<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 > 회원 탈퇴
' 	History		: 2021-08-05, 이샛별
'   DB TABLE	: dbo.개인회원정보
'---------------------------------------------------------------------
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
' 로그인 상태 접근 제한
Dim strLink : strLink = "/login/Login.asp?redir="&site_Url
If g_LoginChk="0" Then
	'Call FN_alertLink("해당 페이지에 대한 접근 권한이 없습니다.",strLink)
	Response.Redirect(strLink)
ElseIf g_LoginChk="2" Then
	Call FN_alertLink("기업회원 탈퇴는 고객센터로 문의 바랍니다.",strLink)
Else
End If

ConnectDB DBCon, Application("DBInfo")

	' 서비스 이용 카운트(지원 완료, 이력서 관리, 스크랩, 관심기업, 첨부파일 관리 수)
	ReDim param(0)
	param(0)		= makeParam("@IN_V_USER_ID", adVarChar, adParamInput, 50, user_id)
	arrRsSvcCnt		= arrGetRsSP(DBCon, "SPU_USER_SERVICE_AMOUNT_CNT", param, "", "")

DisconnectDB DBCon
%>
<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript">
	$(document).ready(function () {});

	function moveSection(){
		$('[data-showhide="!!memDrwSectionStep"]').toggleClass('show');
		$('[data-showhide="!memDrwSectionStep"]').toggleClass('show');
	}

	function fn_keyup() {
		if (event.keyCode == 13) {
			fn_pwChk();
		}
	}

	// 탈퇴 1단계 - 본인 확인(비번 인증)
	function fn_memInfoChk() {
		var joinType = "<%=user_join_type%>";

		if (joinType == "2") {
			if($('#txtPass').val() == "") {
				alert("비밀번호를 입력해 주세요.");
				$('#txtPass').focus();
				return;	
			}else {
				$.ajax({
					type: "POST"
					, url: "Withdraw_Member_Pw_Check.asp"
					, data: { user_pw: $("#txtPass").val() }
					, dataType: "text"
					, async: true
					, success: function (data) {
						if (data.trim() == "S") {
							moveSection();
							//$('#confirm').css("display","block");	
						}
						else {
							alert("비밀번호로 입력하신 정보가 일치하지 않습니다.\n다시 확인해 주세요.");
							$('#txtPass').focus();
							return;
						}
					}
					, error: function (XMLHttpRequest, textStatus, errorThrown) {
						//alert(XMLHttpRequest.responseText);
					}
				});
			}
		}else {
			moveSection();
		}
	}

	// 탈퇴 2단계 - 의사 재확인 및 최종 탈퇴
	function fn_Submit_withdraw() {
		var joinType		= "<%=user_join_type%>";
		var	txtName			= $("#txtName").val();		// 이름
		var txtPhone		= $("#txtPhone").val();		// 휴대폰
		var	txtOutReason	= $("#txtOutReason").val();	// 탈퇴사유

		if(txtName==""){
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if (joinType == "2") {
			if(txtPhone==""){
				alert("휴대폰번호를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}
		}
		
		if(txtOutReason==""){
			alert("탈퇴 사유를 입력해 주세요.");
			$('#txtOutReason').focus();
			return;
		}

		var msgConfirm = "";
		if (joinType == "2") {
			msgConfirm = "탈퇴 시 이력서 작성, 입사지원 등 기존 커리어 사용 이력이\n모두 삭제되며 추후 재가입하더라도\n동일한 아이디로 재가입이 불가능합니다.\n탈퇴 하시겠습니까?";
		}else{
			msgConfirm = "탈퇴 시 이력서 작성, 입사지원 등 기존 커리어 사용 이력이\n모두 삭제 됩니다.\n탈퇴 하시겠습니까?";
		}

		if (confirm(msgConfirm)){
			var queryString = $("form[name=frm_withdraw]").serialize();

			$.ajax({
				type : "POST"
				, url : "Withdraw_Member_Proc.asp"
				, data : queryString
				, dataType : "text"
				, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
				, success: function (data) {
					if (data.trim() == "S") {
						alert("탈퇴 처리되었습니다.");
						location.href = "/";
					}else {
						if (data.trim() == "E1"){
							alert("입력하신 이름이 일치하지 않습니다.\n다시 확인해 주세요.");
							$('#txtName').focus();
							return;
						}else if (data.trim() == "E2"){
							alert("입력하신 휴대폰번호가 일치하지 않습니다.\n다시 확인해 주세요.");
							$('#txtPhone').focus();
							return;						
						}else{
							alert("입력하신 정보가 일치하지 않습니다.\n다시 확인해 주세요.");
							$('#txtName').focus();
							return;						
						}
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert(XMLHttpRequest.responseText);
				}
			});
		}
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

			<input type="password" style="display:block; width:0px; height:0px; border:0;"><%'브라우저 로그인 정보 저장 동의 시 자동입력 방지용%>

				<!-- 회원탈퇴 STEP 1 :S -->
				<div class="signup subpage" data-showhide="!!memDrwSectionStep">
					<div class="innerWrap">
						<div class="signUpBoxArea">
							<div class="sgTit TXTC">회원탈퇴</div>
							<div class="sgsTit TXTC">
								회원탈퇴를 절차에 따라 진행하실 수 있습니다.
							</div>
							<div class="sgHr MT30"></div>
							<div class="sgTitle MT25">
						<%
						' 회원 구분에 따라 표기 문구 및 노출 항목 제어 - 가입사이트구분코드(2: 일반, 31: 네이버, 32: 카카오, 33: 구글, 34: 페이스북)
						If user_join_type="2" Then
						%>
								<span class="poi">비밀번호</span>
								<small class="sm">본인 확인을 위해 비밀번호를 한번 더 입력해주세요.</small>
						<%
						Else
							Select Case user_join_type
							Case "31" :
								strJoinTypeNm = "SNS간편로그인 - 네이버"
							Case "32" :
								strJoinTypeNm = "SNS간편로그인 - 카카오"
							Case "33" :
								strJoinTypeNm = "SNS간편로그인 - 구글"
							Case "34" :
								strJoinTypeNm = "SNS간편로그인 - 페이스북"
							Case Else
								strJoinTypeNm = "SNS간편로그인"
							End Select	
						%>
								<span class="poi"><%=strJoinTypeNm%></span>
								<small class="">을(를) 통해 가입한 회원입니다.</small>
						<%End If%>
							</div>
							<div class="sgFormGroup">
								<div class="sgForm">
									<input type="text" value="<%=user_id%>" readonly>
								</div>
						<%If user_join_type="2" Then%>
								<div class="sgForm">
									<input type="password" id="txtPass" name="txtPass" maxlength="16" onkeyup="fn_keyup();" class="required" placeholder="비밀번호 (8~16자 영문, 숫자, 특수문자 입력)" autocomplete="off" />
								</div>
						<%End If%>
							</div>
							<div class="btnsGroup MT40">
								<button class="abtn block blue lg" onclick="fn_memInfoChk(); return false;">확인</button>
							</div>
							<!-- 탈퇴시 정보:S -->
							<div class="infMsgArea MT35">
								<div class="indTit">※ 회원탈퇴 시 <span class="red">다음의 정보가 삭제되어 이용할 수 없게 됩니다.</span></div>
								<div class="ifmBox">
									<div class="ifmBoxGrid">
										<!-- foreach:S -->
										<div class="ifmGid">
											<div class="gnm">이력서</div>
											<div class="gvu"><%=arrRsSvcCnt(2, 0)%></div>
										</div>
										<div class="ifmGid">
											<div class="gnm">입사지원</div>
											<div class="gvu"><%=arrRsSvcCnt(1, 0)%></div>
										</div>
										<div class="ifmGid">
											<div class="gnm">관심기업</div>
											<div class="gvu"><%=arrRsSvcCnt(4, 0)%></div>
										</div>
										<div class="ifmGid">
											<div class="gnm">스크랩 공고</div>
											<div class="gvu"><%=arrRsSvcCnt(3, 0)%></div>
										</div>
										<!-- foreach:E -->
									</div>
								</div>
							</div>
							<div class="infMsg tp2 MT15">
								<!-- <div class="intx">· 커리어 패밀리 사이트(커리어센터, 대체인력뱅크 등)도 함께 탈퇴되어 로그인이 불가능해집니다.</div> -->
							<%If user_join_type="2" Then%>
								<div class="intx">· 추후 재가입하더라도 동일한 아이디로 재가입이 불가능합니다.</div>
							<%End If%>
								<div class="intx">· 회원님이 미리 설정한 정보에 따른 맞춤 채용정보를 받아보실 수 없습니다.</div>
								<div class="intx">· 커리어가 제공하는 교육 및 세미나 등의 정보를 받아보실 수 없습니다.</div>
								<div class="intx">· 다양한 커리어의 이벤트와 행사에 참가 불가능합니다.</div>
								<div class="intx">· 커리어가 제공하는 다양한 취업관련 서비스 혜택을 받으실 수 없습니다.</div>
								<div class="intx">· 결제하신 유료상품 및 적립된 포인트는 환불되지 않습니다.</div>
							</div>
							<!-- 탈퇴시 정보:E -->
						</div>
					</div>
				</div>
				<!-- 회원탈퇴 STEP 1 :E -->




				<!-- 회원탈퇴 STEP 2 :S -->
				<div class="signup subpage" data-showhide="!memDrwSectionStep">
					<div class="innerWrap">
						<div class="signUpBoxArea">
							<div class="sgTit TXTC">회원탈퇴</div>
							<div class="sgsTit TXTC">
								회원탈퇴를 절차에 따라 진행하실 수 있습니다.
							</div>
							<div class="sgHr MT30"></div>
							<div class="sgTitle MT25">
								<span class="poi">추천정보</span>
								<small  class="sm">회원탈퇴 대신 <span class="org">아래와 같은 방법을 추천</span>해 드립니다.</small>
							</div>
							<div class="rxGroupBox">
								<!-- foreach:S -->
								<div class="rxBoxs">
									<div class="inner">
										<div class="lt">
											<span class="img">
												<img src="/images/common/rxBoxs001.png">
											</span>
										</div>
										<div class="cont">
											<div class="tit">이력서 비공개 설정</div>
											<div class="stit">
												비공개 설정 시 회원님의 이력서 및 개인정보가 공개되지 않으며,
												다시 공개상태로 변경하시면 원활한 입사지원 활동이 가능합니다.
											</div>
											<a href="/user/resume/info.asp" target="_blank" class="lkc">이력서 비공개 설정하기</a>
										</div>
									</div>
								</div>
								<div class="rxBoxs">
									<div class="inner">
										<div class="lt">
											<span class="img">
												<img src="/images/common/rxBoxs002.png">
											</span>
										</div>
										<div class="cont">
											<div class="tit">메일링 서비스 수신 거부</div>
											<div class="stit">
												커리어에서 보내드리는 메일링 서비스가 귀찮으셨다면,
												메일링 수신 안 함으로 설정을 변경해 주세요.
											</div>
											<a href="/user/info/Member_Mailing.asp" target="_blank" class="lkc">메일링 설정 변경</a>
										</div>
									</div>
								</div>
								<!-- foreach:E -->
							</div>
							<div class="FONT13 MT15 MB35 colorRed">* 필수 입력 정보입니다.</div>
							<div class="sgTitle MT35">
								<span class="poi">회원정보</span>
								<small class="sm">아래 정보를 입력 후 회원탈퇴 신청을 해주세요.</small>
							</div>

							<form method="post" id="frm_withdraw" name="frm_withdraw" action="">
							<div class="sgFormGroup">
								<div class="sgForm">
									<input type="text" id="txtName" name="txtName" maxlength="30" class="required" placeholder="이름 (실명입력)" autocomplete="off" />
								</div>
								<div class="sgForm" <%If user_join_type<>"2" Then%>style="display:none;"<%End If%>>
									<input type="text" id="txtPhone" name="txtPhone" maxlength="13" class="required" placeholder="휴대폰 번호 (번호만 입력)" onkeyup="fn_num_chk(this, 'int'); fn_changePhoneType(this);" autocomplete="off" />
								</div>
								<div class="sgForm">
									<input type="text" id="txtOutReason" name="txtOutReason" maxlength="200" class="required" placeholder="탈퇴사유" />
								</div>
							</div>
							<div class="btnsGroup MT40">
								<button class="abtn block blue lg" onclick="fn_Submit_withdraw(); return false;">회원탈퇴 신청</button>
							</div>
							</form>
						</div>
					</div>
				</div>
				<!-- 회원탈퇴 STEP 2 :E -->

			</div>
		</div>
	</div>
	<!-- //본문 -->

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

</body>
</html>
