<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 > 개인회원 가입/로그인 공용
' 	최초 작성일	: 2021-04-15
'	최초 작성자	: 이샛별
'   input		: dbo.개인회원정보, dbo.T_MEMBER_JOIN_LOG, dbo.T_SNS_LOGIN_USER_INFO, joblog.dbo.개인회원가입_유도페이지
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->
<%
Dim f_snsID		: f_snsID		= Request("sns_id")			' SNS 아이디
Dim f_snsName	: f_snsName		= Request("sns_nickname")	' SNS 가입명
Dim f_snsEmail	: f_snsEmail	= Request("sns_email")		' SNS 가입 이메일
Dim f_sns_gubun	: f_sns_gubun	= Request("sns_gubun")		' 가입사이트구분코드(C0063) > 31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
Dim f_siteGubun	: f_siteGubun	= Request("sitegubun")		' 사이트 구분(W: 커리어웹, M: 커리어모바일웹, K: 중견강소히든챔피언웹...)
Dim f_redir_log : f_redir_log	= Request("redir")			' 직전 페이지 정보(유입 경로 체크용)
Dim f_snsID_Full: f_snsID_Full	= Request("sns_id_full")	' SNS 아이디 전문(구글, 페이스북만 해당)


' 전달 값이 없으면 사이트 가입 경로 웹으로 기본 설정
If f_siteGubun  = "" Then
	f_siteGubun = "W"
End If

' 구글, 페이스북 로그인일 경우 내부 가공한 아이디와 업체 측 전달 전문 아이디 별도 저장 및 연관 DB 정보 일괄 변경
'(기존 데이터타입 길이 값 이슈로 리턴된 전문 아이디 중 일부만 잘라서 아이디로 사용함에 따른 중복 아이디 생성 가능성 해소용)
If f_sns_gubun="33" OR f_sns_gubun="34" Then
	ConnectDB DBCon, Application("DBInfo")

	Dim SpNameCHK, paramCHK(3)
	SpNameCHK = "SPU_SNS_ID_LOGIN_HIS_INSERT"
		paramCHK(0) = makeParam("@IN_V_SNS_GUBUN_CD", adChar, adParamInput, 2, f_sns_gubun)
		paramCHK(1) = makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 20, f_snsID)
		paramCHK(2) = makeParam("@IN_V_SNS_FULL_ID", adVarChar, adParamInput, 50, f_snsID_Full)
		paramCHK(3)	= makeParam("@OUT_I_RTN", adInteger, adParamOutput, 4, "")

		Call execSP(DBCon, SpNameCHK, paramCHK, "", "")

		sp_rtn_snsIdModi = getParamOutputValue(paramCHK, "@OUT_I_RTN")	' 처리 결과 리턴 값(1: 아이디 일괄 업데이트 처리 완료, 0: 업데이트 대상 아님)

	DisconnectDB DBCon
End If


' 구글, 페이스북 로그인일 경우 소셜 아이디 가공 → 전문 으로 연관 DB 정보 일괄 변경에 따른 아이디 값 대체
Dim v_snsID : v_snsID = ""
If Len(f_snsID_Full)>0 Then
	v_snsID = f_snsID_Full
Else
	v_snsID = f_snsID
End If

'1) SNS로 연동된 회원 아이디 등록 여부 체크
ConnectDB DBCon, Application("DBInfo")

Dim SpName, param(1)
SpName="SPU_ID_CHECK_ALL_ONLY_SNS"
	param(0) = makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, v_snsID)
	param(1) = makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, param, "", "")

	sp_rtn_chk = getParamOutputValue(param, "@OUT_V_RTN")	' 조회 결과 리턴 값(S: 성공, F: 실패)

DisconnectDB DBCon

