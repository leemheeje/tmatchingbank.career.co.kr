<%
'--------------------------------------------------------------------
'   회원 로그아웃
' 	최초 작성일	: 2021-04-27
'	최초 작성자	: 이샛별
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/auth/clearCookie.asp"-->
<%
' 로그아웃 처리 경로 체크
Dim v_DeviceType, strLink
If InStr(site_Referer,"/mobile/")=0 Then 
	v_DeviceType = "pc"
	strLink      = "/"
Else 
	v_DeviceType = "mobile"
	strLink      = g_mobile_wk
End If

Dim f_hidRedir : f_hidRedir = Request("redir")
If f_hidRedir <> "" Then strLink = f_hidRedir


If g_LoginChk="0" Then
	Call FN_alertLink("정상적인 접근 방식이 아닙니다.",strLink)
End If

' 로그인 구분자에 따라 제어 값 설정
Dim v_LogType_Txt, v_UserId
If g_LoginChk="1" Then
	v_LogType_Txt	= "mem"
	v_UserId		= user_id
Else
	v_LogType_Txt	= "biz"
	v_UserId		= com_id
End If 

' 로그아웃 이력 저장
ConnectDB DBCon, Application("DBInfo")
	SpName="SPU_CONNECT_LOG_INSERT"
		Dim param(5)
		param(0)=makeParam("@IN_V_USER_TYPE", adVarChar, adParamInput, 10, v_LogType_Txt)
		param(1)=makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, v_UserId)
		param(2)=makeParam("@IN_V_LOG_TYPE", adChar, adParamInput, 3, "out")
		param(3)=makeParam("@IN_V_DEVICE_TYPE", adVarChar, adParamInput, 6, v_DeviceType)
		param(4)=makeParam("@IN_V_USER_AGENT", adVarChar, adParamInput, 1000, site_Agent)
		param(5)=makeParam("@IN_V_USER_IP", adVarChar, adParamInput, 30, site_IPAddr)

		Call execSP(DBCon, SpName, param, "", "")
DisconnectDB DBCon

Call Sub_clearCookie  ' 모든 쿠키 정보 초기화
%>
<html>
<head><meta http-equiv="refresh" content="0; url=<%=strLink%>"></head>
<body></body>
</html>