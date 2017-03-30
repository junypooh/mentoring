<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<div class="tab-cont active">
  <div class="tit-wrap">
    <h4 class="tit">수업문의</h4>
    <span class="right">
      <select style="width:68px;" id="recordPerPageCount">
        <option value="10">10</option>
        <option value="20">20</option>
        <option value="30">30</option>
        <option value="50">50</option>
      </select>
    </span>
  </div>
  <div class="lesson-task qna" id="boardQnaList"></div>
</div>

<script type="text/javascript">

var cntntsTargtNo = "<c:out value="${param.lectSer}" />";
var cntntsTargtTims = "<c:out value="${param.lectTims}" />";
var cntntsTargtSeq = "<c:out value="${param.schdSeq}" />";
var lectrMbrNo = "<c:out value="${param.lectrMbrNo}" />";
var lectTitle = "<c:out value="${param.lectTitle}" />";
var lectrJobNo = "<c:out value="${param.lectrJobNo}" />";
var sMbrNo = "<%=user.getMbrNo()==null?"":user.getMbrNo()%>";
var arclSer = 0;

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoQnaList.js" class="${param.arclSer}"></script>