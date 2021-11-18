<%
'--------------------------------------------------------------------
'   Comment		: 회원가입 > 개인회원
' 	History		: 2021-04-13, 이샛별
'   DB TABLE	: dbo.개인회원정보
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
' 로그인 상태 접근 제한
Dim strLink : strLink = "/"
If g_LoginChk<>"0" Then
		Call FN_alertLink("로그인 상태에서는 해당 페이지에 접근할 수 없습니다.\n로그아웃 후 이용 바랍니다.",strLink)
End If

' 공통파일 함수 호출 > /wwwconf_renew/function/common/common_function.asp
Dim arrMailInitial : arrMailInitial	= FN_get_email_initial	' 이메일 주소 배열
%>
<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript">
    $(document).ready(function(){
        var $chkAgrPer1		= $('#chkAgrPer1');		//약관동의체크
        var $chkAgrPer2		= $('#chkAgrPer2');		//개인정보체크
        var $chkAgrPerAll	= $('#chkAgrPerAll');	//모두동의체크
        var isAllCheck = function(){
            if($chkAgrPer1.is(':checked') && $chkAgrPer2.is(':checked')){
                $chkAgrPerAll.prop('checked', true);
                return true;
            }else{
                $chkAgrPerAll.prop('checked', false);
                return false;
            }
        }
        $chkAgrPer1.change(isAllCheck);
        $chkAgrPer2.change(isAllCheck);
        $chkAgrPerAll.change(function(){
            var isChecked = $(this).is(':checked');
            $chkAgrPer1.prop('checked', isChecked);
            $chkAgrPer2.prop('checked', isChecked);
        });
        var dialogagr1_bool = true;
        $('.fnDialogagr1').click(function(){ //약관동의 팝업
            $('[data-layerpop="dialogagr1"]').cmmLocLaypop({
                title: '이용약관 동의',
                beforeCallback: function($el) {
                    if(dialogagr1_bool){
                        var $closest = $('[data-layerpop="dialogagr1"]');
                        var _text = $closest.find('.fnCmmInnerScrollJoinAgree').text();
                        $closest.find('.fnCmmInnerScrollJoinAgree').html(_text);
                        dialogagr1_bool = false;
                    }
                },
                afterCallback: function($el) {
                    $('.fnCmmInnerScrollJoinAgree').cmmInnerScroll();
                },
                submit: function($this) {
                    $this.cmmLocLaypop('close');
                    $chkAgrPer1.prop('checked', true).trigger('change');
                },
            });
        });

        var dialogagr2_bool = true;
        $('.fnDialogagr2').click(function(){//개인정보 수집 및 이용 동의 팝업
            $('[data-layerpop="dialogagr2"]').cmmLocLaypop({
                title: '개인정보 수집 및 이용 동의',
                beforeCallback: function($el) {
                    if(dialogagr2_bool){
                        var $closest = $('[data-layerpop="dialogagr2"]');
                        var _text = $closest.find('.fnCmmInnerScrollJoinAgree').text();
                        $closest.find('.fnCmmInnerScrollJoinAgree').html(_text);
                        dialogagr2_bool = false;
                    }
                },
                afterCallback: function($el) {
                    $('.fnCmmInnerScrollJoinAgree').cmmInnerScroll();
                },
                submit: function($this) {
                    $this.cmmLocLaypop('close');
                    $chkAgrPer2.prop('checked', true).trigger('change');
                },
            });
        });
    });

	// SMS 인증 번호 전송
	/* start */
	function fnAuthSms() {
		if ($("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		}

		$("#hd_idx").val("");

		var strEmail;
		var contact = $("#txtPhone").val();

		if (Authchk_ing) {
			alert("처리중 입니다. 잠시만 기다려 주세요.");
		} else {
			if(contact=="“-” 생략하고 숫자만 입력해 주세요."){
				contact="";
			}

			if(contact==""){
				alert("연락처를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}

			if(contact.length<10){
				alert("정확한 연락처를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}
			else {
				Authchk_ing = true;

				var strUrl = "https://app.career.co.kr/sms/career/Authentication";

				var parm = {};

				parm.authCode	= "1";					// sms:1 | email:2
				parm.authvalue	= $("#txtPhone").val();	// 핸드폰 no( - 는 입력 해도 되고 안해도 됩니다.)
				parm.sitename	= "취업포털 커리어";	// sms 발송시 해당 내용으로 입력 됩니다.
				parm.sitecode	= "2";	// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)
				parm.memkind	= "개인";
				parm.ip			= "";		// 개인 IP
				parm.callback	= "jsonp_sms_callback";

				$("#aMobile").text("인증번호 재전송");
				$.ajax({
					url: strUrl
					, dataType: "jsonp"
					, type: "post"
					, data: parm
					, success: function (data) {
						//alert("sccess : " + data.length);
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						//alert(textStatus + ", " + errorThrown);
					}
				});
			}
		}
	}

	// Result 처리는 이곳에서 합니다.
	function jsonp_sms_callback(data) {
		Authchk_ing = false;
		if ($.trim(data.result) == "true") {
			$("#mobileAuthNumChk").val("1");

			$("#timeCntdown").show();
			fnDpFirst();
			fncDpTm(); //카운트

			$("#hd_idx").val(data.result_idx);
			alert("인증번호가 발송되었습니다.");
			$("#rsltAuthArea").show();
			$("#mobileAuthNumber").val("");
			$("#mobileAuthNumber").focus();
			$("#hd_kind").val("1");
		} else {
			$("#timeCntdown").hide();
			$("#rsltAuthArea").hide();
			$("#emailAuthNumChk").val("0");
			alert("인증번호 발송이 실패하였습니다.");
		}
	}
	/* end */

	// 인증번호 확인
	/* start */
	function fnAuth() {
		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		} else if ($.trim($("#hd_idx").val()) == "") {
			alert("인증번호가 맞지 않습니다. 인증번호를 확인해 주세요.");
			return;
		}

		$("#mobileAuthNumber").val($.trim($("#mobileAuthNumber").val()));
		if  ($("#hd_kind").val() == "1") {
			if ($.trim($("#mobileAuthNumber").val()) == "") {
				alert("인증번호를 입력해 주세요.");
				$("#mobileAuthNumber").focus();
				return;
			}
		}

		var strUrl	= "https://app.career.co.kr/sms/career/AuthenticationResult";
		var parms	= {};

		var strAuthKey = "";
		if ($("#hd_kind").val() == "2") {
			strAuthKey = $("#emailAuthNumber").val();
		} else if ($("#hd_kind").val() == "1") {
			strAuthKey = $("#mobileAuthNumber").val();
		} else {
			return;
		}

		if ($.trim($("#hd_idx").val()) == "" || ($.trim($("#emailAuthNumber").val()) == "" && $.trim($("#mobileAuthNumber").val()) == "")) {
			return;
		}

		parms.authCode	= $("#hd_kind").val();	// sms:1 | email:2

		parms.authvalue	= strAuthKey;			// 발송된 인증 KEY Value

		parms.idx		= $("#hd_idx").val();	// 발송된 인증 번호
		parms.callback	= "jsonp_result_callback";
		$.ajax({
			url: strUrl
				, dataType: "jsonp"
				, type: "post"
				, data: parms
				, success: function (data) {
					//alert("sccess : " + data.length);
				}
				, error: function (jqXHR, textStatus, errorThrown) {
					//alert(textStatus + ", " + errorThrown);
				}
		});
	}

	//Result 처리는 이곳에서 합니다.
	function jsonp_result_callback(data) {
		if ($("#hd_kind").val() == "1") {
			if ($.trim(data.result_idx) == "Y") {
				$("#mobileAuthNumChk").val("4");
				$("#rsltMsg_S").show();
				$("#authproc").val("1");
				$("#timeCntdown").hide();
				$("#rsltMsg_F").hide();
			} else {
				$("#mobileAuthNumChk").val("3");
				$("#rsltMsg_S").hide();
				$("#timeCntdown").show();
				$("#rsltMsg_F").show();
			}
		}
	}
	/* end */

	var emailchk_ing	= false;
	var Authchk_ing		= false;

	var min = 60;
	var sec = 60;
	var ctm;			// 표시 시간
	var inputtime = 3;	// 입력분
	var tstop;			// 타이머 정지

	Number.prototype.dptm = function () { return this < 10 ? '0' + this : this; } //분에 "0" 넣기

	function fnDpFirst() {
		clearTimeout(tstop);
		ctm = sec * inputtime;
	}

	function fncDpTm() {
		var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
		var csc = Math.floor(ctm % sec).dptm();

		//document.getElementById("ctm1").innerText = cmi + ' : ' + csc; //값 보여줌
		//document.getElementById("").innerText = '남은시간 ' + cmi + ' : ' + csc; //값 보여줌
		$("#timeCntdown em:eq(0)").text('(' + cmi + ' : ' + csc + ")");
		if ((ctm--) <= 0) {
			ctm = sec * inputtime;
			clearTimeout(tstop);
			//재전송버튼
			//인증시간 초과 meassage
		}
		else {
			tstop = setTimeout("fncDpTm()", 1000);
		}
	}

	// 인증번호 검증 함수 호출
	function fnAuthNoChk(){
		fnAuth();
	}

	// 휴대폰번호 유효성 검증
	function fn_phoneCertifi(){
		if($("#txtPhone").val()=="“-” 생략하고 숫자만 입력해 주세요."){
			$("#txtPhone").val("");
		}

		if($("#txtPhone").val()==""){
			alert("연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return false;
		}

		if($("#txtPhone").val().length<10){
			alert("정확한 연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return false;
		} else {
			fnAuthSms();
		}
	}

	//메일주소 자동 입력
	function fn_ChangeMail(v) {
		var obj=document.frm_memInfo;
		if(v=="x"){
			$("#txtEmail2").val("");
			$("#txtEmail2").focus();
		} else {
			$("#txtEmail2").val(v);
		}
	}

	// 날짜 체크 후 하이픈 연결 - yyyymmdd → yyyy-mm-dd
	function fn_changeDateType(obj) {
		temp_value = obj.value.toString().replace("-", "");

		if (temp_value.length == 8) {
			obj.value = temp_value.substr(0, 4) + "-" + temp_value.substr(4, 2) + "-" + temp_value.substr(6, 2);
		}
	}

	// 가입 정보 입력 값 유효성 체크
	function fn_Sumbit_memJoin(type){
		var txtId			= $("#txtId").val();		// 아이디
		var txtPass			= $("#txtPass").val();		// 비번
		var txtPassChk		= $("#txtPassChk").val();	// 비번확인
		var	txtName			= $("#txtName").val();		// 이름
		var	txtBirth		= $("#txtBirth").val();		// 생년월일
		var email_id		= $("#txtEmail1").val();	// 이메일 앞자리
		var email_domain	= $("#txtEmail2").val();	// 이메일 뒷자리
		var txtPhone		= $("#txtPhone").val();		// 휴대폰
		var chkAgrPrv		= $("#chkAgrPerAll").is(":checked");	// 이용약관 및 개인정보 수집 동의

		if(txtId==""){
			alert("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}

		if($("#id_box").text()!="사용 가능한 아이디입니다."){
			alert("아이디를 다시 확인해 주세요.");
			$("#txtId").focus();
			return;
		}

		if(txtPass==""){
			alert("비밀번호를 입력해 주세요.");
			$("#txtPass").focus();
			return;
		}

		if($("#pw_box").text()!=""){
			alert("입력하신 비밀번호가 보안상 매우 취약합니다.\n8~16자까지 영문, 숫자, 특수문자 등의 조합으로\n아이디와 무관한 문자열을 입력해 주세요.");
			$("#txtPass").focus();
			return;
		}

		if(txtPassChk==""){
			alert("비밀번호 확인란을 입력해 주세요.");
			$("#txtPassChk").focus();
			return;
		}

		if(txtPassChk!=txtPass){
			alert("비밀번호와 비밀번호 확인란에 입력한 정보가\n일치하지 않습니다. 다시 확인해 주세요.");
			$("#txtPassChk").focus();
			return;
		}

		if(txtName==""){
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if(!txtBirth) {
			alert("생년월일을 입력해 주세요.");
			$("#txtBirth").focus();
			return;
		}

		var birth_value		= txtBirth.replace(/-/gi, "");
		var rxDatePattern	= /^(\d{4})(\d{1,2})(\d{1,2})$/;	// Declare Regex
		var dtArray			= birth_value.match(rxDatePattern);	// is format OK?

		if (birth_value.length < 8) {
			alert("생년월일을 정확히 입력해 주세요.");
			$("#txtBirth").focus();
			return false;
		}else{

			//Checks for yyyymmdd format.
			dtYear	= dtArray[1];
			dtMonth = dtArray[2];
			dtDay	= dtArray[3];

			var today	= new Date();
			var year_n  = today.getFullYear();		// 현재연도
			var year_s  = today.getFullYear()-80;	// 출생연도 입력 허용 시작지점 80세로 설정
			var year_e  = today.getFullYear()-14;	// 출생연도 입력 허용 마감지점 근로기준법 기준 최저취업연령(만 15세) 고정
			var month	= today.getMonth()+1;		// 현재 월

			if (dtYear < year_s || dtYear > year_e){
				alert("생년월일이 유효하지 않습니다.\n("+year_s+"~"+year_e+"년도 사이의 숫자만 입력 가능)\n근로기준법 기준 최저취업연령인 만 15세 미만은 가입할 수 없습니다.");
				return false;
			}

			if (dtYear == year_n && dtMonth > month){
				alert("현재일자보다 미래의 날짜로 생년월일이 입력되었습니다.\n다시 확인해 주세요.");
				return false;
			}

			if (dtMonth < 1 || dtMonth > 12){
				alert("태어난 월이 유효하지 않습니다.");
				return false;
			}

			if (dtDay < 1 || dtDay > 31){
				alert("태어난 일이 유효하지 않습니다.");
				return false;
			}

			if (dtMonth == 2) {
				var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
				if (dtDay > 29 || (dtDay == 29 && !isleap)){
					alert(dtYear+"년 2월의 마지막 날짜는 28일 입니다.");
					return false;
				}
			}
		}

		if(!email_id) {
			alert("이메일 정보를 입력해 주세요.");
			$("#txtEmail1").focus();
			return false;
		}

		if(!email_domain) {
			alert("이메일 주소를 입력해 주세요.");
			$("#txtEmail2").focus();
			return false;
		}

		var email_rule =/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var mail = "";
		mail = email_id+"@"+email_domain;
		$("#mail").val(mail);

		if(!email_rule.test(mail)) {
			alert("이메일을 형식에 맞게 입력해 주세요.");
			$("#txtEmail1").focus();
			return false;
		}

		if($("#mail_box").text()=="잘못된 이메일 형식입니다."){
			alert("이메일을 다시 확인해 주세요.");
			$("#mail_box").focus();
			return;
		}

		if(txtPhone==""){
			alert("휴대폰번호를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			alert("휴대폰번호를 인증하셔야 가입이 가능합니다.");
			$("#txtPhone").focus();
			return;
		}

		if(chkAgrPrv){
			var obj=document.frm_mem;
			if(confirm('입력하신 정보로 회원 가입 하시겠습니까?')) {
				obj.method = "post";
				obj.action = "Join_Member_Proc.asp";
				obj.submit();
			}
		}else{
			alert("개인정보 수집 및 이용에 동의해 주세요.");
			return;
		}
	}

	// 문자 체크
	var num		= "0123456789";
	var alpha	= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var etc		= "-_.!@#$%^&*?~";
	function Validchar(g, str) {
		for (var i = 0; i < g.length; i++) {
			if (str.indexOf(g.charAt(i)) == -1)
				return false;
		}
		return true;
	}

	/*아이디 중복 체크 시작*/
	function fn_checkID() {
		$("#txtId").val($("#txtId").val().toLowerCase());

		$("#id_box").text("");
		$("#id_check").val("0");

		var checkNumber		= $("#txtId").val().search(/[0-9]/g);	// 숫자 입력 체크
		var checkEnglish	= $("#txtId").val().search(/[a-z]/ig);	// 영문 입력 체크

		if($("#txtId").val() == ""){
			$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
			$("#id_box").text("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}else if(!Validchar($("#txtId").val(), num + alpha)){
			$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
			$("#id_box").text("아이디는 한글 및 특수문자를 지원하지 않습니다. 다시 입력해 주세요.");
			$("#txtId").focus();
			return;
		}else if($("#txtId").val().length < 5){
			$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
			$("#id_box").text("아이디는 최소 5자 이상이어야 합니다.");
			return;
		}else if(checkNumber <0 || checkEnglish <0){
			$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
			$("#id_box").text("영문과 숫자를 혼용하여 입력해 주세요.");
			return;
		}else{
			if (/(\w)\1\1\1/.test($("#txtId").val())){	// 같은 형식 문자 4글자 이상 사용 금지
				$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
				$("#id_box").text("동일한 문자 연속 4글자 이상은 사용 금지합니다.");
				return;
			} else {
				$.ajax({
					type: "POST"
					, url: "Id_CheckAll.asp"
					, data: { user_id: $("#txtId").val() }
					, dataType: "text"
					, async: true
					, success: function (data) {
						// 기존 등록된 아이디가 존재하면 F, 없으면 S
						if (data.trim() == "F") {
							$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
							$("#id_box").text("탈퇴한 아이디 또는 이미 사용중인 아이디로, 이용하실 수 없습니다.");
							return;
						} else {
							$("#id_check").val("1");
							$("#chk_id").val($("#txtId").val());
							$("#id_box").addClass(' colorBlue').removeClass(' colorRed');
							$("#id_box").text("사용 가능한 아이디입니다.");
							return;
						}
					}
					, error: function (XMLHttpRequest, textStatus, errorThrown) {
						alert(XMLHttpRequest.responseText);
					}

				});
			}
		}
	}
	/*아이디 중복 체크 끝*/

	/*비밀번호 체크 시작*/
	function fn_checkPW() {
		var chk = false;
		var id	= $("#txtId").val();
		if ($('#txtPass').val().length == 0 ) {
			return;
		} else {
			if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 16) {
				$("#pw_box").text("비밀번호는 8~16자 까지만 허용됩니다.");
				return false;
			}

			if (id != "" && $('#txtPass').val().search(id) > -1) {
				$("#pw_box").text("비밀번호에 아이디가 포함되어 있습니다.");
				return false;
			}

/*
var SamePass_0 = 0; //동일문자 카운트
var SamePass_1 = 0; //연속성(+) 카운드
var SamePass_2 = 0; //연속성(-) 카운드

var chr_pass_0;
var chr_pass_1;

for(var i=0; i < $('#txtPass').val().length; i++) {
	chr_pass_0 = $('#txtPass').val().charAt(i);
	chr_pass_1 = $('#txtPass').val().charAt(i+1);

	//동일문자 카운트
	if(chr_pass_0 == chr_pass_1) {
		SamePass_0 = SamePass_0 + 1
	}


	//연속성(+) 카운트
	if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == 1) {
		SamePass_1 = SamePass_1 + 1
	}

	//연속성(-) 카운트
	if(chr_pass_0.charCodeAt(0) - chr_pass_1.charCodeAt(0) == -1) {
		SamePass_2 = SamePass_2 + 1
	}
}

if(SamePass_0 > 3) {
	$("#pw_box").text("동일 문자 반복 3글자 이상은 사용할 수 없습니다.");
	return false;
}

if(SamePass_1 > 3 || SamePass_2 > 3)  {
	$("#pw_box").text("연속된 문자열(123 또는 321, abc 등) 3글자 이상은 사용할 수 없습니다.");
	return false;
}
*/

			var pattern1 = /[0-9]/;		// 숫자
			var pattern2 = /[a-zA-Z]/;	// 문자
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
			if(!pattern1.test($('#txtPass').val()) || !pattern2.test($('#txtPass').val()) || !pattern3.test($('#txtPass').val())) {
				$("#pw_box").text("비밀번호는 영문, 숫자 및 특수문자의 조합으로 생성해야 합니다");
				return;
			}else{
				if(id != "" && $('#txtPass').val().search(id) > -1) {
					$("#pw_box").text("비밀번호에 아이디가 포함되어 있습니다.");
					return false;
				}else{
					$("#pw_box").text("");
				}
			}
		}

		if ($('#txtPassChk').val().split(" ").join("") == "") {
			$("#pw_box2").text("비밀번호 확인을 입력해 주세요.");
			return;
		}

		if ($('#txtPass').val() != $('#txtPassChk').val()) {
			$("#pw_box2").text("비밀번호가 일치하지 않습니다.");
			return;
		} else {
			$("#pw_box").text("");
			$("#pw_box2").text("");
		}
		return chk;
	}
	/*비밀번호 체크 끝*/

	// 입력값 체크
	$(document).ready(function () {
		//아이디 중복 체크
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// 비번 유효성 체크
		$("#txtPass").bind("keyup keydown", function () {
			$(this).attr('type', 'password');
			fn_checkPW();
		});

		// 비번 재확인 유효성 체크
		$("#txtPassChk").bind("keyup keydown", function () {
			fn_checkPW();
		});
	});
</script>
</head>

<body>

	<div id="header" class="header subpage headerFixed"></div>

	<!-- 본문 -->
    <div id="container" class="container gray">
        <div class="contents">
            <div class="signup subpage">

				<div class="subContents isHeaderFixed MT60">
                    <div class="innerWrap">
                        <div class="signupWrap">
                            <div class="signupInner">
                                <div class="signCont MT30">
                                    <div class="signContInner">
                                        <div class="cmmCard sm">
                                            <div class="signTop MT20 clearfix">
                                                <div class="FLOATL">
                                                    <a href="/" class="logo BLOCK"><img src="/images/logo.png" alt="" /></a>
                                                </div>
                                                <div class="FLOATR MT20">
                                                    <a href="/" class="FONT14 colorGry VMIDDLE">홈</a>
                                                    <span class="cmmHr line vertical VMIDDLE ML05 MR05"></span>
                                                    <a href="javascript:alert('준비 중 입니다.');" class="FONT14 colorGry VMIDDLE">고객센터</a>
                                                </div>
                                            </div>
                                            <div class="cmmHr line2 MT15"></div>
                                            <div class="cmmStateStepType2Wrap col2 sm MT30">
                                                <div class="cmmStateStepInner">
                                                    <div class="cssTp active">
                                                        <a href="#" class="cssTpBox">
                                                            <div class="cssTit paddingnone FONT20">개인회원</div>
                                                        </a>
                                                    </div>
                                                    <div class="cssTp ">
                                                        <a href="Join_Biz.asp" class="cssTpBox">
                                                            <div class="cssTit paddingnone FONT20">기업회원</div>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>

											<%'SNS 간편 로그인 영역 호출%>
											<!--#include file = "../login/Login_SNS_Inc.asp"-->

                                            <form method="post" name="frm_mem" class="fnCmmForm">
											<input type="hidden" id="id_check" name="id_check" value="" /><%'아이디 검증 여부(0/1)%>
											<input type="hidden" id="chk_id" name="chk_id" value=""><%'사용(입력) 아이디%>
											<input type="hidden" id="hd_idx" name="hd_idx" value="" /><%'번호인증 idx%>
											<input type="hidden" id="mobileAuthNumChk" name="mobileAuthNumChk" value="0" />
											<input type="hidden" id="hd_kind" name="hd_kind" value="2" />
											<input type="hidden" id="authproc" name="authproc" value="" />

											<input type="password" id="tempPwd" name="tempPwd" style="display:none;"/>
											<input type="text" id="tempId" name="tempId" style="display:none;"/>

                                                <div class="crow sm">

                                                    <div class="ccol12 MT80">
                                                        <div class="cmmTit sm colorBlack">회원가입</div>
                                                        <div class="FONT15 colorGry MT05">아래 회원정보를 입력하시면 커리어 회원으로 가입이 완료됩니다.</div>
                                                        <div class="cmmHr line1 MT15"></div>
                                                    </div>
                                                    <div class="ccol12 MT20">
                                                        <div class="cmmInput ciCol">
                                                            <label for="" class="lb required">아이디</label>
                                                            <div class="ip">
                                                                <input type="text" id="txtId" name="txtId" maxlength="12" placeholder="아이디 (5~12자 영문, 숫자 입력)" autocomplete="off" />
                                                            </div>
                                                            <div id="id_box" class="FONT12 colorRed"></div>
                                                        </div>
                                                    </div>
                                                    <div class="ccol12">
                                                        <div class="cmmInput ciCol">
                                                            <label for="" class="lb required">비밀번호</label>
                                                            <div class="ip">
                                                                <input type="password" id="txtPass" name="txtPass" maxlength="16" placeholder="비밀번호 (8~16자 영문, 숫자 입력)" autocomplete="off" />
                                                            </div>
                                                            <div id="pw_box" class="FONT12 colorRed"></div>
                                                        </div>
                                                    </div>
                                                    <div class="ccol12">
                                                        <div class="cmmInput ciCol">
                                                            <label for="" class="lb required">비밀번호 확인</label>
                                                            <div class="ip">
                                                                <input type="password" id="txtPassChk" name="txtPassChk" maxlength="16" placeholder="비밀번호 확인" autocomplete="off" />
                                                            </div>
                                                            <div id="pw_box2" class="FONT12 colorRed"></div>
                                                        </div>
                                                    </div>
                                                    <div class="ccol12">
                                                        <div class="cmmInput ciCol">
                                                            <label for="" class="lb required">이름</label>
                                                            <div class="ip">
                                                                <input type="text" id="txtName" name="txtName" maxlength="15" placeholder="이름 (실명입력)" autocomplete="off" />
                                                            </div>
                                                            <div id="nm_box" class="FONT12 colorRed"></div>
                                                        </div>
                                                    </div>
                                                    <div class="ccol6 VMIDDLE">
                                                        <div class="cmmInput ciCol">
                                                            <label for="" class="lb ">생년월일</label>
                                                            <div class="ip">
                                                                <input type="text" id="txtBirth" name="txtBirth" maxlength="8" onkeyup="fn_num_chk(this, 'int'); fn_changeDateType(this);" placeholder="YYYY-MM-DD" autocomplete="off" />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ccol6 VMIDDLE">
                                                        <div class="FONT12 colorRed">만 15세 미만은 가입하실 수 없습니다.<br />취직 최저 연령에 대한 제한(근로기준법 제 64조 1항)</div>
                                                    </div>
                                                    <div class="ccol12 MT20">
                                                        <div class="tblLayout">
                                                            <div class="tlb positionTop top5">
                                                                <div class="cmmInput"><span class="lb required">이메일</span></div>
                                                            </div>
                                                            <div class="tip">
                                                                <div class="crow sm">
                                                                    <div class="ccol4 VMIDDLE">
                                                                        <div class="cmmInput">
                                                                            <div class="ip ">
                                                                                <input type="text" id="txtEmail1" name="txtEmail1" maxlength="30" placeholder="" autocomplete="off">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="ccol05 VMIDDLE"><span class="FONT16" style="margin-right: 12px;">@</span></div>
                                                                    <div class="ccol4 VMIDDLE">
                                                                        <div class="cmmInput">
                                                                            <div class="ip ">
                                                                                <input type="text" id="txtEmail2" name="txtEmail2" maxlength="30" placeholder="" autocomplete="off">
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="ccol35 VMIDDLE">
                                                                        <div class="cmmInput">
                                                                            <div class="ip ">
                                                                                <select name="selMail" onChange="fn_ChangeMail(this.value);" class="customSelect">
																					<option value="">선택</option>
																				<%
																					For i = 0 To UBound(arrMailInitial)
																				%>
																					<option value="<%=arrMailInitial(i)%>" <%=FN_SelectBox(v_email2,arrMailInitial(i))%>><%=arrMailInitial(i)%></option>
																				<%
																					Next
																				%>
																					<option value="x">직접입력</option>
                        														</select>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="MT10">
                                                                    <div class="cmmInput radiochk sm">
                                                                        <input type="checkbox" id="chkAgrMail" name="chkAgrMail" value="Y" />
                                                                        <label for="chkAgrMail" class="lb">맞춤 채용정보 / 정기 뉴스레터 / 이벤트 메일 수신에 동의합니다.</label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
        											</div>

                                                    <div class="ccol12">
                                                        <div class="cmmInput ciCol">
                                                            <label for="" class="lb required">휴대폰 번호</label>
                                                            <div class="ip paddingRight">
                                                                <input type="text" id="txtPhone" name="txtPhone" value="<%=rs_memPhone%>" maxlength="13" onkeyup="fn_num_chk(this, 'int'); fn_changePhoneType(this);" autocomplete="off" />
                                                                <div class="rrtxt">
                                                                    <a href="javaScript:void(0);" onclick="fn_phoneCertifi(); return false;" class="btns mint sm" id="aMobile">인증번호 전송</a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="ccol12">
                                                        <div class="tblLayout" id="rsltAuthArea" style="display:none;">
                                                            <div class="tlb positionTop top5">
                                                                <div class="cmmInput">
                                                                    <span for="" class="lb required">인증번호</span>
                                                                </div>
                                                            </div>
                                                            <div class="tip">
                                                                <div class="cmmInput">
                                                                    <div class="ip paddingRight">
                                                                        <input type="text" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="fn_removeChar(event)" onkeydown="return fn_onlyNumber(event)" autocomplete="off" />
                                                                        <div class="rrtxt">
																			<span id="rsltMsg_S" style="display:none;" class="FONT12 colorBlue">인증번호가 정상 입력 됐습니다.</span>
																			<span id="rsltMsg_F" style="display:none;" class="FONT12 colorRed">인증번호가 틀립니다.</span>
																			<span id="timeCntdown" style="display:none;" class="FONT12"><em>(2:59)</em></span>
                                                                            <a href="javaScript:void(0);" onclick="fnAuthNoChk(); return false;" class="btns mint sm">인증확인</a>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="cmmInput radiochk sm MT10">
                                                                    <input type="checkbox" id="chkAgrSms" name="chkAgrSms" value="1" />
                                                                    <label for="chkAgrSms" class="lb">채용관련 SMS 수신에 동의합니다.</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="ccol12 MT50">
                                                        <div class="cmmTit sm colorBlack">이용약관 및 개인정보 수집 동의</div>
                                                        <!-- <div class="FONT15 colorGry MT05">아래 회원정보를 입력하시면 커리어 회원으로 가입이 완료됩니다.</div> -->
                                                        <div class="cmmHr line1 MT15"></div>
                                                    </div>
                                                    <div class="ccol12 MT20">
                                                        <div class="cmmHr nopadding outline ssm">
                                                            <div class="crow">
                                                                <div class="ccol12">
                                                                    <div class="cmmInput bordernone radiochk tp3 sm">
                                                                        <div class="ip nomargin paddingRight">
                                                                            <input type="checkbox" id="chkAgrPer1" name="" value="" />
                                                                            <label for="chkAgrPer1" class="lb FWB"> 이용약관 동의<span class="FONT12 colorRed ML05 ">필수</span></label>
                                                                            <div class="rrtxt">
                                                                                <a href="#;" class="btns sm gray-2 fnDialogagr1">약관보기</a>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="cmmHr nopadding outline ssm">
                                                            <div class="crow">
                                                                <div class="ccol12">
                                                                    <div class="cmmInput bordernone radiochk tp3 sm">
                                                                        <div class="ip nomargin paddingRight">
                                                                            <input type="checkbox" id="chkAgrPer2" name="" value="" />
                                                                            <label for="chkAgrPer2" class="lb FWB">  개인정보 수집 및 이용 동의<span class="FONT12 colorRed ML05 ">필수</span></label>
                                                                            <div class="rrtxt">
                                                                                <a href="#;" class="btns sm gray-2 fnDialogagr2">약관보기</a>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="cmmHr nopadding outline ssm">
                                                            <div class="crow">
                                                                <div class="ccol12">
                                                                    <div class="cmmInput bordernone radiochk tp3 sm">
                                                                        <div class="ip nomargin ">
                                                                            <input type="checkbox" id="chkAgrPerAll" name="" value="" />
                                                                            <label for="chkAgrPerAll" class="lb FWB colorBlack"> 전체 동의 합니다.</label>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="TXTC MT30">
                                                    <a href="javaScript:void(0);" onclick="javascript:fn_Sumbit_memJoin();" class="btns xxlg MINWIDTH400 blue2 FWB">회원가입 완료하기</a>
                                                </div>
                                            </form>

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
	<!-- //본문 -->

	<!-- 이용약관  -->
    <div class="cmm_layerpop signupDialog" data-layerpop="dialogagr1">
        <div class="fnCmmInnerScrollJoinAgree" style="height: 500px; overflow-y: auto;">
<%
'EXEC dbo.USP_PRIVACY_POLICY_VIEW '2','1','2','1','1','' -- 이용약관> 개인
'EXEC dbo.USP_PRIVACY_POLICY_VIEW '2','2','2','1','1','' -- 이용약관> 기업
'EXEC dbo.USP_PRIVACY_POLICY_VIEW '3','0','2','1','1','' -- 개인정보수집 및 이용동의> 공통

ConnectDB DBCon, Application("DBInfo_REAL") ' 관리자단(통합 메인관리> 개인정보 처리방침) 제어 대상이라 192.168.1.2 서버 테이블 정보 호출 처리

	Dim param(5)
	param(0) = makeParam("@Gubun", adInteger, adParamInput, 4, "2")
	param(1) = makeParam("@SubGubun", adInteger, adParamInput, 4, "1")
	param(2) = makeParam("@Sitecode", adInteger, adParamInput, 4, "2")
	param(3) = makeParam("@Page", adInteger, adParamInput, 4, "1")
	param(4) = makeParam("@PageSize", adInteger, adParamInput, 4, "1")
	param(5) = makeParam("@TotalCnt", adInteger, adParamOutput, 4, "")

	sp_result_agr1 = arrGetRsSP(DBCon, "USP_PRIVACY_POLICY_VIEW", param, "", "")

DisconnectDB DBCon

If isArray(sp_result_agr1) Then
	Response.write sp_result_agr1(4,0)
Else
End If
%>
        </div>
    </div>
	<!-- //이용약관  -->

	<!-- 개인정보 수집 및 이용동의  -->
    <div class="cmm_layerpop signupDialog" data-layerpop="dialogagr2">
        <div class="fnCmmInnerScrollJoinAgree" style="height: 500px; overflow-y: auto;">
<%
ConnectDB DBCon, Application("DBInfo_REAL") ' 관리자단(통합 메인관리> 개인정보 처리방침) 제어 대상이라 192.168.1.2 서버 테이블 정보 호출 처리

	Dim param2(5)
	param2(0) = makeParam("@Gubun", adInteger, adParamInput, 4, "3")
	param2(1) = makeParam("@SubGubun", adInteger, adParamInput, 4, "0")
	param2(2) = makeParam("@Sitecode", adInteger, adParamInput, 4, "2")
	param2(3) = makeParam("@Page", adInteger, adParamInput, 4, "1")
	param2(4) = makeParam("@PageSize", adInteger, adParamInput, 4, "1")
	param2(5) = makeParam("@TotalCnt", adInteger, adParamOutput, 4, "")

	sp_result_agr2 = arrGetRsSP(DBCon, "USP_PRIVACY_POLICY_VIEW", param2, "", "")

DisconnectDB DBCon

If isArray(sp_result_agr2) Then
	Response.write sp_result_agr2(4,0)
Else
End If
%>
        </div>
    </div>
	<!-- //개인정보 수집 및 이용동의  -->


	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

</body>
</html>
