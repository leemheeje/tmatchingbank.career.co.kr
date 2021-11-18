<%
'--------------------------------------------------------------------
'   알림톡 발송
' 	최초 작성일	: 2021-06-08
'	최초 작성자	: 임상균
'   input		: 
'	output		: 
'	Comment		: 
'					RCODE - 0:인증요청, 1:인증완료, 2:인증실패,
'					mobileAuthNumChk:휴대폰번호전송
'					MobileNo:휴대폰번호,
'					SendAuthCodeID:인증코드 비교Key
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#INCLUDE virtual = "/lib/SendAlimTalk.inc"-->
<%
Randomize 

	Dim i,AuthCode,AuthStatus,SendAuthCodeID,MobileNo
	Dim SendContents, SendContentsTranSms
	Dim TemplateCode : TemplateCode = "001002_001"
	Dim sitename	 : sitename		= "취업포털 커리어"
	Dim AlimDate

	contact = request("contact")
	MemberKind = request("MemberKind")
	sitecode =request("sitecode")

	MobileNo = request("contact")

	For i = 1 to 6 
		AuthCode = AuthCode & Int((9 * Rnd) + 1) ' 1에서 10까지 무작위 값을 발생합니다. 
	Next 
	AuthStatus	=	0	'0 

	ConnectDB DBCon, Application("DBInfo_REAL")

	Dim spName, param(8)

	spName = "USP_MobileAuth_AlimTalk_Request"
	param(0) = makeParam("@MobilePhone", adVarChar, adParamInput, 20, contact)
	param(1) = makeParam("@AuthNumber", adVarChar, adParamInput, 6, AuthCode)
	param(2) = makeParam("@SiteName_Kor", adVarChar, adParamInput, 50, sitename)
	param(3) = makeParam("@SiteGubun", adVarChar, adParamInput, 2, sitecode)
	param(4) = makeParam("@MemberKind", adVarChar, adParamInput, 50, MemberKind)
	param(5) = makeParam("@IPaddress", adVarChar, adParamInput, 50, site_IPAddr)
	param(6) = makeParam("@idxNum", adInteger, adParamOutput, 4, 0)
	param(7) = makeParam("@rtnTime", adVarChar, adParamOutput, 100, "")
	param(8) = makeParam("@rtn", adChar, adParamOutput, 1, "")
	
	Dim OUTPUT_VALUE(2)
	Call execSP(DBCon, spName, param, "", "")

	SendAuthCodeID = getParamOutputValue(param, "@idxNum")
	OUTPUT_VALUE(1) = getParamOutputValue(param, "@rtnTime")
	OUTPUT_VALUE(2) = getParamOutputValue(param, "@rtn")

	DisconnectDB DBCon

	'알림톡 발송 시작
	ConnectDB DBCon, Application("DB_SMS")

	Dim spName2, param2(2)

	spName2 = "P_Select_Template_Info_Proc"
	param2(0) = makeParam("@TemplateCode", adVarChar, adParamInput, 30, TemplateCode)
	param2(1) = makeParam("@SendContents_out", adVarChar, adParamOutput, 4000, "")
	param2(2) = makeParam("@SendContentsTranSms_out", adVarChar, adParamOutput, 2000, "")
	
	Call execSP(DBCon, spName2, param2, "", "")

	SendContents = getParamOutputValue(param2, "@SendContents_out")
	SendContentsTranSms = getParamOutputValue(param2, "@SendContentsTranSms_out")

	SendContents = ReplaceContents(SendContents,sitename,AuthCode)
	SendContentsTranSms = ReplaceContents(SendContentsTranSms,sitename,AuthCode)
	
	'알림톡 발송모듈 호출
	AlimDate = TransDatetype(Now(),"YYYYMMDDhhmmss")	' 발송시간

	Call SendAlimtalk(DBCon,contact,TemplateCode,SendContents,AlimDate,"Y",SendContentsTranSms,"daumhr",site_callback_phone)

	DisconnectDB DBCon
	'알림톡 발송 종료

%>

<%
Function ReplaceContents(pContents,pCompanyName,pAuthCode)

	pContents = Replace(pContents,"'","''") 
	If pCompanyName <> "" Then pContents = Replace(pContents, "#{회사명}", pCompanyName)
	If pAuthCode <> "" Then pContents = Replace(pContents, "#{인증번호}", pAuthCode)

	ReplaceContents = pContents

End Function

%>
{
"RCODE":"0","mobileAuthNumChk":"1","MobileNo":"<%=MobileNo%>","SendAuthCodeID":"<%=SendAuthCodeID%>"
}