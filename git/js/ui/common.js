var _cl = window.Cl || {};
var _cl_base = new _cl.base();
$(document).ready(function () {
	var _cl_base_ui = _cl_base.ui_render(this);
});



$(document).ready(function () {
	var $this = $(this);;
	$('.empInfoArea .tConBox').cmmInnerScroll();
	(function () { //채용상품 > 상품안내 툴팁
		var $openButton = $this.find('.mainContents .mainContGridWrap .mainTit .tr, .cmmTit.sm .tr');
		var $fnInsLycToolWrapping = $this.find('.fnInsLycToolWrapping');
		var $fnInsTabsButton = $fnInsLycToolWrapping.find('.fnInsTabsButton');
		var $fnInsTabsDivision = $fnInsLycToolWrapping.find('.fnInsTabsDivision');
		var $fnInsTabsImage = $fnInsLycToolWrapping.find('.fnInsTabsImage');
		var $fnInsCloseButton = $fnInsLycToolWrapping.find('.fnInsCloseButton');
		if ($fnInsLycToolWrapping.length) {
			$openButton.click(function () {
				var $this = $(this);
				$this.closest('.mainTit, .cmmTit').find('.fnInsLycToolWrapping').toggleClass('active');
				return false;
			});
			$fnInsCloseButton.click(function () {
				var $this = $(this);
				$this.closest('.fnInsLycToolWrapping').removeClass('active');
				return false;
			});
			$fnInsLycToolWrapping.off('click').on('click', '.fnInsTabsButton', function () {
				var $this = $(this);
				var $li = $this.closest('.lst').find('.tp');
				var $division = $this.closest('.fnInsLycToolWrapping').find('.fnInsTabsDivision');
				var $image = $this.closest('.fnInsLycToolWrapping').find('.fnInsTabsImage');
				var index = $this.closest('.tp').index();
				$li.removeClass('active');
				$this.closest('.tp').addClass('active');
				$division.removeClass('active');
				$division.eq(index).addClass('active');
				$image.removeClass('active');
				$image.eq(index).addClass('active');
			});
		}
	})();;
	(function ($this) { //공고등록수정 > 템플릿
		var $target = $this.find('#editor_txtContents');
		if ($.__MUTATIONOBSERVER && $target.length) {
			$.__MUTATIONOBSERVER(function (mutation) {
				_mutation()
			}, $target[0], {
				childList: true,
			});
		}
		//_mutation();
		function _mutation() {
			var $td = $('.note-editable[role="textbox"] .carPostTemplateWrap .catTable table tbody td');
			console.log($('.note-editable[role="textbox"]'));
			if ($td.find('.caTp').length) {
				$td.find('.caTp:last').append('<br class="fnObAdd"><div class="fnObAdd"></div>');
			} else {
				$td.append('<br class="fnObAdd">');
			}
		}
	})($this.find('body#companyWrap'));;
	(function () {
		var $target = $this.find('.fnLocDialogWrapping[data-dialog-name="createFile"]');
		if ($.__MUTATIONOBSERVER && $target.length) {
			$.__MUTATIONOBSERVER(function (mutation) {
				if (!$target.is('active')) {
					$target.find('input[type="file"]').val('');
				}
			}, $target[0], {
				attributes: true,
			});
		}
	})();;
	(function () { //공고등록수정
		var $wrapping = $this.find('body#companyWrap');
		var searchResultAddCloseButtonHtml = '';
		searchResultAddCloseButtonHtml = [
			'<div class="casrBot">',
			'	<div class="FLOATR MR10">',
			'		<a href="#;" class="casBtn fnCreateAutoSearchCloseButton">닫기</a>',
			'	</div>',
			'</div>',
		].join('');
		$wrapping.off('click');

		(function () {
			var $target = $wrapping.find('.cmmAutoSearchWrap .cmmAutoSearchResult');
			if ($target.length) {
				$target.append(searchResultAddCloseButtonHtml);
			}
		})();;
		(function () {
			var $target = $this.find('#search_subway_list_1');
			if ($.__MUTATIONOBSERVER && $target.length) {
				$.__MUTATIONOBSERVER(function (mu) {
					if (!$target.find('.casrBot').length) {
						$target.find('.cmmAutoSearchResult').append(searchResultAddCloseButtonHtml);
					}
				}, $target[0], {
					childList: true,
				});
			}
		})();
		$wrapping.on('click', '.fnCreateAutoSearchCloseButton', function () {
			var $this = $(this);
			if ($this.closest('#DivSearchList').length) {
				$this.closest('#DivSearchList').hide();
			}
			if ($this.closest('.cmmAutoSearchResult').find('#license_name_new').length) {
				$this.closest('.cmmAutoSearchResult').hide();
			}
			if ($this.closest('#biz_search_div').length) {
				$this.closest('#biz_search_div').hide();
			}
			if ($this.closest('#search_subway_list_1').length) {
				$this.closest('#search_subway_list_1').hide();
			}
			if ($this.closest('#search_area_txt_div').length) {
				$this.closest('#search_area_txt_div').hide();
			}
			//$(this).closest('.cmmAutoSearchResult').hide();
		});
	})();
	$('.cmmLogoThumbnail img').each(function () {
		if ($(this).attr('src')) {
			$(this).closest('.cmmLogoThumbnail').addClass('on');
		}
	});



	var _domElements = {
		detailD: '[id="detailD"]', //상세요일체크박스
		weekdays: '[name="weekdays"]', //근무요일선택하는 셀렉트
		fnWeekdayDetailInputReadonly: '.fnWeekdayDetailInputReadonly', //근무요일선택시 활성화 유무 체크(상세요일작성인풋)
		fnWeekdayDetailDayShowHide: '.fnWeekdayDetailDayShowHide', //상세요일 체크시 보이고안보이고
		workEtcCheck: '[id^="workEtcCheck"]', //기타사항입력하는 체크박스
		fnWorkEtcCheckShowHide: '.fnWorkEtcCheckShowHide', //기타사항입력 입풋
		rct_hompage: '#rct_hompage', //접수방법>홈페이지체크
		fnRctHompageShowHide: '.fnRctHompageShowHide', //접수방법>홈페이지체크시
		appform_company: '#appform_company', //지원양식>자사양식체크
		appform_user: '#appform_user', //지원양식>자유양식체크
		fnAppformCompanyShowHide: '.fnAppformCompanyShowHide', //지원양식>자사양식리스트
		fnAppformUserShowHide: '.fnAppformUserShowHide', //지원양식>자유양식리스트
		wktype: '[id^="wktype"]',
		fnWkTypeShowHide: '.fnWkTypeShowHide', //근무형태별 보이고안보이고
		experience: '[name="experience"]', //신입,경력,무관 별 활성화
		inp_experience: '[name="inp_experience"]', //신입,경력,무관 별 활성화
		sel_experience: '[name="sel_experience"]', //신입,경력,무관 별 활성화
		fnUdzToggleButton: '.fnUdzToggleButton', //상단부 우대조건 버튼
		fnUdzToggleTarget: '.fnUdzToggleTarget', //상단부 우대조건 타겟
		agelmt: '[name="agelmt"]', //나이제한건 타겟
		fnAgeLimitShowHide: '.fnAgeLimitShowHide', //나이제한 타겟
		salary_type: '[name="salary_type"]', //연봉/급여선택
		salary_txt: '[name="salary_txt"]', //연봉/급여선택
		fnSalaryTypeShowHide: '.fnSalaryTypeShowHide', //연봉/급여선택
		fnSalaryTypeShowHideInputSelect: '.fnSalaryTypeShowHideInputSelect', //연봉/급여선택
		salary_annual: '[name="salary_annual"]', //면접후 결정체크박스
		submitDocs002: '#submitDocs002', //제출서류 > 사전인터뷰
		submitDocs003: '#submitDocs003', //제출서류 > 영문이력서
		fnSubmitDocs002: '.fnSubmitDocs002', //제출서류 > 사전인터뷰
		fnSubmitDocs003: '.fnSubmitDocs003', //제출서류 > 영문이력서
	};
	(function () {
		var $target = $('.jobPostSubIntr');
		if (!$target.length) return false;
		var $offset = $target[0].offsetTop;
		var $height = $target[0].outerHeight;
		$(window).on('load scroll', function () {
			var scrollValue = $(this).scrollTop();
			_callback(scrollValue);
		});

		function _callback(scrollValue) {
			//console.log(scrollValue);
			//console.log($offset);
			if (scrollValue >= $offset) {
				if ($target.find('.jobPostSubBot').length) {
					$target.addClass('fixed isJobPostSubBot');
				}
				$target.addClass('fixed');
			} else {
				$target.removeClass('fixed isJobPostSubBot');
			}
		}
	})();
	$(_domElements.salary_type).change(function () {
		var $this = $(this);
		var value = $this.val();
		var $target = $(_domElements.fnSalaryTypeShowHide);
		var $targetInputSelect = $(_domElements.fnSalaryTypeShowHideInputSelect);
		if (value) {
			$(_domElements.salary_annual).prop('checked', false);
			$(_domElements.fnSalaryTypeShowHideInputSelect).find('input, select').prop('disabled', false);
			$(_domElements.fnSalaryTypeShowHideInputSelect).removeClass('showHideOn');
			if (value === '1') { //
				$(_domElements.fnSalaryTypeShowHideInputSelect + '[data-params="' + value + '"]').addClass('showHideOn');
			} else {
				$(_domElements.salary_txt).val('');
				$(_domElements.fnSalaryTypeShowHideInputSelect + '[data-params="anther"]').addClass('showHideOn');
			}
			if (value === '3' || value === '4' || value === '5' || value === '6' || value === '7') { // 주,일급,시급,건당,내규따름
				$(_domElements.fnSalaryTypeShowHideInputSelect + '[data-params="anther"]').removeClass('manwon')
				$(_domElements.fnSalaryTypeShowHideInputSelect + '[data-params="anther"]').addClass('won')
			} else {
				$(_domElements.fnSalaryTypeShowHideInputSelect + '[data-params="anther"]').removeClass('won')
				$(_domElements.fnSalaryTypeShowHideInputSelect + '[data-params="anther"]').addClass('manwon')
			}
			$target.removeClass('showHideOn');
			$(_domElements.fnSalaryTypeShowHide + '[data-params="' + value + '"]').addClass('showHideOn');
		}
	});
	$(_domElements.salary_annual).change(function () {
		var $this = $(this);
		if (isChecked($this)) {
			$(_domElements.fnSalaryTypeShowHideInputSelect).find('input, select').prop('disabled', true);
		} else {
			$(_domElements.fnSalaryTypeShowHideInputSelect).find('input, select').prop('disabled', false);
		}
	});
	$(_domElements.weekdays).change(function () {
		var $this = $(this);
		var value = $this.val();
		var $target = $(_domElements.fnWeekdayDetailInputReadonly);
		if (value === '7') { //직접입력선택시
			//fnReadonly($target, false);
		} else {
			//fnReadonly($target, true);
		}
	});
	$(_domElements.experience).change(function () {
		var $this = $(this);
		var value = $this.val();
		var $target = [$(_domElements.inp_experience), $(_domElements.sel_experience)];
		if (value === '8') { //경력입력선택시
			fnReadonly($target, false, 'disabled');
		} else {
			fnReadonly($target, true, 'disabled');
		}
	});
	$(_domElements.submitDocs003).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnSubmitDocs003), isChecked($this));
	});
	$(_domElements.submitDocs002).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnSubmitDocs002), isChecked($this));
	});
	$(_domElements.detailD).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnWeekdayDetailDayShowHide), isChecked($this));
	});
	$(_domElements.workEtcCheck).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnWorkEtcCheckShowHide), isChecked($this));
	});
	$(_domElements.rct_hompage).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnRctHompageShowHide), isChecked($this));
	});
	$(_domElements.appform_company).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnAppformCompanyShowHide), isChecked($this));
	});
	$(_domElements.appform_user).change(function () {
		var $this = $(this);
		fnShowHide($(_domElements.fnAppformUserShowHide), isChecked($this));
	});
	$(_domElements.wktype).change(function () {
		var $this = $(this);
		var params = $this.data('params');
		fnShowHide($(_domElements.fnWkTypeShowHide + '[data-params="' + params + '"]'), isChecked($this));
	});
	$(_domElements.agelmt).change(function () {
		var $this = $(this);
		if ($this.val() == 'agelmt2') {
			fnShowHide($(_domElements.fnAgeLimitShowHide), true);
		} else {
			fnShowHide($(_domElements.fnAgeLimitShowHide), false);
		}
	});
	$(_domElements.fnUdzToggleButton).click(function () {
		var $this = $(this);
		$this.toggleClass('active');
		$(_domElements.fnUdzToggleTarget).slideToggle();
	});
	$('[name="comp_area_1"]').change(function () {
		var $this = $(this);
		var value = $this.val();
		var $parent = $this.closest('.crow');
		var $target8 = $parent.find('.ccol7');
		var $target4 = $parent.find('.ccol5');
		if (value == 1) { //국내
			$target4.css('display', 'inline-block');
			$target8.removeClass('ccol12');
		} else if (value == 2) { //해외
			$target4.hide();
			$target8.addClass('ccol12');
		}
	});
});

