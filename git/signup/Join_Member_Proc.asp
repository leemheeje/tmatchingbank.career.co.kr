<%
'--------------------------------------------------------------------
'   회원가입 > 개인회원
' 	최초 작성일	: 2021-04-13
'	최초 작성자	: 이샛별
'   input		: dbo.개인회원정보, dbo.T_MEMBER_JOIN_LOG
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->
<%
f_txtId			= Replace(Request("txtId"), "'", "''")		' 아이디
f_txtPass		= Replace(Request("txtPass"), "'", "''")	' 비밀번호	
f_txtBirth		= Replace(Request("txtBirth"), ",", "")		' 생년월일
f_txtName		= RTrim(LTrim(Replace(Replace(Request("txtName"), "'", "''"), " ", "")))' 이름
f_txtMnFullVer	= RTrim(LTrim(LCase(Replace(Request("txtMnFullVer"), " ", ""))))		' 이메일
f_chkAgrMail	= Request("chkAgrMail")	' 홍보성 메일 수신 동의
f_txtPhone		= Request("txtPhone")	' 휴대폰번호
f_chkAgrSms		= Request("chkAgrSms")	' 홍보성 문자 수신 동의


' 정상적인 경로로 이동하지 않은 경우 회원가입 화면으로 리턴
Dim strLink_Fail : strLink_Fail = "/signup/Join_Member.asp"
If Trim(f_txtId) = "" Or Trim(f_txtPass) = "" Then
	Call FN_alertLink("정상적인 접근 방식이 아닙니다.",strLink_Fail)
End If


' 전달된 비번 암호화
v_Pw_SHA256	= SHA256_Encrypt(f_txtPass)	' > /wwwconf/function/library/KISA_SHA256.asp

' 연락처에 하이픈 누락된 경우 강제 설정
If Len(f_txtPhone)>0 Then 
	If InStr(f_txtPhone,"-")=0 Then 
		len_txtPhone	= Len(f_txtPhone)
		v_Phone			= Left(f_txtPhone,3)&"-"&Mid(f_txtPhone,4,len_txtPhone-7)&"-"&Right(f_txtPhone,4)
	Else 
		v_Phone			= f_txtPhone
	End If 
Else 
	v_Phone = ""
End If 

' 홍보성 메일/문자 수신 체크 여부에 따라 값 할당
If Len(f_chkAgrMail)=0 Then 
	v_chkAgrMail = "N"
Else 
	v_chkAgrMail = "Y"
End If 

If Len(f_chkAgrSms)=0 Then 
	v_chkAgrSms = "0"
Else 
	v_chkAgrSms = "1"
End If 


ConnectDB DBCon, Application("DBInfo")

'1) 입력 아이디 중복 체크
SpName="SPU_ID_CHECK_ALL"
	Dim param(1)
	param(0)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
	param(1)=makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, param, "", "")

	sp_rtn_chk = getParamOutputValue(param, "@OUT_V_RTN")	' 조회 결과 리턴 값(S: 성공, F: 실패)	

DisconnectDB DBCon


If sp_rtn_chk = "S" Then ' 입력한 아이디로 기존 가입된 정보가 없으면 회원 가입

ConnectDB DBCon, Application("DBInfo")

'2) 개인회원 가입 처리&이력 저장
SpName2="SPU_JOIN_USER_INSERT"
	Dim param2(11)
	param2(0)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)	
	param2(1)=makeParam("@IN_V_USER_PASS", adVarChar, adParamInput, 100, v_Pw_SHA256)		
	param2(2)=makeParam("@IN_V_USER_NM", adVarChar, adParamInput, 30, f_txtName)	
	param2(3)=makeParam("@IN_V_USER_BIRTH", adChar, adParamInput, 10, f_txtBirth)
	param2(4)=makeParam("@IN_V_USER_EMAIL", adVarChar, adParamInput, 100, f_txtMnFullVer)
	param2(5)=makeParam("@IN_V_USER_PHONE", adVarChar, adParamInput, 20, v_Phone)
	param2(6)=makeParam("@IN_V_USER_MAIL_YN", adChar, adParamInput, 1, v_chkAgrMail)
	param2(7)=makeParam("@IN_V_USER_SMS_YN", adChar, adParamInput, 1, v_chkAgrSms)
	param2(8)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")	
	param2(9)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
	param2(10)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)
	param2(11)=makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName2, param2, "", "")

	sp_rtn_join = getParamOutputValue(param2, "@OUT_V_RTN")	' 저장 결과 리턴 값(S: 성공, F: 실패)

