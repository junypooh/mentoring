<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
	<security:authentication var="id" property="principal.id" />
	<security:authentication var="username" property="principal.username" />
</security:authorize>
<spring:eval expression="T(kr.or.career.mentor.util.HttpRequestUtils).TOMMS_APP_DOMAIN" var="TOMMS_APP_DOMAIN"/>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js ie6" lang="ko"> <![endif]-->
<!--[if IE 7]>         <html class="no-js ie7" lang="ko"> <![endif]-->
<!--[if IE 8]>         <html class="no-js ie8" lang="ko"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="ko"> <!--<![endif]-->
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
	<title>산들바람 관리자</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.form.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
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
</head>
<body>
<div id="wrap">
	<style type="text/css">
		.sub-gnb {display:none;position: absolute;z-index:10}
	</style>
	<!-- header -->
	<div id="header" class="administrator">
		<div class="logo-area">
			<ul class="header-utill">
				<c:choose>
					<c:when test="${empty id}">
						<li class="logout login"><a href="${pageContext.request.contextPath}/login.do"><span>로그인</span></a></li><!-- 로그인상태 class="login-state" -->
					</c:when>
					<c:otherwise>
						<li class="top-admin"><a href="${pageContext.request.contextPath}/myPage/myInfo/myInfo.do"><span>${username}(${id})</span></a></li>
						<%--<li><a href="#">나의정보</a></li> --%>
						<li class="logout"><form action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post"><input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/><button>로그아웃</button></form></li><!-- 로그인상태 class="login-state" -->
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		<!-- gnb -->
		<div class="gnb-area">
			<h1 class="logo"><a href="${pageContext.request.contextPath}/"><img src="${pageContext.request.contextPath}/images/common/logo1.gif" alt="산들바람 관리자 페이지" /></a></h1>
			<ul class="alarm"><%--
            <li class="active"><a href="#">수업운영관리</a></li>
            <li class="line"><a href="#">사용관리</a></li> --%>
				<c:forEach items="${sessionScope.menu}" var="item" varStatus="vs">
					<li class="nth${item.dispSeq} ">
						<a href="${(empty item.linkUrl)?'javascript:void(0)': pageContext.request.contextPath + item.linkUrl}" onclick="${(empty item.linkUrl)?'showSubMenu(this)':''}"><strong>${item.mnuNm}</strong></a>
						<div class="menu${vs.count}">
							<div>
								<ul class="">
									<c:forEach items="${item.subMnuInfo}" var="subItem"><li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li></c:forEach>
								</ul>
							</div>
						</div>
					</li>
				</c:forEach>
			</ul>
		</div>
		<!-- //gnb -->
	</div>
	<!-- //header -->
	<div id="container">
		<div class="content error">
			<div class="error-cont">
				<h2>페이지를 찾을 수 없습니다.<span>찾으려는 페이지가 제거 되었거나, 이름이 변경 되었거나, 일시적으로 사용이 중단되었습니다.</span></h2>
				<p class="desc">다음을 시도하십시오.</p>
				<ul class="browser-list error-404">
					<li>브라우저의 주소 표시줄에 입력한 웹사이트 주소의 철자와 형식이 정확한지 확인 하십시오.</li>
					<li>링크를 클릭하여 이 페이지에 연결한 경우, 웹사이트 관리자에게 링크가 잘못되었음을 알려 주십시오. </li>
					<li><a href="javascript:history.back();">뒤로</a> 단추를 클릭하여 다른 링크를 시도하십시오.</li>
				</ul>
			</div>
		</div>
	</div>
	<div id="footer">
		<p>Copyright &copy; mentor.career.go.kr. All rights reserved.</p>
	</div>
</div>
</body>
</html>
