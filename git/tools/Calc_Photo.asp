<%
'--------------------------------------------------------------------
'   취업자료실> 성공 취업 툴> 사진크기 조정
' 	최초 작성일	: 2021-04-29
'	최초 작성자	: 김진주
'   input		:
'	output		:
'	Comment		:
'---------------------------------------------------------------------

Dim glbCateNm : glbCateNm = "취업자료"	' GNB 좌측 표기 카테고리명 지정 > /common/gnb/gnb_sub.asp
menu_no = "0303"						' 취업자료 LNB 메뉴번호(lnb영역 class on 제어용) > /common/lnb/lnb_board.asp
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
ConnectDB DBCon, Application("DBInfo")

	' 로그인 상태일 경우 이력서 등록 여부 체크
	If Len(user_id)>0 Then
		strSql = "SELECT COUNT(*) FROM 이력서공통정보 WITH(NOLOCK) "&_
				 "WHERE 개인아이디='"& user_id &"'"
		rowRs = arrGetRsSql(DBCon, strSql, "", "")
		If IsArray(rowRs) Then
			rs_resumeCnt = Trim(rowRs(0,0))
		End If
	Else
		rs_resumeCnt = 0
	End If

DisconnectDB DBCon
%>
<!--#include virtual = "/common/header.asp"-->
<link rel = "stylesheet" href="/css/cropper.css">
<script type="text/javascript" src = "/js/user/html2canvas.js"></script>
<script src="/js/cropper.js"></script>
<script src="/js/ui/libs/jquery-cropper.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var g_LoginChk = "<%=g_LoginChk%>";	// 로그인 체크(0: 비로그인, 1: 개인회원 로그인, 2: 기업회원 로그인)

		;(function(){ //사진 크기 조정
			var cropCanvas	= '';
			var _accept		= 'jpg, jpeg, gif, png';
			var _l_apt		= _accept.split(',');
			var _o			= 0.02645833333333;
			if($.fn.cmmValidator) $('.calcPhotoArea').cmmValidator();
			$(this).cmmFileUpload({
				accept: _accept,
				size: 1000000, //1MB
				bindUploadImageChange:function(file,$target,o){
					if(!file){
						return false;
					}
					if(cropCanvas) cropCanvas.destroy();
					var preview = file['IMAGE_COUNT_0'].imagePreview;
					var f_name	= file['IMAGE_COUNT_0'].file.name;
					var f_size	= file['IMAGE_COUNT_0'].file.size;
					var f_type	= file['IMAGE_COUNT_0'].file.type;
					var bool	= false;
					for(var i = 0; i < _l_apt.length; i++){
						if(f_type.indexOf($.__TRIM(_l_apt[i])) != -1){
							bool= true;
							break;
						}
					}
					if(!bool) {
						alert(_accept+' 의 확장자만 등록 가능합니다.');
						return false;
					};
					$target.find('input.fkf_input').val(f_name);
					if(preview){
						cropCanvas = $('.fnCropperImg').attr('src', preview).__cropper({
							aspectRatio : 3/4,
							preview : '.fnPreviewImgWrapping',
						}, function(event){
							var detail	= cropCanvas.cropBoxData;
							var width	= Math.round(detail.width);
							var height	= Math.round(detail.height);
							var wcm		= Math.round(width * _o);
							var hcm		= Math.round(height * _o);
							$('.fnGuideInput[data-name="widthpx"]').val(width);
							$('.fnGuideInput[data-name="heightpx"]').val(height);
							$('.fnGuideInput[data-name="heightcm"]').val(hcm);
							$('.fnGuideInput[data-name="widthcm"]').val(wcm);
						});
						$('.fnCropperNullMsg').hide();
					}else{
						$('.fnCropperImg').attr('src', '');
						$('.fnCropperNullMsg').show();
					}
				}
			},$('.fnPhotoInputFileWrap'));
			$('.fnGuideInput').blur(function(){
				var $this = $(this);
				var value = $this.val();
				var params = $this.data('name');
				var obj = {};
				if(!cropCanvas) return false;
				switch (params) {
					case 'heightpx':
						obj['height'] = Math.round(value);
						break;
					case 'widthpx':
						obj['width'] = Math.round(value);
						break;
					case 'heightcm':
						obj['height'] = Math.round(value / _o);
						break;
					case 'widthcm':
						obj['width'] = Math.round(value / _o);
						break;
				}
				cropCanvas.setCropBoxData(obj);
			});
			$('.fnResumePhotoSaveButton').click(function(){
				if (g_LoginChk != "1") {
					var cfmMsg = confirm("개인회원 로그인 후 이용 가능합니다. 로그인하시겠습니까?");
					if(cfmMsg) {
						fn_goLogin(1);
					}
					return false;
				}else{
					if ("<%=rs_resumeCnt%>" == 0) {
						alert("사진 적용 대상 이력서가 없습니다.\n이력서를 작성해 주세요.");
						location.href = "/user/resume/Resume_Regist.asp";
						return;
					}

					if($('#photo_view_img').attr('src') == '') {
						alert('사진 파일을 첨부해 주세요.');
						return;
					}
				}

				if(!cropCanvas) return false;
				var formData = new FormData();
				cropCanvas.getCroppedCanvas().toBlob(function(blob){
					formData.append('uploadFile', blob, 'avatar.jpg');
					// 기존스크립트:S
					$.ajax({
						url: '/user/resume/Pop_Userinfo_Photo_Upload.asp',
						type: 'POST',
						data: formData,
						processData: false,
						contentType: false,
						xhr: function () {
							var xhr = new XMLHttpRequest();

							xhr.upload.onprogress = function (e) {
								var percent		= '0';
								var percentage	= '0%';

								if (e.lengthComputable) {
									percent		= Math.round((e.loaded / e.total) * 100);
									percentage	= percent + '%';
								}
							};
							return xhr;
						},
						success: function (data) {
							alert("사진이 성공적으로 등록되었습니다.");
							console.log(data);
							location.reload();
							/*
							Fail<br>" & "첨부파일을 등록할 수 없습니다. 등록할 수 있는 파일 사이즈는 최대" & (maxFileSize/1024/1024) & "MB 입니다.
							Success<br>" & "//www2.career.co.kr/mypic/<br>" & datepath & "/" & newFileName & "." & fileExtension & "<br>?" & strDT
							*/
							var _arrData = data.split('<br>');

							if(_arrData[0] == 'Fail') {
								alert(_arrData[1]);
								return;
							}
							else {
								$('#hdn_user_photo').val(_arrData[2]);
								$('#userPhotoUrl').attr('src',_arrData[1] + _arrData[2] + _arrData[3]);
							}
						},
						error: function (data) {
						},
					});
					// 기존스크립트:E
				});
				return false;
			});

			$('.fnResumePhotoDownloadButton').click(function(){	//내 PC에 사진 저장
				if (g_LoginChk != "1") {
					var cfmMsg = confirm("개인회원 로그인 후 이용 가능합니다. 로그인하시겠습니까?");
					if(cfmMsg) {
						fn_goLogin(1);
						return false;
					}
				}else{
					if($('#photo_view_img').attr('src') == '') {
						alert('사진 파일을 첨부해 주세요.');
						return;
					}

					if(!cropCanvas) return false;
					cropCanvas.getCroppedCanvas().toBlob(function(blob){
						var link		= document.createElement("a");
						link.download	= "here_image.jpg";
						link.href		= URL.createObjectURL(blob);
						link.click();
					},'image/png');
				}
			});
		})();
	});

	//로컬에 파일 저장
   function call_canvas() {
        //debugger;
        //html2canvas(document.body, {
        html2canvas($(".fnPreviewImgWrapping img")[0]).then(function (canvas) {
                console.log(2);
				console.log($(".fnPreviewImgWrapping img")[0])
                var a = document.createElement('a');
                a.href = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
                a.download = 'here_image.jpg';
                a.click();
        });
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
                        <div class="calcContWrap MT45" data-layerpop="uploadPhoto">
                            <div class="clcTit inline">사진크기 조정</div>
                            <div class="clcsTit inline ML10">이력서용 사진으로 크기를 조정해서 사용하세요.</div>
                            <div class="calcInBox MT15">
                                <!-- 사진선택영역:S -->
                                <div class="clcTit sm line">사진선택</div>
                                <div class="calcPhotoArea MT20">
                                    <div class="crow">
                                        <div class="ccol10">
											<div class="calcPhoFile fnPhotoInputFileWrap">
                                                <div class="cmmInput tps2 cmmFileUpload">
                                                    <div class="cmmInputFile">
                                                        <label for="file1" class="btnss navy noradius">파일선택</label>
                                                        <div class="ip noradius nomargin">
                                                            <input type="input" class="fkf_input" name="" value="" placeholder="등록된 파일이 없습니다." readonly="">
                                                            <input type="file" id="file1" class="" name="" value="">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cmmLst indent indent8 MT10">
                                        <div class="cmmtp">- 본인의 얼굴이 정면으로 보이는 사진을 등록해 주세요(1MB 이내의 jpg, jpeg, gif, png파일만 등록 가능)</div>
                                    </div>
                                </div>
                                <!-- 사진선택영역:E -->
                                <div class="cmmHr line1 MT40"></div>
                                <!-- 사진크기입력 영역:S -->
                                <div class="clcTit sm line MT40">사진크기 입력</div>
                                <div class="calcPhotoArea MT20">
                                    <div class="calcPhoSize">
                                        <div class="cacRow">
                                            <span class="crlb">픽셀 사이즈</span>
                                            <div class="crvb">
                                                <span class="intx">가로</span>
                                                <div class="cmmInput tps2 inline VMIDDLE nomargin ML10">
                                                    <div class="ip nomargin">
														<input type="text" class="fnGuideInput" data-params='{"required": true, "ime": "number"}' data-name="widthpx" />
                                                    </div>
                                                </div>
                                                <span class="intx ML10">픽셀</span>
                                                <span class="intx gray ML10 ">/</span>
                                                <span class="intx ML10">세로</span>
                                                <div class="cmmInput tps2 inline VMIDDLE nomargin ML10">
                                                    <div class="ip nomargin">
                                                        <input type="text" class="fnGuideInput" data-params='{"required": true, "ime": "number"}' data-name="heightpx"/>
                                                    </div>
                                                </div>
                                                <span class="intx ML10">픽셀</span>
                                            </div>
                                        </div>
                                        <div class="cacRow">
                                            <span class="crlb">Cm 사이즈</span>
                                            <div class="crvb">
                                                <span class="intx">가로</span>
                                                <div class="cmmInput tps2 inline VMIDDLE nomargin ML10">
                                                    <div class="ip nomargin">
                                                        <input type="text" class="fnGuideInput" data-params='{"required": true, "ime": "number"}' data-name="widthcm"/>
                                                    </div>
                                                </div>
                                                <span class="intx ML10">Cm</span>
                                                <span class="intx gray ML10 ">/</span>
                                                <span class="intx ML10">세로</span>
                                                <div class="cmmInput tps2 inline VMIDDLE nomargin ML10">
                                                    <div class="ip nomargin">
                                                        <input type="text" class="fnGuideInput" data-params='{"required": true, "ime": "number"}' data-name="heightcm" />
                                                    </div>
                                                </div>
                                                <span class="intx ML10">Cm</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cmmLst indent indent8 MT10">
                                        <div class="cmmtp">- 내가 지원하는 기업의 사진 사이즈를 기입하세요.</div>
                                        <div class="cmmtp">- 커리어 이력서 사진 크기인 (300px * 400px)로 기본 설정 되어 있습니다.</div>
                                    </div>
                                </div>
                                <!-- 사진크기입력 영역:E -->
                                <div class="cmmHr line1 MT40"></div>
                                <!-- 미리보기 및 저장 영역:S -->
                                <div class="clcTit sm line MT40">미리보기 및 저장</div>
                                <div class="calcPhotoArea MT20">
                                    <div class="calcPreview">
                                        <div class="cpInRow">
                                            <div class="inbxAre">
                                                <div class="inCnt">
                                                    <img id="photo_view_img" src="" class="fnCropperImg" alt=""/><!--원본 사진-->
                                                </div>
                                                <!-- 선택사진없을때:S -->
                                                <div class="noResult fnCropperNullMsg">현재 등록된 사진이 없습니다.</div>
                                                <!-- 선택사진없을때:E -->
                                            </div>
                                            <div class="info">Before 원본사진</div>
                                        </div>
                                        <span class="icCpStep"></span>
                                        <div class="cpInRow">
                                            <div class="inbxAre">
                                                <div class="inCnt croped">
                                                    <div class="cmmUserThumbnail fnPreviewImgWrapping" ><!--수정 후 사진-->
                                                        <img src="" alt="" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="info">After 이력서용 사진</div>
                                        </div>
                                    </div>
                                </div>
                                <!-- 미리보기 및 저장 영역:E -->

                            </div>
                            <div class="btnsWrap TXTC MT45">
                                <a href="javascript:void(0);" class="btnss lg MINWIDTH160 org fnResumePhotoDownloadButton">내 PC에 사진 저장하기</a>
                                <a href="#;" class="btnss lg MINWIDTH160 outline gray-2 fnResumePhotoSaveButton">이력서에 적용하기</a>
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
