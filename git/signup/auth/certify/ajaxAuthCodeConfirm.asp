<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%

	Dim AuthNumber,SendAuthCodeID,RCODE,MobileNo,result_idx
	Dim sitename	: sitename		= "취업포털 커리어"

	contact	= request("contact")
	AuthNumber	= request("AuthNumber") 
	sitecode =request("sitecode")
	MemberKind = request("MemberKind")
	idxNum	  =	request("idxNum")

	MobileNo = request("contact")

	ConnectDB DBCon, Application("DBInfo_REAL")

	Dim spName, param(7)

	spName = "USP_MobileAuth_AlimTalk_Confirm"
	param(0) = makeParam("@MobilePhone", adVarChar, adParamInput, 20, contact)
	param(1) = makeParam("@AuthNumber", adVarChar, adParamInput, 6, AuthNumber)
	param(2) = makeParam("@SiteName_kor", adVarChar, adParamInput, 50, sitename)
	param(3) = makeParam("@SiteGubun", adVarChar, adParamInput, 2, sitecode)
	param(4) = makeParam("@MemberKind", adVarChar, adParamInput, 50, MemberKind)
	param(5) = makeParam("@idxNum", adInteger, adParamInput, 4, idxNum)
	param(6) = makeParam("@rtn", adChar, adParamOutput, 1, 0)
	param(7) = makeParam("@AuthYN", adChar, adParamOutput, 1, 0)


	Call execSP(DBCon, spName, param, "", "")

	RCODE = getParamOutputValue(param, "@rtn")
	result_idx = getParamOutputValue(param, "@AuthYN")


	DisconnectDB DBCon
		

%>{"RCODE":"<%=RCODE%>","result_idx":"<%=result_idx%>","MobileNo":"<%=MobileNo%>","SendAuthCodeID":"<%=SendAuthCodeID%>"}