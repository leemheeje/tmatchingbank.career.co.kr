/*
 * 제작자 : 임희재
 * 버전 : v.08
 * 업데이트내용 : cmmCalendal '주' 단위 수정
 */

/* Plugin */
(function ($) {
	var debounce = function (func, threshold, execAsap) {
		var timeout;
		return function debounced() {
			var obj = this,
				args = arguments;

			function delayed() {
				if (!execAsap) func.apply(obj, args);
				timeout = null;
			};
			if (timeout) clearTimeout(timeout);
			else if (execAsap) func.apply(obj, args);
			timeout = setTimeout(delayed, threshold || 150);
		};
	}
	jQuery.fn['smartresize'] = function (fn) {
		return fn ? this.bind('resize', debounce(fn)) : this.trigger('smartresize');
	};
	jQuery.fn['smartscroll'] = function (fn) {
		return fn ? this.bind('scroll', debounce(fn, 15)) : this.trigger('smartscroll');
	};
})(jQuery);;
(function ($) {
	$.fn.extend({
		pickDate: function (obj) {
			// var calendar = new UI_CONF.consulting({
			// 	initYear: 2021,
			// 	initMonth: 8,
			// 	disabledArray: ['20210701', '20210712'], //날짜선택 비활성화 선택적 [0], [1], [2] ... 선택적 비활성화
			// 	disabledRange: ['0', '20210727'], //날짜선택 비활성화 범위 [0]이상 ~ [1]이하 비활성화
			// 	changeCallBack: function (conf) {
			// 		$('.fnTitleCalendar').html(conf.year + '.' + conf.month);
			// 	}
			// });
			// $('.fnContrCalendarButton').click(function () { //controller
			// 	var $this = $(this);
			// 	var params = $this.data('params');
			// 	if (params == 'next') {
			// 		_init.month++;
			// 		if (_init.month > 12) {
			// 			_init.month = 1;
			// 			_init.year++;
			// 		}
			// 	} else if (params == 'prev') {
			// 		_init.month--;
			// 		if (_init.month == 0) {
			// 			_init.month = 12;
			// 			_init.year--;
			// 		}
			// 	}
			// 	calendar.getDate(_init.year, _init.month);
			// 	_restore();
			// });
			// function fnConsultConvBindClick(e) {
			// 	alert(e.target.value);
			// 	/**
			// 	 * 달력 날짜 클릭할때 해당날짜의 시간대 데이타받아오기 ajax
			// 	 * 선택된 날짜 active는 UI영역에서 외 예외처리는 추후 협의
			// 	 */
			// }
			//타겟돔
			//<tbody class="fnDateNodeTbody" data-params="table">
			//<tbody class="fnDateNodeTbody" data-params="table">
			// <select class="vtSel fnDateNodeTbody" data-params="select">
			// 	<option value="">컨설팅 일자 선택</option>
			// </select>
			var $this = $(this);
			var PickDate = function (obj) {
				this.year = $.__GET_YEAR;
				this.month = $.__GET_MONTH;
				this.day = $.__GET_DAY;
				this.obj = $.extend(true, {
					currentDate: $.__GET_YEAR && $.__GET_YEAR ? $.__GET_YEAR + '' + $.__GET_MONTH : '202101',
					initYear: $.__GET_YEAR,
					initMonth: $.__GET_MONTH,
					initDay: $.__GET_DAY,
					disabledArray: [],
					disabledRange: [],
					changeCallBack: null,
					dayNameArray : ['일','월','화','수','목','금','토'],
				}, obj);
				this.init();
				return this;
			}
			PickDate.prototype = {
				init: function () {
					this.getDate(this.obj.initYear, this.obj.initMonth);
				},
				setDate: function (year, month) {
					var last = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
					var date = new Date();
					var year = year ? year : date.getFullYear();
					var month = month !== undefined ? month : date.getMonth();
					if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
						lastDate = last[1] = 29;
					}
					var lastDate = last[month];
					var theDate = new Date(year, month, 1);
					var theDay = theDate.getDay();
					var row = Math.ceil((theDay + lastDate) / 7);
					return {
						setDay: theDay,
						lastDate: lastDate,
						row: row,
						year: year,
						month: month,
					}
				},
				getDate: function (year, month) {
					var _this = this;
					var returnValue = {};
					var _formatDate = '';
					var isDisabled = function (_isN, index) {
						_formatDate = _this._formatConvDate({
							year: year,
							month: month,
							day: _isN,
						});
						var dis_array = _this.obj.disabledArray;
						var dis_range = _this.obj.disabledRange;
						var dis_rangeSe = _this.obj.disabledRangeSe;
						var bool = false;
						if (typeof dis_array === 'object' && Array.isArray(dis_array)) { //단일disabled
							for (var q = 0; q < dis_array.length; q++) {
								if (_formatDate == dis_array[q]) {
									bool = true;
									break;
								}
							}
						}
						if (typeof dis_range === 'object' && Array.isArray(dis_range)) { //범위 disabled
							if (typeof dis_range[0] !== 'undefined' && dis_range[1]) {
								if (_formatDate >= dis_range[0] && _formatDate <= dis_range[1]) {
									bool = true;
								}
							}
						}
						if (typeof dis_rangeSe === 'object' && Array.isArray(dis_rangeSe)) { //범위 disabled
							if (typeof dis_rangeSe[0] !== 'undefined' && dis_rangeSe[1]) {
								if (_formatDate >= dis_rangeSe[0] && _formatDate <= dis_rangeSe[1]) {
									bool = true;
								}
							}
						}
						if(index == 0 || index == 6){ /// 여기요~~~~~~~~~~~~~ 주말
							bool = true;
						}
						return bool ? 'disabled' : '';
					};
					if (month == 1 || month === undefined) {
						returnValue = this.setDate(year, 0);
					} else {
						returnValue = this.setDate(year, month - 1);
					}
					var isN = 1;
					var html = '';
					var option = '<option value="">컨설팅 일자 선택</option>';
					for (var i = 0; i < returnValue.row; i++) {
						html += '<tr>';
						for (var j = 0; j < 7; j++) {
							if ((i === 0 && j < returnValue.setDay) || (isN > returnValue.lastDate)) {
								html += '<td></td>';
							} else {
								html += '<td><button class="acBt ' + (function () {
									var today = false;
									if (_this.obj.initDay === isN && month == Number(_this.month) && year == Number(_this.year)) {
										today = true;
									}
									return today ? 'today' : '';
								})() + ' fnConsultDaySelButton" value="' + (function () {
									return year + '-' + (month < 10 ? '0' + month : month) + '-' + (isN < 10 ? '0' + isN : isN);
								})() + '" data-year="' + year + '" data-month="' + month + '" data-day="' + isN + '" ' + isDisabled(isN,  j) + ' onclick="fnConsultConvBindClick(event);">' + isN + '</button></td>';
								if(isDisabled(isN,  j) === ''){
									option += '<option value="' + (function () {
										return year + '-' + (month < 10 ? '0' + month : month) + '-' + (isN < 10 ? '0' + isN : isN);
									})() + '">' + (function () {
										return _this._formatConvDate({
											year: year,
											month: month,
											day: isN,
										}, 'YYYY-MM-DD');
									})() + (function(){
										if(_this.obj.dayNameArray && Array.isArray(_this.obj.dayNameArray)){
											return ' (' + _this.obj.dayNameArray[j] + ')';
										}
									})() + '</option>';
								}
								isN++;
							}
						}
						html += '</tr>';
					}
					$('.fnDateNodeTbody[data-params="table"]').html(html);
					$('.fnDateNodeTbody[data-params="select"]').html(option);
					if (typeof this.obj.changeCallBack === 'function') {
						this.obj.changeCallBack({
							year: year,
							month: month,
						});
					}
				},
				_formatConvDate: function (date, format) {
					var _format = format ? format : 'YYYYMMDD';
					var _date = date ? date : {};
					var f = '';
					switch (_format) {
						case 'YYYY-MM-DD':
						f = '-';
						break;
						case 'YYYY.MM.DD':
						f = '.';
						break;
					}
					return _date.year + '' + f + '' + (function () {
						if (_date.month < 10) {
							return '0' + _date.month
						} else {
							return _date.month;
						}
					})() + '' + f + '' + (function () {
						if (_date.day < 10) {
							return '0' + _date.day
						} else {
							return _date.day;
						}
					})();
				}
			}
			this.each(function () {
				$.data($(this), new PickDate($(this), obj));
			});
			return $this;
		},
		dataToggleClass: function (index) { //커리어리뉴얼
			var $this = $(this);
			var _self = null;

			function DataToggleClass() {
				_self = this;
				_self.paramsClass = $this.attr('data-toggle-class');
				_self.paramsHtml = $this.attr('data-toggle-html');
				_self.initClass = $this[0].classList && $this[0].classList.value ? $this[0].classList.value : $this[0].className;
				_self.initHtml = $this.html();
				this.init();
				return this;
			}
			DataToggleClass.prototype = {
				init: function () {
					if (_self.paramsClass) {
						$this.attr('data-toggle-class', _self.initClass);
						$this.removeAttr('class');
						$this.addClass(_self.paramsClass);
					}
					if (_self.paramsHtml) {
						$this.attr('data-toggle-html', _self.initHtml);
						$this.html(_self.paramsHtml);
					}
				}
			}
			return new DataToggleClass;
		},
		initSelectbox: function (index) { //커리어리뉴얼
			var $this = $(this);
			var $wrap = $this.closest('.customSelectWrap');
			var options = (function () {
				//$this.find('option:eq('+(index || 0)+')');
				if (index) {
					return $this.find('option[value="' + index + '"]');
				} else {
					return $this.find('option:eq(0)');
				}
			})();
			var value = options.val();
			var text = options.text();
			if ($wrap.length) {
				$this.val(value);
				$wrap.find('.virSelectTxt').html(text).attr('data-value', value);
			} else {
				options.prop('selected', true);
			}
		},
		include: function (bool, data) {
			if (bool) {
				var include = data || [];
				/*
				 * ['footer', { target: '.toolbar', url: '/public/include/toolbar.html', get: 'on' }],
				 */
				/*
				 * ['asideNav', { target: '.aside_area', url: '/include/asideNav.html', get: 'on' }],
				 *['toolbar', { target: '.toolbar', url: '/include/toolbar.html', get: 'on' }]
				 */
				var appendHtml = function (target) {
					$getUrl.done(function (data) {
						$(target).append(function () {
							$(this).html(data);
							$(this).customTags();
						});
					});
				}
				for (var i = 0; i < include.length; i++) {
					if (include[i]) {
						if (include[i][1].get) {
							var $getUrl = $.get(include[i][1].url);
							var target = include[i][1].target;
							appendHtml(target);
						}
					}
				}
			}
		},
		cmmValidator: function (obj) {
			/*
						if (!$('[name="USER_NAME"]').cmmAjax()) {
						contentOpen('.cont12'); //본인의 이름을 정확히 입력해주세요
						return false;
					}
					if (!$('[name="USER_PHONENUMBER"]').cmmAjax(7, 8)) { //min , max 글자수 체크
					contentOpen('.cont13'); //본인의 전화번호을 정확히 입력해주세요
					return false;
				}
				if (!$('[name="USER_EMAIL"]').cmmAjax('email')) {
				contentOpen('.cont16'); //올바르지 않은 이멩리형식입니다.에픽게임즈계정을정확히입력해주세요.
				return false;
			}
			if (!$('[name="USER_CHK1"]').cmmAjax()) {
			contentOpen('.cont09'); //모든 약관에 동의해주세요
			return false;
			}
			if (!$('[name="USER_CHK2"]').cmmAjax()) {
			contentOpen('.cont09'); //모든 약관에 동의해주세요
			return false;
			}
			<input type="text" data-params='{"required" : true}'/>

			*/
			var $this = $(this);
			var defaults = {
				ime: true,
				/*eventType: 'keyup blur keypress',
				keycodeGubun: false,*/
				eventType: 'keydown keyup blur ',
				keycodeGubun: true,
				inputfile: {
					format: ['jpeg', 'jpg', 'gif', 'png'],
					size: 500
				}
			};

			function CmmValidator($this) {
				this.el = $this;
				this.obj = $.extend(true, defaults, obj);
				this.opt = {
					imeArry: ['number', 'tel', 'ko', 'en', 'email', 'ennumber', 'konumber', 'etc', 'enetc', 'koetc', 'koen', 'file', 'koennumber', 'all'],
					ankeycode: [9, 8, 13, 16, 20, 21, 35, 36, 37, 38, 39, 40],
					kokeycode: 229
				};
				this.input = null;
				this.inputArry = [];
				this.dataName = 'params';
				this.title = '';
				this.clearchk = false;
				this.init();
			};
			CmmValidator.prototype = {
				init: function () {
					var _this = this;
					this.set();
					this.fnIme();
					window.addEventListener('input', function () {
						_this.oninput(_this);
					});
				},
				set: function () {
					var _this = this;
					var clsName = '';
					this.el.find('input').each(function () {
						var $this = $(this);
						var $data = $this.data(_this.dataName);
						if ($data) {
							if ($data.required) {
								//$this.attr('required', $data.required);
							}
							if ($this.is('[type="file"]')) {
								_this.fnFileBind($this, $data);
							}
						}
						if ($data && $data.ime && !$this.is('[type="radio"]') && !$this.is('[type="checkbox"]')) {
							switch ($data.ime) {
								case _this.opt.imeArry[2]:
									clsName = 'IME_KO';
									break;
								case _this.opt.imeArry[3]:
									clsName = 'IME_ONLY_EN';
									break;
							}
							$this.addClass(clsName);
						}
					});
				},
				fnFileBind: function ($this, $data) {
					var _this = this;
					this.obj.inputfile = $.extend(true, this.obj.inputfile, $data);
					//<input type="file" name="USER_file" data-params='{"ime" : "file", "required" : true, "inputfile" : {"format" : "image/png","size": 500}}'  placeholder="에픽게임즈 계정(E-mail)을 정확히 입력해주세요.">
					if (this.obj.inputfile) {
						$this.on({
							'change': function (e) {
								var $this = $(this);
								var $disc = null;
								var $type = null;
								var type_bool = false;
								var disc_bool = false;
								var type_msg = '';
								if ($this.val()) {
									$disc = $this[0].files[0].size;
									$type = $this[0].files[0].type;
									if (typeof _this.obj.inputfile.format == 'string') {
										type_msg = _this.obj.inputfile.format;
										if ($type.indexOf(_this.obj.inputfile.format) != -1) {
											type_bool = true;
										}
									} else if (Array.isArray(_this.obj.inputfile.format)) {
										for (var i = 0; i < _this.obj.inputfile.format.length; i++) {
											type_msg += _this.obj.inputfile.format[i] + '/';
											if ($type.indexOf(_this.obj.inputfile.format[i]) != -1) {
												type_bool = true;
											}
										}
									}
									if ($disc <= _this.obj.inputfile.size * 1024) {
										disc_bool = true;
									}
									if (!type_bool || !disc_bool) {
										$this.val('');
										alert('이미지파일형식은 ' + type_msg + '만 가능하며, \n이미지의 용량은 ' + _this.obj.inputfile.size + 'KB이하만 업로드 가능합니다.')
									}
								} else {
									$this.val('');
									return false;
								}
							}
						});
					} else {
						//데이터오류
					}
				},
				fnImeExp: function (str, keycode) {
					var exp = '';
					var keygubun = '';
					var callback = null;
					if (str.indexOf(',') != -1) {
						var arry = str.split(',');
						var strArry = '';
						for (var i = 0; i < arry.length; i++) {
							strArry += arry[i];
						}
					} else {
						strArry = str;
					}
					switch (strArry) {
						case this.opt.imeArry[0]: //number
						case this.opt.imeArry[1]: //tel
							keygubun = (keycode >= 48 && keycode <= 57) || (keycode >= 96 && keycode <= 105) && keycode != this.opt.kokeycode;
							exp = /[^0-9-]/gi;
							break;
						case this.opt.imeArry[2]: //ko
							keygubun = keycode == this.opt.kokeycode;
							exp = /[^ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi;
							break;
						case this.opt.imeArry[3]: //en
							keygubun = keycode >= 65 && keycode <= 90 && keycode != this.opt.kokeycode;
							exp = /[^A-Za-z]/gi;
							break;
						case this.opt.imeArry[4]: //email
							exp = /[^A-Za-z|0-9\-_|@|.]/gi;
							break;
						case this.opt.imeArry[5]: //ennumber
							exp = /[^A-Za-z|0-9]/gi;
							break;
						case this.opt.imeArry[6]: //konumber
							exp = /[^ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9]/gi;
							break;
						case this.opt.imeArry[7]: //etc
							exp = /[^~!@\#$%<>^&*\()\-=+_\’.,/]/gi;
							break;
						case this.opt.imeArry[8]: //enetc
							exp = /[^A-Za-z|~!@\#$%<>^&*\()\-=+_\’.,/]/gi;
							break;
						case this.opt.imeArry[9]: //koetc
							exp = /[^ㄱ-ㅎ|ㅏ-ㅣ|가-힣|~!@\#$%<>^&*\()\-=+_\’.,/]/gi;
							break;
						case this.opt.imeArry[10]: //koen
							exp = /[^ㄱ-ㅎ|ㅏ-ㅣ|가-힣|A-Za-z/]/gi;
							break;
						case this.opt.imeArry[12]: //koennumber
							exp = /[^ㄱ-ㅎ|ㅏ-ㅣ|가-힣|A-Za-z|0-9/]/gi;
							break;
						case this.opt.imeArry[13]: //all
							exp = /[]]/g;
							break;
					}
					callback = function ($input) {
						var $val = $input.val();
						$input.val($val.replace(exp, ''));
					};
					return {
						exp: exp,
						keygubun: keygubun,
						callback: callback
					};
				},
				oninput: function (_this) {
					var $input = _this.el.find('input[type="number"]');
					$input.each(function () {
						var $this = $(this);
						var _input = $this[0];
						if (_input.maxLength > 0) {
							if (_input.value.length > _input.maxLength) {
								_input.value = _input.value.slice(0, _input.maxLength);
							}
						}
					});
				},
				fnIme: function ($input, ime) {
					var _this = this;
					this.el.find('input, textarea').on(_this.obj.eventType, function (e) {
						var $this = $(this);
						var _bool = true;
						if (!$this.is('[type="checkbox"]') && !$this.is('[type="radio"]')) {
							var $val = $this.val();
							var $data = $this.data(_this.dataName);
							var keycode = e.keyCode;
							var str = '';
							if ($data) {
								if ($data.ime && $data.ime != 'file') {
									str = _this.fnImeExp($data.ime, keycode);
									if (_this.obj.keycodeGubun && str.keygubun != '' && navigator.userAgent.indexOf('Mobile') == -1) {
										if (str.keygubun || _this.opt.ankeycode.indexOf(keycode) != -1) {
											_bool = true;
										} else {
											_bool = false;
										}
										if (!_bool) {
											e.preventDefault();
											e.stopPropagation();
											e.returnValue = false;
										}
										if (typeof str.callback === 'function') {
											str.callback($this);
										}
										return _bool;
									} else {
										if (str.exp.test($val)) {
											$(this).val($val.replace(str.exp, ''));
										}
									}
								}
							}
						}
					});
				},
			};
			this.each(function () {
				$.data($(this), new CmmValidator($(this), obj));
			});
			return this;
		},
		cmmAjax: function (obj) {
			var globalBool = true;
			var args = arguments;
			var radioBool = false;
			var defaults = {
				errorCall: 'alert', //alert , append
				errorStr: 'title',
				ajax: null,
				jsonParse: false
			};

			function CmmAjax($this) {
				this.el = $this;
				this.obj = typeof obj === 'string' ? obj : typeof obj === 'number' ? $.extend(true, defaults, {
					minlength: args[0],
					maxlength: args[1]
				}) : $.extend(true, defaults, obj);
				this.input = null;
				this.inputArry = [];
				this.title = '';
				this.clearchk = false;
				this.dataName = 'params';
				this.opt = {
					chkmsg: ['을(를) 선택해주세요.', '을(를) 입력해주세요.'],
				}
				this.globalBool = true;
				this.init();
				globalBool = this.globalBool;
				if (this.obj == 'result') {
					globalBool = this.el.serializeObject();
					if (args[1] == 'json') {
						globalBool = JSON.stringify(globalBool);
					}
				}
			};
			CmmAjax.prototype = {
				init: function () {
					var _this = this;
					var chkleng = 0;
					if (_this.obj == 'clear') {
						_this.clear(this.el);
					} else if (_this.obj == 'submit') {
						_this.submitSet(args[1]);
					}
					_this.clear = false;
					//_this.el.find('input, select, textarea').each(function() {
					_this.el.each(function () {
						var $this = $(this);
						var $data = $this.data(_this.dataName);
						chkleng++;
						if ($data && $data.required) {
							_this.input = $this;
							_this.clear = false;
							_this.chk();
							if (_this.clear) {
								_this.clearchk = false;
								return false;
							} else {
								_this.clearchk = true;
								if ($this.is('input[type="checkbox"]') || $this.is('input[type="radio"]')) {
									_this.input = _this.input.prop('checked') ? _this.input : null;
								}
								if (_this.input) {
									_this.inputArry.push(_this.input);
								}
							}
						}
					});
				},
				chk: function () {
					var _this = this;
					if (this.obj == 'tel' || this.obj == 'email') {
						_this.typeInputGubun(_this.el);
					}
					if (this.input.is('input[type="checkbox"]')) {
						this.errorFun(this.input.prop('checked'), this.opt.chkmsg[0]);
					} else if (this.input.is('input[type="radio"]')) {
						var $name = this.input.attr('name');
						if (this.input.is(':checked') && this.input.data(_this.dataName) && this.input.data(_this.dataName).required) {
							radioBool = true;
						}
						this.errorFun(radioBool, this.opt.chkmsg[0]);
					} else {
						var inputbool = this.input.val();
						var trim = inputbool.replace(/\s+/, '');
						if (this.input.is('textarea') && trim == '') {
							inputbool = false;
						}
						if (this.obj.maxlength && this.obj.minlength && (this.obj.minlength > this.input.val().length || this.obj.maxlength < this.input.val().length)) {
							//글자수체크 함수명 뒤에 arguments[0] : min , arguments[1] : max
							inputbool = false;
						}
						this.errorFun(inputbool, this.opt.chkmsg[1]);
					}
				},
				errorFun: function (bool, bmsg) {
					if (!bool) {
						/*switch(this.obj.errorCall) {
                case 'alert':
                //alert('\'' + this.title + '\'' + bmsg);
                break;
                case 'layerpop':
                break;
            }*/
						//this.input.focus();
						this.clear = true;
						this.globalBool = false;
					}
				},
				typeInputGubun: function ($this) {
					//var $this = this.el;
					var $val = $this.val();
					var bool = false;
					if ($this.data(this.dataName).ime == 'tel' && $val) {
						if ($this.val().indexOf('010') == 0 || $this.val().indexOf('011') == 0) {
							bool = true;
						}
					} else if ($this.data(this.dataName).ime == 'email' && $val) {
						if ($val.match(/[a-zA-Z0-9\._-]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,5}/g)) {
							bool = true;
						}
					}
					this.errorFun(bool, this.opt.chkmsg[1]);
				},
				submitSet: function (_args) {
					if (!_args || typeof _args === 'object') {
						var ajaxobj = $.extend(true, {
							url: '',
							type: 'post',
							data: this.el.serializeObject(),
							dataType: 'json',
							success: function (data) {},
							error: function (r, s, e) {
								console.error("cmmAjax.submitSet() ERROR : \ncode:" + r.status + "\n" + "message:" + r.responseText + "\n" + "error:" + e);
							}
						}, _args);
						if (!this.obj.jsonParse) {
							//ajaxobj.data = JSON.stringify(ajaxobj.data);
						}
						$.ajax(ajaxobj);
					} else if (typeof _args === 'function') {
						_args();
					}
				},
				clear: function ($this) {
					$this.find('input, textarea, select').each(function () {
						var $this = $(this);
						if ($this.is('[type="checkbox"]') || $this.is('[type="radio"]')) {
							$this.prop('checked', false);
						} else {
							$this.val('');
						}
					});
				}
			};
			this.each(function () {
				$.data($(this), new CmmAjax($(this), obj));
			});
			return globalBool;
		},
		serializeObject: function () {
			var $this = $(this);
			var o = {};
			var a = this.serializeArray();
			$.each(a, function () {
				if (o[this.name]) {
					if (!o[this.name].push) {
						o[this.name] = [o[this.name]];
					}
					o[this.name].push(this.value || '');
				} else {
					o[this.name] = this.value || '';
				}
			});
			return o;
		},
		cmmYoutubePlayPause: function (opt) {
			var $this = $(this);
			var defaults = {
				action: 'stop', //stop, pause, play , onReady, playing
				eventCallback: null,
				actionCallback: null
			};

			function CmmYoutubePlayPause(_self) {
				var _this = this;
				this.el = _self;
				this.opt = $.extend(true, defaults, opt);
				this.obj = {
					paramGubun: ['?', '&'],
					params: 'enablejsapi=1&version=3&playerapiid=ytplayer&cc_load_policy=1',
				};
				this.init();
			}
			CmmYoutubePlayPause.prototype = {
				init: function () {
					this.set();
					if (this.opt.action) {
						this.actions(this.opt.action);
					}
				},
				set: function () {
					var _this = this;
					$(this.el).each(function () {
						var $this = $(this);
						var $thisSrc = $this.attr('src');
						if ($thisSrc.indexOf(_this.obj.params) == -1) {
							if ($thisSrc.indexOf(_this.obj.paramGubun[0]) != -1) {
								$thisSrc = $thisSrc + _this.obj.paramGubun[1] + _this.obj.params;
							} else {
								$thisSrc = $thisSrc + _this.obj.paramGubun[0] + _this.obj.params;
							}
							$this.attr('src', $thisSrc);
						}
					});
				},
				actions: function (gubun) {
					var _this = this;
					var gubunv = '';
					if (gubun == 'stop') {
						gubunv = 'stopVideo';
					} else if (gubun == 'pause') {
						gubunv = 'pauseVideo';
					} else if (gubun == 'play') {
						gubunv = 'playVideo';
					} else {
						gubunv = gubun;
					}
					$(_this.el).load(function () {
						this.contentWindow.postMessage('{"event" : "command","func" : "' + gubunv + '","args":""}', '*');

						function onYouTubePlayerReady() {
						}
						if (typeof _this.opt.eventCallback === 'function') {
							_this.opt.eventCallback(this);
						}
					});
				}
			};
			this.each(function () {
				$.data($(this), new CmmYoutubePlayPause(this));
			});
			return $this;
		},
		cmmLimitTime: function (obj, callb) {
			/*$(this).cmmLimitTime({
				datetype: 'minu',
				limitdate: 201801151659
			}, function() {
			asdfasdf
			});*/
			function CmmLimitTime() {
				this.obj = $.extend(true, {
					datetype: 'date', //year , month , date , hours, minu
					limitdate: 0,
				}, obj);
				this.newdate = new Date();
				this.date = {
					year: this.newdate.getFullYear(),
					month: this.newdate.getMonth() + 1 >= 10 ? this.newdate.getMonth() + 1 : '0' + (this.newdate.getMonth() + 1),
					date: this.newdate.getDate() >= 10 ? this.newdate.getDate() : '0' + this.newdate.getDate(),
					hours: this.newdate.getHours() >= 10 ? this.newdate.getHours() : '0' + this.newdate.getHours(),
					minu: this.newdate.getMinutes() >= 10 ? this.newdate.getMinutes() : '0' + this.newdate.getMinutes(),
				};
				this.fullDate = 0;
				this.callb = callb;
				this.init();
			};
			CmmLimitTime.prototype = {
				init: function () {
					this.fulldateFun();
					this.act();
				},
				fulldateFun: function () {
					var d = 0;
					switch (this.obj.datetype) {
						case 'year':
							d = Number(this.date.year);
							break;
						case 'month':
							d = Number(this.date.year + '' + this.date.month);
							break;
						case 'date':
							d = Number(this.date.year + '' + this.date.month + '' + this.date.date);
							break;
						case 'hours':
							d = Number(this.date.year + '' + this.date.month + '' + this.date.date + '' + this.date.hours);
							break;
						case 'minu':
							d = Number(this.date.year + '' + this.date.month + '' + this.date.date + '' + this.date.hours + '' + this.date.minu);
							break;
					}
					this.fulldate = d;
				},
				act: function () {
					if (this.obj.limitdate) {
						if (this.fulldate >= this.obj.limitdate) {
							if (typeof this.callb === 'function') {
								this.callb();
							}
						}
					}
				}
			};
			this.each(function () {
				$.data($(this), new CmmLimitTime($(this), obj));
			});
			return this;
		},
		cmmVisualEffect: function (obj) {
			var defaults = {};

			function CmmMycanavs($this) {
				this.canvas = document.getElementById($this[0].id);
				this.ctx = this.canvas.getContext('2d');
			};
			CmmMycanavs.prototype = {
				init: function () {},
				set: function () {},
				update: function () {},
				draw: function () {},
				callb: function () {}
			};
			this.each(function () {
				$.data($(this), new CmmMycanavs($(this), obj));
			});
			return this;
		},
		cmmAsideLocLaypop: function (obj) {
			var $this = $(this);
			var params = typeof obj === 'string' ? {
				msg: obj
			} : obj;
			return $this.cmmLocLaypop($.extend(true, {
				title: '',
				width: 700,
				parentAddClass: 'aside',
				submit: function ($el) {
					$el.cmmLocLaypop('close');
				},
				closeCallb: function ($el) {
					$el.cmmLocLaypop('close');
				}
			}, params));
		},
		cmmInnerScroll: function (obj) {
			var $this = $(this);
			var params = typeof obj === 'string' ? obj : typeof obj === 'object' ? $.extend(true, {
				scrollInertia: 300,
				mouseWheel: {
					preventDefault: true
				}
			}, obj) : {};
			if ($.fn.mCustomScrollbar) {
				return $this.mCustomScrollbar(params);
			} else {
				console.error('플로그인 없음');
				return false;
			}
		},
		cmmLocLaypop: function (obj) {
			/*
    * $('.button1').click(function() {
    $('[data-layerpop="tnvhtb"]').cmmLocLaypop({
    title: '타이틀112311',
    width: 640,
    targetBtnsName: ['aaaa', '확인'],
    beforeCallback: function($el) {
},
afterCallback: function($el) {
},
submit: function($this) {
$this.cmmLocLaypop('close');
$(this).cmmAlert({
title: 'asdf', msg: 'asfasdfasdfasdfasfasdfasdf'
});
},
targetCustomBtnsName: [
['커스텀버튼1', 'asdf asdfasdf', function($button, $el) {
$(document).on('click' ,'.asdfasdf',function(){
$el.cmmLocLaypop('close');
})
}],
['커스텀버튼2', 'asdf asdfasdf12', function($button) {
$(document).on('click' ,'.asdfasdf12',function(){
})
}]
]
});
});
html : <div class="cmm_layerpop" data-layerpop="tnvhtb">내용</div>
*/
			var defaults = {
				type: '',
				align: ['center', 'center'], //['center' , 'center'] 배열에 css백그라운드 처럼 적용
				garaboon: false, //너비적용
				width: '1080px', //너비적용
				height: null, //그냥 주지않는게 편함
				openAfterScroll: false, //팝업오픈 후 스크롤 막기 false 스크롤 안막기 true
				title: '타이틀', //팝업 타이틀
				parentAddClass: '', //특정요소만 커스텀style 해야할때 추가
				targetBtnsName: ['취<span class="cmm_layerpop_btn_blank"></span>소', '확<span class="cmm_layerpop_btn_blank"></span>인'], //버튼텍스트 [0][1] 인덱스 번호로 이벤트가 부여되니 순서 지켜야함
				targetCustomBtnsName: null,
				useBottomArea: true,
				attrSetParams: {},
				clearFormElement: true,
				/*
    * 하단부에 추가적으로 노출되어야할 버튼
    * [   [텍스트명, 클래스명, 함수명]    ]
    ['하단부 커스텀 버튼', 'asdf asdfasdf', function($button, $el) {
    $(document).on('click' ,'.asdfasdf',function(){
    $el.cmmLocLaypop('close');
})
}],
*/
				beforeCallback: null, //동적팝업이 형성되고, 시각화 되기전에 호출
				afterCallback: null, //동적팝업이 형성되고, 시각화 되고 호출
				submit: null, //확인버튼(targetBtnsName[1]) 클릭시 호출
				closeCallb: null, //x버튼, 취소버튼(targetBtnsName[2]) 클릭시 호출
				closeInit: null //x버튼, 취소버튼 클릭시 이벤틉발생 이후 콜백은 X
			};

			function CmmLocLaypop($this) {
				var _this = this;
				this.target = $this;
				this.obj = typeof obj === 'object' ? $.extend(defaults, obj) : obj;
				this.dimmClsName = '.cmm_dimm';
				this.targetParent = '.laypopWarp';
				this.targetParentIn = '.laypopIn';
				this.targetTitle = '.laypopTit';
				this.targetTitleTxt = '.laypopTitTxt';
				this.targetCont = '.laypopCont';
				this.targetBottom = '.laypopBottom';
				this.targetBtns = ['.layClosebtn', '.laySmtbtn'];
				this.cont = '';
				this.title = '';
				this.bottom = '';
				this.currentScrolltop = $(document).scrollTop();
				window.ZOOM_VIEW = window.ZOOM_VIEW ? window.ZOOM_VIEW : 1;
				this.init();
				$(window).smartresize(function () {
					_this.alignFun(true, true);
				});
				return {
					submit: function (callback) {
						if (typeof callback === 'function') {
							_this.obj.submit = callback;
						}
					},
					align: function (bool) {
						_this.alignFun(bool, true);
					}
				};
			};
			CmmLocLaypop.prototype = {
				init: function () {
					var _this = this;
					if (this.obj == 'close') {
						this.act().hide();
						return;
					}
					if (this.obj == 'open') {
						this.act().show();
						return;
					}
					if (this.obj == 'clear') {
						$(_this.target).find('input, select, textarea').each(function () {
							var $this = $(this);
							if ($this.is('[type="radio"]') || $this.is('[type="checkbox"]')) {
								$this.prop('checked', false);
							} else {
								$this.val('');
							}
						});
						return;
					}
					_this.set();
					_this.dimm().set();
					_this.act().show();
					_this.close();
					_this.submitFun();
				},
				set: function () {
					var _this = this;
					switch (this.obj.type) {
						case 'alert':
							this.cont += '<div class="' + this.clsFormat(this.targetParent) + ' cmmParaenAlert ' + this.obj.parentAddClass + '">';
							break;
						case 'confirm':
							this.cont += '<div class="' + this.clsFormat(this.targetParent) + ' cmmParaenConfirm ' + this.obj.parentAddClass + '">';
							break;
						default:
							this.cont += '<div class="' + this.clsFormat(this.targetParent) + ' ' + (
								!this.obj.useBottomArea ? 'hiddenBottomArea' : ''
							) + '  ' + this.obj.parentAddClass + '">';
					}
					if (!this.obj.height) {
						this.obj.height = 'auto';
					} else {
						this.obj.height = this.obj.height + 'px';
					}
					this.cont += '<div class="' + this.clsFormat(this.targetParentIn) + '" style="width: ' + (
						typeof this.obj.width === 'number' ? this.obj.width + 'px' : this.obj.width
					) + '; height : ' + this.obj.height + '">';
					this.cont += '<div class="' + this.clsFormat(this.targetCont) + '">';
					if (this.obj.type == 'alert' || this.obj.type == 'confirm') {
						this.cont += '<div class="alert_msg">' + this.obj.msg + '</div>';
					}
					this.cont += '</div>';
					this.cont += '</div>';
					this.cont += '</div>';
					this.title += '<div class="' + this.clsFormat(this.targetTitle) + '">';
					this.title += '<span class="' + this.clsFormat(this.targetTitleTxt) + '">' + this.obj.title + '</span>';
					this.title += '<a href="javascript: ;" class="' + this.clsFormat(this.targetBtns[0]) + ' " title=""><span class="ti-close"></span></a>';
					this.title += '</div>';
					if (this.obj.useBottomArea) {
						this.bottom += '<div class="' + this.clsFormat(this.targetBottom) + '">';
						if (this.obj.type != 'alert') {
							this.bottom += '<a href="javascript:;" class="btns blue outline ' + this.clsFormat(this.targetBtns[0]) + ' " title="">' + this.obj.targetBtnsName[0] + '</a>';
							this.bottom += '<a href="javascript:;" class="btns blue ' + this.clsFormat(this.targetBtns[1]) + ' " title="">' + this.obj.targetBtnsName[1] + '</a>';
						} else {
							this.bottom += '<a href="javascript:;" class="btns blue ' + this.clsFormat(this.targetBtns[1]) + ' ">' + this.obj.targetBtnsName[0] + '</a>';
						}
					}
					this.bottom += '</div>';
					if (!$(this.target).closest(this.targetParent).length) {
						$(this.target).wrap(this.cont);
						$(this.target).closest(this.targetParentIn).prepend(this.title);
						$(this.target).closest(this.targetParentIn).append(this.bottom);
						//팝업 하단부 커스텀 버튼 생성
						if (this.obj.targetCustomBtnsName && typeof this.obj.targetCustomBtnsName === 'object') {
							$(this.target).closest(this.targetParentIn).find(this.targetBottom).html('');
							for (var i = 0; i < this.obj.targetCustomBtnsName.length; i++) {
								var clsn = this.obj.targetCustomBtnsName[i][1] ? this.obj.targetCustomBtnsName[i][1] : 'cst_btn';
								if (typeof this.obj.targetCustomBtnsName[i][2] === 'object') {
									var t = this.obj.targetCustomBtnsName[i][2];
									var o = {
										href: t.href ? t.href : '',
										target: t.target ? t.target : '_self',
										title: t.title ? t.title : '',
									}
									var html = '<a href="' + o.href + '" target="' + o.target + '" title="' + o.title + '"  class="' + clsn + '">' + this.obj.targetCustomBtnsName[i][0] + '</a>';
								} else {
									var html = '<a href="javascript:;" class="' + clsn + '">' + this.obj.targetCustomBtnsName[i][0] + '</a>';
								}
								var $html = $(html);
								$(this.target).closest(this.targetParentIn).find(this.targetBottom).append(html);
								if (typeof this.obj.targetCustomBtnsName[i][2] === 'function') {
									this.obj.targetCustomBtnsName[i][2]($html, $(this.target).closest(this.targetParent));
								}
							}
						}
						this.cont = '';
						this.title = '';
						this.bottom = '';
					}
					$(this.target).closest(this.targetParent).attr('data-params', (function () {
						var _p = '';
						if (_this.obj.attrSetParams && typeof _this.obj.attrSetParams === 'object') {
							_p = JSON.stringify(_this.obj.attrSetParams);
						}
						return _p;
					})());
					if (typeof this.obj.beforeCallback === 'function') {
						this.obj.beforeCallback($(this.target));
					}
					$(this.target).show();
					$(this.target).closest(this.targetParent).hide();
				},
				alignFun: function (bool, popOpenGoobun) {
					var _this = this;
					if (bool) {
						var sc = {
							//val: $(document).scrollTop() * (1 / window.ZOOM_VIEW),
							val: $('body').is('[data-scroll-value]') ? Math.abs($('body').attr('[data-scroll-value]')) : $(document).scrollTop() * (1 / window.ZOOM_VIEW),
						};
						var align = function ($this) {
							var v = null;
							if (!_this.obj || !_this.obj.align) {
								return '';
							}
							switch (_this.obj.align[0], _this.obj.align[1]) {
								case 'center', 'center':
									var tp = (function () {
										if ($('body').outerHeight() <= $this.outerHeight()) {
											$(_this.target).closest(_this.targetParent).addClass('oversizeHeight');
											return 0;
										} else {
											$(_this.target).closest(_this.targetParent).removeClass('oversizeHeight');
											return $('html').is('.mobile') ? sc.val + (window.innerHeight / 2) + ($this.outerHeight() / 2) : sc.val + (window.innerHeight / 2) - ($this.outerHeight() / 2)
										}
									})();
									if (!popOpenGoobun && $('body').css('margin-top')) {
										tp += Number($('body').css('margin-top').replace(/[^0-9.]/g, ''));
									}
									v = {
										'top': tp
									};
									break;
								case 'left', 'top':
								case 'right', 'top':
									v = {
										'top': sc.val + 50
									};
									break;
							}
							return v;
						};
						setTimeout(function () { //만약 팝업안에 이미지가있다면 이미지불러오는시간때문에 높이값이 제대로 측정안됨. 그래서타임아웃
							$(_this.target).closest(_this.targetParent).css(align($(_this.target).closest(_this.targetParent)));
							if (typeof _this.obj.afterCallback === 'function') {
								$(_this.target).closest(_this.targetParent).attr('data-layerpop-visible', true);
								_this.obj.afterCallback($(_this.target).closest(_this.targetParent));
							}
						}, 10);
					}
				},
				submitFun: function () {
					var _this = this;
					$(_this.target).closest(_this.targetParent).find(this.targetBtns[1]).off().on({
						'click': function () {
							if (typeof _this.obj.submit === 'function' && _this.obj.submit) {
								_this.obj.submit($(this).closest(_this.targetParent));
								if (_this.obj.type == 'alert' || _this.obj.type == 'confirm') {
									$(_this).closest(_this.targetParent).remove();
								}
								$(document).scrollTop(_this.currentScrolltop);
							} else {
								_this.act().hide();
							}
						}
					});
				},
				scrLock: function (bool, popOpenGoobun) {
					/*
					 * parametter : popOpenGoobun = 팝업이 하나라도 열려있으면 ? false : true
					 */
					this.alignFun(bool, popOpenGoobun);
					var scrollValue = -(this.currentScrolltop * (1 / window.ZOOM_VIEW));
					if (!this.obj.garaboon) {
						if (bool) {
							var o = {
								'overflow-y': 'hidden',
								'position': 'fixed',
								'width': '100%',
								'height': '100%',
							}
							if (popOpenGoobun) {
								o = $.extend(false, o, {
									'margin-top': scrollValue
								});
							}
							$('body').css(o).attr('data-scroll-value', scrollValue);
							// $(this.target).closest(this.targetParent).find(this.dimmClsName).on('wheel scroll mousemove touchmove touchstart', function(e) {
							//     e.preventDefault();
							//     e.stopPropagation();
							//     return false;
							// });
							$(this.target).closest(this.targetParent).on('touchmove', function (e) {
								var cnt = true;
								var lastY = 0;
								if (e.originalEvent) {
									var currentY = e.originalEvent.touches[0].clientY;
									if (currentY != lastY) {
										cnt = false;
									}
									lastY = currentY;
								}
								return cnt;
							});
						} else {
							if (popOpenGoobun) {
								$('body').css({
									'overflow-y': 'auto',
									'position': 'static',
									'width': 'auto',
									'height': 'auto',
									'margin-top': 0
								}).removeAttr('data-scroll-value');
								$(document).scrollTop(this.currentScrolltop);
							}
						}
					}
					if (this.obj.openAfterScroll) {
						$(this.target).closest(this.targetParent).addClass('oversizeHeight');
					}
				},
				close: function () {
					var _this = this;
					// $(document).keyup(function() {
					//     if(event.keyCode == 27) {//esc
					//         if(typeof _this.obj.closeInit === 'function'){
					//             _this.obj.closeInit();
					//         }else{
					//             _this.act().hide();
					//         }
					//     }
					// });
					$(_this.target).closest(_this.targetParent).find(this.targetBtns[0]).off().on({
						'click': function (e) {
							if (typeof _this.obj.closeInit === 'function') {
								_this.obj.closeInit($(this).closest(_this.targetParent));
							} else {
								_this.act().hide($(this));
							}
							return false;
						}
					});
					$(_this.target).closest(_this.targetParent).find(this.dimmClsName).off().on({
						'click': function () {
							if (typeof _this.obj.closeInit === 'function') {
								_this.obj.closeInit($(this).closest(_this.targetParent));
							} else {
								_this.act().hide($(this));
							}
							return false;
						}
					});
				},
				act: function (bool) {
					var _this = this;
					var popOpenFun = function () {
						var popOpenGoobun = true;
						/* 팝업이 하나라도 열려있을땐 바디얼라인 안탐 : S */
						$(_this.targetParent).each(function () {
							var $this = $(this);
							if ($this.is(':visible')) {
								popOpenGoobun = false;
							}
						});
						/* 팝업이 하나라도 열려있을땐 바디얼라인 안탐 : E */
						return popOpenGoobun;
					};
					return {
						show: function () {
							var gt = popOpenFun();
							$(_this.target).closest(_this.targetParent).show();
							$(_this.target).closest(_this.targetParentIn).addClass('layerpop_on');
							_this.dimm().get(true);
							_this.scrLock(true, gt);
						},
						hide: function ($self) {
							$(_this.target).closest(_this.targetParent).hide();
							$(_this.target).closest(_this.targetParentIn).removeClass('layerpop_on');
							_this.dimm().get(false, '', $self);
							_this.scrLock(false, popOpenFun());
							if (_this.obj.clearFormElement) {
								$(_this.target).find('input, select, textarea').each(function () {
									var $this = $(this);
									if ($this.is('[type="radio"]') || $this.is('[type="checkbox"]')) {
										$this.prop('checked', false);
									} else {
										$this.val('');
									}
								});
							}
							$(_this.target).closest(_this.targetParent).attr('data-layerpop-visible', false);
							if (typeof _this.obj.closeCallb === 'function') {
								_this.obj.closeCallb($(_this.target).closest(_this.targetParent));
							}
						}
					};
				},
				dimm: function () {
					var _this = this;
					var $p = $(_this.target).closest(_this.targetParent);
					return {
						set: function () {
							$p.prepend('<div class="' + _this.clsFormat(_this.dimmClsName) + ' " style="display: none;"></div>');
							$p.find(_this.dimmClsName).css({
								'position': 'fixed',
								'z-index': 100,
								'left': 0,
								'top': 0,
								'bottom': 0,
								'width': '100%',
								'opacity': 0,
								'background': 'black'
							});
							//클릭했을때 닫히게 안되는건 상단부에 딤드 touch swipe 등등 이벤트 off시킴
						},
						get: function (bool, callb, $self) {
							if (bool) {
								$p.find(_this.dimmClsName).show().animate({
									'opacity': .7
								}, $.extend({
									'duration': 200,
									'complete': function () {}
								}, callb));
							} else {
								$p.find(_this.dimmClsName).animate({
									'opacity': 0
								}, $.extend({
									'complete': function () {
										$(this).remove();
									}
								}, callb));
							}
						},
					};
				},
				aniCallb: function (obj) {
					return $.extend({
						'duration': 600,
						'easing': 'swing',
						'complete': function () {},
						'step': function () {}
					}, obj);
				},
				clsFormat: function (str) {
					return str.replace('.', '');
				},
			};
			// this.each(function() {
			//     $.data(this, new CmmLocLaypop($(this), obj));
			// });
			return new CmmLocLaypop($(this), obj);
		},
		multiEllip: function (opt) {
			var defaults = {
				len: 0,
				ellips: '...',
				space: false,
				initTxtAppend: true,
			};

			function MultiEllip($this) {
				this.el = $this;
				this.txt = '';
				this.initTxt = '';
				this.obj = $.extend(true, defaults, opt);
				this.init();
			};
			MultiEllip.prototype = {
				init: function () {
					this.set();
				},
				set: function () {
					var _this = this;
					this.el.each(function () {
						var $thistxt = $(this).text();
						_this.initTxt = $thistxt;
						if (_this.obj.initTxtAppend) {
							_this.append();
						}
						_this.slc($thistxt);
					});
				},
				append: function () {
					this.el.after('<span class="mult_init_txt multInitTxt" style="display: none;">' + this.initTxt + '</span>');
				},
				slc: function (txt) {
					var txt = txt.replace(/(^\s*)|(\s*$)/g, '');
					var len = this.obj.space ? txt.replace(/ /gi, '').length : txt.length;
					if (len > this.obj.len) {
						this.txt = txt.slice(0, this.obj.len);
						this.el.text(this.txt + this.obj.ellips);
					}
				},
			};
			this.each(function () {
				$.data(this, new MultiEllip($(this), opt));
			});
			return this;
		},
		mapApiSortFun: function (obj) {
			var defaults = {
				LatReturn: null,
				LngReturn: null,
				level: 3,
				marker: {
					src: '/common/images/sub/baseIco02.png',
					size: [70, 95],
				},
			};

			function DaumMapLoad($this) {
				var LatReturn = null;
				var LngReturn = null;
				var level = null;
				var map = null;
				this.el = $this;
				this.obj = $.extend(true, defaults, obj);
				this.init();
			};
			DaumMapLoad.prototype = {
				init: function () {
					LatReturn = this.obj.LatReturn;
					LngReturn = this.obj.LngReturn;
					level = this.obj.level;
					var mapContainer = this.el[0] ? this.el[0] : null;
					var mapOption = {
						center: new daum.maps.LatLng(LatReturn, LngReturn),
						level: level
					};
					map = new daum.maps.Map(mapContainer, mapOption);
					this.marker();
					this.overlay();
				},
				marker: function () {
					var imageSrc = this.obj.marker.src;
					var imageSize = new daum.maps.Size(this.obj.marker.size[0], this.obj.marker.size[1]);
					var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize);
					var markerPosition = new daum.maps.LatLng(LatReturn, LngReturn);
					var marker = new daum.maps.Marker({
						position: markerPosition,
						image: markerImage
					});
					marker.setMap(map);
				},
				overlay: function () {
					var content = '';
					var position = new daum.maps.LatLng(LatReturn, LngReturn);
					var customOverlay = new daum.maps.CustomOverlay({
						map: map,
						position: position,
						content: content,
						yAnchor: 1
					});
				},
			};
			this.each(function () {
				$.data(this, new DaumMapLoad($(this), obj));
			});
			return this;
		},
		numberEffect: function (obj) {
			var defaults = {
				mode: 'typing',
				speed: 1500
			};

			function NumberEffect($this) {
				this.el = $this;
				this.obj = $.extend(true, defaults, obj);
				this.init();
			};
			NumberEffect.prototype = {
				init: function () {
					var _this = this;
					_this.el.each(function () {
						var $this = $(this);
						var speed = 10;
						var $thisTxt = Number($this.text());
						$this.css({
							'width': $this.width()
						});
						$this.text('');
						$this.animate({
							'num': $thisTxt
						}, {
							'duration': _this.obj.speed,
							'step': function (t, o) {
								var stepNum = Math.ceil(o.now);
								$this.text(stepNum);
							},
							'complete': function () {
								$this.css({
									'width': 'auto'
								});
							}
						});
					});
				},
			};
			this.each(function () {
				$.data(this, new NumberEffect($(this), obj));
			});
			return this;
		},
		cmmShowHideTabs: function (obj) {
			var defaults = {
				tabUl: '',
				tabDivs: '',
				tabAnimate: false,
				tabAnitype: '',
				tabhref: '.href',
				tabInSlide: false,
				callb: function () {},
			};

			function CmmShowHideTabs($this) {
				this.tabWrap = $this;
				this.obj = $.extend(true, defaults, obj);
				this.li = null;
				this.idx = null;
				this.init();
			};
			CmmShowHideTabs.prototype = {
				init: function () {
					if (!this.tabWrap.is(this.obj.tabhref)) {
						this.set();
						this.bind();
					} else {
						this.tabHref();
					}
				},
				set: function () {
					if (this.obj.tabInSlide) {
						$(this.tabWrap).find(this.obj.tabDivs + '>div,' + this.obj.tabDivs + '>ul').css({
							'overflow': 'hidden',
							'height': 0
						});
					} else {
						$(this.tabWrap).find(this.obj.tabDivs + '>div,' + this.obj.tabDivs + '>ul').hide();
					}
				},
				bind: function () {
					var _this = this;
					this.tabWrap.find(this.obj.tabUl + '>li').on({
						'click': function (e) {
							e.preventDefault();
							_this.li = $(this);
							_this.idx = $(this).index();
							_this.show();
							return false;
						},
					});
					_this.tabWrap.find(_this.obj.tabUl + '>li:eq(0)').click();
				},
				show: function () {
					this.tabWrap.find(this.obj.tabUl + '>li').removeClass('active');
					this.li.addClass('active');
					if (this.obj.tabInSlide) {
						$(this.tabWrap).find(this.obj.tabDivs + '>div,' + this.obj.tabDivs + '>ul').css({
							'overflow': 'hidden',
							'height': 0
						});
						$(this.tabWrap).find(this.obj.tabDivs + '>div:eq(' + this.idx + ') ,' + this.obj.tabDivs + '>ul:eq(' + this.idx + ')').css({
							'overflow': 'visible',
							'height': 'auto'
						});
					} else {
						$(this.tabWrap).find(this.obj.tabDivs + '>div,' + this.obj.tabDivs + '>ul').hide();
						$(this.tabWrap).find(this.obj.tabDivs + '>div:eq(' + this.idx + ') ,' + this.obj.tabDivs + '>ul:eq(' + this.idx + ')').show();
					}
					if (typeof this.obj.callb === 'function') {
						this.obj.callb(this.tabWrap, this.idx, this.li);
					}
				},
				tabHref: function () {
					var _this = this;
					this.tabWrap.attr('data-coldiv');
					this.tabWrap.find(this.obj.tabUl + '>li').each(function () {
						if ($(this).is('.active')) {
							var $color = $(this).find('.txt').attr('data-color');
							_this.tabWrap.attr('data-coldiv', $color);
						}
					});
				},
			};
			this.each(function () {
				$.data(this, new CmmShowHideTabs($(this), obj));
			});
			return this;
		},
		rspGrid: function (obj) {
			var _settings = {
				setBox: {
					items: '.item',
					width: 230,
					margin: null
				},
				animate: true,
				animateOfOptions: {
					mode: 'flip', // flip,opacity
					duration: 300,
					ease: 'easeOutExpo',
					queue: false,
					complete: function () {},
				},
				renderAfterCallb: function () {},
				animateAfterCallb: function () {},
			};

			function RspGrid(el, obj) {
				this.col = null;
				this.itemGroup = 'itemsGroup';
				this.opt = $.extend(true, _settings, obj);
				this.el = $(el);
				this.box = this.el.find(this.opt.setBox.items);
				this.init();
			};
			RspGrid.prototype = {
				init: function () {
					var _this = this;
					this.el.addClass('clearfix');
					this.setItem();
					this.renderItem();
					$(window).smartresize(function () {
						_this.resizeble();
					});
				},
				setItem: function () {
					var thisOtp = this.opt.setBox;
					var w = Math.floor(this.el.width() / thisOtp.width);
					var boxw = 100 / w;
					this.col = w;
					for (var i = 0; i < this.col; i++) {
						var div = $('<div></div>').addClass(this.itemGroup).css({
							'width': boxw + '%',
							'float': 'left',
							'box-sizing': 'border-box',
							'-webkit-box-sizing': 'border-box',
							'-moz-box-sizing': 'border-box',
							'-ms-box-sizing': 'border-box',
							'-o-box-sizing': 'border-box',
						}).attr('itemGroup', i);
						this.el.append(div);
					}
				},
				renderItem: function (evt, resizeYN) {
					var itemArry = [];
					var _this = this;
					var num = 0;
					this.box.each(function (idx) {
						num++;
						var $this = $(this);
						$this.css({
							'padding': _this.opt.setBox.margin / 2
						});
						if (idx % _this.col == 0) {
							num = 0;
						}
						$this.attr('itemGroupBox', num);
						var $thisGroupNum = $this.attr('itemGroupBox');
						$('.' + _this.itemGroup + '[itemgroup="' + $thisGroupNum + '"]').append($this);
						if (resizeYN != 'N') _this.renderAnimate($this, idx);
					});
					if (typeof this.opt.renderAfterCallb === 'function') {
						this.opt.renderAfterCallb();
					}
				},
				renderAnimate: function ($this, idx) {
					var thisOpt = this.opt.animateOfOptions;
					if (this.opt.animate) {
						var funs = function () {};
						if (!thisOpt.queue) {
							var time = idx * 150;
						} else {
							var time = 0;
						}
						switch (thisOpt.mode) {
							case 'flip':
								$this.css({
									'display': 'none'
								});
								funs = function () {
									$this.slideDown({
										'duration': thisOpt.duration,
										'easing': thisOpt.ease,
										'complete': thisOpt.complete()
									});
								}
								break;
							case 'opacity':
								$this.css({
									'opacity': .1
								});
								funs = function () {
									$this.stop().animate({
										'opacity': 1
									}, {
										'duration': thisOpt.duration,
										'easing': thisOpt.ease,
										'complete': thisOpt.complete()
									});
								}
								break;
							case 'pars':
								break;
						}
						setTimeout(funs, time);
					}
					if (typeof this.opt.animateAfterCallb === 'function') {
						this.opt.animateAfterCallb();
					}
				},
				resizeble: function () {
					this.el.find('>').remove();
					this.setItem();
					this.renderItem('', 'N');
				}
			};
			this.each(function () {
				$.data(this, new RspGrid($(this), obj));
			});
			return this;
		},
		uiSwiper: function (obj) {
			/*
			 * slick.js 기반의 플러그인(http://kenwheeler.github.io/slick/) slick 옵션+커스텀옵션 추가, 제작자 : 임희재 버전 : v.01
			 */
			var $this = $(this);
			var $slide = null;
			var defaults = {
				/** slickJS 전용객체 */
				slideObj: {
					draggable: false,
				},
				/** 페이징+버튼 */
				uiBtnsApp: {
					target: 'contr',
					uiDot: true,
					uiShortDot: false,
					uiPrev: null,
					uiNext: null,
					uiPause: null,
					uiPlay: null,
				},
				/** dot관련 */
				dotThumb: false,
				dotTabs: false,
				dotTabsLst: '',
				uicallback: function () {},
				/** 슬라이드 콜백관련 */
				beforeCallback: function () {},
				afterCallback: function () {},
			};

			function CmmUiSwiper() {
				this.obj = $exObj;
				this.acallb = function (o) {
					var cb = {
						duration: 300,
						ease: 'easeInExpo',
						complete: function () {}
					};
					if (typeof o === 'object') {
						var $exCb = $.extend(true, cb, o);
						return $exCb;
					}
				};
				if ($.fn.slick) this.init();
			};
			CmmUiSwiper.prototype = {
				init: function () {
					this.slickSlide();
				},
				slickSlide: function () {
					var _this = this;
					$slide = $.fn.slick ? $this.slick($.extend(true, {}, this.obj.slideObj)) : null;
					if (!$slide) {
						console.error('slickJS임포트해주세요');
					}
					if (typeof this.obj.afterCallback === 'function' && typeof this.obj.beforeCallback === 'function') {
						$this.on({
							'afterChange': function (a, b, c) {
								_this.obj.afterCallback(a, b, c);
							},
							'beforeChange': function (a, b, c) {
								_this.obj.beforeCallback(a, b, c);
							}
						});
					}
					this.initButtons();
				},
				initButtons: function () {
					if (typeof this.obj.uiBtnsApp !== 'object') {
						$this.find('.slick-prev').show();
						$this.find('.slick-next').show();
						return;
					}
					$this.find('.slick-prev').hide();
					$this.find('.slick-next').hide();
					this.buttons();
				},
				buttons: function () {
					var uiBtnsAppTarget = this.obj.uiBtnsApp.target;
					var buttons = {
						uiDot: this.obj.uiBtnsApp.uiDot ? $this.find('.slick-dots') : null,
						uiPrev: this.obj.uiBtnsApp.uiPrev ? this.obj.uiBtnsApp.uiPrev : 'uiSlidePrev',
						uiPause: this.obj.uiBtnsApp.uiPause ? this.obj.uiBtnsApp.uiPause : 'uiSlidePause',
						uiPlay: this.obj.uiBtnsApp.uiPlay ? this.obj.uiBtnsApp.uiPlay : 'uiSlidePlay',
						uiNext: this.obj.uiBtnsApp.uiNext ? this.obj.uiBtnsApp.uiNext : 'uiSlideNext',
						uiShortDot: this.obj.uiBtnsApp.uiShortDot ? 'uiSlideShortDot' : null,
					};
					$this.parent().append('<div class="' + uiBtnsAppTarget + '"></div>');
					var $uiBtnsAppTarget = $this.parent().find('.' + uiBtnsAppTarget);
					for (var i in buttons) {
						var buttonsVal = buttons[i];
						var html = '';
						switch (i) {
							case 'uiPrev':
								html = $('<a href="#" class="uislide_prev ' + buttonsVal + '" title="이전슬라이드"></a>');
								break;
							case 'uiNext':
								html = $('<a href="#" class="uislide_next ' + buttonsVal + '" title="다음슬라이드"></a>');
								break;
							case 'uiPause':
								if (this.obj.slideObj.autoplay) {
									html = $('<a href="#" class="uislide_pause ' + buttonsVal + '" title="슬라이드 일시정지"></a>');
								}
								break;
							case 'uiPlay':
								if (this.obj.slideObj.autoplay) {
									html = $('<a href="#" class="uislide_play ' + buttonsVal + '" title="슬라이드 재생"></a>');
								}
								break;
							case 'uiShortDot':
								if (this.obj.uiBtnsApp.uiShortDot) {
									html = $('<div class="uislide_shortdot ' + buttonsVal + '"></div>');
								}
								break;
							default:
								html = buttonsVal;
						}
						$uiBtnsAppTarget.append(html);
					}
					if (this.obj.slideObj.dots) {
						if (this.obj.dotThumb) {
							this.dotThumb(buttons);
						} else if (this.obj.dotTabs && this.obj.dotTabsLst) {
							var _this = this;
							this.dotTabs();
							$this.on({
								'afterChange swipe edge': function () {
									_this.dotTabs();
								}
							});
						}
					}
					if (this.obj.uiBtnsApp.uiShortDot) {
						var _this = this;
						this.dotShort(buttons);
						$this.on({
							'afterChange swipe edge': function () {
								_this.dotShort(buttons);
							}
						});
					}
					this.buttonsEvent(buttons);
				},
				dotThumb: function (buttons) {
					var imgSrc = null;
					buttons.uiDot.find('>li').each(function () {
						var $thisIdx = $(this).index();
						var imgSrc = '';
						$this.find('.slick-slide').each(function () {
							if ($(this).data('slick-index') == $thisIdx) {
								imgSrc = $(this).find('img').attr('src');
							}
						});
						$(this).find('button').html('<img src="' + imgSrc + '" alt="슬라이드이미지 썸네일" class="uislide_dotimg" />');
					});
				},
				dotShort: function (buttons) {
					var $dots = $this.parent().find('.slick-dots li');
					var $activeDot = null;
					var allTxt = $dots.length;
					$dots.each(function () {
						if ($(this).is('.slick-active')) {
							$activeDot = $(this).index() + 1;
						}
					});
					if (!$activeDot) $activeDot = 0;
					$this.parent().find('.' + buttons.uiShortDot).html('<em class="poi">' + $activeDot + '</em>' + '/' + allTxt);
				},
				dotTabs: function () {
					var _this = this;
					var $ul = $(this.obj.dotTabsLst);
					var $li = $ul.find('li');
					var $dots = $this.parent().find('.slick-dots');
					var $activeDot = null;
					$dots.find('li').each(function () {
						if ($(this).is('.slick-active')) {
							$activeDot = $(this).index();
						}
					});
					$li.removeClass('active');
					$ul.find('li:eq(' + $activeDot + ')').addClass('active');
					$li.off().on({
						'mouseenter click': function () {
							var $thisIdx = $(this).closest('li').index();
							$li.removeClass('active');
							$dots.find('li:eq(' + $thisIdx + ')').click();
							return false;
						},
					});
				},
				buttonsEvent: function (buttons) {
					// $this.parent().find('.' + buttons.uiPause).css('opacity', 1);
					$this.parent().find('.' + buttons.uiPlay).hide();
					$this.parent().find('.' + buttons.uiPrev).on({
						'click': function () {
							$this.find('.slick-prev').click();
							return false;
						}
					});
					$this.parent().find('.' + buttons.uiNext).on({
						'click': function () {
							$this.find('.slick-next').click();
							return false;
						}
					});
					$this.parent().find('.' + buttons.uiPause).on({
						'click': function () {
							$this.slick('slickPause');
							$(this).hide();
							$this.parent().find('.' + buttons.uiPlay).show();
							return false;
						}
					});
					$this.parent().find('.' + buttons.uiPlay).on({
						'click': function () {
							$this.slick('slickPlay');
							$(this).hide();
							$this.parent().find('.' + buttons.uiPause).show();
							return false;
						}
					});
					if (typeof this.obj.uicallback === 'function') {
						this.obj.uicallback();
					}
				},
			};
			var $exObj = $.extend(true, defaults, obj);
			this.each(function () {
				$.data(this, new CmmUiSwiper($exObj));
			});
			return $slide;
		},
		musMoveEffect: function (obj) {
			var $this = $(this);
			var opt = $.extend(true, {
				dots: {
					leng: 40,
					maxw: 80,
					minw: 10,
					type: 'circle',
					color: ['#fac863', '#c594c5', '#6699cc', '#ec5f67', '#5fb3b3'],
					group: null,
					css: {}
				},
				pos: {
					left: null,
					top: null,
				},
				move: {
					dir: 'h', // v , h , vh
					easing: null,
					maxRange: 30,
					distance: 50,
					delay: 3000,
					rever: false,
				},
			}, obj);

			function MusMoveEvt(el) {
				this.target = el;
				this.init();
			};
			MusMoveEvt.prototype = {
				init: function () {
					this.dotDraw();
					this.bind();
				},
				dotDraw: function () {
					var $thisTarget = $(this.target);
					var dots = opt.dots;
					var pos = this.pos;
					var dotsType = dots.type == 'circle' ? '50%' : '';
					$thisTarget.css({
						'overflow': 'hidden'
					});
					for (var i = 1; i <= dots.leng; i++) {
						var _this = this;
						var random = Math.random();
						var ran = Math.floor(random * (dots.maxw - dots.minw + 1)) + dots.minw;
						var bg = Math.floor(random * ((dots.color.length - 1) - 0 + 1)) + 0;
						var bg = dots.color[bg];
						var dotsSize = ran;
						var pos = function () {
							var random = Math.random();
							var left = $(_this.target).width() * random;
							var top = $(_this.target).height() * random;
							return {
								left: left,
								top: top
							};
						};
						var html = '';
						html = '<span style="display: inline-block; width: ' + dotsSize + 'px; height: ' + dotsSize + 'px;  border-radius: ' + dotsType + ';  background: ' + bg + ';position: absolute; left: ' + pos().left + 'px; top: ' + pos().top + 'px; opacity: .05; transform: scale(0);"></span>';
						$thisTarget.append(html);
						var o = i - 1;
						$thisTarget.find('span:eq(' + o + ')').animate({
							'transform': 'scale(1)'
						}, {
							'duration': 700,
							'easing': 'easeInExpo'
						});
					}
					if (typeof dots.css === 'object') {
						$thisTarget.find('span').css(dots.css);
					}
				},
				bind: function () {
					var $thisTarget = $(this.target);
					var _this = this;
					var moveObj = opt.move;
					var lastPos = {
						x: null,
						y: null
					};
					var leftArry = [];
					var topArry = [];
					$thisTarget.find('span').each(function () {
						var $thisLeft = Number($(this).css('left').replace('px', ''));
						var $thisTop = Number($(this).css('top').replace('px', ''));
						leftArry.push($thisLeft);
						topArry.push($thisTop);
					});
					$thisTarget.on({
						'mousemove': function (e) {
							if (true) {
								if (!moveObj.rever) {
									var distance = {
										x: event.pageX > lastPos.x ? moveObj.distance : -moveObj.distance,
										y: event.pageY > lastPos.y ? moveObj.distance : -moveObj.distance,
									};
								} else {
									var distance = {
										x: event.pageX < lastPos.x ? moveObj.distance : -moveObj.distance,
										y: event.pageY < lastPos.y ? moveObj.distance : -moveObj.distance,
									};
								}
								lastPos = {
									x: event.pageX,
									y: event.pageY
								};
								for (var i = 0; i < leftArry.length; i++) {
									if (moveObj.dir == 'h') {
										var aa = leftArry.length / 2;
										if (i <= aa) {
											$(this).find('span:eq(' + i + ')').stop().animate({
												'left': leftArry[i] + distance.x,
											}, {
												'duration': moveObj.delay,
												'easing': 'easeOutExpo'
											});
										} else {
											$(this).find('span:eq(' + i + ')').stop().animate({
												'left': leftArry[i] + ((distance.x + 30) * -1),
											}, {
												'duration': (moveObj.delay * 2),
												'easing': 'easeOutExpo'
											});
										}
									} else if (moveObj.dir == 'v') {
										$(this).find('span:eq(' + i + ')').stop().animate({
											'top': topArry[i] + distance.y
										}, {
											'duration': moveObj.delay,
											'easing': 'easeInExpo'
										});
									} else if (moveObj.dir == 'vh') {
										$(this).find('span:eq(' + i + ')').stop().animate({
											'left': leftArry[i] + distance.x,
											'top': topArry[i] + distance.y
										}, {
											'duration': moveObj.delay,
											'easing': 'easeInExpo'
										});
									}
								}
							}
						},
						'mouseleave': function () {
							for (var i = 0; i < leftArry.length; i++) {
								$(this).find('span:eq(' + i + ')').stop().animate({
									'left': leftArry[i],
									'top': topArry[i]
								}, {
									'duration': moveObj.delay,
									'easing': 'easeInExpo'
								});
							}
						}
					});
				},
			};
			this.each(function () {
				$.data(this, new MusMoveEvt(this));
			});
			return $this;
		},
		cmmCalendal: function (obj) {
			var defaults = {
				format: {
					day: {
						sun: '일',
						mon: '월',
						tue: '화',
						wed: '수',
						thu: '목',
						fri: '금',
						sat: '토'
					},
					month: [
						[1, 'January'],
						[2, 'February'],
						[3, 'March'],
						[4, 'April'],
						[5, 'May'],
						[6, 'June'],
						[7, 'July'],
						[8, 'August'],
						[9, 'September'],
						[10, 'October'],
						[11, 'November'],
						[12, 'December']
					]
				},
				sch: {
					schMax: 1,
					//schItem: [기간,시작날짜,스케줄설명,스케줄들어간애 클래스네임,이건뭐지?,스케줄타이틀],
					schItem: [],
				}
			};

			function CmmCalendal(el, obj) {
				var _this = this;
				var date = new Date();
				this.y = date.getFullYear();
				this.m = date.getMonth();
				this.d = date.getDate();
				this.theDate = new Date(this.y, this.m, 1);
				this.theDay = this.theDate.getDay();
				this.el = $(el);
				this.opt = $.extend(true, defaults, obj);
				this.init();
				/*$(window).smartresize(function() {
        _this.resize();
    });*/
			}
			CmmCalendal.prototype = {
				init: function () {
					this.initPasing();
					this.initSch();
					this.schParsing();
				},
				initPasing: function () {
					var last = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
					if (this.y % 4 && this.y % 100 != 0 || this.y % 400 === 0) {
						lastDate = last[1] = 29;
					}
					var lastDate = last[this.m];
					var row = Math.ceil((this.theDay + lastDate) / 7);
					this.el.html("<div class='cal_top'><div class=''><a href='#' class='btns_cal cal_prev'>&lt;</a><a href='#' class='btns_cal cal_next'>&gt;</a></div><span class='cal_year'>" + this.y + "</span><span class='cal_month'>" + (this.m + 1) + "</span></div>");
					var calendar = '';
					var commColgroup = [7, '14.285%'];
					calendar += "<div class='calTableGroup'>";
					calendar += "<div class='calTheadGroup'>";
					calendar += "<table class='calendar_table'>";
					calendar += "<colgroup>";
					for (var i = 0; i < commColgroup[0]; i++) {
						calendar += "<col width='" + commColgroup[1] + "'/>";
					}
					calendar += "</colgroup>";
					calendar += "<thead>";
					calendar += "<tr>";
					calendar += "<th class='SUN'>" + this.opt.format.day.sun + "</th>";
					calendar += "<th>" + this.opt.format.day.mon + "</th>";
					calendar += "<th>" + this.opt.format.day.tue + "</th>";
					calendar += "<th>" + this.opt.format.day.wed + "</th>";
					calendar += "<th>" + this.opt.format.day.thu + "</th>";
					calendar += "<th>" + this.opt.format.day.fri + "</th>";
					calendar += "<th class='SAT'>" + this.opt.format.day.sat + "</th>";
					calendar += "</tr>";
					calendar += "</thead>";
					calendar += "</table>";
					calendar += "</div>"; // calTheadGroup
					var dNum = 1;
					for (var i = 1; i <= row; i++) {
						calendar += "<div class='calTbodyGroup' data-table-index='" + (i - 1) + "'>";
						calendar += "<table class='calendar_table'>";
						calendar += "<colgroup>";
						for (var o = 0; o < commColgroup[0]; o++) {
							calendar += "<col width='" + commColgroup[1] + "'/>";
						}
						calendar += "</colgroup>";
						calendar += "<tbody>";
						calendar += "<tr>";
						for (var k = 1; k <= 7; k++) {
							if (i === 1 && k <= this.theDay || dNum > lastDate) {
								calendar += "<td>&nbsp;</td>";
							} else {
								if (this.d == dNum) {
									calendar += "<td class='TODAY'><span class='dot'>" + dNum + "</span></td>";
								} else {
									calendar += "<td><span class='dot'>" + dNum + "</span></td>";
								}
								dNum++;
							}
						}
						calendar += "</tr>";
						calendar += "</tbody>";
						calendar += "</table>";
						calendar += "</div>"; // calTbodyGroup
					}
					calendar += "</div>"; // calTableGroup
					this.el.append(calendar);
					$('.calendar_table tr').each(function () {
						var $this = $(this);
						$this.find('td:first').addClass('SUN');
						$this.find('td:last').addClass('SAT');
					});
				},
				initSch: function () {
					var html = '';
					var _this = this;
					var $calTbodyGroup = $('.calTbodyGroup');
					var $calTbl = $('.cal_tbl');
					var $fragment = $(document.createDocumentFragment());
					for (var i = 0; i < this.opt.sch.schItem.length; i++) {
						var time = '<td class="txt_left"><b>' + this.opt.sch.schItem[i][5] + '</b></td>';
						var suj = '<td class="txt_left">' + this.opt.sch.schItem[i][2] + '</td>';
						var suj2 = '<td class="txt_left">' + this.opt.sch.schItem[i][4] + '</td>';
						$fragment.append('<tr>' + time + suj + suj2 + '</tr>');
					}
					$calTbl.find('tbody').append($fragment);
					$calTbodyGroup.each(function () {
						var $this = $(this);
						var $cal_tbl = $this.find('.calendar_table');
						var $_fragment = $(document.createDocumentFragment());
						html += '<table>';
						html += '<colgroup><col width="14.285%"><col width="14.285%"><col width="14.285%"><col width="14.285%"><col width="14.285%"><col width="14.285%"><col width="14.285%"></colgroup>';
						html += '<tbody>';
						html += '<tr>';
						for (var i = 0; i < 7; i++) {
							var x = $cal_tbl.find('tbody td:eq(' + i + ')').text();
							if (!x.replace(/\s/g, '')) {
								x = null;
							}
							html += '<td data-table-index="' + x + '">&nbsp;</td>';
						}
						html += '</tr>';
						html += '</tbody>';
						html += '</table>';
						for (var i = 0; i < _this.opt.sch.schMax; i++) {
							$_fragment.append('<div class="scVirTableGroup" data-table-index="' + i + '">' + html + '</div>');
						}
						$this.append($_fragment);
						html = '';
					});
				},
				schParsing: function () {
					var _this = this;
					var $tbl = $('.calTbodyGroup .calendar_table');
					var item = this.opt.sch.schItem;
					var items = item.length;
					var $td_w = $tbl.find('td').innerWidth();
					for (var i = 0; i < items; i++) {
						//schItem: [기간,시작날짜,스케줄설명,스케줄들어간애 클래스네임,이건뭐지?,스케줄타이틀],
						$tbl.find('td').each(function () {
							var $this = $(this);
							var $i = $this.index();
							var $t = $this.text();
							var $p = $this.closest('.calTbodyGroup');
							if ($t == item[i][1]) {
								if (item[i][0]) {
									$p.find('.scVirTableGroup td[data-table-index="' + $t + '"]').attr('colspan', item[i][0]).html('<span class="sch_lb ' + item[i][3] + '" style="">' + item[i][5] + '</span>');
								}
							}
						});
					}
					var emp = [];
					$('.calTbodyGroup').find('.scVirTableGroup td[colspan]').each(function () {
						var $this = $(this);
						var $i = $this.index();
						var $colspan = $this.attr('colspan');
						var c = 0;
						var cc = 1;
						var ccc = 0;
						$this.closest('tr').find('td').each(function () {
							var $_this = $(this);
							if (!$_this.attr('colspan')) {
								c++;
							} else {
								c += Number($_this.attr('colspan'));
							}
						});
						if (c > 7) {
							for (var i = 0; i < $colspan - 1; i++) {
								if ($this.next()[0]) {
									cc++;
									$this.next().remove();
								} else {
									ccc++;
									var tnc = $.extend(true, {}, {
										tar: $this.closest('.calTbodyGroup').next().find('.scVirTableGroup td:eq(0)'),
										lop: ccc
									});
								}
							}
							emp.push(tnc);
							$this.attr('colspan', cc);
						}
					});
					for (var i = 0; i < emp.length; i++) {
						if (emp[i]) {
							for (var o = 1; o < emp[i].lop; o++) {
								emp[i].tar.next().remove();
							}
							emp[i].tar.attr('colspan', emp[i].lop).html('<span class="sch_lb ' + item[i][3] + '" style="">' + item[i][5] + '</span>');
						}
					}
				},
				resize: function () {
					this.el.empty();
					this.init();
				}
			};
			this.each(function () {
				$.data(this, new CmmCalendal($(this), obj));
			});
			return this;
		},
		musMoveDragPraxx: function (obj) {
			/** 작업소스 예시
			$('.list li').each(function () {
			    var $this = $(this);
			    var $thisImg = $this.find('img');
			    var $thisSpan = $this.find('.asdf');
			    $this.musMoveDragPraxx({
			        motions: [
			            [$thisImg, '1', '0', '0', '5', '5'],
			        ],
			        offset: true,
			    });
			});
			$('.item01').musMoveDragPraxx({
			    motions: [
			        ['.i01', '1', '3', '3', '5', '5'],
			        ['.i02', '1', '6', '6', '5', '2'],
			    ]
			});*/
			var defaults = {
				centerMode: true,
				perspective: 1000,
				motions: [
					// [클래스, 방향, x거리 , y거리 , x축, y축]
				],
				callb: {
					'duration': 0,
					'easing': 'swing',
					'complete': function () {}
				},
				offset: true
			};

			function MusMoveDragParxx($this) {
				var _this = this;
				this.el = $this;
				this.elw = $this.width();
				this.elh = $this.height();
				this.obj = $.extend(true, defaults, obj);
				this.callb = function (callbObj) {
					var extd = $.extend(true, _this.obj.callb, callbObj);
					return extd;
				};
				this.setOffsetX = this.obj.centerMode ? this.el.width() / 2 : 0;
				this.setOffsetY = this.obj.centerMode ? this.el.height() / 2 : 0;
				this.init();
			};
			MusMoveDragParxx.prototype = {
				init: function () {
					this.bind();
				},
				bind: function () {
					var _this = this;
					this.el.off().on({
						'mousemove': function (event) {
							_this.dir(event);
						},
						'mouseleave': function (event) {
							_this.moving2('reset', '', '', event);
						}
					});
				},
				dir: function (event, offsetX) {
					var crtOffsetX = this.obj.offset ? event.offsetX : event.clientX;
					var crtOffsetY = this.obj.offset ? event.offsetY : event.clientY;
					this.moving2('', crtOffsetX, crtOffsetY, event);
				},
				moving: function (direction, crtOffsetX, crtOffsetY) {
					var _this = this;
					var motions = this.obj.motions;
					var transform = null;
					for (var i = 0; i < motions.length; i++) {
						var distance = function () {
							var x = (crtOffsetX - _this.setOffsetX) * (motions[i][2] * 0.01);
							var y = (crtOffsetY - _this.setOffsetY) * (motions[i][3] * 0.01);
							var rx = (crtOffsetX - _this.setOffsetX) * (motions[i][5] * 0.01);
							var ry = -(crtOffsetY - _this.setOffsetY) * (motions[i][4] * 0.01);
							return {
								x: x,
								y: y,
								rx: rx,
								ry: ry
							};
						};
						if (direction == 'reset') {
							$(motions[i][0]).animate({
								'transform': 'translateX(0) translateY(0) rotateX(0) rotateY( 0)'
							}, 500);
							return;
						} else {
							transform = 'translateX(' + distance().x + 'px) translateY(' + distance().y + 'px) rotateX(' + distance().ry + 'deg) rotateY( ' + distance().rx + 'deg)';
						}
						$(motions[i][0]).parent().css('perspective', '1000px');
						$(motions[i][0]).css({
							'transform': transform
						});
						$(motions[i][0]).find('.ppgr_inner').css('pointer-events', 'none');
					}
				},
				moving2: function (direction, crtOffsetX, crtOffsetY, event) {
					var _this = this;
					var motions = this.obj.motions;
					var transform = null;
					var target = {
						centerWidth: this.obj.offset ? event.target.clientWidth / 2 : window.innerWidth / 2,
						centerHeight: this.obj.offset ? event.target.clientHeight / 2 : window.innerHeight / 2
					};
					for (var i = 0; i < motions.length; i++) {
						var distance = function () {
							var x = ((crtOffsetX - target.centerWidth) * -motions[i][2]) / target.centerWidth;
							var y = ((crtOffsetY - target.centerHeight) * -motions[i][3]) / target.centerHeight;
							var rx = ((crtOffsetX - target.centerWidth) * -motions[i][4]) / target.centerWidth;
							var ry = ((crtOffsetY - target.centerHeight) * -motions[i][5]) / target.centerHeight;
							return {
								x: x,
								y: y,
								rx: rx,
								ry: ry
							};
						};
						if (direction == 'reset') {
							$(motions[i][0]).addClass('animate');
							$(motions[i][0]).find('.ppgr_img').addClass('animate');
							$(motions[i][0]).find('.ppgr_inner').addClass('initboxshadow').css({
								'pointer-events': 'inherit'
							});
							return;
						} else {
							transform = 'translateX(' + distance().x + 'px) translateY(' + distance().y + 'px) rotateX(' + distance().ry + 'deg) rotateY( ' + distance().rx + 'deg)';
						}
						$(motions[i][0]).parent().css('perspective', '1000px');
						$(motions[i][0]).removeClass('animate').css({
							'transform': transform
						});
						$(motions[i][0]).find('.ppgr_img').removeClass('animate').css({
							'transform': transform
						});
						$(motions[i][0]).find('.ppgr_inner').removeClass('initboxshadow').css({
							'pointer-events': 'none',
							'box-shadow': '' + -(distance().x * 4) + 'px ' + (distance().y * 2) + 'px 0px rgba(0,0,0,0.05)'
						});
					}
				},
			}
			this.each(function () {
				$.data(this, new MusMoveDragParxx($(this), obj));
			});
			return this;
		},
		fileTreeUpdown: function (obj) {
			var defaults = {
				list: {
					left: '', // ul태그만
					right: '', // ul태그만
				},
				btns: {
					left: '',
					right: '',
				},
				contrBtns: {
					up: '',
					down: '',
					maxUp: '',
					maxDown: '',
				},
				dupChk: false,
				callb: function () {}
			};

			function FileTreeUpdown($this) {
				this.el = $this;
				this.num = 0;
				this.idx = 0;
				this.arry = null;
				this.obj = $.extend(true, defaults, obj);
				this.init();
			};
			FileTreeUpdown.prototype = {
				init: function () {
					this.set();
					this.updown();
					this.bind();
				},
				set: function () {},
				updown: function () {
					var btns = this.obj.contrBtns;
					var _this = this;
					var $target = $(this.obj.list.left + ',' + this.obj.list.right).find('>li');
					$target.off().on({
						'click': function () {
							if ($(this).is('.active')) {
								$(this).removeClass('active');
								return;
							}
							if (!_this.dupChk) {
								$target.removeClass('active');
							}
							$(this).addClass('active');
						},
					});
					this.el.find(btns.up).on({
						'click': function () {
							_this.updownMoving('up');
							return false;
						}
					});
					this.el.find(btns.down).on({
						'click': function () {
							_this.updownMoving('down');
							return false;
						}
					});
					this.el.find(btns.maxUp).on({
						'click': function () {
							_this.updownMoving('maxUp');
							return false;
						}
					});
					this.el.find(btns.maxDown).on({
						'click': function () {
							_this.updownMoving('maxDown');
							return false;
						}
					});
				},
				updownMoving: function (type) {
					var list = this.obj.list;
					var _this = this;
					var $this = null;
					_this.arry = [];
					this.el.find(this.obj.list.left + '>li').each(function () {
						if ($(this).is('.active')) {
							switch (type) {
								case 'up':
									$(this).prev().before($(this));
									break;
								case 'down':
									_this.arry.unshift([$(this), $(this).index()]);
									break;
								case 'maxUp':
									$(_this.obj.list.left).prepend($(this));
									break;
								case 'maxDown':
									$(_this.obj.list.left).append($(this));
									break;
							}
						}
					});
					if (type == 'down') {
						for (var i = 0; i < this.arry.length; i++) {
							this.el.find(this.obj.list.left + '>li:eq(' + (this.arry[i][1] + 1) + ')').after(this.arry[i][0]);
						}
					}
				},
				bind: function () {
					var btns = this.obj.btns;
					var _this = this;
					this.el.find(btns.right + ',' + btns.left).on({
						'click': function (e) {
							_this.moving(e.target);
							return false;
						},
					});
				},
				moving: function (btnType) {
					var lst = this.obj.list;
					if (btnType == $(this.obj.btns.right)[0]) {
						$(lst.left).find('>li').each(function () {
							if ($(this).is('.active')) {
								$(lst.right).append($(this));
							}
						});
					} else {
						$(lst.right).find('>li').each(function () {
							if ($(this).is('.active')) {
								$(lst.left).append($(this));
							}
						});
					}
					if (typeof this.obj.callb === 'function') {
						this.obj.callb();
					}
				},
			};
			this.each(function () {
				$.data(this, new FileTreeUpdown($(this), obj));
			});
			return this;
		},
		customScrollBar: function (obj) {
			/*
			$(target).customScrollBar();
			<div class="target">
			<div>내용내용</div>
			</div>
			*/
			var defaults = {
				scrVal: {
					num: 50,
					callb: {
						'duration': 300,
						'easing': 'easeOutExpo',
						'complete': function () {}
					},
				},
				scrEl: {
					bx: 'scr_wrap',
					el: 'scr_bar',
					btn: 'scr_btn',
				},
				drag: true,
			};

			function CustomScrollBar($this) {
				var _this = this;
				this.el = $this;
				this.scr = {
					outw: $this.outerWidth(),
					scrw: $this[0].clientWidth,
					outh: $this.outerHeight(),
					scrh: $this[0].scrollHeight,
				};
				this.scrClassName = {
					wrap: 'scrWrap',
					btn: 'scrBtn',
					bar: 'scrBar',
				};
				this.html = '';
				this.obj = $.extend(true, defaults, obj);
				this.init();
			};
			CustomScrollBar.prototype = {
				init: function () {
					if (this.scr.outw > this.scr.scrw) {
						this.set();
						this.bind();
					} else {
						this.el.closest('.' + this.scrClassName.wrap).find('.' + this.scrClassName.bar).hide();
					}
				},
				set: function () {
					var $this = this.el;
					this.html = '<div class="' + this.obj.scrEl.el + ' ' + this.scrClassName.bar + '" ><span class="' + this.obj.scrEl.btn + ' ' + this.scrClassName.btn + '"></span></div>';
					var scrBtnHei = (this.scr.outh / this.scr.scrh) * 100;
					$this.closest('.' + this.scrClassName.wrap).find('.' + this.scrClassName.bar).show();
					if (!$this.closest('.' + this.scrClassName.wrap).length) {
						$this.wrap('<div class="' + this.obj.scrEl.bx + ' ' + this.scrClassName.wrap + '" style="width:' + this.scr.outw + 'px; overflow: hidden;"></div>').css({
							'margin-right': -(this.scr.outw - this.scr.scrw),
							'padding-right': this.scr.outw - this.scr.scrw,
							'overflow-x': 'hidden'
						});
						$this.closest('.' + this.scrClassName.wrap).append(this.html);
					}
					$this.closest('.' + this.scrClassName.wrap).find('.' + this.scrClassName.btn).css('height', scrBtnHei + '%');
				},
				bind: function () {
					var _this = this;
					var $this = this.el;
					var $thisWrap = $this.closest('.' + this.scrClassName.wrap);
					var $thisBar = $thisWrap.find('.' + this.scrClassName.bar);
					var $thisBtn = $thisWrap.find('.' + this.scrClassName.btn);
					var vScrVal = 0;
					var scrBarHei = Math.round($thisBar.height() - $thisBtn.height());
					var scrInnerHei = $this.find('>*').height() - $this.height();
					$this.scroll(function (e) {
						var $thisScrTop = $(this).scrollTop();
						var $thisScr = (scrBarHei * $thisScrTop) / scrInnerHei;
						$thisBtn.css('top', $thisScr);
					});
					$thisBtn.mousedown(function () {
						// $(window).scrollTop(0);
					});
					if (this.drag) {
						$thisBtn.draggable({
							scroll: false,
							axis: "y",
							containment: $thisBar[0],
							drag: function () {
								$top = Number($thisBtn.css('top').replace('px', ''));
								vScrVal = Math.round((scrInnerHei * $top) / scrBarHei);
								_this.el.scrollTop(vScrVal);
							},
						});
					}
				},
				drag: function () {
					var _this = this;
				},
			};
			this.each(function () {
				$.data(this, new CustomScrollBar($(this), obj));
			});
			return this;
		},
		swipListBtns: function (obj) {
			var defaults = {
				minDistance: 20,
				maxDistance: 30,
				animatecallb: {
					'duration': 50,
					'easing': 'easeOutExpo',
				}
			};

			function SwipListBtns($this) {
				this.el = $this;
				this.oriEvents = null;
				this.moveObj = {};
				this.obj = $.extend(true, defaults, obj);
				this.clientXArry = [];
				this.movedir = function (dirobj) {
					if (dirobj) {
						return $.extend(true, {
							'start': null,
							'end': null
						}, dirobj);
					}
				};
				this.initNum = 0;
				this.acallb = $.extend(true, {
					'duration': 300,
					'easing': 'easeOutExpo',
					'complete': function () {}
				}, this.obj.animatecallb);
				this.init();
			};
			SwipListBtns.prototype = {
				init: function () {
					this.bind();
				},
				bind: function () {
					var _this = this;
					var distanceStart = null;
					var distanceEnd = null;
					this.el.each(function () {
						$(this).bind({
							'touchstart': function (event) {
								distanceStart = event.originalEvent.changedTouches[0].clientX;
							},
							// 'touchmove': function(event) {
							// var offsetX = event.originalEvent.changedTouches[0].clientX;
							// //if (offsetX > _this.obj.minDistance && offsetX < _this.obj.maxDistance) _this.cnt(offsetX);
							// },
							'touchend': function (event) {
								distanceEnd = event.originalEvent.changedTouches[0].clientX;
								// this.clientXArry = new Array();
								_this.moveSet(distanceStart, distanceEnd);
							},
						});
					});
				},
				moveSet: function (distanceStart, distanceEnd) {
					var movedir = this.movedir({
						'start': distanceStart,
						'end': distanceEnd
					});
					if (Math.abs(movedir.start - movedir.end) > this.obj.minDistance) this.move(movedir);
				},
				move: function (movedir) {
					if (movedir.start > movedir.end) { // 열기
						this.el.stop().animate({
							'transform': 'translateX(-' + this.obj.maxDistance + 'px)'
						}, this.acallb);
					} else { // 닫기
						this.el.stop().animate({
							'transform': 'translateX(0px)'
						}, this.acallb);
					}
				},
			};
			this.each(function () {
				$.data(this, new SwipListBtns($(this), obj));
			});
			return this;
		},
		rowGraph: function (obj) {
			/** 2021 작성 */
			var $wrapping = $(this);
			var _self = null;
			var _label = 'label';
			var _value = 'value';
			var _title = 'title';
			var _obj = {
				barClassName: 'bars',
				keynameLabel: _label,
				keynameValue: _value,
				keynameTitle: _title,
				data: [],
				getDATA: null,
				/*
				data 배열형태, 인덱스요소는 객체 {}
				인덱스요소 [index]['label'], [index]['value']
				*/
				animate: false,
				absolute: false,
				horizental: false
			};

			function RowGraph() {
				_self = this;
				_self.obj = $.extend(true, _obj, obj);
				_label = _self.obj.keynameLabel;
				_value = _self.obj.keynameValue;
				_title = _self.obj.keynameTitle;
				_self._data = _self.set(_self.obj.data);
				_self.sumValue = 0;
				_self.max = Math.max.apply(null, _self._data[1][_value]);
				_self.min = Math.min.apply(null, _self._data[1][_value]);
				_self.returnData = [];
				var _vl = 0;
				if (!_self.obj.absolute) {
					if (Array.prototype.reduce && _self._data[1][_value].length) {
						_self.sumValue = _self._data[1][_value].reduce(function (a, c) {
							return a + c;
						});
					} else {
						for (var i = 0; i < _self._data[1][_value].length; i++) {
							_vl += _self._data[1][_value][i]
						}
						_self.sumValue = _vl;
					}
				} else {
					_self.sumValue = Math.max.apply(null, _self._data[1][_value]);
				}
				_self.init();
				if (typeof _self.obj.getDATA === 'function') {
					_self.obj.getDATA($wrapping, _self.returnData, _self.max, _self.min);
				}
				return _self;
			};
			RowGraph.prototype = {
				init: function () {
					_self.fnAddHTML(_self.getHTML(_self._data));
				},
				set: function (ary) {
					/**
					 * 리턴되는 _array = [{keynameLabel:[]},{keynameValue:[]}]
					 */

					var _array = [{}, {}, {}];
					_array[0][_label] = []; //네임들만 따로 배열묶음
					_array[1][_value] = []; //값들만 따로 배열묶음
					_array[2][_title] = []; //값들만 따로 배열묶음
					if (typeof ary === 'object' && Array.isArray && Array.isArray(ary)) {
						for (var i = 0; i < ary.length; i++) {
							_array[0][_label].push(ary[i][_label]);
							_array[1][_value].push(ary[i][_value]);
							_array[2][_title].push(ary[i][_title]);
						}
					}
					return _array;
				},
				getHTML: function (arry) {
					var html = '';
					var _obj = null;
					_self.returnData = [];
					_self.returnData[0] = [];
					_self.returnData[1] = arry[0];
					_self.returnData[2] = arry[1];
					_self.returnData[3] = {};
					_self.returnData[3]['percent'] = [];
					_self.returnData[4] = {};
					_self.returnData[4]['title'] = [];
					for (var i = 0; i < arry[1][_value].length; i++) {
						_obj = {};
						_obj[_label] = arry[0][_label][i];
						_obj[_value] = arry[1][_value][i];
						_obj[_title] = arry[2][_title][i];
						_obj['percent'] = _self.fnCalcPercent(arry[1][_value][i], _self.sumValue);
						_self.returnData[0].push(_obj);
						_self.returnData[3]['percent'].push(_obj['percent']);
						//arry[i]
						if (_self.obj.horizental) { //가로로 늘어날때
							//html += '<div>'+arry[1][_value][i]+' / '+_self.fnCalcPercent(arry[1][_value][i],_self.max)+'%</div>';
							//html += '<br>';
						} else { //세로로 늘어날때
							//html += '<div>'+arry[0][_label][i]+arry[1][_value][i]+' / '+_self.fnCalcPercent(arry[1][_value][i],_self.max)+'%</div>';
							//html += '<br>';
						}
					}
					return html;
				},
				fnCalcPercent: function (current, max) {
					return Math.ceil(current / max * 100);
					//return current/max*100;
				},
				fnAddHTML: function (html) {
					if (html) {
						$wrapping.empty();
						return $(html).appendTo($wrapping);
					}
					return false;
				}
			};
			this.each(function () {
				$.data(this, new RowGraph($(this), obj));
			});
			return this;
		},
		__cropper: function (obj, callback, blob) {
			var $this = $(this);
			var cropper = null;
			var obj = $.extend(true, {
				aspectRatio: 16 / 9,
			}, obj);
			if (!$.fn.cropper) return false;
			var $image = $this;
			if ($image.is('img') || $image.is('canvas')) {
				cropper = new Cropper($image[0], $.extend(obj, {
					crop: function (event) {
						if (typeof callback === 'function') {
							callback(event);
						}
					}
				}));
			}
			return cropper;
		},
		cmmFileUpload: function (obj, $target) {
			var $this = $target;
			var $input = $this.find('input[type="file"]');
			var classNames = {
				"cmmFileUpload": ".cmmFileUpload",
				"cmmFilesGroup": ".cmmInputFile",
				"previewListItems": ".previewListItems",
				"cmmFilesDelectBtn": ".cmmFilesDelectBtn",
				"cmmFilesAddBtn": ".cmmFilesAddBtn",
			}
			var FileUpload = function (obj) {
				var _this = this;
				this.obj = $.extend(true, {
					preview: true,
					multiple: false,
					itemInAddImages: false,
					sortable: false,
					accept: 'image',
					defaultValue: [],
					afterCallback: null,
					bindUploadImageChange: null,
					size: 200000, //byte
				}, obj);
				if (this.obj.multiple) {
					$input.attr('multiple', true);
				}
				if (this.obj.accept && this.obj.accept !== '*') {
					if (this.obj.accept === 'image') {
						$input.attr('accept', 'image/*');
					} else {
						var _accept = this.obj.accept;
						var split = _accept.split(',');
						var _bool = function (str) {
							return /^\./g.test(str);
						}
						var _v = [];
						var _st = '';
						for (var i = 0; i < split.length; i++) {
							_st = !_bool(split[i]) ? '.' + split[i] : split[i];
							_v.push(_st.replace(/\s/g, ''));
						}
						$input.attr('accept', _v.join(','));
					}
				}
				this.options = {
					sortable: {
						placeholder: "ui-state-highlight",
						update: function (event, ui) {
							var reUploadImageArray = {};
							$this.find(classNames.cmmFilesDelectBtn).each(function () {
								var $count = $(this).data('delectButtonCount');
								reUploadImageArray['IMAGE_COUNT_' + $count] = _this.uploadImageArray['IMAGE_COUNT_' + $count];
							});
							_this.uploadImageArray = reUploadImageArray;
							_this.obj.bindUploadImageChange(_this.uploadImageArray, $target, _this.obj);
						},
					},
				}

				this.defaultValue = this.obj.defaultValue || $input.val() || [];
				this.uploadImageInDelectButtonCount = 0;
				this.uploadImageCount = 0;
				this.uploadImageArray = {};
				this.init();
			}
			FileUpload.prototype = {
				init: function () {
					if (this.defaultValue.length && this.obj.preview) {
						// $this.find(classNames.cmmFilesGroup).html('');
						// this.fnSetNativeImagesPreview($input, this.defaultValue);
					}
					this.isValueCheck($this.find(classNames.cmmFilesGroup));
					this.bind();
				},
				uploadValidator: function (files) {
					var _this = this;
					var isNotImage = false;
					var isOverSize = false;
					var msg = '';
					for (var i = 0; i < files.length; i++) { //확장자검사
						if (_this.obj.accept === 'image' && !/image/g.test(files[i].type)) {
							alert('이미지파일만 업로드 가능합니다.');
							isNotImage = true;
							break;
						}
						if ((_this.obj.size !== false || _this.obj.size !== '*') && files[i].size >= this.obj.size) { //용량검사 2MB
							if ($.__GET_BYTE_FORMAT) {
								msg = $.__GET_BYTE_FORMAT(this.obj.size, false) + '이하만 업로드 가능합니다.';
							} else {
								msg = this.obj.size + 'byte이하만 업로드 가능합니다.';
							}
							alert(msg);
							isOverSize = true;
							break;
						}
					}
					return {
						isNotImage: isNotImage,
						isOverSize: isOverSize,
					};
				},
				bind: function () {
					var _this = this;

					$input.off().on("change", function (event) {

						var files = event.target.files;
						//확장자체크
						_this.defaultValue = files;
						_this.uploadImageInDelectButtonCount = 0; //버튼데이타값들 초기화
						_this.uploadImageCount = 0; //이미지값들 초기화
						_this.uploadImageArray = {}; //이미지값들 초기화
						if (files.length) {
							var uploadValidator = _this.uploadValidator(files);
							if (uploadValidator.isNotImage) return false;
							if (uploadValidator.isOverSize) return false;
							if (_this.obj.preview) {
								//$this.find(classNames.cmmFilesGroup).html('');
								_this.fnSetPreview(event.target, files);
							}
						}
						if (typeof _this.obj.afterCallback === 'function') {
							_this.obj.afterCallback(event.target.files, _this.obj, $(this).closest($this));
						}
					});
					$this.find(classNames.cmmFilesAddBtn).find('input[type="file"]').off().on("change", function (event) {
						var files = event.target.files;
						var isNotImage = false;
						//확장자체크
						_this.defaultValue = files;
						if (files.length) {
							var uploadValidator = _this.uploadValidator(files);
							if (uploadValidator.isNotImage) return false;
							if (uploadValidator.isOverSize) return false;
							if (_this.obj.preview) {
								_this.fnSetPreview(event.target, files);
							}
						}
						if (typeof _this.obj.afterCallback === 'function') {
							_this.obj.afterCallback(event.target.files, _this.obj, $(this).closest($this));
						}
					});
				},
				bindPreviewItems: function () {
					var _this = this;
					$this.find(classNames.cmmFilesDelectBtn).off().on({
						'click': function () {
							var $parent = $(this).closest(classNames.previewListItems);
							var $count = $(this).data('delectButtonCount');
							$parent.remove();
							_this.isValueCheck($this.find(classNames.cmmFilesGroup));
							delete _this.uploadImageArray['IMAGE_COUNT_' + $count];
							if (typeof _this.obj.bindUploadImageChange === 'function') {
								_this.obj.bindUploadImageChange(_this.uploadImageArray, $target, _this.obj);
							}

						}
					});
					$this.find(classNames.cmmFilesAddBtn).off().on({
						'click': function () {
							var $parent = $(this).closest(classNames.previewListItems);
							_this.bind();
						}
					});
				},
				fnSetNativeImagesPreview: function (target, files) { //순수이미지파일로 올때
					var _this = this;
					files.forEach(function (item) {
						_this.fnGetPreview(item);
					});
					this.fnSetPreviewAfterCall(files, files, $(target).closest($this));
				},
				fnSetPreview: function (target, files) { //인풋파일의 file형태로 오는 노드
					var _this = this;
					this.fnFileReader(files, function (fileArray) {
						fileArray.forEach(function (item) {
							_this.fnGetPreview(item.result);
						});
						_this.fnSetPreviewAfterCall(files, fileArray, $(target).closest($this));
					});
				},
				fnSetPreviewAfterCall: function (files, fileReader, $wrapping) {
					var _this = this;
					_this.bindPreviewItems();
					_this.isValueCheck($this.find(classNames.cmmFilesGroup));
					if (_this.obj.sortable === true) {
						if (Object.keys(_this.obj.sortable).length) {
							$this.find(classNames.cmmFilesGroup).sortable($.extend(true, _this.options.sortable, _this.obj.sortable));
							$this.find(classNames.cmmFilesGroup).disableSelection();
						}
					}
					for (var key in files) {
						if (typeof files[key] === 'string' || typeof files[key] === 'object') {
							_this.uploadImageArray['IMAGE_COUNT_' + _this.uploadImageCount] = {
								file: files[key],
								imagePreview: typeof fileReader[key] === 'object' && !Array.isArray(fileReader[key]) ? fileReader[key].result : fileReader[key],
							};
							_this.uploadImageCount++;
						}
					}
					if (typeof this.obj.bindUploadImageChange === 'function') {
						this.obj.bindUploadImageChange(_this.uploadImageArray, $target, _this.obj, $wrapping);
					}
				},
				fnGetPreview: function (url) {
					// var html = '<li class="' + this.clsFormat(classNames.previewListItems) + ' ui-state-default">';
					// html += '<img src="' + url + '" alt=""/>';
					// html += '<a href="javascript:;" data-delect-button-count="' + this.uploadImageInDelectButtonCount + '" class="itemDeleteBtn ' + this.clsFormat(classNames.cmmFilesDelectBtn) + '"><i class="fas fa-times-circle"></i></a>';
					// if (this.obj.itemInAddImages) {
					//     html += '<label class="itemAddBtn ' + this.clsFormat(classNames.cmmFilesAddBtn) + '">이미지추가<input type="file" ' + (this.obj.multiple ? 'multiple' : '') + ' accept="image/*"/></label>';
					// }
					// html += '</li>';
					// $this.find(classNames.cmmFilesGroup).append(html);
					this.uploadImageInDelectButtonCount++;
				},
				fnFileReader: function (files, onloadCallback) {
					var ary = [];
					for (var i = 0; i < files.length; i++) {
						ary.push(new FileReader());
					}
					ary.forEach(function (item, index) {
						item.onloadend = function () {
							if (ary.length - 1 === index) {
								onloadCallback(ary);
							}
						}
						item.readAsDataURL(files[index]);
					});
				},
				isValueCheck: function ($target) {
					return (function () {
						var gubun = 0;
						if ($target[0].nodeName.toLowerCase() === 'input') {
							gubun = $target[0].files.legnth;
						} else {
							gubun = $target.find('>*').length;
						}
						$this.attr('data-images-length', gubun);
						return gubun;
					})();
				},
				clsFormat: function (s) {
					return s.replace(/\./g, '');
				}
			};
			var arg = [];
			this.each(function () {
				arg.push($.data($(this), new FileUpload(obj)));
			});
			return arg;
		}
	});
	$['__TRIM'] = function (str) {
		if (str) {
			if (String.prototype.trim) {
				return str.trim();
			} else {
				return str.replace(/(^\s*)|(\s*$)/g, '');
			}
		}
		return str;
	}
	$['__GET_BYTE_FORMAT'] = function (bytes, origin) {
		var gb = origin ? 1073741824 : 1000000000;
		var mb = origin ? 1048576 : 1000000;
		var kb = origin ? 1024 : 1000;
		if (bytes >= gb) {
			bytes = (bytes / gb).toFixed(2) + " GB";
		} else if (bytes >= mb) {
			bytes = (bytes / mb).toFixed(2) + " MB";
		} else if (bytes >= kb) {
			bytes = (bytes / kb).toFixed(2) + " KB";
		} else if (bytes > 1) {
			bytes = bytes + " bytes";
		} else if (bytes == 1) {
			bytes = bytes + " byte";
		} else {
			bytes = "0 bytes";
		}
		return bytes;
	}
	$['__ALERT'] = function (obj) {
		$('body').append('<span class="cmmAlert"></span>');
		var params = typeof obj === 'string' ? {
			msg: obj
		} : obj;
		$('.cmmAlert').cmmLocLaypop($.extend(true, {
			type: 'alert',
			title: '알림',
			width: 320,
			targetBtnsName: ['확인'],
			msg: '',
			submit: function ($el) {
				$el.cmmLocLaypop('close');
				$el.remove();
			},
			closeCallb: function ($el) {
				$el.cmmLocLaypop('close');
				$el.remove();
			}
		}, params));
	};
	$['__CONFIRM'] = function (obj) {
		$('body').append('<span class="cmmConfirm"></span>');
		var params = typeof obj === 'string' ? {
			msg: obj
		} : obj;
		$('.cmmConfirm').cmmLocLaypop($.extend(true, {
			type: 'confirm',
			title: '알림',
			width: 320,
			targetBtnsName: ['취소', '확인'],
			msg: '',
			submit: function ($el) {
				$el.cmmLocLaypop('close');
				$el.remove();
			},
			closeCallb: function ($el) {
				$el.cmmLocLaypop('close');
				$el.remove();
			}
		}, params));
	};
	$['cmmFullPage'] = {
		_defaults: {
			tar: '',
			section: [],
			sectionCommonName: '',
			scrollCallback: null,
			spacing: 350,
			jump_spacing: 0
		},
		sectionOffset: [],
		scrolltop: 0,
		scrollIdx: 0,
		init: function (obj) {
			var _this = this;
			this.obj = $.extend(true, this._defaults, obj);
			this.obj.anicallb = this.obj.anicallb ? this.obj.anicallb : {};
			this.obj.zoomView = this.obj.zoomView ? this.obj.zoomView : 1;
			this.obj.spacing = this.obj.spacing * this.obj.zoomView;
			this.set();
			this.bind();
			return {
				jump: function (i) {
					_this.set(); //is career
					_this.active(i, true);
				}
			};
		},
		set: function () {
			this.sectionOffset = [];
			for (var i = 0; i < this.obj.section.length; i++) {
				var nt = 0;
				var zoomScr = $(this.obj.section[i])[0].offsetTop * this.obj.zoomView;
				if (zoomScr >= 0) {
					nt = zoomScr;
				}
				if ($(this.obj.section[i]).is(':hidden')) {
					nt = false;
				}
				this.sectionOffset.push(nt);
			}
		},
		bind: function () {
			var _this = this;
			var _fn = function () {
				_this.set();
				_this.scrolltop = $(this).scrollTop();
				for (var i = 0; i < _this.sectionOffset.length; i++) {
					if (_this.sectionOffset[i] !== false) {
						if (_this.scrolltop > _this.sectionOffset[i] - _this.obj.spacing) {
							_this.scrollIdx = i;
						}
					}
				}
				if (($(document).height() * _this.obj.zoomView) - $(window).height() <= _this.scrolltop) {
					_this.scrollIdx = _this.obj.section.length - 1;
				}
				_this.active(_this.scrollIdx);
			}
			$(this.obj.tar).on({
				'click': function (e) {
					e.preventDefault();
					var $this = $(this);
					var $thisIdx = 0;
					if (_this.obj.tarParams) {
						$thisIdx = $this.data(_this.obj.tarParams);
					} else {
						$thisIdx = $this.index();
					}
					_this.active($thisIdx, true);
					return false;
				}
			});
			$(window).smartscroll(_fn);
			//$(window).smartresize(_fn);
			$(window).on({
				'load DOMMouseScroll': function () {
					_fn();
				}
			});
			if (!$(window).scrollTop()) {
				_this.active(0);
			}
		},
		active: function () {
			var _this = this;
			var args = arguments;
			if (args[1]) {
				var aaa = $(document).outerWidth() < 1300 ? _this.obj.jump_spacing - 160 : $(document).outerWidth() > 1300 && $(document).outerWidth() <= 1850 ? _this.obj.jump_spacing - 72 : _this.obj.jump_spacing;
				if (_this.sectionOffset[args[0]] !== false) {
					$('html,body').stop().animate({
						'scrollTop': _this.sectionOffset[args[0]] + aaa
					}, $.extend({}, args[2] || _this.obj.anicallb));
				}
			} else {
				if ($(_this.obj.section[args[0]]).is(':hidden')) return;
				$(_this.obj.tar).removeClass('active');
				$(_this.obj.sectionCommonName).removeClass('active');
				// for (var i = 0; i < _this.obj.section.length; i++) {
				//     $(_this.obj.section[i]).removeClass('active');
				// }
				$(_this.obj.section[args[0]]).addClass('active');
				$(_this.obj.tar + ':eq(' + args[0] + ')').addClass('active');
				if (typeof _this.obj.scrollCallback === 'function') {
					_this.obj.scrollCallback($(_this.obj.tar), _this.scrolltop, args[0], this.sectionOffset);
				}
			}
		}
	}
})(jQuery);
