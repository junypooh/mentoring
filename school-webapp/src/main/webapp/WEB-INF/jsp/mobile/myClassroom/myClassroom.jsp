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

<%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/userguide.css"> --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/mobile/css/my_lesson.css">

<form:form action="${pageContext.request.contextPath}/mobile/j_spring_security_logout.do" method="post" id="mLogout">
	<div id="header">
        <h1>나의 교실</h1>
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
                <li><a href="${pageContext.request.contextPath}/mobile/myClassroom/myClassroom.do"><span>나의 교실</span></a></li>
            </ul>
            <ul class="tab2">

                <li class="nth1">

                <a href="javascript:comfirmLogout();" class="logout" onclick="confirm('로그아웃 하시겠습니까?')"><span>로그아웃</span></a></li>
                <li class="nth2"><a href="javascript:goToPCVersion();"><span>PC버전</span></a></li>
                <li class="nth3"><a href="${pageContext.request.contextPath}/mobile/noticeList.do"><span>공지사항</span></a></li>
                <li class="nth4"><a href="${pageContext.request.contextPath}/mobile/setting.do" onClick="javascript:checkVersion();"><span>설정</span></a></li>
            </ul>
            <a href="#" class="slide-menu-close">전체메뉴 닫기</a>
        </div>
		<div class="dim" ></div>

    </div>
    <div id="ang"></div>
    <div id="container">
    <!-- content -->
        <div id="myClassroomInfoList" >

        </div>

    <!-- //content -->
    </div>
    <div class="cont-quick double">
        <a href="#ang"><img src="${pageContext.request.contextPath}/mobile/images/common/img_quick2.png" alt="상단으로 이동"></a>
    </div>
</form:form>
<script type="text/javascript" src="${pageContext.request.contextPath}/mobile/js/react/myClassroom.js"></script>

<script type="text/javascript">
function menuBtn(){
    $(".btn-slide-menu").click();
}

function search() {
  mentor.MyClassInfoList.getList(param);
}

function comfirmLogout(){
	 $('#mLogout').submit()
}

</script>

<script type="text/javascript">
mentor.myClassroomInfoList = React.render(
  React.createElement(MyClassInfoList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.myClassroomStudent.do', contextPath: mentor.contextpath, regStatCd:'101526'}),
  document.getElementById('myClassroomInfoList')
);
</script>


