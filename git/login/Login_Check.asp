<%
'--------------------------------------------------------------------
'   회원 로그인 처리
' 	최초 작성일	:
'	최초 작성자	: 
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"--> 
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->
<!--#include virtual = "/wwwconf/function/library/CryptoHelper.asp"-->
<%
f_txtId			= RTrim(LTrim(Replace(Request("txtId"), "'", "''")))		' 아이디
f_txtPass		= RTrim(LTrim(Replace(Request("txtPass"), "'", "''")))		' 비밀번호
f_chkAutoLogin	= Request("chkAutoLogin")	' 자동로그인 체크 구분자
f_hidLogType	= Request("hidLogType")		' 로그인 구분자(1 : 개인, 2: 기업)
f_hidRedir		= Request("redir")			' 직전 페이지 정보(유입 경로 체크용)

' 정상적인 경로로 이동하지 않은 경우 로그인 화면으로 리턴
Dim strLink_Fail : strLink_Fail	= "/login/Login.asp?logType="&f_hidLogType
If Len(f_txtId)=0 Then
	Call FN_alertLink("정상적인 접근 방식이 아닙니다. - 아이디 누락",strLink_Fail)
Else
	If Len(f_txtPass)=0 Then 
		Call FN_alertLink("정상적인 접근 방식이 아닙니다. - 비번 누락",strLink_Fail)
	End If 
End If

' 로그인 구분자에 따라 제어 값 설정
Dim v_LogType_Txt
If f_hidLogType="" Or f_hidLogType="1" Then
	v_LogType_Txt = "mem"
Else 
	v_LogType_Txt = "biz"
End If 


'## 유효성 검증 - 1) 접속 허용 상태 여부 체크
If v_LogType_Txt = "mem" Then ' 개인회원 로그인일 경우 휴면 상태 여부 확인
	ConnectDB DBCon, Application("DBInfo")

		Dim SpName, param(1)
		SpName="SPU_INACTIVE_LOGIN_CHECK"
			param(0)    = makeParam("@UserID", adVarChar, adParamInput, 50, f_txtId)
			param(1)    = makeParam("@Rtn", adInteger, adParamOutput, 1, "")

			Call execSP(DBCon, SpName, param, "", "")

			sp_rtn_chk = getParamOutputValue(param,"@Rtn")	' 조회 결과 리턴 값(0: 휴면, 1: 활성)

	DisconnectDB DBCon

	If sp_rtn_chk="0" Then
		'Call FN_alertLink("현재 회원님은 휴면 상태로,\n정상적인 커리어 서비스 이용을 위해서는 휴면 해제가 필요합니다.\n고객센터(☎1577-9577)로 문의 바랍니다.","/")
		Response.Write "<script>"
		Response.Write "alert('현재 회원님은 휴면 상태로,\n정상적인 커리어넷 서비스 이용을 위해서는 휴면 해제가 필요합니다.\n휴면 해제 페이지로 이동합니다.');"
		Response.Write "</script>"
		Response.Write "<form method=post name='frm_Inactive' action='/signup/Inactive_Member.asp'>"
		Response.Write "<input type=hidden id='hidUserId' name='hidUserId' value='" + LCase(f_txtId) + "'>"
		Response.Write "</form>"
		Response.Write "<script language='JavaScript'>document.forms[0].submit();</script>"
		Response.End
	End If
Else ' 기업회원 로그인일 경우 불량 기업으로 분류되었는지 여부 확인
	ConnectDB DBCon2, Application("DBInfo_REAL")

		strSql =	"SELECT TOP 1 아이디 "&_
					"FROM 회사그룹관리 WITH(NOLOCK) "&_
					"WHERE 아이디='"& f_txtId &"' AND 구분1='Z'"
		rowRs = arrGetRsSql(DBCon2, strSql, "", "")

	DisconnectDB DBCon2
	If IsArray(rowRs) Then
		Call FN_alertLink("커리어 로그인이 제한된 아이디 입니다.\n고객센터(☎1577-9577)로 문의 바랍니다.","/")
	End If
End If


'## 유효성 검증 - 2) 불량회원 분류 여부 체크(개인/기업 공통 관리 대상 테이블)
ConnectDB DBCon2, Application("DBInfo_REAL")

	strSql2 =	"SELECT TOP 1 개인아이디 "&_
				"FROM 불량아이디 WITH(NOLOCK) "&_
				"WHERE 개인아이디='"& f_txtId &"'"
	rowRs2 = arrGetRsSql(DBCon2, strSql2, "", "")

