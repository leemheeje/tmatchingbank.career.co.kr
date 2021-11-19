/*
 *	기본이력서 정보 가져오기
 */
function fn_get_info(uid) {

	uid = uid || '';
	if (uid == '') {

		alert('본 서비스를 이용하기 위해서는 개인회원 로그인이 필요합니다.\n로그인 후 이용해 주시기 바랍니다.');
		fn_login_redirect();
		return;
	} else {
		$.get("/wwwconf/include/tools/ajax_resumeinfo_get.asp?dummy=" + Math.random() * 99999 + "&uid=" + uid, function (data) {
			var json = eval("(" + data + ")");
			if (json.ret_val == '1' && json.info[0].rsm_idx != '') { // 기본이력서 존재
				var rid = json.info[0].rsm_idx;
				$("#rid").val(rid);
				var rstep = json.info[0].rsm_step;
				$("#rstep").val(rstep);
				var regdate = json.info[0].regdate;
				var moddate = json.info[0].moddate;
				var arrdate1 = regdate.split("-");
				var arrdate2 = moddate.split("-");

				$(".basic_resume .year").each(function (idx) {
					$(this).text((idx == 0) ? arrdate1[0] : arrdate2[0]);
				});
				$(".basic_resume .month").each(function (idx) {
					$(this).text((idx == 0) ? arrdate1[1] : arrdate2[1]);
				});
				$(".basic_resume .day").each(function (idx) {
					$(this).text((idx == 0) ? arrdate1[2] : arrdate2[2]);
				});
				$(".basic_resume").show();

				fn_get_career(rid, rstep);

			} else {
				$("#rid").val("0");
				/* if(confirm("현재 등록하신 이력서가 없습니다.\n이력서를 새로 등록하시겠습니까?")) {
					window.open("/my/resume/resume_step1.asp");
				} */
			}
		});

	}
}


/*
 *	세부 경력사항 가져오기
 */
function fn_get_career(rid, rstep) {

	var agree_chk = $("#daum_agree").val();
	if (document.domain.indexOf("career.co.kr") > 0) {
		agree_chk = "1";
	}

	if (agree_chk == "-1") {

		alert('본 서비스를 이용하기 위해서는 개인회원 로그인이 필요합니다.\n로그인 후 이용해 주시기 바랍니다.');
		fn_login_redirect();
		return;
	} else if (agree_chk == "0") {
		alert('먼저 개인정보 제공동의를 해주시기 바랍니다.');
		var newWin = window.open("/my/");
		if (newWin == null) {
			alert('팝업이 차단되었습니다.\n팝업차단을 해제하고 다시 시도해주시기 바랍니다.');
		}
		return;
	} else if (agree_chk == "1") {
		//		alert("rid: "+rid + " / rstep: " + rstep);
		if (rid == '' || rstep == '') {
			if (rid == '0') {
				if (confirm("현재 등록하신 이력서가 없습니다.\n이력서를 새로 등록하시겠습니까?")) {
					window.open("/my/resume/resume_step1.asp");
				}
				return;
			} else {
				alert('본 서비스를 이용하기 위해서는 개인회원 로그인이 필요합니다.\n로그인 후 이용해 주시기 바랍니다.');
				fn_login_redirect();
				return;
			}
		} else {
			$.get("/wwwconf/include/tools/ajax_resumecareer_get.asp?dummy=" + Math.random() * 99999, {
				"rid": rid,
				"step": rstep
			}, function (data) {
				var json = eval("(" + data + ")");
				if (json.ret_val > 0) {
					fn_reset();
					var career = json.career;
					career = career.reverse();
					var init_loop = 0;
					for (init_loop = 0; init_loop < career.length; init_loop++) {
						fn_add_career();

						var pidx = $(".fnCarCalLstGroup .crow").length - 1;

						$(".fnCarCalLstGroup .crow:eq(" + pidx + ") select").each(function (idx) {

							switch (idx) {
								case 0:
									$(this).val(career[init_loop].st_year);
									break;
								case 1:
									$(this).val(career[init_loop].st_month);
									break;
								case 2:
									$(this).val(career[init_loop].ed_year);
									break;
								case 3:
									$(this).val(career[init_loop].ed_month);
									break;
								case 4:
									if (career[init_loop].c_type != '1') {
										$(this).children('option:eq(1)').attr('selected', true);
									}
									break;
							}

						});
						$(".sty:eq(" + pidx + ")").text(career[init_loop].st_year);
						$(".stm:eq(" + pidx + ")").text(career[init_loop].st_month);
						$(".edy:eq(" + pidx + ")").text(career[init_loop].ed_year);
						$(".edm:eq(" + pidx + ")").text(career[init_loop].ed_month);
						if (career[init_loop].c_type != '1') {
							$(".chst:eq(" + pidx + ")").text("재직중");
						} else {
							$(".chst:eq(" + pidx + ")").text("퇴사");
						}
					};

					alert("기본이력서의 세부경력사항이 반영되었습니다.");
					//	$(".fix img").hide();
				} else {
					alert("기본이력서에 세부경력사항이 등록되지 않았습니다.");
					//	$(".fix img").show();
				}
			});
		}
	}
}

