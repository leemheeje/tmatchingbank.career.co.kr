<%
'--------------------------------------------------------------------
'   회원 로그인
' 	최초 작성일	:
'	최초 작성자	:
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "로그인" ' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/auth/clearCookie.asp"-->
<%
Call Sub_clearCookie  ' 모든 쿠키 정보 초기화
g_LoginChk = 0

' 로그인 상태 접근 제한
'Dim strLink : strLink = "/"
'If request.Cookies("WKP")("id")<>"" Or request.Cookies("WKC")("id")<>"" Then
'		Call FN_alertLink("로그인 상태에서는 해당 페이지에 접근할 수 없습니다.\n로그아웃 후 이용 바랍니다.",strLink)
'End If

Dim p_logType	: p_logType		= request("logType")	' 로그인 유형(1: 개인, 2: 기업)
Dim f_hidRedir	: f_hidRedir	= Request("redir")		' 직전 페이지 정보(유입 경로 체크용)

If p_logType="" Then
	p_logType = "1"
End If

If Len(f_hidRedir)=0 Then
	f_hidRedir = site_Referer
Else
	f_hidRedir = f_hidRedir
End If

' 이전 경로가 기업회원 전용 메뉴일 경우 기업회원 로그인 탭으로 설정
If InStr(f_hidRedir, "/company/") > 0 Or InStr(f_hidRedir,"/biz/") > 0 Then
	p_logType = "2"
End If
%>
<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript">
	function fn_admin_login() {
		location.href = "/login/Login_Check_Admin.asp?redir=<%=f_hidRedir%>";
	}

	function fn_setType(logtype) {
		var obj = document.getElementById("frm_login");
		obj.hidLogType.value = logtype;
		fn_setDiv(logtype);
	}

	function fn_setDiv(logtype) {
		if(logtype != "1"){ // 1 : 개인, 2: 기업
			$("#tab_biz").attr('class','cssTp active');
			$("#tab_mem").attr('class','cssTp ');
			$('#snsLoginArea').css("display","none");
			$('#underlineArea').css("display","none");
			$('.fnDivisionSetType2').show();
		}else{
			$("#tab_biz").attr('class','cssTp ');
			$("#tab_mem").attr('class','cssTp active');
			$('#snsLoginArea').css("display","block");
			$("#underlineArea").css("display","block");
			$('.fnDivisionSetType2').hide();
		}
	}

	function fn_join() {
		var obj = document.getElementById("frm_login");
		logtype = obj.hidLogType.value;
		if (logtype == "2"){
			location.href = "/signup/Join_Biz.asp";
		}else{
			location.href = "/signup/Join_Member.asp";
		}
	}

	function fn_submit(evt) {
		if (event.keyCode == 13) {
			fn_validate(document.frm_login);
		}
	}

	function fn_validate(frm) {
		var obj			= frm;
		var loginType	= obj.hidLogType.value;

		if (loginType == ""){
			loginType = "1";
		}

		if (obj.txtId.value.length == 0) {
			alert("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return false;
		}

		if (obj.txtPass.value.length == 0) {
			alert("비밀번호를 입력해 주세요.");
			$("#txtPass").focus();
			return false;
		}

		if (obj.txtPass.value.length > 32) {
			alert("비밀번호를 올바르게 입력해 주세요.");
			$("#txtPass").focus();
			return false;
		}

		obj.hidLogType.value	= loginType;
		obj.action				= "Login_Check.asp";
		obj.submit();
	}

	$(document).ready(function(){
		if ("<%=p_logType%>"=="2"){
			$('.fnDivisionSetType2').show();
			fn_setType('2');
			fn_submit();
		}else{
			$('.fnDivisionSetType2').hide();
		}

		var key = getCookie("key");

		if(key != ""){
			$("#txtId").val(key);
			$("#chkSaveId").attr("checked", true);
		}

		$("#chkSaveId").change(function(){
			if($("#chkSaveId").is(":checked")){
				setCookie("key", $("#txtId").val(), 30);
			}else{
				deleteCookie("key");
			}
		});

		$("#txtId").keyup(function(){
			if($("#chkSaveId").is(":checked")){
				setCookie("key", $("#txtId").val(), 30);
			}
		});
	});

	//개인(1)/기업(2)에 따라 아이디/비밀번호 찾기 경로 설정
	function fn_find(obj) {
		var frm = document.getElementById("frm_login");
		logtype = frm.hidLogType.value;

		$(obj).attr('href','/search/Find_Id_User.asp');

		if(logtype == '2') {
			$(obj).attr('href','/search/Find_Id_Biz.asp');
		}
	}

	// 배너 클릭 이력 저장
	function fn_clicks(type, typeidx) {
		console.log(type+"---->"+typeidx);

		var deviceCk;

		if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent))
			deviceCk = "mo";
		else
			deviceCk = "pc"

		var userIdCk = '<%=user_id%>' != '' ? '<%=user_id%>' : '<%=com_id%>' != '' ? '<%=com_id%>' : ''

		var $form = $('<form></form>');
		$form.attr('action', '/Click_Log.asp');
		$form.attr('method', 'post');
		$form.appendTo('body');

		var bannerType		= $('<input type="hidden" id="bannerType" value="' + type + '" name="bannerType">');
		var bannerIdx		= $('<input type="hidden" id="bannerIdx" value="' + typeidx + '" name="bannerIdx">');
		var bannerDevice	= $('<input type="hidden" id="bannerDevice" value="' + deviceCk + '" name="bannerDevice">');
		var userId			= $('<input type="hidden" id="userId" value="' + userIdCk + '" name="userId">');

		$form.append(bannerType);
		$form.append(bannerIdx);
		$form.append(bannerDevice);
		$form.append(userId);
		$form.submit();
	}

