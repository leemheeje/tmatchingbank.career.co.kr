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
<script src="/js/ui/signUpCustomTags.js"></script>
<script type="text/javascript">
/*
		//Listen for authorization success
	document.addEventListener('AppleIDSignInOnSuccess', function(data) {
			
			//handle successful response
			var token = data.detail.authorization.id_token;
			//var base64Payload = token.split('.')[1];
			var base64Payload = JSON.parse(base64_url_decode(token.split(".")[1]));


			document.getElementById("frm_sns_ap").sns_id.value			= "AP" + base64Payload.sub.split('.').join('');
			document.getElementById("frm_sns_ap").sns_id_full.value			= "AP" + base64Payload.sub.split('.').join('');
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
		fn_move("#container");
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
				width: 850,
				parentAddClass: 'tp3',
				useBottomArea: false,
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
                    //$('.fnCmmInnerScrollJoinAgree').cmmInnerScroll();
                },
                submit: function($this) {
                    $this.cmmLocLaypop('close');
                    $chkAgrPer1.prop('checked', true).trigger('change');
                },
            });
			return false;
        });

        var dialogagr2_bool = true;
        $('.fnDialogagr2').click(function(){//개인정보 수집 및 이용 동의 팝업
            $('[data-layerpop="dialogagr2"]').cmmLocLaypop({
				width: 850,
				parentAddClass: 'tp3',
				useBottomArea: false,
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
                    //$('.fnCmmInnerScrollJoinAgree').cmmInnerScroll();
                },
                submit: function($this) {
                    $this.cmmLocLaypop('close');
                    $chkAgrPer2.prop('checked', true).trigger('change');
                },
            });
			return false;
        });
		// 풀이메일 split
		/*$('#txtMnFullVer').bind('blur', function(){
			var $this = $(this);
			var value = $this.val();
			var array = null;
			$('#txtEmail1').val('');
			$('#txtEmail2').val('');
			if($.__TRIM(value) && value.indexOf('@') != -1){
				array = value.split('@');
				$('#txtEmail1').val(array[0] || '');
				$('#txtEmail2').val(array[1] || '');
			}
		});*/
		/* 입력값 체크 시작 */
		// 비번 유효성 체크
		$("#txtPass").bind("keyup keydown", function () {
			var $this = $(this);
			$(this).attr('type', 'password');
			fn_checkPW($this);
		});

		// 비번 재확인 유효성 체크
		$("#txtPassChk").bind("keyup keydown", function () {
			var $this = $(this);
			fn_checkPW($this);
		});

		// 이름 자릿수 체크
		$("#txtName").bind("keyup keydown", function () {
			fn_checkName();
		});

		// 아이디 중복 체크
		var checkAjaxSetTimeout;
		$("#txtId").bind("keyup keydown", function () {
			var $this = $(this);
			var $tooltip = $this.closest('.sgForm').find('.warMsg[data-tooltip-name]');
			$tooltip.removeAttr('data-params');
			clearTimeout(checkAjaxSetTimeout);
			checkAjaxSetTimeout = setTimeout(function(){

				$("#txtId").val($("#txtId").val().toLowerCase());

				$("#id_box").text("");
				$("#id_check").val("0");

				var checkNumber		= $("#txtId").val().search(/[0-9]/g);	// 숫자 입력 체크
				var checkEnglish	= $("#txtId").val().search(/[a-z]/ig);	// 영문 입력 체크

				if($("#txtId").val() == ""){
					//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
					$tooltip.attr('data-params', 'error');
					$("#id_box").text("아이디를 입력해 주세요.");
					$("#txtId").focus();
					return;
				}

				if(!Validchar($("#txtId").val(), num + alpha)){
					//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
					$tooltip.attr('data-params', 'error');
					$("#id_box").text("아이디는 한글 및 특수문자를 지원하지 않습니다. 다시 입력해 주세요.");
					$("#txtId").focus();
					return;
				}

				if($("#txtId").val().length < 5){
					//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
					$tooltip.attr('data-params', 'error');
					$("#id_box").text("아이디는 최소 5자 이상이어야 합니다.");
					return;
				}

				if(checkNumber <0 || checkEnglish <0){
					//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
					$tooltip.attr('data-params', 'error');
					$("#id_box").text("영문과 숫자를 혼용하여 입력해 주세요.");
					return;
				}

				if (/(\w)\1\1\1/.test($("#txtId").val())){	// 같은 형식 문자 4글자 이상 사용 금지
						//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
						$tooltip.attr('data-params', 'error');
						$("#id_box").text("동일한 문자 연속 4글자 이상은 사용 금지합니다.");
						return;
				}

				// ajax 실행
				$.ajax({
					type : 'POST',
					url : 'Id_CheckAll.asp',
					dataType: "text",
					data:{user_id: $('#txtId').val()},
					success : function(data) {
						//console.log(data);
						if (data == "F") {
							//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
							$tooltip.attr('data-params', 'error');
							$("#id_box").text("탈퇴한 아이디 또는 이미 사용중인 아이디로, 이용하실 수 없습니다.");
							return false;
						} else {
							if ($("#txtId").val() != "" && $("#txtId").val().length > 4){
								$("#id_check").val("1");
								$("#chk_id").val($("#txtId").val());
								//$("#id_box").addClass(' colorBlue').removeClass(' colorRed');
								$tooltip.attr('data-params', 'success');
								$("#id_box").text("사용 가능한 아이디입니다.");
								return false;
							}else{
								//$("#id_box").addClass(' colorRed').removeClass(' colorBlue');
								$tooltip.attr('data-params', 'error');
								$("#id_box").text("아이디를 입력해 주세요. 아이디는 최소 5자 이상이어야 합니다.");
								$("#txtId").focus();
								return false;
							}
						}
					}
				}); // end ajax

			},1000); //end setTimeout
		}); // end keyup keydown
		/* 입력값 체크 끝 */

		// 페이지 이동 시 의사 확인
		$(".logo").click( function(e) {
			if(confirm('입력 정보가 삭제됩니다.\n페이지를 나가시겠습니까?')) {
				location.href = "/";
			}else{
				return false;
			}
		});

    });


	/* 알림톡 인증코드전송 */
	/* start */
	function fnAuthSmsRequest() {
		if ($("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		}
		if ($("#mobileAuthNumChk").val() == "1") {
			ans = confirm("인증번호를 재전송 하시겠습니까?");
			if (ans == true) {
				Authchk_ing = false;
			}else{return;}
		}

		$("#hd_idx").val('');

		var contact = $("#txtPhone").val();
		$("#rsltAuthArea").show();
		$("#timeCntdown").show();
		$("#rsltMsg_S").hide();
		fnDpFirst();
		fncDpTm(); //카운트

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

				var strUrl = "/signup/auth/certify/ajaxAuthCodeRequest.asp";
				var parm = {};

				parm.contact	= $("#txtPhone").val();
				parm.MemberKind	= "개인";
				parm.sitecode	= "2";	// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)

				$("#aMobile").text("인증번호 재전송");
				$.ajax({
					url: strUrl
					, dataType: "json"
					, type: "post"
					, data: parm
					, success: function (data) {
						$("#hd_idxNum").val(data.SendAuthCodeID);
						$("#mobileAuthNumChk").val(data.mobileAuthNumChk);
						//alert("sccess : " + data.length);
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						//alert(textStatus + ", " + errorThrown);
					}
				});
			}
		}
	}

	function fnAuthSmsConfirm(){
		Authchk_ing = false;

		var strUrl = "/signup/auth/certify/ajaxAuthCodeConfirm.asp";
		var parm = {};

		parm.contact	= $("#txtPhone").val();
		parm.MemberKind	= "개인";
		parm.sitecode	= "2";	// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)
		parm.AuthNumber = $("#mobileAuthNumber").val();
		parm.idxNum		= $("#hd_idxNum").val();

		$.ajax({
			url: strUrl
			, dataType: "json"
			, type: "post"
			, data: parm
			, success: function (data) {
				$("#hd_kind").val(data.RCODE);
				jsonp_result_callbackSe(data);
				//alert("sccess : " + data.length);
			}
			, error: function (jqXHR, textStatus, errorThrown) {
				//alert(textStatus + ", " + errorThrown);
			}
		});
	}

	function jsonp_result_callbackSe(data) {
		if ($("#hd_kind").val() == "1") {
			if ($.trim(data.result_idx) == "Y") {
				$("#mobileAuthNumChk").val("4");
				$("#mobileAuthNumber").attr("readonly",true);
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

		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		} else if ($.trim($("#hd_idx").val()) == "") {
			alert("인증번호가 맞지 않습니다. 인증번호를 확인해 주세요.");
			return;
		}
	}
	/* end */
	/* 알림톡 인증코드전송 */

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
		$("#mobileAuthNumber").attr("readonly",false);
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
			if ($("#mobileAuthNumChk").val() != "4"){
				$("#mobileAuthNumber").val('');
				$("#mobileAuthNumber").attr("placeholder","인증시간이 만료되었습니다.");
				$("#mobileAuthNumber").attr("readonly",true);
				alert("인증시간이 만료되었습니다.");
				return false;
			}
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
			fnAuthSmsRequest();
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
	function fn_Submit_memJoin(type){
		var txtId			= $("#txtId").val();		// 아이디
		var txtPass			= $("#txtPass").val();		// 비번
		var txtPassChk		= $("#txtPassChk").val();	// 비번확인
		var	txtName			= $("#txtName").val();		// 이름
		var	txtBirth		= $("#txtBirth").val();		// 생년월일

		//var email_id			= $("#txtEmail1").val();	// 이메일 앞자리
		//var email_domain		= $("#txtEmail2").val();	// 이메일 뒷자리

		var txtMnFullVer	= $("#txtMnFullVer").val();		// 이메일
		var txtPhone		= $("#txtPhone").val();			// 휴대폰
		var chkAgrPrv		= $("#chkAgrPerAll").is(":checked");	// 이용약관 및 개인정보 수집 동의

		if(txtId==""){
			alert("아이디를 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtId").focus();
			return;
		}

		if($("#id_box").text()!="사용 가능한 아이디입니다."){
			alert("아이디를 다시 확인해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtId").focus();
			return;
		}

		if(txtPass==""){
			alert("비밀번호를 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtPass").focus();
			return;
		}

		if($("#pw_box").text()!=""){
			alert("입력하신 비밀번호가 보안상 매우 취약합니다.\n8~16자까지 영문, 숫자, 특수문자 등의 조합으로\n아이디와 무관한 문자열을 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtPass").focus();
			return;
		}

		if(txtPassChk==""){
			alert("비밀번호 확인란을 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtPassChk").focus();
			return;
		}

		if(txtPassChk!=txtPass){
			alert("비밀번호와 비밀번호 확인란에 입력한 정보가\n일치하지 않습니다. 다시 확인해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtPassChk").focus();
			return;
		}

		if(txtName==""){
			alert("이름을 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtName").focus();
			return;
		}

		var pattern_etc = /([^가-힣ㄱ-ㅎㅏ-ㅣ\x20])/i; // 한글이 아닌 값을 입력한 경우(영문, 한문)
		if (pattern_etc.test(txtName)) {
			if(txtName.length < 3) {
				alert('한글이 아닌 이름은 두글자 이상 입력해 주셔야 합니다.');
				$('#txtName').focus();
				return false;
			}

			var check_ko = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
			if(check_ko.test(txtName)){
				alert("이름에 한글 및 알파벳, 특수문자를 조합하여 입력하실 수 없습니다.\n다시 확인해 주세요.");
				$('#txtName').focus();
				return false;
			}

			if(checkSpecial(txtName)){
				alert("이름에 특수문자 및 숫자는 입력하실 수 없습니다. 다시 확인해 주세요.");
				$("#txtName").focus();
				return;
			}

			if(checkSpace(txtName)){
				alert("이름에 공백은 입력하실 수 없습니다. 다시 확인해 주세요.");
				$("#txtName").focus();
				return;
			}
		}else { // 한글 입력 시
			var pattern_ko = /([^가-힣\x20])/i; // ㅇ, ㅏ, 특수기호(●, ♥) 체크
			if (pattern_ko.test(txtName)) {
				alert("이름에 자음, 모음만 입력하실 수 없습니다. 다시 확인해 주세요.");
				$("#txtName").focus();
				return;
			}

			if(txtName.length < 2) {
				alert('이름은 한글자 이상 입력 가능합니다.');
				$('#txtName').focus();
				return false;
			}

			var check_alpha = /[a-z]/i;
			if(check_alpha.test(txtName)){
				alert("이름에 한글 및 알파벳, 특수문자를 조합하여 입력하실 수 없습니다.\n다시 확인해 주세요.");
				$('#txtName').focus();
				return false;
			}

			if(checkSpecial(txtName)){
				alert("이름에 특수문자 및 숫자는 입력하실 수 없습니다. 다시 확인해 주세요.");
				$("#txtName").focus();
				return;
			}

			if(checkSpace(txtName)){
				alert("이름에 공백은 입력하실 수 없습니다. 다시 확인해 주세요.");
				$("#txtName").focus();
				return;
			}
		}

		if(!txtBirth) {
			alert("생년월일을 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtBirth").focus();
			return;
		}

		var birth_value		= txtBirth.replace(/-/gi, "");
		var rxDatePattern	= /^(\d{4})(\d{1,2})(\d{1,2})$/;	// Declare Regex
		var dtArray			= birth_value.match(rxDatePattern);	// is format OK?

		if (birth_value.length < 8) {
			alert("생년월일을 정확히 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtBirth").focus();
			return;
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
				fn_move("#memInfo_Area");
				$("#txtBirth").focus();
				return;
			}

			if (dtYear == year_n && dtMonth > month){
				alert("현재일자보다 미래의 날짜로 생년월일이 입력되었습니다.\n다시 확인해 주세요.");
				fn_move("#memInfo_Area");
				$("#txtBirth").focus();
				return;
			}

			if (dtMonth < 1 || dtMonth > 12){
				alert("태어난 월 정보가 유효하지 않습니다.");
				fn_move("#memInfo_Area");
				$("#txtBirth").focus();
				return;
			}

			if (dtDay < 1 || dtDay > 31){
				alert("태어난 일 정보가 유효하지 않습니다.");
				fn_move("#memInfo_Area");
				$("#txtBirth").focus();
				return;
			}

			if (dtMonth == 2) {
				var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
				if (dtDay > 29 || (dtDay == 29 && !isleap)){
					alert(dtYear+"년 2월의 마지막 날짜는 28일 입니다.");
					fn_move("#memInfo_Area");
					$("#txtBirth").focus();
					return;
				}
			}
		}

		if(!txtMnFullVer) {
			alert("이메일 정보를 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtMnFullVer").focus();
			return;
		}

		/*if(!email_domain) {
			alert("이메일 주소를 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtEmail2").focus();
			return;
		}*/

		var email_rule=/^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
//		var email_rule =/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var mail = $('[name="txtMnFullVer"]').val();
		//mail = email_id+"@"+email_domain;
		//$("#mail").val(mail);

		if(!email_rule.test(mail)) {
			alert("이메일을 형식에 맞게 입력해 주세요.");
			fn_move("#memInfo_Area");
			$("#txtMnFullVer").focus();
			return;
		}

		if($("#mail_box").text()=="잘못된 이메일 형식입니다."){
			alert("이메일을 다시 확인해 주세요.");
			fn_move("#memInfo_Area");
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
			//if(confirm('입력하신 정보로 회원 가입 하시겠습니까?')) {
				obj.method = "post";
				obj.action = "Join_Member_Proc.asp";
				obj.submit();
			//}
		}else{
			alert("이용약관 및 개인정보 수집에 동의해 주세요.");
			return;
		}
	}

	/*정규식 검증 시작*/
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

	// 특수 문자 체크
	function checkSpecial(str) {
		var regExp = /[!?@#$%^&*():;+-=~{}<>\_\[\]\|\\\"\'\,\.\/\`\₩]/i;
		if(regExp.test(str)) {
			return true;
		}else{
			return false;
		}
	}

	// 숫자 체크
	function checkNum(str){
		var regExp = /[0-9]/i;
		if(regExp.test(str)){
			return true;
		}else{
			return false;
		}
	}

	// 공백(스페이스 바) 체크
	function checkSpace(str) {
		if(str.search(/\s/) !== -1) {
			return true;	// 스페이스가 있는 경우
		}else{
			return false;	// 스페이스 없는 경우
		}
	}
	/*정규식 검증 끝*/

	/* 비밀번호 체크 시작 */
	function fn_checkPW($this) {
		var chk = false;
		var id	= $("#txtId").val();
		var $tooltip = $this.closest('.sgForm').find('.warMsg[data-tooltip-name]');
		$('[data-tooltip-name="pw_box"]').removeAttr('data-params');
		$('[data-tooltip-name="pw_box2"]').removeAttr('data-params');
		if ($('#txtPass').val().length == 0 ) {
			return;
		} else {
			if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 16) {
				$tooltip.attr('data-params', 'error');
				$("#pw_box").text("비밀번호는 8~16자 까지만 허용됩니다.");
				//return false;
			}

			if (id != "" && $('#txtPass').val().search(id) > -1) {
				$tooltip.attr('data-params', 'error');
				$("#pw_box").text("비밀번호에 아이디가 포함되어 있습니다.");
				//return false;
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
				$tooltip.attr('data-params', 'error');
				$("#pw_box").text("비밀번호는 8~16자까지 영문, 숫자 및 특수문자의 조합으로 생성해야 합니다.");
				//return;
			}else{
				if(id != "" && $('#txtPass').val().search(id) > -1) {
					$tooltip.attr('data-params', 'error');
					$("#pw_box").text("비밀번호에 아이디가 포함되어 있습니다.");
					//return false;
				}else{
					$('[data-tooltip-name="pw_box"]').removeAttr('data-params');
					$("#pw_box").text("");
				}
			}
		}
		if($this[0] === $('#txtPassChk')[0]){
			if ($('#txtPassChk').val().split(" ").join("") == "") {
				$tooltip.attr('data-params', 'error');
				$("#pw_box2").text("비밀번호 확인을 입력해 주세요.");
				//return;
			}
			if ($('#txtPass').val() != $('#txtPassChk').val()) {
				$tooltip.attr('data-params', 'error');
				$("#pw_box2").text("비밀번호가 일치하지 않습니다.");
				//return;
			} else {
				$("#pw_box").text("");
				$("#pw_box2").text("");
				$('[data-tooltip-name="pw_box"]').removeAttr('data-params');
				$('[data-tooltip-name="pw_box2"]').removeAttr('data-params');
			}
		}
		return chk;
	}
	/* 비밀번호 체크 끝 */

	/* 이름 자릿수 체크 시작 */
	function fn_checkName() {
		if($("#txtName").val().length >= 15){
			alert("이름은 최대 15자 까지만 입력 됩니다.");
			return;
		}
	}
	/* 이름 자릿수 체크 끝 */

	// 특정 영역 이동
	function fn_move(div_id){
        var offset = $(div_id).offset();
        $('html, body').animate({scrollTop : offset.top}, 400);
    }
