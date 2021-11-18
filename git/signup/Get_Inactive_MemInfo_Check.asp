<%
'--------------------------------------------------------------------
'   개인회원 > 휴면 해제 > 휴면 관리 테이블 내 회원 정보 유무 체크
' 	최초 작성일	: 2021-08-10
'	최초 작성자	: 이샛별
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
Dim f_txtId		: f_txtId	= Request("txtId")				' 회원아이디
Dim f_txtName	: f_txtName	= unescape(Request("txtName"))	' 회원명

If Len(f_hidUserId)=0 And Len(f_txtName)=0 Then
	cntJoin = "X"
Else 
	ConnectDB DBCon, Application("DBInfo")

		Dim rowRs
		ReDim param(1)
		param(0)	= makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_txtId)
		param(1)	= makeParam("@IN_V_USER_NAME", adVarChar, adParamInput, 30, f_txtName)
		rowRs		= arrGetRsSP(DBCon, "SPC_INACTIVE_USER_INFO_SELECT", param, "", "")
		If IsArray(rowRs) Then
			cntJoin = "S"
		Else
			cntJoin = "F"
		End If

	DisconnectDB DBCon
End If

Response.write cntJoin
%>