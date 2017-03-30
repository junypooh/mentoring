<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">로그인</span>
        <span>14세 미만 회원 가입 동의</span>
    </div>
    <div class="content sub">
        <form:form id="approveForm" method="post" commandName="user" action="approve.do">
        <form:input type="hidden" path="mbrNo"/>
        <h2 class="txt-type">14세미만회원가입동의</h2>
        <p class="tit-desc-txt">14세미만회원가입동의</p>
        <div class="minor_member_join">
            <div class="txt-box">
                <em>${user.username}(${fn:substring(user.birthday,0,4)})</em>
                <p>이 원격진로멘토링 회원으로 가입하는 것에<br/>동의하십니까?</p>
            </div>
            <p>
                개인정보보호법에 의거 14세 미만의 어린이가 원격영상 진솔루션 회원으로 가입하기 위해서는 <br/>
                보호자의 동의가 필요합니다.<br/>
                아래 <span>[가입동의]</span> 버튼을 클릭하시면 가입이 완료됩니다.
            </p>
            <div class="btn-area">
                <button type="submit" class="btn-type2" >가입동의</button>
            </div>
        </div>
        </form:form>

    </div>
</div>

<div class="cont-quick double">
    <%--<a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a>--%>
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>