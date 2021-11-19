<%
'--------------------------------------------------------------------
'   취업자료실> 성공취업 툴> 연봉 계산기
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 김진주
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0304"						' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp


Dim salary_type			: salary_type		= Request("salary_type")
Dim dependency			: dependency		= Request("dependency")
Dim income_salary		: income_salary		= Request("income_salary")
Dim underage_children	: underage_children = Request("underage_children")
'dim retiring_type	: retiring_type = Request.Form("retiring_type") 퇴직금 별도
'dim tax_free		: tax_free		= Request.Form("tax_free")
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script type="text/javascript" src = "/js/user/cal_salCal.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		fn_toggle_input('#tax_free', false);
		/*fn_chk_dependency();*/

		$("input[name=salary_type]").bind("click", function () {
			if ($(this).val() == "annual") {
				$("#tr_retiring").show().children().show();
				$("#tr_retiring span").show().children().show();
				$("#tr_retiring2").hide().children().hide();
				$("#salary_type_text").text("연봉입력");
			} else {
				$("#tr_retiring").hide().children().hide();
				$("#tr_retiring span").hide().children().hide();
				$("#tr_retiring2").show().children().show();
				$("#salary_type_text").text("월급입력");
			}
		});

		var hSalary_type		= $("#hdnSalary_type");
		var hDependency			= $("#hdnDependency");
		var hUnderage_children	= $("#hdnUnderage_children");
		var hIncome_salary		= $("#hdnIncome_salary");
		//var hInDi = $("#hdnDi");

		var oSalary_type		= $("#salary_type");
		var oDependency			= $("#dependency");
		var oUnderage_children	= $("#underage_children");
		var oIncome_salary		= $("#income_salary");
		//var oDi = $("#di");

		if (hSalary_type.val() != "") {
			$("input[name=salary_type]").filter('input[value=' + hSalary_type.val() + ']').attr("checked", "checked");
		}

		if (hDependency.val() != "") {
			//alert(hDependency.val());
			if (hDependency.val() == "0") {
				hDependency.val("1")
			}

			oDependency.val(hDependency.val());
			/*fn_chk_dependency(document.getElementById("dependency"));*/
			fn_set_commval(document.getElementById("dependency"));
		}

		if (hUnderage_children.val() != "") {
			$("input[name=underage_children]").filter('input[value=' + hUnderage_children.val() + ']').attr("checked", "checked");
		}

		if (hIncome_salary.val() != "") {
			oIncome_salary.val(hIncome_salary.val());
		}

		//if (hSalary_type.val() != "" && hIncome_salary.val() != "") {
		//      fn_calculate();
		//  }

		$('.fnActCheckbox').change(function(){ //직접입력 체크시
			if($(this).is(':checked')){
				$('.fnActInput').prop('readonly', false);
			}else{
				$('.fnActInput').prop('readonly', true);
			}
		});

		function autoResize(i){
			var iframeHeight=
			(i).contentWindow.document.body.scrollHeight;
			(i).height=iframeHeight+20;
		}

		/*radio check error 개선*/
		$(document).ready(function() {
		  $('input:radio').click(function() {
			$('input:radio[name='+$(this).attr('name')+']').parent().removeClass('on');
				$(this).parent().addClass('on');
			});
		});
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
                            <div class="clcTit inline">연봉 계산기</div>
                            <div class="clcsTit inline ML10">자신의 연봉 및 월급을 입력해 보세요. 세금을 제외한 실 급여를 계산해 드립니다.</div>
                            <div class="calcInBox MT15">
                                <!-- 연봉영역:S -->
                                <div class="clcTit sm line">현재(희망)연봉 입력</div>
                                <div class="calcSalaryArea MT25">
                                    <div class="crow">
                                        <!-- 연봉/월급 선택:S -->
                                        <div class="ccol4">
                                            <div class="tblLayout ciColsm">
                                                <div class="tlb">
                                                    <div class="cmmInput">
                                                        <span class="lb">연봉/월급 선택</span>
                                                    </div>
                                                </div>
                                                <div class="tip">
                                                    <div class="cmmRadiochkButtonWrap tp4">
                                                        <div class="cmmRadiochkButtonCol">
                                                            <div class="cmmInput radiochk">
                                                                <label class = "radiobox on">
                                                                    <input type="radio" value=""  checked="checked"  class="rdi" id="annual_salary" name="salary_type" value="annual">
                                                                    <div class="lb"><span class="int">연봉</span></div>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="cmmRadiochkButtonCol">
                                                            <div class="cmmInput radiochk">
                                                                <label class="radiobox">
                                                                    <input type="radio" class="rdi" id="monthly_salary" name="salary_type" value="monthly">
                                                                    <div class="lb"><span class="int">월급</span></div>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 연봉/월급 선택:E -->
                                        <!-- 퇴직금:S -->
                                        <div class="ccol4">
                                            <div class="tblLayout ciColxsm">
                                                <div class="tlb"  style="z-index: 1;">
                                                    <div class="cmmInput inline VMIDDLE">
                                                        <span class="lb">퇴직금</span>
                                                    </div>
                                                    <!-- <div class="cmmLocTooltipButton tp3 VMIDDLE MR20">
                                                        <div class="cmmLocTooltipWrap">
                                                            <div class="cmmLocTooltipInner MINWIDTH200">
                                                                <div class="clttLst">
                                                                    <div class="clttTp">
                                                                        <div class="txt FONT12 FWN MINWIDTH200">
                                                                            건강보험료는 3.06% 공제합니다.<br />단, 비과세액이 있을 경우, 비과세액을 제외한 과세금액에서만 세액이 공제됩니다.
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div> -->
                                                </div>
                                                <div class="tip">
                                                    <div class="cmmRadiochkButtonWrap tp4">
                                                        <div class="cmmRadiochkButtonCol">
                                                            <div class="cmmInput radiochk">
                                                                <label  class="radiobox on">
                                                                    <input type="radio" class="rdi" id="rg01" name="retiring_type" checked="checked">
                                                                    <div class="lb"><span class="int">별도</span></div>
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="cmmRadiochkButtonCol">
                                                            <div class="cmmInput radiochk">
                                                                <label class="radiobox">
                                                                    <input type="radio" class="rdi" id="rg02" name="retiring_type">
                                                                    <div class="lb"><span class="int">포함</span></div>
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 퇴직금:E -->
                                        <!-- 비과세액:S -->
                                        <div class="ccol8">
                                            <div class="tblLayout ciColsm">
                                                <div class="tlb"  style="z-index: 1;">
                                                    <div class="cmmInput inline VMIDDLE">
                                                        <span class="lb">비과세액</span>
                                                    </div>
                                                    <div class="cmmLocTooltipButton tp3 VMIDDLE MR20">
                                                        <div class="cmmLocTooltipWrap">
                                                            <div class="cmmLocTooltipInner MINWIDTH200">
                                                                <div class="clttLst">
                                                                    <div class="clttTp">
                                                                        <span class="txt FONT12 FWN MINWIDTH500">
                                                                            급여액 중 세금을 공제하지 않는 금액을 말합니다. 커리어 연봉 계산기는 기본으로 식대 10만원이
                                                                            설정되어있으며, 비과세액을 정확히 알고 계신 경우, 직접 입력이 가능합니다.<br /><br />

                                                                            비과세되는 식사대, 출산.보육수당, 실비변상적인 급여, 국외근로소득, 생산직근로자 등의 야근근로수당,
                                                                            외국인 근로자에 대한 과세특례, 기타 비과세 되는 소득등이 이에 해당합니다.
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="tip nomargin">
                                                    <div class="cmmInput inline VMIDDLE MINWIDTH300">
                                                        <div class="ip noradius">
                                                            <input type="text" class="fnActInput" id="tax_free" name="tax_free"  value="100,000" onkeyup="fn_set_commval(this);return fn_chk_numeric_Salary(this);"/><!--비과새액-->
                                                        </div>
                                                    </div>
                                                    <span class="FONT16 VMIDDLE INLINE_BLOCK">원</span>
                                                    <div class="cmmInput radiochk inline VMIDDLE ML25">
                                                        <label class = "checkbox">
                                                            <input type="checkbox" class="chk" id="di" name="di" onclick="fn_toggle_input('#tax_free',this.checked);"/>
                                                            <span class="lb">직접입력</span>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 비과세액:E -->
                                        <!-- 부양 가족 수:S -->
                                        <div class="ccol8">
                                            <div class="tblLayout ciColsm">
                                                <div class="tlb">
                                                    <div class="cmmInput inline VMIDDLE">
                                                        <span class="lb">부양 가족 수</span>
                                                    </div>
                                                    <div class="cmmLocTooltipButton tp3 VMIDDLE MR20">
                                                        <div class="cmmLocTooltipWrap">
                                                            <div class="cmmLocTooltipInner MINWIDTH200">
                                                                <div class="clttLst">
                                                                    <div class="clttTp">
                                                                        <span class="txt FONT12 FWN MINWIDTH400">
                                                                            공제 대상자(본인포함)에 해당하는 부양하는 가족의 수를 1이상 입력합니다.<br />단, 연간 소득금액이 100만원을 초과하는 경우에는 해당되지 않습니다.
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="tip">
                                                    <div class="cmmInput inline VMIDDLE MINWIDTH100">
                                                        <div class="ip noradius">
                                                            <input type="text" class="txt" id="dependency" name="dependency" value="1" onkeyup="fn_chk_numeric_Salary(this);fn_set_commval(this);"  /><!--fn_chk_dependency();빠짐-->
                                                        </div>
                                                    </div>
                                                    <span class="FONT16 VMIDDLE INLINE_BLOCK">명 <span class="colorGry2">(본인포함)</span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- 부양 가족 수:E -->
                                    </div>
                                    <div class="cmmHr line1 MT30"></div>
                                    <!-- 연봉입력:S -->
                                    <div class="tblLayout ciColsm MT40">
                                        <div class="tlb">
                                            <div class="clcTit sm line">연봉입력</div>
                                        </div>
                                        <div class="tip nomargin">
                                            <div class="cmmInput inline MINWIDTH500">
                                                <div class="ip xlg yeonbong noradius borderblaack">
                                                    <!--<span class="yntx">12억5천만원</span>-->
                                                    <input type="text" class="txt" id="income_salary" name="income_salary" onkeyup="fn_set_commval(this);fn_disp_korean(this,'korean_num');" /><!--연봉입력 -->
                                                </div>
                                            </div>
                                            <span class="FONT16 VMIDDLE INLINE_BLOCK">원</span>
                                            <a href="#;" class="btnss org xlg VMIDDLE MINWIDTH160 ML55" onclick="fn_calculate();">계산하기</a>
                                            <a href="#" class="searchBtnsInt tp2 ML15 VBOTTOM" onclick="fn_reset();">초기화</a>
                                        </div>
                                    </div>
                                    <!-- 연봉입력:E -->
                                </div>
                                <!-- 연봉영역:E -->

                            </div>
                            <div class="calcInBox outline MT30">
                                <div class="calcSalaryArea">
                                    <div class="calcSalResultArea">
                                        <div class="crow">
                                            <div class="ccol6">
                                                <div class="clcTit sm line">한 달 기준 공제액</div>
                                                <div class="calcSalLst MT15">
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE">국민연금</span>
                                                            <div class="cmmLocTooltipButton tp3 VMIDDLE ML05">
                                                                <div class="cmmLocTooltipWrap">
                                                                    <div class="cmmLocTooltipInner MINWIDTH200">
                                                                        <div class="clttLst">
                                                                            <div class="clttTp">
                                                                                <span class="txt FONT12 FWN MINWIDTH300">
                                                                                    국민연금은 사업주, 근로자 모두 4.5%를 공제합니다.<br />단, 비과세액이 있을 경우, 비과세액을 제외한 과세금액에서만 세액이 공제됩니다
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx" id="national_pension" name="national_pension" type="text" disabled="disabled" ></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE">건강보험</span>
                                                            <div class="cmmLocTooltipButton tp3 VMIDDLE ML05">
                                                                <div class="cmmLocTooltipWrap">
                                                                    <div class="cmmLocTooltipInner MINWIDTH200">
                                                                        <div class="clttLst">
                                                                            <div class="clttTp">
                                                                                <span class="txt FONT12 FWN MINWIDTH300">
                                                                                    건강보험료는 3.06% 공제합니다.<br />단, 비과세액이 있을 경우, 비과세액을 제외한 과세금액에서만 세액이 공제됩니다.
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx" id="health_insurance" name="health_insurance" type="text" disabled="disabled" ></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE">장기요양</span>
                                                            <div class="cmmLocTooltipButton tp3 VMIDDLE ML05">
                                                                <div class="cmmLocTooltipWrap">
                                                                    <div class="cmmLocTooltipInner MINWIDTH200">
                                                                        <div class="clttLst">
                                                                            <div class="clttTp">
                                                                                <span class="txt FONT12 FWN MINWIDTH300">
                                                                                    장기요양보험은 건강보험 금액의 6.55%를 공제합니다.
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx" id="longterm_insurance" name="longterm_insurance" type="text" disabled="disabled"></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE">고용보험</span>
                                                            <div class="cmmLocTooltipButton tp3 VMIDDLE ML05">
                                                                <div class="cmmLocTooltipWrap">
                                                                    <div class="cmmLocTooltipInner MINWIDTH200">
                                                                        <div class="clttLst">
                                                                            <div class="clttTp">
                                                                                <span class="txt FONT12 FWN MINWIDTH300">
                                                                                    고용보험은 사업주 0.70%, 근로자 0.65%로 책정되어있으며, 월 급여액의 0.65%를 공제합니다.
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx"  id="unemployment_insurance" name="unemployment_insurance" type="text" disabled="disabled"></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE">소득세</span>
                                                            <div class="cmmLocTooltipButton tp3 VMIDDLE ML05">
                                                                <div class="cmmLocTooltipWrap">
                                                                    <div class="cmmLocTooltipInner MINWIDTH200">
                                                                        <div class="clttLst">
                                                                            <div class="clttTp">
                                                                                <span class="txt FONT12 FWN MINWIDTH300">
                                                                                    부양가족수와 20세이하 자녀수에 따라, 국세청의 근로소득 간이세액표 자료를 기준으로 공제됩니다.
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx" id="income_tax" name="income_tax" type="text" disabled="disabled"></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE">지방소득세</span>
                                                            <div class="cmmLocTooltipButton tp3 VMIDDLE ML05">
                                                                <div class="cmmLocTooltipWrap">
                                                                    <div class="cmmLocTooltipInner MINWIDTH200">
                                                                        <div class="clttLst">
                                                                            <div class="clttTp">
                                                                                <span class="txt FONT12 FWN MINWIDTH200">
                                                                                    소득세의 10%를 공제합니다.
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx" id="inhabitants_tax" name="inhabitants_tax" type="text" disabled="disabled" ></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                    <div class="casRow">
                                                        <div class="casLt">
                                                            <span class="tx VMIDDLE FWB">공제액 합계</span>
                                                        </div>
                                                        <div class="casRt">
                                                            <span class="tx FWB"  id="total_exemption" name="total_exemption" type="text" disabled="disabled"></span>
                                                            <span class="tx">원</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="ccol6">
                                                <div class="clcTit sm line">예상 실수령액 (월)</div>
                                                <div class="calcSalResult MT25">
                                                    <div class="inTxt">
                                                        <span class="nb" id="expected_receipt">0</span>
                                                        <span class="wn">원</span>
                                                    </div>
                                                </div>
                                                <div class="cmmLst indent indent8 MT10">
                                                    <div class="cmmtp">- 예상 실 수령액은 월 급여액에서 공제액 합계를 제외한 금액입니다.</div>
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

</body>
</html>
