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
<script type='text/javascript'>
	function b64DecodeUnicode(str) {
	    return decodeURIComponent(
			atob(str).replace(/(.)/g, function (m, p) {
				var code = p.charCodeAt(0).toString(16).toUpperCase();
				if (code.length < 2) {
					code = "0" + code;
				}
				return "%" + code;
			})
	    );
	}

	
	function base64_url_decode(str) {
		var output = str.replace(/-/g, "+").replace(/_/g, "/");
		switch (output.length % 4) {
		case 0:
			break;
		case 2:
			output += "==";
			break;
		case 3:
			output += "=";
			break;
		default:
			throw "Illegal base64url string!";
		}

		try {
			return b64DecodeUnicode(output);
		} catch (err) {
			return atob(output);
		}
	}




	function fn_submit_ap() {
		var obj = document.frm_sns_ap;
		obj.method = "post"
		obj.action = "/login/Login_SNS_Check.asp"
		obj.submit();
	}
</script>

<form name="frm_sns_ap" id="frm_sns_ap" method="POST">
	<input type="hidden" id="sns_id" name="sns_id" value="" />
	<input type="hidden" id="sns_nickname" name="sns_nickname" value="-" />
	<input type="hidden" id="sns_email" name="sns_email" value="-" />
	<input type="hidden" id="sns_gubun" name="sns_gubun" value="46" /> <!--애플 로그인API-->
	<input type="hidden" id="redir" name="redir" value="<%=site_Referer%>" />
	<input type="hidden" id="sitegubun" name="sitegubun" value="" />
	<input type="hidden" id="sns_id_full" name="sns_id_full" value="-" />
</form>
<%
'	sns_gubun = 가입사이트구분코드 (C0063)
'	31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북, 46: 애플
%>