/*
* jQuery sistarGallery images slider- 1.2.1
* Copyright (c) 2013 nickname stryper http://gotoplay.tistory.com/
* Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/licenses/gpl.html
*/
(function($){
	$.fn.sistarGallery = function(user_opt){
		var default_opt = {
			$animateTime_ : 500,
			$animateEffect_ : "easeInOutQuint",
			$autoDelay : 3000,
			$focusFade : 200
		};
		var opt = $.extend(default_opt, user_opt);
		return this.each(function() {
			var $slider = $(this);
			var $slider_wrap = $slider.parent();
			var $control = $(this).siblings(".control_wrap");
			var $li_ = $slider.find("li");
			var $li_active = $slider.find(">li.current");
			var $con_ = $li_.length;
			var $ul_w = $li_.outerWidth() * $con_;
			var $navi = $slider.siblings(".navi").find('button');
			var $next = $control.find('.right_m');
			var $prev = $control.find('.left_m');
			var $auto = $control.find('.auto');
			var $stop = $control.find('.stop');
			$slider.heipos = function (){
				var $refl = ($slider.find(".current").innerHeight()/2) - ($slider.find($next).innerHeight() / 2) - 5;
				setTimeout(function(){
						$next.add($prev).css('top', $refl);
				}, 10);
			};
			$slider.heipos();
			$slider.nextMove = function () {
				var $li_current = $slider.find(".current");
				var $currentLength = $slider.find('.current').index();
				var $currentPos = $slider.find('.current').width();
				var $lastPos = $li_.width() * $($li_).last().index();
				if(!$($li_).is(":animated")){
					if( ! $($li_).last().hasClass('current') ){
						$slider.psitionNextReset ();
						$($li_).each(function(index){
							$(this).animate({left : '-='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_);
						});
						$($li_current).next().addClass('current').siblings().removeClass('current');
						$slider.siblings(".navi").find(".active").removeClass("active").next().addClass("active");
						var $li_current2 = $($li_current).next().height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
					}else{
						$slider.find('li:lt('+$currentLength+')').each(function(index){
							$(this)
								.css({left: $currentPos*(index+1)})
								.animate({left : '-='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_);
						});
						$slider.find(".current")
							.animate({left : '-='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_)
							.animate({left :$lastPos},0);
						$($li_).first().addClass('current').siblings().removeClass('current');
						$slider.siblings(".navi").find("li").first().addClass("active").siblings().removeClass("active");
						var $li_current2 = $($li_).first().height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
					};
				};
			};
			$slider.prevMove = function () {
				var $li_current = $slider.find(".current");
				var $currentLength = $slider.find('.current').index();
				var $currentPos = $slider.find('.current').width();
				var $firstPos = '-'+$li_.width() * $($li_).last().index();
				if(!$($li_).is(":animated")){
					if( ! $($li_).first().hasClass('current') ){
						$($slider.find('li:gt('+$currentLength+')').get().reverse()).each(function(index){
							$(this).css({left: $currentPos*(index+1)});
						});
						$($slider.find('li:lt('+$currentLength+')').get().reverse()).each(function(index){
							$(this).css({left: -$currentPos*(index+1)});
						});
						$($li_).each(function(index){
							$(this).animate({left : '+='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_);
						});
						$($li_current).prev().addClass('current').siblings().removeClass('current');
						$slider.siblings(".navi").find(".active").removeClass("active").prev().addClass("active");
						var $li_current2 = $($li_current).prev().height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
					}else{
						$($slider.find('li:gt('+$currentLength+')').get().reverse()).each(function(index){
							$(this)
								.css({left: -$currentPos*(index+1)})
								.animate({left : '+='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_);
						});
						$slider.find(".current")
							.animate({left : '+='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_)
							.animate({left :$firstPos},0);
						$($li_).last().addClass('current').siblings().removeClass('current');
						$slider.siblings(".navi").find("li").last().addClass("active").siblings().removeClass("active");
						var $li_current2 = $($li_).last().height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
					};
				};
			};
			$slider.psitionNextReset = function () {
				var $li_current = $slider.find(".current");
				var $currentLength = $slider.find('.current').index();
				var $currentPos = $slider.find('.current').width();
				$($slider.find('li:gt('+$currentLength+')')).each(function(index){
					$(this).css({left: $currentPos*(index+1)});
				});
				$($slider.find('li:lt('+$currentLength+')')).each(function(index){
					$(this).css({left: -$currentPos*(index+1)});
				});
			};
			$slider.psitionPrevReset = function () {
				var $li_current = $slider.find(".current");
				var $currentLength = $slider.find('.current').index();
				var $currentPos = $slider.find('.current').width();
				$($slider.find('li:gt('+$currentLength+')').get().reverse()).each(function(index){
					$(this).css({left: $currentPos*(index+1)});
				});
				$($slider.find('li:lt('+$currentLength+')').get().reverse()).each(function(index){
					$(this).css({left: -$currentPos*(index+1)});
				});
			};
			$slider.autoPlaySlider = function () {
				var $li_current = $slider.find(".current");
				var $currentLength = $slider.find('.current').index();
				var $currentPos = $slider.find('.current').width();
				var $lastPos = $li_.width() * $($li_).last().index();
				if( ! $($li_).last().hasClass('current') ){
					if(!$($li_).is(":animated")){
						$slider.psitionNextReset ();
						$($li_).each(function(index){
							$(this).animate({left : '-='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_);
						});
						$($li_current).next().addClass('current').siblings().removeClass('current');
						$slider.siblings(".navi").find(".active").removeClass("active").next().addClass("active");
						var $li_current2 = $($li_current).next().height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
					};
				} else {
					if(!$($li_).is(":animated")){
						$slider.psitionNextReset ();
						$slider.find('li:lt('+$currentLength+')').each(function(index){
							$(this)
								.css({left: $currentPos*(index+1)})
								.animate({left : '-='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_);
						});
						$slider.find(".current")
							.animate({left : '-='+$li_.width()}, opt.$animateTime_, opt.$animateEffect_)
							.animate({left :$lastPos},0);
						$($li_).first().addClass('current').siblings().removeClass('current');
						$slider.siblings(".navi").find("li").first().addClass("active").siblings().removeClass("active");
						var $li_current2 = $($li_).first().height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
					};
				};
			};
			$slider.sizeSet = function () {
				$slider.widthHeightFind ();
				$($li_).each(function(index){
					$(this).css({left: $li_.width()*index});
				});
				$($li_).first().addClass('current').siblings().removeClass('current');
				$slider.siblings(".navi").find("li").first().addClass("active").siblings().removeClass("active");
				var $li_active = $slider.find(".current");
				$($slider_wrap).css("height", $($li_active).height() );
				$slider.heipos();
			};
			$slider.widthHeightFind = function () {
				setTimeout(function(){
					var $liWidth = $slider_wrap.innerWidth();
					$($slider).css("width", $liWidth );
					$($li_).css("width", $liWidth );
					$($control).css("width", $slider.width() );
				}, 1 );
			};
			$($navi).each(function($navi){
				if(!$($li_).is(":animated")){
					$(this).on("click", function(e){
						e.preventDefault();
						var $current_eq = $slider.find(".current").index();
						var $this_eq = $(this).parent().index();
						if( $current_eq < $this_eq ){
							$slider.psitionNextReset ();
						} else {
							$slider.psitionPrevReset ();
						};
						var $li_current = $li_active;
						$($li_).each(function(index){
							$(this).animate({left : (-$li_.width()*$navi) + ($li_.width()*index)}, opt.$animateTime_, opt.$animateEffect_);
						});
						$($li_).eq($navi).addClass('current').siblings().removeClass('current');
						$(this).parent().siblings().removeClass("active").end().addClass("active");

						var $li_current2 = $($li_).eq($navi).height();
						setTimeout(function(){
							$($slider_wrap).animate({'height' : $li_current2}, opt.$animateTime_, opt.$animateEffect_);
						},0);
						$slider.heipos();
					});
				};
			});
			$($li_).find('a').on("focus", function(){
				$(this).parent().parent().addClass('current').css({'left':'0','opacity':'0'}).animate({'opacity':'1'},opt.$focusFade);
				$(this).parent().parent().siblings().removeClass('current').css({'left': -$li_.width()*2});
				var $thisIndex = $(this).parent().parent().index();
				$slider.siblings(".navi").find(">li:eq("+$thisIndex+")").addClass("active").siblings().removeClass("active");
				var $heiRe = $($li_).eq($thisIndex).height();
				setTimeout(function(){
					$($slider_wrap).animate({'height' : $heiRe}, opt.$focusFade, opt.$animateEffect_);
				},0);
				$slider.heipos();
			});
			$($next).on("click", function(e){
				e.preventDefault();
				$slider.nextMove();
				$slider.heipos();
			});
			$($prev).on("click", function(e){
				e.preventDefault();
				$slider.prevMove();
				$slider.heipos();
			});
			$($auto).on("click", function(e){
				e.preventDefault();
					$slider.autoStartAni = setInterval(function() {
						$slider.autoPlaySlider();
						$slider.heipos();
					}, opt.$autoDelay );
			});
			$($stop).on("click", function(e){
				e.preventDefault();
				clearInterval($slider.autoStartAni);
			});
			$(window).on("resize", function () {
				$slider.widthHeightFind ();
				var $currentLength = $slider.find(".current").index();
				var $currentPos = $slider.find(".current").width();
				$slider.find('li:gt('+$currentLength+')').each(function(index){
					$(this).css({left: $currentPos*(index+1)});
				});
				$slider.find('li:lt('+$currentLength+')').each(function(index){
					$(this).css({left: -$currentPos*(index+1)});
				});
				setTimeout(function(){
					var $li_active = $slider.find(".current");
					$($slider_wrap).css("height", $($li_active).height() );
				}, opt.$animateTime_ );
				$slider.heipos();
			}).resize();
			$(window).load(function(){
				$slider.sizeSet ();
			});
		});
	};
})(jQuery);