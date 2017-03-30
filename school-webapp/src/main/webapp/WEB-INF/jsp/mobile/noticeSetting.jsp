<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="kr.or.career.mentor.domain.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

     User user = (User) authentication.getPrincipal();
     String mbrClassCd = user.getMbrClassCd();
 %>

<div id="wrap">
	<form:form action="${pageContext.request.contextPath}/mobile/j_spring_security_logout.do" method="post" id="mLogout">
		<div id="header">
			<h1>알림설정</h1><!-- 151124 modi -->
			<a href="${pageContext.request.contextPath}/mobile/setting.do" class="btn-pg-prev">이전 페이지로 가기</a><!-- 151124 modi -->
			<!-- 151124 del<a href="#" class="btn-slide-menu">전체메뉴 열기</a> -->
			<!-- slide menu -->
			<!-- <div class="slide-menu">
				<dl class="user-info">
					<dt class="name">김희재</dt>
					<dd class="img"><img src="./images/common/thumb_70x70_01.jpg" alt="김희재 인물사진"></dd>
					<dd class="info">이화여자대학교 사범대학 부속 이화&middot;금란고등학교</dd>
				</dl>
				<ul class="tab">
					<li><a href="#"><span>나의 수업</span></a></li>
					<li><a href="#"><span>멘토링 수업</span></a></li>
				</ul>
				<ul class="tab2">
				
					<li class="nth1">
					
					<a href="javascript:setLoginComplite('N')" class="logout" onclick="confirm('로그아웃 하시겠습니까?')"><span>로그아웃</span></a></li>
					<li class="nth2"><a href="javascript:goToPCVersion();"><span>PC버전</span></a></li>
					<li class="nth3"><a href="${pageContext.request.contextPath}/mobile/noticeList.do"><span>공지사항</span></a></li>
					<li class="nth4"><a href="${pageContext.request.contextPath}/mobile/setting.do" onClick="javascript:checkVersion();"><span>설정</span></a></li>
				</ul>
				<a href="#" class="slide-menu-close">전체메뉴 닫기</a>
			</div> -->
		<div class="dim"></div>
		</div>
		<div id="container">
				<!-- content -->
				<div class="content">
					<div class="setting-box">
						<strong class="tit">알림</strong>
						<ul class="norice-setting">
							<li><span>수업 알림</span>
									<c:choose>
									<c:when test="${studyAgree eq 'Y'}">
									<a href="javascript:studyPush();" class='btn-check on' id="studyPush"><span></span></a>
									</c:when>
									<c:otherwise>
									<a href="javascript:studyPush();" class='btn-check' id="studyPush"><span></span></a>
									</c:otherwise>
									</c:choose>
									 
							</li>
							<li><span>공지사항 알림</span>
								<c:choose>
									<c:when test="${noticeAgree eq 'Y'}">
									<a href="javascript:setPushAgreement();" class='btn-check on' id="noticePush"><span></span></a>
									</c:when>
									<c:otherwise>
									<a href="javascript:setPushAgreement();" class='btn-check' id="noticePush"><span></span></a>
									</c:otherwise>
								</c:choose>
							</li>
						</ul>
					</div>
				</div>
				<!-- //content -->
			</div>
	 </form:form>
</div>

<script type="text/javascript">

function setPushAgreement(){
	if(document.getElementById("noticePush").className=="btn-check on"){
    	 $.ajax({
    		    url: "${pageContext.request.contextPath}/mobile/ajax.agreementNotification.do",
    		    data : {code : '100992'},
    		    contentType: "application/json",
    		    dataType: 'json',
    		    cache: false,
    		    success: function(rtnData) {
    		    },
    		    error: function(xhr, status, err) {
    		      console.error(this.props.url, status, err.toString());
    		    }
    		  });
    	 
	}else if(document.getElementById("noticePush").className=="btn-check"){
		$.ajax({
		    url: "${pageContext.request.contextPath}/mobile/ajax.removeNotification.do",
		    data : {code : '100992'},
		    contentType: "application/json",
		    dataType: 'json',
		    cache: false,
		    success: function(rtnData) {
		    },
		    error: function(xhr, status, err) {
		      console.error(this.props.url, status, err.toString());
		    }
		  });
	}
}

function studyPush(){
	if(document.getElementById("studyPush").className=="btn-check on"){
   	 $.ajax({
		    url: "${pageContext.request.contextPath}/mobile/ajax.agreementNotification.do",
		    data : {code : '101680'},
		    contentType: "application/json",
		    dataType: 'json',
		    cache: false,
		    success: function(rtnData) {
		    },
		    error: function(xhr, status, err) {
		      console.error(this.props.url, status, err.toString());
		    }
		  });
	 
	}else if(document.getElementById("studyPush").className=="btn-check"){
		$.ajax({
		    url: "${pageContext.request.contextPath}/mobile/ajax.removeNotification.do",
		    data : {code : '101680'},
		    contentType: "application/json",
		    dataType: 'json',
		    cache: false,
		    success: function(rtnData) {
		    },
		    error: function(xhr, status, err) {
		      console.error(this.props.url, status, err.toString());
		    }
		  });
	}
}

 </script>
