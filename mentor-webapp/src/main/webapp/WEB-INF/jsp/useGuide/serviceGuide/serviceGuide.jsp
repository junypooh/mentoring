<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/userguide.css">

<script type="text/javascript">
    $(document).ready(function(){
        $('.bxslider1').sistarGallery({
            $animateTime_ : 500,
            $animateEffect_ : "easeInOutQuint",
            $autoDelay : 2000,
            $focusFade : 500,
            $currentNum : 1
        });
        $('.bxslider2').sistarGallery({
            $animateTime_ : 500,
            $animateEffect_ : "easeInOutQuint",
            $autoDelay : 2000,
            $focusFade : 500,
            $currentNum : 1
        });
    });
</script>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>이용안내</span>
        <span>서비스 가이드</span>
    </div>
    <div class="content">
        <h2 class="fs24">서비스 가이드</h2>
        <div class="cont">
            <div class="id-pw-search mentor-detail" style="padding:0;">
                <div class="id-search">
                    <div class="board-title">
                        <h3 class="board-tit">수업개설</h3>
                        <div>
                            <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_mentor_management.png" alt="열기/닫기" /></a>
                        </div>
                    </div>
                    <div class="board-input-type guide-slide">
                        <div class="service-guide">
                            <ul class="bxslider1">
                                <li class="current"><div><img src="${pageContext.request.contextPath}/images/common/img_serviceguide_open1.jpg" alt="step01 : 기본정보 입력(필수입력)-수업관리 &gt; 수업개설에서 수업 정보를 입력합니다." /></div></li>
                                <li><div><img src="${pageContext.request.contextPath}/images/common/img_serviceguide_open2.jpg" alt="step02 : 부가정보 입력-수업자료와 요청수업 항목을 선택할 수 있습니다." /></div></li>
                                <li><div><img src="${pageContext.request.contextPath}/images/common/img_serviceguide_open3.jpg" alt="step03 : 수업 일시 등록-수업일시를 추가합니다. (옵션선택:스튜디오, MC)" /></div></li>
                            </ul>
                            <div class="control_wrap">
                                <button class="left_m"><img src="${pageContext.request.contextPath}/images/common/btn_slide_prev.png" alt="이전" /></button>
                                <button class="right_m"><img src="${pageContext.request.contextPath}/images/common/btn_slide_next.png" alt="다음" /></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="id-pw-search mentor-detail">
                <div class="id-search">
                    <div class="board-title">
                        <h3 class="board-tit">나의 수업</h3>
                        <div>
                            <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_mentor_management.png" alt="열기/닫기" /></a>
                        </div>
                    </div>
                    <div class="board-input-type guide-slide1">
                        <div class="service-guide my-lesson">
                            <ul class="bxslider1">
                                <li class="current"><div><img src="${pageContext.request.contextPath}/images/common/img_serviceguide_lesson1.jpg" alt="step01 : 수업 현황-수업관리 &gt; 수업현황에서 수업 정보를 확인합니다." /></div></li>
                                <li><div><img src="${pageContext.request.contextPath}/images/common/img_serviceguide_lesson2.jpg" alt="step02 : 수업 입장-수업일 도래 시, 입장 버튼을 클릭하여 수업에 입장합니다." /></div></li>
                                <li><div><img src="${pageContext.request.contextPath}/images/common/img_serviceguide_lesson3.jpg" alt="step03 : 수업 진행-화상 솔루션을 실행한 후, 수업을 진행합니다." /></div></li>
                            </ul>
                            <div class="control_wrap">
                                <button class="left_m"><img src="${pageContext.request.contextPath}/images/common/btn_slide_prev.png" alt="이전" /></button>
                                <button class="right_m"><img src="${pageContext.request.contextPath}/images/common/btn_slide_next.png" alt="다음" /></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>