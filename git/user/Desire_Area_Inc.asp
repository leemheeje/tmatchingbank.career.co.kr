<%
'====================================================================
'   구직신청서 희망근무지
' 	최초 작성일	: 2021-11-19
'	최초 작성자	: 임상균
'====================================================================
%>
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<%

'지역코드 xml
Dim arrListArea1 '1차
arrListArea1 = getAreaList1()

ReDim arrListArea2(UBound(arrListArea1)) '2차
For i=0 To UBound(arrListArea1)
	arrListArea2(i) = getArrJcList(arrListArea1(i,0))
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
		$('.fnInnerScrollSearchAreaResult').cmmInnerScroll();
	});
</script>
<div class="scToolArea">
	<div class="cmmFormToolTipWrap tp2">
		<div class="cmmFormToolTipInner">
			<div class="cmmFormToolTipCont">

				<div class="jcjtSearchDivision">
					<div class="jcjtSearchTop paddingright">
						<div class="jtit">근무지역<small class="sm">(최대 3개까지 선택 가능)</small></div>
						<div class="appAutoSearchTarget INLINE_BLOCK VMIDDLE fnAppendAutoSearchTemplate">
							<!-- 실시간검색 불러오기 /html/common/template/auto_search_template.html -->
						</div>
					</div>
					<div class="jcjtSearchCont">
						<div class="crow collaps">
							<div class="ccol25 fnInnerScrollSearchColsResult">
								<div class="crow sm">
<% 
'getAcName 호출 > /wwwconf/code/code_function_ac.asp
%>
								<%
								If isArray(arrListArea1) Then
									For i=0 To UBound(arrListArea1)
								%>
									<div class="ccol12">
										<div class="cmmInput radiochk sm MB10">
											<a href="#;" class="vChkLabel FWB on"><%=arrListArea1(i, 1)%></a>
										</div>
									</div>
								<%
									Next
								End if
								%>
								</div>
							</div>
							
							<div class="ccol95 fnInnerScrollSearchColsResult">
								<!-- 선택영역이 있을때 :S -->
								<%Response.write "test " & UBound(arrListArea1)%>
								<% For i=0 To UBound(arrListArea1) %>
								<div class="crow sm">
									<!-- foreach:S -->
									<% For ii=0 To UBound(arrListArea2(i)) %>
									<div class="ccol3">
										<div class="cmmInput radiochk sm MB10">
											<label>
												<input type="checkbox">
												<span class="lb"><%=arrListArea2(i)(ii, 1)%></span>
											</label>
											<!-- <a href="#;" class="vChkLabel FWB">서울전체</a> -->
										</div>
									</div>
									<% Next %>
									<!-- foreach:E -->
								</div>
								<%next%>
								<!-- 선택영역이 있을때 :E -->
								<!-- 선택된거 없을때:S -->
								<div class="cmmNoResult tp2">지역을 선택해 주세요.</div>
								<!-- 선택된거 없을때:E -->

							</div>
						</div>
						<div class="tbArea ">
							<!-- <a href="#;" class="btnExtd fnSearchColsHeightExtend" data-toggle-class="btnExtd fnSearchColsHeightExtend extend" data-toggle-html="지역 접어보기">
								지역 펼쳐보기
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