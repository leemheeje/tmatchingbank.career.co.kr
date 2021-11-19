<%
'====================================================================
'   구직신청서 희망직종
' 	최초 작성일	: 2021-11-19
'	최초 작성자	: 임상균
'====================================================================
%>
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<%
'직종코드 xml
Dim arrListJc1 '1차
arrListJc1 = getArrJcList1()

ReDim arrListJc2(UBound(arrListJc1)) '2차
For i=0 To UBound(arrListJc1)
	arrListJc2(i) = getArrJcList2(arrListJc1(i,0))
Next

ReDim arrListJc3(UBound(arrListJc1)) '3차
For i=0 To UBound(arrListJc1)
	arrListJc3(i) = getArrJcList3(arrListJc1(i,0))
Next

%>
<script>
	$(document).ready(function () {
		$(this).include(true, [
			['실시간검색', {
				target: '.fnAppendAutoSearchTemplate',
				url: '/html/template/auto_search_template.html',
				get: true
			}]
		]);
		$('.fnInnerScrollSearchCatjcResult').cmmInnerScroll();
	});
</script>
<div class="scToolArea">
	<div class="cmmFormToolTipWrap tp2">
		<div class="cmmFormToolTipInner">
			<div class="cmmFormToolTipCont">

				<div class="jcjtSearchDivision">
					<div class="jcjtSearchTop paddingright">
						<div class="jtit">직무.키워드<small class="sm">(직무 최대3개 / 키워드 직무별 최대 5개 선택 가능)</small></div>
						<div class="appAutoSearchTarget INLINE_BLOCK VMIDDLE fnAppendAutoSearchTemplate">
							<!-- 실시간검색 불러오기 /html/common/template/auto_search_template.html -->
						</div>
					</div>
					<div class="jcjtSearchCont">
						<div class="crow collaps">
							<div class="ccol25 fnInnerScrollSearchColsResult">
<% 
'getJcName 호출 > /wwwconf/code/code_function_jc.asp
%>
								<%
								If IsArray(arrListJc1) Then
									For i=0 To UBound(arrListJc1)
								%>
									<div class="cmmInput radiochk sm MB10">
										<a href="#;" class="vChkLabel FWB on"><%=arrListJc1(i,1)%></a>
									</div>
								<%
									Next
								End If
								%>
							</div>
							<div class="ccol25 fnInnerScrollSearchColsResult">
								<%
								For i=0 To UBound(arrListJc1) 
									For ii=0 To UBound(arrListJc2(i))
								%>
									<div class="cmmInput radiochk sm MB10">
										<label>
											<input type="checkbox">
											<span class="lb"><%=arrListJc2(i)(ii, 1)%></span>
										</label>
										<!-- <a href="#;" class="vChkLabel FWB on">유통.백화점.도소매</a> -->
									</div>
								<%
									Next
								Next
								%>
								
								<div class="cmmInput radiochk sm MB10">
									<label>
										<input type="checkbox">
										<span class="lb">무역.상사</span>
									</label>
									<!-- <a href="#;" class="vChkLabel FWB">무역.상사</a> -->
								</div>
							</div>
							<div class="ccol7 fnInnerScrollSearchColsResult">
								<!-- 선택영역이 있을때 :S -->
								<!-- foreach:S -->
								<div class="jjsRstArea">
									<div class="jjsRstAreTit">마케팅.광고.분석</div>
									<div class="crow sm">
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">전체</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">전체</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
									</div>
								</div>
								<div class="jjsRstArea">
									<div class="jjsRstAreTit">마케팅.광고.분석</div>
									<div class="crow sm">
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">전체</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">전체</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
										<div class="ccol4">
											<div class="cmmInput radiochk sm MB10">
												<label>
													<input type="checkbox">
													<span class="lb">프로모션</span>
												</label>
												<!-- <a href="#;" class="vChkLabel FWB">프로모션</a> -->
											</div>
										</div>
									</div>
								</div>
								<!-- foreach:E -->
								<!-- 선택영역이 있을때 :E -->
								<!-- 선택된거 없을때:S -->
								<div class="cmmNoResult tp2">직무를 선택해 주세요.</div>
								<!-- 선택된거 없을때:E -->
							</div>
						</div>
						<div class="tbArea">
							<!-- <a href="#;" class="btnExtd fnSearchColsHeightExtend" data-toggle-class="btnExtd fnSearchColsHeightExtend extend" data-toggle-html="직무 접어보기">
								직무 펼쳐보기
							</a>
							<a href="#" class="searchBtnsInt ML15">선택 초기화</a> -->
							<button class="axnTbtn gray">취소</button>
							<button class="axnTbtn cblue ML05">확인</button>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>