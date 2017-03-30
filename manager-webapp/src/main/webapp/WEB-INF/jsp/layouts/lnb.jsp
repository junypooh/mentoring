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

<div class="lnb-area">
    <c:set var="_tagetUrl" value="${requestScope['javax.servlet.forward.request_uri']}" />
    <spring:eval expression="@mnuInfoService.getGlobalMnuInfo('${authCd}', '${headerMnuId}')" var="globalMenus" />
    <ul class="lnb">
        <c:forEach items="${globalMenus}" var="menuInfo">
        <c:set var="urlPttn" value="${pageContext.request.contextPath}${menuInfo.urlPttn}" />
        <li <c:if test="${fn:indexOf(_tagetUrl, urlPttn) > -1}"> class="on"</c:if>>
            <c:choose>
            <c:when test="${not empty menuInfo.globalSubMnuInfos}">
            <p class="lead-menu"><a href="javascript:void(0)">${menuInfo.mnuNm}</a></p>
            </c:when>
            <c:otherwise>
            <p class="lead-menu"><a href="${pageContext.request.contextPath}${menuInfo.linkUrl}">${menuInfo.mnuNm}</a></p>
            </c:otherwise>
            </c:choose>
            <c:if test="${not empty menuInfo.globalSubMnuInfos}">
            <ul class="lnb-sub">
            <c:forEach items="${menuInfo.globalSubMnuInfos}" var="subMenuInfo" varStatus="status">
                <c:set var="subUrlPttn" value="${pageContext.request.contextPath}${subMenuInfo.urlPttn}" />
                <li <c:if test="${fn:indexOf(_tagetUrl, subUrlPttn) > -1}"> class="on"</c:if>><a href="${pageContext.request.contextPath}${subMenuInfo.linkUrl}">${subMenuInfo.mnuNm}</a></li>
            </c:forEach>
            </ul>
            </c:if>
        </li>
        </c:forEach>
    </ul>
</div>