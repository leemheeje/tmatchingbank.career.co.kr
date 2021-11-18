<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/mobile.asp"-->
<%
ConnectDB DBCon, Application("DBInfo")



DisconnectDB DBCon
%>
<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript">

</script>
</head>

<body>


	<!-- HEADER :S -->
	<!--include virtual = "/common/gnb/gnb_main.asp"-->
	<!-- HEADER :E -->

	<div id="container" class="container">
		<div class="contetns">

			<script>
				$(document).ready(function () {
					var $this = $(this);
					$this.find('.fnVisualSlideWrapping').uiSwiper({
						slideObj: {
							dots: true,
						}
					});
				});
			</script>
			<!-- 메인 컨텐츠 : S -->
			<div class="mainArea">
				<!-- 메인 비주얼 영역 :S -->
				<div class="maVisBannArea">
					<div class="innerWrap">

						<div class="maVisBanInner">
							<div class="lts">
								<div class="rcScp">
									<a href="#" class="img">
										<img src="/static/images/sample1.png" alt="">
									</a>
								</div>
								<div class="rcScp">
									<a href="#" class="img">
										<img src="/static/images/sample2.png" alt="">
									</a>
								</div>
							</div>
							<div class="mts">
								<div class="rcScp">
									<div class="vsBannerAa">
										<div class="vsBannIns fnVisualSlideWrapping">
											<!-- foreach:S -->
											<div class="tp">
												<a href="#" class="img">
													<img src="/static/images/sample3.png" alt="">
												</a>
											</div>
											<div class="tp">
												<a href="#" class="img">
													<img src="/static/images/sample3.png" alt="">
												</a>
											</div>
											<!-- foreach:E -->
										</div>
									</div>
								</div>
							</div>
							<div class="rts">
								<div class="rcScp">
									<a href="#" class="img">
										<img src="/static/images/sample4.png" alt="">
									</a>
								</div>
								<div class="rcScp">
									<div class="rcNoti">
										<div class="notcIns">
											<div class="nts">공지사항</div>
											<div class="ntlst">
												<!-- foreach:S -->
												<div class="tp"> <a href="#" class="txt">[이벤트] 인사담당자님 회원가입을 축하합니..</a></div>
												<div class="tp"> <a href="#" class="txt">[교육] 온라인교육센터 전 과정 무료!</a></div>
												<div class="tp"> <a href="#" class="txt">[이벤트] 페이스북 오픈 이벤트 잡아라~!</a></div>
												<!-- foreach:E -->
											</div>
											<a href="/board/notice_list.asp" class="admr">더보기</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
				<!-- 메인 비주얼 영역 :E -->

				<!-- 메인 본문 영역 :S -->
				<div class="maContArea MT30">
					<!-- 채용공고:S -->
					<div class="recArea">
						<div class="innerWrap">
							<div class="maTit">대체인력뱅크 최근 시작 채용공고</div>
							<div class="recBoxArea">



								<div class="cmmRecBoxGirdWrap prime MT15">
									<div class="cmmRecBoxGirdInner">
										<div class="gridBox">



											<!-- foreach:S -->
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 액체 추력기 시개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray active"></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<div class="gtp">
												<!-- box영역:S -->
												<div class="recBoxArea level1">
													<div class="recBoxFrt">
														<!-- <a href="#" class="img">
															<img src="/images/sample41.png" alt="" />
														</a> -->
														<a href="#" class="img" target="_blank">
															<img src="http://www2.career.co.kr/logo/201303/hanwhacorp.jpg" alt="">
														</a>
														<div class="hoverimg">
															<img src="/images/sample37.png" alt="">
														</div>
														<div class="txtbx">
															<span class="lbc">(주)한화</span>
															<a href="#" class="tit" target="_blank">종합연구소 위성 액체 추력기 시스템 개발(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="공고보기" target="_blank"></a>
													</div>
												</div>
												<!-- box영역:E -->
											</div>
											<!-- foreach:E -->



										</div>
									</div>
								</div>




							</div>
						</div>
					</div>
					<!-- 채용공고:E -->



					<div class="infsArea MT70">
						<div class="infsBanner">
							<div class="innerWrap">
								<div class="stit">대체인력뱅크는 고용노동부와 함께합니다.</div>
								<div class="tit JALNAN">
									대체인력뱅크란? <span class="poi">FAQ에서 궁금증 해결!</span>
								</div>
								<a href="/board/list.asp?gubun=2" class="bt">
									<span class="int">바로가기</span>
									<span class="ic"></span>
								</a>
							</div>
						</div>
						<div class="infsCont ">
							<div class="innerWrap">
								<div class="maTit">대체인력뱅크 취업성공 수기</div>
								<div class="grdArea MT30">
									<!-- foreach:S -->
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">장 (여, 40세)</span>
											<div class="txts">
												<div class="ttit">
													눈을 떠보니 어느날 취업이 되었
												</div>
												<div class="sttit">
													성공취업은 대체인력뱅크를 통해서라는 말
												</div>
											</div>
											<span class="adm">자세히 보기</span>
										</a>
									</div>
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">장화홍련 (여, 40세)</span>
											<div class="txts">
												<div class="ttit">
													눈을 떠보니 어느날 취업이 되었
													다! 대체인력뱅크 고맙습니다.
												</div>
												<div class="sttit">
													성공취업은 대체인력뱅크를 통해서라는 말
													이 있습니다. 절망적 인 상황에서 내게 손서 내게 서 내게 서 내게
												</div>
											</div>
											<span class="adm">자세히 보기</span>
										</a>
									</div>
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">장화홍련 (여, 40세)</span>
											<div class="txts">
												<div class="ttit">
													눈을 떠보니 어느날 취업이 되었
													다! 대체인력뱅크 고맙습니다.
												</div>
												<div class="sttit">
													성공취업은 대체인력뱅크를 통해서라는 말
													이 있습니다. 절망적 인 상황에서 내게 손서 내게 서 내게 서 내게
												</div>
											</div>
											<span class="adm">자세히 보기</span>
										</a>
									</div>
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">장화홍련 (여, 40세)</span>
											<div class="txts">
												<div class="ttit">
													눈을 떠보니 어느날 취업이 되었
												</div>
												<div class="sttit">
													성공취업은 대체인력뱅크를 통해서라는 말
													이 있습니다. 절망적 인 상황에서 내게 손서 내게 서 내게 서 내게
												</div>
											</div>
											<span class="adm">자세히 보기</span>
										</a>
									</div>
									<!-- foreach:E -->
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- 메인 본문 영역 :E -->
			</div>
			<!-- 메인 컨텐츠 : E -->



		</div>
	</div>


	<!-- FOOTER : S -->
	<!--#include virtual = "/common/footer_main.asp"-->
	<!-- FOOTER : E -->

</body>


</html>
