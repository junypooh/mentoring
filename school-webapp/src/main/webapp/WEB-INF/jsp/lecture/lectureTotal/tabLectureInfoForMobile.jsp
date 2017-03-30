<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();
}
%>

	<!-- 수업소개 -->
	<div class="lesson-introduce">
		<h3>수업소개</h3>
		<p class="tit-desc">
			${lectInfo.lectIntdcInfo}
		</p>
		<h4 class="stit-dot-type">수업내용</h4>
		<div class="lesson-cont-wrap">
			<div class="tit-desc">
				${lectInfo.lectSustInfo}
			</div>
		</div>

		<%--
		<h4 class="stit-dot-type">수업자료</h4>
		<div id="boardDataList"></div>
		--%>
	</div>
	<!-- //수업소개 -->

<script type="text/javascript">

var cntntsTargtNo = "<c:out value="${param.lectSer}" />";
var cntntsTargtTims = "<c:out value="${param.lectTims}" />";
var cntntsTargtSeq = "<c:out value="${param.schdSeq}" />";
var sMbrNo = "<%=user.getMbrNo()==null?"":user.getMbrNo()%>";
var arclSer = 0;

</script>

<%--<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoDataList.js"></script>--%>
