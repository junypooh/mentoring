<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원가입</span>
    </div>
    <div class="content">
        <h2 class="tab-tit">회원가입</h2>
        <div class="tab-area">
            <img src="${pageContext.request.contextPath}/images/member/img_join_step1.gif" alt="회원분류 선택" />
        </div>
        <div class="cont">
            <div class="member-choice">
                <h3>양방향 실시간, 원격영상 멘토링 서비스</h3>
                <%--<div class="message">
                    <em>(주)우리나라좋은나라</em>
                    <p>회원가입을 환영합니다!</p>
                </div>
                --%>
                <p>
                    회원구분에 따라 차별화된 서비스를 제공하고 있습니다.<br/>
                    회원구분을 선택해주세요.
                </p>
                <div class="btn-area">
                    <a href="step2.do" class="btn-type2 arw">개인 멘토 회원 가입</a>
                </div>
            </div>

        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>
