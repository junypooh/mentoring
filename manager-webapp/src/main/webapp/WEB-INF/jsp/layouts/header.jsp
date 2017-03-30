<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="authCd" property="principal.authCd" />
</security:authorize>

<div id="header">
    <h1 class="h1-logo"><a href="${pageContext.request.contextPath}"><img src="${pageContext.request.contextPath}/images/h1_logo.png" alt="산들바람" /></a></h1>
    <div class="header-top">
        <ul class="util">
        <c:choose>
        <c:when test="${empty id}">
        </c:when>
        <c:otherwise>
            <li class="total-manager"><a href="javascript:void(0)" onclick="showPassWordModifyLayer()">${username}</a></li>
            <!--li><a href="#"><img src="${pageContext.request.contextPath}/images/ico_setting.png" alt="설정" /></a></li-->
            <li><form id="loginForm" action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/><a href="javascript:$('#loginForm').submit();"><img src="${pageContext.request.contextPath}/images/ico_logout.png" alt="로그아웃" /></a></form></li>
        </c:otherwise>
        </c:choose>
        </ul>
    </div>
    <div class="header-bot">
        <c:set var="_tagetUrl" value="${requestScope['javax.servlet.forward.request_uri']}" />
        <ul class="gnb">
            <spring:eval expression="@mnuInfoService.getGlobalMnuInfo('${authCd}')" var="globalMenus" />
            <c:forEach items="${globalMenus}" var="menuInfo">
            <c:set var="urlPttn" value="${pageContext.request.contextPath}${menuInfo.urlPttn}" />
            <li<c:if test="${fn:indexOf(_tagetUrl, urlPttn) > -1}"> class="on" <c:set var="headerMnuId" value="${menuInfo.mnuId}" scope="request"/></c:if>><a href="javascript:void(0)" onclick="headerMnuUrl('${menuInfo.mnuId}', '${authCd}')">${menuInfo.mnuNm}</a></li>
            </c:forEach>
        </ul>
    </div>
</div>
<c:import url="/popup/passwordModify.do" />

<script type="text/javascript">
    function headerMnuUrl(mnuId, authCd) {
        $(location).attr('href', '${pageContext.request.contextPath}/ajax.gnb.do?mnuId=' + mnuId + '&authCd=' + authCd);
    }

    function showPassWordModifyLayer() {

        $('.jqgrid-overlay').show();
        $("#pw0").val("");
        $("#pw1").val("");
        $("#pw2").val("");
        $("#chkPwdDisp").css("display","none");
        $('#passWordModifyLayer').css('display', 'block');
    }
</script>