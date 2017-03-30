<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="kr.or.career.mentor.domain.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
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
<script type="text/javascript">
    $(document).ready(function(){
    	$("#lesson-detail-txt-view").load("${pageContext.request.contextPath}/lecture/lectureTotal/tabLectureInfoForMobile.do?lectSer="+"${lectSchdInfo.lectSer}"+"&lectTims="+"${lectSchdInfo.lectTims}");
    });

    function fn_errorMsg(sValue){
        switch (sValue){
            case 'lectureApply' : alert("수업신청은 교사만 가능합니다."); break;
            case 'lectureApplyWait' : alert("수업신청대기는 교사만 가능합니다."); break;
        }
    }

    //참관용
    function callTomms(){
    	var apisvr = "http://61.36.98.130:28080";
    	var permission = "P";
    	var obj = "{\"apisvr\":\"http://112.175.92.241:18080\",\"userid\":\"${mbrNo}\",\"permission\":\"P\",\"confid\":\""+${lectSessId}+"\"}";
    	startTomms(obj);
    }
    
</script>
		<div id="wrap">
		<form:form action="${pageContext.request.contextPath}/mobile/j_spring_security_logout.do" method="post" id="mLogout">
			<div id="header">
			<h1>수업상세</h1>
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
				<!-- content -->
				<div class="content">
					<c:choose>
						<c:when test="${lectSessId gt '0' && lectInfo.lectTimsInfo.lectStatCd == '101550'}">
						    <div class="lesson-go-wrap visit">
					  			<a href="javascript:callTomms();"><span>참관</span></a> 
					  		</div> 
						</c:when>
						<c:otherwise> 
						    
						</c:otherwise>
					</c:choose>
					
					<div class="lesson-detail-wrap">
						<h2><strong class="stit">
							<c:if test="${lectInfo.lectTypeCd ne code['CD101528_101529_단강']}">
								[${lectInfo.lectTypeCdNm}]
							</c:if>
							${lectInfo.lectTitle}<span>${lectSchdInfo.lectStatCdNm}</span></strong></h2>
						<div class="lesson-detail-thumb">
							<div class="thumb-list">
								<ul>
									<c:forEach items="${lectPicInfoList}" var="lectPicInfo" varStatus="vs">
										<li><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${lectPicInfo.fileSer}" alt="사진${vs.count}"/></li>
									</c:forEach>
								</ul>
							</div>
							<div class="thum-paging"></div>
						</div>
						<p class="lesson-detail-txt" id="lesson-detail-txt-view"></p>
						<ul class="lesson-detail-info">
							<li>
								<span>멘토</span>
								<p>${mentorInfo.nm}
												<c:if test="${lectInfo.iconKindCd eq code['CD101597_101598_재능기부']}">
												<span class="ic-box-round">
													<span class="don">재능기부</span>
												</span>
												</c:if>
									
								</p>
							</li>
							<li>
								<strong>일시</strong>
								<div>
									<ul>
										<c:forEach var="schdInfo" items="${lectSchdInfoList}">
											<fmt:parseDate value="${schdInfo.lectDay}" var="lectDay" pattern="yyyyMMdd"/>
											<fmt:parseDate value="${schdInfo.lectStartTime}" var="lectStartTime" pattern="HHmm"/>
											<fmt:parseDate value="${schdInfo.lectEndTime}" var="lectEndTime" pattern="HHmm"/>
											<li>
												<c:if test="${schdInfo.schdSeq eq lectSchdInfo.schdSeq}">
													<strong>
												</c:if>
												<fmt:formatDate value="${lectDay}" pattern="yyyy.MM.dd"/> <fmt:formatDate value="${lectStartTime}" pattern="HH:mm"/> ~ <fmt:formatDate value="${lectEndTime}" pattern="HH:mm"/>
												<c:if test="${schdInfo.schdSeq eq lectSchdInfo.schdSeq}">
													</strong>
												</c:if>
											</li>
										</c:forEach>
									</ul>
								</div>
							</li>
							<li>
								<span>대상</span>
								<p>
								<c:choose>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101534_초등학교']}">
														<span class="icon-rating elementary">초</span>
													</c:when>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101535_중학교']}">
														<span class="icon-rating middle">중</span>
													</c:when>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101536_고등학교']}">
														<span class="icon-rating high">고</span>
													</c:when>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101537_초등_중학교']}">
														<span class="icon-rating elementary">초</span>
														<span class="icon-rating middle">중</span>
													</c:when>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101538_중_고등학교']}">
														<span class="icon-rating middle">중</span>
														<span class="icon-rating high">고</span>
													</c:when>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101539_초등_고등학교']}">
														<span class="icon-rating elementary">초</span>
														<span class="icon-rating high">고</span>
													</c:when>
													<c:when test="${lectInfo.lectTargtCd eq code['CD101533_101540_초등_중_고등학교']}">
														<span class="icon-rating elementary">초</span>
														<span class="icon-rating middle">중</span>
														<span class="icon-rating high">고</span>
													</c:when>
												</c:choose>

								</p>
							</li>
							<li>
								<span>태그</span><p>${lectInfo.jobTagInfo}</p>
							</li>
						</ul>
					</div>
				</div>
				<!-- //content -->
			</div>
			<div class="cont-quick double">
				<!--a href="${pageContext.request.contextPath}/mobile/lectureList.do"><img src="./images/common/img_quick3.png" alt="리스트로 이동"></a-->
				<a href="#ang"><img src="./images/common/img_quick2.png" alt="상단으로 이동"></a>
			</div>
		</form:form>
		</div>
		<script>
		$(".thumb-list").touchSlider({
			flexible : true,
			initComplete : function (e) {
				$(".thum-paging").html("");
				var num = 1;
				$(".thumb-list ul li").each(function (i, el) {
					if((i+1) % e._view == 0) {
						$(".thum-paging").append('<button type="button" class="btn-page">사진' + (num++) + '</button>');
					}
				});
				$(".btn-page").bind("click", function (e) {
					var i = $(this).index();
					$(".thumb-list").get(0).go_page(i);
				});
			},
			counter : function (e) {
				$(".thum-paging .btn-page").removeClass("on").eq(e.current-1).addClass("on");
			}
		});
		</script>
		
<script type="text/javascript">
    
     function comfirmLogout(){
    	 $('#mLogout').submit()
     }

 </script>