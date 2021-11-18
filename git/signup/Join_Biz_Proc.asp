<%
'--------------------------------------------------------------------
'   회원가입 > 기업회원
' 	최초 작성일	: 2021-04-21
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
f_txtBizNum			= RTrim(LTrim(Replace(Request("txtBizNum"), "-", "")))	' 사업자등록번호
f_txtBizName		= RTrim(LTrim(Replace(Replace(Request("txtBizName"), "'", "''"), " ", "")))	' 기업명
f_txtCeoName		= RTrim(LTrim(Replace(Replace(Request("txtCeoName"), "'", "''"), " ", "")))	' 대표자명
f_txtId				= Replace(Request("txtId"), "'", "''")			' 아이디
f_txtPass			= Replace(Request("txtPass"), "'", "''")		' 비밀번호
f_txtZipCode		= Request("txtZipCode")							' 우편번호
f_selBizScale		= Request("selBizScale")						' 기업형태 선택박스
f_txtBizAddr		= Replace(Request("txtBizAddr"), "'", "''")		' 주소
f_txtBizAddrDtl		= Replace(Request("txtBizAddrDtl"), "'", "''")	' 주소상세
f_txtName			= RTrim(LTrim(Replace(Replace(Request("txtName"), "'", "''"), " ", "")))	' 채용담당자명
f_txtMnFullVer		= RTrim(LTrim(LCase(Replace(Request("txtMnFullVer"), " ", ""))))			' 채용담당자 이메일

f_rdoBizType		= Request("rdoBizType")	' 기업형태(5: 일반, 8: 서치펌, 9: 파견)
f_txtTel			= Request("txtTel")		' 채용담당자 연락처
f_txtPhone			= Request("txtPhone")	' 채용담당자 휴대폰번호
f_chkAgrSms			= Request("chkAgrSms")	' 홍보성 문자 수신 동의
f_chkAgrMail		= Request("chkAgrMail")	' 홍보성 메일 수신 동의

f_hidIpoCd			= Request("hidIpoCd")	' 상장구분코드(1:상장(코스피), 2:코스닥, 3:코넥스, 4:K-OTC(제3시장), 9:기타)
f_hidCreateDt		= Replace(Request("hidCreateDt"), "-", "")	' 설립일자
f_hidBizHomePage	= RTrim(LTrim(LCase(Replace(Request("hidBizHomePage"), " ", ""))))	' 홈페이지URL
f_hidBizProduct		= Request("hidBizProduct")	' 주요상품내역
f_hidBizTel			= Request("hidBizTel")		' 대표번호

f_bizNumAuthType	= Request("bizNumAuthType")	' 기업정보 API 인증 구분자(N: 나신평 인증, D: 국세청 인증)

v_AddrInfo			= f_txtBizAddr&" "&f_txtBizAddrDtl	' 주소 조합


' 정상적인 경로로 이동하지 않은 경우 회원가입 화면으로 리턴
Dim strLink_Fail : strLink_Fail = "/signup/Join_Biz.asp"
If Trim(f_txtId) = "" Or Trim(f_txtPass) = "" Then
	Call FN_alertLink("정상적인 접근 방식이 아닙니다.",strLink_Fail)
End If


' 전달된 비번 암호화
v_Pw_SHA256	= SHA256_Encrypt(f_txtPass)	' > /wwwconf/function/library/KISA_SHA256.asp

' 연락처에 하이픈 누락된 경우 강제 설정
If Len(f_txtPhone)>0 Then 
	If InStr(f_txtPhone,"-")=0 Then 
		len_txtPhone = Len(f_txtPhone)
		If len_txtPhone>8 Then 
			v_Phone = Left(f_txtPhone,3)&"-"&Mid(f_txtPhone,4,len_txtPhone-7)&"-"&Right(f_txtPhone,4)
		Else 
			v_Phone = f_txtPhone
		End If 
	Else 
		v_Phone = f_txtPhone
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
	v_chkAgrSms = "N"
Else 
	v_chkAgrSms = "Y"
End If 

' 기업 형태 구분자에 따라 저장 값 제어
If f_rdoBizType<>"5" Then
	v_BizScale = f_rdoBizType
Else
	v_BizScale = f_selBizScale
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

