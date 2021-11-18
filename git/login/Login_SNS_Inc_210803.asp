<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 > 개인회원 가입/로그인 공용
' 	최초 작성일	: 2021-04-15
'	최초 작성자	: 이샛별
'   input		: 
'	output		: 
'	Comment		: sns_gubun = 가입사이트구분코드(C0063) > 31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
'---------------------------------------------------------------------
%>
<%
' SNS로그인 api용 브라우저 체크
Dim apiTrueChk, apiTrueChkGL
apiTrueChk		= False 
apiTrueChkGL	= False 

If InStr(site_Agent, "MSIE 10") Or InStr(site_Agent, "rv:11") Or InStr(site_Agent, "RV:11") Or InStr(site_Agent, "EDGE") Or InStr(site_Agent, "Chrome") Or InStr(site_Agent, "Safari") Or InStr(site_Agent, "SAFARI") Or InStr(site_Agent, "Firefox") Or InStr(site_Agent, "FIREFOX") Or InStr(site_Agent, "Opera") Or InStr(site_Agent, "OPERA") Then
	apiTrueChk = True 
End If

If InStr(site_Agent, "MSIE 10") Or InStr(site_Agent, "rv:11") Or InStr(site_Agent, "RV:11") Or InStr(site_Agent, "EDGE") Or InStr(site_Agent, "Chrome") Or InStr(site_Agent, "Safari") Or InStr(site_Agent, "SAFARI") Or InStr(site_Agent, "Firefox") Or InStr(site_Agent, "FIREFOX") Or InStr(site_Agent, "Opera") Or InStr(site_Agent, "OPERA") Then
	apiTrueChkGL = True 
End If

g_LoginChk = 0
%>
<META NAME="ROBOTS" CONTENT="NOINDEX">
<script type="text/javascript">
	// SNS 간편 로그인
	function fn_openSNSLogin(gb) {
		if (gb == "KO") {
			if ('<%=apiTrueChk%>' == "True") {
				loginWithKakao();
			} else {
				alert("Explorer 10 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
				return false;
			}
		} else if (gb == "NV") {
			if ('<%=apiTrueChk%>' == "True") {
				var params = "?gb=" + gb;
				window.open("/login/Default.asp" + params, "snslogin", "width=500,height=300,scrollbars=no,location=no").focus();
			} else {
				alert("Explorer 10 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
				return false;
			}
		} else if (gb == "FB") {
			if ('<%=apiTrueChk%>' == "True") {
				checkLoginState();
			} else {
				alert("Explorer 10 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
				return false;
			}
		} else if (gb == "GL") {
			//구글만 조건이 다름, apiTrueChkGL 로 체크
			//구글api는 객체(id) 자체에 이벤트 기능이 삽입되어 있음
			if ('<%=apiTrueChkGL%>' == "True") {
				startApp();
			} else {
				alert("Explorer Edge 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
				return false;
			}
		}
	}

	function fn_snsReturnLogin() {
		var obj = document.frm_snslogin;
		obj.method = "post";
		obj.action = "/login/Login_SNS_Check.asp";
		obj.submit();
	}
</script>
<div class="ccol12 MT30">
	<div class="cmmTit sm colorBlack">SNS 간편 로그인</div>
</div>
<div class="ccol12 MT10">
	<div class="crow sm allpadding">
		<div class="ccol6">
			<a href="javascript:void(0);" onclick="fn_openSNSLogin('FB');" class="btns block gray-4 outline colorGry-1 FONT14 xmd" id="fb_login"><span class="icos sns facebook MR05"></span>페이스북으로 시작하기</a>
		</div>
		<div class="ccol6">
			<a href="javascript:void(0);" onclick="fn_openSNSLogin('KO');" class="btns block gray-4 outline colorGry-1 FONT14 xmd" id="ko_login"><span class="icos sns kakao MR05"></span>카카오톡으로 시작하기</a>
		</div>
		<div class="ccol6">
			<a href="javascript:void(0);" onclick="fn_openSNSLogin('NV');" class="btns block gray-4 outline colorGry-1 FONT14 xmd" id="nv_login"><span class="icos sns naver MR05"></span>네이버로 시작하기</a>
		</div>
		<div class="ccol6">
			<a href="javascript:void(0);" onclick="fn_openSNSLogin('GL');" class="btns block gray-4 outline colorGry-1 FONT14 xmd" id="gl_login"><span class="icos sns google MR05"></span>구글로 시작하기</a>
		</div>
	</div>
</div>

<%' 네이버는 include하지않고 window.open으로 새창 띄움 %>	
<!--#include virtual = "/login/Login_Kakao.asp"-->
<!--#include virtual = "/login/Login_Google.asp"-->
<!--#include virtual = "/login/Login_Facebook.asp"-->

<form id="frm_snslogin" name="frm_snslogin" method="POST">
	<input type="hidden" id="sns_id" name="sns_id" value="" />
	<input type="hidden" id="sns_nickname" name="sns_nickname" value="" />
	<input type="hidden" id="sns_email" name="sns_email" value="" />
	<input type="hidden" id="sns_gubun" name="sns_gubun" value="" />
	<input type="hidden" id="redir" name="redir" value="<%=site_Referer%>" />
	<input type="hidden" id="sitegubun" name="sitegubun" value="" />
</form>

<% 
'	sns_gubun = 가입사이트구분코드(C0063)
'	31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
%>