function tooltipOpen(nm, _this) {
	var $this = $(_this);
	if (nm === '_templateCareerJc') {
		$('.fnLocFormToolTipWrapping[data-tooltip-name]').removeClass('active');
		$this.closest('.cmmInput').find('.fnLocFormToolTipWrapping[data-tooltip-name="' + nm + '"]').addClass('active');
	} else {
		$('.fnLocFormToolTipWrapping[data-tooltip-name]').removeClass('active');
		$('.fnLocFormToolTipWrapping[data-tooltip-name="' + nm + '"]').addClass('active');
	}
}

function tooltipClose(nm) {
	$('.fnLocFormToolTipWrapping[data-tooltip-name="' + nm + '"]').removeClass('active');
}

function dialogOpen(nm) {
	$('.fnLocDialogWrapping[data-dialog-name="' + nm + '"]').addClass('active');
}

function dialogClose(nm) {
	$('.fnLocDialogWrapping[data-dialog-name="' + nm + '"]').removeClass('active');
}

function isChecked($this) {
	return $this.is(':checked');
};

function fnReadonly($target, bool, attr) {
	if (typeof $target === 'object') {
		if (Array.isArray($target)) {
			for (var i = 0; i < $target.length; i++) {
				$target[i].prop(attr || 'readonly', bool);
				if (!bool) {
					$target[i].val('');
				}
			}
		} else {
			$target.prop('readonly', bool);
			if (!bool) {
				$target.val('');
			}
		}
	}
};

