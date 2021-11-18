window.Cl = window.Cl || {};

Cl['config'] = function () {
	this.ui = {
		name: {
			inputfile: 'ui-input-file',
			inputdate: 'ui-input-date',
		},
	}
	this.ui['className'] = {}; /*리딩용 작성금지*/
	for (var key in this.ui.name) {
		this.ui['className'][key] = (function (value) {
			return !/^\./.test(value) ? '.' + value : value;
		})(this.ui.name[key]);
	}
	return this;
}
Cl['base'] = function () {
	Cl['config'].call(this);
	this.ui_name = this.ui.name;
	this.ui_className = this.ui.className;
	return this;
}
Cl['base'].prototype = {
	bind_formaddremove : function(){
		var _this = this;
		var _options = _this.formaddremove_options;
		console.log(_options);
	},
	ui_render: function (_element) {
		var _this = this;
		var $this = !_element.context ? $(_element) : _element;
		var ui_name = this.ui_name;
		var className = this.ui_className;
		(function ($inputfile) { // 인풋파일 관련 ui렌더링
			if ($inputfile.length) {
				$inputfile.each(function () {
					var $this = $(this);
					$this.attr('data-ui-name', ui_name.inputfile);
					$this.data('uiName', ui_name.inputfile);
					_this.ui_set($this);
				});
			}
		})($this.is(className.inputfile) ? $this : $this.find(className.inputfile));
		(function ($inputdate) { // 데이트피커 관련 ui렌더링
			if ($inputdate.length) {
				$inputdate.each(function () {
					var $this = $(this);
					$this.attr('data-ui-name', ui_name.inputdate);
					$this.data('uiName', ui_name.inputdate);
					_this.ui_set($this);
				});
			}
		})($this.is(className.inputdate) ? $this : $this.find(className.inputdate));
	},
	ui_set: function (_element) {
		var _this = this;
		var $this = !_element.context ? $(_element) : _element;
		var ui_name = this.ui_name;
		var get_name = $this.data('uiName');
		switch (get_name) {
			case ui_name.inputfile:
				_ui_set_inputfile($this);
				break;
			case ui_name.inputdate:
				_ui_set_inputdate($this);
				break;
		}

		function _ui_set_inputdate($this) { //데이트피커 set
			if ($ && $.fn.datepicker) {
				$this.datepicker({
					dateFormat: 'yy-mm-dd',
					monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
					dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
					dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
					changeMonth: true,
					changeYear: true
				}).prop('readonly', true);
			}
		}

		function _ui_set_inputfile($this) { //인풋파일관련 동적생성 태그
			/* ui생성:S */
			if (!$this.closest('.cmmFileUpload').length) {
				$this.wrap('<div class="cmmFileUpload"></div>');
				$this.wrap('<div class="cmmInputFile"></div>');
				$this.closest('.cmmFileUpload').append('<input type="text" class="read-input" placeholder="" readonly /><span class="btn">파일찾기</span>');
			}
			var $cmmFileUpload = $this.closest('.cmmFileUpload');
			var $input_text = $cmmFileUpload.find('input[type="text"].read-input');
			var $input_file = $this;
			$input_file.off().on('change', function (e) {
				console.log('change몇번?');
				var $this = $(this);
				var files = e.target.files;
				set_value(files);
			});
			set_value($input_file[0].defaultValue);

			function set_value(value) {
				var _s = '';
				var mx_ln = 3;
				if (typeof value === 'object') {
					if (value.length) {
						for (var i = 0; i < value.length; i++) {
							var fl = '';
							var ot = '';
							var _v = value[i].name;
							if (i) {
								fl = ',';
							}
							if (i >= mx_ln) {
								fl = '';
								_v = '';
								ot = '..[외 ' + (value.length - mx_ln) + '개]';
							}
							_s += fl + _v + ot;
							if (!_v) {
								break;
							}
						}
					} else {
						_s += '선택된 파일이 없습니다.';
					}
				} else {
					_s += value;
				}
				$input_text.val(_s);
			}
			/* ui생성:E */
		}

		return {
			_ui_set_inputfile: _ui_set_inputfile,
		}
	}
};