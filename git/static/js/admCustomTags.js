$.fn.extend({
	'admCustomTags': function () {
		var $this = $(this);
		$this.find('.fnDatepicker').datepicker();
		$this.find('.fnAdmFormBoxWrapping').on('change', '[name^="fnAdmFormExposType"]', function () {
			var $this = $(this);
			var $parent = $this.closest('.fnAdmFormWrapping');
			if ($this.val() == '9') {
				$parent.find('.fnAdmFormExposType').addClass('show');
			} else {
				$parent.find('.fnAdmFormExposType').removeClass('show');
			}
		});;
		(function () { //관리자화면 인풋파일 이미지미리보기
			var formWrapping = '.fnThumbPreviewTargetWrapping';
			var $fnAdmFileImageViewWrapping = $this.find('.fnAdmFileImageViewWrapping');
			if (!$fnAdmFileImageViewWrapping.length || !$.fn.cmmFileUpload) return false;
			for (let i = 0; i < $fnAdmFileImageViewWrapping.length; i++) {
				var _$this = $($fnAdmFileImageViewWrapping[i]);
				var _objectParams = _$this.data('objectParams') || {};
				_$this.cmmFileUpload($.extend({
						afterCallback: function (file, obj, $wrapping) {
							var __thumbPreviewCallback = _thumbPreviewCallback($wrapping);
							if (!file.length) {
								$wrapping.find('input[type="text"]').val('선택된 파일이 없습니다.');
								if (__thumbPreviewCallback) {
									__thumbPreviewCallback.restore();
								}
							} else {
								if (file.length > 1) {
									$wrapping.find('input[type="text"]').val(file[0].name + ' (외 ' + (file.length - 1)+')');
								} else {
									$wrapping.find('input[type="text"]').val(file[0].name);

								}
							}
						},
						bindUploadImageChange: function (files, $target, obj, $wrapping) {
							var file = files;
							var fileName = files['IMAGE_COUNT_0'].file.name;
							var imagePreview = files['IMAGE_COUNT_0'].imagePreview;
							var __thumbPreviewCallback = _thumbPreviewCallback($wrapping, imagePreview);
							if (__thumbPreviewCallback) {
								if (imagePreview) {
									__thumbPreviewCallback.init();
								} else {
									__thumbPreviewCallback.restore();
								}
							};
						}
					},
					_objectParams), _$this);

			}

			function _thumbPreviewCallback($wrapping, imagePreview) {
				var params = $wrapping.data('params');
				var _$wrapping = $wrapping.closest(formWrapping);
				var _$thumbTarget = params && params.thumbTarget ? _$wrapping.find(params.thumbTarget) : undefined;
				if (!params) return false;
				return {
					restore: function () {
						_$thumbTarget.find('.fnThumbNodeImg').attr('src', ''); //.hide();
						_$thumbTarget.find('.fnNoResult').show();
						return true;
					},
					init: function () {
						if (_$thumbTarget && _$thumbTarget.length) {
							_$thumbTarget.find('.fnThumbNodeImg').attr('src', imagePreview); //.show();
							_$thumbTarget.find('.fnNoResult').hide();
							return true;
						}
						return false;
					}
				}
			}
		})();;
		(function () { //추가삭제리셋버튼
			var $addButton = $this.find('.fnAdmFormAreaAddButton');
			var $removeButton = $this.find('.fnAdmFormAreaRemoveButton');
			var $restoreButton = $this.find('.fnAdmFormAreaRestoreButton');
			$removeButton.click(function () {
				var $this = $(this);
				var $parent = $this.closest('.fnAdmFormWrapping');
				var _confirm = confirm('삭제하시겠습니까?\n삭제된 데이타는 복구 불가능합니다.');
				if (_confirm) {
					$parent.remove();
				}
				return false;
			});
			$restoreButton.click(function () {
				var $this = $(this);
				var $parent = $this.closest('.fnAdmFormWrapping');
				$parent.find('input,select,img').each(function () {
					var $this = $(this);
					if ($this.is('input')) {
						if ($this.is('[type="checkbox"]') || $this.is('[type="radio"]')) {
							$this.prop('checked', false);
							if ($this.attr('checked')) {
								$this.prop('checked', true);
							}
						} else {
							$this.val('').trigger('change');;
						}
					}
					if ($this.is('select')) {
						$this.val($this.find('option:first').val()).trigger('change');
					}
					if ($this.is('img')) {
						$this.attr('src', '').hide();
						$this.closest('.imgWrap').find('.fnNoResult').show();
					}
				});
				$parent.find('[data-showhide="!"]').removeClass('show');
				$parent.find('[data-showhide="!!"]').removeClass('show');
			});
		})();
		return $this;
	},
});
