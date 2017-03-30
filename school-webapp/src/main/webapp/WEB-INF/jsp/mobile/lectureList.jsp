<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="kr.or.career.mentor.domain.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
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

     User user = (User) authentication.getPrincipal();
     String mbrClassCd = user.getMbrClassCd();
 %>
 
 <script type="text/jsx;harmony=true" src="${pageContext.request.contextPath}/mobile/js/react/lectureList.js"></script>
	<div id="wrap">
	<form:form action="${pageContext.request.contextPath}/mobile/j_spring_security_logout.do" method="post" id="mLogout">
		<div id="header">
			<h1>멘토링수업</h1>
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
		<div id="ang">
		</div>
		<div id="container">
			<div class="content" id="lectureTabViewTotal"></div>
		</div>
		<div class="cont-quick double">
			<a href="#ang" style="height:44px;"><img src="./images/common/img_quick2.png" alt="상단으로 이동"></a>
		</div>
	 </form:form>
	</div>

		<!-- layerpopup -->
<!-- layerpopup -->
<div id="layerPopupDiv">

</div>
<script type="text/jsx;harmony=true">
mentor.lectureTabViewTotal = React.render(
  <LectureTabView url='${pageContext.request.contextPath}/lecture/lectureTotal/ajax.mobileMentorsLectureList.do'/>,
  document.getElementById('lectureTabViewTotal')
);
</script>
 <script type="text/javascript">
     var mbrClassCd = '<%=mbrClassCd %>';  //권한변수
     $(document).ready(function(){
         $('#layerPopupDiv').load(function() {
             $('body').addClass('dim');
             $(".layer-pop-wrap").attr('tabindex',0).show().focus();
         });
     });


     function searchList(){
//          mentor.myLecutreList.getList({'listType':mentor.activeTab, 'isMore':false});
     }
     
     function comfirmLogout(){
    	 $('#mLogout').submit()
     }
     
 function logout(){
// 	 alert('lotout');
	 $("#mlogoutFrm").attr("action", "${pageContext.request.contextPath}/mobile/j_spring_security_logout.do").submit();
// 	 alert('end');
 }
//      mentor._callbackTabClick = function(idx){
//          mentor.activeTab = idx;
//          searchList();
//      }
// 	function fn_login(){
// 		$("#logoutFrm").attr("action", ${pageContext.request.contextPath}+"/mobile/j_spring_security_logout.do").submit();
// 	}
 </script>