/*
	//Listen for authorization success
	document.addEventListener('AppleIDSignInOnSuccess', function(data) {

			alert(1);
			//handle successful response
			var token = data.detail.authorization.id_token;
			//var base64Payload = token.split('.')[1];
			var base64Payload = JSON.parse(base64_url_decode(token.split(".")[1]));


			document.getElementById("frm_sns_ap").sns_id.value			= "AP" + base64Payload.sub.split('.').join('');javascript:
			document.getElementById("frm_sns_ap").sns_id_full.value		= "AP" + base64Payload.sub.split('.').join('');
			document.getElementById("frm_sns_ap").sns_email.value		= base64Payload.email;

			if (typeof data.detail.user !== "undefined")
			{
				document.getElementById("frm_sns_ap").sns_nickname.value	= data.detail.user.name.lastName + data.detail.user.name.firstName;
			}

			if (confirm('취업포털 커리어넷 사이트에 로그인 하시겠습니까?\n로그인 시 자동으로 이용약관 및 개인정보 취급방침에\n동의 처리됩니다.\n\n커리어넷은 만 15세 이상부터 이용 가능합니다.')){
				fn_submit_ap();
			}


	});
	//Listen for authorization failures
	document.addEventListener('AppleIDSignInOnFailure', function(error) {
		console.log(error);
		 //handle error.
	});
*/

	$(document).ready(function(){
		// 아이디란에 한글 입력 안되게 처리
		$("input[name=txtId]").keyup(function(event){
			if (!(event.keyCode >=37 && event.keyCode<=40)) {
				var inputVal = $(this).val();
				$(this).val(inputVal.replace(/[^a-z0-9]/gi,''));
			}
		});
	});
</script>
<!-- <meta name="appleid-signin-client-id" content="kr.co.career.login">
<meta name="appleid-signin-scope" content="name email">
<meta name="appleid-signin-redirect-uri" content="https://www.career.co.kr/login/Login.asp">
<meta name="appleid-signin-state" content="signin">
<meta name="appleid-signin-use-popup" content="true"> -->
</head>