</script>
<!-- <meta name="appleid-signin-client-id" content="kr.co.career.login">
<meta name="appleid-signin-scope" content="name email">
<meta name="appleid-signin-redirect-uri" content="https://www.career.co.kr/signup/Join_Member.asp">
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
	<link rel="stylesheet" href="/css/signup.css">

	<!-- 본문 -->
    <div id="container" class="container gray">
        <div class="contents">
            <div class="subContens">

				<!-- 회원가입:S -->
				<div class="signup subpage">
					<div class="innerWrap">
						<div class="signUpBoxArea">
							<div class="signBoxInner">
								<!-- 타이틀:S -->
								<div class="sgTitNm">
									채용의 시작!<br>
									지금 바로 회원가입 후 시작하세요!
								</div>
								<!-- 타이틀:E -->
								<!-- 탭:S -->
								<div class="cmmStateStepType2Wrap tp2 col2 MT35">
									<div class="cmmStateStepInner">
										<div class="cssTp active">
											<a href="#;" class="cssTpBox">
												<div class="cssTit">개인회원</div>
											</a>
										</div>
										<div class="cssTp ">
											<a href="Join_Biz.asp" class="cssTpBox ">
												<div class="cssTit">기업회원</div>
											</a>
										</div>
									</div>
								</div>
								<!-- 탭:E -->

								<!-- SNS선택:S -->
								<%'SNS 간편 로그인 영역 호출%>
								<div class="sgSnsGroup MT35">
									<!--#include file = "../login/Login_SNS_Inc.asp"-->
									<!-- <div class="sgTitle">SNS로 간편 로그인</div>
									<div class="snsArea">
										<button class="snsBt naver" title="네이버"></button>
										<button class="snsBt facebook" title="페이스북"></button>
										<button class="snsBt kakao" title="카카오톡"></button>
										<button class="snsBt google" title="구글"></button>
									</div> -->
									<div class="sgHr MT25"></div>
								</div>
								<!-- SNS선택:E -->

								<div class="FONT13 MT20 MB35 colorRed">* 필수 입력 정보입니다.</div>

								<form method="post" name="frm_mem" class="fnCmmForm">
								<input type="hidden" id="id_check" name="id_check" value="" /><%'아이디 검증 여부(0/1)%>
								<input type="hidden" id="chk_id" name="chk_id" value=""><%'사용(입력) 아이디%>
								<input type="hidden" id="hd_idx" name="hd_idx" value="" /><%'번호인증 idx%>
								<input type="hidden" id="hd_idxNum" name="hd_idxNum" value="" /><%'번호인증 idx%>
								<input type="hidden" id="mobileAuthNumChk" name="mobileAuthNumChk" value="0" />
								<input type="hidden" id="hd_kind" name="hd_kind" value="2" />
								<input type="hidden" id="authproc" name="authproc" value="" />
								<input type="password" style="display:block; width:0px; height:0px; border:0;"><%'브라우저 로그인 정보 저장 동의 시 자동입력 방지용%>

								<div id="memInfo_Area">
									<!-- 폼:S -->
									<div class="sgFormGroup">
										<div class="sgTitle">
											<span class="poi">회원가입</span>하고 다양한 커리어 서비스를 이용하세요!
										</div>
										<div class="sgForm ">
											<input type="text" id="txtId" name="txtId" maxlength="12" class="required" placeholder="아이디 (5~12자 영문, 숫자 입력)" autocomplete="off" />
											<div class="warMsg" data-tooltip-name="id_box" data-params="">
												<div class="intx" id="id_box"></div>
											</div>
										</div>
										<div class="infMsg">
											<div class="intx">※ 커리어 아이디 관리 정책에 따라 대문자 입력 시 소문자로 자동 변환됩니다.</div>
										</div>

										<div class="sgForm MT15">
											<input type="password" id="txtPass" name="txtPass" maxlength="16" class="required" placeholder="비밀번호 (8~16자 영문, 숫자, 특수문자 입력)" autocomplete="off" />
											<div class="warMsg" data-tooltip-name="pw_box" data-params="">
												<div class="intx" id="pw_box"></div>
											</div>
										</div>
										<div class="sgForm">
											<input type="password" id="txtPassChk" name="txtPassChk" maxlength="16" class="required" placeholder="비밀번호 확인" autocomplete="off" />
											<div class="warMsg" data-tooltip-name="pw_box2" data-params="">
												<div class="intx" id="pw_box2"></div>
											</div>
										</div>
										<div class="sgForm MT40">
											<input type="text" id="txtName" name="txtName" maxlength="15" class="required" placeholder="이름 (실명 입력)" autocomplete="off" />
										</div>
										<div class="sgForm ">
											<input type="text" id="txtBirth" name="txtBirth" maxlength="8" class="required" onkeyup="fn_num_chk(this, 'int'); fn_changeDateType(this);" placeholder="생년월일 입력 (YYYY-MM-DD)" autocomplete="off" />
										</div>
										<div class="infMsg">
											<div class="intx">※ 만 15세 미만은 가입하실 수 없습니다. 취직 최저 연령에 대한 제한 <a href="https://www.law.go.kr/%EB%B2%95%EB%A0%B9/%EA%B7%BC%EB%A1%9C%EA%B8%B0%EC%A4%80%EB%B2%95" target="_blank"><span class="cRed">(근로기준법 제 64조 1항)</span></a></div>
										</div>
										<div class="sgForm MT40">
											<input type="text" id="txtMnFullVer" name="txtMnFullVer" maxlength="60" class="required" placeholder="이메일 주소" autocomplete="off">
											<!-- <input type="hidden" id="txtEmail1" name="txtEmail1">
											<input type="hidden" id="txtEmail2" name="txtEmail2"> -->
										</div>
										<div class="infMsg">
											<div class="cmmInput radiochk tp99">
												<label>
													<input type="checkbox" id="chkAgrMail" name="chkAgrMail" value="Y" checked />
													<span class="lb">맞춤 채용정보 / 정기 뉴스레터 / 이벤트 메일 수신에 동의합니다. (선택)</span>
												</label>
											</div>
										</div>
										<div class="sgForm absBtn MT30">
											<input type="text" id="txtPhone" name="txtPhone" value="<%=rs_memPhone%>" class="required" placeholder="휴대폰 번호 (번호만 입력)" maxlength="13" onkeyup="fn_num_chk(this, 'int'); fn_changePhoneType(this);" autocomplete="off" />
											<div class="abs">
												<button class="abtn" onclick="fn_phoneCertifi(); return false;" id="aMobile">인증번호 전송</button>
											</div>
										</div>
										<div class="sgForm absBtn isInzNum" id="rsltAuthArea" style="display:none;">
											<input type="text" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" class="required" placeholder="인증번호 입력" onkeyup="fn_removeChar(event)" onkeydown="return fn_onlyNumber(event)" autocomplete="off" />
											<span class="inzNum" id="timeCntdown" style="display:none;"><em>(00:00)</em></span>
											<div class="warMsg" id="rsltMsg_S" style="display:none;" data-params="success">
												<div class="intx">인증번호가 정상 입력 됐습니다.</div>
											</div>
											<div class="warMsg" id="rsltMsg_F" style="display:none;" data-params="error">
												<div class="intx">인증번호가 틀립니다.</div>
											</div>
											<div class="abs">
												<button class="abtn fnAuthSmsConfirmButton" onclick="fnAuthSmsConfirm(); return false;">확인</button>
											</div>
										</div>
										<div class="infMsg">
											<div class="cmmInput radiochk tp99">
												<label>
													<input type="checkbox" id="chkAgrSms" name="chkAgrSms" value="1" checked />
													<span class="lb">이벤트 및 소식을 카카오 알림톡 또는 SMS로 수신하는데 동의합니다. (선택)</span>
												</label>
											</div>
										</div>
									</div>
									<!-- 폼:E -->

									<!-- 약관동의폼:S -->
									<div class="sgAgrGroup MT60">
										<div class="sgaTo">
											<div class="cmmInput radiochk tp99">
												<label>
													<input type="checkbox" id="chkAgrPerAll" name="" value="" />
													<span class="lb">이용약관 및 개인정보 수집에 모두 동의합니다.</span>
												</label>
											</div>
										</div>
										<div class="sgHr MT15"></div>
										<div class="sgaCt MT15">
											<div class="cmmInput radiochk tp99">
												<label>
													<input type="checkbox" id="chkAgrPer1" name="" value="" />
													<span class="lb">이용약관 동의 <span class="colorRed ML05">(필수)</span></span>
												</label>
												<button class="agTxtBtn fnDialogagr1">약관보기</button>
											</div>
											<div class="cmmInput radiochk tp99">
												<label>
													<input type="checkbox" id="chkAgrPer2" name="" value="" />
													<span class="lb">개인정보 수집 및 이용 동의 <span class="colorRed ML05">(필수)</span></span>
												</label>
												<button class="agTxtBtn fnDialogagr2">약관보기</button>
											</div>
										</div>
										<div class="sgHr MT15"></div>
									</div>
									<!-- 약관동의폼:E -->
								</div>

								<div class="btnsGroup MT40">
									<a href="#;" class="abtn block blue lg" onclick="javascript:fn_Submit_memJoin();">회원가입 완료하기</a>
								</div>


								</form>


							</div>
						</div>
					</div>
				</div>
				<!-- 회원가입:E -->

            </div>
        </div>
    </div>
	<!-- //본문 -->

	<!-- 이용약관  -->
    <div class="cmm_layerpop signupDialog" data-layerpop="dialogagr1">
        <div class="fnCmmInnerScrollJoinAgree">
