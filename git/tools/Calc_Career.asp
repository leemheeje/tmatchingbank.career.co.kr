<%
'--------------------------------------------------------------------
'   취업자료실> 성공취업 툴> 경력 계산기
' 	최초 작성일	: 2021-11-01
'	최초 작성자	: 이샛별
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0305"					' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp


Dim salary_type			: salary_type		= Request("salary_type")
Dim dependency			: dependency		= Request("dependency")
Dim income_salary		: income_salary		= Request("income_salary")
Dim underage_children	: underage_children = Request("underage_children")
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script src="/js/tool/calc_career.js?<%=publishUpdateDt%>"></script>
<script type="text/javascript">
	$(document).ready(function () {
		fn_add_career();
	});
</script>
</head>

<body>

	<!-- 상단 -->
	<!--#include virtual = "/common/gnb/gnb_main.asp"-->

	<!-- 본문 -->
    <div id="container" class="container isLnb">
        <div class="contents">
            <div class="recruit subpage empolyArea">

				<!-- 좌측 메뉴 -->


                <div class="subContents isHeaderFixed MT85">
                    <div class="innerWrap isAside">
                        <div class="cmmTit">성공 취업 Tool</div>

						<!-- 취업성공툴 탑 부분 공통 영역 -->
						<!--#include file = "Tools_Top_Inc.asp"-->

                        <!-- 취업툴 컨텐츠:S -->
						<div class="calcContWrap MT45">
							<div class="clcTit inline">경력 계산기</div>
							<div class="clcsTit inline ML10">커리어 경력 계산기로 회원님의 총 경력을 쉽게 산출하실 수 있습니다.</div>
							<div class="calcInBox MT15">
								<div class="clcTit sm line">재직기간 입력</div>
								<div class="calcSalaryArea MT25">


									<div class="fnCarCalLstGroup">
										<!-- foreach:S -->
										<!-- <div class="form_row">
											<div class="cmmInput MR05 tps2 inline VMIDDLE MINWIDTH250">
												<div class="ip nomargin xlg noradius borderblaack">
													<input type="text" class="FONT16" placeholder="입사년월 (yyyy.mm)">
												</div>
											</div>
											<span class="INLINE_BLOCK VMIDDLE MR05 colorGry2">~</span>
											<div class="cmmInput MR05 tps2 inline VMIDDLE MINWIDTH250">
												<div class="ip nomargin xlg noradius borderblaack">
													<input type="text" class="FONT16" placeholder="입사년월 (yyyy.mm)">
												</div>
											</div>
											<a href="#;" class="btnss xlg blue5 MINWIDTH140 noradius FWN" onclick="fn_add_career();">경력기간 추가</a>
											<a href="#;" class="btnss xlg blue6 MINWIDTH100 noradius FWN ML05" onclick="fn_calculate();">삭제</a>
										</div> -->
										<!-- foreach:E -->
									</div>




								</div>
								<div class="cmmLst indent indent9 MT25">
									<div class="cmmtp colorBlack">- 재직기간 설정은 <span class="FWB">오름차순</span>으로만 가능합니다.</div>
									<div class="cmmtp">
										- 여러개의 경력을 가지고 계실 경우, 재직기간은 아는데 합산하느라 힘드셨죠?<br>
										커리어 총 경력계산기는 재직기간을 입력하면, 그에 대한 총 경력을 합산해주는 프로그램 입니다. 재직기간만 입력하시고 쉽게 총경력을 산출하세요.
									</div>
								</div>
								<div class="cmmHr line1 MT25"></div>
								<div class="btnsWrap TXTC MT30">
									<button class="btnss lg MINWIDTH160 org" onclick="fn_calculate();">경력 계산하기</button>
									<button class="btnss lg MINWIDTH160 outline inbg gray-2" onclick="fn_reset(); fn_add_career();">초기화</button>
								</div>


							</div>
							<div class="calcInBox outline MT30">
								<div class="clcTit sm line">총 경력 계산 결과</div>
								<div class="calcSalaryArea MT25">
									<div class="calcSalResult TXTC">
										<div class="inTxt FONT20" style="margin-top: -6px;">
											<span class="FWB">회원</span>님의 총 경력은 <span class="yel"><em id="result_year" name="result_year" class="nb FWB">00</em>년 <em id="result_month" name="result_month" class="nb FWB">00</em>개월</span> 입니다.
										</div>
									</div>
								</div>
							</div>
						</div>
                        <!-- 취업툴 컨텐츠:E -->

						<!-- 우측 퀵메뉴 -->

                    </div>
                </div>

            </div>
        </div>
    </div>
	<!-- //본문 -->

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

</body>
</html>