function fnShowHide($target, bool) {
	if (bool) {
		$target.addClass('showHideOn');
	} else {
		$target.removeClass('showHideOn');
	}
};

function _FN_kw_search_kecode() {
	this.index = -1;
	this.$focus_list = {};
	return this;
}
_FN_kw_search_kecode.prototype.set = function (keycode) {
	var mx_lng = (function ($list) {
		if ($list.length) {
			return $list.closest('ul').find('li').length;
		} else {
			return 99;
		}
	})(this.$focus_list);
	if (keycode == 40 || keycode === true) {
		if (this.index > mx_lng - 2) {
			this.index = 0;
		} else {
			++this.index;
		}
	} else if (keycode == 38 || keycode === false) {
		if (this.index <= 0) {
			this.index = 0;
		} else {
			--this.index;
		}
	}
}
_FN_kw_search_kecode.prototype.move = function ($list) {
	this.$focus_list = $list.eq(this.index);
	if (this.$focus_list.length) {
		$list.removeClass('onFocus');
		this.$focus_list.addClass('onFocus');
	}
	return this.$focus_list;
}
_FN_kw_search_kecode.prototype.click = function () {
	if (Object.keys(this.$focus_list).length) {
		this.$focus_list.find('a').trigger('click');
		return this.$focus_list.find('a');
	}
}
_FN_kw_search_kecode.prototype.callback = function (_fn) {
	if (typeof _fn === 'function') {
		_fn(this);
	}
}

