<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 > 휴면 해제
' 	History		: 2021-08-03, 이샛별
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

f_hidUserId = RTrim(LTrim(Replace(Request("hidUserId"), "'", "''")))	' 아이디

If Len(f_hidUserId)=0 Then
	Call FN_alertLink("정상적인 접근 방식이 아닙니다. - 아이디 누락",strLink)
Else

	ConnectDB DBCon, Application("DBInfo")

		Dim rowRs
		ReDim param(1)
		param(0)	= makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, f_hidUserId)
		param(1)	= makeParam("@IN_V_USER_NAME", adVarChar, adParamInput, 30, "")
		rowRs		= arrGetRsSP(DBCon, "SPC_INACTIVE_USER_INFO_SELECT", param, "", "")
		If IsArray(rowRs) Then
			rs_memName		= Trim(rowRs(0,0))	' 회원명
			rs_memPhone		= Trim(rowRs(1,0))	' 휴대폰
			rs_memEmail		= Trim(rowRs(2,0))	' 이메일
			rs_memJoinType	= Trim(rowRs(3,0))	' 가입사이트구분코드(2: 일반, 31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북)
			rs_memPw		= Trim(rowRs(4,0))	' 암호화비번
			rs_Photo		= Trim(rowRs(5,0))	' 이력서 증명사진
		Else
			Call FN_alertLink("해당 페이지에 대한 접근 권한이 없습니다.",strLink)
		End If

	DisconnectDB DBCon

