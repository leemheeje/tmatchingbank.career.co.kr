
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