/*
 *	추가
 */
function fn_add_career() {
	if ($(".fnCarCalLstGroup .form_row").length == 20) {
		alert('세부경력 기간 추가를 20개까지 하실 수 있습니다.');
		return;
	}

	var date = new Date();
	var now_year = date.getFullYear();

	var html = '';
	html += '<div class="form_row">';
	html += '	<div class="cmmInput MR10 tps2 inline VMIDDLE MINWIDTH250 form_box">';
	html += '		<div class="ip nomargin xlg noradius borderblaack">';
	html += '				<input type="hidden" name="year_st" />';
	html += '				<input type="hidden" name="month_st" />';
	html += '			<input type="text" class="FONT16" onkeypress="_fnCalcCareerDateParse(event);" onkeyup="_fnCalcCareerDateParse(event);" onblur="_fnCalcCareerDateBlur(event, \'start\');" placeholder="입사년월 (yyyy.mm)">';
	html += '		</div>';
	html += '	</div>';
	html += '	<span class="INLINE_BLOCK VMIDDLE MR10 colorGry2">~</span>';
	html += '	<div class="cmmInput MR10 tps2 inline VMIDDLE MINWIDTH250 form_box">';
	html += '		<div class="ip nomargin xlg noradius borderblaack">';
	html += '				<input type="hidden" name="year_ed" />';
	html += '				<input type="hidden" name="month_ed" />';
	html += '			<input type="text" class="FONT16" onkeypress="_fnCalcCareerDateParse(event);" onkeyup="_fnCalcCareerDateParse(event);" onblur="_fnCalcCareerDateBlur(event, \'end\');" placeholder="퇴사년월 (yyyy.mm)">';
	html += '		</div>';
	html += '	</div>';
	//html += '<div class="cmmInput MR10 tps2 inline VMIDDLE MINWIDTH100">';
	//html += '	<div class="ip nomargin xlg noradius borderblaack">';
	//html += '		<select class="customSelect">';
	//html += '				<option selected="selected">퇴사</option>';
	//html += '				<option>재직중</option>';
	//html += '		</select>';
	//html += '	</div>';
	//html += '</div>';
	html += '<a href="#;" class="btnss xlg blue5 MINWIDTH140 noradius FWN" onclick="fn_add_career();">경력기간 추가</a>';
	if ($(".fnCarCalLstGroup .form_row").length >= 1) {
		html += '<a href="#;" class="btnss xlg blue6 MINWIDTH100 noradius FWN ML10" onclick="$(this).closest(\'.form_row\').remove();">삭제</a>';
	}
	// html += '	<div class="form_col">';
	// html += '		<div class="form_box">';
	// html += '			<input type="hidden" name="year_st" />';
	// html += '			<input type="hidden" name="month_st" />';
	// html += '			<input type="number" onkeypress="_fnCalcCareerDateParse(event);" onkeyup="_fnCalcCareerDateParse(event);" onblur="_fnCalcCareerDateBlur(event, \'start\');" placeholder="YYYY.MM" />';
	// html += '		</div>';
	// html += '	</div>';
	// html += '	<div class="form_col">';
	// html += '		<div class="form_box">';
	// html += '			<input type="hidden" name="year_ed" />';
	// html += '			<input type="hidden" name="month_ed" />';
	// html += '			<input type="number" onkeypress="_fnCalcCareerDateParse(event);" onkeyup="_fnCalcCareerDateParse(event);" onblur="_fnCalcCareerDateBlur(event, \'end\');" placeholder="YYYY.MM" />';
	// html += '		</div>';
	// html += '		<div class="form_box custom_select">';
	// html += '			<select>';
	// html += '				<option selected="selected">퇴사</option>';
	// html += '				<option>재직중</option>';
	// html += '			</select>';
	// html += '		</div>';
	// html += '	</div>';
	//html += '	<div class="form_col">';
	//if ($(".fnCarCalLstGroup .form_row").length >= 1) {
	//	html += '		<button type="button" class="btn_del" onclick="$(this).closest(\'.form_row\').remove();">삭제</button>';
	//}
	//html += '	</div>';
	html += '</div>'; //form_row
	if ($(".fnCarCalLstGroup").is('.fnCustomUiGroupWrapping')) {
		var $html = $(html);
		$(".fnCarCalLstGroup").append($html);
	} else {
		var $html = $(html);
		$(".fnCarCalLstGroup").append($html);
		if (window.selectBoxControl) {
			selectBoxControl.init();
		}
	}
	fn_button_render();

}

