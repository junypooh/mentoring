<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>

<script type="text/javascript">
$().ready(function() {
    $('#secessionFisnshBtn').click(function(e) {
        return confirm('회원탈퇴 시 모든 개인정보가 삭제됩니다.\n회원 탈퇴를 계속 진행하시겠습니까?')
    });
});
</script>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원정보</span>
        <span>회원탈퇴<c:if test="${mbrCualfCd eq '101503'}"> 신청</c:if></span>
    </div>
    <div class="content">
        <h2>회원탈퇴<c:if test="${mbrCualfCd eq '101503'}"> 신청</c:if></h2>
        <div class="cont">
            <div class="member-out">
                <h3>회원탈퇴<c:if test="${mbrCualfCd eq '101503'}">를 신청</c:if>합니다.</h3>
                <p>서비스를 이용해주셔서 감사합니다.<br />회원탈퇴를 하실 경우 아래 내용과 같이 회원정보가 처리됩니다.</p>
                <div class="message">
                    <ul>
                        <c:if test="${mbrCualfCd eq '101503'}">
                        <li>회원탈퇴 신청 시, 관리자 승인 후 탈퇴가 완료됩니다.</li>
                        </c:if>
                        <li class="cir-pink"><em>회원님이 등록하신 콘텐츠 내용, 이용문의 등은 삭제되지 않습니다.</em></li>
                        <li>회원탈퇴 이후 같은 아이디로는 재가입이 불가능합니다. </li>
                    </ul>
                </div>
                <div class="btn-area member-out">
                    <a href="${pageContext.request.contextPath}/myPage/myInfo/secessionFisnsh.do?mbrCualfCd=${mbrCualfCd}" class="btn-type2" id="secessionFisnshBtn">회원탈퇴<c:if test="${mbrCualfCd eq '101503'}"> 신청</c:if></a>
                    <a href="${pageContext.request.contextPath}/" class="btn-type2 gray">홈으로</a>
                </div>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>