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
/*
 * yyyyMMdd 날짜문자열을 gubun으로 포맷을 변경
 */
function to_date_format(date_str, gubun)
{
    var yyyyMMdd = String(date_str);
    var sYear = yyyyMMdd.substring(0,4);
    var sMonth = yyyyMMdd.substring(4,6);
    var sDate = yyyyMMdd.substring(6,8);

    return sYear + gubun + sMonth + gubun + sDate;
}

/*
 * hh24mi 시간문자열을 gubun으로 포맷을 변경
 */
function to_time_format(time_str, gubun)
{
    var time = String(time_str);
    var hh = time.substring(0,2);
    var mm = time.substring(2,4);
    return hh + gubun + mm;
}

function replaceLineBreakHtml(str){
    if(str == null || str == "") {
        return '';
    } else {
	    return str.replace( /[\r\t\n]/g, "<br /> " );
    }
}

function headerClose() {
    $('#gnb ul li, .header-search .search, .header-search .sitemap').removeClass('active');
    $('body').removeClass('dim');
    $('.sitemap-wrap > li').removeClass('active');
    $('.header-search div.sitemap').css('display', '');
}

function headerOpen() {
    var closebind = function(){
            $('#gnb ul li, .header-search .search, .header-search .sitemap').removeClass('active');
            $('body').removeClass('dim');
            $('.header-search div.sitemap').css('display', '');
            $(window).unbind('click touchstart', closebind);
            $('.selectbox-zindex-box').css('display', 'none'); /* pom */
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
    $('.sitemap-wrap > li > em > a').on('click', function(e){
        e.stopPropagation();
        e.preventDefault();
        var _this = $(this);

        if(!_this.parent().parent().is('.active')){
            _this.parent().parent().addClass('active').siblings().removeClass('active');
            $(window).bind('click touchstart', closebind);
        }else{
            headerClose();
            _this.parent().parent().removeClass('active');
        }
    });

	$('.header-search .search, .organization').on('click', function(e){
		e.stopPropagation();
		e.preventDefault();
		var _this = $(this);

        if(!_this.is('.active')){
            headerClose();
            _this.addClass('active');
            $(window).bind('click touchstart', closebind);
        }else{
            headerClose();
            _this.removeClass('active');
        }
    });


    $('.header-search a.sitemap').on('click', function(e){
		e.stopPropagation();
		e.preventDefault();
		var _this = $(this);

		if(!_this.is('.active')){
			headerClose();
			_this.addClass('active').parent().parent().find('#gnb').css('display', 'block');
			//$('#wrap').addClass('dim');
			$(window).bind('click touchstart', closebind);
			$('.selectbox-zindex-box').css('display', 'block');/* pom */
			$('#gnb').addClass('mgnb');
			$('.top-util').css('display', 'block');
		}else{
			headerClose();
			_this.removeClass('active').parent().parent().find('#gnb').css('display', '');
			$('.selectbox-zindex-box').css('display', 'none'); /* pom */
			$('.header-search a.sitemap').text('사이트맵 열기');
			//$('#wrap').removeClass('dim');
			$('.top-util').css('display', '');
		}
	});



    $('#gnb, .header-search').bind('click touchstart', function(e){
        e.stopPropagation();
    })
}


function tabAction() {
    var tabWrap = $('.tab'),
         tabBtn = tabWrap.find(".tab-ul>li>a"),
         tabCont = $('.tab-action-cont .tab-cont');

    tabBtn.on('click', function(e) {
        e.preventDefault();
        var _this = $(this).parent('li'),
             index = _this.index();
        _this.addClass('on').siblings().removeClass('on');
        _this.next('.tab-cont').removeClass('on').addClass('on');
        $(".ellipsis").trigger("update");
    });
}

function detailTab() {
    var tabBtn = $('.lesson-data-list .title a');

    tabBtn.on('click', lessonDataListClick);
}
function lessonDataListClick(e) {
    //debugger
    e.preventDefault();
    if(!$(this).parent().hasClass('active')){
        $('.lesson-data-list .title').removeClass('active');
        $(this).parent().addClass('active');

    }else{
        $(this).parent().removeClass('active');
    }
}

function detailTab2() {
    var tabBtn = $('.community-data-list .title a');

    tabBtn.on('click', function(e) {
        e.preventDefault();
        if(!$(this).parent().hasClass('active')){
            $('.community-data-list .title').removeClass('active');
            $(this).parent().addClass('active');

        }else{
            $(this).parent().removeClass('active');
        }
    });
}
function memClass() {
    var selectBtn = $('.choice-box > ul > li > a, .my_interest ul li a.set-up');

    selectBtn.on('click', function(e) {
        e.preventDefault();
        if(!$(this).hasClass('active')){
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(this).addClass('active');

        }else{
            $(this).removeClass('active');
        }
    });

}
function starLayer() {
	var tabBtn = $('.give-grade .star-view a');

	tabBtn.on('click', function(e) {
		e.preventDefault();
		if(!$(this).parent().hasClass('active')){
			$(this).parent().addClass('active');
			$('#container .content.sub').css('padding-bottom','130px');

		}else{
			$(this).parent().removeClass('active');
			$('#container .content.sub').css('padding-bottom','50px');
		}
	});
}
function commentLayer() {
    var tabBtn = $('.comment a.num');

    tabBtn.on('click', function(e) {
        e.preventDefault();
        if(!$(this).hasClass('active')){
            $(this).addClass('active');

        }else{
            $(this).removeClass('active');
        }
    });
}

function mainSlide(slideId, showNum) {
    var slideWrap = $("#"+slideId),
         list=slideWrap.find(".my-lesson-list"),
         show_num=showNum,
         num=0,
         total=$(">li",list).size(),
         li_width=$("li:first",list).width(),
         btnPrev = slideWrap.find(".prev"),
         btnNext = slideWrap.find(".next");
    if(total > showNum){
        var copyObj=$(">li:lt("+show_num+")",list).clone();
        list.append(copyObj);
    }
    if(total <= showNum){
        btnPrev.hide();
        btnNext.hide();
    }

    btnNext.unbind("click").on("click",function(){
        console.log("mainSlide click");
        if(num==total){
            num=0;
            list.css("margin-left",num);
        }
        num++;
        list.stop().animate({marginLeft:-li_width*num+"px"},500)
        return false;
    });

    btnPrev.unbind("click").on("click",function(){
        if(num==0){
            num=total;
            list.css("margin-left",-num*li_width+"px");
        }
        num--;
        list.stop().animate({marginLeft:-li_width*num+"px"},500);
        return false;
    });
}
function mentoSlide(mentoId, mentoPd, wlenth){
    var slWrap = $('.'+mentoId),
         slUl = slWrap.find('.slide-list-wrap > ul'),
         slUlMl = parseInt(slWrap.css('margin-left')),
         slli = slUl.find('> li > ul > li'),
         slliMl = slUl.find('> li '),
         index = 0,
         nextB = slWrap.find('.next'),
         prevB = slWrap.find('.prev');
    if(slliMl.length <= wlenth){//표시해야 할 페이지가 1개 이하면 버튼 숨김
        nextB.hide();
    }

        slUl.css('width', slli.length * slliMl.width());
        nextB.click(function(){
            if (!slUl.is(':animated')){
                if (index < slliMl.length){
                    index = index + 1;
                }
                prevB.css('display', 'block')
                slUl.animate({'margin-left': (slliMl.width() + mentoPd) * -index}, 500)
                if (index == (slliMl.length - wlenth)){
                    nextB.css('display','none');
                }
            }
        });
        prevB.click(function(){
            if (!slUl.is(':animated')){
                if (index > 0){
                    index = index - 1;
                }

                nextB.css('display','');
                slUl.animate({'margin-left':  (slliMl.width() + mentoPd) * -index}, 500)
                if (index == 0){
                    prevB.css('display','none');
                }
            }
        });
}


function videoSlide() {
    var vSlideWrap = $('.content-movie'),
         list = vSlideWrap.find('.movie-gallery'),
         show_num=1,
         num=1,
         total=$(">li",list).size(),
         li_width=$("li:first",list).width(),
         btnPrev = vSlideWrap.find(".movie-prev"),
         btnNext = vSlideWrap.find(".movie-next"),
         pagingDot = vSlideWrap.find('.paging-dot span'),
         copyObj=$(">li:last",list).clone();
         //list.prepend(copyObj);

    list.css("margin-left",-li_width+'px');
    btnNext.on("click",function(){
        if(num==total){
            num=0;
            list.css("margin-left",num);
        }
        num++;
        list.stop().animate({marginLeft:-li_width*num+"px"},500)
        pagingDot.removeClass('active').eq(num-1).addClass('active');
        return false;
    });

    btnPrev.on("click",function(){
        if(num==total){
            num=4;
            list.css("margin-left",li_width*-num+"px");
        }
        num--;
        list.stop().animate({marginLeft:li_width*-num+"px"},500);
        pagingDot.removeClass('active').eq(num-1).addClass('active');
        return false;
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

function fixedTab() {
    var headerH = $('#header').outerHeight(true),
        locationH = $('.location').outerHeight(true),
        titleH = $('.content > h2').outerHeight(true),
        infoH = $('.detail-info').outerHeight(true),
        moveH = headerH + locationH + titleH + infoH,
        wrapScrollTop = $(document).scrollTop();

    if (wrapScrollTop >= moveH){
        $('.anchor-tab-area').css('height', $('.move-bar > .tab-type1').outerHeight(true) + 'px');
        $('.move-bar').addClass('fixed').css('top', '0');
    } else {
        $('.anchor-tab-area').css('height', '');
        $('.move-bar').removeClass('fixed').css('top', '');
    }
}



function sdiSubNavi() {
    var naviWrap = $('.move-bar .tab-type1'),
        naviList = naviWrap.find('li'),
        naviBtn = naviWrap.find('li > a'),
        naviTopH,
        naviH,
        scrollTopNumber,
        naviContH;

    naviBtn.on('click', function(e){
        e.preventDefault();

        var _this = $(this),
            thisIndex = _this.parent('li').index(),
            headerH = $('#header').outerHeight(true),
            locationH = $('.location').outerHeight(true),
            titleH = $('.content > h2').outerHeight(true),
            infoH = $('.detail-info').outerHeight(true),
            anchorTabH = $('.anchor-tab-area').outerHeight(true);

        naviTopH = headerH + locationH + titleH + infoH + anchorTabH;

        /*switch(thisIndex) {
            case 0 :
                $(document).scrollTop(naviTopH);
                fixedTab();
                naviH = $('.move-bar').outerHeight(true);
                scrollTopNumber = $(document).scrollTop() - naviH;
                $(document).scrollTop(scrollTopNumber);
                break;
            case 1 :
                naviContH = $('.navi-content').eq(0).outerHeight();
                $(document).scrollTop(naviTopH + naviContH);
                fixedTab();
                naviH = $('.move-bar').outerHeight(true);
                scrollTopNumber = $(document).scrollTop() - naviH;
                $(document).scrollTop(scrollTopNumber);
                break;
            case 2 :
                naviContH = $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight();
                $(document).scrollTop(naviTopH + naviContH);
                fixedTab();
                naviH = $('.move-bar').outerHeight(true);
                scrollTopNumber = $(document).scrollTop() - naviH;
                $(document).scrollTop(scrollTopNumber);
                break;
            case 3 :
                naviContH = $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight();
                $(document).scrollTop(naviTopH + naviContH);
                fixedTab();
                naviH = $('.move-bar').outerHeight(true);
                scrollTopNumber = $(document).scrollTop() - naviH;
                $(document).scrollTop(scrollTopNumber);
                break;
            case 4 :
                naviContH = $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight() + $('.navi-content').eq(3).outerHeight();
                $(document).scrollTop(naviTopH + naviContH);
                fixedTab();
                naviH = $('.move-bar').outerHeight(true);
                scrollTopNumber = $(document).scrollTop() - naviH;
                $(document).scrollTop(scrollTopNumber);
                break;
            case 5 :
                naviContH = $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight() + $('.navi-content').eq(3).outerHeight() + $('.navi-content').eq(4).outerHeight();
                $(document).scrollTop(naviTopH + naviContH);
                fixedTab();
                naviH = $('.move-bar').outerHeight(true);
                scrollTopNumber = $(document).scrollTop() - naviH;
                $(document).scrollTop(scrollTopNumber);
                break;
            default :
                break;
        }*/
    });

    /*$(document).on('scroll', function(){
        var wrapScroll = $(document).scrollTop();
            headerH = $('#header').outerHeight(true),
            locationH = $('.location').outerHeight(true),
            titleH = $('.content > h2').outerHeight(true),
            infoH = $('.detail-info').outerHeight(true),
            anchorTabH = $('.anchor-tab-area').outerHeight(true),
            naviH = $('.move-bar').outerHeight(true);

        naviTopH = headerH + locationH + titleH + infoH + anchorTabH - naviH;
        naviList.removeClass('active');
        if(wrapScroll < naviTopH + $('.navi-content').eq(0).outerHeight()){
            naviList.eq(0).addClass('active');
        }else if(wrapScroll < naviTopH + $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight()){
            naviList.eq(1).addClass('active');
        }else if(wrapScroll < naviTopH + $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight()){
            naviList.eq(2).addClass('active');
        }else if(wrapScroll < naviTopH + $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight() + $('.navi-content').eq(3).outerHeight()){
            naviList.eq(3).addClass('active');
        }else if(wrapScroll < naviTopH + $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight() + $('.navi-content').eq(3).outerHeight() + $('.navi-content').eq(4).outerHeight()){
            naviList.eq(4).addClass('active');
        }else if(wrapScroll < naviTopH + $('.navi-content').eq(0).outerHeight() + $('.navi-content').eq(1).outerHeight() + $('.navi-content').eq(2).outerHeight() + $('.navi-content').eq(3).outerHeight() + $('.navi-content').eq(4).outerHeight() + $('.navi-content').eq(5).outerHeight()){
            naviList.eq(5).addClass('active');
        }
    });*/
}

function accordionList (){
    var accoWrap = $('.writing-list'),
         accoCont = accoWrap.find('.subject-info');


    accoCont.on('click',function(){
        var _this = $(this);
        if(_this.parent().hasClass('active')){
            _this.parent().removeClass('active');
        }else{
            _this.parent().addClass('active').siblings().removeClass('active');
        }

    });
}

function accordionList2 (){
    var accoWrap = $('.user-guide-list'),
         accoCont = accoWrap.find('li > a');


    accoCont.on('click',function(e){
        e.preventDefault();
        var _this = $(this);
        if(_this.parent().hasClass('on')){
            _this.parent().removeClass('on');
        }else{
            _this.parent().addClass('on').siblings().removeClass('on');
        }

    });
}

function connectionLesson (){
    var connecTion = $('.lesson-connection a.view');

    connecTion.on('click',function(e){
        e.preventDefault();

        var _this = $(this);
        if(!_this.hasClass('active')){
            $('.lesson-connection a.view').removeClass('active');
            _this.addClass('active');
        }else{
            _this.removeClass('active');
        }

    });
}


function updatePosition(){
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();
    var $obj = $('.layer-pop-wrap');
    var objWidth = $obj.width();
    var objHeight = $obj.height();
    $obj.css({
        'left':Math.max((windowWidth/2)-(objWidth/2),0),
        'top':Math.max((windowHeight/2)-(objHeight/2),0)
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
                if ($this.hasClass('m-none')) {
                    $('body').addClass('dim_mobile_no');
                } else {
                    $('body').addClass('dim');
                }
                //$('body').css('overflow','hidden');
                $('.selectbox-zindex-box').css('display', 'block');
                $layer.attr('tabindex',0).show().focus();
                $layer.find('.layer-close, .btn-area.popup a.cancel, .btn-area.border a.cancel').on('click',function (e) {
                    e.preventDefault();
                    if($layer){
                        $layer.find("select option:first-child").attr('selected','selected');
                        $layer.find("input[type='text']").val("");
                        $layer.find('input:radio[name=jobRadio]:nth(0)').click();
                        $layer.find('input:radio[name=mentorRadio]:nth(0)').click();
                        $layer.find('input:radio[name=solutionRadio]:nth(0)').click();
                        if($layer.find('input:radio[name=jobRadio]').length > 0)
                            $layer.find('#targtJobNm').text('');
                        if($layer.find('input:radio[name=mentorRadio]').length > 0)
                        $layer.find('#targtMentorNm').text('');

                        $layer.find("textarea").val("");
                        $layer.find(".wish-dat:gt(0)").remove();
                    }
                    $layer.hide();

                    $('.selectbox-zindex-box').css('display', 'none');
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

    $.fn.layerOpenstar = function() {
        return this.each(function() {
            var $this  = $(this);
            $this.click(function(e) {
                e.preventDefault();
                $('body').removeClass('dim');

            });
        });
    }
    $('.layer-open.mobile').layerOpenstar();
}



function mobilePopupH(){
    var windowW = $(window).width(),
        windowH = $(window).height(),
        popupWrap = $('.layer-pop-wrap');

    if (windowW <= 767){
        popupWrap.css('height', windowH + 'px');
    } else {
        popupWrap.css('height', '');
    }

}
function tabAction2() {
   var tabWrap = $('.tab-action'),
      tabBtn = tabWrap.find('.tab-type1 a, .tab-type2 > li > a'),
      tabCont = $('.tab-action-cont .tab-cont');

   tabBtn.on('click', function(e) {
      e.preventDefault();

      var _this = $(this).parent('li'),
         index = _this.index();

      _this.addClass('active').siblings().removeClass('active');
      //tabCont.removeClass('active').eq(index).addClass('active');
      mentor._callbackTabClick($(this).parents("li:first").index());
   });
}

function tabAction3() {
    var tabWrap = $('.tab-action'),
        tabBtn = tabWrap.find('.tab-type1 a, .tab-type2 > li > a'),
        tabCont = $('.tab-action-cont .tab-cont');

    tabBtn.on('click', function(e) {
        e.preventDefault();

        var _this = $(this).parent('li'),
            index = _this.index();

        _this.addClass('active').siblings().removeClass('active');
        tabCont.removeClass('active').eq(index).addClass('active');
    });
}

function mobilePopupstar(){
    var windowWq = $(window).width();
        popupWradfp = $('.star-score');

    if (windowWq <= 767){
        popupWradfp.removeClass('mobile-popup-view');
    } else{
        popupWradfp.addClass('mobile-popup-view');
    }

}

function PopupmyClassReg(){
    var windowWw = $(window).width();
        popupNone = $('.layer-pop-wrap.my-class-reg');

    $('.layer-open.mobile-none').on('click', function(){
        if (windowWw <= 767){
            if(popupNone.css('display') != 'block'){
                $('body').removeClass('dim');
            }else{
                $('body').addClass('dim');
            }
        }
    });
}

function loginFcs(){
    $('.login-box input').on('focusin', function(){
        $(this).parent().parent().addClass('on');
    });
    $('.login-box input').on('focusout', function(){
        $(this).parent().parent().removeClass('on');
    });
}

function inpSkin(){
	/* radio Skin */

	/*
	$(document).on('click','input[type=radio]',function(){
		if($(this).parent().is('.radio-skin')){
			$('input[name="'+this.name+'"]').each(function(){
				$(this).parent().removeClass('checked');
			})
			$(this).parent().addClass('checked')
		}
	})
	$('input[type=radio]').on('focus', function() {
		$(this).parent().addClass('focus-radio');
		$('head').append('<style id="radioStyle">label.focus-radio:after {background-color:transparent;}</style>');
	});
	$('input[type=radio]').on('blur', function() {
		$(this).parent().removeClass('focus-radio');
		$('#radioStyle').remove();
	});
	*/

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
	$('input[type=checkbox]').on('focus', function() {
		$(this).parent().addClass('focus-check');
		$('head').append('<style id="checkStyle">label.focus-check:after {background-color:transparent;}</style>');
	});
	$('input[type=checkbox]').on('blur', function() {
		$(this).parent().removeClass('focus-check');
		$('#checkStyle').remove();
	});
}

function lessonDetailLayer(){
    $(".info-btn").on('focusin', function(){
        $(this).next('.info-layer').css("display","block");
    });
    $(".info-btn").on('focusout', function(){
        $(this).next('.info-layer').css("display","none");
    });
}

function joinForm(){
    $('.id-pw-search .board-title').on('click', function(e){
        if(!$(this).hasClass('active')){
//			$(this).addClass('active').siblings('.board-title').removeClass('active'); // 하나씩만 열릴때
            $(this).addClass('active'); // 클릭한 것 마다 열릴때
        }else{
            $(this).removeClass('active');
        }
        e.preventDefault();
    });
}


function myLessonLayer() {/* 2015-11-16 수정 */
    var dateOpen = $('.my-lesson-list span.lesson-time');
        //dateClose = $('.date-open a.close');

    dateOpen.on('click', function(e) {
        e.preventDefault();
        if(!$(this).hasClass('active')){
            $('.my-lesson-list span.lesson-time').removeClass('active');
            $(this).addClass('active');
            $('.content.sub').css('overflow','inherit');
            //dateOpen.parent().siblings('a').css('display','none');
        }else{
            $(this).removeClass('active');
            $('.content.sub').css('overflow','hidden');
        }
    });

     $('.date-open a.close').on('click', function(e) {
        e.preventDefault();
        $(this).parent().siblings('.lesson-time').removeClass('active');
    });

}

function liveLesson() {
    var llWrap = $('.live-lesson'),
        llUl = llWrap.find('ul'),
        llList = llUl.find('li'),
        listHeight = llList.outerHeight(),
        listLength = llList.length,
        upBtn = llWrap.find('.up'),
        downBtn = llWrap.find('.down');

    llList.css('top','100%').eq(0).addClass('active').css('top','0').next().css('top', listHeight).next().css('top', 2 * listHeight);

    if (listLength == 1){
        // noticeWrap.find('.footer-notice-control').css('display', 'none');
    } else {
        llList.eq(0).clone().appendTo(llUl).removeClass('active').css('top','100%');
        llList.eq(listLength - 1).clone().prependTo(llUl).css('top',-listHeight);
    }

    upBtn.on('click', function(e) {
        e.preventDefault();
        var cloneList = llUl.find('li');
        if (!llUl.find('.active').is(':animated')){
            llUl.find('.active').stop().animate({
                'top' : -listHeight
            }, 500).removeClass('active').next().stop().animate({
                'top' : '0'
            }, 500).addClass('active').next().stop().animate({
                'top' : listHeight
            }, 500).next().stop().animate({
                'top' : 2 * listHeight
            }, 500);

            llUl.find('.active').clone().appendTo(llUl).css('top', '100%').removeClass('active');
            cloneList.eq(0).remove();
        }

    });

    downBtn.on('click', function(e) {
        e.preventDefault();
        var cloneList = llUl.find('li');
        if (!llUl.find('.active').is(':animated')){
            listLength = cloneList.length;
            llUl.find('.active').stop().animate({
                'top' : listHeight
            }, 500).removeClass('active').prev().stop().animate({
                'top' : '0'
            }, 500).addClass('active').next().next().stop().animate({
                'top' : 2 * listHeight
            }, 500).next().stop().animate({
                'top' : '100%'
            }, 500);

            llUl.find('.active').next().next().clone().prependTo(llUl).css('top',-listHeight).removeClass('active');
            cloneList.eq(listLength - 1).remove();
        }
    });
}

function myCommunity() {
	var myCom = $('.my-community-wrap'),
		 myLi = myCom.find('li'),
		 myTarget = myLi.find(' > a'),
		 myHeight = myCom.find('.mypage-wrap').height(),
		 myTarget2 = myCom.find('.title > a, .subject-info, .comment .num, .btn-more-view a'),
		 thismyHeight;

	thismyHeight = myCom.find('.active .mypage-wrap').height();
	myCom.css('padding-bottom', thismyHeight + 19 + 'px' );
	/*
	myTarget.on('click', function(e){
		e.preventDefault();
		var _this = $(this),
			 winW = $(window).width();

		if (winW <=768){
			if (_this.parent().hasClass('active')) {
				if (_this.parent().hasClass('m-active')){
					_this.parent().removeClass('active')
				} else {
					_this.parent().addClass('active')
				}
			}else{
			 	_this.parent().addClass('active').siblings().removeClass('active')
			}
		}else{
		 	_this.parent().addClass('active').siblings().removeClass('active')
		}
		_this.parents('.my-community-wrap').css('padding-bottom', _this.next().height() + 19 + 'px' )
	});*/
	myTarget2.on('click', function(){
		var _this = $(this);
		_this.parents('.my-community-wrap').css('padding-bottom', _this.parents('.mypage-wrap').height() + 19 + 'px' )
	})
}
function openView() {
	var clauseWrap = $('.clause-info-wrap'),
		 clauseInfo = clauseWrap.find('.clause-info'),
		 clauseBtn = clauseWrap.find('.btn-more-view > a');
	clauseBtn.on('click', function(e){
		e.preventDefault();
		var _this = $(this);
	 	_this.parents('.clause-info-wrap').find('.clause-info').addClass('on');
	})
}
function designSelect(){
    $('.design-select').each(function(){
        /*reset*/
        var _that = $(this);
        var _thatTitle = _that.attr('title');
        $(this).hide();
        $(this).wrap('<div class="designSelectW" />');
        var selectW = $(this).parent('.designSelectW');
        selectW.append('<div class="select-content" />');
        var selectC = selectW.find('.select-content');
        selectC.append('<div class="select-title"><a href="#"></a></div>');
        selectC.append('<ul class="select-list" />');
        var selectT = selectW.find('.select-title > a');
        if (_thatTitle){
            selectT.attr('title',_thatTitle);
        }
        var selectL = selectW.find('.select-list');
        if ($(this).find(' option:selected')){
            selectT.text($(this).find('option:selected').text());
        }else{
            selectT.text($(this).find('option').eq(0).text());
        }
        var selectOption = $(this).find('option');
        selectOption.each(function(){
            var optionText = $(this).text();
            selectL.append('<li><a href="#">' + optionText + '</a></li>')
        });
        selectL.find('li').eq(0).addClass('first');
        selectL.find('li').last().addClass('last');
        selectL.hide();

        /*event handler*/
        selectT.on('click',function(e){
            e.preventDefault();
            if ($(this).parent().next().is(':visible')){
                $(this).parent().next().hide();
                $(this).parent().removeClass('active');
            }else{
                $('.select-list').hide();
                $(this).parent().addClass('active');
                $(this).parent().next().show();
            }

        });
        selectT.on('keydown',function(e){
            if (e.keyCode == 9 && $(this).next().parent().is(':visible')){
                $(this).parent().next().find('a').eq(0).focus();
                return false;
            }else if (e.keyCode == 27){
                $(this).parent().next().hide();
                $(this).focus();
            }else{
                return true;
            }
        });
        selectW.find('.select-list a').on('click',function(e){
            e.preventDefault();
            var $text = $(this).text();
            var $index =$(this).parent().parent().find('li').index($(this).parent());
            _that.find('option').removeAttr('selected');
            _that.find('option').eq($index).attr('selected','selected');
            $(this).parent().parent().parent().find('.select-title').find('a').text($text).focus();
            $(this).parent().parent().hide();
            if (_that.attr('onchange')){
                _that.trigger('onchange');
            }else{
                _that.trigger('change');
            }
        });
        $('.select-list').find('a').on('keydown',function(e){
            if (e.shiftKey && e.keyCode == 9) {
                if ($(this).parent().attr('class') == 'first'){
                    $(this).parent().parent().find('li').last().find('a').focus();
                    return false;
                }
            }else if (e.keyCode == 9){
                if ($(this).parent().attr('class') == 'last'){
                    //$(this).parent().parent().find('li').eq(0).find('a').focus();
                    $(this).parent().parent().hide();
                    $(this).parent().parent().prev().find('a').focus();
                    return false;
                }
            }else if (e.keyCode == 27){
                $(this).parent().parent().hide();
                $(this).parent().parent().parent().find('.select-title').find('a').focus();
                return false;
            }else{
                return true;
            }
        });

    });
}

function resetDesignSelect(targetObj){

    var _that = targetObj;

    _that.val('');

    var selectW = _that.parent('.designSelectW');

    var selectT = selectW.find('.select-title > a');
    selectT.text(_that.children("option:selected").text());

    var selectL = selectW.find('.select-list');
    selectL.empty();

    var selectOption = _that.find('option');
    selectOption.each(function(){
        var optionText = $(this).text();
        selectL.append('<li><a href="#">' + optionText + '</a></li>')
    });
    selectL.find('li').eq(0).addClass('first');
    selectL.find('li').last().addClass('last');
    selectL.hide();

    selectW.find('.select-list a').on('click',function(e){
        e.preventDefault();
        var $text = $(this).text();
        var $index =$(this).parent().parent().find('li').index($(this).parent());
        _that.find('option').removeAttr('selected');
        _that.find('option').eq($index).attr('selected','selected');
        $(this).parent().parent().parent().find('.select-title').find('a').text($text).focus();
        $(this).parent().parent().hide();
        if (_that.attr('onchange')){
            _that.trigger('onchange');
        }else{
            _that.trigger('change');
        }
    });
    selectW.find('.select-list a').on('keydown',function(e){
        if (e.shiftKey && e.keyCode == 9) {
            if ($(this).parent().attr('class') == 'first'){
                $(this).parent().parent().find('li').last().find('a').focus();
                return false;
            }
        }else if (e.keyCode == 9){
            if ($(this).parent().attr('class') == 'last'){
                //$(this).parent().parent().find('li').eq(0).find('a').focus();
                $(this).parent().parent().hide();
                $(this).parent().parent().prev().find('a').focus();
                return false;
            }
        }else if (e.keyCode == 27){
            $(this).parent().parent().hide();
            $(this).parent().parent().parent().find('.select-title').find('a').focus();
            return false;
        }else{
            return true;
        }
    });
}

function setDocumentTitle() {

    var location = $('.location');
    var locationTxt = '';
    location.find('span').each(function(){
        locationTxt += ' > ' + $(this).text();
    });

    $(document).attr('title', $(document).attr('title') + locationTxt);
    $( 'meta[name="description"]' ).attr( 'content' , $(document).attr('title') + locationTxt);
}

$(document).ready(function(){
    headerOpen();
    tabAction();
    //mainSlide('slide-type1', '3');
    //mainSlide('slide-type2', '4');
    videoSlide();
    detailTab();
    detailTab2();
    starLayer();
    commentLayer();
    accordionList();
    position_cm();
    connectionLesson();
    tabAction2();
    mobilePopupstar();
    PopupmyClassReg();
    loginFcs();
    inpSkin();
    joinForm();
    //memClass();
    myLessonLayer();
    liveLesson();
	myCommunity();
    lessonDetailLayer();

    if ($('.move-bar').length > 0){
        sdiSubNavi();
    }

    if ($('.layer-pop-wrap').length > 0){
        mobilePopupH();
    }
    if ($('.design-select').length > 0){
        designSelect();
    }
    setDocumentTitle();

});
$(document).on('resize',function(){
    if ($('.layer-pop-wrap').length > 0){
        mobilePopupH();
    }
    position_cm();
    myCommunity();
});
$(window).on('resize',function(){
    if ($('.star-score').length > 0){
        mobilePopupstar();
    }
    if ($('.layer-pop-wrap.my-class-reg').length > 0){
        PopupmyClassReg();
    }
    if ($('.layer-pop-wrap').length > 0){
        mobilePopupH();
    }
    position_cm();

});

$(document).on('scroll',function(){
	fixedTab();
});



$(window).resize(function(){
	var windowW = $(window).width(),
		   windowH = $(window).height();

	 if (windowW <= 640){
		 $('.lesson-slide').parent().parent('.bx-wrapper').hide();
		 $('.mobile-slide').parent().parent('.bx-wrapper').show();
	} else {
		$('.mobile-slide').parent().parent('.bx-wrapper').hide();
		$('.lesson-slide').parent().parent('.bx-wrapper').show();
	}
});

$(document).ready(function(){
	var windowW = $(window).width(),
		   windowH = $(window).height();

	 if (windowW <= 640){
		 $('.lesson-slide').parent().parent('.bx-wrapper').hide();
		 $('.mobile-slide').parent().parent('.bx-wrapper').show();
	} else {
		$('.mobile-slide').parent().parent('.bx-wrapper').hide();
		$('.lesson-slide').parent().parent('.bx-wrapper').show();
	}
});


//마이페이지가 있을경우 class추가
$(document).ready(function(){
	if ($('.mymenu').length > 0){
		$('#gnb').addClass('myon');
	}
});


//메뉴개수 늘어나면 확장
$(document).ready(function(){
	if ($('.mym>ul>li').length > 6){
		$('.sub-gnb').addClass('expan');
		$('.gnb-notice').addClass('expan');
	}
});


/* 썸네일 이미지 정비율 리사이즈/크롭
$(window).load(function() {
  var spans = document.querySelectorAll('.aspect');
  for (var i = 0; i < spans.length; ++i) {
    var span = spans[i];
    var spanAspect = span.offsetHeight / span.offsetWidth;
    span.style.overflow = 'hidden';

    var img = span.querySelector('img');
    var imgAspect = img.height / img.width;

    if (imgAspect <= spanAspect) {
      // 이미지가 div보다 납작한 경우 세로를 div에 맞추고 가로는 잘라낸다
      var imgWidthActual = span.offsetHeight / imgAspect;
      var imgWidthToBe = span.offsetHeight / spanAspect;
      var marginLeft = -Math.round((imgWidthActual - imgWidthToBe) / 2)
      img.style.cssText = 'width: auto; height: 100%; max-width: inherit; margin-left: '
                      + marginLeft + 'px;'
    } else {
      // 이미지가 div보다 길쭉한 경우 가로를 div에 맞추고 세로를 잘라낸다
      img.style.cssText = 'width: 100%; height: auto; margin-left: 0;';
    }
  }
}); */


