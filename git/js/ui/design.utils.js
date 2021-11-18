;
(function ($) {
	//$.__CLSFORMAT('.asdf .asdf .asdf')
	//return asdf asdf asdf
	//$.__ARRAY_SHUFFLE([1, 2, 3, 4, 5, 6, 7, 8])
	//return 8
	//$.__ARRAY_SHUFFLE([1, 2, 3, 4, 5, 6, 7, 8])
	//$.__RANDOM(6,8)
	//6이상8미만의 실수;
	//$.__GETPARAMS('tnna')
	//url = absc.com?tnna=123 ==> return 123;
	var utills = '__';
	var utills_array = utills + 'ARRAY_';
	var curDate = new Date();
	var curDateFmt;
	var year = curDate.getFullYear();
	var month = curDate.getMonth() + 1;
	var day = curDate.getDate();
	var hours = curDate.getHours();
	var minutes = curDate.getMinutes();
	var __config = {
		mobile: /iPhone|iPod|iPad|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i,
		ios: /iPhone|iPod|iPad/i,
		android: /Android/i,
	}
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
	$[utills_array + 'SHUFFLE'] = function (a) {
		var va = a;
		var j, x, i;
		for (i = a.length - 1; i > 0; i--) {
			j = Math.floor(Math.random() * (i + 1));
			x = va[i];
			va[i] = va[j];
			va[j] = x;
		}
		return va;
	}
	$[utills + 'GET_YEAR'] = year;
	$[utills + 'GET_MONTH'] = month;
	$[utills + 'GET_DAY'] = day;
	$[utills + 'GET_FULL_DATE'] = year + '' + month + '' + day;
	$[utills + 'GET_HOURS'] = hours;
	$[utills + 'GET_MINUTES'] = minutes;
	$[utills + 'MUTATIONOBSERVER'] = function (callback, t, c) {
		if (!window.MutationObserver && !t && !t.length) return false;
		var config = c || {
			childList: true
		}
		var _constr = new MutationObserver(callback);
		_constr.observe(t, config);
		return _constr;
	};
	$[utills + 'DATEFORMAT'] = function (va, fl) {
		var n = va;
		var _fl = fl ? fl : '.';
		if (typeof n === 'object') {
			return n.toLocaleString('ko-KR');
		} else if (typeof n === 'string' || typeof n === 'number') {
			if (n && /\D/g.test(n)) {
				n = n.replace(/\D/g, '');
			}
			if (n && isNaN(Number(n))) {
				throw '$.__DATEFORMAT params NaN';
			}
			return n.toString().replace(/^(\d{4})(\d{1,2})(\d{1,2})$/g, '$1' + _fl + '$2' + _fl + '$3');
		}
	};
	$[utills + 'COMMAFORMAT'] = function (va) {
		var n = va;
		if (n && /\D/g.test(n)) {
			n = n.replace(/\D/g, '');
		}
		if (n && isNaN(Number(n))) {
			throw '$.__COMMAFORMAT params NaN';
		}
		if (String.toLocaleString) {
			return Number(n).toLocaleString('ko');
		} else {
			return n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
		}
	};
	$[utills + 'CLSFORMAT'] = function (s) {
		return s.replace(/\./g, '');
	};
	$[utills_array + 'LAST'] = function (a) {
		return a[a.length - 1];
	};
	$[utills_array + 'MAX'] = function (a) {
		return Math.max.apply(null, a);
	};
	$[utills_array + 'MIN'] = function (a) {
		return Math.min.apply(null, a);
	};
	$[utills + 'RANDOM'] = function (min, max) {
		return Math.random() * (max - min) + min;
	};
	$[utills + 'NUM_TO_KOREAN'] = function (number, range) {
		var _range = (function (range) {
			var _r = 2;
			if (!isNaN(range)) {
				_r = Number(range);
			}
			return _r;
		})(range);
		var inputFg = number < 0 ? '-' : '';
		var inputNumber = Math.abs(number) < 0 ? false : Math.abs(number);
		var unitWords = ['', '만', '억', '조', '경', '해'];
		var splitUnit = 10000;
		var splitCount = unitWords.length;
		var resultArray = [];
		var resultString = '';
		var resultToStringArray = [];
		var returnValue = '';

		for (var i = 0; i < splitCount; i++) {
			var unitResult = (inputNumber % Math.pow(splitUnit, i + 1)) / Math.pow(splitUnit, i);
			unitResult = Math.floor(unitResult);
			if (unitResult > 0) {
				resultArray[i] = unitResult;
			}
		}
		for (var i = 0; i < resultArray.length; i++) {
			if (!resultArray[i]) continue;
			resultString = String($.__COMMAFORMAT(resultArray[i])) + unitWords[i] + resultString;
			resultToStringArray.unshift(String($.__COMMAFORMAT(resultArray[i])) + unitWords[i]);
		}
		if (!_range) {
			returnValue = resultString;
		} else {
			returnValue = resultToStringArray.slice(0, _range).join('');
		}

		return inputFg + returnValue + '원';
	};
	$[utills + 'GETPARAMS'] = function (param, str, amp, url) {
		var url = url ? url : location.search;
		if (url) {
			var arry = url.split(str ? str : '?');
			var amp = amp ? amp : '&';
			var result = null;
			var arryDp = arry[1].split(amp);
			for (var i = 0; i < arryDp.length; i++) {
				var resArry = arryDp[i].split('=');
				for (var j = 0; j < resArry.length; j++) {
					if (resArry[0] == param) {
						result = resArry[1];
					}
				}
			}
			return result;
		}
	};
	$[utills + 'SCROLL'] = function (b, t, fnc) {
		var t = t ? t : window;
		var events = 'scroll wheel mousemove touchmove';
		if (b) {
			$(t).on(events, function (e) {
				if (typeof fnc === 'function') fnc($(this));
				e.preventDefault();
				e.stopPropagation();
				return false;
			});
		} else {
			$(t).off(events);
		}
	};
	$[utills + 'GET_IP'] = null;
	$[utills + 'GET_BYTE'] = function (str, isEmpty) {
		var byte = 0;
		var leng = 0;
		var str = str;
		var isemp = isEmpty === false ? false : true;
		if (!isemp) {
			str = str.replace(/\s/g, '');
		}
		for (var i = 0; i < str.length; i++) {
			if (escape(str.charAt(i)).length == 6) {
				byte++;
			}
			byte++;
		}
		return {
			byte: byte,
			leng: str.length,
		};
	};

	$[utills + 'ISMOBILE'] = function () {
		var user = navigator.userAgent.toLowerCase();
		var value = false;
		if (user.match(__config.mobile)) {
			value = true;
		}
		return value;
	};
	$[utills + 'DEVICE_CHECK'] = function (str) {
		var _str = '';
		var user = navigator.userAgent.toLowerCase();
		var key = 0;
		var value = false;
		if (str) {
			_str = str.toLowerCase();
			switch (_str) {
				case 'ios':
				case 'iphone':
				case 'ipad':
				case 'ipod':
					key = 'ios'
					break;
				case 'android':
				case 'aos':
					key = 'android'
			}
			if (user.match(__config[key])) {
				value = true;
			}
		}
		return value;
	};
})(jQuery);





/* ob polyfill */
(function () {
	var MutationObserver;
	if (window.MutationObserver != null) {
		return;
	}
	MutationObserver = (function () {
		function MutationObserver(callBack) {
			this.callBack = callBack;
		}
		MutationObserver.prototype.observe = function (element, options) {
			this.element = element;
			return this.interval = setInterval((function (_this) {
				return function () {
					var html;
					html = _this.element.innerHTML;
					if (html !== _this.oldHtml) {
						_this.oldHtml = html;
						return _this.callBack.apply(null);
					}
				};
			})(this), 200);
		};
		MutationObserver.prototype.disconnect = function () {
			return window.clearInterval(this.interval);
		};
		return MutationObserver;
	})();
	window.MutationObserver = MutationObserver;
}).call(this);