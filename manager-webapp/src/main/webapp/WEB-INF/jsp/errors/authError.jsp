<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${exception eq 'kr.or.career.mentor.exception.AuthorityException' and exception.error_type eq 4}" >
<script type="text/javascript">
location.href="${pageContext.request.contextPath}/join/protectorMail.do";
</script>
</c:if>