function _fnCalcCareerDateParse(e){
	var _this = e.target;
	var value = _this.value;
	if(value){
		value = value.replace(/^(\d{4})\.?(\d{2})$/g,'$1.$2').substr(0,7);
		e.target.value = value;
	}
}
function _fnCalcCareerDateBlur(e, type){
	var _this = e.target;
	var value = _this.value;
	var _year = '';
	var _month = '';
	if(!value) return false;
	if(!/^\d{4}\.\d{2}$/g.test(value)){
		alert('날짜지정이 잘못된 포맷입니다.\n"YYYY.MM" 형식에 맞게 작성해주세요.');
		e.target.value = '';
	}else{
		_year = Number(value.substr(0,4));
		_month = Number(value.substr(5));
		var y_array = new fn_get_cal('year').get();
		var m_array = new fn_get_cal('month').get();
		if(y_array.indexOf(_year) == -1){
			alert('범위에서 벗어난 연도 입니다.\n입/퇴사 년도는 1954 ~ '+y_array[0]+'년 까지 가능합니다');
			e.target.value = '';
			return false;
		}
		if(m_array.indexOf(_month) == -1){
			alert('범위에서 벗어난 월(月)입니다.\n입/퇴사 월(月)은 01 ~ 12월 까지 가능합니다');
			e.target.value = '';
			return false;
		}
		console.log(y_array);
		$(_this).closest('.form_box').find('input[type="hidden"][name^="year"]').val(_year);
		$(_this).closest('.form_box').find('input[type="hidden"][name^="month"]').val(_month);
		fn_chng_month(type);
	}
	// var __a = new fn_get_cal(type);
	// console.log(__a.get());
}
/*
 *	버튼 표시 및 이벤트 할당
 */
function fn_button_render() {

	$(".fnCarCalLstGroup .addBtn").each(function (idx) {
		var html = '';
		if (idx == 0) {
			if ($(".fnCarCalLstGroup .addBtn").length == 1) {

				html = '<a class="txt add" href="javascript:void(0);" onclick="fn_add_career();"><span>추가</span></a>';
			} else {

				html += '<a class="txt add" href="javascript:void(0);" onclick="fn_add_career();"><span>추가</span></a>';

			}
		} else {

			html = ' <a class="txt add" href="javascript:void(0);" onclick="fn_add_career();"><span>추가</span></a>';

			if (idx == ($(".fnCarCalLstGroup .addBtn").length - 1)) {

				html += ' <a class="txt del" href="javascript:void(0);" onclick="fn_remove_career(this);"><span>삭제</span></a>';
			} else {
				html = ' <a class="txt add" href="javascript:void(0);" onclick="fn_add_career();"><span>추가</span></a>';
				html += ' <a class="txt del" href="javascript:void(0);" onclick="fn_remove_career(this);"><span>삭제</span></a>';
			}
		}

		$(this).html(html);
	});

}

/*
 *	년월 정보 가져오기
 */
function fn_get_cal(type) {
	type = type || 'year';
	var options = '';
	this.array = [];

	if (type == 'year') {
		var date = new Date();
		var start_year = 1954;
		var end_year = date.getFullYear();
		for (i = end_year; i >= start_year; i--) {
			options += '		<option value="' + i + '"' +
				(i == end_year ? ' selected' : '') +
				'>' + i + '</option>\n';
			this.array.push(i);
		}
	} else if (type == 'month') {
		for (i = 1; i < 13; i++) {
			options += '		<option value="' + i + '">' + i + '</option>\n';
			this.array.push(i);
		}
	}

	return options;
}
fn_get_cal.prototype.get = function(){
	return this.array;
}


