<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원가입</span>
    </div>
    <div class="content">
        <h2 class="tab-tit">회원가입</h2>
        <div class="tab-area">
            <img src="${pageContext.request.contextPath}/images/member/img_join_step4.gif" alt="접수완료" />
        </div>
        <div class="cont">
            <div class="member-choice finish">
                <h3>양방향 실시간, 원격영상 멘토링 서비스</h3>
                <%--
                <div class="message">
                    <em>(주)우리나라좋은나라</em>
                    <p><span>[회원가입 접수 완료]</span>되었습니다.</p>
                </div>
                --%>
                <p>
                    관리자 승인 후, 멘토 회원 가입이 완료됩니다.<br/>
                    승인 정보는 입력하신 메일주소로 메일이 발송됩니다.
                </p>
                <div class="btn-area">
                    <a href="${pageContext.request.contextPath}/" class="btn-type2">메인으로 이동</a>
                </div>
            </div>

        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>