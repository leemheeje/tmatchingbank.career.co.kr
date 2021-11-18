<%
'--------------------------------------------------------------------
'   SNS 간편 로그인 - 카카오 > 개인회원 가입/로그인 공용
' 	최초 작성일	:
'	최초 작성자	:
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------
%>
<%
' SNS openAPI login 연동관련 api key 값 호출 > global.asa
Dim API_KO_KEY : API_KO_KEY = Application("API_KO_KEY")
%>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type='text/javascript'>
    // 사용할 앱의 JavaScript 키를 설정해 주세요.
    Kakao.init('<%=API_KO_KEY%>');

	// 로그인 호출
    function loginWithKakao() {
      Kakao.Auth.login({	// 로그인 창을 띄웁니다.
        success: function(authObj) {
			Kakao.API.request({
			  url: '/v2/user/me',
			  data: { secure_resource: true },
			  success: function(res) {
				$.each(res, function(key, value) {
					if (key == "id"){
                        console.log(document.getElementById("frm_sns_ko"));
						document.getElementById("frm_sns_ko").sns_id.value = "KO" + value;
						//$("#sns_id").val("KO" + value)
					}else if (key == "properties"){
						$.each(res.properties, function(key, value) {
							if (key == "nickname"){
								document.getElementById("frm_sns_ko").sns_nickname.value = value;
								//$("#sns_nickname").val(value)
							}
							if (key == "email"){
								document.getElementById("frm_sns_ko").sns_nickname.value = value;
								$("#sns_email").val(value)
							}
						});
					}
				});

				if (document.getElementById("frm_sns_ko").sns_nickname.value == "") {
					document.getElementById("frm_sns_ko").sns_nickname.value = "이름없음";
				}

				if (confirm('취업포털 커리어넷 사이트에 로그인 하시겠습니까?\n로그인 시 자동으로 이용약관 및 개인정보 취급방침에\n동의 처리됩니다.\n\n커리어넷은 만 15세 이상부터 이용 가능합니다.')) {
					fn_submit_ko();
				}
				else {
					//카카오 로그아웃
					Kakao.Auth.logout();
				}
			  },
			  fail: function(error) {
				alert(JSON.stringify(error));
			  }
			});
        },
        fail: function(err) {
          alert(JSON.stringify(err));
        }
      });
    };

	function fn_submit_ko() {
		var obj = document.frm_sns_ko;
		obj.method = "post"
		obj.action = "/login/Login_SNS_Check.asp"
		obj.submit();
	}
</script>
<form name="frm_sns_ko" id="frm_sns_ko" method="POST">
    <input type="hidden" id="sns_id" name="sns_id" value="" />
	<input type="hidden" id="sns_nickname" name="sns_nickname" value="" />
	<input type="hidden" id="sns_email" name="sns_email" value="" />
	<input type="hidden" id="sns_gubun" name="sns_gubun" value="32" />
	<input type="hidden" id="redir" name="redir" value="<%=site_Referer%>" />
	<input type="hidden" id="sitegubun" name="sitegubun" value="" />
</form>
<%
'	sns_gubun = 가입사이트구분코드 (C0063)
'	31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북
%>
