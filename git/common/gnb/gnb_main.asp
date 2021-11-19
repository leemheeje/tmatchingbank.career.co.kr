<script>
	$(document).ready(function () {
		var $event_target = $('.header .gnbArea .gnAsd, .header .gnbArea .gnb,.header .headerInner .dimmd');
		$event_target.on({
			'mouseenter': function () {
				$('.header').addClass('openlay');
				var arra = [];
				$('.dtpd').each(function () {
					var $this = $(this);
					var height = $this.outerHeight();
					arra.push(height);
				});
				if ($.__ARRAY_MAX) {
					$('.header .headerInner .dimmd').css('height', $.__ARRAY_MAX(arra) + 20);
				}
			},
			'mouseleave': function () {
				$('.header').removeClass('openlay');
			},
		});
	});
</script>
<div id="header" class="header">

	<div class="headerInner">
		<div class="dimmd"></div>
		<div class="innerWrap">
			<div class="hdStmap">
				
				<% '로그인 전 %>
				<div class="gdStInner">
					<a href="/signup/Join_Member.asp" class="gbtsn prim FWB">회원가입</a>
					<a href="/login/Login.asp" class="gbtsn navy FWB">로그인</a>
					<div class="grLayWr">
						<button class="gbtsn outline gray deRform">
							<span class="int">신청서</span>
							<span class="inc"></span>
						</button>
						<div class="lstsaArea">
							<div class="lstsa">
								<div class="tp"><a href="/user/subworker.asp" class="txt">구직신청</a></div>
								<div class="tp"><a href="/company/subworker.asp" class="txt">구인신청</a></div>
							</div>
						</div>
					</div>
					<a href="/board/notice_list.asp" class="gbtsn outline gray">공지사항</a>
				</div>
				<!--
				<% '로그인(개인) %>
				<div class="gdStInner">
					<div class="inst"><span class="poi">홍길동</span> 님</div>
					<a href="/login/Logout.asp" class="gbtsn navy FWB">로그아웃</a>
					<a href="#" class="gbtsn outline gray">구직신청서</a>
					<a href="/board/notice_list.asp" class="gbtsn outline gray">공지사항</a>
				</div>

				<% '로그인(기업) %>
				<div class="gdStInner">
					<div class="inst"><span class="poi">커리어넷</span> 님</div>
					<a href="/login/Logout.asp" class="gbtsn navy FWB">로그아웃</a>
					<a href="#" class="gbtsn outline gray">구인신청서</a>
					<a href="/board/notice_list.asp" class="gbtsn outline gray">공지사항</a>
				</div>

				<% '로그인(관리자) %>
				<div class="gdStInner">
					<div class="inst"><span class="poi">대체인력뱅크 관리자</span> 님</div>
					<a href="/login/Logout.asp" class="gbtsn navy FWB">로그아웃</a>
					<a href="/board/notice_list.asp" class="gbtsn outline gray">공지사항</a>
					<a href="#" class="gbtsn dnavy FWB">관리자</a>
				</div>
				-->
			</div>
			<div class="gnbArea">
				<a href="/" class="logo"></a>
				<!-- gnb:S -->
				<div class="gnb">
					<ul class="lst">
						<li class="tp active">
							<a href="#" class="txt">대체인력뱅크</a>
							<ul class="dtpd">
								<li class="stp active">
									<a href="#" class="txt">사업소개</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">지원금 안내</a>
								</li>
							</ul>
						</li>
						<li class="tp">
							<a href="#" class="txt">대체인력 채용정보</a>
						</li>
						<li class="tp">
							<a href="#" class="txt">온라인 교육센터</a>
						</li>
						<li class="tp">
							<a href="#" class="txt">소양교육</a>
						</li>
						<li class="tp">
							<a href="#" class="txt">기업전용 채용관</a>
							<ul class="dtpd">
								<li class="stp ">
									<a href="#" class="txt">신협 채용관</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">공공기관 채용정보</a>
								</li>
							</ul>
						</li>
						<li class="tp">
							<a href="#" class="txt">자료실</a>
							<ul class="dtpd">
								<li class="stp ">
									<a href="#" class="txt">취업 성공수기</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">취업/경제뉴스</a>
								</li>
								<li class="stp ">
									<a href="#" class="txt">시사상식 카드뉴스</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">노무상담 FAQ</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">성공취업 Tool</a>
								</li>
							</ul>
						</li>
					</ul>
				</div>
				<!-- gnb:E -->
				<div class="gnAsd">
					<div class="gnaInner">
						<div class="boxs">
							<a href="#" class="txt">구직자</a>
							<ul class="dtpd">
								<!-- foreach:S -->
								<li class="stp ">
									<a href="#" class="txt">구직신청</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">이력서 관리</a>
								</li>
								<li class="stp ">
									<a href="#" class="txt">이력서 등록</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">입사지원 관리</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">스크랩 공고</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">관심기업 공고</a>
								</li>
								<!-- foreach:E -->
							</ul>
						</div>
						<div class="boxs">
							<a href="#" class="txt">참여기업</a>
							<ul class="dtpd">
								<!-- foreach:S -->
								<li class="stp ">
									<a href="#" class="txt">구인신청</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">채용공고 관리</a>
								</li>
								<li class="stp ">
									<a href="#" class="txt">채용공고 등록</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">지원자 관리</a>
								</li>
								<li class="stp">
									<a href="#" class="txt">스크랩 인재</a>
								</li>
								<!-- foreach:E -->
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>