function EducSearchArea(params) {
	this.params = $.extend(true, {
		name: '',
		data: [],
		className: {
			wrapping: '.fnSecAutoSearchWrapping',
			input: '.fnSecAutoSearchInput',
			list: '.fnSecAutoSearchList',
		},
		nullmsg: '',
		bindCallback: null,
		updateAPI: null,
		keynames: {
			content: 'content'
		},
	}, params);
	this.keyword = '';
	this.keyword_params = '';
	this.className = {
		fnListInBindingTarget: '.fnListInBindingTarget',
	};
	if (!this.params.data.length && typeof this.params.updateAPI !== 'function') {
		throw 'no data';
	}
	this.init();
}
EducSearchArea.prototype = {
	init: function () {
		this.eventbind();
	},
	getData: function (keyword) {
		var _this = this;
		var className = _this.params.className;
		var _data = (function () {
			var _d = _this.params.data;
			if (typeof _this.params.updateAPI === 'function') {
				_d = _this.params.updateAPI(keyword);
			}
			return _d;
		})();
		var mt_data = [];
		if (!keyword) return false;
		if (/[ㄱ-ㅎㅏ-ㅣ]/g.test(keyword)) {
			return false;
		}
		if (typeof _this.params.updateAPI === 'function') {
			mt_data = _data;
		} else {
			mt_data = _data.filter(function (data) {
				try {
					var regExp = new RegExp(keyword, 'i');
					if (regExp.test(data[_this.params.keynames.content])) {
						return true;
					}
				} catch (e) {}
			});
		}
		if (_this.params.name == 'event') {
			if (mt_data.length) {
				$(className.list).html(_this.getHTML(mt_data));
				_this.fnLayerContr(true);
			} else {
				$(className.list).html(_this.getNullHTML());
			}
		} else {
			if (mt_data.length) {
				$(className.list).html(_this.getHTML(mt_data));
				_this.fnLayerContr(true);
			} else {
				//$(className.list).html(_this.getNullHTML());
			}
		}
	},
	getNullHTML: function () {
		return [
			'<li class="tp">',
			'	<a href="#;" class="txt noresult">' + (this.params.nullmsg || '등록된 기업명이 없습니다.') + '</a>',
			'</li>',
		].join('');
	},
	getHTML: function (data) {
		var _this = this;
		var html = '';
		for (var i = 0; i < data.length; i++) {
			html += '<li class="tp">';
			html += '	<a href="javascript:;" class="txt ' + $.__CLSFORMAT(_this.className.fnListInBindingTarget) + '" data-attrdata=\'' + JSON.stringify(data[i].data) + '\' data-params="' + data[i].content + '">' + this.getHTMLReplace(data[i]['content'], _this.keyword) + '<small class="sm">' + (function (params) {
				var str = '';
				if (params && params.type_no !== 'undefined') {
					str = '(' + $.__COMMAFORMAT(params.type_no) + ')';
				}
				return str;
			})(data[i].parametters) + '</small></a>';
			html += '</li>';
		}
		return html;
	},
	getHTMLReplace: function (str, mt_word) {
		var _keyword = mt_word;
		var _str = str;
		var _regExp = new RegExp(_keyword, 'i');
		var r_v = '';
		if (_str && _keyword) {
			r_v = _str.replace(_regExp, '<span class="poi">' + _keyword + '</span>')
		}
		return r_v;
	},
	eventbind: function () {
		var _this = this;
		var className = _this.params.className;
		var bindButtonCallback = function ($this, params, attrdata) {
			$(_this.params.className.input).val(params.type_nm);
			_this.keyword = params.type_nm;
			_this.fnLayerContr(false);
			if (typeof _this.params.bindCallback === 'function') {
				_this.params.bindCallback($this, params, attrdata);
			}
		}
		$(className.wrapping).on('click', _this.className.fnListInBindingTarget, function () {
			var $this = $(this);
			var params = $this.data('params');
			var attrdata = $this.data('attrdata');
			bindButtonCallback($this, params, attrdata);

		});
		$(className.input).on({
			'keydown': function () {
				var $this = $(this);
				var value = $this.val();
				if (!value) {
					$(className.list).html('');
				}
			},
			'keyup': function (e) {
				var $this = $(this);
				var value = $this.val();
				var _keyCode = e.keyCode;
				if (_keyCode != 40 && _keyCode != 38 && _keyCode != 13) {
					__FN_kw_search_kecode = new _FN_kw_search_kecode();
				}
				if (_keyCode == 40 || _keyCode == 38) {
					var $target = $(className.list);
					var $list_tp = $target.find('.tp');
					__FN_kw_search_kecode.set(_keyCode);
					__FN_kw_search_kecode.move($list_tp);
					__FN_kw_search_kecode.callback(function (_el) {
						if (Object.keys(_el.$focus_list).length) {
							if (!_el.$focus_list.length) return false;
							var of = _el.$focus_list[0].offsetTop;
							$target.closest('.saaInner').scrollTop( of -60);
							$this.val($.__TRIM(_el.$focus_list.find('.txt').text()));
							_this.keyword_params = _el.$focus_list.find('.txt').data('attrdata');
						}
					});
					return;
				}
				_this.keyword = $.__TRIM(value);
				if (!$.__TRIM(value)) {
					_this.fnLayerContr(false);
				} else {
					_this.getData(_this.keyword);
				}
			},
			'focus': function () {
				var $this = $(this);
				var value = $this.val();
				if ($.__TRIM(value)) {
					_this.fnLayerContr(true);
				}
			},
			'blur': function () {
				setTimeout(function () {
					_this.fnLayerContr(false);
				}, 500);
			},
		});
	},
	fnLayerContr: function (bool) {
		var _this = this;
		var className = _this.params.className;
		if (bool) { //열림
			$(className.wrapping).addClass('active');
		} else { //닫힘
			$(className.wrapping).removeClass('active');
		}
	}
}



