<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 > 개인회원 가입/로그인 공용
' 	최초 작성일	: 
'	최초 작성자	: 
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

If InStr(site_Agent, "rv:11") Or InStr(site_Agent, "RV:11") Or InStr(site_Agent, "EDGE") Or InStr(site_Agent, "Chrome") Or InStr(site_Agent, "Safari") Or InStr(site_Agent, "SAFARI") Or InStr(site_Agent, "Firefox") Or InStr(site_Agent, "FIREFOX") Or InStr(site_Agent, "Opera") Or InStr(site_Agent, "OPERA") Then
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
				alert("Explorer 11 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
				return false;
			}
		} else if (gb == "NV") {
			if ('<%=apiTrueChk%>' == "True") {
				var params = "?gb=" + gb;
				window.open("/login/Default.asp" + params, "snslogin", "width=500,height=750,scrollbars=no,location=no").focus();
			} else {
				alert("Explorer 11 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
				return false;
			}
		} else if (gb == "FB") {
			if ('<%=apiTrueChk%>' == "True") {
				checkLoginState();
			} else {
				alert("Explorer 11 이상의 버전이나 크롬, 사파리 등에서 접속이 가능합니다.");
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
		} else if (gb == "AP") {
			$("#appleid-signin").click();
		}
	}

	function fn_snsReturnLogin() {
		var obj = document.frm_snslogin;
		obj.method = "post";
		obj.action = "/login/Login_SNS_Check.asp";
		obj.submit();
	}
</script>
<div class="sgTitle">SNS로 간편 로그인</div>
<div class="snsArea">
	<button class="snsBt naver" onclick="fn_openSNSLogin('NV');" id="nv_login" title="네이버"></button>
	<button class="snsBt facebook" onclick="fn_openSNSLogin('FB');" id="fb_login" title="페이스북"></button>
	<button class="snsBt kakao" onclick="fn_openSNSLogin('KO');" id="ko_login" title="카카오톡"></button>
	<button class="snsBt google" onclick="fn_openSNSLogin('GL');" id="gl_login" title="구글"></button>
	<!-- <button class="snsBt apple" onclick="fn_openSNSLogin('AP');" id="ap_login" title="애플"></button>
	<div id="appleid-signin" style ="display:none"></div> -->
</div>

