<%
'--------------------------------------------------------------------
'   취업자료실> 취업성공 툴> 자소서 자동완성
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 김진주
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0302"						' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp
%>
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/paging.asp"-->
<%
Dim page		: page		= request("page")
Dim PageSize	: PageSize	= 1000

If page = "" Then
	page = 1
End If

ConnectDB DBCon, Application("DBInfo")

'자소서 샘플 조회
Dim arrListData, sp_name
sp_name = "SPU_RESUME_SAMPLE_LIST"

Dim parameter(4)
parameter(0) = makeParam("@IN_I_THRSC_SEQ", adInteger, adParamInput, 1, 0)'메뉴 번호
parameter(1) = makeParam("@IN_I_PAGESIZE", adInteger, adParamInput, 4, PageSize)
parameter(2) = makeParam("@IN_I_PAGEINDEX", adInteger, adParamInput, 4, page)
parameter(3) = makeParam("@IN_I_TOTALCOUNT", adInteger, adParamOutput, 4, "")
parameter(4) = makeParam("@IN_I_TOTALPAGE", adInteger, adParamOutput, 4, "")

arrListData = arrGetRsSp(DBCon, sp_name, parameter, "", "")
totalCnt	= getParamOutputValue(parameter, "@IN_I_TOTALCOUNT")

Dim pageCount	: pageCount = Fix(((totalCnt-1)/PageSize) +1)
Dim strParam	: strParam	= ""

DisconnectDB DBCon

Dim selfOn1, selfOn2, selfOn3, selfOn4, selfOn5, selfOn6, selfOn7
Dim gubun : gubun = request("gubun")

If gubun = "" Then
	gubun = "1"
End If

Select Case gubun
	Case "1" selfOn1 = "active"
	Case "2" selfOn2 = "active"
	Case "3" selfOn3 = "active"
	Case "4" selfOn4 = "active"
	Case "5" selfOn5 = "active"
	Case "6" selfOn6 = "active"
	Case "7" selfOn7 = "active"
