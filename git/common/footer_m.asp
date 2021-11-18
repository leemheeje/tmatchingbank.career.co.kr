<footer>
	<div class="f_menu">
		<ul>
			<li><a href="<%=g_mobile_wk%>">커리어 홈</a></li>
<%
' 로그인 상태에 따라 노출 영역 제어
If g_LoginChk="0" Then	' 비로그인 상태
%>
			<li><a href="/mobile/login/mLogin.asp">로그인</a></li>
			<li><a href="/mobile/signup/Join_Member.asp">회원가입</a></li>
<%
Else	' 로그인 상태
%>
			<li><a href="/login/Logout.asp">로그아웃</a></li>
<%
	If g_LoginChk="1" Then	' 개인회원 로그인
%>
			<li><a href="/mobile/user/jobs/Recruit.asp">맞춤채용</a></li>
<%
	Else	' 기업회원 서비스가 개발될 경우 기업회원 홈 연결 처리 필요!!
	End If
End If
%>
			<li><a href="/?bm=1" target="_blank">PC버전</a></li>
		</ul>
	</div>
	<div class="footer">
		<p class="tc"><a href="tel:<%=site_callback_phone%>" class="call"><%=site_callback_phone%></a></p>
		<div>
			<div class="link_area">
				<a href="<%=g_mobile_wk%>/help/PrivacyPolicy?gubun=2">이용약관</a>
				<a href="<%=g_mobile_wk%>/help/PrivacyPolicy?gubun=1">개인정보처리방침</a>
				<a href="javascript:void(0);" class="btn_toggle">CAREER</a>
			</div>
			<div class="career_info">
				<div class="circle_list">
					<ul>
						<li><%=site_com_name%> 대표이사 : <%=site_ceo_name%></li>
						<li>사업자등록번호 : <%=site_com_license%></li>
						<li>주소 : <%=site_addr_info%></li>
						<li>직업정보제공사업 신고번호 : <%=site_jobinfo_license%></li>
						<li>통신판매업 신고번호 : <%=site_electro_license%></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- 
	<div class="app_down">
		<h3>내 손에 취업 필수템! 커리어 앱</h3>
		<div class="d_flex">
			<a href="#" class="btn_android">안드로이드 설치하기</a>
			<a href="#" class="btn_ios">아이폰 설치하기</a>
		</div>
	</div> 
	-->

	<div class="dimmed"></div><!-- 공통 dimmed -->

	<script>
		/* footer info */
		$('.link_area .btn_toggle').click(function(){
			if($(this).hasClass('open')){
				$('.career_info').css('height','0');
				$(this).removeClass('open');
			} else {
				$('.career_info').css('height','auto');
				$(this).addClass('open');
			} return;
		});

		/* dimmed */
		$('.dimmed').click(function(){
			sidemenuClose();
		});
	</script>
</footer>