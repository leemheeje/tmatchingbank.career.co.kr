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
				$(document).ready(function () {});
			</script>
			<div class="sub_visual" style="background-image: url(/images/bann/bann006.png);">
				<div class="visual_area">
					<h2>대체인력뱅크 채용정보</h2>
				</div>
			</div>

			<!-- 채용정보 :S -->
			<div class="empInfoArea MT70">
				<div class="innerWrap">

					<!-- 채용정보패널:S -->
					<div class="empPanArea">
						<!-- 직무:S -->
						<div class="emPanCol col1">
							<div class="ttit tp1">
								<span class="int">직무</span>
							</div>
							<div class="tCont">
								<div class="tConBox col6">
									<!-- foreach:S -->
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">경영.기획</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">전문직</span>
										</label>
									</div>
									<!-- foreach:E -->
								</div>
								<div class="tConBox col6">
									<!-- foreach:S -->
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">경영.기획</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">전문직</span>
										</label>
									</div>
									<!-- foreach:E -->
									<!-- 선택된거없을때:S -->
									<!-- <div class="nores">
										직무를 선택해 주세요.
									</div> -->
									<!-- 선택된거없을때:E -->
								</div>
							</div>
						</div>
						<!-- 직무:E -->
						<!-- 지역:S -->
						<div class="emPanCol col2">
							<div class="ttit tp2">
								<span class="int">지역</span>
							</div>
							<div class="tCont">
								<div class="tConBox col6">
									<!-- foreach:S -->
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">서울특별시</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">부산광역시</span>
										</label>
									</div>
									<!-- foreach:E -->
								</div>
								<div class="tConBox col6">
									<!-- foreach:S -->
									<!-- <div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">경영.기획</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="checkbox" id="" name="" value="">
											<span class="lb">전문직</span>
										</label>
									</div> -->
									<!-- foreach:E -->
									<!-- 선택된거없을때:S -->
									<div class="nores">
										지역를 선택해 주세요.
									</div>
									<!-- 선택된거없을때:E -->
								</div>
							</div>
						</div>
						<!-- 지역:E -->
						<!-- 신입/경력:S -->
						<div class="emPanCol col3">
							<div class="ttit tp3">
								<span class="int">신입/경력</span>
							</div>
							<div class="tCont">
								<div class="tConBox">
									<!-- foreach:S -->
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="a" value="">
											<span class="lb">신입</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="a" value="">
											<span class="lb">경력</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="a" value="">
											<span class="lb">경력무관</span>
										</label>
									</div>
									<!-- foreach:E -->
								</div>
							</div>
						</div>
						<!-- 신입/경력:E -->
						<!-- 학력:S -->
						<div class="emPanCol col4">
							<div class="ttit tp4">
								<span class="int">학력</span>
							</div>
							<div class="tCont">
								<div class="tConBox">
									<!-- foreach:S -->
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="b" value="">
											<span class="lb">전체</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="b" value="">
											<span class="lb">학력무관</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="b" value="">
											<span class="lb">고등학교 졸업</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="b" value="">
											<span class="lb">대학(2, 3년)졸업</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="b" value="">
											<span class="lb">대학교(4년) 졸업</span>
										</label>
									</div>
									<div class="lasForm">
										<label>
											<input type="radio" id="" name="b" value="">
											<span class="lb">석사학윈</span>
										</label>
									</div>
									<!-- foreach:E -->
								</div>
							</div>
						</div>
						<!-- 학력:E -->
					</div>
					<!-- 채용정보패널:E -->


					<!-- 리스트:S -->
					<div class="notice_area MT70" >
						<div class="searchArea" style="border-top: none;">
							<div class="searchInner">
								<div class="fl">
									<select class="tp2 MINWIDTH130 MR05">
										<option value="">최근업데이트순</option>
									</select>
									<span class="lnses"></span>
									<select class="tp2 MINWIDTH080 MR05">
										<option value="">40줄</option>
									</select>
								</div>
								<div class="fr">
									<div class="searchBox">
										<div>
											<input type="text" class="txt" id="" name="" placeholder="제목 또는 내용을 입력해 주세요" value="" style="width:377px;">
											<button type="button" class="btn typegray"><strong>검색</strong></button>
											<button type="button" class="btn typereset"><strong>초기화</strong></button>
										</div>
									</div><!-- .searchBox -->
								</div>
								<!--.fr-->
							</div>
							<!--.searchInner-->
						</div>
						<!-- 채용관련 테이블:S -->
						<div class="cmmTblTp recruit ">
							<div class="cttCont ">
								<table>
									<colgroup>
										<col class="col1">
										<col class="col2">
										<col class="col3">
										<col class="col4">
										<col class="col5">
										<col class="col6">
									</colgroup>
									<thead>
										<tr>
											<th> </th>
											<th>회사명</th>
											<th>채용제목</th>
											<th>지원자격</th>
											<th>근무조건</th>
											<th>마감일/등록일</th>
										</tr>
									</thead>
									<tbody>
										<!-- foreach:S -->
										<tr>
											<td colspan="2">
												<div class="cttCkNm">
													<div class="ckbBx"></div>
													<div class="txtBx">
														<div class="tpNm">
															<a href="#" class="tx">한국전력거래소한국전력거래소한국전력거래소</a>
															<a href="#" class="ic active" title="관심기업"></a>
														</div>
														<span class="otNm">산업통상자원부그룹</span>
													</div>
												</div>
											</td>
											<td>
												<div class="cttCntArea">
													<div class="txtBx">
														<div class="tpNm">
															<a href="/html/recruit/recruit_view.html" class="tx">2021년도 한국자산관리공사 채용형 청년인턴 채용공고</a>
															<a href="#" class="ic " title="스크랩"></a>
														</div>
														<div class="otNmArea">
															<span class="otNm">#웹기획</span>
															<span class="otNm">#웹디자인</span>
															<span class="otNm">#웹퍼블리셔</span>
															<span class="otNm">#산업</span>
															<span class="otNm">#기획</span>
														</div>
													</div>
												</div>
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">경력3년</span>
													<!-- "이상" 일때:S -->
													<span class="ico gt"></span>
													<!-- "이상" 일때:E -->
												</div>
												<div class="txsArea">
													<span class="itx">대학교(4년)</span>
													<!-- "이하" 일때:S -->
													<span class="ico lt"></span>
													<!-- "이하" 일때:E -->
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">정규직</span>
												</div>
												<div class="txsArea">
													<span class="itx">서울 강남구</span>
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<a href="#;" onclick="alert('작업중');" class="cttBtns radius org block FWB">
													<span class="icos check_7 white"></span>
													<span class="VMIDDLE">입사지원</span>
												</a>
												<div class="txsArea tp2 MT05">
													<span class="itx">~04/07(수)</span>
												</div>
												<div class="txsArea tp2">
													<span class="itx cgray">(3분 전 등록)</span>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<div class="cttCkNm">
													<div class="ckbBx"></div>
													<div class="txtBx">
														<div class="tpNm">
															<a href="#" class="tx">한국전력거래소</a>
															<a href="#" class="ic active" title="관심기업"></a>
														</div>
														<span class="otNm">산업통상자원부그룹</span>
													</div>
												</div>
											</td>
											<td>
												<div class="cttCntArea">
													<div class="txtBx">
														<div class="tpNm">
															<a href="/html/recruit/recruit_view.html" class="tx ">2021년도 상반기 한국전력거래소 공개채용</a>
															<a href="#" class="ic active" title="스크랩"></a>
														</div>
														<div class="otNmArea">
															<span class="otNm">#웹기획</span>
															<span class="otNm">#웹디자인</span>
															<span class="otNm">#웹퍼블리셔</span>
															<span class="otNm">#산업</span>
															<span class="otNm">#기획</span>
														</div>
													</div>
												</div>
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">경력3년</span>
													<!-- "이상" 일때:S -->
													<span class="ico gt"></span>
													<!-- "이상" 일때:E -->
												</div>
												<div class="txsArea">
													<span class="itx">대학교(4년)</span>
													<!-- "이하" 일때:S -->
													<span class="ico lt"></span>
													<!-- "이하" 일때:E -->
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">정규직</span>
												</div>
												<div class="txsArea">
													<span class="itx">서울 강남구</span>
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<a href="#;" class="cttBtns radius blue1 outline block">홈페이지</a>
												<div class="txsArea tp2 MT05">
													<span class="itx">~04/07(수)</span>
												</div>
												<div class="txsArea tp2">
													<span class="itx cgray">(3분 전 등록)</span>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<div class="cttCkNm">
													<div class="ckbBx"></div>
													<div class="txtBx">
														<div class="tpNm">
															<a href="#" class="tx">한국전</a>
															<a href="#" class="ic" title="관심기업"></a>
														</div>
														<span class="otNm">산업통상자원부그룹</span>
													</div>
												</div>
											</td>
											<td>
												<div class="cttCntArea">
													<div class="txtBx">
														<div class="tpNm">
															<a href="/html/recruit/recruit_view.html" class="tx ">온라인쇼핑몰/어린이집 ERP 고객상담(CS) 및 영업관리(교육기관 및 대리점 관리) 채용모온라인쇼핑몰/어린이집 ERP 고객상담(CS) 및 영업관리(교육기관 및 대리점 관리) 채용모</a>
															<a href="#" class="ic active" title="스크랩"></a>
														</div>
														<div class="otNmArea">
															<span class="otNm">#웹기획</span>
															<span class="otNm">#웹디자인</span>
															<span class="otNm">#웹퍼블리셔</span>
															<span class="otNm">#산업</span>
															<span class="otNm">#기획</span>
														</div>
													</div>
												</div>
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">경력3년</span>
													<!-- "이상" 일때:S -->
													<span class="ico gt"></span>
													<!-- "이상" 일때:E -->
												</div>
												<div class="txsArea">
													<span class="itx">대학교(4년)</span>
													<!-- "이하" 일때:S -->
													<span class="ico lt"></span>
													<!-- "이하" 일때:E -->
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">정규직</span>
												</div>
												<div class="txsArea">
													<span class="itx">서울 강남구</span>
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<a href="#;" onclick="alert('작업중');" class="cttBtns radius org block FWB">
													<span class="icos check_7 white"></span>
													<span class="VMIDDLE">입사지원</span>
												</a>
												<div class="txsArea tp2 MT05">
													<span class="itx">~04/07(수)</span>
												</div>
												<div class="txsArea tp2">
													<span class="itx cgray">(3분 전 등록)</span>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<div class="cttCkNm">
													<div class="ckbBx"></div>
													<div class="txtBx">
														<div class="tpNm">
															<a href="#" class="tx">한국전력거</a>
															<a href="#" class="ic" title="관심기업"></a>
														</div>
														<span class="otNm">산업통상자원부그룹</span>
													</div>
												</div>
											</td>
											<td>
												<div class="cttCntArea">
													<div class="txtBx">
														<div class="tpNm">
															<a href="/html/recruit/recruit_view.html" class="tx">강동구 상일동 오피스빌딩 시설관리 팀장 및 기사급 모집</a>
															<a href="#" class="ic active" title="스크랩"></a>
														</div>
														<div class="otNmArea">
															<span class="otNm">#웹기획</span>
															<span class="otNm">#웹디자인</span>
															<span class="otNm">#웹퍼블리셔</span>
															<span class="otNm">#산업</span>
															<span class="otNm">#기획</span>
														</div>
													</div>
												</div>
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">경력3년</span>
													<!-- "이상" 일때:S -->
													<span class="ico gt"></span>
													<!-- "이상" 일때:E -->
												</div>
												<div class="txsArea">
													<span class="itx">대학교(4년)</span>
													<!-- "이하" 일때:S -->
													<span class="ico lt"></span>
													<!-- "이하" 일때:E -->
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">정규직</span>
												</div>
												<div class="txsArea">
													<span class="itx">서울 강남구</span>
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<a href="#;" class="cttBtns radius blue1 outline block">홈페이지</a>
												<div class="txsArea tp2 MT05">
													<span class="itx">~04/07(수)</span>
												</div>
												<div class="txsArea tp2">
													<span class="itx cgray">(3분 전 등록)</span>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<div class="cttCkNm">
													<div class="ckbBx"></div>
													<div class="txtBx">
														<div class="tpNm">
															<a href="#" class="tx">한국전</a>
															<a href="#" class="ic" title="관심기업"></a>
														</div>
														<span class="otNm">산업통상자원부그룹</span>
													</div>
												</div>
											</td>
											<td>
												<div class="cttCntArea">
													<div class="txtBx">
														<div class="tpNm">
															<a href="/html/recruit/recruit_view.html" class="tx">.sdf</a>
															<a href="#" class="ic active" title="스크랩"></a>
														</div>
														<div class="otNmArea">
															<span class="otNm">#웹기획</span>
															<span class="otNm">#웹디자인</span>
															<span class="otNm">#웹퍼블리셔</span>
															<span class="otNm">#산업</span>
															<span class="otNm">#기획</span>
														</div>
													</div>
												</div>
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">경력3년</span>
													<!-- "이상" 일때:S -->
													<span class="ico gt"></span>
													<!-- "이상" 일때:E -->
												</div>
												<div class="txsArea">
													<span class="itx">대학교(4년)</span>
													<!-- "이하" 일때:S -->
													<span class="ico lt"></span>
													<!-- "이하" 일때:E -->
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">정규직</span>
												</div>
												<div class="txsArea">
													<span class="itx">서울 강남구</span>
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<a href="#;" onclick="alert('작업중');" class="cttBtns radius org block FWB">
													<span class="icos check_7 white"></span>
													<span class="VMIDDLE">입사지원</span>
												</a>
												<div class="txsArea tp2 MT05">
													<span class="itx">~04/07(수)</span>
												</div>
												<div class="txsArea tp2">
													<span class="itx cgray">(3분 전 등록)</span>
												</div>
											</td>
										</tr>
										<tr>
											<td colspan="2">
												<div class="cttCkNm">
													<div class="ckbBx"></div>
													<div class="txtBx">
														<div class="tpNm">
															<a href="#" class="tx">한국전력거래소</a>
															<a href="#" class="ic" title="관심기업"></a>
														</div>
														<span class="otNm">산업통상자원부그룹</span>
													</div>
												</div>
											</td>
											<td>
												<div class="cttCntArea">
													<div class="txtBx">
														<div class="tpNm">
															<a href="/html/recruit/recruit_view.html" class="tx">asdfasfasdfasdfasdfasdfasdfasdfdasdfasfasdfasdfasdfasdfasdfasdfdasdfasfasdfasdfasdfasdfasdfasdfdasdfasfasdfasdfasdfasdfasdfasdfd</a>
															<a href="#" class="ic active" title="스크랩"></a>
														</div>
														<div class="otNmArea">
															<span class="otNm">#웹기획</span>
															<span class="otNm">#웹디자인</span>
															<span class="otNm">#웹퍼블리셔</span>
															<span class="otNm">#산업</span>
															<span class="otNm">#기획</span>
														</div>
													</div>
												</div>
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">경력3년</span>
													<!-- "이상" 일때:S -->
													<span class="ico gt"></span>
													<!-- "이상" 일때:E -->
												</div>
												<div class="txsArea">
													<span class="itx">대학교(4년)</span>
													<!-- "이하" 일때:S -->
													<span class="ico lt"></span>
													<!-- "이하" 일때:E -->
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<!-- foreach:S -->
												<div class="txsArea">
													<span class="itx">정규직</span>
												</div>
												<div class="txsArea">
													<span class="itx">서울 강남구</span>
												</div>
												<!-- foreach:E -->
											</td>
											<td>
												<a href="#;" class="cttBtns radius org block FWB">
													<span class="icos check_7 white"></span>
													<span class="VMIDDLE">입사지원</span>
												</a>
												<div class="txsArea tp2 MT05">
													<span class="itx">~04/07(수)</span>
												</div>
												<div class="txsArea tp2">
													<span class="itx cgray">(3분 전 등록)</span>
												</div>
											</td>
										</tr>
										<!-- foreach:E -->
									</tbody>
								</table>
							</div>
						</div>
						<!-- 채용관련 테이블:E -->
					</div>
					<!-- 리스트:E -->



					<!-- 페이징:S -->
					<div class="pagingArea">
						<strong>1</strong>
						<a href="#">2</a>
					</div>
					<!-- 페이징:E -->
				</div>
			</div>

			<!-- 채용정보 :E -->

		</div>
	</div>

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->
	<!-- 하단 -->

</body>
</html>