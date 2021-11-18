<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/error/ErrorPageExec.asp"-->
<%
Const lngMaxFormBytes = 200

Dim objASPError, blnErrorWritten, strServername, strServerIP, strRemoteIP
Dim strMethod, lngPos, datNow, strQueryString, strURL
Dim scriptname

If Response.Buffer Then
	Response.Clear
	Response.Status = "500 Internal Server Error"
	Response.ContentType = "text/html"
	Response.Expires = 0
End If
%>

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
dim strerr, ertype

  Set objASPError = Server.GetLastError

  strerr=strerr & "<ul><li><b>오류 형식:</b><br>"
  strerr=strerr & objASPError.Category

  'Response.Write strerr

  If objASPError.ASPCode > "" Then   strerr=strerr & ", " & objASPError.ASPCode

  strerr=strerr & " (0x" & Hex(objASPError.Number) & ")" & "<br>"
  ertype=objASPError.Description
  strerr=strerr & "<b>" & ertype & "</b><br>"

  If objASPError.ASPDescription > "" Then strerr=strerr & objASPError.ASPDescription & "<br>"

  blnErrorWritten = False

  ' Only show the Source if it is available and the request is from the same machine as IIS
  If objASPError.Source > "" Then
    strServername = LCase(Request.ServerVariables("SERVER_NAME"))
    strServerIP = Request.ServerVariables("LOCAL_ADDR")
    strRemoteIP =  Request.ServerVariables("REMOTE_ADDR")
'    If (strServername = "localhost" Or strServerIP = strRemoteIP) And objASPError.File <> "?" Then
      strerr=strerr & objASPError.File
      If objASPError.Line > 0 Then strerr=strerr & ", line " & objASPError.Line
      If objASPError.Column > 0 Then strerr=strerr & ", column " & objASPError.Column
      strerr=strerr & "<br>"
      strerr=strerr & "<font style=""COLOR:000000; FONT: 9pt/11pt 굴림""><b>"
'      strerr=strerr & Server.HTMLEncode(objASPError.Source) & "<br>"
      strerr=strerr & objASPError.Source & "<br>"
      If objASPError.Column > 0 Then strerr=strerr & String((objASPError.Column - 1), "-") & "^<br>"
      strerr=strerr & "</b></font>"
      blnErrorWritten = True
 '   End If
  End If

  If Not blnErrorWritten And objASPError.File <> "?" Then
    strerr=strerr & "<b>" & objASPError.File
    If objASPError.Line > 0 Then strerr=strerr & ", line " & objASPError.Line
    If objASPError.Column > 0 Then strerr=strerr & ", column " & objASPError.Column
    strerr=strerr & "</b><br>"
  End If

  strerr=strerr & "</li><p><li>페이지 : "

  strMethod = Request.ServerVariables("REQUEST_METHOD")
  strerr=strerr & strMethod & " "
  If strMethod = "POST" Then
    strerr=strerr & Request.TotalBytes & " bytes to "
  End If
  scriptname=Request.ServerVariables("SCRIPT_NAME")
  strerr=strerr & scriptname
  lngPos = InStr(Request.QueryString, "|")
  If lngPos > 1 Then
    strerr=strerr & "?" & Left(Request.QueryString, (lngPos - 1))
  End If
  strerr=strerr & "</li>"

  If strMethod = "POST" Then
     strerr=strerr & "<li>POST Data : "
     strerr=strerr & Request.Form
  Else
     strerr=strerr & "<li>GET Data : " & Request.ServerVariables ("QUERY_STRING") & "</li>"
  End If

  strerr=strerr & "<li>참조페이지 : " & Request.ServerVariables ("HTTP_REFERER") & "</li>"
  strerr=strerr & "<li>사용자IP : " & Request.Servervariables("REMOTE_ADDR") & "</li>"
  strerr=strerr & "<li>브라우저 형식 : " & Request.ServerVariables("HTTP_USER_AGENT") & "</li>"
  strerr=strerr & "<li>시간 : " & Now() & "</li>"

dim pu,cu,ce,pe

pu=user_id
cu=comid & "|" & comname  & "|" & Request.Cookies("WKC")("comlevdb") & "|" & Request.Cookies("WKC")("comkind") & "|" & Request.Cookies("WKC")("comlevgu") & "|" & Request.Cookies("WKC")("comlevre")
'pe=Request.Cookies("user_email")

dim str

str="<ul><li>서버 : " & Request.ServerVariables("LOCAL_ADDR") & "</li><br>" & vbCrLf
str=str & "<font size=2><ul><li>개인아이디 : " & pu & " </li><br>" & vbCrLf
str=str & "<li>기업아이디 : " & cu & "</li></ul>" & vbCrLf
str=str & strerr & "<p>"


'if Request.ServerVariables("REMOTE_ADDR")="211.54.63.81" Or Request.ServerVariables("REMOTE_ADDR")="211.54.63.8" Or Request.ServerVariables("REMOTE_ADDR")="211.54.63.86" Or Request.ServerVariables("REMOTE_ADDR")="218.145.92.94" Then

If Request.ServerVariables("LOCAL_ADDR") = "218.145.70.187" Then
	Response.Write Str
	Response.End
End If 

'Response.End


If ertype="시간 제한이 만료되었습니다." or ertype="스크립트 시간 초과" Then
	Response.Redirect "/sys/500.html"
	Response.End
Else

	Dim HTTP_ServerName : HTTP_ServerName = Request.ServerVariables("SERVER_NAME")
    Dim HTTP_RemoteAddr : HTTP_RemoteAddr = Request.ServerVariables("REMOTE_ADDR")
    Dim HTTP_LocalAddr : HTTP_LocalAddr = Request.ServerVariables("LOCAL_ADDR")
    Dim HTTP_RequestMethod : HTTP_RequestMethod = Request.ServerVariables("REQUEST_METHOD")
    Dim HTTP_ScriptName : HTTP_ScriptName = Request.ServerVariables("SCRIPT_NAME")
    Dim HTTP_Referer : HTTP_Referer = Request.ServerVariables ("HTTP_REFERER")
    Dim HTTP_UserAgent : HTTP_UserAgent = Request.ServerVariables("HTTP_USER_AGENT")

	Dim execParams(6)
	execParams(0) = "M001"   '커리어
	execParams(1) = mailto
	execParams(2) = "error@career.co.kr"
	execParams(3) = "커리어 관리자"
	execParams(4) = "▶서버에러신고" & scriptname
	execParams(5) = 500
	execParams(6) = Str
	
	'1) DB입력
	Const DB_CONN_STR = "Provider=SQLOLEDB;Data Source='192.168.1.7';User ID='daumwithdba';Password='fnzl@boa';Initial Catalog=dbRecord"
	ConnectDB DBCon, DB_CONN_STR
		Dim execRet
		execRet = ErrorPageInsert(DBCon, execParams(0), execParams(5), HTTP_ServerName, HTTP_LocalAddr, HTTP_RemoteAddr, HTTP_ScriptName, HTTP_Referer, HTTP_RequestMethod, HTTP_UserAgent, execParams(6))
	DisconnectDB DBCon
End If 


%>