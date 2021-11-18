window.digFunArry = [];
$.fn.extend({
	'customTags': function ($parent) {
		var $this = $parent || $(this);
		var user = navigator.userAgent;
		var userArray = [
			['ie ie8', user.indexOf('MSIE 8.0') != -1],
			['ie ie9', user.indexOf('MSIE 9.0') != -1],
			['ie ie10', user.indexOf('MSIE 10.0') != -1],
			['ie ie11', user.indexOf('rv:11.0') != -1],
			['android', user.indexOf('Android') != -1],
			['iphone', user.indexOf('iPhone') != -1],
			['mobile', user.indexOf('Mobile') != -1],
			['pc', user.indexOf('Windows') != -1],
		];
		if (!$this.find('html').is('[class^="ie"]')) {
			for (var i = 0; i < userArray.length; i++) {
				if (userArray[i] && userArray[i][1]) {
					$this.find('html').addClass(userArray[i][0]);
					continue;
				}
			}
		};;
		(function () {
			var $slideTarget = $this.find('.fnSlideArea');
			var params = $slideTarget.data('params');
			if ($.fn.uiSwiper && $slideTarget.length) {
				(function () {
					if (params && params.slidesToShow) {
						var slideToShow = params.slidesToShow;
						var $tp = $slideTarget.find('>*');
						if ($tp.length <= slideToShow) {
							$slideTarget.addClass('slick_lams');
						}
					}
				})();
				$slideTarget.uiSwiper({
					slideObj: $.extend(true, {}, params)
				});
			}
		})();
		$this.find('.fnInnerScrollSearchColsResult').not('.mCustomScrollbar').cmmInnerScroll();
		$this.find('.fnSearchColsHeightExtend').off().on('click', function () { //검색영역에서 펼쳐보기
			var $this = $(this);
			var $parent = $this.closest('.jcjtSearchDivision');
			var $target = $parent.find('.fnInnerScrollSearchColsResult');
			$target.toggleClass('extend');
			$this.dataToggleClass();
		});;
		(function () {
			var $input = $this.find('.fnAutoSearchInput');
			var $autoBox = $this.find('.cmmAutoSearchWrap');
			var $compBtn = $autoBox.find('.compBtn, .fnAutoSearchCloseButton');
			$input.on({
				'focus': function () {
					var $wrapping = $(this).closest('.csaTp').length ? $(this).closest('.csaTp') : $(this).closest('.cmmAutoSearchWrap.tp2');
					var $resultBox = $wrapping.find('.fnSelEducatShowHide');
					$resultBox.addClass('showHideOn');
					$wrapping.addClass('active');
				}
			});
			$compBtn.off().on('click', function () {
				var $wrapping = $(this).closest('.csaTp').length ? $(this).closest('.csaTp') : $(this).closest('.cmmAutoSearchWrap.tp2');
				var $resultBox = $(this).closest('.cmmAutoSearchResult');
				$resultBox.removeClass('showHideOn');
				$wrapping.removeClass('active');
			});
			$this.click(function (e) {
				if (!$(e.target).closest('.appAutoSearchTarget') && !$(e.target).closest('.fnAppendAutoSearchTemplate')) { //
					$('.cmmAutoSearchResult').removeClass('showHideOn')
					$('.cmmAutoSearchWrap.tp2').removeClass('active')
				}
			});
		})();
		$(window).on('load scroll', function () {
			if ($(this).scrollTop() > 0) {
				$('.ftTopbt').addClass('active');
			} else {
				$('.ftTopbt').removeClass('active');
			}
		});;
		(function () {
			if (!$this.find('.sub_visual .brdPages').length) {
				var $dp1 = $this.find('.gnbArea .gnb>.lst>.tp.active>.txt');
				var $dp2 = $dp1.find('.dtpd .stp.active .txt');
				var html = [
					'<div class="brdPages">',
					'	<div class="innerWrap">',
					'		<div class="lst">',
					'			<div class="tp">',
					'				<a href="/" class="txt home">홈</a>',
					'			</div>',
					(
						$dp1.length ?
						'			<div class="tp">' +
						'				<a href="' + $dp1.attr('href') + '" class="txt">' + $dp1.text() + '</a>' +
						'			</div>' :
						''
					),
					(
						$dp2.length ?
						'			<div class="tp">' +
						'				<a href="' + $dp2.attr('href') + '" class="txt">' + $dp2.text() + '</a>' +
						'			</div>' :
						''
					),
					'		</div>',
					'	</div>',
					'</div>',
				].join('');
				$this.find('.sub_visual').append(html);
			}
		})();
		return $this;
	},
});