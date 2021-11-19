<%
'--------------------------------------------------------------------
'   취업자료실> 취업성공 툴> 학점변환기
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 김진주
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0306"					' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp

Dim cur_point	: cur_point		= Request.Form("cur_point")
Dim point_type	: point_type	= Request.Form("point_type")
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script type="text/javascript" src="/js/user/cal_convert.js"></script>
<script type="text/javascript" src="/js/user/cal_convert_array.js"></script>
<script type = "text/javascript">
	$(document.body).ready(function () {
		$_menu_num = "2";
		var hCur_point	= $("#hdnCur_point");
		var hPoint_type = $("#hdnPoint_type");
		var pCur_point	= $("#cur_point");
		var pPoint_type = $("#point_type");

		if (hCur_point.val() != "") {
			pCur_point.val(hCur_point.val());
		}

		if (hPoint_type.val() != "") {
			pPoint_type.val(hPoint_type.val());
		}

		if (hCur_point.val() != "" && hPoint_type.val() != "") {
			fn_points_convert();
		}
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
                            <div class="clcTit inline">학점 변환기</div>
                            <div class="clcsTit inline ML10">내가 원하는 기업의 채용기준 학점에 내 점수가 해당되는지 확인해 보세요.</div>
                            <div class="calcInBox MT15">
                                <!-- 학점:S -->
                                <div class="clcTit sm line">내 점수 입력</div>
                                <div class="calcSalaryArea MT25">
                                    <div class="cmmInput tps2 inline VMIDDLE MINWIDTH200">
                                        <div class="ip nomargin xlg noradius borderblaack">
                                            <input type="text" id="cur_point" name="cur_point" type="text" placeholder="학점을 입력해 주세요" onkeyup = "return fn_chk_numeric_point(this);"/>
                                        </div>
                                    </div>
                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2">/</span>
                                    <div class="cmmInput tps2 inline VMIDDLE MINWIDTH200">
                                        <div class="ip nomargin xlg noradius borderblaack">
                                            <select class="customSelect" id="point_type">
                                                	<option value="4.0" ptype="A">4.0</option>
													<option value="4.3" ptype="B">4.3</option>
													<option value="4.5" ptype="C" selected>4.5</option>
													<option value="5.0" ptype="">5.0</option>
													<option value="6.0" ptype="">6.0</option>
													<option value="7.0" ptype="">7.0</option>
													<option value="100" ptype="D">100</option>
                                            </select>
                                        </div>
                                    </div>
                                    <a href="#;" class="btnss xlg org MINWIDTH160" onclick = "fn_points_convert();">학점 변환하기</a>
                                </div>
                                <div class="cmmLst indent indent8 MT10">
                                    <div class="cmmtp">- 커리어툴 학점변환 프로그램은 범용적인 기준으로 제작되기에 학교와 기업마다 기준이 다를 수 있으므로 약간의 오차가 발생할 수 있습니다.</div>
                                    <div class="cmmtp">- 회원님의 성적증명서를 필히 확인하시고, 변환을 해보시기 바랍니다.</div>
                                </div>
                                <!-- 학점:E -->

                            </div>
                            <div class="calcInBox outline MT30">
                                <div class="clcTit sm line">학점변환 결과</div>
                                <div class="calcSalaryArea MT25">
                                    <div class="crow allpadding">
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointA" ppoint="4.0" name="result_pointA" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">4.0 만점</span>
                                        </div>
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointB" ppoint="4.3" name="result_pointB" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">4.3 만점</span>
                                        </div>
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointC" ppoint="4.5" name="result_pointC" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">4.5 만점</span>
                                        </div>
                                        <div class="ccol3"></div>
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointE" ppoint="5.0" name="result_pointE" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">5.0 만점</span>
                                        </div>
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointA" ppoint="6.0" name="result_pointG" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">6.0 만점</span>
                                        </div>
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointF" ppoint="7.0" name="result_pointF" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">7.0 만점</span>
                                        </div>
                                        <div class="ccol3">
                                            <div class="cmmInput tps2 inline VMIDDLE w120">
                                                <div class="ip nomargin noradius">
                                                    <input type="text" id="result_pointD" ppoint="100" name="result_pointD" readonly />
                                                </div>
                                            </div>
                                            <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                            <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">100 만점</span>
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

	<input type="hidden" id="hdnCur_point" name="hdnCur_point" value="<%=cur_point %>" />
	<input type="hidden" id="hdnPoint_type" name="hdnPoint_type" value="<%=point_type %>" />

</body>
</html>
