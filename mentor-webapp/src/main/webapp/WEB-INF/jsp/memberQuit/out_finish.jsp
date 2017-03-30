<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원정보</span>
        <span>회원탈퇴 신청</span>
    </div>
    <div class="content">
        <h2>회원탈퇴 신청</h2>
        <div class="cont">
            <div class="member-out out-finish">
                <h3>회원탈퇴 신청이 완료되었습니다.</h3>
                <p>요청하신 회원탈퇴 신청이 완료 처리되었습니다.<br />이용해 주셔서 감사합니다.</p>
                <div class="message">
                    <ul>
                        <li>관리자 승인 후, 회원 탈퇴가 완료됩니다.</li>
                        <li>승인 정보는 입력하신 주소로 메일이 발송됩니다.</li>
                    </ul>
                </div>
                <div class="btn-area member-out">
                    <a href="${pageContext.request.contextPath}/" class="btn-type2">메인으로 이동</a>
                </div>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>