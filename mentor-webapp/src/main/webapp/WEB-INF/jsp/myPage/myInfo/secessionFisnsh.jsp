<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원정보</span>
        <span>회원탈퇴<c:if test="${param.mbrCualfCd eq '101503'}"> 신청</c:if></span>
    </div>
    <div class="content">
        <h2>회원탈퇴<c:if test="${param.mbrCualfCd eq '101503'}"> 신청</c:if></h2>
        <div class="cont">
            <div class="member-out out-finish">
                <h3>회원탈퇴<c:if test="${param.mbrCualfCd eq '101503'}"> 신청이</c:if><c:if test="${param.mbrCualfCd ne '101503'}">가</c:if> 완료되었습니다.</h3>
                <p>요청하신 회원탈퇴<c:if test="${param.mbrCualfCd eq '101503'}"> 신청이</c:if><c:if test="${param.mbrCualfCd ne '101503'}">가</c:if> 완료 처리되었습니다.<br />이용해 주셔서 감사합니다.</p>
                <c:if test="${param.mbrCualfCd eq '101503'}">
                <div class="message">
                    <ul>
                        <li>관리자 승인 후, 회원 탈퇴가 완료됩니다.</li>
                        <li>승인 정보는 입력하신 주소로 메일이 발송됩니다.</li>
                    </ul>
                </div>
                </c:if>
                <div class="btn-area member-out">
                    <a href="${pageContext.request.contextPath}" class="btn-type2">메인으로 이동</a>
                </div>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>