if (!Array.prototype.find) {
	Object.defineProperty(Array.prototype, 'find', {
		value: function (predicate) {
			if (this == null) {}
			var o = Object(this);
			var len = o.length >>> 0;
			if (typeof predicate !== 'function') {}
			var thisArg = arguments[1];
			var k = 0;
			while (k < len) {
				var kValue = o[k];
				if (predicate.call(thisArg, kValue, k, o)) {
					return kValue;
				}
				k++;
			}
			return undefined;
		},
		configurable: true,
		writable: true
	});
}
if (!Array.prototype.filter) {
	Array.prototype.filter = function (func, thisArg) {
		'use strict';
		if (!((typeof func === 'Function' || typeof func === 'function') && this))
			throw new TypeError();

		var len = this.length >>> 0,
			res = new Array(len),
			t = this,
			c = 0,
			i = -1;
		if (thisArg === undefined) {
			while (++i !== len) {
				if (i in this) {
					if (func(t[i], i, t)) {
						res[c++] = t[i];
					}
				}
			}
		} else {
			while (++i !== len) {
				if (i in this) {
					if (func.call(thisArg, t[i], i, t)) {
						res[c++] = t[i];
					}
				}
			}
		}

		res.length = c;
		return res;
	};
}






var MainDigCusFun = function () {};;
(function ($) {
	MainDigCusFun = function (_this, idx, params) {
		this.el = _this;
		this.obj = $.extend(true, {
			style: {
				'z-index': 100,
			},
			start: 0,
			end: 0,
			drag: false,
		}, params);
		this.cookieNm = 'close' + idx;
		this.closeBtn = '.fnDayPopCloseBtn';
		this.chkbox = '.fnDayPopCheckbox';

	};
	MainDigCusFun.prototype = {
		init: function () {
			var _this = this;
			this.set();
			this.bind();
			return {
				show: function () {
					$(_this.el).show();
				},
				hide: function () {
					$(_this.el).hide();
				}
			}
		},
		set: function () {
			var server_today = window.SERVER_TODAY || serverToday();
			if ($.ui) {
				if (this.obj.drag && $.ui.draggable) {
					$(this.el).draggable();
				}
			}
			$(this.el).css($.extend(true, {
				'position': 'absolute',
			}, this.obj.style));
			if (this.obj.start && this.obj.end && (this.obj.start < this.obj.end)) {
				var st = server_today;
				if (st >= this.obj.start && st < this.obj.end) {
					this.get();
				} else {
					$(this.el).hide();
				}
			} else {
				this.get();
			}
		},
		get: function () {
			if (this.getCookie(this.cookieNm) != "done") {
				$(this.el).show();
			} else {
				$(this.el).hide();
			}
		},
		setCookie: function (name, value, expiredays) {
			var todayDate = new Date();
			todayDate.setDate(todayDate.getDate() + expiredays);
			document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";"
		},
		getCookie: function (name) {
			var nameOfCookie = name + "=";
			var x = 0;
			while (x <= document.cookie.length) {
				var y = (x + nameOfCookie.length);
				if (document.cookie.substring(x, y) == nameOfCookie) {
					if ((endOfCookie = document.cookie.indexOf(";", y)) == -1) endOfCookie = document.cookie.length;
					return unescape(document.cookie.substring(y, endOfCookie));
				}
				x = document.cookie.indexOf(" ", x) + 1;
				if (x == 0) {
					break;
				}
			}
			return "";
		},
		bind: function () {
			var _this = this;
			$(this.el).find(this.closeBtn).on({
				'click': function () {
					_this.show();
				},
			});
			$(this.el).find(this.chkbox).on({
				'click': function () {
					_this.show();
				},
			});
		},
		show: function () {
			if ($(this.el).find(this.chkbox).is(":checked") == true) {
				this.setCookie(this.cookieNm, "done", 1);
			}
			$(this.el).hide();
		},
	};
})(jQuery);



function serverToday(year, month, day, hours, minutes) {
	var curDate = new Date();
	var curDateFmt;
	var year = year || curDate.getFullYear();
	var month = month || curDate.getMonth() + 1;
	var day = day || curDate.getDate();
	var hours = hours || curDate.getHours();
	var minutes = minutes || curDate.getMinutes();
	if (parseInt(month) < 10) {
		month = 0 + "" + month;
	}
	if (parseInt(day) < 10) {
		day = 0 + "" + day;
	}
	if (parseInt(hours) < 10) {
		hours = 0 + "" + hours;
	}
	if (parseInt(minutes) < 10) {
		minutes = 0 + "" + minutes;
	}
	curDateFmt = parseInt(year + "" + month + "" + day + "" + hours + "" + minutes);
	//	curDateFmt = "201910021919";
	//	alert(curDateFmt);

	return curDateFmt;
}