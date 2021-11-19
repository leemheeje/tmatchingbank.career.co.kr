<%
'--------------------------------------------------------------------
'   취업자료실> 취업성공 툴> 어학 변환기
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 이샛별
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------
Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0307"					' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp

Dim cur_point : cur_point = Request.Form("cur_point")
Dim exam_type : exam_type = Request.Form("exam_type")
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script type="text/javascript" src="/js/user/cal_lang.js"></script>
<script type="text/javascript" src="/js/user/cal_array.js"></script>
<script type = "text/javascript">
	$(document).ready(function(){
		var hCur_point	= $("#hdnCur_point");
		var h_type		= $("#hdn_type");
		var pCur_point	= $("#cur_point");
		var p_type		= $("#exam_type");

		if (hCur_point.val() != "") {
			pCur_point.val(hCur_point.val());
		}

		if (h_type.val() != "") {
			p_type.val(h_type.val());
		}

		if (hCur_point.val() != "" && h_type.val() != "") {
			fn_english_convert();
		}
		fn_type_change($("#exam_type").val());

		//fn_english_convert();
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
                            <div class="clcTit inline">어학 변환기</div>
                            <div class="clcsTit inline ML10">내가 원하는 기업의 채용기준 어학점수에 내 점수가 해당되는지 확인해 보세요.</div>
                            <div class="calcInBox MT15">
                                <!-- 학점:S -->
                                <div class="clcTit sm line">내 점수 입력</div>
                                <div class="calcSalaryArea MT25">
                                    <div class="cmmInput tps2 inline VMIDDLE MINWIDTH250">
                                        <div class="ip nomargin xlg noradius borderblaack">
                                            <input type="text" id="cur_point" name = "cur_point" placeholder="어학점수를 입력해 주세요" />
                                        </div>
                                    </div>
                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2">/</span>
                                    <div class="cmmInput tps2 inline VMIDDLE MINWIDTH200">
                                        <div class="ip nomargin xlg noradius borderblaack">

                                            <select class="customSelect" id="exam_type" onchange="fn_type_change(this.value)">
												<option value="TOEIC" selected="selected">TOEIC</option>
												<option value="TOEIC_S">TOEIC Speaking</option>
												<option value="TEPS">TEPS</option>
												<option value="NEWTEPS">NEW TEPS</option>
                                                <option value="TEPS_S">TEPS Speaking</option>
												<option value="IBT">TOEFL(IBT)</option>
                                            </select>
                                        </div>
                                    </div>
                                    <a href="#;" class="btnss xlg org MINWIDTH160" onclick ="fn_english_convert();">어학점수 변환하기</a>
                                </div>
                                <div class="cmmLst indent indent8 MT10">
									<div class="cmmtp colorBlack FWB" id="remark_toeic" style="display:none;"><em>-</em> 변환가능한 <span>TOEIC</span>의 총점은 <span>990</span>점 ~ <span>320</span>점이며, <span>5</span>점 단위로 입력이 가능합니다.</div>
									<div class="cmmtp colorBlack FWB" id="remark_toeic_s" style="display:none;"><em>-</em> 변환가능한 <span>TOEIC Speaking</span>의 총점은 <span>200</span>점 ~ <span>50</span>점이며, <span>10</span>점 단위로 입력이 가능합니다.</div>
									<div class="cmmtp colorBlack FWB" id="remark_teps" style="display:none;"><em>-</em> 변환가능한 <span>TEPS</span>의 총점은 <span>990</span>점 ~ <span>280</span>점이며, <span>1</span>점 단위로 입력이 가능합니다.</div>
									<div class="cmmtp colorBlack FWB" id="remark_teps_s" style="display:none;"><em>-</em> 변환가능한 <span>TEPS Speaking</span>의 총점은 <span>99</span>점 ~ <span>8</span>점이며, <span>1</span>점 단위로 입력이 가능합니다.</div>
									<div class="cmmtp colorBlack FWB" id="remark_ibt" style="display:none;"><em>-</em> 변환가능한 <span>TOEFL(IBT)</span>의 총점은 <span>120</span>점 ~ <span>17</span>점이며, <span>1</span>점 단위로 입력이 가능합니다.</div>
									<div class="cmmtp colorBlack FWB" id="remark_newteps" style="display:none;"><em>-</em> 변환가능한 <span>NEW TEPS</span>의 총점은 <span>600</span>점 ~ <span>150</span>점이며, <span>1</span>점 단위로 입력이 가능합니다.</div>			
                                    <div class="cmmtp">- 커리어툴 학점변환 프로그램은 범용적인 기준으로 제작되기에 학교와 기업마다 기준이 다를 수 있으므로 약간의 오차가 발생할 수 있습니다.</div>
                                    <div class="cmmtp">- 회원님의 성적증명서를 필히 확인하시고, 변환을 해보시기 바랍니다.</div>
                                </div>
                                <!-- 학점:E -->

                            </div>
                            <div class="calcInBox outline MT30">
                                <div class="clcTit sm line">어학점수 변환 결과</div>
                                <div class="calcSalaryArea MT25">
                                    <div class="crow allpadding">

                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>TOEIC 점수</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_toeic" name="result_point_toeic" arridx="0" readonly /><!--토익점수-->
                                                        </div>
                                                    </div>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">점</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">990점</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>TOEIC Speaking</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_toeic_s" name="result_point_toeic_s" arridx="1" readonly /><!--토익스피킹점수-->
                                                        </div>
                                                    </div>
                                                    <<span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">점</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">200점</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>TEPS 점수</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_ielts" name="result_point_ielts" arridx="2" readonly /><!--텝스점수-->
                                                        </div>
                                                    </div>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">점</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">990점</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>TEPS Speaking</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_ielts_s" name="result_point_ielts_s" arridx="3" readonly /><!--텝스스피킹점수-->
                                                        </div>
                                                    </div>
                                                    <<span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">점</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">99점</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>NEW TEPS 점수</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_ielts" name="result_point_ielts" arridx="4" readonly /><!--뉴텝스점수-->
                                                        </div>
                                                    </div>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">점</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">600점</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>TOFEL(IBT) 점수</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_ibt" name="result_point_ibt" arridx="5" readonly /><!--토플점수-->
                                                        </div>
                                                    </div>
                                                    <<span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">점</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">120점</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ccol55">
                                            <div class="tblLayout ciColmd">
                                                <div class="tlb">
                                                    <div class="cmmInput ">
                                                        <span class="lb"><span class="cmmDots w3 MR05"></span>OPIc</span>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput tps2 inline VMIDDLE w120">
                                                        <div class="ip nomargin noradius">
                                                            <input type="text" id="result_point_cbt" name="result_point_cbt" arridx="6" readonly /><!--OPIC점수-->
                                                        </div>
                                                    </div>
                                                    <<span class="INLINE_BLOCK VMIDDLE colorGry-1 MR10 FONT16">Lv</span>
                                                    <span class="INLINE_BLOCK VMIDDLE MR10 colorGry2 FONT12">/</span>
                                                    <span class="INLINE_BLOCK VMIDDLE colorGry-1 FONT16">AL</span>
                                                </div>
                                            </div>
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
	<input type="hidden" id="hdn_type" name="hdn_type" value="<%'=hdn_type %>" />

</body>
</html>