/*
 *	삭제
 */
function fn_remove_career(obj) {
	if ($(".fnCarCalLstGroup").is('.fnCustomUiGroupWrapping')) {
		var parentobj = $(obj).closest('.crow');
	} else {
		var parentobj = $(obj).parent().parent();
	}
	$(parentobj).children().remove();
	$(parentobj).remove();

	fn_button_render();
}


/*
 *	모두 지우기
 */
function fn_reset() {
	$(".fnCarCalLstGroup").children().remove();
	$("#result_year").val("");
	$("#result_month").val("");
	$("#result_year").text('00');
	$("#result_month").text('00');
}

/*
 *	계산하기
 */
function fn_calculate() {
	var ret_month = 0;
	ret_month = fn_chk_month();

	if (ret_month > 0) {
		$("#result_year").val(Math.floor(ret_month / 12));
		$("#result_month").val(parseInt(ret_month % 12));
		$("#result_year").text(Math.floor(ret_month / 12));
		$("#result_month").text(parseInt(ret_month % 12));

	} else {
		$("#result_year").val("");
		$("#result_month").val("");
	}
}

/*
 *	선택 기간 계산
 */
function fn_chk_month() {
	var ret_month = 0;
	var chk_month = 0;
	var st_year, st_month, ed_year, ed_month, bf_year, bf_month;
	var bool = true;

	$(".fnCarCalLstGroup .form_row").each(function (idx, item) {
		st_year = parseInt($(this).find("input[type='hidden'][name='year_st']").val());
		st_month = parseInt($(this).find("input[type='hidden'][name='month_st']").val());
		ed_year = parseInt($(this).find("input[type='hidden'][name='year_ed']").val());
		ed_month = parseInt($(this).find("input[type='hidden'][name='month_ed']").val());

		//		alert(idx + " / " + st_year+ " / " +st_month+ " / " +ed_year+ " / " +ed_month);
		//		return false;

		ret_month += ((ed_year - st_year) * 12 + (ed_month - st_month));

		if (ret_month < 0) {
			alert('기간선택이 잘못되었습니다.');
			bool = false;
			return false;
		}

		if (idx > 0) {
			chk_month = ((st_year - bf_year) * 12 + (st_month - bf_month));
			if (chk_month < 0) {
				alert('재직기간은 중복선택이 불가합니다.\n재설정 하신 후, 변환하시기 바랍니다.');
				bool = false;
				return false;
			}
		}

		if (idx == 0 || (idx > 0 && !(bf_year == st_year && bf_month == st_month))) {
			ret_month += 1;
		}
		bf_year = ed_year;
		bf_month = ed_month;
	});

	return ret_month;
}


/*
 *	선택 기간 입력 체크
 */
function fn_chng_month(type) {

	var chk_month = 0;
	var st_year, st_month, ed_year, ed_month, bf_year, bf_month;

	$(".fnCarCalLstGroup .form_row").each(function (idx) {
		st_year = parseInt($(this).find("input[type='hidden'][name='year_st']").val());
		st_month = parseInt($(this).find("input[type='hidden'][name='month_st']").val());
		ed_year = parseInt($(this).find("input[type='hidden'][name='year_ed']").val());
		ed_month = parseInt($(this).find("input[type='hidden'][name='month_ed']").val());

		//console.log(st_year + "-" + st_month + " ~ " + ed_year + "-" + ed_month);

		chk_month = ((ed_year - st_year) * 12 + (ed_month - st_month));
		if (chk_month < 0) {
			alert('기간선택이 잘못되었습니다.');
			if (type == 'start') {
				$(this).find("input[type='hidden'][name='year_st']").val(st_year)
				$(this).find("input[type='hidden'][name='month_st']").val(st_month)
			} else if(type == 'end'){
				$(this).find("input[type='hidden'][name='year_ed']").val(ed_year)
				$(this).find("input[type='hidden'][name='month_ed']").val(ed_month)
			}
			return false;
		}

		if (idx > 0) {
			chk_month = ((st_year - bf_year) * 12 + (st_month - bf_month));
			if (chk_month < 0) {
				alert('재직기간은 중복선택이 불가합니다.\n재설정 하신 후, 변환하시기 바랍니다.');
				$(this).find("span.selectbox:eq(0)").val(bf_year);
				$(this).find("span.selectbox:eq(1)").val(bf_month);
				return false;
			}
		}

		//bf_year = ed_year;
		//bf_month = ed_month;

	});
}