DisconnectDB DBCon

	' 저장 결과 리턴 값(S: 성공, F: 실패)에 따라 처리 제어
	If sp_rtn_join = "S" Then
	
		'3) 관리자 통계 자료용 이력 저장
		ConnectDB DBCon2, Application("DBInfoJobLog")
			Dim SpName3, param3(3)
			SpName3 = "USP_개인회원가입_유도페이지_저장"
				param3(0)    = makeParam("@개인아이디", adVarChar, adParamInput, 50, f_txtId)
				param3(1)    = makeParam("@어드레스", adVarChar, adParamInput, 20, site_IPAddr)
				param3(2)    = makeParam("@가입경로URL", adVarChar, adParamInput, 2000, site_Referer)
				param3(3)    = makeParam("@siteflag", adVarChar, adParamInput, 2, "W")

				Call execSP(DBCon2, SpName3, param3, "", "")
		DisconnectDB DBCon2

'		ConnectDB DBCon3, Application("DBInfo_REAL")
'			Dim SpName4, param4(1)
'			SpName4="개인회원로그입력_career"
'				param4(0)    = makeParam("@uid", adVarChar, adParamInput, 20, f_txtId)
'				param4(1)    = makeParam("@uip", adVarChar, adParamInput, 20, site_IPAddr)

'				Call execSP(DBCon3, SpName4, param4, "", "")
'		DisconnectDB DBCon3

		'4) 접속 이력 저장
		ConnectDB DBCon, Application("DBInfo")
			SpName5="SPU_CONNECT_LOG_INSERT"
				Dim param5(5)
				param5(0)=makeParam("@IN_V_USER_TYPE", adVarChar, adParamInput, 10, "mem")
				param5(1)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
				param5(2)=makeParam("@IN_V_LOG_TYPE", adChar, adParamInput, 3, "in")
				param5(3)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
				param5(4)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
				param5(5)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)

				Call execSP(DBCon, SpName5, param5, "", "")
		DisconnectDB DBCon

		'5) 회원 정보 쿠키 할당
		' objEncrypter AES암호화 모듈 위치 : /common/common.asp > /wwwconf_renew/function/auth/getCookie.asp > /wwwconf_renew/function/library/AES256.asp
		' /wwwconf_renew/function/library/AES256.asp : KISA 권고안에 따른 로그인 정보 AES256 방식 암호화 처리
		' 로그인 정보 복호화는 /common/common.asp 상단에 인클루드된 /wwwconf_renew/function/auth/getCookie.asp 에서 처리됨
		Response.Cookies("WKP")("id")			= objEncrypter.Encrypt(f_txtId)
		Response.Cookies("WKP")("name")			= objEncrypter.Encrypt(f_txtName)
		Response.Cookies("WKP")("email")		= objEncrypter.Encrypt(f_txtMnFullVer)
		Response.Cookies("WKP")("cellphone")	= objEncrypter.Encrypt(v_Phone)
		Response.Cookies("WKP")("jointype")		= objEncrypter.Encrypt("2")
		Response.Cookies("WKP").Domain			= "career.co.kr"	' 도메인 설정

		Dim strLink_Sucs : strLink_Sucs = "/user/resume/Resume_Regist.asp" '"/"	
		Call FN_alertLink("회원가입이 완료되었습니다.\n취업의 첫걸음, 이력서를 작성해 주세요.",strLink_Sucs)
	Else 
		Call FN_alertLink("회원가입 중 오류가 발생했습니다.\n다시 시도해 주세요.",strLink_Fail)
	End If 
Else 
	Call FN_alertLink("입력하신 아이디로 가입된 정보가 존재합니다.\n다른 아이디로 다시 시도해 주세요.",strLink_Fail)
End If 
%>