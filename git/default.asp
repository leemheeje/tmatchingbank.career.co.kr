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
			<!-- ���� ������ : S -->
			<div class="mainArea">
				<!-- ���� ���־� ���� :S -->
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
											<div class="nts">��������</div>
											<div class="ntlst">
												<!-- foreach:S -->
												<div class="tp"> <a href="#" class="txt">[�̺�Ʈ] �λ����ڴ� ȸ�������� �����մ�..</a></div>
												<div class="tp"> <a href="#" class="txt">[����] �¶��α������� �� ���� ����!</a></div>
												<div class="tp"> <a href="#" class="txt">[�̺�Ʈ] ���̽��� ���� �̺�Ʈ ��ƶ�~!</a></div>
												<!-- foreach:E -->
											</div>
											<a href="/board/notice_list.asp" class="admr">������</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

				</div>
				<!-- ���� ���־� ���� :E -->

				<!-- ���� ���� ���� :S -->
				<div class="maContArea MT30">
					<!-- ä�����:S -->
					<div class="recArea">
						<div class="innerWrap">
							<div class="maTit">��ü�η¹�ũ �ֱ� ���� ä�����</div>
							<div class="recBoxArea">



								<div class="cmmRecBoxGirdWrap prime MT15">
									<div class="cmmRecBoxGirdInner">
										<div class="gridBox">



											<!-- foreach:S -->
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ��ü �߷±� �ð���(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray active"></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ����(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ����(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ����(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ����(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ����(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<div class="gtp">
												<!-- box����:S -->
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
															<span class="lbc">(��)��ȭ</span>
															<a href="#" class="tit" target="_blank">���տ����� ���� ��ü �߷±� �ý��� ����(~11/7)</a>
															<span class="detDt">~11/07</span>
														</div>
														<div class="recBot">
															<a href="#;" class="icos star_18 gray "></a>
															<div class="tr">
																<span class="tx">D-4</span>
															</div>
														</div>
														<a href="#" class="detBtn" title="������" target="_blank"></a>
													</div>
												</div>
												<!-- box����:E -->
											</div>
											<!-- foreach:E -->



										</div>
									</div>
								</div>




							</div>
						</div>
					</div>
					<!-- ä�����:E -->



					<div class="infsArea MT70">
						<div class="infsBanner">
							<div class="innerWrap">
								<div class="stit">��ü�η¹�ũ�� ���뵿�ο� �Բ��մϴ�.</div>
								<div class="tit JALNAN">
									��ü�η¹�ũ��? <span class="poi">FAQ���� �ñ��� �ذ�!</span>
								</div>
								<a href="/board/list.asp?gubun=2" class="bt">
									<span class="int">�ٷΰ���</span>
									<span class="ic"></span>
								</a>
							</div>
						</div>
						<div class="infsCont ">
							<div class="innerWrap">
								<div class="maTit">��ü�η¹�ũ ������� ����</div>
								<div class="grdArea MT30">
									<!-- foreach:S -->
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">�� (��, 40��)</span>
											<div class="txts">
												<div class="ttit">
													���� ������ ����� ����� �Ǿ�
												</div>
												<div class="sttit">
													��������� ��ü�η¹�ũ�� ���ؼ���� ��
												</div>
											</div>
											<span class="adm">�ڼ��� ����</span>
										</a>
									</div>
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">��ȭȫ�� (��, 40��)</span>
											<div class="txts">
												<div class="ttit">
													���� ������ ����� ����� �Ǿ�
													��! ��ü�η¹�ũ �����ϴ�.
												</div>
												<div class="sttit">
													��������� ��ü�η¹�ũ�� ���ؼ���� ��
													�� �ֽ��ϴ�. ������ �� ��Ȳ���� ���� �ռ� ���� �� ���� �� ����
												</div>
											</div>
											<span class="adm">�ڼ��� ����</span>
										</a>
									</div>
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">��ȭȫ�� (��, 40��)</span>
											<div class="txts">
												<div class="ttit">
													���� ������ ����� ����� �Ǿ�
													��! ��ü�η¹�ũ �����ϴ�.
												</div>
												<div class="sttit">
													��������� ��ü�η¹�ũ�� ���ؼ���� ��
													�� �ֽ��ϴ�. ������ �� ��Ȳ���� ���� �ռ� ���� �� ���� �� ����
												</div>
											</div>
											<span class="adm">�ڼ��� ����</span>
										</a>
									</div>
									<div class="tp">
										<a href="/board/jobclass_list.asp" class="gInns">
											<span class="glb">��ȭȫ�� (��, 40��)</span>
											<div class="txts">
												<div class="ttit">
													���� ������ ����� ����� �Ǿ�
												</div>
												<div class="sttit">
													��������� ��ü�η¹�ũ�� ���ؼ���� ��
													�� �ֽ��ϴ�. ������ �� ��Ȳ���� ���� �ռ� ���� �� ���� �� ����
												</div>
											</div>
											<span class="adm">�ڼ��� ����</span>
										</a>
									</div>
									<!-- foreach:E -->
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- ���� ���� ���� :E -->
			</div>
			<!-- ���� ������ : E -->



		</div>
	</div>


	<!-- FOOTER : S -->
	<!--#include virtual = "/common/footer_main.asp"-->
	<!-- FOOTER : E -->

</body>


</html>
