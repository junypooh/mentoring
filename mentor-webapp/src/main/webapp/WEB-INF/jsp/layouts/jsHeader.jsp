<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<spring:eval expression="T(kr.or.career.mentor.util.HttpRequestUtils).TOMMS_APP_DOMAIN" var="TOMMS_APP_DOMAIN"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/slides.min.jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.bxslider.min.js"></script>
<!--[if lte IE 8]>
<script type="text/javascript" src="/react/js/html5shiv.min.js"></script>
<script type="text/javascript" src="/react/js/es5-shim.min.js"></script>
<script type="text/javascript" src="/react/js/es5-sham.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/JSXTransformer.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.gallery.slide.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easing.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tmpl.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tmplPlus.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.bind-first-0.2.3.js"></script>

<script type="text/javascript">
mentor.contextpath = "${pageContext.request.contextPath}";
mentor.csrf_parameterName = "${_csrf.parameterName}";
mentor.csrf = "${_csrf.token}";
mentor.TOMMS_APP_DOMAIN = "${TOMMS_APP_DOMAIN}";
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/mentor.react.js"></script>