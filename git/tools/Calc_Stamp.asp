<%
'--------------------------------------------------------------------
'   취업자료실> 성공취업 툴> 온라인 도장
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 김진주
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0308"					' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/common/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<script type="text/javascript" src = "/js/user/html2canvas.js"></script>
<script type="text/javascript">
	//saveAs
	function saveAs(uri, filename) {
		var link = document.createElement('a');
		if (typeof link.download === 'string') {
		link.href = uri;
		link.download = filename;

		//Firefox requires the link to be in the body
		document.body.appendChild(link);

		//simulate click
		link.click();

		//remove the link when done
		document.body.removeChild(link);
		} else {
			window.open(uri);
		}
	}

   function call_canvas($el) {
        //debugger;
        //html2canvas(document.body, {
        html2canvas($("#stampCapture")[0]).then(function (canvas) {
			//console.log(2);
			var a = document.createElement('a');
			a.href = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
			a.download = 'here_image.jpg';
			a.click();
			$el.cmmLocLaypop('close');
        });
    }

	$(document).ready(function(){
		var stmp_value = 1;
		var g_LoginChk = "<%=g_LoginChk%>";	// 로그인 체크(0: 비로그인, 1: 개인회원 로그인, 2: 기업회원 로그인)
		(function(){
			$('[name="stampType"]').change(function(){
				var $this = $(this);
				stmp_value = $this.val();
			});
		})();
		$('.fnDialogCalcStampButton').click(function(){ //도장팝업
			var $input = $('.fnCreateCalcStampInput');
			var $value = $input.val();
			var array = $value.split('');
			var html = '<div class="inner">';

			var login_chk = _loginChk();
			if(!login_chk) return false;

			if(!$value.length || $value.length == 1 || $value.length >= 5){
				alert('이름은 2글자 이상 4글자 이하만 입력 가능합니다.');
				$input.focus();
				return false;
			}
			if(/[^가-힣一-龥]/g.test($value)){
				alert('이름은 한글(자음+모음) 및 한자만 입력 가능합니다.');
				$input.focus();
				return false;
			}
			if($value.length == 3){ //3글자입력시 뒤에 '인' 붙히기
				if(/[一-龥]/g.test($value)){
					array.push('印');
				}else{
					array.push('인');
				}
			}
			for (var i = 0; i < array.length; i++) {
				html+='<span class="tx">'+array[i]+'</span>';
			}
			html += '</div>';
			$('.fnStampAppendHTML').html(html).addClass(function(a,b){
				if(stmp_value == 1 || stmp_value == 3 || stmp_value == 5){ //동그라미 모양
					$(this).addClass('circle');
				}else{
					$(this).removeClass('circle');
				}
				if(stmp_value == 3 || stmp_value == 4){ //궁서체
					$(this).addClass('gungsuh');
					$(this).removeClass('batang');
				}else if(stmp_value == 5 || stmp_value == 6){ //바탕체
					$(this).addClass('batang');
					$(this).removeClass('gungsuh');
				}else{
					$(this).removeClass('batang gungsuh');
				}
			});
			$('[data-layerpop="dialogCalcStamp"]').cmmLocLaypop({
				parentAddClass : 'tp3 buttonTXTC',
				width: 400,
				title : '<div class="TXTC FWN LINEHEIGHT12" a href=\"javascript:void(0);\" onclick=\"html2canvas(this, 0);\" "><span class="FWB fnCreateCalcStampNameTarget"></span></span>님의<br />도장이 완성되었습니다.</div>',
				targetCustomBtnsName: [
					['이미지로 저장하기', 'btnss org fnDownloadStampImage', function($button, $el) {
						$(document).on('click' ,'.fnDownloadStampImage',function(){
							call_canvas($el);

								/*
								var url = canvas.toDataURL();

								$('.fnCalcStampImage').attr('src',url);
								//alert("여기인가요?");
								saveAs(url , "filename");
								alert($('.fnCalcStampImage')[0].src)
							*/
						})
					}],
				]
			});
			$('.fnCreateCalcStampNameTarget').text($(".fnCreateCalcStampInput").val()); //이름 넣기
		});
		$('.fnCreateCalcStampInput').focus(function(){
			var login_chk = _loginChk();
			if(!login_chk) $(this).blur(); return false;
		});
		function _loginChk(){
			if (g_LoginChk != "1") {
				var cfmMsg = confirm("개인회원 로그인 후 이용 가능합니다. 로그인하시겠습니까?");
				if(cfmMsg) {
					fn_goLogin(1);
				}
				return false;
			}else{
				return true;
			}
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
                            <div class="clcTit inline">온라인 도장</div>
                            <div class="clcsTit inline ML10">온라인에서 사용하실 도장을 이미지파일로 만들어드립니다.</div>
                            <div class="calcInBox MT15">
                                <!-- 도장:S -->
                                <div class="clcTit sm line">내 이름 입력</div>
                                <div class="calcSalaryArea MT25">
                                    <!-- <div class="cmmInput tps2 inline VMIDDLE MINWIDTH130">
                                        <div class="ip nomargin xlg noradius borderblaack">
                                            <select class="customSelect">
                                                <option value="1">한글</option>
                                                <option value="2">한문</option>
                                            </select>
                                        </div>
                                    </div> -->
                                    <div class="cmmInput tps2 inline VMIDDLE MINWIDTH350">
                                        <div class="ip nomargin xlg noradius borderblaack">
                                            <input type="text" value="" class="fnCreateCalcStampInput" placeholder="도장에 새겨질 이름을 입력해 주세요"/>
                                        </div>
                                    </div>
                                    <span class="FONT16 colorGry2 VMIDDLE">예) 임꺽정, 홍길동, 林巨正, 洪吉洞 </span>
                                </div>
                                <div class="cmmHr line1 MT40"></div>
                                <div class="clcTit sm line MT45">도장 모양 선택</div>
                                <div class="crow stampArea MT30">
                                    <div class="ccol4 borderleft">
                                        <div class="crow sm">
                                            <div class="ccol6">
                                                <div class="cmmInput radiochk">
                                                    <label>
                                                        <input type="radio" value="1" name="stampType" checked/>
                                                        <span class="lb"></span>
                                                        <div class="stpm tp1"><img src="/images/common/stmp001.png" /></div>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="ccol6">
                                                <div class="cmmInput radiochk">
                                                    <label>
                                                        <input type="radio" value="2" name="stampType" />
                                                        <span class="lb"></span>
                                                        <div class="stpm tp2"><img src="/images/common/stmp002.png" /></div>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="FONT16 colorGry-1 MT15 TXTC" >굴림체</div>
                                    </div>
                                    <div class="ccol4 borderleft">
                                        <div class="crow sm">
                                            <div class="ccol6">
                                                <div class="cmmInput radiochk">
                                                    <label>
                                                        <input type="radio" value="3" name="stampType" />
                                                        <span class="lb"></span>
                                                        <div class="stpm tp3"><img src="/images/common/stmp003.png" /></div>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="ccol6">
                                                <div class="cmmInput radiochk">
                                                    <label>
                                                        <input type="radio" value="4" name="stampType" />
                                                        <span class="lb"></span>
                                                        <div class="stpm tp4"><img src="/images/common/stmp004.png" /></div>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="FONT16 colorGry-1 MT15 TXTC" >궁서체</div>
                                    </div>
                                    <div class="ccol4 borderleft">
                                        <div class="crow sm">
                                            <div class="ccol6">
                                                <div class="cmmInput radiochk">
                                                    <label>
                                                        <input type="radio" value="5" name="stampType" />
                                                        <span class="lb"></span>
                                                        <div class="stpm tp5"><img src="/images/common/stmp005.png" /></div>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="ccol6">
                                                <div class="cmmInput radiochk">
                                                    <label>
                                                        <input type="radio" value="6" name="stampType" />
                                                        <span class="lb"></span>
                                                        <div class="stpm tp6"><img src="/images/common/stmp006.png" /></div>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="FONT16 colorGry-1 MT15 TXTC" >바탕체</div>
                                    </div>
                                </div>
                                <!-- 도장:E -->

                            </div>
                            <div class="btnsWrap TXTC MT30">
                                <a href="#;" class="btnss lg MINWIDTH160 org fnDialogCalcStampButton" >도장 만들기</a>
                            </div>
                        </div>
                        <!-- 취업툴 컨텐츠:E -->

						<!-- 우측 퀵메뉴 -->

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="cmm_layerpop" data-layerpop="dialogCalcStamp">
        <div class="TXTC MT20">
            <div id="stampCapture" class="stampGetArea inline fnStampAppendHTML">
                <div class="inner ">
                    <span class="tx">임</span>
                </div>
            </div>
        </div>
        <img src="" class="fnCalcStampImage" style="display: none;" alt="" id="capture">
    </div>
	<!-- //본문 -->

	<!-- 하단 -->
	<!--#include virtual = "/common/footer.asp"-->

</body>
</html>
