<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/userguide.css">
<div id="container">
    <div class="location mobile-sb">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">이용안내</span>
        <span>모바일 이용가이드</span>
    </div>
    <div class="content sub">
        <h2>모바일 이용가이드</h2>
        <div class="user-guide-list">
            <ul>
                <li class="m-type">
                    <a href="#"><strong>어플리케이션 다운로드 및 설치</strong></a>
                    <div class="user-guide-cont app-down">
                        <ul>
                            <li class="nth1">
                                <div class="info-wrap">
                                    <strong class="title">어플리케이션 스토어에서 &lsquo;산들바람&rsquo; 검색 후 다운받아 설치하세요.</strong>
                                    <p class="info">
                                        <img src="${pageContext.request.contextPath}/images/userguide/icon_tip3.png" alt="꼭 읽어보세요">
                                        <span>Wi-Fi를 통한 다운로드를 권장합니다. LTE, 3G망 등 이동통신망을 이용하는 경우 별도의 데이터 사용료가 발생할 수 있습니다.</span>
                                    </p>
                                    <div class="app-dw-area">
                                        <span class="app-store"><a href="#" title="산들바람 app 다운로드 - 이동">애플 어플 다운로드</a></span>
                                        <span class="google-play"><a href="#" title="산들바람 app 다운로드 - 이동">안드로이드 어플 다운로드</a></span>
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </li>
                <li class="m-type">
                    <a href="#"><strong>어플리케이션 실행</strong></a>
                    <div class="user-guide-cont app-play">
                        <ul>
                            <li class="nth1">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>1</span></em>
                                    <strong class="title">산들바람 어플리케이션 실행</strong>
                                    <p class="info">
                                        모바일 폰에 설치된 산들바람 App을 실행합니다.
                                    </p>
                                </div>
                            </li>
                            <li class="nth2">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>2</span></em>
                                    <strong class="title">로그인</strong>
                                    <p class="info">
                                        산들바람 계정으로 로그인 합니다.
                                    </p>
                                </div>
                            </li>
                        </ul>
                    </div>
                </li>
                <li>
                    <a href="#"><strong>수업 참여</strong></a>
                    <div class="user-guide-cont app-lesson">
                        <ul>
                            <li class="nth1">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>1</span></em>
                                    <strong class="title">나의 수업</strong>
                                    <p class="info">
                                        로그인 후, 나의 수업 목록으로 이동됩니다.
                                    </p>
                                    <div class="tip-info type2"><img src="${pageContext.request.contextPath}/images/userguide/icon_tip2.png" alt="TIP"><strong>멘토링수업</strong><p>산들바람의 전체 수업 목록으로, 참관이 허용 된 수업에 한해, 참관 수업이 가능합니다.</p></div>
                                </div>
                            </li>
                            <li class="nth2">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>2</span></em>
                                    <strong class="title">수업 입장</strong>
                                    <p class="info">
                                        수업 상세 페이지의 &lsquo;입장&rsquo; 버튼을 눌러 수업에 참여합니다.
                                    </p>
                                </div>
                            </li>
                            <li class="nth3">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>3</span></em>
                                    <strong class="title">수업 참여</strong>
                                </div>
                            </li>
                        </ul>
                    </div>
                </li>
                <li class="w-type">
                    <a href="#"><strong>수업 참여</strong></a>
                    <div class="user-guide-cont app-lesson">
                        <ul>
                            <li class="nth1">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>1</span></em>
                                    <strong class="title">수업 신청정보 확인</strong>
                                    <p class="info">수업일 도래 시,&lsquo;입장&rsquo; 버튼을클릭해서 수업에 참여해주세요.</p>
                                </div>
                            </li>
                            <li class="nth2">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>2</span></em>
                                    <strong class="title">수업 평가하기</strong>
                                    <p class="info">
                                        수업 완료 후, <br>수업 후기 및 평가를 작성합니다
                                    </p>
                                </div>
                            </li>
                            <li class="nth3">
                                <div class="info-wrap">
                                    <em class="num">STEP<span>3</span></em>
                                    <strong class="title">수업 참여</strong>
                                </div>
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</div>
    <div class="cont-quick">
        <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
    </div>

<script type="text/javascript">
$(document).ready(function(){
    accordionList ();
    accordionList2 ();
    tabAction3();
});
</script>