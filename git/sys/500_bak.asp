<%
'	Option Explicit
'	Dim g_Debug : g_Debug = TRUE
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include file = "../../../wwwconf/function/error_function.asp"-->
<!--#include file = "../../../wwwconf/function/db/DBFunction.asp"-->
<!--#include file = "../../../wwwconf/function/lib_sql/error/ErrorPageExec.asp"-->
<!--#include file = "../../../wwwconf/function/lib_biz/error/ErrorPageExec.asp"-->

<!--


실서버 반영시 
/wwwconf/function/error_function.asp
/wwwconf/function/lib_sql/error/ErrorPageExec.asp
/wwwconf/function/lib_biz/error/ErrorPageExec.asp

renew.career.co.kr 전용으로 (wwwconf_renew) 
ANSI형태가 아닌 UTF-8형태로 신규생성 해야함

-->


<%
 'File Name  : /sys/500.asp
 'Description : System error

 'Programmed by KyungNam, Park(knpark@career.co.kr)
 'Last Modification Date : 2006/11/06 구현.
%>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="imagetoolbar" content="no" />
<title>커리어 :: 취업포털 커리어</title>
<link type="text/css" rel="stylesheet" href="/css/error.css" />
<script type="text/javascript" src="error.js"></script>
</head>

<body>
<div id="error_area">
	<!-- header -->
	<div class="header">
	<h1><a href="/"><img src="http://image.career.co.kr/career_new/error/logo_career.gif" alt="커리어" /></a></h1>
	<ul class="top_menu">
	<li class="first"><a href="/"><img src="http://image.career.co.kr/career_new/error/menu_career.gif" alt="커리어 메인" /></a></li>
	<li><a href="javascript:history.back()"><img src="http://image.career.co.kr/career_new/error/menu_back.gif" alt="이전페이지" /></a></li>
	</ul>
	</div>
	<!--// header -->
	
	<!-- tit area -->
	<div class="tit_area">
	<h2><img src="http://image.career.co.kr/career_new/error/txt2.gif" alt="죄송합니다! 사용자가 많아 서버와의 접속이 지연되고 있습니다." /></h2>
	<p class="txt_box">
	서비스 이용에 불편을 드려 죄송합니다.<br />
	사용자가 많아 서버와의 접속이 지연되고 있습니다.<br /><br />

	정상적인 서비스 이용을 위해 현재 모두가 최선을 다하고 있습니다.<br /><br />

	서비스 이용에 불편을 드려 다시 한번 사과드립니다.<br />
	잠시 후에 다시 이용해 주시기 바랍니다. 감사합니다
	</p>
	</div>
	<!--// tit area -->

	<!-- poweService -->
	<div class="powerService">
		<div class="person">
			<h2><img src="http://image.career.co.kr/career_new2/error/person_tit.gif" alt="개인회원을 위한 파워서비스!" /></h2>
			<ul>
				<li><a href="http://www.career.co.kr/my/resume/resume_reg_step1.asp" target="_blank"><img src="http://image.career.co.kr/career_new2/error/person_btn1.gif" alt="이력서 등록! 이력서를 등록하시면 커리어에서 쉽고 간편하게 입사지원을 하실 수 있습니다" /></a></li>
				<li><a href="http://www.career.co.kr/info/consulting/list.asp?ca=2&channel=나눔&indexname=좌측_톡&linkname=이력서컨설팅" target="_blank"><img src="http://image.career.co.kr/career_new2/error/person_btn2.gif" alt="이력서 무료 컨설팅! 커리어 경력개발 연구소의 전문 컨설턴트가 무료로 컨설팅을 해드립니다." /></a></li>
				<li><a href="http://www.career.co.kr/info/opdt/default.asp?ca=1&channel=나눔&indexname=좌측_톡&linkname=직업성향진단검사" target="_blank"><img src="http://image.career.co.kr/career_new2/error/person_btn3.gif" alt="직업성향 진단검사! 개인의 성향에 맞는 직업을 파악하고, 해당 직업의 소개, 필요 스펙들을 한 눈에 알 수 있는 특화된 검사입니다." /></a></li>
				<li><a href="http://www.career.co.kr/jobs/mobile/" target="_blank"><img src="http://image.career.co.kr/career_new2/error/person_btn4.gif" alt="취업 어플! 커리어 스마트 취업! 언제 어디서든 스마트폰으로 맞춤채용정보 검색부터 입사지원까지! 이제 구직활동도 스마트하게!" /></a></li>
			</ul>
		</div>
		<div class="company">
			<h2><img src="http://image.career.co.kr/career_new2/error/company_tit.gif" alt="기업회원을 위한 파워서비스!" /></h2>
			<ul>
				<li><a href="http://www.career.co.kr/company/jobpost/jobpost_step1.asp" target="_blank"><img src="http://image.career.co.kr/career_new2/error/company_btn1.gif" alt="채용공고 무료등록! 이력서를 등록하시면 커리어에서 쉽고 간편하게 입사지원을 하실 수 있습니다" /></a></li>
				<li><a href="http://www.career.co.kr/resume/" target="_blank"><img src="http://image.career.co.kr/career_new2/error/company_btn2.gif" alt="이력서 200만건 인재정보 보유! 이력서 보유량 업계 최고! 최저가격, 높은 만족도를 제공하는 이력서 열람서비스를 이용해보세요." /></a></li>
				<li><img src="http://image.career.co.kr/career_new2/error/company_btn3.gif" alt="Metro, City신문에 채용공고 노출! 대한민국 최고의 Metro무가지 신문에 귀사의 채용정보가 동시 게재됩니다." /></li>
				<li><img src="http://image.career.co.kr/career_new2/error/company_btn4.gif" alt="대학전산망 채용공고 노출! 전국 60여개 대학 취업지원 사이트에 귀사의 채용정보가 동시 게재됩니다." /></li>
			</ul>
		</div>
	</div>
	<!--// poweService -->

	<!-- footer -->
	<div class="footer">
		Copyright⒞ CareerNet co.,LTD. All rights Reserved.
	</div>
	<!--// footer -->

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
if InStr(Request.ServerVariables("REMOTE_ADDR"), "10.8.0.") > 0 Then
    '관리자이면 디버깅정보 화면에 view
	Response.Write str
	Response.End
