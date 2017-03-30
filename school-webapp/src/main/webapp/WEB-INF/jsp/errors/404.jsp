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
	<title>산들바람 진로멘토링</title>
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

<script type="text/javascript">
	$().ready(function() {
		<c:if test="${not empty errorCode}">
		<spring:eval expression="errorCode.toMessage()" var="errorMessage" />
		alert('${errorMessage}');
		</c:if>
		$('#totalSearchForm').submit(function() {
			if (!!!this.searchKey.value || this.searchKey.value.trim().length < 2) {
				alert('검색은 2글자 이상 입력해야 합니다.');
				return false;
			}
		});

		$('#totalSearch').click(function(e) {
			e.preventDefault();
			$(this).closest('form').submit()
		});

		if(mentor.isMobile || getCookie("h-notice_${banner.bnrSer}")){
			$("#h-notice").remove();
		}else{
//        $("#h-notice").show();
			$("#h-notice_tmpl").tmpl({}).appendTo('#h-notice');
		}

		if(mentor.isMobile || getCookie("h-info")){
			$("#web-service-info").remove();
		}else{
//        $("#web-service-info").show();
		}
	});
</script>
<div class="web-service-info" id="web-service-info">
	<img src="${pageContext.request.contextPath}/images/common/banner_img_01.png" alt="반응형 웹 서비스"><p class="txt-info"><strong>진로멘토링 산들바람</strong> 은 PC, 태블릿, 모바일 기기 환경 및 웹 브라우저 크기에 따라 <br> 화면 구성이 달라지는 <strong>반응형 웹 서비스</strong> 입니다. <br> 현재 크기는 태블릿, 및 모바일 기기 반응형 화면입니다. <br> 화면을 늘려 PC용 최적화 사이즈로 서비스를 이용하세요.</p>
	<div class="ctl-box">
		<label for="webService" class="chk-skin" title="다시 보지 않기"><input type="checkbox" id="webService">다시 보지 않기</label><a href="javascript:void(0)" onclick="javascript:if($('#webService:checked').length>0)setCookie('h-info', 'x',1);$(this).closest('.web-service-info').remove();">닫기</a>
	</div>
</div>
<c:if test="${! isMobile}">
	<div class="h-notice" id="h-notice">
		<script type="text/html" id="h-notice_tmpl">
			<div class="cont-area">
				<c:choose>
					<c:when test="${banner.bnrTypeCd == code['CD101637_101638_A']}">
						<!-- 텍스트 노출 -->
						<div class="notice"><a href="${banner.bnrLinkUrl}"><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(banner.bnrDesc)"></spring:eval></a></div>
					</c:when>
					<c:when test="${banner.bnrTypeCd == code['CD101637_101639_B']}">
						<!-- 이미지 + 텍스트 노출 -->
						<div class="img-txt">
							<a href="${banner.bnrLinkUrl}">
								<span><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${banner.bnrImgUrl}" alt="<c:out value="${banner.bnrNm}"/>" /></span>
								<p><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(banner.bnrDesc)"></spring:eval></p>
							</a>
						</div>
					</c:when>
					<c:when test="${banner.bnrTypeCd == code['CD101637_101640_C']}">
						<!-- 이미지 노출 -->
						<div class="img"><a href="${banner.bnrLinkUrl}"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${banner.bnrImgUrl}" alt="<c:out value="${banner.bnrNm}" />" /></a></div>
					</c:when>
				</c:choose>
				<a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/common/btn_hnotice_close.png" alt="닫기" onclick="javascript:$(this).closest('.h-notice').remove();setCookie('h-notice_${banner.bnrSer}', '${banner.bnrSer}',1);"/></a>
			</div>
		</script>
	</div>
