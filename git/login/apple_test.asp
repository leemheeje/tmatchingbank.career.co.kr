<!--#include virtual = "/common/common.asp"-->
<%

%>


<script type="text/javascript" src="https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js"></script>
<script type="text/javascript">

</script>



<div id="appleid-signin" data-color="black" data-border="true" data-type="sign in"></div>
<script type="text/javascript">
	AppleID.auth.init({
		clientId : '[CLIENT_ID]',
		scope : '[SCOPES]',
		redirectURI : '[REDIRECT_URI]',
		state : '[STATE]',
		nonce : '[NONCE]',
		usePopup : true //or false defaults to false
	});
</script>