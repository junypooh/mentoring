<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<html>
<body>
<c:out value="${article.totalRecordCount}" />   <br />
<c:forEach var="result" items="${article.result}" varStatus="status">
    <span><c:out value="${result.title}"/><br /></span>
</c:forEach>
<form:form name="tx_editor_form" id="tx_editor_form" action="${pageContext.request.contextPath}/main/editorTest.do" method="post" accept-charset="utf-8">

<jsp:include page="/layouts/editor.do" flush="true">
  <jsp:param name="contentId" value="content_area_id"/>
</jsp:include>
<!-- Sample: Loading Contents -->
<textarea id="content_area_id" name="contentNm" style="display:none;">${params.contentNm}</textarea>
<%--<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
<div><button onclick='saveContent()'><spring:message code="button.save"/></button></div>
</form:form>
</body>
</html>