'2) 기업회원 가입 처리&이력 저장
SpName2="SPU_JOIN_BIZ_INSERT_V2"
	Dim param2(23)
	param2(0)=makeParam("@IN_V_BIZ_ID", adVarChar, adParamInput, 20, f_txtId)
	param2(1)=makeParam("@IN_V_BIZ_PASS", adVarChar, adParamInput, 100, v_Pw_SHA256)
	param2(2)=makeParam("@IN_V_BIZ_NUM", adChar, adParamInput, 10, f_txtBizNum)
	param2(3)=makeParam("@IN_V_BIZ_NAME", adVarChar, adParamInput, 100, f_txtBizName)
	param2(4)=makeParam("@IN_V_CEO_NAME", adVarChar, adParamInput, 100, f_txtCeoName)
	param2(5)=makeParam("@IN_V_BIZ_SCALE", adVarChar, adParamInput, 2, v_BizScale)
	param2(6)=makeParam("@IN_V_BIZ_ZIPCODE", adChar, adParamInput, 6, f_txtZipCode)
	param2(7)=makeParam("@IN_V_BIZ_ADDR", adVarChar, adParamInput, 200, v_AddrInfo)
	param2(8)=makeParam("@IN_V_MNG_TEL", adVarChar, adParamInput, 20, f_txtTel)
	param2(9)=makeParam("@IN_V_MNG_NAME", adVarChar, adParamInput, 30, f_txtName)
	param2(10)=makeParam("@IN_V_MNG_EMAIL", adVarChar, adParamInput, 100, f_txtMnFullVer)
	param2(11)=makeParam("@IN_V_MNG_PHONE", adVarChar, adParamInput, 20, v_Phone)
	param2(12)=makeParam("@IN_V_IPO_CD", adVarChar, adParamInput, 1, f_hidIpoCd)
	param2(13)=makeParam("@IN_V_FOUND_DATE", adVarChar, adParamInput, 8, f_hidCreateDt)
	param2(14)=makeParam("@IN_V_HOMEPAGE", adVarChar, adParamInput, 200, f_hidBizHomePage)
	param2(15)=makeParam("@IN_V_BIZ_CONTENT", adVarChar, adParamInput, 500, f_hidBizProduct)
	param2(16)=makeParam("@IN_V_BIZ_TEL", adVarChar, adParamInput, 30, f_hidBizTel)
	param2(17)=makeParam("@IN_V_MAIL_YN", adChar, adParamInput, 1, v_chkAgrMail)
	param2(18)=makeParam("@IN_V_SMS_YN", adChar, adParamInput, 1, v_chkAgrSms)
	param2(19)=makeParam("@IN_V_BIZ_NUM_AUTHTYPE", adChar, adParamInput, 1, f_bizNumAuthType)
	param2(20)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
	param2(21)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
	param2(22)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)
	param2(23)=makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName2, param2, "", "")

	sp_rtn_join = getParamOutputValue(param2, "@OUT_V_RTN")	' 저장 결과 리턴 값(S: 성공, F: 실패)

DisconnectDB DBCon

	' 저장 결과 리턴 값(S: 성공, F: 실패)에 따라 처리 제어
	If sp_rtn_join = "S" Then
		'3) 접속 이력 저장
		ConnectDB DBCon, Application("DBInfo")
			SpName3="SPU_CONNECT_LOG_INSERT"
				Dim param3(5)
				param3(0)=makeParam("@IN_V_USER_TYPE", adVarChar, adParamInput, 10, "biz")
				param3(1)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
				param3(2)=makeParam("@IN_V_LOG_TYPE", adChar, adParamInput, 3, "in")
				param3(3)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, "pc")
				param3(4)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
				param3(5)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)

				Call execSP(DBCon, SpName3, param3, "", "")
		DisconnectDB DBCon

		'4) 회원 정보 쿠키 할당
		' objEncrypter AES암호화 모듈 위치 : /common/common.asp > /wwwconf_renew/function/auth/getCookie.asp > /wwwconf_renew/function/library/AES256.asp
		' /wwwconf_renew/function/library/AES256.asp : KISA 권고안에 따른 로그인 정보 AES256 방식 암호화 처리
		' 로그인 정보 복호화는 /common/common.asp 상단에 인클루드된 /wwwconf_renew/function/auth/getCookie.asp 에서 처리됨
		Response.Cookies("WKC")("id")			= objEncrypter.Encrypt(f_txtId)
		Response.Cookies("WKC")("name")			= objEncrypter.Encrypt(f_txtBizName)
		Response.Cookies("WKC")("kind")			= objEncrypter.Encrypt(f_rdoBizType)
		Response.Cookies("WKC").Domain			= "career.co.kr"	' 도메인 설정

		Dim strLink_Sucs : strLink_Sucs = "/company/info/Biz_Info.asp"	
		Call FN_alertLink("회원가입이 완료되었습니다.",strLink_Sucs)
	Else 
		Call FN_alertLink("회원가입 중 오류가 발생했습니다.\n다시 시도해 주세요.",strLink_Fail)
	End If 
Else 
	Call FN_alertLink("입력하신 아이디로 가입된 정보가 존재합니다.\n다른 아이디로 다시 시도해 주세요.",strLink_Fail)
End If 
%>