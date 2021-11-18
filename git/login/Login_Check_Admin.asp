<%
'--------------------------------------------------------------------
'   회원 로그인 처리
' 	최초 작성일	: 2021-04-27
'	최초 작성자	: 이샛별
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

	f_hidRedir		= Request("redir")			' 직전 페이지 정보(유입 경로 체크용)

	v_set_Ck	= "ADM"
	Response.Cookies(v_set_Ck)("id")			= "careeradm"
	Response.Cookies(v_set_Ck)("name")			= "관리자"
	Response.Cookies(v_set_Ck).Domain			= "career.co.kr"	' 도메인 설정

	strLink = f_hidRedir
%>
<html>
<head><meta http-equiv="refresh" content="0; url=<%=strLink%>"></head>
<body></body>
</html>