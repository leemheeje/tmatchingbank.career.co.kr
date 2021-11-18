<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 - 페이스북 > 개인회원 가입/로그인 공용
' 	최초 작성일	: 2021-04-15
'	최초 작성자	: 이샛별
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<%
' SNS openAPI login 연동관련 api key 값 호출 > global.asa
Dim API_FB_KEY : API_FB_KEY = Application("API_FB_KEY")
%>
<script>
	window.fbAsyncInit = function() {
		FB.init({
			appId      : '<%=API_FB_KEY%>',
			cookie     : true,  // enable cookies to allow the server to access 
								// the session
			xfbml      : true,  // parse social plugins on this page
			version    : 'v2.5' // use graph api version 2.5
		});
	};

	// Load the SDK asynchronously
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/ko_KR/sdk.js";
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));


	//로그인 유무 체크
	function checkLoginState() {
		FB.login(function(response) {
			//    FB.getLoginStatus(function(response) {
			  statusChangeCallback(response);
		});
	}

	// This is called with the results from from FB.getLoginStatus().
	function statusChangeCallback(response) {
		if (response.status === 'connected') {
		  // 로그인 성공
			fbAPI();
		} else if (response.status === 'not_authorized') {
		  // api로그인 안되어있음
		  fb_login();
		  //document.getElementById('status').innerHTML = 'Please log ' + 'into this app.';
		} else {
			//sns로그인 안되어있음
			//fb_login();
		}
	}

	function fb_login() {
		FB.login(function(response) {
			if (response.status === 'connected') {
				fbAPI();
			} else if (response.status === 'not_authorized') {
			// The person is logged into Facebook, but not your app.
			} else {
			// The person is not logged into Facebook, so we're not sure if
			// they are logged into this app or not.
			}
		});
	}

	function fbAPI() {
		FB.api('/me', function(response) {
		//		alert(response.id);
		//		alert(response.name);
			var obj = document.frm_sns_fb;

			$.each(response, function(key, value) {
				if (key == "id"){
					obj.sns_id.value		= "FB" + value.substr(0,15);
					obj.sns_id_full.value	= "FB" + value;
					//document.getElementById("frm_sns_fb").sns_id.value = "FB" + value;
					//$("#sns_id").val("FB" + value);
				}else if (key == "name"){
					obj.sns_nickname.value = value;
					//document.getElementById("frm_sns_fb").sns_nickname.value = value;
					//$("#sns_nickname").val(value);
				}
			});

			if (confirm('취업포털 커리어넷 사이트에 로그인 하시겠습니까?\n로그인 시 자동으로 이용약관 및 개인정보 취급방침에\n동의 처리됩니다.\n\n커리어넷은 만 15세 이상부터 이용 가능합니다.')){
				fn_submit_fb();
			}else{
				FB.logout();
			}
		});
	}

	function fn_submit_fb() {
		var obj = document.frm_sns_fb;
		obj.method = "post";
		obj.action = "/login/Login_SNS_Check.asp";
		obj.submit();
	}
</script>

<form name="frm_sns_fb" id="frm_sns_fb" method="POST">
	<input type="hidden" id="sns_id" name="sns_id" value="" />
	<input type="hidden" id="sns_nickname" name="sns_nickname" value="" />
	<input type="hidden" id="sns_email" name="sns_email" value="" />
	<input type="hidden" id="sns_gubun" name="sns_gubun" value="34" />
	<input type="hidden" id="redir" name="redir" value="<%=site_Referer%>" />
	<input type="hidden" id="sitegubun" name="sitegubun" value="" />
	<input type="hidden" id="sns_id_full" name="sns_id_full" value="" /><%'페이스북 회신 아이디 전문%>
</form>
<%
'	sns_gubun = 가입사이트구분코드 (C0063)
'	31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
%>

<!--
  Below we include the Login Button social plugin. This button uses
  the JavaScript SDK to present a graphical Login button that triggers
  the FB.login() function when clicked.
-->