End If 

'else

	if ertype="시간 제한이 만료되었습니다." or ertype="스크립트 시간 초과" then

		Response.Redirect "/sys/500.htm"
        Response.End

	else

		dim mailto

		' 이청희 : hyperx@career.co.kr
		' 심원보 : wonbo@career.co.kr
		' 이상준 : havethesay@career.co.kr
		' 허양미 : yangmi76@career.co.kr
		' 최순봉 : program9@career.co.kr
		' 민남기 : sjun80@career.co.kr
		' 황경숙 : ksh@career.co.kr
		' 한상권 : hsk2244@career.co.kr
		' 오두용 : myname520@career.co.kr
		' 함치영 : kosmis@career.co.kr
		' 박동욱 : ingpdw@career.co.kr
		' 최상호 : shchoi@career.co.kr
		' 안정훈 : muaerror@career.co.kr
		' 박종현 : flyjjong@career.co.kr
		' 박병옥 : redreo@career.co.kr
		' 김승준 : sjun80@career.co.kr

		if instr(1,scriptname,"/edu/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/educlass/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/jobs/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/jobs2/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/event/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/kntalk/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/info/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/alba/",1) > 0 then
			mailto="oldboy798@career.co.kr;muaerror@career.co.kr"
		elseif instr(1,scriptname,"/headhunting/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/my/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/resume/",1) > 0 then
			mailto="muaerror@career.co.kr"
		elseif instr(1,scriptname,"/company/",1) > 0 then
			mailto="muaerror@career.co.kr"
		else
			mailto="muaerror@career.co.kr"
		end If

        mailto = mailto & ""

        '일반사용자이면 디버깅정보 DB전송 or 메일보내기
		if ertype <> "시간 제한이 만료되었습니다." then

            '----------------------------------------------------
            '   에러정보 DB적용처리(실패 시 관리자에게 메일발송)
            '----------------------------------------------------
            '   페이지 오류 처리 파라미터 셋팅.
            '
            '   0: 사이트구분코드(M001, M002, A001,..)
            '   1: 받는사람 메일주소
            '   2: 보내는 사람 메일주소
            '   3: 보내는 사람 이름
            '   4: 메일제목
            '   5: 에러코드
            '   6: 오류내용
            '----------------------------------------------------
            Dim execParams(13)

            execParams(0) = "M001"   '커리어
            execParams(1) = mailto
            execParams(2) = "error@career.co.kr"
            execParams(3) = "커리어 관리자"
            execParams(4) = "▶서버에러신고" & scriptname
            execParams(5) = 500
            execParams(6) = str

            Call ErrorPageDbOrEmailExec(execParams)

        End If

	end if

'end if
%>