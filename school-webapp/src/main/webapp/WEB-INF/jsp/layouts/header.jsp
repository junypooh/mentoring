<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="browser" value="${header['User-Agent']}"/>
<spring:eval expression="@bannerServiceImpl.retrieveBanner(T(kr.or.career.mentor.constant.Constants).SCHOOL)" var="banner"/>
<spring:eval expression="@notifInfoServiceImpl.selectNotReadMbrNotifInfo()" var="notifInfo" />

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />

<c:if test="${empty isMobile}">
<c:set var="isMobile" value="${cnet:isMobile(header['User-Agent'])}" scope="session"/>
</c:if>

<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
    <security:authentication var="authCd" property="principal.authCd" />
</security:authorize>


<script type="text/javascript">
$().ready(function() {

<c:if test="${not empty errorCode}">
    <spring:eval expression="errorCode.toMessage()" var="errorMessage" />
    alert('${errorMessage}');
</c:if>
    <%--
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
    --%>

    if(mentor.isMobile || getCookie("h-notice_${banner.bnrSer}")){
        $("#h-notice").remove();
    }else{
//        $("#h-notice").show();
        $("#h-notice_tmpl").tmpl({}).appendTo('#h-notice');
    }
});
</script>
<div class="web-service-info" id="web-service-info">
    <img src="${pageContext.request.contextPath}/images/common/banner_img_01.png" alt="반응형 웹 서비스"><p class="txt-info"><strong>진로멘토링 산들바람</strong> 은 PC, 태블릿, 모바일 기기 환경 및 웹 브라우저 크기에 따라 <br> 화면 구성이 달라지는 <strong>반응형 웹 서비스</strong> 입니다. <br> 현재 크기는 태블릿, 및 모바일 기기 반응형 화면입니다. <br> 화면을 늘려 PC용 최적화 사이즈로 서비스를 이용하세요.</p>
    <div class="ctl-box">
        <label for="webService" class="chk-skin" title="다시 보지 않기"><input type="checkbox" id="webService">다시 보지 않기</label><a href="javascript:void(0)" onclick="javascript:if($('#webService:checked').length>0)setCookie('h-info', 'x',1);$(this).closest('.web-service-info').remove();">닫기</a>
    </div>
</div>
<script type="text/javascript">
    // 화면 깜박임으로 인한 ready 에서 옮김.
    if(mentor.isMobile || getCookie("h-info")){
        $("#web-service-info").remove();
    }else{
//        $("#web-service-info").show();
    }
</script>
<c:if test="${! isMobile}">
<div class="h-notice" id="h-notice">
<script type="text/html" id="h-notice_tmpl">
    <div class="cont-area">
        <c:if test="${banner.bnrTypeCd == code['CD101637_101638_상단띠배너']}">
            <!-- 텍스트 노출 -->
            <div class="notice"><a href="${banner.bnrLinkUrl}"><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(banner.bnrDesc)"></spring:eval></a></div>
        </c:if>
        <a href="javascript:void(0)" onclick="javascript:$(this).closest('.h-notice').remove();setCookie('h-notice_${banner.bnrSer}', '${banner.bnrSer}',1);"><img src="${pageContext.request.contextPath}/images/common/btn_hnotice_close.png" alt="닫기" /></a>
    </div>
