<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<spring:eval expression="@notifInfoServiceImpl.selectNotReadMbrNotifInfo()" var="notifInfo" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
    <security:authentication var="authCd" property="principal.authCd" />
    <security:authentication var="posCoNm" property="principal.posCoNm" />
    <security:authentication var="profFileSer" property="principal.profFileSer" />
</security:authorize>
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
        <c:if test="${banner.bnrTypeCd eq code['CD101637_101638_상단띠배너']}">
            <!-- 텍스트 노출 -->
            <div class="notice"><a href="${banner.bnrLinkUrl}"><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(banner.bnrDesc)"></spring:eval></a></div>
        </c:if>
        <a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/common/btn_hnotice_close.png" alt="닫기" onclick="javascript:$(this).closest('.h-notice').remove();setCookie('h-notice_${banner.bnrSer}', '${banner.bnrSer}');"/></a>
    </div>
</div>
<div id="header">
    <div class="gnb-wrap">
        <h1><a href="${pageContext.request.contextPath}/index.do">산들바람 멘토 - 원격진로멘토링</a></h1>
        <ul>
        <c:choose>
        <c:when test="${empty id}">
            <li class="join"><a href="${pageContext.request.contextPath}/join/step1.do">회원가입</a></li>
            <li class="login"><a href="${pageContext.request.contextPath}/login.do">로그인</a></li>
        </c:when>
        <c:otherwise>
            <li class="login">
            <c:choose>
                <c:when test="${mbrCualfCd eq code['CD100204_101501_업체담당자'] }">
                <a href="${pageContext.request.contextPath}/myPage/myInfo/myInfo.do" <c:if test="${not empty notifInfo}">class="new-alert"</c:if>><security:authentication property="principal.posCoNm" /></a>
                </c:when>
                <c:otherwise>
                <a href="${pageContext.request.contextPath}/myPage/myInfo/myInfo.do" <c:if test="${not empty notifInfo}">class="new-alert"</c:if>><security:authentication property="principal.username" /></a>
                </c:otherwise>
            </c:choose>
            </li>
            <!--li class="member-info"><a href="#">회원정보</a></li-->
            <li class="logout">
                <form:form action="${pageContext.request.contextPath}/j_spring_security_logout.do" method="post" id="logoutFrm">
                <a href="javascript:void(0)" class="logout" onclick="$('#logoutFrm').submit()">로그아웃</a></form:form>
            </li>
        </c:otherwise>
        </c:choose>
        </ul>
        <!-- gnb -->
        <c:if test="${empty authCd}">
        <c:set var="authCd" value="ROLE_MENTOR" />
        </c:if>
        <c:set var="thisUrl" value="${requestScope['javax.servlet.forward.request_uri']}" />
        <c:if test="${fn:indexOf(thisUrl, '/join/step') < 0}">
        <%-- 회원가입 페이지 에서는 메뉴 노출하지 않음 --%>
        <div id="gnb" class="<security:authorize access="hasRole('ROLE_MENTOR')">affiliate</security:authorize> <security:authorize access="hasRole('ROLE_COP_MENTOR')">affiliate</security:authorize> <security:authorize access="hasRole('ROLE_CORPORATION')">business</security:authorize>"><!-- 소속멘토: affiliate  기업멘토:business -->
            <c:choose>
            <c:when test="${empty id}">
            <div class="sub-area">
                <div class="gnb-profile">
                    <span class="gnb-profile-img"><img src="${pageContext.request.contextPath}/images/main/img_profile_default.jpg" alt="프로필 이미지" /></span>
                    <p class="gnb-profile-nm">로그아웃 상태입니다.</p>
                </div>
            </div>
            </c:when>
            <c:otherwise>
            <div class="sub-area">
                <div class="gnb-profile">
                <c:choose>
                <c:when test="${mbrCualfCd eq code['CD100204_101501_업체담당자'] }">
                    <span class="gnb-profile-img"><img src="${pageContext.request.contextPath}/images/main/img_profile_default.jpg" alt="프로필 이미지" /></span>
                    <p class="gnb-profile-nm"><security:authentication property="principal.posCoNm" /></p>
                </c:when>
                <c:otherwise>
                    <c:choose>
                    <c:when test="${!empty profFileSer}">
                    <span class="gnb-profile-img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/main/img_profile_default.jpg'" alt="프로필 이미지" /></span>
                    </c:when>
                    <c:otherwise>
                    <span class="gnb-profile-img"><img src="${pageContext.request.contextPath}/images/main/img_profile_default.jpg" alt="프로필 이미지" /></span>
                    </c:otherwise>
                    </c:choose>
                    <p class="gnb-profile-nm"><security:authentication property="principal.username" /></p>
                    <a href="${pageContext.request.contextPath}/myPage/myInfo/profile.do" class="btn-setting">설정</a>
                </c:otherwise>
                </c:choose>
                </div>
            </div>
            </c:otherwise>
            </c:choose>
            <ul>
                <spring:eval expression="@mnuInfoService.getGlobalMnuInfo('${authCd}')" var="globalMenus" />
                <c:forEach items="${globalMenus}" var="item" varStatus="vs">
                    <li<c:if test="${vs.last}"> class="gnb-last"</c:if>>
                  <c:choose>
                    <c:when test="${not empty item.linkUrl}">
                        <a href="${pageContext.request.contextPath}${item.linkUrl}">${item.mnuNm}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:void(0)">${item.mnuNm}</a>
                    </c:otherwise>
                  </c:choose>
                  <c:if test="${!empty item.globalSubMnuInfos}">
                        <div class="sub-gnb smenu${vs.count}">
                            <ul>
                    <c:forEach items="${item.globalSubMnuInfos}" var="subItem">
                                <c:choose>
                                <c:when test="${not empty subItem.linkUrl}">
                                <li><a href="${pageContext.request.contextPath}${subItem.linkUrl}">${subItem.mnuNm}</a></li>
                                </c:when>
                                <c:otherwise>
                                <li><a href="javascript:alert('준비중입니다.');">${subItem.mnuNm}</a></li>
                                </c:otherwise>
                                </c:choose>
                    </c:forEach>
                            </ul>
                        </div>
                  </c:if>
                    </li>
                </c:forEach>
            </ul>
            <div class="gnb-notice">
                <c:choose>
                <c:when test="${not empty notifInfo}">
                <p><span class="gnb-date"><fmt:formatDate value="${notifInfo.regDtm}" pattern="yyyy.MM.dd"/></span>[알림] ${notifInfo.notifTitle}<a href="${pageContext.request.contextPath}/mentor/notifInfo/notifInfoList.do">더보기</a></p>
                </c:when>
                <c:otherwise>
                <p>새 알림이 없습니다. <a href="${pageContext.request.contextPath}/mentor/notifInfo/notifInfoList.do">알림내역 바로가기</a></p>
                </c:otherwise>
                </c:choose>
            </div>
        </div>
        </c:if>
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