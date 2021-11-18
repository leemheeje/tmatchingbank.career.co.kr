<%
Session.codepage="65001"
Response.CharSet="utf-8"
Response.codepage="65001"
Response.ContentType="text/html;charset=utf-8"
%>
<!--#include virtual = "/common/constant.asp"-->
<!--#include virtual = "/wwwconf/function/common/injection.asp"-->
<!--#include virtual = "/wwwconf/function/common/common_function.asp"-->
<!--#include virtual = "/wwwconf/function/common/svrlink.asp"-->
<!--#include virtual = "/wwwconf/function/auth/getCookie.asp"-->
<%
'//W3C P3P 규약설정 - ASP 버전
Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"


'============================================================
' 사용자 접속환경 정보
'============================================================
site_IPAddr			= Request.ServerVariables("REMOTE_ADDR")		' 요청하는 원격 호스트 주소를 반환
site_Name			= Request.ServerVariables("SERVER_NAME")		' 도메인 주소
site_Port			= Request.ServerVariables("SERVER_PORT")		' 포트 정보
site_Path			= Request.ServerVariables("PATH_INFO")			' 전체 URL 표기
site_Url			= Request.ServerVariables("URL")				' 도메인명 이후 URL을 반환
site_QueryString	= Request.ServerVariables("QUERY_STRING")		' 파라메터 정보 반환
site_Referer		= Request.ServerVariables("HTTP_REFERER")		' 이전 페이지 URL 문자열을 반환
site_Agent			= Request.ServerVariables("HTTP_USER_AGENT")	' 접속자 브라우저 정보 반환
site_lPath			= LCase(Trim(site_Path))


'============================================================
'	사이트 공통 사항 정의
'============================================================
'SSL 접속
If site_Port = 80 Then
	strSecureURL = "https://"
	strSecureURL = strSecureURL & site_Name
	strSecureURL = strSecureURL & site_Url
	If site_QueryString <> "" Then 
		strSecureURL = strSecureURL &"?"&site_QueryString
	End If 

	Response.Redirect strSecureURL
End If


'롤백URL
redir = site_Name & site_Url
If Len(site_QueryString) > 0 Then
	redir = redir &"?"& site_QueryString
End If


'로그인 상태
If Request.Cookies("WKP")("id") <> "" Then
	'개인회원
	g_LoginChk = 1
	Call Sub_getUserCookie()

ElseIf Request.Cookies("WKC")("id") <> "" Then
	'기업회원
	g_LoginChk = 2
	Call Sub_getBizCookie()

Else
	'비회원(로그인전)
	g_LoginChk = 0

End If
%>