End Select
%>
<!--#include virtual = "/common/header.asp"-->
<script type="text/javascript" src = "/js/user/cal_resume_complete.js"></script>
<script type="text/javascript" src = "/js/user/cal_resume_complete_public.js"></script>
<script src="/js/ui/libs/printThis.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var g_LoginChk = "<%=g_LoginChk%>";	// 로그인 체크(0: 비로그인, 1: 개인회원 로그인, 2: 기업회원 로그인)

	$('.fnDialogMailSubmitFormButton').off().on('click',function(){ //메일보내기팝업
		alert("작업중입니다.");
		return false;
		_dialogMainSubmitForm();
	});
	$('.fnDialogIntroPreviewButton').off().on('click',function(){ //미리보기팝업
		var str = $('.fnResumInBoxWrapping .resmRow .fnResumeInBoxTextBox').text();
		if (str == ""){
			alert("상단 샘플 중에서 편집할 자기소개서를 선택해 주세요.");
			return false;
		}

		_dialogIntroPreview();
	});
	function _dialogMainSubmitForm(){
		$('[data-layerpop="dialogMailSubmitForm"]').cmmLocLaypop({
			parentAddClass:'tp3 border buttonTXTC',
			width: 420,
			title: '메일보내기<br /><small class="MT05 FONT14 colorGry FWN">작성하신 자기소개서를 e-메일로 보낼 수 있습니다.</small>',
			targetCustomBtnsName: [
			   ['메일전송', 'btnss noradius org fnInDialogMailSendButton', function($button, $el) {
				   alert("작업중입니다");

				   $(document).on('click' ,'.fnInDialogMailSendButton',function(){
					   $el.cmmLocLaypop('close');
					   alert('메일전송');
				   });
			   }],
			   ['취소', 'btnss noradius gray-2 outline FWN fnInDialogMailCancelButton', function($button, $el) {
				   $(document).on('click' ,'.fnInDialogMailCancelButton',function(){
					   $el.cmmLocLaypop('close');
				   });
			   }]
		   ]
		});
	}
	function _dialogIntroPreview(){
        var html = $('.fnResumInBoxWrapping').html();
        $('[data-layerpop="dialogIntroPreview"] .resumInBoxArea').html(html);
		$('[data-layerpop="dialogIntroPreview"]').cmmLocLaypop({
			parentAddClass:'tp3',
			width: 760,
			title: '미리보기',
			targetCustomBtnsName: [
			   ['인쇄하기', 'btnss noradius gray-2 outline FWN fnInDialogPreviewPrint', function($button, $el) {
				   $(document).on('click' ,'.fnInDialogPreviewPrint',function(){
					   // $el.cmmLocLaypop('close');
					   $('.fnCallResumeDivPrintTarget').printThis();
					   //alert('프린트');
				   });
			   }]
			   /*,['메일보내기', 'btnss noradius gray-2 outline FWN _fnDialogMailSubmitFormButton', function($button, $el) {
				   $(document).on('click' ,'._fnDialogMailSubmitFormButton',function(){
					  _dialogMainSubmitForm();
				   });
			   }]*/
		   ]
		});
	}
	//
    var _fnCalcResumeAutoComplete = new fnCalcResumeAutoComplete($('.fnCalcResumeTableWrapping'),{
        pagination: true, //페이징 여부
		pagination_leng : 4, //페이징 그룹화 4개씩 묶기
        paginationAppendTarget : '.fnCalcResumePaginationWrapping', //동적 페이징 어펜드할 dom
        afterCallback:function(buttonType){ //클릭이 되는 순간들 콜백
			if(buttonType == 'fnResumeSelectButton'){
				//console.log('로그인 되어 있는지 아닌지 먼저체크 해야합니다~~~~~~~~~~~~~~~~~~~~~~~~~~');
				/*
				로그인안되어있으면,
				if confirm('로그인 하셔야 사용 가능합니다.\n로그인 하시겠습니까?') ? 로그인페이지진입 : reutrn false;
				*/
				if (g_LoginChk != "1") {
					var cfmMsg = confirm("개인회원 로그인 후 이용 가능합니다. 로그인하시겠습니까?");
					if(cfmMsg) {
						fn_goLogin(1);
						$(".fnDialogAllDeleteButton").trigger("click");
						return false;
					}else{
						$(".fnDialogAllDeleteButton").trigger("click");
					}
				}
			}
            if(buttonType == 'fnResumeSelectButton' || buttonType == 'fnResumeInBoxCompleteButton' || buttonType == 'fnResumeInBoxDeleteButton' ){
                //[선택하기, 삭제, 완료] 버튼 클릭 시 바이트 체크
                var str = $('.fnResumInBoxWrapping .resmRow .fnResumeInBoxTextBox').text();
                var getbyte = $.__GET_BYTE(str);
                var getemptybyte = $.__GET_BYTE(str, false);
                $('.fnGetByteTarget[data-params="leng"]').text($.__COMMAFORMAT(getbyte.leng));
                $('.fnGetByteTarget[data-params="byte"]').text($.__COMMAFORMAT(getbyte.byte));
                $('.fnGetByteEmptyTarget[data-params="leng"]').text($.__COMMAFORMAT(getemptybyte.leng));
                $('.fnGetByteEmptyTarget[data-params="byte"]').text($.__COMMAFORMAT(getemptybyte.byte));
            }
        }
    });
    $('.fnListSortButton').click(function(){
        var $this = $(this);
        var params = $this.data('params');
        $('.fnListSortButton').closest('.cssTp').removeClass('active');
        $this.closest('.cssTp').addClass('active');
        _fnCalcResumeAutoComplete.init(CALC_RESUME_DATA[params], params);
        $('.fnListSortTitle').html(CALC_RESUME_DATA[params][0].subject+' <small class="sml">('+CALC_RESUME_DATA[params].length+')</small>');
    });
    $('.fnListSortButton').each(function(index){
		if(CALC_RESUME_DATA[index]){
			$(this).find('.fnDatasLength').text('('+CALC_RESUME_DATA[index].length+')');
		}
	});
    if(!$.__GETPARAMS('pageID')){
        $('.fnListSortButton:eq(0)').click();
    }else{
        $('.fnListSortButton:eq('+$.__GETPARAMS('pageID')+')').click();
    }
    $('.fnDialogAllDeleteButton').click(function(){ //전체지우기 클릭
        _fnCalcResumeAutoComplete.restore();
        $('.fnGetByteTarget[data-params="leng"]').text('0');
        $('.fnGetByteTarget[data-params="byte"]').text('0');
        $('.fnGetByteEmptyTarget[data-params="leng"]').text('0');
        $('.fnGetByteEmptyTarget[data-params="byte"]').text('0');
    });
});
function _fnCallResumeDivPrint(){ //div 프린트
	var log = '<%=g_LoginChk%>';
	if(log === '0'){
		var cfmMsg = confirm("개인회원 로그인 후 이용 가능합니다. 로그인하시겠습니까?");
		if(cfmMsg) fn_goLogin(1);
	}else if(log === '1'){
		$('.fnDialogIntroPreviewButton').trigger('click');
		$('.fnInDialogPreviewPrint').trigger('click');
	}
}
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
                            <div class="clcTit inline">자기소개서 자동완성</div>
                            <div class="clcsTit inline ML10">자기소개서를 항목별로 손쉽게 완성하실 수 있습니다.</div>
                            <div class="calcInBox MT15">
                                <div class="cmmStateStepType2Wrap tp3 col7">
									<!--성장과정 , 학창시절 , 성격의 장점 , 성격의 단점 , 교내외 활동 , 지원동기 , 입사 후 포부 탭-->
                                    <div class="cmmStateStepInner">
                                        <div class="cssTp active">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="0">
                                                <div class="cssTit">성장과정 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                        <div class="cssTp <%=selfOn%>">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="1">
                                                <div class="cssTit">학창시절 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                        <div class="cssTp <%=selfOn%>">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="2">
                                                <div class="cssTit">성격의 장점 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                        <div class="cssTp <%=selfOn%>">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="3">
                                                <div class="cssTit">성격의 단점 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                        <div class="cssTp <%=selfOn%>">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="4">
                                                <div class="cssTit">교내 외 활동 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                        <div class="cssTp <%=selfOn%>">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="5">
                                                <div class="cssTit">지원동기 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                        <div class="cssTp <%=selfOn%>">
                                            <a href="#;" class="cssTpBox fnListSortButton" data-params="6">
                                                <div class="cssTit">입사 후 포부 <span class="sml fnDatasLength"></span></div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="clcTit sm MT30 fnListSortTitle">성장과정 선택하기 <small class="sml">(848)</small></div>
                                <!--자소서 선택하기 (연동)-->
								<div class="calcTbl vCalcTbl MT15">
                                    <div class="table">
                                        <div class="thead">
                                            <div class="tr">
                                                <div class="th">NO</div>
                                                <div class="th">자기소개서 샘플</div>
                                                <div class="th">선택</div>
                                            </div>
                                        </div>
                                        <div class="tbody fnCalcResumeTableWrapping">
                                            <!-- foreach:S -->
                                            <!-- <div class="tr">
                                                <div class="td TXTC colorGry2">1</div>
                                                <div class="td">
                                                    <div class="mellipsis">
                                                        부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.
                                                        부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.
                                                    </div>
                                                </div>
                                                <div class="td TXTC">
                                                    <a href="#;" class="btnss outline sm blue radius">선택하기</a>
                                                </div>
                                            </div> -->
                                            <!-- foreach:E -->
                                        </div>
                                    </div>
                                </div>




								<div class="calcTblPagination fnCalcResumePaginationWrapping">
                                    <!-- <div class="pagination MT30">
                                        <div class="ptp contr prev"><a href="javascript:;" class="txt"></a></div>
                                        <div class="ptp active"><a href="javascript:;" class="txt">1</a></div>
                                        <div class="ptp"><a href="javascript:;" class="txt">2</a></div>
                                        <div class="ptp contr next"><a href="javascript:;" class="txt"></a></div>
                                    </div> -->
                                </div>

                                <div class="cmmHr line1 MT50"></div>
                                <div class="clearfix MT30">
                                    <div class="FLOATL">
                                        <div class="clcTit sm ">나의 자소서 편집하기</div>
                                    </div>
                                    <div class="FLOATR">
                                        <div class="cmmBytChkWrap sm TXTR">
                                            <div class="cbcTp">
                                                <span class="cLbv">공백포함</span>
                                                <span class="cLvv">총 <span class="st fnGetByteTarget" data-params="leng">0</span>자 (<span class="bt fnGetByteTarget" data-params="byte">0</span>byte)</span>
                                            </div>
                                            <div class="cbcTp">
                                                <span class="cLbv">공백제외</span>
                                                <span class="cLvv">총 <span class="st fnGetByteEmptyTarget" data-params="leng">0</span>자 (<span class="bt fnGetByteEmptyTarget" data-params="byte">0</span>byte)</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
								<!--나의 자소서 편집하기 -->
								<div class="resumInBoxArea MT10 fnResumInBoxWrapping">
                                    <!-- 선택된값이있을때:S -->
                                    <!-- foreach:S -->
                                    <!-- <div class="resmRow">
                                        <div class="rsrTit">성장과정</div>
                                        <div class="rsrLst">
                                            <div class="rsrTp">
                                                <div class="txts mellipsis">
                                                    부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.
                                                    부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.
                                                </div>
                                                <textarea class="textarea">부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다. 부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.</textarea>
                                                <div class="btnsWrap">
                                                    <a href="#;" class="btnss radius sm gray-2 outline FONT12">수정</a>
                                                    <a href="#;" class="btnss radius sm gray-2 outline FONT12">삭제</a>
                                                </div>
                                            </div>
                                            <div class="rsrTp">
                                                <div class="txts mellipsis">
                                                    부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.
                                                    부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.
                                                </div>
                                                <textarea class="textarea">부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다. 부모님께서 항상 강조하시던 말이 "책임감" 이었습니다. 지금까지 제가 맡은 일은 투철한 책임감을 가지고 완벽하게 해내는 것은 부모님의 가르침의 영향이 컸습니다.</textarea>
                                                <div class="btnsWrap">
                                                    <a href="#;" class="btnss radius sm blue FONT12">완료</a>
                                                    <a href="#;" class="btnss radius sm gray-2 outline FONT12">삭제</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div> -->
                                    <!-- foreach:E -->
                                    <!-- 선택된값이 있을때:E -->
                                    <!-- 선택된값이 없을때:S -->
                                    <div class="noResult fnResumInBoxNoresult">
                                        위 자기소개서 샘플 목록에서 문장을 선택해 주세요.<br />
                                        <strong class="FWB">선택하신 문장은 수정이 가능합니다.</strong>
                                    </div>
                                    <!-- 선택된값이 없을때:E -->
                                </div>
								<div class="btnsWrap clearfix MT10">
                                    <div class="FLOATL">
                                        <a href="javascript:void();" class="btnss outline gray-2 inbg noradius FWN fnDialogIntroPreviewButton">미리보기</a>
                                        <!-- <a href="javascript:void();" class="btnss outline gray-2 inbg noradius FWN fnDialogMailSubmitFormButton">메일보내기</a> -->
                                    </div>
                                    <div class="FLOATR">
                                        <a href="javascript:;" class="btnss outline gray-2 inbg noradius FWN fnDialogAllDeleteButton">전체 지우기</a>
                                    </div>
                                </div>

                            </div>
                            <div class="btnsWrap TXTC MT45">
                                <a href="javascript:;" class="btnss lg MINWIDTH160 org" onclick="fn_download();">작성한 자기소개서 다운로드</a>
                                <a href="javascript:;" class="btnss lg MINWIDTH160 outline gray-2" onclick="_fnCallResumeDivPrint();">인쇄하기</a>
                            </div>
                        </div>
                        <!-- 취업툴 컨텐츠:E -->

	<!-- 우측 퀵메뉴 -->

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="cmm_layerpop" id="preview" data-layerpop="dialogIntroPreview"> <!--미리보기--><!--팝업창-->
        <div class="calcContWrap MT15">
            <div class="resumInBoxArea fnCallResumeDivPrintTarget">
			<!--팝업창 추가-->

            </div>
        </div>
    </div>

    <div class="cmm_layerpop" data-layerpop="dialogMailSubmitForm">
        <div class="tblLayout ciColxsm MT20">
            <div class="tlb">
                <div class="cmmInput"><span class="lb FONT14">발신인</span></div>
            </div>
            <div class="tip">
                <div class="cmmInput">
                    <div class="ip">
                        <input type="text" class="FONT14" placeholder="발신인을 입력해 주세요" />
                    </div>
                </div>
            </div>
        </div>
        <div class="tblLayout ciColxsm">
            <div class="tlb">
                <div class="cmmInput"><span class="lb FONT14">발신인 e-mail</span></div>
            </div>
            <div class="tip">
                <div class="cmmInput">
                    <div class="ip">
                        <input type="text" class="FONT14" placeholder="메일 주소를 입력해 주세요" />
                    </div>
                </div>
            </div>
        </div>
        <div class="tblLayout ciColxsm ">
            <div class="tlb">
                <div class="cmmInput"><span class="lb FONT14">수신인 e-mail</span></div>
            </div>
            <div class="tip">
                <div class="cmmInput">
                    <div class="ip">
                        <input type="text" class="FONT14" placeholder="메일 주소를 입력해 주세요" />
                    </div>
                </div>
            </div>
        </div>
    </div>
	<!-- //본문 -->

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

	<div class="HIDDEN">
		<ul class="lst fnCalcResumeSetData" data-params="1">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "1" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
		<ul class="lst fnCalcResumeSetData" data-params="2">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "2" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
		<ul class="lst fnCalcResumeSetData" data-params="3">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "3" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
		<ul class="lst fnCalcResumeSetData" data-params="4">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "4" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
		<ul class="lst fnCalcResumeSetData" data-params="5">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "5" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
		<ul class="lst fnCalcResumeSetData" data-params="6">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "6" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
		<ul class="lst fnCalcResumeSetData" data-params="7">
			<%
			For i = 0 To UBound(arrListData , 2)
			   If arrListData(1,i) = "7" Then
			%><li class="tp"> <%=arrListData(3,i)%> </li><%
				End If
			Next
			%>
		</ul>
	</div>
	<script>
	window.CALC_RESUME_DATA = [];
	;(function(){//자기소개서 관련작업
		var replace = function(str){
			return str.replace(/["'`]/g, '"');
		}
        var labels = ['성장과정','학창시절','성격의 장점','성격의 단점','교내 외 활동','지원동기','입사 후 포부'];
		$('.fnCalcResumeSetData').each(function(idx){
			var $this	= $(this);
			var $titls	= $this.find('.tp');
			var params	= $this.data('params');
			var count	= $this.data('count');
			CALC_RESUME_DATA[idx] = [];
			$titls.each(function(index){
				var $this = $(this);
				var title = replace($this.html());
				CALC_RESUME_DATA[idx][index] = {
                    subject : labels[idx],
					count : index+1,
					title: title
				};
			});
		});

	})();
	</script>
</body>
</html>
