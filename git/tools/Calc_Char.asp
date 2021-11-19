<%
'--------------------------------------------------------------------
'   취업자료실> 취업성공 툴> 글자 수 세기
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 김진주
'   input		: 
'	output		: 
'	Comment		: 
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0301"						' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script type="text/javascript">
	$(document).ready(function(){
		//텍스트 박스 전체 지우기
		$(".gray-2").on("click",function(){
		   $("#txtReqConsCont").val("");
		   $("#i_nowcount").text('');
		   $("#i_nowcount2").text('');
		});
	});

	// 클립보드 복사
	function fn_copy(){
		var dummy = document.createElement("textarea");
		document.body.appendChild(dummy);
		dummy.value = document.getElementById('txtReqConsCont').value;
		dummy.select();
		document.execCommand("copy");
		document.body.removeChild(dummy);

		alert("입력하신 내용이 복사되었습니다.\n원하는 페이지에 붙여넣기(Ctrl+v)해 주세요.");		
	}

	// 입력 글자 수 체크
	function fn_textCount(obj) {
		var str		= $(obj).val();
		var str2	= $(obj).val().replace(/(\s*)/g, "");

		var nbyte	= calculate_msglen(str);
		var nbyte2	= calculate_msglen(str2);

		if (str.length > 5000){
			alert('5000자까지만 입력 가능합니다.');
			$(obj).val( str.substring( 0, 5000 ) );
			str = $(obj).val();
		}

		$("#i_nowcount").text((str.length));
		$("#i_nowcount2").text((str.replace(/(\s*)/g, "").length));

		//바이트 계산 후 반영
		$("#i_nowcount_byte").text((nbyte));
		$("#i_nowcount_byte2").text((nbyte2));
	}

	//바이트 계산하는 함수
	function calculate_msglen(strval) {
		var nbytes = 0;
		for (i = 0; i < strval.length; i++) {
			var ch = strval.charAt(i);
			if (escape(ch).length > 4) {
				nbytes += 2;
			} else if (ch == '\n') {
				if (strval.charAt(i - 1) != '\r') {
					nbytes += 1;
				}
			} else if (ch == '<' || ch == '>') {
				nbytes += 4;
			} else {
				nbytes += 1;
			}
		}
		return nbytes;
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
                            <div class="clcTit inline">글자수 세기</div>
                            <div class="clcsTit inline ML10">기업에서 요구하는 자기소개서 글자수를 체크하여 작성하세요.</div>
                            <div class="calcInBox MT15">
                                <div class="cmmBytChkWrap TXTC">
                                    <div class="cbcTp">
                                        <span class="cLbv">공백 포함</span>
										<span class="cLvv">총 <span class="st"  id="i_nowcount">0</span>자 (<span class="bt" id="i_nowcount_byte">0</span>byte)</span>
                                      
                                    </div>
                                    <div class="cbcTp">
                                        <span class="cLbv">공백 제외</span>
										<span class="cLvv">총 <span class="st"  id="i_nowcount2">0</span>자 (<span class="bt" id="i_nowcount_byte2">0</span>byte)</span>
                                    </div>
                                </div>
                                <div class="cmmInput tps2 MT15">
                                    <div class="ip nomargin">
                                        <textarea class="textarea"  id="txtReqConsCont" name="txtReqConsCont" onkeyup="fn_textCount(this);" onkeypress="fn_textCount(this);" style="height: 450px;" placeholder="자기소개서에 들어갈 글을 직접 작성하거나, 복사해서 붙여 넣으면 글자수가 계산됩니다."></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="btnsWrap TXTC MT30">
                                <a href="#" class="btnss lg MINWIDTH160 org" onclick="fn_copy();">글자 복사하기</a>
                                <a href="#" class="btnss lg MINWIDTH160 outline gray-2">전체 지우기</a>
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
