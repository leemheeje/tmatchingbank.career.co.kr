<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 > 휴면 해제
' 	History		: 2021-08-11, 이샛별
'   DB TABLE	: 
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/KISA_SHA256.asp"-->
<!--#include virtual = "/wwwconf/function/library/CryptoHelper.asp"-->
<%
Dim f_txtId		: f_txtId		= unescape(Request("txtId"))	' 회원아이디
Dim f_txtName	: f_txtName		= unescape(Request("txtName"))	' 회원명
Dim f_authType	: f_authType	= Request("authType")			' 인증 수단(1: sms, 2: email)
Dim f_authValue	: f_authValue	= Request("authValue")			' 인증 정보(휴대폰/이메일)
Dim f_txtPass	: f_txtPass		= RTrim(LTrim(Replace(Request("txtPass"), "'", "''")))	' 신규 비밀번호

' 전달된 비번 암호화
v_newPw_SHA256	= SHA256_Encrypt(f_txtPass)	' > /wwwconf_renew/function/library/KISA_SHA256.asp

' 인증 수단에 따라 가입 여부 체크 항목 값 설정
If Len(f_authType)=0 Then
	v_chkRsltCd = "X"	' 필수정보 미전달 시 변경 불가 리턴
End If 

If Len(f_txtId)=0 And Len(f_txtName)=0 Then
	v_chkRsltCd = "X"	' 필수정보 미전달 시 변경 불가 리턴
Else 
	ConnectDB DBCon, Application("DBInfo")
	
		' 1) 가입 여부 체크
		Dim rowRs
		ReDim param(1)
		param(0)	= makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
		param(1)	= makeParam("@IN_V_USER_NAME", adVarChar, adParamInput, 30, f_txtName)
		rowRs		= arrGetRsSP(DBCon, "SPC_INACTIVE_USER_INFO_SELECT", param, "", "")
		If IsArray(rowRs) Then
			cntJoin = "S"
			rs_memName		= Trim(rowRs(0,0))	' 회원명
			rs_memPhone		= Trim(rowRs(1,0))	' 휴대폰
			rs_memEmail		= Trim(rowRs(2,0))	' 이메일
			rs_memJoinType	= Trim(rowRs(3,0))	' 가입사이트구분코드(2: 일반, 31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북)
			rs_memPw		= Trim(rowRs(4,0))	' 암호화비번
			rs_Photo		= Trim(rowRs(5,0))	' 이력서 증명사진
		Else
			cntJoin = "F"
		End If
		
		If cntJoin = "S" Then

			If rs_memJoinType="2" Then
				v_memPw	= v_newPw_SHA256
			Else
				v_memPw = ""
			End If

			' 2) 유효성 검증 통과 시 휴면해제 및 비번 정보 변경&이력 저장 > 고객센터를 통한 변경 요청 시에도 활용(관리자단 공용)
			Dim SpName
			ReDim param(8)
			SpName="SPC_INACTIVE_USER_INFO_RELEASE"
			param(0)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
			param(1)=makeParam("@IN_V_USER_PW", adVarChar, adParamInput, 100, v_memPw)
			param(2)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
			param(3)=makeParam("@IN_V_MOD_GUBUN", adVarChar, adParamInput, 10, "user")
			param(4)=makeParam("@IN_V_MOD_ID", adVarChar, adParamInput, 50, f_txtId)
			param(5)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
			param(6)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)
			param(7)=makeParam("@IN_V_MEMO", adVarChar, adParamInput, 1000, "휴면해제-사용자")
			param(8)=makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

			Call execSP(DBCon, SpName, param, "", "")

			sp_rtn = getParamOutputValue(param, "@OUT_V_RTN")

			If sp_rtn = "S" Then
				' 회원 정보 쿠키 할당
				' objEncrypter AES암호화 모듈 위치 : /common/common.asp > /wwwconf_renew/function/auth/getCookie.asp > /wwwconf_renew/function/library/AES256.asp
				' /wwwconf_renew/function/library/AES256.asp : KISA 권고안에 따른 로그인 정보 AES256 방식 암호화 처리
				' 로그인 정보 복호화는 /common/common.asp 상단에 인클루드된 /wwwconf_renew/function/auth/getCookie.asp 에서 처리됨
				Response.Cookies("WKP")("id")			= objEncrypter.Encrypt(f_txtId)
				Response.Cookies("WKP")("name")			= objEncrypter.Encrypt(rs_memName)
				Response.Cookies("WKP")("email")		= objEncrypter.Encrypt(rs_memEmail)
				Response.Cookies("WKP")("jointype")		= objEncrypter.Encrypt(rs_memJoinType)
				Response.Cookies("WKP")("photo")		= rs_Photo
				Response.Cookies("WKP").Domain			= "career.co.kr"	' 도메인 설정

				Response.Cookies("WKP").Expires			= dateAdd("h", 2, now())	' 로그인 시 접속시점 기준 2시간 이후 쿠키 만료 설정
			End If

			v_chkRsltCd = sp_rtn
		Else 
			v_chkRsltCd = "F"	' 가입정보 없을 경우 변경 불가 리턴
		End If

	DisconnectDB DBCon
End If

Response.write v_chkRsltCd
%>