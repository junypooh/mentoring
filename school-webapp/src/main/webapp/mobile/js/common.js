function inpSkin(){
	/* radio Skin */
	// $(document).on('click','input[type=radio]',function(){
	// 	if($(this).parent().is('.radio-skin')){
	// 		$('input[name="'+this.name+'"]').each(function(){
	// 			$(this).parent().removeClass('checked');
	// 		})
	// 		$(this).parent().addClass('checked')
	// 	}
	// })
	/* checkBox skin */
	$(document).on('click','input[type=checkbox]',function(){
		var _label = $(this).parent();
		if(_label.is('.chk-skin')){
			if(_label.is('.checked')){
				_label.removeClass('checked')
			}else{
				_label.addClass('checked')
			}
		}
	})
}

function loginFcs(){
	$('.login input').on('focusin', function(){
		$(this).parent().addClass('on');
	});
	$('.login input').on('focusout', function(){
		$(this).parent().removeClass('on');
	});
}
function slideMenu(){
	var wrapClass = $('#wrap'),
		 slideWrap = $('#header'),
		 dimWrap = slideWrap.find('.dim'),
		 slideCnt = slideWrap.find('.slide-menu'),
		 slideOpen = slideWrap.find('.btn-slide-menu'),
		 slideClose = slideWrap.find('.slide-menu-close'),
		 winH = $(window).height();

		slideCnt.css('height', winH + 'px');
		dimWrap.css('height', winH + 'px');
		slideOpen.on('click', function(e){
			e.preventDefault();
			$(this).next().addClass('slide-open');
			wrapClass.addClass('wrapHidden');
		});
		slideClose.on('click', function(e){
			e.preventDefault();
			$(this).parent().removeClass('slide-open');
			wrapClass.removeClass('wrapHidden');
		});
}
function btnCheck(){
	$('.btn-check').on('click', function(){
		if ($(this).hasClass('on')) {
			$(this).removeClass('on')
			$(this).find('span').text('off')
		}else{
			$(this).addClass('on')
			$(this).find('span').text('on')
		}
	});
}
function noriceList() {
	var tabBtn = $('.norice-list .title a');

	tabBtn.on('click', function(e) {
		e.preventDefault();
		if(!$(this).parent().hasClass('active')){
			$('.norice-list .title').removeClass('active');
			$(this).parent().addClass('active');

		}else{
			$(this).parent().removeClass('active');
		}
	});
}
$(function(){
	 $(window).scroll(function() {
		var scrT = $(window).scrollTop();
		if(scrT >= 0 && scrT <= 50) {
			$('.cont-quick').css('display','none');
		}else{
			$('.cont-quick').css('display','block');
		}
	 });
});
$(document).ready(function(){
	inpSkin();
	loginFcs();
	slideMenu();
	btnCheck();
	noriceList();
	// if ($('').length > 0){
	// }
});

$(window).resize(function(){
	slideMenu();
});