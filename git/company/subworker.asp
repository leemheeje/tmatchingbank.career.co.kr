<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%


%>
<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript">

</script>

	<!-- 상단 -->
	<!--#include virtual = "/common/gnb/gnb_main.asp"-->
	<!-- 상단 -->

	<div id="container" class="container">
		<div id="contents" class="contetns sub_page">

			<script>
				$(document).ready(function () {
					var $this = $(this);
					$this.include(true, [
						['희망직무', {
							target: '.cmmMainSearchPageArea[data-params="catjc"]',
							url: '/html/template/search_main_catjc.html',
							get: true
						}]
					]);
					$('.dtFormArea').on('click', '.tbts.add', function () {
						$(this).closest('.dtForsInBox').find('.fnMainSearchPannelDivision').addClass('showHideOn');
						$(this).hide();
						$(this).closest('.dtForsInBox').find('.tbts.res').show();
					})
					$('.dtFormArea').on('click', '.axnTbtn', function () {
						$(this).closest('.dtForsInBox').find('.fnMainSearchPannelDivision').removeClass('showHideOn');
						$(this).closest('.dtForsInBox').find('.tbts.add').show();
						$(this).closest('.dtForsInBox').find('.tbts.res').hide();
					})
				});
			</script>

			<div class="sub_visual" style="background-image: url(/images/bann/bann004.png);">
				<div class="visual_area">
					<h2>구인신청서</h2>
				</div>
			</div>

			<!-- 구인신청서 폼영역:S -->
			<div class="dtFormArea MT65">
				<div class="innerWrap">



					<div class="insRow">
						<div class="sTtit">구인신청서 기본정보</div>
						<div class="knkLstArea MT15">
							<div class="knkFormArea">
								<div class="kforms ">
									<table>
										<colgroup>
											<col width="200px">
											<col width="*">
											<col width="200px">
											<col width="*">
										</colgroup>
										<tbody>
											<tr>
												<th>기업명</th>
												<td>
													<div class="vrow">
														<div class="col12">
															<input type="text" value="커리어넷" class="read-non" readonly>
														</div>
													</div>
												</td>
												<th>사업자등록번호</th>
												<td>
													<div class="vrow">
														<div class="col12">
															<input type="text" value="220-86-73547" class="read-non" readonly>
														</div>
													</div>
												</td>
											</tr>
											<tr>
												<th>대표자명</th>
												<td>
													<div class="vrow">
														<div class="col12">
															<input type="text" value="홍길동" class="read-non" readonly>
														</div>
													</div>
												</td>
												<th>회사주소</th>
												<td>
													<div class="vrow">
														<div class="col12">
															<input type="text" value="(00000) 서울 구로구 디지털로 273, 2층 205호" class="read-non" readonly>
														</div>
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>

					<div class="insRow MT80">
						<div class="sTtit">채용 조건</div>
						<div class="dtFors MT15">
							<!-- foreach:S -->
							<div class="dtForsInBox">
								<span class="ldt">희망 직무</span>
								<div class="inBox">

									<div class="vInputTop">
										<!-- 선택없을때:S -->
										<!-- <span class="placeholder">희망 직무 4개. 직무당 키워드 5개씩 선택 가능</span> -->
										<!-- 선택없을때:E -->
										<!-- 선택있을때:S -->
										<div class="grop">
											<div class="grps">
												<div class="inb dp1">경영.사무</div>
												<div class="inb dp2">마케팅.광고.분석 </div>
												<div class="inb dp3">
													<span class="intx">광고기획</span>
													<button class="intb" title="삭제"></button>
												</div>
												<div class="inb dp3">
													<span class="intx">국제회의</span>
													<button class="intb" title="삭제"></button>
												</div>
											</div>
										</div>
										<!-- 선택있을때:E -->
										<div class="trs">
											<button class="tbts add">추가하기</button>
											<button class="tbts res">초기화</button>
										</div>
									</div>

									<div class="searchPennelBox catjc fnMainSearchPannelDivision" data-params="catjc">
										<div class="cmmMainSearchPageArea" data-params="catjc">
											<!-- 직무 /html/common/template/search_main_catjc.html -->
										</div>
									</div>

								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">채용 희망경력</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col00">
											<div class="radiochkButtonWrap">
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="B" value="" checked="">
															<span class="lb">신입</span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="B" value="">
															<span class="lb">경력</span>
														</label>
													</div>
												</div>
											</div>
										</div>
										<div class="col2 RELATIVE">
											<input type="text" maxlength="4" placeholder="">
											<label class="wn">년</label>
										</div>
										<div class="col2 RELATIVE">
											<div class="cmmInput radiochk MT10">
												<label>
													<input type="checkbox" id="" name="" value="">
													<span class="lb">경력무관</span>
												</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">최종 희망학력</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col00">
											<div class="radiochkButtonWrap">
												<!-- foreach:S -->
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="sch" value="" checked="">
															<span class="lb">초등학교</span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="sch" value="">
															<span class="lb">중학교 </span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="sch" value="">
															<span class="lb">고등학교 </span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="sch" value="">
															<span class="lb">대학(2,3년) </span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="sch" value="">
															<span class="lb">대학교 </span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="sch" value="">
															<span class="lb">대학원 </span>
														</label>
													</div>
												</div>
												<!-- foreach:E -->
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- foreach:E -->
						</div>
					</div>
					<div class="insRow MT80">
						<div class="sTtit">담당자 정보</div>
						<div class="dtFors MT15">
							<!-- foreach:S -->
							<div class="dtForsInBox border">
								<span class="ldt">담당자</span>
								<div class="inBox">

									<div class="vrow">
										<div class="col12">
											<input type="text" value="홍길동" class="read-non" readonly>
										</div>
									</div>

								</div>
							</div>
							<div class="dtForsInBox border">
								<span class="ldt">연락처 / 이메일</span>
								<div class="inBox">

									<div class="vrow">
										<div class="col12">
											<input type="text" value="010-4228-7877  /   ditak@career.co.kr" class="read-non" readonly>
										</div>
									</div>

								</div>
							</div>
							<!-- foreach:E -->
						</div>
					</div>




					<div class="btnsWrap TXTC MT55 MB60">
						<a href="#" class="sdbtns gblue xlg radius MINWIDTH260">구인신청서 등록하기</a>
					</div>
				</div>
			</div>
			<!-- 구인신청서 폼영역:E -->

		</div>
	</div>

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->
	<!-- 하단 -->

</body>
</html>