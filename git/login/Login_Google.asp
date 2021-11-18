<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 - 구글 > 개인회원 가입/로그인 공용
' 	최초 작성일	: 
'	최초 작성자	: 
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<%
' SNS openAPI login 연동관련 api key 값 호출 > global.asa
Dim API_GL_KEY : API_GL_KEY = Application("API_GL_KEY")
%>
<script src="https://apis.google.com/js/api:client.js"></script>
<script>
	var googleUser = {};

	var startApp = function(v) {
		// 메인 우측 상단 SNS 아이콘 중복 표기로 인한 호출 정보 체크 > gl_login2=/include/main/Login_Inc.asp, gl_login3=/common/footer_main.asp 에 존재, 나머지는 gl_login 로 사용
		var req_snsid;
		if (v == undefined){
			req_snsid = "gl_login";
		}else if (v == ""){
			req_snsid = "gl_login";
		}else if (v == "2"){
			req_snsid = "gl_login2";
		}else if (v == "3"){
			req_snsid = "gl_login3";
		}

		gapi.load('auth2', function() {
			auth2 = gapi.auth2.init({
				client_id: '<%=API_GL_KEY%>',
				cookiepolicy: 'single_host_origin',
			});
			attachSignin(document.getElementById(req_snsid));
		});
	};

	function attachSignin(element) {

		auth2.attachClickHandler(element, {},

		function(googleUser) {
			var profile		= googleUser.getBasicProfile();
			var get_id		= profile.getId();
			var get_name	= profile.getName();
			var get_email	= profile.getEmail();

			document.getElementById("frm_sns_gl").sns_id.value			= "GL" + get_id.substr(0,13) + get_email.substr(0,2);
			document.getElementById("frm_sns_gl").sns_id_full.value		= "GL" + get_id;
			document.getElementById("frm_sns_gl").sns_nickname.value	= get_name;
			document.getElementById("frm_sns_gl").sns_email.value		= get_email;

			if (confirm('취업포털 커리어넷 사이트에 로그인 하시겠습니까?\n로그인 시 자동으로 이용약관 및 개인정보 취급방침에\n동의 처리됩니다.\n\n커리어넷은 만 15세 이상부터 이용 가능합니다.')){
				fn_submit_gl();
			}else{
				signOut();
			}
		}, function(error) {
			signOut();
	//		alert(JSON.stringify(error, undefined, 2));
		});
	}

	// 메인 우측 상단 및 푸터 영역 SNS 아이콘 중복 표기로 인한 파라메터 개별 호출
	if ('<%=apiTrueChkGL%>' == "True"){
		//startApp();
		startApp('');
		startApp('2');
		startApp('3');
	}

	function signOut() {
		var auth2 = gapi.auth2.getAuthInstance();
		auth2.signOut().then(function () {
		});
	}

	function fn_submit_gl() {
		var obj = document.frm_sns_gl;
		obj.method = "post"
		obj.action = "/login/Login_SNS_Check.asp"
		obj.submit();
	}
</script>

<form name="frm_sns_gl" id="frm_sns_gl" method="POST">
	<input type="hidden" id="sns_id" name="sns_id" value="" />
	<input type="hidden" id="sns_nickname" name="sns_nickname" value="" />
	<input type="hidden" id="sns_email" name="sns_email" value="" />
	<input type="hidden" id="sns_gubun" name="sns_gubun" value="33" />
	<input type="hidden" id="redir" name="redir" value="<%=site_Referer%>" />
	<input type="hidden" id="sitegubun" name="sitegubun" value="" />
	<input type="hidden" id="sns_id_full" name="sns_id_full" value="" /><%'구글 회신 아이디 전문%>
</form>
<%
'	sns_gubun = 가입사이트구분코드 (C0063)
'	31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
%>