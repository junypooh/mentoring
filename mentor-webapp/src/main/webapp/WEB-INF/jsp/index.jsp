<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<spring:eval expression="T(kr.or.career.mentor.util.EgovProperties).getProperty('MENTORING_SCHOOL')" var="SCHOOL_DOMAIN" />
<c:if test="${not empty param.error and not empty SPRING_SECURITY_LAST_EXCEPTION}">
    <script type="text/javascript">
    $().ready(function() {
        alert('${SPRING_SECURITY_LAST_EXCEPTION.message}');
    });
    </script>
</c:if>
<div id="container">
	<div class="before-main">
		<div class="cont-top">
			<div class="login-area">
				<form:form action="${pageContext.request.contextPath}/j_spring_security_check.do" method="post">
					<fieldset>
						<legend>로그인 폼</legend>
						<div class="login-wrap">
							<label for="insertId">ID</label>
							<input type="text" name="username" placeholder="아이디 입력" class="input-text" placeholder="ID" />
							<label for="insertPw">PASSWORD</label>
							<input type="password" name="password" placeholder="비밀번호 입력" class="input-text" placeholder="PASSWORD" />
							<button type="submit" class="btn-login">로그인</button>
						</div>
						<div class="btn-box">
							<p>아직 멘토가 아니신가요?</p>
							<a href="${pageContext.request.contextPath}/useGuide/introduce/introduceBusiness.do" class="btn-intro">산들바람 소개</a>
							<a href="${pageContext.request.contextPath}/join/step1.do" class="btn-join">회원가입</a>
						</div>
					</fieldset>
				</form:form>
			</div>
			<div class="carousel-wrap">
				<ul class="carousel-slide">
				    <c:forEach items="${bnrInfoList}" var="bnrInfo" varStatus="status">
				    <li><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${bnrInfo.bnrImgUrl}&origin=true" onerror="this.src='${pageContext.request.contextPath}/images/main/carousel01.jpg'" alt="${bnrInfo.bnrDesc}" /></li>
				    </c:forEach>
				</ul>
			</div>
		</div>
		<div class="cont-middle">
			<div class="middle-fl">
			    <c:if test="${not empty noticeInfo}">
				<div class="notice-bar">
					<p><a href="${pageContext.request.contextPath}/useGuide/notice/noticeList.do?arclSer=${noticeInfo.arclSer}"><span class="notice-date"><fmt:formatDate value="${noticeInfo.regDtm}" pattern="yyyy-MM-dd"/></span> ${noticeInfo.title}</a> <a href="${pageContext.request.contextPath}/useGuide/notice/noticeList.do" class="btn-more">자세히보기</a></p>
				</div>
			    </c:if>
				<div class="mento-now">
					<h2>멘토 NOW</h2>
					<div class="now-wrap">
						<ul class="now-slide">
							<c:forEach items="${nowMentors}" var="item" varStatus="status">
							<c:if test="${status.index%6 eq 0 or status.first}">
							<li>
								<ul class="now-group">
							</c:if>
									<li>
										<a href="${SCHOOL_DOMAIN}mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=${item.mbrNo}" target="_blank">
											<span class="mt-pic">
											<c:choose>
											<c:when test="${not empty item.profFileSer}">
											<img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/active_mento/img_act_mento_default.jpg'" alt="${item.jobNm} ${item.nm} 멘토 사진" />
											</c:when>
											<c:otherwise>
											<img src="${pageContext.request.contextPath}/images/active_mento/img_act_mento_default.jpg" alt="멘토 프로필 사진" />
											</c:otherwise>
											</c:choose>
											</span>
											<p class="mt-info">
												<span class="mt-job">${item.jobNm}</span>
												<span class="mt-nm"><em>${item.nm}</em> 멘토</span>
												<span class="mt-desc">${item.lectTitle}</span>
											</p>
										</a>
									</li>
							<c:if test="${status.index%6 eq 5 or status.last}">
								</ul>
							</li>
							</c:if>
							</c:forEach>
						</ul>
					</div>
				</div>
			</div>
			<div class="hot-mento">
				<h2>HOT 멘토</h2>
				<div class="hot-wrap">
					<ul class="hot-slide">
                        <c:forEach items="${hotMentors}" var="item" varStatus="status">
                        <c:if test="${status.index%4 eq 0 or status.first}">
						<li>
                            <ul class="hot-group">
                        </c:if>
                                <li>
                                    <a href="${SCHOOL_DOMAIN}mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=${item.mbrNo}" target="_blank">
                                        <span class="mt-pic">
                                        <c:choose>
                                        <c:when test="${not empty item.profFileSer}">
                                        <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/active_mento/img_act_mento_default.jpg'" alt="${item.jobNm} ${item.nm} 멘토 사진" />
                                        </c:when>
                                        <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/images/active_mento/img_act_mento_default.jpg" alt="멘토 프로필 사진" />
                                        </c:otherwise>
                                        </c:choose>
                                        </span>
                                        <p class="mt-info">
                                            <span class="mt-job">${item.jobNm}</span>
                                            <span class="mt-nm"><em>${item.nm}</em> 멘토</span>
                                            <span class="mt-desc">${item.jobClsfNm}</span>
                                        </p>
                                    </a>
                                </li>
                        <c:if test="${status.index%4 eq 3 or status.last}">
                            </ul>
                        </li>
                        </c:if>
                        </c:forEach>
					</ul>
				</div>
			</div>
		</div>
		<div class="cont-bottom">
			<a href="javascript:void(0)" onclick="viewVideo()" class="bot-banner bn-sample-video">
				<strong>멘토링 샘플영상</strong>
				<p>원격영상진로멘토링 수업의 생생한 현장을 영상을 통해 알아보세요!</p>
			</a>
			<a href="javascript:void(0)" onclick="alert('서비스 준비중입니다');" class="bot-banner bn-remote-video">
				<strong>원격진로멘토링</strong>
				<p>FACEBOOK 멘토그룹</p>
			</a>
		</div>
	</div>
</div>
<script type="text/javascript">
	$('.now-slide').bxSlider({
		controls: false
	});
	$('.hot-slide').bxSlider({
		pager: false
	});
	$('.carousel-slide').bxSlider({ //배너 하나일 경우 롤링/옵션 동작안함
		auto: ($(".carousel-slide li").length > 1) ? true: false,
		autoHover: ($(".carousel-slide li").length > 1) ? true: false,
		autoControls: ($(".carousel-slide li").length > 1) ? true: false,
		pager: ($(".carousel-slide li").length > 1) ? true: false
	});

	function viewVideo() {
	    window.open ("${pageContext.request.contextPath}/layer/popupMoviePlay.do?cId=14418","sampleVideo","scrollbars=no,width=710px,height=630px,left=20px,top=180px");
	}
</script>