DisconnectDB DBCon2
If IsArray(rowRs2) Then
	Call FN_alertLink("커리어 로그인이 제한된 아이디 입니다.\n고객센터(☎1577-9577)로 문의 바랍니다.","/")
End If


'## 유효성 검증 - 3) 계정 정보 존재 여부 체크
ConnectDB DBCon, Application("DBInfo")

	Dim spName2, param2(1)
	spName2 = "SPU_MEMBER_JOIN_CHECK"
		param2(0)	= makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
		param2(1)	= makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

		ArrRs		= arrGetRsSP(DBCon, spName2, param2, "", "")
		sp_rtn_cd	= getParamOutputValue(param2, "@OUT_V_RTN")	' 조회 결과 리턴 값(S: 성공, F: 실패)

DisconnectDB DBCon

If sp_rtn_cd="F" Then 
	Call FN_alertLink("입력하신 아이디가 존재하지 않습니다.\r아이디를 다시 확인해 주세요.",strLink_Fail)
Else 
	If IsArray(ArrRs) Then
		rs_LogType	= Trim(ArrRs(0,0))	' 접속 구분자(mem: 개인, biz: 기업)
		rs_Name		= Trim(ArrRs(1,0))	' 접속자명(회원명, 기업명)
		rs_Pw		= Trim(ArrRs(2,0))	' 암호화 비번
		rs_StatCd	= Trim(ArrRs(3,0))	' 유형코드
		'>> 개인 - 가입사이트구분코드(2: 일반, 31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북), 기업 - 기업형태(5: 일반, 8: 서치펌, 9: 파견)
		rs_Photo	= Trim(ArrRs(4,0))	' 이미지(이력서 증명사진, 기업 로고)

		If v_LogType_Txt<>rs_LogType Then
			If rs_LogType="mem" Then
				strChkMsg = "개인"
			Else
				strChkMsg = "기업"
			End If
			Call FN_alertLink(strChkMsg&"회원으로 가입된 아이디 입니다.\n접속 구분을 다시 확인해 주세요.",strLink_Fail)
		End If 
	Else 
		Call FN_alertLink("입력하신 아이디가 존재하지 않습니다.\n아이디를 다시 확인해 주세요.",strLink_Fail)
	End If 
End If 


'## 유효성 검증 - 4) 비번 체크
Dim v_Pw_SHA256, v_Pw_MD5, v_nowPwTrans

' 전달된 비번 암호화
v_Pw_SHA256	= SHA256_Encrypt(f_txtPass)	' > /wwwconf_renew/function/library/KISA_SHA256.asp
v_Pw_MD5	= getMD5(f_txtPass)			' > /wwwconf_renew/function/library/CryptoHelper.asp

' 암호화 방식 체크 후 비교군 설정
If Len(rs_Pw) = 64 Then
	v_nowPwTrans = v_Pw_SHA256
Else
	v_nowPwTrans = v_Pw_MD5
End If

' 입력 비번과 DB 저장 비번 정보 비교, 불일치 시 리턴
If CStr(v_nowPwTrans) <> CStr(rs_Pw) Then
	Call FN_alertLink("비밀번호로 입력하신 정보가 일치하지 않습니다.\n비밀번호를 다시 확인해 주세요.",strLink_Fail)
Else '## 유효성 검증 - 5) 통과 시
	' 암호화 방식이 MD5 로 저장된 경우 SHA256 으로 변경 및 전환 이력 저장
	If Len(rs_Pw) <> 64 Then
		ConnectDB DBCon, Application("DBInfo")
			SpName3="SPC_MEMBER_PW_UPDATE"
				Dim param3(9)
				param3(0)=makeParam("@IN_V_EDIT_TYPE", adVarChar, adParamInput, 20, "pw_sha")
				param3(1)=makeParam("@IN_V_USER_TYPE", adVarChar, adParamInput, 10, rs_LogType)
				param3(2)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
				param3(3)=makeParam("@IN_V_USER_PW", adVarChar, adParamInput, 80, v_Pw_SHA256)
				param3(4)=makeParam("@IN_V_MOD_GUBUN", adVarChar, adParamInput, 10, "user")
				param3(5)=makeParam("@IN_V_MOD_ID", adVarChar, adParamInput, 50, f_txtId)
				param3(6)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
				param3(7)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)
				param3(8)=makeParam("@IN_V_MEMO", adVarChar, adParamInput, 1000, "")
				param3(9)=makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

				Call execSP(DBCon, SpName3, param3, "", "")
		DisconnectDB DBCon
	End If

	' 접속 이력 저장
	ConnectDB DBCon, Application("DBInfo")
		SpName4="SPU_CONNECT_LOG_INSERT"
			Dim param4(5)
			param4(0)=makeParam("@IN_V_USER_TYPE", adVarChar, adParamInput, 10, rs_LogType)
			param4(1)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
			param4(2)=makeParam("@IN_V_LOG_TYPE", adChar, adParamInput, 3, "in")
			param4(3)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
			param4(4)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
			param4(5)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)

			Call execSP(DBCon, SpName4, param4, "", "")
	DisconnectDB DBCon
