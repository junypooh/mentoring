<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="schNm" property="principal.schNm" />
    <security:authentication var="clasNm" property="principal.clasNm" />
    <security:authentication var="mbrClassNm" property="principal.mbrClassNm" />
    <security:authentication var="mbrpropicInfos" property="principal.mbrpropicInfos" />
</security:authorize>
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();
}
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<div id="wrap">
<form:form action="${pageContext.request.contextPath}/mobile/j_spring_security_logout.do" method="post" id="mLogout">
	<div id="header">
			<h1>설정</h1>
			<a href="#" class="btn-slide-menu">전체메뉴 열기</a>
			<div class="slide-menu">
				<dl class="user-info">
					<dt class="name">${username}</dt>
					<dd class="img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${mbrpropicInfos[0].fileSer}" alt="${username}인물 사진"></dd>
					<dd class="info">
						 ${clasNm} ${mbrClassNm}
                    </dd>
				</dl>
				<ul class="tab">
					<li><a href="${pageContext.request.contextPath}/mobile/main.do"><span>나의 수업</span></a></li>
					<li><a href="${pageContext.request.contextPath}/mobile/lectureList.do"><span>멘토링 수업</span></a></li>
				</ul>                                               
				<ul class="tab2">
				
					<li class="nth1">
					
					<a href="javascript:setLoginComplite('N')" class="logout" onclick="confirm('로그아웃 하시겠습니까?')"><span>로그아웃</span></a></li>
					<li class="nth2"><a href="javascript:goToPCVersion();"><span>PC버전</span></a></li>
					<li class="nth3"><a href="${pageContext.request.contextPath}/mobile/noticeList.do"><span>공지사항</span></a></li>
					<li class="nth4"><a href="${pageContext.request.contextPath}/mobile/setting.do" onClick="javascript:checkVersion();"><span>설정</span></a></li>
				</ul>
				<a href="#" class="slide-menu-close">전체메뉴 닫기</a>
			</div>
		<div class="dim"></div>
		</div>
		<div id="container">
			<!-- content -->
		<div class="content">
			<ul class="setting-info">
				<li><a href="javascript:checkVersionForMarket();">버전 정보<span class="latest" id="new"></span> <span class="num" id="app_version">0</span></a></li>
				<%--<li><a href="${pageContext.request.contextPath}/mobile/noticeSetting.do" onClick="javascript:checkPushNoti();">알림 설정</a></li>--%>
			</ul>
			<div class="setting-box">
				<strong class="tit">약관</strong>
				<ul class="clause-wrap">
					<li><a href="javascript:goToUsageRule();">이용약관</a></li>
					<li><a href="javascript:goToPersonInfoRule();">개인정보 처리방침</a></li>
				</ul>
			</div>
		</div>
		<!-- //content -->
	</div>
</form:form>
</div>
<script type="text/javascript">
     function getLatestAppVersion(ver,icon){
		document.getElementById("app_version").innerHTML = ver;
		//if(icon == 'icon-new')
			document.getElementById("new").className = icon;
		//else
			//document.getElementById("new").className = icon;
     }
     
     function comfirmLogout(){
    	 $('#mLogout').submit()
     }
 </script>