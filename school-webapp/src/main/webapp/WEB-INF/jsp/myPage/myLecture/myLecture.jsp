<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="kr.or.career.mentor.domain.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
</security:authorize>
 <%
     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

     User user = (User) authentication.getPrincipal();
     String mbrClassCd = user.getMbrClassCd();
 %>

 <script type="text/javascript" src="${pageContext.request.contextPath}/js/react/myLecture.js"></script>

		<div id="container">
			<div class="location">
				<a href="${pageContext.request.contextPath}/" class="home">HOME</a>
				<span class="first">마이페이지</span>
				<span>나의수업</span>
			</div>
			<div class="content sub">
				<h2 class="txt-type">나의수업</h2>
				<p class="tit-desc-txt">나의 수업 신청 내용을 확인할 수 있습니다.</p>

				<div class="tab-action lesson-list">

                    <c:set var="tabClass" value="tab05"/>
                    <c:if test="${mbrClassCd == '100859' or mbrClassCd =='101707'}">
                        <c:set var="tabClass" value="tab06"/>
                    </c:if>
                    <ul class="tab-type1 ${tabClass} b-line">
                        <li class="active"><a href="#" id="lessonTab01">전체(00)</a></li>
                        <li><a href="#" id="lessonTab02">신청수업(00)</a></li>
                        <li><a href="#" id="lessonTab03">오늘의 수업(00)</a></li>
                        <li><a href="#" id="lessonTab04">수업완료(00)</a></li>
                        <li><a href="#" id="lessonTab05">수업취소(00)</a></li>
                        <c:if test="${mbrClassCd == '100859' or mbrClassCd =='101707'}">
                            <li><a href="#" id="lessonTab06">요청수업(00)</a></li>
                        </c:if>
					</ul>

                    <!-- 전체 -->
                    <div class="tab-action-cont" id="myLecutreList"></div>

				</div>

			</div>
		</div>

<a href="#layer1" class="layer-open" title="팝업 - 열기" id="layerOpen"></a>
<!-- layerpopup -->
<div id="layerPopupDiv">

</div>
 <script type="text/javascript">

     var mbrClassCd = ${mbrClassCd};  //권한변수
     $(document).ready(function(){

         $('#layerPopupDiv').load(function() {
             $('body').addClass('dim');
             $(".layer-pop-wrap").attr('tabindex',0).show().focus();
         });
     });

    function callbackApplLectApplInfo(){
        searchList();
    }

     function searchList(){
         mentor.myLecutreList.getList({'listType':mentor.activeTab, 'isMore':false});
     }

     mentor._callbackTabClick = function(idx){
         mentor.activeTab = idx;
         if(${isMobile}){
            searchList();
         }else{
            goPage(1);
         }
     }

     function goPage(curPage){
         mentor.myLecutreList.getList({'currentPageNo':curPage, 'listType':mentor.activeTab});
     }

 </script>

 <script type="text/javascript">
mentor.myLecutreList = React.render(
  React.createElement(MyLectureTab, {url:'${pageContext.request.contextPath}/myPage/myLecture/ajax.myLectureList.do'}),
  document.getElementById('myLecutreList')
);
</script>