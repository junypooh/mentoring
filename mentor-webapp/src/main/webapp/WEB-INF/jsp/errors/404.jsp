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
	<security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>
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
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/management.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" media="screen" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css" media="screen" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery-ui.min.css">
	<spring:eval expression="T(kr.or.career.mentor.util.HttpRequestUtils).TOMMS_APP_DOMAIN" var="TOMMS_APP_DOMAIN"/>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/slides.min.jquery.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
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
		mentor.csrf = "${_csrf.token}";
		mentor.TOMMS_APP_DOMAIN = "${TOMMS_APP_DOMAIN}";
	</script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/mentor.react.js"></script>
</head>
<body>
<ul id="skipNav">
	<li><a href="#">본문</a></li>
	<li><a href="#">footer</a></li>
</ul>
<div id="wrap">
	<c:if test="${not empty messageCode}">
		<spring:eval expression="messageCode.toMessage()" var="message" />
		<script type="text/javascript">
			$().ready(function() {
				alert('${message}');
			});
		</script>
	</c:if>
	<c:if test="${not empty errorCode}">
		<spring:eval expression="errorCode.toMessage()" var="errorMessage" />
		<script type="text/javascript">
			$().ready(function() {
				alert('${errorMessage}');
			});
		</script>
	</c:if>
	<div class="h-notice" id="h-notice">
		<div class="cont-area">
			<spring:eval expression="@bannerServiceImpl.retrieveBanner(T(kr.or.career.mentor.constant.Constants).MENTOR)" var="banner"/>
			<c:choose>
				<c:when test="${banner.bnrTypeCd eq code['CD101637_101638_A']}">
					<!-- 텍스트 노출 -->
					<div class="notice"><a href="${banner.bnrLinkUrl}"><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(banner.bnrDesc)"></spring:eval></a></div>
				</c:when>
				<c:when test="${banner.bnrTypeCd eq code['CD101637_101639_B']}">
					<!-- 이미지 + 텍스트 노출 -->
					<div class="img-txt">
						<a href="${banner.bnrLinkUrl}">
							<span><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${banner.bnrImgUrl}" alt="${banner.bnrNm}" /></span>
							<p><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(banner.bnrDesc)"></spring:eval></p>
						</a>
					</div>
				</c:when>
				<c:when test="${banner.bnrTypeCd eq code['CD101637_101640_C']}">
					<!-- 이미지 노출 -->
					<div class="img"><a href="${banner.bnrLinkUrl}"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${banner.bnrImgUrl}" alt="${banner.bnrNm}" /></a></div>
				</c:when>
			</c:choose>

			<a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/common/btn_hnotice_close.png" alt="닫기" onclick="javascript:$(this).closest('.h-notice').remove();setCookie('h-notice_${banner.bnrSer}', '${banner.bnrSer}',1);"/></a>
		</div>
	</div>
	<div id="header">
		<div class="gnb-wrap">
			<h1><a href="${pageContext.request.contextPath}/">산들바람 멘토 - 원격진로멘토링</a></h1>
			<ul>
				<c:choose>
					<c:when test="${empty id}">
						<li class="login"><a href="${pageContext.request.contextPath}/login.do">로그인</a></li><!-- 로그인상태 class="login-state" -->
						<li class="join"><a href="${pageContext.request.contextPath}/join/step1.do">회원가입</a></li><!-- 로그아웃 class="logout" -->
					</c:when>
					<c:otherwise>
						<li class="login-state">
							<c:choose>
								<c:when test="${mbrCualfCd eq code['CD100204_101501_업체담당자'] }">
									<a href="${pageContext.request.contextPath}/myPage/myInfo/myInfo.do"><security:authentication property="principal.username" /></a>
								</c:when>
								<c:otherwise>
									<a href="${pageContext.request.contextPath}/myPage/myInfo/myInfo.do"><security:authentication property="principal.username" /></a>
								</c:otherwise>
							</c:choose>
						</li>
						<li class="logout">
							<form:form action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post" id="logoutFrm">
								<a href="javascript:void(0)" class="logout" onclick="$('#logoutFrm').submit()">로그아웃</a></form:form>
						</li>
					</c:otherwise>
				</c:choose>
			</ul>
			<!-- gnb -->

			<div id="gnb" class="<security:authorize access="hasRole('ROLE_COP_MENTOR')">affiliate</security:authorize> <security:authorize access="hasRole('ROLE_CORPORATION')">business</security:authorize>"><!-- 소속멘토: affiliate  기업멘토:business -->
				<ul>
					<c:forEach items="${sessionScope.menu}" var="item" varStatus="vs">
						<li>
							<c:choose>
								<c:when test="${item.linkUrl ne null and item.linkUrl ne ''}">
									<a href="${pageContext.request.contextPath}${item.linkUrl}">${item.mnuNm}</a>
								</c:when>
								<c:otherwise>
									<a href="#">${item.mnuNm}</a>
								</c:otherwise>
							</c:choose>
							<c:if test="${!empty item.subMnuInfo}">
								<div class="sub-gnb smenu${vs.count}">
									<ul>
										<c:forEach items="${item.subMnuInfo}" var="subItem">
											<li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li>
										</c:forEach>
									</ul>
								</div>
							</c:if>
						</li>
					</c:forEach>
				</ul>
			</div>
			<!-- //gnb -->
		</div>
	</div>
	<div class="page-loader" style="display:none;">
		<img src="${pageContext.request.contextPath}/images/common/img_page_loader.gif" alt="페이지 로딩 이미지">
	</div>
	<script type="text/javascript">
		$(document).ready(function() {
			if(mentor.isMobile || getCookie("h-notice_${banner.bnrSer}")){
				$("#h-notice").remove();
			}else if(${!empty id}){
				$(".h-notice .cont-area .img-txt").show();
			}
		});
	</script>
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
		<div class="footer-cont">
			<div class="footer-info">
				<ul class="footer-menu">
					<li><a href="${pageContext.request.contextPath}/agreement.do">이용약관</a></li>
					<li><a href="${pageContext.request.contextPath}/agreementPersonalInformation.do">개인정보처리방침</a></li>
					<li><a href="${pageContext.request.contextPath}/emailRefusal.do">이메일무단수집거부</a></li>
					<%--<li><a href="#">변경동의</a></li> --%>
				</ul>
				<div class="footer-menu-organization">
					<a href="#" class="organization">관련사이트</a>
					<ul class="organization-ul">
						<li><a href="http://www.career.go.kr/cnet/front/main/main.do" target="_blank">커리어넷</a></li>
						<li><a href="http://www.krivet.re.kr/ku/index.jsp" target="_blank">한국직업능력개발원</a></li>
						<li><a href="https://www.kofac.re.kr/" target="_blank">한국과학창의재단</a></li>
					</ul>
				</div>
			</div>
			<div class="footer-organization">
				<a href="http://www.moe.go.kr/main.do" target="_blank"><img src="${pageContext.request.contextPath}/images/main/img_footer_fscience.png" alt="미래창조과학부" /></a>
				<a href="http://www.msip.go.kr" target="_blank"><img src="${pageContext.request.contextPath}/images/main/img_footer_edu.png" alt="교육부" /></a>
			</div>
			<div class="footer-science-menu">
				<address>세종특별자치시 시청대로 370 세종국책연구단지 사회정책동</address>
				<p class="footer-manage">운영: 한국직업능력개발원 진로교육센터</p>
				<p class="footer-support">지원: 교육부</p>
				<p class="footer-copyright">COPYRIGHTS <em>&copy;</em> KRIVET ALL RIGHTS RESERVED.</p>
			</div>
		</div>
	</div>
</div>
</body>
</html>