<%
'EXEC dbo.USP_PRIVACY_POLICY_VIEW '2','1','2','1','1','' -- 이용약관> 개인
'EXEC dbo.USP_PRIVACY_POLICY_VIEW '2','2','2','1','1','' -- 이용약관> 기업
'EXEC dbo.USP_PRIVACY_POLICY_VIEW '3','0','2','1','1','' -- 개인정보수집 및 이용동의> 공통

'ConnectDB DBCon, Application("DBInfo_REAL") ' 관리자단(통합 메인관리> 개인정보 처리방침) 제어 대상이라 192.168.1.2 서버 테이블 정보 호출 처리
'
'	Dim param(5)
'	param(0) = makeParam("@Gubun", adInteger, adParamInput, 4, "2")
'	param(1) = makeParam("@SubGubun", adInteger, adParamInput, 4, "1")
'	param(2) = makeParam("@Sitecode", adInteger, adParamInput, 4, "2")
'	param(3) = makeParam("@Page", adInteger, adParamInput, 4, "1")
'	param(4) = makeParam("@PageSize", adInteger, adParamInput, 4, "1")
'	param(5) = makeParam("@TotalCnt", adInteger, adParamOutput, 4, "")
'
'	sp_result_agr1 = arrGetRsSP(DBCon, "USP_PRIVACY_POLICY_VIEW", param, "", "")
'
'DisconnectDB DBCon

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
        <div class="fnCmmInnerScrollJoinAgree">
<%
'ConnectDB DBCon, Application("DBInfo_REAL") ' 관리자단(통합 메인관리> 개인정보 처리방침) 제어 대상이라 192.168.1.2 서버 테이블 정보 호출 처리
'
'	Dim param2(5)
'	param2(0) = makeParam("@Gubun", adInteger, adParamInput, 4, "3")
'	param2(1) = makeParam("@SubGubun", adInteger, adParamInput, 4, "0")
'	param2(2) = makeParam("@Sitecode", adInteger, adParamInput, 4, "2")
'	param2(3) = makeParam("@Page", adInteger, adParamInput, 4, "1")
'	param2(4) = makeParam("@PageSize", adInteger, adParamInput, 4, "1")
'	param2(5) = makeParam("@TotalCnt", adInteger, adParamOutput, 4, "")
'
'	sp_result_agr2 = arrGetRsSP(DBCon, "USP_PRIVACY_POLICY_VIEW", param2, "", "")
'
'DisconnectDB DBCon

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
