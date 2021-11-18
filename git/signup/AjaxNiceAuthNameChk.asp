<%
'--------------------------------------------------------------------
'   Comment		: 기업회원가입 > 나신평 휴대폰 본인인증 모듈 연동
' 	History		: 2021-08-25, 이샛별
'   DB TABLE	: 
'---------------------------------------------------------------------

Dim tag	: tag	= request("tag")
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script type="text/javascript">
<%If Len(tag)=0 Then%>
$(document).ready(function(){
	function fn_popAuth(){
		document.domain = "career.co.kr";
		window.name = "parentPageX";
		window.open('http://www1.career.co.kr/Auth/HP/checkplus_main.asp', 'popupChk', 'width=520, height=480, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
	}
});
<%End If%>
</script>
<html>
	<body>
	</body>
</html>
<%
Response.write tag&"TT"
%>