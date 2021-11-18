<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/error/ErrorPageExec.asp"-->

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>커리어 - 취업이 이뤄진다, 이직이 이뤄진다.</title>

	<!-- 에러페이지관련 리소스파일 :S -->
	<link rel="stylesheet" href="/css/renew_error.css">
	<!-- 에러페이지관련 리소스파일 :E -->
</head>
<body>

	<div class="erroWrap">
		<div class="inner">
			<div class="slog">
				<a href="//www.career.co.kr/" class="img"><img src="//image.career.co.kr/career_new/error/logo.png" alt=""></img></a>
			</div>
			<div class="scont">
				<span class="scImgs">
					<img src="//image.career.co.kr/career_new/error/err_img.png" alt="">
				</span>
				<div class="scTxts">
					<div class="tit">
						죄송합니다.<br>
						사용자가 많아 서버와의 접속이 지연되고 있습니다.
					</div>
					<div class="stit">
						서비스 이용에 불편을 드려 죄송합니다.<br>
						사용자가 많아 서버와의 접속이 지연되고 있습니다.
					</div>
					<div class="stit">
						정상적인 서비스 이용을 위해 현재 모두가 최선을 다하고 있습니다.
					</div>
					<div class="stit">
						서비스 이용에 불편을 드려 다시 한번 사과드립니다.<br>
					잠시 후에 다시 이용해 주시기 바랍니다. 감사합니다
					</div>
				</div>
			</div>
			<div class="scbot">
				<a href="//www.career.co.kr/" class="sbtns">
					<span class="t">커리어 메인으로 이동</span><span class="ic"></span>
				</a>
			</div>
		</div>
	</div>

</body>
</html>

<%

	Dim HTTP_ServerName : HTTP_ServerName = Request.ServerVariables("SERVER_NAME")
    Dim HTTP_RemoteAddr : HTTP_RemoteAddr = Request.ServerVariables("REMOTE_ADDR")
    Dim HTTP_LocalAddr : HTTP_LocalAddr = Request.ServerVariables("LOCAL_ADDR")
    Dim HTTP_RequestMethod : HTTP_RequestMethod = Request.ServerVariables("REQUEST_METHOD")
    Dim HTTP_ScriptName : HTTP_ScriptName = Request.ServerVariables("SCRIPT_NAME")
    Dim HTTP_Referer : HTTP_Referer = Request.ServerVariables ("HTTP_REFERER")
    Dim HTTP_UserAgent : HTTP_UserAgent = Request.ServerVariables("HTTP_USER_AGENT")

	Dim execParams(6)
	execParams(0) = "M001"   '커리어
	execParams(1) = ""
	execParams(2) = "error@career.co.kr"
	execParams(3) = "커리어 관리자"
	execParams(4) = "▶서버에러신고" & HTTP_ScriptName
	execParams(5) = "404"
	execParams(6) = "test"


	Response.write "a : " & Request.ServerVariables("PATH_INFO")		& "<br>"
	Response.write "b : " & Request.ServerVariables("SCRIPT_NAME")	& "<br>"
	Response.write "c : " & Request.ServerVariables("URL")			& "<br>"


	Response.write "0 : " & execParams(0)		& "<br>"
	Response.write "1 : " & execParams(5)		& "<br>"
	Response.write "2 : " & HTTP_ServerName		& "<br>"
	Response.write "3 : " & HTTP_LocalAddr		& "<br>"
	Response.write "4 : " & HTTP_RemoteAddr		& "<br>"
	Response.write "5 : " & HTTP_ScriptName		& "<br>"
	Response.write "6 : " & HTTP_Referer		& "<br>"
	Response.write "7 : " & HTTP_RequestMethod	& "<br>"
	Response.write "8 : " & HTTP_UserAgent		& "<br>"
	Response.write "9 : " & execParams(6)		& "<br>"

	
	'1) DB입력
	Const DB_CONN_STR = "Provider=SQLOLEDB;Data Source='192.168.1.7';User ID='daumwithdba';Password='fnzl@boa';Initial Catalog=dbRecord"
	ConnectDB DBCon, DB_CONN_STR
		Dim execRet
		'execRet = ErrorPageInsert(DBCon, execParams(0), execParams(5), HTTP_ServerName, HTTP_LocalAddr, HTTP_RemoteAddr, HTTP_ScriptName, "", HTTP_RequestMethod, HTTP_UserAgent, execParams(6))
	DisconnectDB DBCon

%>