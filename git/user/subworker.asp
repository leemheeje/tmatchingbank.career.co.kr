<%
'====================================================================
'   구직신청서 작성
' 	최초 작성일	: 2021-11-19
'	최초 작성자	: 임상균
'====================================================================
%>
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
						['희망근무', {
							target: '.cmmMainSearchPageArea[data-params="area"]',
							url: '/user/Desire_Area_Inc.asp',
							get: true
						}]
					]);
					$this.include(true, [
						['희망직무', {
							target: '.cmmMainSearchPageArea[data-params="catjc"]',
							url: '/user/Desire_Jc_Inc.asp',
							get: true
						}]
					]);
					$this.include(true, [
						['희망산업', {
							target: '.cmmMainSearchPageArea[data-params="catct"]',
							url: '/html/template/search_main_catct.html',
							get: true
						}]
					]);
					$('.dtFormArea').on('click', '.tbts.add' , function(){
						$(this).closest('.dtForsInBox').find('.fnMainSearchPannelDivision').addClass('showHideOn');
						$(this).hide();
						$(this).closest('.dtForsInBox').find('.tbts.res').show();
					})
					$('.dtFormArea').on('click', '.axnTbtn' , function(){
						$(this).closest('.dtForsInBox').find('.fnMainSearchPannelDivision').removeClass('showHideOn');
						$(this).closest('.dtForsInBox').find('.tbts.add').show();
						$(this).closest('.dtForsInBox').find('.tbts.res').hide();
					})
				});
			</script>

			<div class="sub_visual" style="background-image: url(/images/bann/bann005.png);">
				<div class="visual_area">
					<h2>구직신청서</h2>
				</div>
			</div>

			<!-- 구직신청서 폼영역:S -->
			<div class="dtFormArea MT65">
				<div class="innerWrap">



					<div class="insRow">
						<div class="sTtit">구직신청서 기본정보</div>
						<div class="dtFors MT15">
							<!-- foreach:S -->
							<div class="dtForsInBox">
								<span class="ldt">신청자 / 나이 / 성별</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col35">
											<input type="text" value="홍길동" readonly>
										</div>
										<div class="col00">

											<div class="radiochkButtonWrap">
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="A" value="" checked="">
															<span class="lb">남자</span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="A" value="">
															<span class="lb">여자</span>
														</label>
													</div>
												</div>
											</div>

										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">주소 (거주지)</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col6">
											<input type="text" placeholder="클릭하고 주소를 검색해 주세요." readonly>
										</div>
										<div class="col6">
											<input type="text" placeholder="상세 주소를 입력해 주세요." readonly>
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">연락처(휴대폰)</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col6">
											<input type="text" placeholder="‘-’ 빼고 입력해 주세요.">
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">이메일</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col6">
											<input type="text" placeholder="이메일 주소를 입력해 주세요.">
										</div>
									</div>
								</div>
							</div>
							<!-- foreach:E -->
						</div>
					</div>

					<div class="insRow MT80">
						<div class="sTtit">희망 근무조건</div>
						<div class="dtFors MT15">
							<!-- foreach:S -->
							<div class="dtForsInBox">
								<span class="ldt">희망 근무지</span>
								<div class="inBox">

									<div class="vInputTop">
										<!-- 선택없을때:S -->
										<!-- <span class="placeholder">희망 근무지 3개까지 선택 가능</span> -->
										<!-- 선택없을때:E -->
										<!-- 선택있을때:S -->
										<div class="grop">
											<!-- foreach:S -->
											<div class="grps">
												<div class="inb dp1">서울</div>
												<!-- <div class="inb dp2">강남구 </div> -->
												<div class="inb dp3">
													<span class="intx">강남구</span>
													<button class="intb" title="삭제"></button>
												</div>
												<div class="inb dp3">
													<span class="intx">강동구</span>
													<button class="intb" title="삭제"></button>
												</div>
												<div class="inb dp3">
													<span class="intx">강동구</span>
													<button class="intb" title="삭제"></button>
												</div>
											</div>
											<div class="grps">
												<div class="inb dp1">인천</div>
												<!-- <div class="inb dp2">관악구</div> -->
												<div class="inb dp3">
													<span class="intx">서구</span>
													<button class="intb" title="삭제"></button>
												</div>
												<div class="inb dp3">
													<span class="intx">국제회의</span>
													<button class="intb" title="삭제"></button>
												</div>
											</div>
											<!-- foreach:E -->
										</div>
										<!-- 선택있을때:E -->
										<div class="trs">
											<button class="tbts add">추가하기</button>
											<button class="tbts res">초기화</button>
										</div>
									</div>


									<div class="searchPennelBox area fnMainSearchPannelDivision" data-params="area">
										<div class="cmmMainSearchPageArea" data-params="area">
											<!-- 희망근무지 /user/Desire_Area_Inc.asp -->
										</div>
									</div>


								</div>
							</div>
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
								<span class="ldt">희망산업</span>
								<div class="inBox">

									<div class="vInputTop">
										<!-- 선택없을때:S -->
										<span class="placeholder">희망 산업 2개. 산업당 키워드 5개씩 선택 가능</span>
										<!-- 선택없을때:E -->
										<!-- 선택있을때:S -->
										<!-- <div class="grop">
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
										</div> -->
										<!-- 선택있을때:E -->
										<div class="trs">
											<button class="tbts add">추가하기</button>
											<button class="tbts res">초기화</button>
										</div>
									</div>

									<div class="searchPennelBox catct fnMainSearchPannelDivision" data-params="catct">
										<div class="cmmMainSearchPageArea" data-params="catct">
											<!-- 직무 /html/template/search_main_catct.html -->
										</div>
									</div>

								</div>
							</div>
							<!--
							<div class="dtForsInBox">
								<span class="ldt">희망급여</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col4 RELATIVE">
											<input type="text" placeholder="희망급여를 입력해 주세요">
											<label class="wn">만원</label>
										</div>
										<div class="col2 RELATIVE">
											<div class="cmmInput radiochk MT10">
												<label>
													<input type="checkbox" id="" name="" value="">
													<span class="lb">회사 내규에 따름</span>
												</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">희망 근무기간 </span>
								<div class="inBox">
									<div class="vrow">
										<div class="col25 ">
											<input type="text" placeholder="YYYY. MM">
										</div>
										<div class="col00">
											<div class="MT15 FWB">~</div>
										</div>
										<div class="col25 ">
											<input type="text" placeholder="YYYY. MM">
										</div>
									</div>
								</div>
							</div>
							-->
							<!-- foreach:E -->
						</div>
					</div>


					<div class="insRow MT80">
						<div class="sTtit">학력.경력.자격증</div>
						<div class="dtFors MT15">
							<!-- foreach:S -->
							<div class="dtForsInBox">
								<span class="ldt">학력구분</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col35">
											<select>
												<option value="">학력구분</option>
											</select>
										</div>
										<div class="col2">
											<select>
												<option value="">졸업여부</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">경력</span>
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
											<input type="text" maxlength="2" placeholder="">
											<label class="wn">개월</label>
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">자격증</span>
								<div class="inBox">


									<script>
										$(document).ready(function () {
											(function ($this) { //추가삭제 관련 스크립트
												$('.fnStTogAppendWarpping').off();
												$('.fnStTogAppendWarpping').on('click', '.fnStTogAppendButton', function () {
													var $this = $(this);
													var $wrapping = $this.closest('.fnStTogAppendWarpping');
													var $appendTarget = $wrapping.find('.fnStTogAppendTarget');
													var html = [
														'<div class="sttBox fnStTogInner">',
														'	<div class="vrow">',
														'		<div class="col6">',
														'			<input type="text">',
														'		</div>',
														'		<div class="col45">',
														'			<input type="text">',
														'		</div>',
														'		<div class="col15">',
														'			<button class="sdbtns lgray outline block fnStTogRemoveButton">- 삭제하기</button>',
														'		</div>',
														'	</div>',
														'</div>',
													].join('');
													$appendTarget.append(html);
												});
												$('.fnStTogAppendWarpping').on('click', '.fnStTogRemoveButton', function () {
													$(this).closest('.fnStTogInner').remove();
												});

											})($(document));
										});
									</script>
									<!-- 추가삭제:S -->
									<div class="stTogAppendArea fnStTogAppendWarpping">
										<div class="stInner fnStTogAppendTarget">
											<!-- foreach:S -->
											<div class="sttBox fnStTogInner">
												<div class="vrow">
													<div class="col6">
														<input type="text">
													</div>
													<div class="col45">
														<input type="text">
													</div>
													<div class="col15">
														<button class="sdbtns black block fnStTogAppendButton">+ 추가하기</button>
													</div>
												</div>
											</div>
											<!-- <div class="sttBox fnStTogInner">
												<div class="vrow">
													<div class="col6">
														<input type="text">
													</div>
													<div class="col45">
														<input type="text">
													</div>
													<div class="col15">
														<button class="sdbtns lgray outline block">- 삭제하기</button>
													</div>
												</div>
											</div> -->
											<!-- foreach:E -->
										</div>
									</div>
									<!-- 추가삭제:E -->



								</div>
							</div>
							<!-- foreach:E -->
						</div>
					</div>



					<div class="insRow MT80">
						<div class="sTtit">첨부파일</div>
						<div class="dtFors MT15">
							<!-- foreach:S -->
							<div class="dtForsInBox">
								<span class="ldt">파일구분</span>
								<div class="inBox">
									<div class="vrow">
										<div class="col35">
											<select>
												<option value="">구분선택</option>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="dtForsInBox">
								<span class="ldt">경력</span>
								<div class="inBox">
									<div class="vrow ">
										<div class="col00">
											<div class="radiochkButtonWrap">
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="C" value="" checked="">
															<span class="lb">파일 업로더</span>
														</label>
													</div>
												</div>
												<div class="radiochkButtonCol">
													<div class="cmmInput radiochk">
														<label>
															<input type="radio" id="" name="C" value="">
															<span class="lb">URL 입력</span>
														</label>
													</div>
												</div>
											</div>
										</div>

									</div>
									<div class="vrow MT10">
										<div class="col7">
											<!-- 파일업로드일때:S -->
											<div class="fidForm file">
												<input type="file" class="ui-input-file">
											</div>
											<!-- 파일업로드일때:E -->
											<!-- URL입력일때:S -->
											<input type="text">
											<!-- URL입력일때:E -->
										</div>
									</div>
								</div>
							</div>
							<!-- foreach:E -->
						</div>
						<div class="infs">
							<div class="tx">- 파일형식 : ppt, pptx, xls, xlsx, doc, docx, pdf, hwp, jpg, jpeg, png (각 개별파일 30MB 첨부 가능)</div>
							<div class="tx">- 파용량이 큰 파일은 외부 링크를 활용하셔서 등록해 주세요</div>
							<div class="tx">- 파이용자의 부주의나 기본적인 인터넷의 위험성 때문에 발생한 문제에 대해 책임지지 않습니다.</div>
							<div class="tx">- 파이력서 파일을 첨부할 경우, 민감정보 (주민등록번호)와 개인정보 (연락처 등)는 삭제 후 업로드 해주세요.</div>
						</div>
					</div>


					<div class="btnsWrap TXTC MT55 MB60">
						<a href="#" class="sdbtns gblue xlg radius MINWIDTH260">구직신청서 등록하기</a>
					</div>
				</div>
			</div>
			<!-- 구직신청서 폼영역:E -->

		</div>
	</div>

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->
	<!-- 하단 -->

</body>
</html>