<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:if test="${exception eq 'kr.or.career.mentor.exception.AuthorityException' and exception.error_type eq 4}" >
<script type="text/javascript">
alert("관리자의 승인을 기다리고 있습니다.");
$(document).ready(function(){
    $('#logoutFrm').submit();
});
</script>
<div style="display:none">
<form:form action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post" id="logoutFrm">
<a href="javascript:void(0)" class="logout" onclick="$('#logoutFrm').submit()">나가기</a></form:form>
</c:if>
</div>