</script>
</div>
</c:if>
<c:set var="_tagetUrl" value="${requestScope['javax.servlet.forward.request_uri']}" />
<div id="header">
    <div class="gnb-wrap">
        <h1><a href="${pageContext.request.contextPath}/">산들바람 진로멘토링</a></h1>
        <ul class="top-util">
            <c:choose>
            <c:when test="${empty id}">

                <li>
                    <form:form action="${pageContext.request.contextPath}/login.do" id="_frmLogin" method="post">
                    <a href="javascript:void(0)" onclick="$('#_frmLogin').submit()">로그인</a></form:form>
                </li>
                <c:if test="${! isMobile }">
                <li><a href="${pageContext.request.contextPath}/join/step1.do">회원가입</a></li>
                </c:if>
            </c:when>
            <c:otherwise>
                <li class="login <c:if test="${not empty notifInfo}">alert</c:if>"><a href="${pageContext.request.contextPath}/myPage/myInfo/myInfoView.do"><security:authentication property="principal.username" /></a></li>
                <li><form:form action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post" id="logoutFrm"><a href="javascript:void(0)" class="logout" onclick="$('#logoutFrm').submit()">로그아웃</a></form:form></li><!-- 로그인상태 class="login-state" -->
            </c:otherwise>
            </c:choose>
            <li class="lesson-timetable"><a href="${pageContext.request.contextPath}/lecture/lectureSchedule/lectureSch.do">수업시간표</a></li>
        </ul>
        <!-- gnb -->
        <c:set var="thisUrl" value="${requestScope['javax.servlet.forward.request_uri']}" />
        <c:if test="${fn:indexOf(thisUrl, '/join/step') < 0}">
        <%-- 회원가입 페이지 에서는 메뉴 노출하지 않음 --%>
        <div id="gnb">
            <c:if test="${empty authCd}">
            <c:set var="authCd" value="ROLE_STUDENT" />
            </c:if>
            <spring:eval expression="@mnuInfoService.getGlobalMnuInfo('${authCd}')" var="globalMenus" />
            <ul>
            <c:forEach items="${globalMenus}" var="item" varStatus="vs">
            <c:if test="${not empty id or item.mnuId ne 'MNU00021' }">
                <li <c:if test="${item.mnuId eq 'MNU00021'}">class="mymenu"</c:if>>
                    <a href="javascript:void(0)">${item.mnuNm}</a>
                    <c:if test="${!empty item.globalSubMnuInfos}">
                    <div class="sub-gnb <c:if test="${vs.first}">first</c:if><c:if test="${item.mnuId eq 'MNU00021'}">mym</c:if>">
                        <ul>
                            <c:forEach items="${item.globalSubMnuInfos}" var="subItem">
                            <c:if test="${!((subItem.mnuId eq 'MNU00022' or subItem.mnuId eq 'MNU00023') and (mbrCualfCd eq code['CD100204_100208_대학생'] or mbrCualfCd eq code['CD100204_100209_일반'] or mbrCualfCd eq code['CD100204_100210_일반_학부모_']))}">
                            <c:choose>
                                <c:when test="${item.linkUrl ne null and item.linkUrl ne ''}">
                                    <li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li>
                                </c:otherwise>
                            </c:choose>
                            </c:if>
                            </c:forEach>
                        </ul>
                    </div>
                    </c:if>
                </li>
            </c:if>
            </c:forEach>
            </ul>
            <div class="gnb-notice">
                <c:choose>
                <c:when test="${not empty notifInfo}">
                <p><span class="gnb-date"><fmt:formatDate value="${notifInfo.regDtm}" pattern="yyyy.MM.dd"/></span>[알림] ${notifInfo.notifTitle}<a href="${pageContext.request.contextPath}/myPage/notifInfo/notifInfoList.do">더보기</a></p>
                </c:when>
                <c:otherwise>
                <p>새 알림이 없습니다.</p>
                </c:otherwise>
                </c:choose>
            </div>
        </div>
        </c:if>
        <!-- //gnb -->

        <div class="header-search">
            <!-- search -->
            <!-- <a href="${pageContext.request.contextPath}" class="search"><img src="${pageContext.request.contextPath}/images/common/btn_gnb_search.png" alt="search" /></a>
            <div class="form-wrap">
                <div class="form">
                    <div><form id="totalSearchForm" action="${pageContext.request.contextPath}/totalSearch.do">
                        <span><input type="text" class="txt" name="searchKey" maxlength="40" title="검색어 입력" /></span>
                        <a href="#" class="btn-search" id="totalSearch">검색</a>
                    </form></div>
                </div>
            </div> -->
            <a href="#" class="sitemap">사이트맵 열기</a>
            <!-- //search -->
        </div>
    </div>
</div>
<div class="page-loader" style="display:none;">
    <img src="${pageContext.request.contextPath}/images/common/img_page_loader.gif" alt="페이지 로딩 이미지">
</div>