<body>

	<style>
	.headerMainCont{display: none !important;}
	body { background: none !important; }
	</style>
	<!-- 상단 -->
	<!--#include virtual = "/common/gnb/gnb_main.asp"-->
	<link rel="stylesheet" href="/css/signin.css">
	<!-- 본문 -->
    <div id="container" class="container ">
        <div class="contents">
	        <div class="sdubContents">
				<!-- 로그인:S -->
				<div class="signin subpage">
					<div class="signInBoxArea">
						<div class="sgTit">로그인이 필요한 서비스입니다.</div>
						<div class="sgsTit">
							커리어 회원이 아니시면, 지금 <a href="/signup/Join_Member.asp" class="poi">회원가입</a>을 해주세요.
						</div>
						<div class="sgBoxWrap">
							<div class="sgLogBox">
								<!-- 탭:S -->
								<div class="cmmStateStepType2Wrap tp2 col2 MT35">
									<div class="cmmStateStepInner">
										<div id="tab_mem" class="cssTp active">
											<a href="#;" onclick="fn_setType('1');" class="cssTpBox">
												<div class="cssTit">개인회원</div>
											</a>
										</div>
										<div id="tab_biz" class="cssTp ">
											<a href="#;" onclick="fn_setType('2');" class="cssTpBox ">
												<div class="cssTit">기업회원</div>
											</a>
										</div>
									</div>
								</div>
								<!-- 탭:E -->
								<div class="compMsg fnDivisionSetType2">
									채용의 시작! <span class="colorOrg FWB">커리어와 함께하세요!</span>
								</div>
								<div class="sgFormArea MT40">
									<form method="post" id="frm_login" name="frm_login" onsubmit="return fn_validate(this);" class="fnCmmForm">
									<input type="hidden" id="redir" name="redir" value="<%=f_hidRedir%>">
									<input type="hidden" id="hidLogType" name="hidLogType" value="">

									<div class="inputGr">
										<input type="text" id="txtId" name="txtId" maxlength="20" placeholder="회원 아이디를 입력해 주세요" />
										<input type="password" id="txtPass" name="txtPass" maxlength="32" onkeyup="fn_submit(this);" placeholder="비밀번호를 입력해 주세요" />
									</div>
									<button onclick="return fn_validate(document.frm_login);" class="inBtn">로그인</button>
									<!-- <a href="javaScript:void(0);" onclick="return fn_admin_login();" class="">관리자 로그인 테스트</a> -->


									<div class="chkGr clearfix MT15">
										<div class="FLOATL">
											<div class="cmmInput radiochk inline tp99">
												<label>
													<input type="checkbox" id="chkAutoLogin" name="chkAutoLogin" value="Y" />
													<span class="lb">자동 로그인</span>
												</label>
											</div>
											<div class="cmmInput radiochk inline tp99">
												<label>
													<input type="checkbox" id="chkSaveId" name="chkSaveId" value="Y" />
													<span class="lb">아이디 저장</span>
												</label>
											</div>
										</div>
										<div class="FLOATR">
											<a href="#;" onclick="fn_join();" class="lic poi">회원가입</a>
											<a href="#;" onclick="fn_find(this);" class="lic ML10">아이디/비밀번호 찾기</a>
										</div>
									</div>
									</form>
								</div>
								<div class="sgHr MT20"></div>
								<!-- SNS선택:S -->
								<div id="snsLoginArea" class="sgSnsGroup MT15">
									<!--#include file = "../login/Login_SNS_Inc.asp"-->
									<!-- <div class="sgTitle">SNS로 간편 로그인</div>
									<div class="snsArea">
										<button class="snsBt naver" title="네이버"></button>
										<button class="snsBt facebook" title="페이스북"></button>
										<button class="snsBt kakao" title="카카오톡"></button>
										<button class="snsBt google" title="구글"></button>
									</div> -->
								</div>
								<!-- SNS선택:E -->
							</div>
							
						</div>
					</div>
				</div>
				<!-- 로그인:E -->
	        </div>
        </div>
    </div>
	<!-- //본문 -->

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

</body>
</html>