End If

	'회원 정보 쿠키 할당
	' objEncrypter AES암호화 모듈 위치 : /common/common.asp > /wwwconf_renew/function/auth/getCookie.asp > /wwwconf_renew/function/library/AES256.asp
	' /wwwconf_renew/function/library/AES256.asp : KISA 권고안에 따른 로그인 정보 AES256 방식 암호화 처리
	' 로그인 정보 복호화는 /common/common.asp 상단에 인클루드된 /wwwconf_renew/function/auth/getCookie.asp 에서 처리됨
	If rs_LogType="mem" Then
		v_set_Ck	= "WKP"
		v_set_Cko	= "jointype"
		v_set_Cko2	= "photo"
		v_LoginChk	= "1"
	Else 
		v_set_Ck	= "WKC"
		v_set_Cko	= "kind"
		v_set_Cko2	= "logo"
		v_LoginChk	= "2"
	End If

	Response.Cookies(v_set_Ck)("id")			= objEncrypter.Encrypt(LCase(f_txtId))
	Response.Cookies(v_set_Ck)("name")			= objEncrypter.Encrypt(rs_Name)
	Response.Cookies(v_set_Ck)(v_set_Cko)		= objEncrypter.Encrypt(rs_StatCd)
	Response.Cookies(v_set_Ck)(v_set_Cko2)		= rs_Photo
	Response.Cookies(v_set_Ck).Domain			= "career.co.kr"	' 도메인 설정
	g_LoginChk	= v_LoginChk

	If f_chkAutoLogin="Y" Then ' 자동로그인 체크 시
		Response.Cookies(v_set_Ck).Expires	= Date + 365 * 10
	Else
		Response.Cookies(v_set_Ck).Expires	= dateAdd("h", 2, now())	' 자동 로그인 미체크 시 접속시점 기준 2시간 이후 쿠키 만료 설정
	End If

	' 유입 경로에 따라 리턴 페이지 제어
	If Len(f_hidRedir)>0 Then
		If InStr(f_hidRedir,"/login/")=0 And InStr(f_hidRedir,"/signup/")=0 And InStr(f_hidRedir,"/search/")=0 And InStr(f_hidRedir,"Login_Check.asp")=0 And InStr(f_hidRedir,"Member_Pw_Modify.asp")=0 And InStr(f_hidRedir,"Biz_Pw_Modify.asp")=0 Then
			If rs_LogType="mem" Then
				If InStr(f_hidRedir,"/company/")=0 And InStr(f_hidRedir,"/biz/")=0 Then
					If f_hidRedir = g_members_wk Then	' 입사지원 팝업에서 유입된 경우 부모 창 URL(document.referrer;)을 redir에 전달해야 직전 페이지로 이동 처리 가능
						strLink = "/"
					Else
						strLink = f_hidRedir
					End If
				Else
					strLink = "/"
				End If
			Else
				If InStr(f_hidRedir,"/user/")=0 And InStr(f_hidRedir,"/my/")=0 Then
					If f_hidRedir = g_members_wk Then	' g_members_wk → /wwwconf_renew/function/common/svrlink.asp 에서 설정
						strLink = "/"
					Else
						strLink = f_hidRedir
					End If
				Else
					strLink = "/"
				End If
			End If
		Else
			strLink = "/"
		End If
	Else
		strLink = "/"
	End If
%>
<html>
<head><meta http-equiv="refresh" content="0; url=<%=strLink%>"></head>
<body></body>
</html>

<%' 휴면해제 페이지 이동 %>
<form method="post" id="frm_Inactive" name="frm_Inactive">
	<input type="hidden" id="hidUserId" name="hidUserId" value="<%=f_txtId%>" />
</form>