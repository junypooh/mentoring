function headerClose() {
	$('#gnb ul li, .header-search .search, .header-search .sitemap').removeClass('active');
	$('#wrap').removeClass('dim');
}

function headerOpen() {
	var closebind = function(){
			$('#gnb ul li, .header-search .search, .header-search .sitemap').removeClass('active');
			$('#wrap').removeClass('dim');
			$(window).unbind('click touchstart', closebind);
		}

	$('#gnb > ul > li > a').on('click', function(e){
		e.stopPropagation();
		e.preventDefault();
		var _this = $(this);

		if(!_this.parent().is('.active')){
			headerClose();
			_this.parent().addClass('active').siblings().removeClass('active');
			$(window).bind('click touchstart', closebind);
		}else{
			headerClose();
			_this.parent().removeClass('active');
		}
	});

	$('#gnb, .header-search').bind('click touchstart', function(e){
		e.stopPropagation();
	})
}

function joinForm(){
	$('.board-title, .organization').on('click', function(e){
		if(!$(this).hasClass('active')){
//			$(this).addClass('active').siblings('.board-title').removeClass('active'); // 하나씩만 열릴때
			$(this).addClass('active'); // 클릭한 것 마다 열릴때
		}else{
			$(this).removeClass('active');
		}
		e.preventDefault();
	});
}

function inpSkin(){
	/* radio Skin */
	$(document).on('click','input[type=radio]',function(){
		if($(this).parent().is('.radio-skin')){
			$('input[name="'+this.name+'"]').each(function(){
				$(this).parent().removeClass('checked');
			})
			$(this).parent().addClass('checked')
		}
	})
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
function position_cm(){
	var windowWidth = $(window).width();
	var windowHeight = $(window).height();
	var $obj = $('.layer-pop-wrap');
	var objWidth = $obj.width();
	var objHeight = $obj.height();
	$obj.css({
		'left':(windowWidth/2)-(objWidth/2),
		'top':(windowHeight/2)-(objHeight/2)
	});
}
function popClose(){
	$('.pop-close').on('click', function(){
		$('#wrap').removeClass('dim');
	});
}

function loginFcs(){
	$('.login-box input').on('focusin', function(){
		$(this).parent().addClass('on');
	});
	$('.login-box input').on('focusout', function(){
		$(this).parent().removeClass('on');
	});
}

function tabAction3() {
	var tabWrap = $('.tab-action'),
		tabBtn = tabWrap.find('.tab a, .tab-type2 > li > a'),
		tabCont = $('.tab-action-cont .tab-cont');

	tabBtn.on('click', function(e) {
		e.preventDefault();

		var _this = $(this).parent('li'),
			index = _this.index();

		_this.addClass('active').siblings().removeClass('active');
		tabCont.removeClass('active').eq(index).addClass('active');
	});
}

$(document).ready(function(){
	headerOpen();
	inpSkin();
	joinForm();
	position_cm();
	popClose();
	loginFcs();
	tabAction3();
});