Dim v_rtn_join : v_rtn_join = ""
If sp_rtn_chk = "F" Then ' 기존 가입 내역이 존재할 경우 회원정보 저장 스킵
	v_rtn_join="S"
	
	' 쿠키 세팅용 정보 추출
	ConnectDB DBCon, Application("DBInfo")
		strQuery = "SPC_USER_INFO_SELECT '"& v_snsID &"'"
		rowRs = arrGetRsSql(DBCon, strQuery, "", "")
		If IsArray(rowRs) Then
			rs_memName		= Trim(rowRs(0,0))	' 회원명
			rs_memPhone		= Trim(rowRs(1,0))	' 휴대폰
			rs_memEmail		= Trim(rowRs(2,0))	' 이메일
			rs_Photo		= Trim(rowRs(11,0))	' 이력서 증명사진
			rs_resumeCnt	= Trim(rowRs(19,0))	' 이력서 수(저장 완료 상태)
		End If
	DisconnectDB DBCon	
Else
	'2) 휴면 상태로 분류되었는지 체크
	ConnectDB DBCon, Application("DBInfo")

		Dim SpName2, param2(1)
		SpName2="SPU_INACTIVE_LOGIN_CHECK"
			param2(0) = makeParam("@UserID", adVarChar, adParamInput, 50, v_snsID)
			param2(1) = makeParam("@Rtn", adInteger, adParamOutput, 1, "")

			Call execSP(DBCon, SpName2, param2, "", "")

			sp_rtn_chk_inact = getParamOutputValue(param2,"@Rtn")	' 조회 결과 리턴 값(0: 휴면, 1: 활성)

	DisconnectDB DBCon

	If sp_rtn_chk_inact="0" Then
		'Call FN_alertLink("현재 회원님은 휴면 상태로,\n정상적인 커리어 서비스 이용을 위해서는 휴면 해제가 필요합니다.\n고객센터(☎1577-9577)로 문의 바랍니다.","/")
		Response.Write "<script>"
		Response.Write "alert('현재 회원님은 휴면 상태로,\n정상적인 커리어넷 서비스 이용을 위해서는 휴면 해제가 필요합니다.\n휴면 해제 페이지로 이동합니다.');"
		Response.Write "</script>"
		Response.Write "<form method=post name='frm_Inactive' action='/signup/Inactive_Member.asp'>"
		Response.Write "<input type=hidden id='hidUserId' name='hidUserId' value='" + v_snsID + "'>"
		Response.Write "</form>"
		Response.Write "<script language='JavaScript'>document.forms[0].submit();</script>"
		Response.End 
	Else 

		'3) SNS 간편 로그인 회원 가입 처리&이력 저장
		ConnectDB DBCon, Application("DBInfo")

		Dim SpName3, param3(8)
		SpName3="SPU_JOIN_USER_SNS_INSERT"
			param3(0) = makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, v_snsID)
			param3(1) = makeParam("@IN_V_USER_NM", adVarChar, adParamInput, 30, f_snsName)
			param3(2) = makeParam("@IN_V_USER_EMAIL", adVarChar, adParamInput, 100, f_snsEmail)
			param3(3) = makeParam("@IN_V_SITE_GUBUN", adChar, adParamInput, 2, f_siteGubun)
			param3(4) = makeParam("@IN_V_SNS_GUBUN_CD", adChar, adParamInput, 2, f_sns_gubun)
			param3(5) = makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
			param3(6) = makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
			param3(7) = makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)
			param3(8) = makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

			Call execSP(DBCon, SpName3, param3, "", "")

			sp_rtn_join = getParamOutputValue(param3, "@OUT_V_RTN")	' 저장 결과 리턴 값(S: 성공, F: 실패)
			v_rtn_join	= sp_rtn_join
		DisconnectDB DBCon

		If v_rtn_join="S" Then	' 회원 가입 저장 결과 리턴 값(S: 성공, F: 실패)에 따라 처리 제어
			'4) 관리자 통계 자료용 이력 저장
			ConnectDB DBCon2, Application("DBInfoJobLog")

				Dim SpName4, param4(3)
				SpName4 = "USP_개인회원가입_유도페이지_저장"
					param4(0) = makeParam("@개인아이디", adVarChar, adParamInput, 50, v_snsID)
					param4(1) = makeParam("@어드레스", adVarChar, adParamInput, 20, site_IPAddr)
					param4(2) = makeParam("@가입경로URL", adVarChar, adParamInput, 2000, f_redir_log)
					param4(3) = makeParam("@siteflag", adVarChar, adParamInput, 2, f_siteGubun)

					Call execSP(DBCon2, SpName4, param4, "", "")

			DisconnectDB DBCon2
		End If 

	End If
