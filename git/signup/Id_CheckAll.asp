<%
'--------------------------------------------------------------------
'   Comment		: 회원가입 > 아이디 중복 체크
' 	History		: 2021-04-13, 이샛별
'   DB TABLE	: dbo.개인회원정보
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
user_id = Request("user_id")

ConnectDB DBCon, Application("DBInfo")

' 입력 아이디 중복 체크
SpName="SPU_ID_CHECK_ALL"
	Dim param(1)
	param(0)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, user_id)
	param(1)=makeParam("@OUT_V_RTN", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, param, "", "")

	sp_rtn = getParamOutputValue(param, "@OUT_V_RTN")	

DisconnectDB DBCon

	If Len(user_id)<5 Then
		sp_rtn = "F"
	Else
		sp_rtn = sp_rtn
	End If

Response.write sp_rtn
%>
