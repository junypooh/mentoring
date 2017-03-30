<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
</security:authorize>

	<!-- 수업소개 -->
	<div class="lesson-introduce">
		<h3>수업소개</h3>
		<p class="tit-desc">
			<spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectInfo.lectIntdcInfo)"></spring:eval>
		</p>
		<h4 class="stit-dot-type">수업내용</h4>
		<div class="lesson-cont-wrap">
			<div class="tit-desc">
				${lectInfo.lectSustInfo}
			</div>
		</div>

		<h4 class="stit-dot-type" id="lectData">수업자료</h4>
		<div id="boardDataList"></div>
	</div>
	<!-- //수업소개 -->

<script type="text/javascript">

var cntntsTargtNo = "<c:out value="${param.lectSer}" />";
var lectrMbrNo = "<c:out value="${param.lectrMbrNo}" />";
var userId = "<c:out value="${id}" />";

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoDataList.js"></script>
