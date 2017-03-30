// Avoid `console` errors in browsers that lack a console.
(function() {
    var method;
    var noop = function () {};
    var methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ];
    var length = methods.length;
    var console = (window.console = window.console || {});

    while (length--) {
        method = methods[length];

        // Only stub undefined methods.
        if (!console[method]) {
            console[method] = noop;
        }
    }
}());

function replaceLineBreakHtml(str){
	return str.replace( /[\r\t\n]/g, "<br /> " );
}

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
function upDatePosition(){
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
function position_cm(){
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();
    var $obj = $('.layer-pop-wrap');
    $obj.each(function(index) {
        var _this = $obj.eq(index),
            thisW = _this.width(),
            thisH = _this.height();

        _this.css({
            'left':(windowWidth/2)-(thisW/2),
            'top':(windowHeight/2)-(thisH/2)
        });
    });

    $.fn.layerOpen = function() {
        return this.each(function() {
            var $this  = $(this);
            var $layer = $($this.attr('href') || null);
            $this.click(function(e) {
                e.preventDefault();
                if ($this.parent().hasClass('layer-pop-wrap')) {
                    $('body').addClass('dim_mobile_no');
                } else {
                    $('body').addClass('dim');
                }
                //$('body').css('overflow','hidden');
                $layer.attr('tabindex',0).show().focus();
                $layer.find('.pop-close, .btn-area.popup a.cancel, .btn-area.border a.cancel, .btn-type2.gray, .btn-type1.gray, .layer-close').on('click',function (e) {
                    e.preventDefault();
                    $layer.hide();
                    var layerOpen = true;
                    $('#wrap > .layer-pop-wrap').each(function(index){
                        var $this = $(this).eq(index);
                        if ($this.css('display') == 'block'){
                            layerOpen = false;
                        }
                    });
                    if (layerOpen){
                        $('body').removeClass('dim dim_mobile_no');
                    }
                    //$('body').css('overflow','auto');
                    $this.focus();
                });
            });
        });
    }
    $('.layer-open').layerOpen();
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

function detailTab() {
	var tabBtn = $('.lesson-data-list .title a');
	var tabBtndf = $('.lesson-task .lesson-data-list li .reply-area a');

	tabBtn.on('click', function(e) {
		e.preventDefault();
		if(!$(this).parent().parent().hasClass('active')){
			$('.lesson-data-list li').removeClass('active');
			$(this).parent().parent().addClass('active');

		}else{
			$(this).parent().parent().removeClass('active');
		}
	});
	tabBtndf.on('click', function(e) {
		e.preventDefault();
		if(!$(this).hasClass('active')){
			$('.lesson-task .lesson-data-list li .reply-area a').removeClass('active');
			$(this).addClass('active');

		}else{
			$(this).removeClass('active');
		}
	});
}

function detailTab2() {
	var lessonDetailBtn = $('.board-type2.info table tr td .lesson-cont a');
	lessonDetailBtn.on('click', function(e) {
		if(!$(this).hasClass('active')){
			$('.board-type2.info table tr td .lesson-cont a').removeClass('active');
			$(this).addClass('active');

		}else{
			$(this).removeClass('active');
		}
	});
}

$(document).ready(function(){
	headerOpen();
	inpSkin();
	joinForm();
	position_cm();
	popClose();
	loginFcs();
	detailTab();
	detailTab2();
	tabAction3();
});




