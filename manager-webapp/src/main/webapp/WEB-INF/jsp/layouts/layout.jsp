<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="T(kr.or.career.mentor.util.HttpRequestUtils).TOMMS_APP_DOMAIN" var="TOMMS_APP_DOMAIN"/>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>산들바람 관리자</title>

	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/basic.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
	<!-- datapicker / jqgrid -->
	<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/resources/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/resources/css/jquery-ui.theme.min.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/resources/css/ui.jqgrid.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/resources/plugins/ui.multiselect.css" />
	<link rel="stylesheet" type="text/css" media="screen" href="${pageContext.request.contextPath}/resources/css/jquery.bxslider.css" />

	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/i18n/grid.locale-kr.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.jqGrid.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.bxslider.min.js"></script>

    <!-- datapicker / jqgrid[E] -->

    <script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.jqGrid.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tmpl.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.tmplPlus.js"></script>
    <script type="text/javascript">
    mentor.csrf = "${_csrf.token}";
    mentor.contextpath = "${pageContext.request.contextPath}";
    mentor.TOMMS_APP_DOMAIN = "${TOMMS_APP_DOMAIN}";
    </script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/react.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/JSXTransformer.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/react/mentor.react.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.gallery.slide.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easing.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.bind-first-0.2.3.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
</head>
<body>
    <div class="wrap">
		<!-- Header -->
        <tiles:insertAttribute name="header" />
		<!-- Header[E] -->
		<!-- Container -->
        <div id="container">
        <tiles:insertAttribute name="lnb" />
        <tiles:insertAttribute name="body" />
        </div>
		<!-- Container[E] -->
		<!-- Footer-->
        <tiles:insertAttribute name="footer" />
		<!-- Footer[E] -->
    </div>
</body>
</html>