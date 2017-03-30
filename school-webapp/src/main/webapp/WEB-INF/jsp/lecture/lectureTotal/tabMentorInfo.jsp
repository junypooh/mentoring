<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>

<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
</security:authorize>

<!-- <div class="mentor-introduce"> -->
<div class="mentor-introduce introduce-wrap">
    <h3>멘토 소개</h3>
    <div class="replay-detail">
        <strong class="stit">${mentor.profTitle}  <em> ${mentor.nm}</em></strong>
        <div class="img-star">
            <div class="eximg">
                <div class="txt">
                    <p>
                        <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(mentor.profIntdcInfo)"></spring:eval>
                    </p>
                </div>
                <ul>
                    <li>
                        <em>멘토</em>
                        <span class="r-txt">${mentor.nm}<c:if test="${mentor.iconKindCd eq '101598'}"> <span class="don">재능기부</span></c:if></span>
                    </li>
                    <li>
                        <em>직업</em>
                        <span class="r-txt">${mentor.jobNm}&nbsp;</span>
                    </li>
                    <li>
                        <em>태그</em>
                        <span class="r-txt">${mentor.jobTagInfo}&nbsp;</span>
                    </li>
<!--
                    <li>
                        <em>관련 정보</em>
                        <div class="r-txt news">
                            <ul class="info">
                                <c:forEach var="each" items="${listMbrProfScrpInfo}" varStatus="vs">
                                    <%--<li><span class="sort">${each.scrpClassCdNm}</span><a href="${each.scrpURL}" target="_blank" title="새창열림">${each.scrpTitle}</a></li>--%>
                                    <li><em>${each.scrpClassCdNm}</em><a href="${each.scrpURL}" title="새창열림" target="_blank">${each.scrpTitle}</a></li>
                                </c:forEach>
                            </ul>&nbsp;
                        </div>
                    </li>

                    <c:if test="${not empty corporationUser}">
                        <li>
                            <em>운영</em>
                            <span class="r-txt">${corporationUser.posCoNm}&nbsp;</span>
                        </li>
                    </c:if>
                    <c:if test="${not empty organizationUser}">
                        <li>
                            <em>지원</em>
                            <span class="r-txt">${organizationUser.posCoNm}</span>
                        </li>
                    </c:if>
-->
                </ul>
            </div>
        </div>
    </div>
    <c:if test="${mentor.profSchCarInfo != null || mentor.profCareerInfo != null || mentor.profAwardInfo != null || mentor.profBookInfo != null}">
    <h3>멘토이력</h3>
    <div class="career">
        <ul>
        <c:if test="${mentor.profSchCarInfo != null}">
            <li>
                <em>- 학력</em>
                <ul>
                    <li><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(mentor.profSchCarInfo)"></spring:eval></li>
                </ul>
            </li>
        </c:if>
        <c:if test="${mentor.profCareerInfo != null}">
            <li>
                <em>- 경력</em>
                <ul>
                    <li><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(mentor.profCareerInfo)"></spring:eval></li>
                </ul>
            </li>
        </c:if>
        <c:if test="${mentor.profAwardInfo != null}">
            <li>
                <em>- 수상</em>
                <ul>
                    <li><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(mentor.profAwardInfo)"></spring:eval></li>
                </ul>
            </li>
        </c:if>
        <c:if test="${mentor.profBookInfo != null}">
            <li>
                <em>- 저서</em>
                <ul>
                    <li><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(mentor.profBookInfo)"></spring:eval></li>
                </ul>
            </li>
        </c:if>
        </ul>
    </div>
    </c:if>
    <h3 id="lectData">멘토 자료</h3>
    <div id="boardDataList"></div>
</div>

<script type="text/javascript">


var lectrMbrNo = "<c:out value="${param.mbrNo}" />";
var userId = "<c:out value="${id}" />";
var cntntsTargtNo = 0;

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoDataList.js"></script>