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
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery.form.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
    <title>산들바람 관리자 - 원격진로멘토링</title>
</head>
<body>
    <tiles:insertAttribute name="body" />
</body>
</html>