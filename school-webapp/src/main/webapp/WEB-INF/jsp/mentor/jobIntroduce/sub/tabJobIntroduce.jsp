<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<!-- 직업 소개 -->
<div class="introduce-wrap tab-cont active">
    <h3>하는 일</h3>
    <div class="introduce-info">
        <p><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(jobInfo.jobIntdcInfo)" /></p>
    </div>

    <c:if test="${(not empty newsList) or (not empty interviewList) or (not empty movieList)}">
        <div class="career">
            <h4 class="stit-dot-type">관련정보</h4>
            <ul>
                <c:if test="${not empty newsList}">
                    <li>
                        <em>- 뉴스</em>
                        <ul>
                            <c:forEach var="news" items="${newsList}">
                                <li><a href="${news.scrpURL}" title="새창열림" target="_blank">${news.scrpTitle}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${not empty interviewList}">
                    <li>
                        <em>- 인터뷰</em>
                        <ul>
                            <c:forEach var="interview" items="${interviewList}">
                                <li><a href="${interview.scrpURL}" title="새창열림" target="_blank">${interview.scrpTitle}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${not empty movieList}">
                    <li>
                        <em>- 동영상</em>
                        <ul>
                            <c:forEach var="movie" items="${movieList}">
                                <li><a href="${movie.scrpURL}" title="새창열림" target="_blank">${movie.scrpTitle}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>
            </ul>
        </div>
    </c:if>

</div>
<!-- //멘토 소개 -->