End If

If v_rtn_join="F" Then
	Call FN_alertLink("SNS 간편 로그인 중 오류가 발생했습니다.\n다시 시도해 주세요.","/")
Else 
	'5) 접속 이력 저장
	ConnectDB DBCon, Application("DBInfo")
		Dim SpName5, param5(5)
		SpName5 = "SPU_CONNECT_LOG_INSERT"
			param5(0) = makeParam("@IN_V_USER_TYPE", adVarChar, adParamInput, 10, "mem")
			param5(1) = makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, v_snsID)
			param5(2) = makeParam("@IN_V_LOG_TYPE", adChar, adParamInput, 3, "in")
			param5(3) = makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
			param5(4) = makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
			param5(5) = makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)

			Call execSP(DBCon, SpName5, param5, "", "")
	DisconnectDB DBCon
		
	' 개인회원정보에 저장된 데이터가 있다면 해당 정보로 로그인 쿠키 생성
	If Len(rs_memName)>0 Then
		v_setNm   = rs_memName
		v_setMail = rs_memEmail
	Else
		v_setNm   = f_snsName
		v_setMail =	f_snsEmail
	End If

	If Len(v_setNm)=1  Then
		v_setNm = "간편로그인회원"
	Else
		v_setNm = v_setNm
	End If

	'6) 회원 정보 쿠키 할당
	' objEncrypter AES암호화 모듈 위치 : /common/common.asp > /wwwconf_renew/function/auth/getCookie.asp > /wwwconf_renew/function/library/AES256.asp
	' /wwwconf_renew/function/library/AES256.asp : KISA 권고안에 따른 로그인 정보 AES256 방식 암호화 처리
	' 로그인 정보 복호화는 /common/common.asp 상단에 인클루드된 /wwwconf_renew/function/auth/getCookie.asp 에서 처리됨
	Response.Cookies("WKP")("id")			= objEncrypter.Encrypt(v_snsID)
	Response.Cookies("WKP")("name")			= objEncrypter.Encrypt(v_setNm)
	Response.Cookies("WKP")("email")		= objEncrypter.Encrypt(v_setMail)
	Response.Cookies("WKP")("jointype")		= objEncrypter.Encrypt(f_sns_gubun)
	Response.Cookies("WKP")("photo")		= rs_Photo
	Response.Cookies("WKP").Domain			= "career.co.kr"	' 도메인 설정

	Response.Cookies("WKP").Expires			= dateAdd("h", 2, now())	' 로그인 시 접속시점 기준 2시간 이후 쿠키 만료 설정


	' 유입 경로에 따라 리턴 페이지 제어
	If InStr(f_redir_log,"/login/")=0 And InStr(f_redir_log,"/signup/")=0 And InStr(f_redir_log,"/search/")=0 And InStr(f_redir_log,"Login_Check.asp")=0 Then
		v_rtnPage = f_redir_log
	Else
		v_rtnPage = "/"
	End If
End If 


If Len(v_rtnPage)=0 Then
	v_rtnPage = "/"
Else
	v_rtnPage = v_rtnPage
End If 


If rs_resumeCnt=0 Then	' 저장 완료된 이력서가 없으면 이력서 작성 폼으로 이동 처리
	' 직전 경로가 리뉴얼 오픈 이벤트 화면인 경우 해당 페이지 리턴[2021-10-28 edit by star]
	If InStr(f_redir_log,"Renew_Open_Event.asp")=0 Then
		v_rtnPage = v_rtnPage
	Else
		v_rtnPage = "/user/resume/Resume_Regist.asp"
	End If 
Else
	v_rtnPage = v_rtnPage
End If
%>
<html>
<head><meta http-equiv="refresh" content="0; url=<%=v_rtnPage%>"></head>
<body></body>
</html>

