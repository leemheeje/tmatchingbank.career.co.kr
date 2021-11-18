<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 - 네이버 > 개인회원 가입/로그인 공용
' 	최초 작성일	: 2021-04-15
'	최초 작성자	: 이샛별
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------
%>
<%
' SNS openAPI login 연동관련 api key 값 호출 > global.asa
Dim API_NV_KEY : API_NV_KEY = Application("API_NV_KEY")
%>
<meta charset="utf-8">

<script type="text/javascript" src="naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
<%If Request.ServerVariables("HTTPS") <> "on" Then%>
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>
<%Else%>
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<%End If%>

<!-- //네이버 아이디로 로그인 버튼 노출 영역 -->
<div id="naver_id_login" style="display:none"></div>
<div id="naver_id_login_test" style="display:none"></div>

<!-- 네이버 아이디로 로그인 초기화 Script -->
<script type="text/javascript">
	var str_host   = location.host;
	var naver_host_http;
	var naver_host_https;
	if (str_host == "www.career.co.kr") {
		naver_host_http		= "http://www.career.co.kr/login/Login_Naver.asp";
		naver_host_https	= "https://www.career.co.kr/login/Login_Naver.asp";
	}else {
		naver_host_http		= "http://career.co.kr/login/Login_Naver.asp";
		naver_host_https	= "https://career.co.kr/login/Login_Naver.asp";	
	}

<%If Request.ServerVariables("HTTPS") <> "on" Then%>
	var naver_id_login = new naver_id_login("<%=API_NV_KEY%>", naver_host_http);
<%Else%>
	var naver_id_login = new naver_id_login("<%=API_NV_KEY%>", naver_host_https);
<%End If%>
	var state = naver_id_login.getUniqState();
	naver_id_login.setButton("white", 2,40);
	naver_id_login.setDomain(".service.com");
	naver_id_login.setState(state);
//	naver_id_login.setPopup();
	naver_id_login.init_naver_id_login();
	naver_id_login.init_naver_id_login_function();

	$(document).ready(function() {
		if ('<%=gb%>' == 'NV'){
			document.location.href = $("#nvLoginUrl").val();
		}
	});
</script>
<!-- //네이버 아이디로 로그인 초기화 Script -->

<!-- 네이버 아이디로 로그인 Callback 페이지 처리 Script -->
<script type="text/javascript">
	// 네이버 사용자 프로필 조회
	naver_id_login.get_naver_userprofile("naverSignInCallback()");
	
	// 네이버 사용자 프로필 조회 이후 프로필 정보를 처리할 callback function
	function naverSignInCallback() {
		// naver_id_login.getProfileData('프로필항목명');
		// 프로필 항목은 개발가이드를 참고하시기 바랍니다.	
		$("#nv_sns_id").val("NV" + naver_id_login.getProfileData('id'));
		$("#nv_sns_nickname").val(naver_id_login.getProfileData('nickname'));
		$("#nv_sns_email").val(naver_id_login.getProfileData('email'));
		fn_submit();
	}

	function fn_submit() {
		var objF = opener.document.getElementById("frm_snslogin");
		objF.sns_id.value		= $("#nv_sns_id").val();
		objF.sns_nickname.value = $("#nv_sns_nickname").val();
		objF.sns_email.value	= $("#nv_sns_email").val();
		objF.sns_gubun.value	= "31";

		$("#sns_id", opener.document).val($("#nv_sns_id").val());
		$("#sns_nickname", opener.document).val($("#nv_sns_nickname").val());
		$("#sns_email", opener.document).val($("#nv_sns_email").val());
		$("#sns_gubun", opener.document).val("31");

		if (confirm('취업포털 커리어넷 사이트에 로그인 하시겠습니까?\n로그인 시 자동으로 이용약관 및 개인정보 취급방침에\n동의 처리됩니다.\n\n커리어넷은 만 15세 이상부터 이용 가능합니다.')){
			opener.fn_snsReturnLogin();
		}
		self.close();
	}
</script>
<!-- //네이버 아이디로 로그인 Callback 페이지 처리 Script -->
<html>
<body>
<form name="frm_sns_nv" id="frm_sns_nv" method="POST">
	<input type="hidden" id="nv_sns_id" name="nv_sns_id" value="" />
	<input type="hidden" id="nv_sns_nickname" name="nv_sns_nickname" value="" />
	<input type="hidden" id="nv_sns_email" name="nv_sns_email" value="" />
	<input type="hidden" id="nv_sns_gender" name="nv_sns_gender" value="" />
	<input type="hidden" id="nv_sns_age" name="nv_sns_age" value="" />
	<input type="hidden" id="nv_sns_birthday" name="nv_sns_birthday" value="" />
	<input type="hidden" id="nv_sns_profile_image" name="nv_sns_profile_image" value="" />
</form>
</body>
</html>
<%
'	sns_gubun = 가입사이트구분코드 (C0063)
'	31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
%>