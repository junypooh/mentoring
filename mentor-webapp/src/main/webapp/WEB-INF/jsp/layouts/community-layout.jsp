<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js ie6" lang="ko"> <![endif]-->
<!--[if IE 7]>         <html class="no-js ie7" lang="ko"> <![endif]-->
<!--[if IE 8]>         <html class="no-js ie8" lang="ko"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="ko"> <!--<![endif]-->
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
    <title>산들바람 멘토 진로멘토링</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/community.css" />
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/react.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/JSXTransformer.js"></script>
    <script type="text/javascript">
    mentor.contextpath = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
    <ul id="skipNav">
        <li><a href="#">본문</a></li>
        <li><a href="#">footer</a></li>
    </ul>
    <div id="wrap">
        <!-- header -->
        <tiles:insertAttribute name="header" />
        <!-- //header -->
        <tiles:insertAttribute name="body" />
        <tiles:insertAttribute name="footer" />
    </div>
</body>
</html>