</c:if>
<c:set var="_tagetUrl" value="${requestScope['javax.servlet.forward.request_uri']}" />
<div id="header">
	<div class="gnb-wrap">
		<h1><a href="${pageContext.request.contextPath}/">산들바람 진로멘토링</a></h1>
		<ul>
			<li class="mentor"><a href="https://mentor.career.go.kr/index.do" target="_blank">산들바람 멘토</a></li>
			<c:choose>
				<c:when test="${empty id}">

					<li class="login"><form:form action="${pageContext.request.contextPath}/login.do" id="_frmLogin" method="post">
						<%--
                        <c:set value="${fn:substring(_tagetUrl,fn:length(pageContext.request.contextPath),-1)}" var="_targetPath"/>
                        <c:if test="${fn:length(_targetPath)>1}">
                            <input type="hidden" name="_spring_security_target_url" value="<c:out value="${_targetPath}" />${!empty pageContext.request.queryString?'?':''}<c:out value="${pageContext.request.queryString}" />" />
                        </c:if> --%>
						<a href="javascript:void(0)" onclick="$('#_frmLogin').submit()">로그인</a></form:form>
					</li><!-- 로그인상태 class="login-state" -->
					<c:if test="${! isMobile }">
						<li class="join"><a href="${pageContext.request.contextPath}/join/step1.do">회원가입</a></li><!-- 로그아웃 class="logout" -->
					</c:if>
				</c:when>
				<c:otherwise>
					<li class="login-state"><a href="${pageContext.request.contextPath}/myPage/myInfo/myInfoView.do"><security:authentication property="principal.username" /></a></li>
					<li class="logout"><form:form action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post" id="logoutFrm"><a href="javascript:void(0)" class="logout" onclick="$('#logoutFrm').submit()">로그아웃</a></form:form></li><!-- 로그인상태 class="login-state" -->
				</c:otherwise>
			</c:choose>
		</ul>
		<!-- gnb -->
		<div id="gnb">
			<ul>
				<c:forEach items="${SCHOOL_MENU_INFO}" var="item" varStatus="status">
					<c:choose>
						<c:when test="${empty id and item.mnuId eq 'MNU00021' }"></c:when>
						<c:otherwise>
							<li>
								<a href="#">${item.mnuNm}</a>
								<div class="sub-gnb smenu${status.count}">
									<ul>
										<c:forEach items="${item.subMnuInfo}" var="subItem">
											<c:if test="${(subItem.mnuId ne 'MNU00077') or (subItem.mnuId eq 'MNU00077' && (mbrCualfCd eq code['CD100204_100215_교사_진로상담_'] or mbrCualfCd eq code['CD100204_100214_교사']) )}">
												<c:if test="${!((subItem.mnuId eq 'MNU00022' or subItem.mnuId eq 'MNU00023') and (mbrCualfCd eq code['CD100204_100208_대학생'] or mbrCualfCd eq code['CD100204_100209_일반'] or mbrCualfCd eq code['CD100204_100210_일반_학부모_']))}">
													<li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li>
												</c:if>
											</c:if>
										</c:forEach>
									</ul>
								</div>
							</li>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</ul>
		</div>
		<!-- //gnb -->

		<div class="header-search">
			<!-- search -->
			<a href="${pageContext.request.contextPath}" class="search"><img src="${pageContext.request.contextPath}/images/common/btn_gnb_search.png" alt="search" /></a>
			<div class="form-wrap">
				<div class="form">
					<div><form id="totalSearchForm" action="${pageContext.request.contextPath}/totalSearch.do">
						<span><input type="text" class="txt" name="searchKey" maxlength="40" title="검색어 입력" /></span>
						<a href="#" class="btn-search" id="totalSearch">검색</a>
					</form></div>
				</div>
			</div>
			<!-- //search -->

			<!-- sitemap -->
			<a href="#" class="sitemap"><img src="${pageContext.request.contextPath}/images/common/btn_gnb_sitemap.png" alt="sitemap" /></a>
			<div class="form-wrap sitemap">
				<ul class="sitemap-wrap">
					<c:forEach items="${SCHOOL_MENU_INFO}" var="item" varStatus="vs">
						<c:choose>
							<c:when test="${empty id and item.mnuId eq 'MNU00021' }"></c:when>
							<c:otherwise>
								<li>
									<em><a href="#">${item.mnuNm}</a></em>
									<ul class="menu${vs.count}">
										<c:forEach items="${item.subMnuInfo}" var="subItem">
											<c:if test="${(subItem.mnuId ne 'MNU00077') or (subItem.mnuId eq 'MNU00077' && (mbrCualfCd eq code['CD100204_100215_교사_진로상담_'] or mbrCualfCd eq code['CD100204_100214_교사']) )}">
												<c:if test="${!((subItem.mnuId eq 'MNU00022' or subItem.mnuId eq 'MNU00023') and (mbrCualfCd eq code['CD100204_100208_대학생'] or mbrCualfCd eq code['CD100204_100209_일반'] or mbrCualfCd eq code['CD100204_100210_일반_학부모_']))}">
													<li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li>
												</c:if>
											</c:if>
										</c:forEach>
									</ul>
								</li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</ul>
			</div>
			<!-- //sitemap -->
		</div>
	</div>
</div>
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
				<li><a href="${pageContext.request.contextPath}/footer/usageRule.do">이용약관</a></li>
				<li><a href="${pageContext.request.contextPath}/footer/personalInformationRule.do">개인정보처리방침</a></li>
				<li><a href="${pageContext.request.contextPath}/footer/emailRefusal.do">이메일무단수집거부</a></li>
				<li><a href="https://mentor.career.go.kr/index.do" target="_blank">산들바람 멘토</a></li>
				<%--<li><a href="${pageContext.request.contextPath}/footer/">변경동의</a></li> --%>
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
			<a href="http://www.moe.go.kr/main.do" target="_blank"><img src="${pageContext.request.contextPath}/images/main/img_footer_edu.png" alt="교육부"></a>
			<a href="http://www.msip.go.kr" target="_blank"><img src="${pageContext.request.contextPath}/images/main/img_footer_fscience.png" alt="미래창조과학부"></a>
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
