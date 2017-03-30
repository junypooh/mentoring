<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">마이페이지</span>
        <span>나의정보</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">나의정보</h2>
        <p class="tit-desc-txt">나의 정보를 조회할 수 있습니다.</p>
        <div class="member-out">
            <h3>회원 탈퇴 신청</h3>
            <div class="member-out-box">
                <ul>
                    <li><strong>원격진로멘토링 서비스를 이용해 주셔서 감사합니다.</strong></li>
                    <li>원격진로멘토링 회원 탈퇴를 하실 경우<br />아래 내용과 같이 회원정보가 처리됩니다.</li>
                </ul>
                <ul class="member-out-info">
                    <li>회원 탈퇴 신청 즉시 회원 탈퇴 처리되며, 해당 아이디의 회원정보는 즉시 삭제 처리됩니다.</li>
                    <li>회원님이 수강한 수업, 작성한 게시글 등의 정보는 개인정보(아이디, 이름)을 삭제하여 통계 및 연구 목적으로 활용됩니다.</li>
                    <li>회원 탈퇴 이후 같은 아이디로는 재가입이 불가능합니다.</li>
                </ul>
            </div>
            <div class="btn-area">
                <a href="secessionFinish.do" class="btn-type2 out">회원탈퇴신청</a>
                <a href="${pageContext.request.contextPath}/" class="btn-type2 gray">홈으로</a>
            </div>
        </div>
    </div>
</div>