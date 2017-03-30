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

<!-- 다시보기 -->
<div class="lesson-replay navi-cont">
    <h3>다시보기</h3>
	<div id="boardReplayList"></div>
</div>

<script type="text/javascript">

var cntntsTargtNo = "<c:out value="${param.lectSer}" />";
var cntntsTargtTims = "<c:out value="${param.lectTims}" />";
var cntntsTargtSeq = "<c:out value="${param.schdSeq}" />";
var lectrMbrNo = "<c:out value="${param.lectrMbrNo}" />";
var lectrJobNo = "<c:out value="${param.lectrJobNo}" />";
var sMbrNo = "<%=user.getMbrNo()==null?"":user.getMbrNo()%>";
var arclSer = 0;

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoReplayList.js" ></script>