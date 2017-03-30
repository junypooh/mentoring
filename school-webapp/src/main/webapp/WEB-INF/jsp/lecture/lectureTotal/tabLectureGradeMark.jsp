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

<!-- 평점 및 후기 -->
<div class="grade-epilogue navi-content">
    <h3>평점 및 후기</h3>
  <div id="boardGradeList"></div>
</div>

<script type="text/javascript">
    $(function(){
        $('.slider-area').slider({
            range: "min",
            value: 5, /* value값 제한해주세요 */
            min: 0,
            max: 10
        });
    });

    var cntntsTargtNo = "<c:out value="${param.lectSer}" />";
    var cntntsTargtTims = "<c:out value="${param.lectTims}" />";
    var cntntsTargtSeq = "<c:out value="${param.schdSeq}" />";
    var sMbrNo = "<%=user.getMbrNo()==null?"":user.getMbrNo()%>";
    var arclSer = "${arclInfo.arclSer}";

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoGradeList.js"></script>