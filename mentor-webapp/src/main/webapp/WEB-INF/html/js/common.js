function headerClose() {
	$('#gnb ul li, .header-search .search, .header-search .sitemap').removeClass('active');
	$('body').removeClass('dim');
}

function headerOpen() {
	var closebind = function(){
			$('#gnb ul li, .header-search .search, .header-search .sitemap').removeClass('active');
			$('body').removeClass('dim');
			$(window).unbind('click touchstart', closebind);
			$('.selectbox-zindex-box').css('display', 'none'); /* pom */
		}

	$('#gnb > ul > li > a').on('click', function(e){
		e.stopPropagation();
		//e.preventDefault();
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
				$('.selectbox-zindex-box').css('display', 'block');
				//$('body').css('overflow','hidden');
				$layer.attr('tabindex',0).show().focus();
				$layer.find('.pop-close, .btn-area.popup a.cancel, .btn-area.border a.cancel').on('click',function (e) {
					e.preventDefault();
					$layer.hide();
					$('.selectbox-zindex-box').css('display', 'none')
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
/*function popClose(){
	$('.pop-close').on('click', function(){
		$('body').removeClass('dim');
	});
}*/

function loginFcs(){
	$('.login-box input').on('focusin', function(){
		$(this).parent().addClass('on');
	});
	$('.login-box input').on('focusout', function(){
		$(this).parent().removeClass('on');
	});
}
function txtareaFcs(){
	$('textarea').on('focusin', function(){
		$(this).addClass('on');
	});
	$('textarea').on('focusout', function(){
		$(this).removeClass('on');
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
	var lessonDetailBtn = $('.board-type2.info table tr td .lesson-cont .detail-btn');
	lessonDetailBtn.on('click', function(e) {
		if(!$(this).hasClass('active')){
			$('.board-type2.info table tr td .lesson-cont .detail-btn').removeClass('active');
			$(this).addClass('active');

		}else{
			$(this).removeClass('active');
		}
	});
}

function tblListTab() {
	var cListWrap = $('.community-list-wrap'),
		 cListBtn = cListWrap.find('> ul > li > a');

		 cListBtn.on('click', function(e){
			e.preventDefault();
			var _this = $(this);
			_this.parent().addClass('active').siblings().removeClass('active');
		 })
}

function scheduleSlide(){
	var slWrap = $('.schedule-detail'),
		 slUl = slWrap.find('> ul'),
		 slUlMl = parseInt(slWrap.css('margin-left')),
		 slli = slUl.find('> li > ul > li'),
		 slliMl = slUl.find('> li '),
		 index = 0,
		 nextB = slWrap.find('.next'),
		 prevB = slWrap.find('.prev');

		slUl.css('width', slli.length * slliMl.width());
		nextB.click(function(){
			if(nextB.hasClass('on')){

				if (!slUl.is(':animated')){
					if (index < slliMl.length){
						index = index + 1;
					}
					prevB.addClass('on')
					slUl.animate({'margin-left': slliMl.width() * -index}, 500)
					if (index == (slliMl.length - 1)){
						nextB.removeClass('on');
					}
				}
			}else{
				return false;
			}
		});
		prevB.click(function(){
			if(prevB.hasClass('on')){
				if (!slUl.is(':animated')){
					if (index > 0){
						index = index - 1;
					}

					nextB.addClass('on');
					slUl.animate({'margin-left':  slliMl.width() * -index}, 500)
					if (index == 0){
						prevB.removeClass('on');
					}
				}
			}else{
				return false;
			}
		});
}

function tabAction() {
	var tabWrap = $('.tab'),
		 tabBtn = tabWrap.find('.tab-ul li a'),
		 tabCont = $('.tab-action-cont .tab-cont');

	tabBtn.on('click', function(e) {
		e.preventDefault();
		var _this = $(this).parent('li'),
			 index = _this.index();

		_this.addClass('on').siblings().removeClass('on');
		_this.next('.tab-cont').removeClass('on').addClass('on');
	});
}
function tabAction2() {
	var tabWrap = $('.tab-action'),
		tabBtn = tabWrap.find('.sub-tab a, .tab-type2 > li > a'),
		tabCont = $('.tab-action-cont .tab-cont');

	tabBtn.on('click', function(e) {
		e.preventDefault();

		var _this = $(this).parent('li'),
			index = _this.index();

		_this.addClass('active').siblings().removeClass('active');
		tabCont.removeClass('active').eq(index).addClass('active');
	});
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

function lessonChoice() {
	var tileList = $('.mc-search-list div.lesson-request-date .time-list');

	tileList.on('click', function(e){
		e.preventDefault();
		if(!$(this).hasClass('active')){
			tileList.removeClass('active');
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
	//popClose();
	loginFcs();
	txtareaFcs();
	detailTab();
	detailTab2();
	tblListTab();
	scheduleSlide();
	tabAction();
	tabAction2();
	tabAction3();
	accordionList();
	lessonChoice();

});

$(document).on('resize',function(){
	position_cm();
});
$(window).on('resize',function(){
	position_cm();

});

$(document).on('scroll',function(){
});

//메뉴개수 늘어나면 확장
$(document).ready(function(){
	if ($('#gnb>ul>li:nth-child(2) .sub-gnb>ul>li').length > 6){
		$('.sub-gnb').addClass('expan');
		$('.gnb-notice').addClass('expan');
		$('.sub-area').addClass('expan');
	}
});

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
});