End If
%>
<!--#include virtual = "/common/header.asp"-->
<script src="/js/ui/signUpCustomTags.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $('[name="authType"]').change(function(){	// 인증 타입 선택 시
            var $this		= $(this);
            var value		= $this.val();
			var memPhone	= "<%=rs_memPhone%>";	// 휴면 전환 당시 휴대폰
			var memEmail	= "<%=rs_memEmail%>";	// 휴면 전환 당시 이메일


            if(value == 'authTypeEmail'){
                $('[data-showhide="!authType"]').addClass('show');
                $('[data-showhide="!!authType"]').addClass('show');

				if ($("#mobileAuthNumChk").val() == "4"){
					alert("휴대폰 인증이 완료되었습니다.");
					return;
				}else{
					$("#txtPhone").val(memPhone);
					$("#txtAuthNumber").val("");
					$("#txtAuthNumber").attr("placeholder","");
					$("#txtAuthNumber").attr("readonly",false);
					$("#timeCntdown").hide();
					$("#rsltAuthArea").hide();
				}
            }else if(value == 'authTypePhone'){
                $('[data-showhide="!authType"]').removeClass('show');
                $('[data-showhide="!!authType"]').removeClass('show');

				if ($("#emailAuthNumChk").val() == "4"){
					alert("이메일 인증이 완료되었습니다.");
					return;
				}else{
					$("#txtEmail").val(memEmail);
					$("#txtAuthNumber").val("");
					$("#txtAuthNumber").attr("placeholder","");
					$("#txtAuthNumber").attr("readonly",false);
					$("#timeCntdown").hide();
					$("#rsltAuthArea").hide();
				}
            }
        });
    });

	// 휴대폰번호 유효성 검증
	function fn_phoneCertifi(){
		var txtId	= $("#txtId").val();	// 아이디
		var	txtName	= $("#txtName").val();	// 이름

		if(txtId==""){
			alert("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}

		if(!txtName) {
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if($("#txtPhone").val()=="휴대폰 번호 (번호만 입력)"){
			$("#txtPhone").val("");
		}

		if($("#txtPhone").val()==""){
			alert("연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		}

		if($("#txtPhone").val().length<10){
			alert("정확한 연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		} else {
			fnAuthSmsRequest();
		}
	}

	/* 알림톡 인증코드 전송*/
	/* start */
	function fnAuthSmsRequest() {
		var txtId	= $("#txtId").val();	// 아이디
		var	txtName	= $("#txtName").val();	// 이름
		var contact = $("#txtPhone").val();	// 연락처

		if ($("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		}

		if ($("#mobileAuthNumChk").val() == "1") {
			ans = confirm("인증번호를 재전송 하시겠습니까?");
			if (ans == true) {
				Authchk_ing = false;
				$("#txtAuthNumber").val('');
				$("#rsltMsg_S").hide();
				$("#rsltMsg_F").hide();
				$("#timeCntdown").show();
				fnDpFirst();
				fncDpTm(); //카운트
			}else{return;}
		}

		$("#hd_idx").val('');

		if(contact=="휴대폰 번호 (번호만 입력)"){
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

		$.ajax({
			type: "POST"
			, url: "Get_Inactive_MemInfo_Check.asp"
			, data: { memType: "mem", txtId: txtId, txtName: escape(txtName), txtPhone: contact }
			, dataType: "text"
			, async: true
			, success: function (data) {
				if (data != "S") {
					alert("회원정보가 맞지 않습니다.\n다시 입력해 주세요.");
					return;
				}else {
					$("#rsltAuthArea").show();
					$("#timeCntdown").show();
					$("#rsltMsg_S").hide();
					$("#rsltMsg_E").hide();
					fnDpFirst();
					fncDpTm(); //카운트

					alert("인증번호가 발송되었습니다.");
					$("#hd_type").val("1");

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
			, error: function (XMLHttpRequest, textStatus, errorThrown) {
				alert("code:"+XMLHttpRequest.textStatus+"\n"+"message:"+XMLHttpRequest.responseText+"\n"+"error:"+errorThrown);
			}
		});
	}

	// 알림톡 처리 결과 리턴
	function jsonp_result_callbackSe(data) {
		if ($("#hd_kind").val() == "1") {
			if ($.trim(data.result_idx) == "Y") {
				$("#mobileAuthNumChk").val("4");
				$("#txtAuthNumber").attr("readonly",true);
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
			//alert("인증번호가 맞지 않습니다. 인증번호를 확인해 주세요.");
			//return;

			$("#emailAuthNumChk").val("3");
			$("#rsltMsg_S").hide();
			$("#timeCntdown").show();
			$("#rsltMsg_F").show();
		}
	}
	/*end*/
	/*알림톡 인증코드 전송*/

	/*이메일 인증코드 전송*/
	/*start*/
	function fn_emailCertifi(){
		var	txtId		= $("#txtId").val();	// 아이디
		var	txtName		= $("#txtName").val();	// 이름
		var txtEmail	= $("#txtEmail").val(); // 이메일

		if ($("#emailAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		}

		$("#hd_idx").val("");

		if(!txtName) {
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if(!txtEmail) {
			alert("이메일 정보를 입력해 주세요.");
			$("#txtEmail").focus();
			return;
		}

		var email_rule=/^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		var mail = "";
		mail = txtEmail;
		$("#mail").val(mail);

		if(!email_rule.test(mail)) {
			alert("이메일을 형식에 맞게 입력해 주세요.");
			$("#txtEmail").focus();
			return;
		}

		if($("#mail_box").text()=="잘못된 이메일 형식입니다."){
			alert("이메일을 다시 확인해 주세요.");
			$("#mail_box").focus();
			return;
		}

		$.ajax({
			type: "POST"
			, url: "Get_Inactive_MemInfo_Check.asp"
			, data: { txtId: txtId, txtName: escape(txtName) }
			, dataType: "text"
			, async: true
			, success: function (data) {
				if (data != "S") {
					alert("회원정보가 맞지 않습니다.\n다시 입력해 주세요.");
					return false;
				}else {
					Authchk_ing = true;
					var strUrl = "https://app.career.co.kr/sms/career/Authentication";
					var parm = {};
					parm.authCode	= "2";					//sms: 1, email: 2
					parm.authvalue	= txtEmail;				//email 주소
					parm.username	= $.trim(txtName);		//회원명
					parm.sitename	= "취업포털 커리어넷";	//발송 제목(sms 발송시 자동 추가 됩니다.)
					parm.sitecode = "2"; //sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송 시 구분합니다.
					parm.memkind = "개인";
					parm.ip = "<%=site_IPAddr%>"; //개인 IP
					parm.callback = "jsonp_email_callback";
					$("#aEmail").text("인증번호 재전송");
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
			, error: function (XMLHttpRequest, textStatus, errorThrown) {
				alert("code:"+XMLHttpRequest.textStatus+"\n"+"message:"+XMLHttpRequest.responseText+"\n"+"error:"+errorThrown);
			}
		});
	}

	//Result 처리는 이곳에서 합니다.
	function jsonp_email_callback(data) {
		Authchk_ing = false;
		if ($.trim(data.result) == "true") {
			$("#emailAuthNumChk").val("1");

			$("#timeCntdown").show();
			fnDpFirst();
			fncDpTm(); //카운트

			$("#hd_idx").val(data.result_idx);
			$("#hd_kind").val("2");

			alert("인증번호가 발송되었습니다.");

			$("#rsltAuthArea").show();
			$("#rsltMsg_S").hide();
			$("#txtAuthNumber").val("");
			$("#txtAuthNumber").focus();
			$("#hd_type").val("2");
		} else {
			$("#emailAuthNumChk").val("0");
			alert("인증번호 발송이 실패하였습니다.");
		}
	}

	// 이메일 처리 결과 리턴
	function jsonp_result_callback(data) {
		if ($("#hd_type").val() == "2") {
			if ($.trim(data.result_idx) == "Y") {
				$("#emailAuthNumChk").val("4");
				//alert("인증이 완료되었습니다.");

				$("#emailAuthNumChk").val("4");
				//$("#txtAuthNumber").val('');
				$("#txtAuthNumber").attr("readonly",true);
				$("#rsltMsg_S").show();
				$("#authproc").val("1");
				$("#timeCntdown").hide();
				$("#rsltMsg_F").hide();
			} else {
				//alert("인증번호가 맞지 않습니다. 인증번호를 확인해 주세요.");

				$("#emailAuthNumChk").val("3");
				$("#rsltMsg_S").hide();
				$("#timeCntdown").show();
				$("#rsltMsg_F").show();
			}
		}
	}
	/*end*/
	/*이메일 인증코드 전송*/


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
		$("#txtAuthNumber").attr("readonly",false);
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

			if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() != "4") {
				$("#txtAuthNumber").val('');
				$("#txtAuthNumber").attr("placeholder","인증시간이 만료되었습니다.");
				$("#txtAuthNumber").attr("readonly",true);
				$("#rsltMsg_F").hide();
				return;
			} else if ($("#hd_kind").val() == "2" && $("#emailAuthNumChk").val() != "4") {
				$("#txtAuthNumber").val('');
				$("#txtAuthNumber").attr("placeholder","인증시간이 만료되었습니다.");
				$("#txtAuthNumber").attr("readonly",true);
				$("#rsltMsg_F").hide();
				return;
			}
		}
		else {
			tstop = setTimeout("fncDpTm()", 1000);
		}
	}

	// 인증번호 검증
	function fnAuthConfirm(){
		if ($("#hd_type").val() == "2" && $("#emailAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.\n비밀번호 저장 버튼을 클릭하여 비밀번호를 변경하시면\n휴면 해제 처리됩니다.");
			return;
		} else if ($("#hd_type").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.\n비밀번호 저장 버튼을 클릭하여 비밀번호를 변경하시면\n휴면 해제 처리됩니다.");
			return;
		}

		$("#txtAuthNumber").val($.trim($("#txtAuthNumber").val()));

		if ($("#hd_type").val() == "1") { // 알림톡
			if ($.trim($("#txtAuthNumber").val()) == "") {
				alert("인증번호를 입력해 주세요.");
				$("#txtAuthNumber").focus();
				return;
			}

			Authchk_ing = false;

			var strUrl = "/signup/auth/certify/ajaxAuthCodeConfirm.asp";
			var parm = {};

			parm.contact	= $("#txtPhone").val();
			parm.MemberKind	= "개인";
			parm.sitecode	= "2";	// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송 시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)
			parm.AuthNumber = $("#txtAuthNumber").val();
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
		}else { // 이메일
			if ($.trim($("#txtAuthNumber").val()) == "") {
				alert("인증번호를 입력해 주세요.");
				$("#txtAuthNumber").focus();
				return;
			}

			var strUrl = "https://app.career.co.kr/sms/career/AuthenticationResult";
			var parms = {};

			var strAuthKey = "";
			strAuthKey = $("#txtAuthNumber").val();

			if ( $.trim($("#hd_idx").val()) == "" || ($.trim($("#txtAuthNumber").val()) == "") ) {
				return;
			}

			parms.authCode	= $("#hd_type").val();	//sms: 1, email: 2
			parms.authvalue = strAuthKey;			//발송된 인증 KEY Value
			parms.idx		= $("#hd_idx").val();	//발송된 인증 번호
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

	}

	// 입력 정보 값 유효성 체크
	function fn_chkInfo(type){
		var joinType	= "<%=rs_memJoinType%>";

		var	txtId		= $("#txtId").val();	// 아이디
		var	txtName		= $("#txtName").val();	// 이름
		var	authType	= $("#hd_type").val();	// 인증 수단(1: sms, 2: email)
		var authValue	= "";

		if(!txtId) {
			alert("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}

		if(!txtName) {
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if (authType == "1" && $("#mobileAuthNumChk").val() == "4") {
			if (joinType == "2") {
				$("#inactive_Area").hide();
				$("#resetPw_Area").show();
				fn_move("#resetPw_Area");
			}else{
				// SNS간편로그인 회원의 경우 비번 초기화 없이 휴면 → 활성 상태로 DB 정보 이관 후 로그인 처리해야 함
				fn_Submit_Release();
			}
		} else if (authType == "2" && $("#emailAuthNumChk").val() == "4") {
			if (joinType == "2") {
				$("#inactive_Area").hide();
				$("#resetPw_Area").show();
				fn_move("#resetPw_Area");
			}else{
				// SNS간편로그인 회원의 경우 비번 초기화 없이 휴면 → 활성 상태로 DB 정보 이관 후 로그인 처리해야 함
				fn_Submit_Release();
			}
		} else {
		   alert('연락처 또는 이메일을 통한 본인 인증 후 휴면 해제 가능합니다.');
		   return;
		}
	}

	// 특정 영역 이동
	function fn_move(div_id){
        var offset = $(div_id).offset();
        $('html, body').animate({scrollTop : offset.top}, 400);
    }

	// 휴면 해제 처리
	function fn_Submit_Release() {
		var joinType	= "<%=rs_memJoinType%>";

		var txtId		= $("#txtId").val();	// 아이디
		var	txtName		= $("#txtName").val();	// 이름
		var	authType	= $("#hd_type").val();	// 인증 수단(1: sms, 2: email)
		var authValue	= "";

		var id	= txtId;

		if(!txtId) {
			alert("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}

		if(!txtName) {
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if (authType == "1" && $("#mobileAuthNumChk").val() == "4") {
		   authValue = $('#txtPhone').val();
		} else if (authType == "2" && $("#emailAuthNumChk").val() == "4") {
		   authValue = $('#txtEmail').val();
		} else {
		   alert('연락처 또는 이메일을 통한 본인 인증을 해주셔야 휴면 해제 가능합니다.');
		   return;
		}

		if (joinType == "2") {
			if ($('#txtPass').val().length == 0 ) {
				alert("비밀번호를 입력해 주세요.");
				$("#txtPass").focus();
				return;
			} else {
				if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 16) {
					alert("비밀번호는 8~16자 까지만 허용됩니다.");
					$("#txtPass").focus();
					return;
				}

				var pattern1 = /[0-9]/;		// 숫자
				var pattern2 = /[a-zA-Z]/;	// 문자
				var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자

				if (!pattern1.test($('#txtPass').val()) || !pattern2.test($('#txtPass').val()) || !pattern3.test($('#txtPass').val())) {
					alert("비밀번호는 8~16자 까지 영문, 숫자 및 특수문자의 조합으로\n생성해야 합니다.");
					$("#txtPass").focus();
					return;
				} else {
					if($('#txtPass').val().search(id) > -1) {
						alert("비밀번호에 아이디를 포함하여 생성할 수 없습니다.");
						$("#txtPass").focus();
						return;
					}

					if(/(\w)\1\1/.test($("#txtPass").val())) { // 같은 형식 문자 3글자 이상 사용 금지
						alert("동일한 문자 연속 3글자 이상은 사용 금지합니다.");
						$("#txtPass").focus();
						return;
					}
				}
			}

			if ($('#txtPassChk').val().split(" ").join("") == "") {
				alert("비밀번호 확인을 입력해 주세요.");
				$("#txtPassChk").focus();
				return;
			}

			if ($('#txtPass').val() != $('#txtPassChk').val()) {
				alert("비밀번호가 일치하지 않습니다.");
				$("#txtPassChk").focus();
				return;
			}
		}


		$.ajax({
			type: "POST" 
			, url: "Inactive_Member_Release_Proc.asp"
            , data: { txtId: escape(txtId), txtName: escape(txtName), txtPass: $('#txtPass').val(), authType: authType, authValue: authValue }
			, dataType: "html"
			, async: true
			, success: function (data) {
				//alert(data.trim());return;
				if (data.trim() == "S") {
					alert("휴면 해제 처리되었습니다.");
					location.href = "/";
				} else {
					alert("휴면 해제 중 오류가 발생했습니다.\n다시 시도해 주세요.");
					return;
				}
			}
			, error: function (XMLHttpRequest, textStatus, errorThrown) {
			   // alert(XMLHttpRequest.responseText);
			}
		});

	}
</script>
</head>

<body>

    <style>
	.headerMainCont{display: none !important;}
	body { background: none !important; }
	</style>
	<!-- 상단 -->
	<!--#include virtual = "/common/gnb/gnb_signup.asp"-->
	<link rel="stylesheet" href="/css/signup.css">

	<!-- 본문 -->
    <div id="container" class="container gray">
        <div class="contents">
            <div class="subContents">

				<div class="signup subpage" id="inactive_Area">
					<div class="innerWrap">
						<div class="signUpBoxArea">
							<div class="sgTit TXTC">휴면전환 계정 해제 안내</div>
							<div class="sgHr MT25"></div>
							<div class="sgsTit lg TXTC MT15">
						<%
							Select Case rs_memJoinType
								Case "2" :
									strJoinTypeUserId = f_hidUserId
								Case "31" :
									strJoinTypeUserId = "SNS간편로그인 - 네이버회원"
								Case "32" :
									strJoinTypeUserId = "SNS간편로그인 - 카카오회원"
								Case "33" :
									strJoinTypeUserId = "SNS간편로그인 - 구글회원"
								Case "34" :
									strJoinTypeUserId = "SNS간편로그인 - 페이스북회원"
								Case Else
									strJoinTypeUserId = "SNS간편로그인회원"
							End Select	
						%>
								<span class="red"><%=strJoinTypeUserId%></span>
								<span class="poi">님의 계정은 최근 1년간 접속하지 않으셨습니다.</span>
							</div>
							<div class="sgsTit TXTC">
								정보통신망 이용촉진 및 정보보호 등에 관한 법률 29조 제 2항 및 동법 시행령<br>
								제 16조에 의거, 해당 ID는 휴면계정으로 전환되었으며 간단한 본인인증을 통해,<br>
								ID <span class="red"><%=strJoinTypeUserId%></span>으로 등록하셨던 이력서 및 구직정보를 다시 활용하실 수 있습니다.
							</div>
							<div class="sgHr MT15"></div>
							<div class="FONT13 MT20 MB35 colorRed">* 필수 입력 정보입니다.</div>

							<form method="post" id="frm_memInactive" name="frm_memInactive">
							<input type="hidden" id="hd_idx" name="hd_idx" value="" /><%'번호인증 idx%>
							<input type="hidden" id="hd_idxNum" name="hd_idxNum" value="" /><%'번호인증 idx%>
							<input type="hidden" id="mobileAuthNumChk" name="mobileAuthNumChk" value="0" />
							<input type="hidden" id="emailAuthNumChk" name="emailAuthNumChk" value="0" />
							<input type="hidden" id="hd_type" name="hd_type" value="1" /><%'인증 구분자(1: sms, 2: email)%>
							<input type="hidden" id="hd_kind" name="hd_kind" value="2" />
							<input type="hidden" id="authproc" name="authproc" value="" />
							<input type="text" style="display:block; width:0px; height:0px; border:0;"><%'브라우저 로그인 정보 저장 동의 시 자동입력 방지용%>


							<div class="sgFormGroup">
								<!-- 인증방법:S -->
								<div class="sgTitle">
									<span class="poi">인증방법</span>
									<small class="sm">휴면전환 계정 해제를 위한 인증방법을 선택해 주세요.</small>
								</div>
								<div class="sgFormRadioArea">
									<div class="sgfBox">
										<label>
											<input type="radio" name="authType" value="authTypePhone" checked>
											<div class="lb">
												<span class="intx">휴대폰으로 인증받기</span>
											</div>
										</label>
									</div>
									<div class="sgfBox">
										<label>
											<input type="radio" name="authType" value="authTypeEmail">
											<div class="lb">
												<span class="intx">이메일로 인증받기</span>
											</div>
										</label>
									</div>
								</div>
								<!-- 인증방법:E -->

								<!-- 회원정보:S -->
								<div class="sgTitle MT50">
									<span class="poi">회원정보</span>
									<small class="sm">회원가입 시 입력한 본인 정보를 입력해 주세요.</small>
								</div>
								<div class="sgForm ">
									<input type="text" id="txtId" name="txtId" value="<%=f_hidUserId%>" readonly>
								</div>
								<div class="sgForm ">
									<input type="text" id="txtName" class="required" name="txtName" maxlength="15" placeholder="이름 (실명 입력)" autocomplete="off" />
								</div>
								<div class="sgForm absBtn" data-showhide="!authType">
									<input type="text" id="txtEmail" name="txtEmail" value="<%=rs_memEmail%>" maxlength="100" class="required" placeholder="이메일 주소" autocomplete="off" />
									<div class="abs">
										<button class="abtn" onclick="fn_emailCertifi(); return false;" id="aEmail">인증번호 전송</button>
									</div>
								</div>
								<div class="sgForm absBtn" data-showhide="!!authType">
									<input type="text" id="txtPhone" name="txtPhone" value="<%=rs_memPhone%>" maxlength="13" class="required" placeholder="휴대폰 번호 (번호만 입력)" onkeyup="fn_num_chk(this, 'int'); fn_changePhoneType(this);" autocomplete="off" />
									<div class="abs">
										<button class="abtn" onclick="fn_phoneCertifi(); return false;" id="aMobile">인증번호 전송</button>
									</div>
								</div>
								<div class="sgForm absBtn isInzNum" id="rsltAuthArea" style="display:none;">
									<input type="text" id="txtAuthNumber" name="txtAuthNumber" maxlength="6" class="required" placeholder="인증번호 입력" onkeyup="fn_removeChar(event)" onkeydown="return fn_onlyNumber(event)" autocomplete="off" />
									<span class="inzNum" id="timeCntdown" style="display:none;"><em>(00:00)</em></span>
									<div class="warMsg" id="rsltMsg_S" style="display:none;" data-params="success">
										<div class="intx">인증번호가 정상 입력 됐습니다.</div>
									</div>
									<div class="warMsg" id="rsltMsg_F" style="display:none;" data-params="error">
										<div class="intx">인증번호가 틀립니다.</div>
									</div>
									<div class="abs">
										<button class="abtn" onclick="fnAuthConfirm(); return false;">확인</button>
									</div>
								</div>
								<!-- 회원정보:E -->
							</div>

							<div class="btnsGroup MT40">
								<a href="javaScript:void(0);" onclick="javascript:fn_chkInfo();" class="abtn block blue lg">본인인증 완료</a>
							</div>
							</form>

							<div class="infMsgArea MT35">
								<div class="indTit">※ 휴면 해제가 정상 처리되지 않으실 경우 커리어넷 고객만족센터로 문의 바랍니다.</div>
								<div class="ifmBox">
									<span class="lb">TEL</span> : <a href="tel:<%=site_callback_phone%>" class="tel"><%=site_callback_phone%></a> | <span class="lb">FAX</span> : <%=site_fax%><br>
									<span class="lb">상담운영시간</span> : <%=site_helpdesk_opertime%><br>
									<span class="lb">e-mail</span> : <a href="mailto:<%=site_helpdesk_mail%>" class="mai"><%=site_helpdesk_mail%></a>
								</div>
							</div>

						</div>
					</div>
				</div>

                <!-- 비밀번호 재설정:S -->
				<div class="signup subpage" id="resetPw_Area" style="display:none;">
					<div class="innerWrap">
						<div class="signUpBoxArea">
							<div class="sgTit TXTC">휴면전환 계정 해제</div>
							<div class="sgsTit TXTC">
								비밀번호 재설정 후 이용 가능합니다.
							</div>
							<div class="sgHr MT35"></div>
							<div class="FONT13 MT30 MB35 colorRed">* 필수 입력 정보입니다.</div>
							<div class="sgTitle MT25">
								<span class="poi">새로운 비밀번호</span>를 입력해 주세요.
							</div>
							<div class="sgFormGroup">
								<div class="sgForm isInzNum">
                                    <input type="password" id="txtPass" name="txtPass" maxlength="16" class="required" placeholder="비밀번호 (8~16자 영문, 숫자, 특수문자 입력)" autocomplete="off" />
								</div>
								<div class="sgForm isInzNum">
                                    <input type="password" id="txtPassChk" name="txtPassChk" maxlength="16" class="required" placeholder="비밀번호 확인" autocomplete="off" />
								</div>
							</div>
							<div class="btnsGroup MT40">
                                <a href="javaScript:void(0);" onclick="javascript:fn_Submit_Release();" class="abtn block blue lg">비밀번호 저장</a>
							</div>
						</div>
					</div>
				</div>
                <!-- 비밀번호 재설정:E -->

            </div>
        </div>
    </div>
	<!-- //본문 -->

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

</body>
</html>
