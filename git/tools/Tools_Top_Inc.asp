<script type = "text/javascript">
	$(document).ready(function(){
		var activeNumber = '<%=menu_no%>';
		$('.lst>.tp[data-params="'+activeNumber+'"]').addClass('active');
		$('.lst>.tp').on('click', function(){
				 //$(this).addClass("active");

				if($(this).index() == 0){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 1){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 2){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 3){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 4){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 5){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 6){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 7){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}else if($(this).index() == 8){
					$(this).addClass("active");
					$('.lst>.tp').not($(this)).removeClass("active");
				}
		});

	});
</script>
<div class="calcTopWrap MT20">
	<div class="lst">
		<div class="tp tp1" data-params="0301">
			<a href="/tools/Calc_Char.asp" class="txt">
				<div class="intx">
					글자수 세기
				</div>
			</a>
		</div>
		<div class="tp tp2" data-params="0302">
			<a href="/tools/Calc_Resume_Complete.asp" class="txt">
				<div class="intx">
					자소서 자동완성
				</div>
			</a>
		</div>
		<div class="tp tp3" data-params="0303">
			<a href="/tools/Calc_Photo.asp" class="txt">
				<div class="intx">
					사진크기 조정
				</div>
			</a>
		</div>
		<div class="tp tp4" data-params="0304">
			<a href="/tools/Calc_Salary.asp" class="txt">
				<div class="intx">
					연봉 계산기
				</div>
			</a>
		</div>
		<div class="tp tp8" data-params="0305">
			<a href="/tools/Calc_Career.asp" class="txt">
				<div class="intx">
					경력 계산기
				</div>
			</a>
		</div>
		<div class="tp tp5" data-params="0306">
			<a href="/tools/Calc_Convert.asp" class="txt">
				<div class="intx">
					학점 변환기
				</div>
			</a>
		</div>
		<div class="tp tp6" data-params="0307">
			<a href="/tools/Calc_Lang.asp" class="txt">
				<div class="intx">
					어학 변환기
				</div>
			</a>
		</div>
		<div class="tp tp7" data-params="0308">
			<a href="/tools/Calc_Stamp.asp"  class="txt">
				<div class="intx">
					온라인 도장
				</div>
			</a>
		</div>
	</div>
</div>
