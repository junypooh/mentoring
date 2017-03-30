<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="nowDate" pattern="yyyyMMdd"/>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="schNm" property="principal.schNm" />
    <security:authentication var="clasNm" property="principal.clasNm" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
    <security:authentication var="mbrClassNm" property="principal.mbrClassNm" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
    <security:authentication var="mbrpropicInfos" property="principal.mbrpropicInfos" />
</security:authorize>
        <div id="container">
			<div class="main-inner">
                <c:if test="${not empty id}">
				<!-- 로그인 시 노출 -->
				<div class="mylesson-area">
					<div class="profile-box">
					    <c:choose>
					    <c:when test="${!empty mbrpropicInfos and !empty mbrpropicInfos[fn:length(mbrpropicInfos)-1].fileSer}">
                        <span class="profile-img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${mbrpropicInfos[fn:length(mbrpropicInfos)-1].fileSer}" onerror="this.src='${pageContext.request.contextPath}/images/common/img_profile_default.jpg'" alt="${username}인물 사진"></span>
					    </c:when>
					    <c:otherwise>
						<span class="profile-img"><img src="${pageContext.request.contextPath}/images/common/img_profile_default.jpg" alt="프로필 사진" /></span>
					    </c:otherwise>
					    </c:choose>
						<p class="profile-nm">${username}</p>
						<c:choose>
						<c:when test="${empty clasNm}">
						<c:if test="${mbrCualfCd ne code['CD100204_100208_대학생'] and mbrCualfCd ne code['CD100204_100209_일반'] and mbrCualfCd ne code['CD100204_100210_일반_학부모_']}">
						<p class="profile-class">
							<a href="${pageContext.request.contextPath}/myPage/myClassroom/myClassroom.do"><span>나의교실정보등록</span></a>
						</p>
						</c:if>
						</c:when>
						<c:otherwise>
						<p class="profile-class">
							<span>${schNm}</span>
							<em>${clasNm}</em>
						</p>
						</c:otherwise>
						</c:choose>
						<button type="button" class="btn-profile-set" onclick="location.href= '${pageContext.request.contextPath}/myPage/myInfo/myInfoView.do'">프로필사진 수정</button>
					</div>
					<div class="weekly-lesson-area">
						<div class="weekly-top">
							<span id="dispDate"></span>
							<div class="weekly-btn">
								<button type="button" class="on" onClick="setSetSer(this,0)">오늘</button>
								<button type="button" onClick="setSetSer(this,6)">1주</button>
								<button type="button" onClick="setSetSer(this,13)">2주</button>
								<button type="button" class="btn-detail" onclick="location.href='${pageContext.request.contextPath}/lecture/lectureTotal/lectureList.do'">자세히 보기</button>
							</div>
						</div>
						<div class="weekly-slide-wrap" id="my-lesson-list">
                            <c:choose>
                            <c:when test="${empty myLessionList}">
							<div class="lesson-empty">
							    <p>수업이 없습니다.</p>
							</div>
                            </c:when>
                            <c:otherwise>
                            <ul class="weekly-slide">
                            <c:forEach items="${myLessionList}" var="item" varStatus="status">
                                <li>
                                    <p class="teacher-nm">${item.lectrNm}</p>
                                    <p class="lesson-title">${item.lectTitle}</p>
                                    <p class="lesson-date"><em>${fn:substring(item.lectDay,0,4)}-${fn:substring(item.lectDay,4,6)}-${fn:substring(item.lectDay,6,8)}</em> ${fn:substring(item.lectStartTime,0,2)}:${fn:substring(item.lectStartTime,2,4)}~${fn:substring(item.lectEndTime,0,2)}:${fn:substring(item.lectEndTime,2,4)} (${item.lectRunTime}분)</p>
                                    <c:choose>
                                    <c:when test="${item.lectStatCd eq code['CD101541_101549_수업대기'] or item.lectStatCd eq code['CD101541_101550_수업중']}">
                                        <a href="javascript:void(0)" class="ls-label" onClick="_fCallTomms('${item.lectSessId}','${item.clasRoomSer}')">입장</a>
                                    </c:when>
                                    <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${item.lectSer}&lectTims=${item.lectTims}&schdSeq=${item.schdSeq}" class="ls-label waiting">대기</a>
                                    </c:otherwise>
                                    </c:choose>
                                </li>
                            </c:forEach>
                            </ul>
                            <script type="text/javascript">
                                $('.weekly-slide').bxSlider({
                                    pager:false,
                                    minSlides:1,
                                    maxSlides:3,
                                    moveSlides:1,
                                    slideWidth:228,
                                    slideMargin:30,
                                    infiniteLoop:false,
                                    hideControlOnEnd: true
                                });
                            </script>
                            </c:otherwise>
                            </c:choose>
						</div>
					</div>
				</div>
				<!-- // 로그인 시 노출 -->
				</c:if>
				<div class="cont-top">
					<div class="carousel-wrap bx-sdw">
						<ul class="carousel-slide">
                            <c:forEach items="${bnrInfoList}" var="bnrInfo" varStatus="status">
                            <li><c:if test="${not empty bnrInfo.bnrLinkUrl}"><a href="${bnrInfo.bnrLinkUrl}"></c:if><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${bnrInfo.bnrImgUrl}&origin=true" onerror="this.src='${pageContext.request.contextPath}/images/main/carousel01.jpg'" alt="${bnrInfo.bnrDesc}" /><c:if test="${not empty bnrInfo.bnrLinkUrl}"></a></c:if></li>
                            </c:forEach>
						</ul>
					</div>
					<div class="ls-srch-area">
						<a href="${pageContext.request.contextPath}/lecture/lectureSchedule/lectureSch.do" class="banner-wrap"><img src="${pageContext.request.contextPath}/images/main/img_banner01.gif" alt="수업시간표 - 신청 가능한 수업을 확인하세요!" /></a>
						<div class="ls-srch-box bx-sdw">
							<h2><span>수업찾기</span></h2>
							<ul>
								<li><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureList.do?schoolGrd=101534" class="srch-elementary">초등학교</a></li>
								<li><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureList.do?schoolGrd=101535" class="srch-middle">중학교</a></li>
								<li><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureList.do?schoolGrd=101536" class="srch-high">고등학교</a></li>
							</ul>
							<div class="input-shch-box">
							    <form id="totalSearchForm" action="${pageContext.request.contextPath}/totalSearch.do">
								<input type="text" name="searchKey" placeholder="검색해보세요" />
								<button type="button" id="totalSearch">수업찾기 검색</button>
								</form>
							</div>
						</div>
					</div>
					<div class="lesson-slide-area">
						<ul class="lesson-tab">
							<li class="on" data="recomm">추천 수업</li>
							<li data="close">마감 임박 수업</li>
							<li data="new">신규 수업</li>
						</ul>
						<div class="lesson-slide-wrap">
                            <c:choose>
                            <c:when test="${empty recommandLecture}">
							<div class="lesson-empty">
								<p>${noLectMsg}</p>
							</div>
                            </c:when>
                            <c:otherwise>
							<!--PC버전 수업리스트 start-->
							<ul class="lesson-slide">
                                <c:forEach items="${recommandLecture}" var="item" varStatus="status">
                                <c:if test="${status.index%6 eq 0 or status.first}">
                                <li>
                                    <ul class="lesson-list">
                                </c:if>
                                        <li>
											<a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${item.lectSer}&lectTims=${item.lectTims}&schdSeq=${item.schdSeq}">
												<dl class="lesson-info">
													<dt class="mento"><strong>${item.lectrNm}</strong><em>${item.jobNm}</em></dt>
													<dd class="rating">
														<span class="ico-ls-type">${item.lectTypeCdNm}</span>
                                                        <c:if test="${fn:contains('101534,101537,101539,101540',item.lectTargtCd)}"><span class="icon-rating elementary">초</span></c:if>
                                                        <c:if test="${fn:contains('101535,101537,101538,101540',item.lectTargtCd)}"><span class="icon-rating middle">중</span></c:if>
                                                        <c:if test="${fn:contains('101536,101538,101539,101540',item.lectTargtCd)}"><span class="icon-rating high">고</span></c:if>
														<c:if test="${fn:contains('101713',item.lectTargtCd)}"><span class="icon-rating etc">기타</span></c:if>
													</dd>
													<dd class="date-time">
														<span class="date">${fn:substring(item.lectDay,0,4)}-${fn:substring(item.lectDay,4,6)}-${fn:substring(item.lectDay,6,8)}</span><span class="time">${fn:substring(item.lectStartTime,0,2)}:${fn:substring(item.lectStartTime,2,4)}~${fn:substring(item.lectEndTime,0,2)}:${fn:substring(item.lectEndTime,2,4)} (${item.lectRunTime}분)</span>
													</dd>
													<c:if test="${fn:contains('101543',item.lectStatCd)}"><c:set var="classColor" value="orange" /></c:if> <%-- 수강모집 --%>
													<c:if test="${fn:contains('101548',item.lectStatCd)}"><c:set var="classColor" value="yellow" /></c:if> <%-- 수업확정 --%>
													<c:if test="${fn:contains('101549,101550',item.lectStatCd)}"><c:set var="classColor" value="skyblue" /></c:if> <%-- 수업예정/수업중 --%>
													<c:if test="${fn:contains('101551',item.lectStatCd)}"><c:set var="classColor" value="" /></c:if> <%-- 수업완료 --%>
													<dd class="title"><span class="icon-lesson ${classColor}">${item.lectStatCdNm}</span><span>${item.lectTitle}</span></dd>
													<dd class="info"><p>${item.lectIntdcInfo}</p></dd>
													<dd class="image aspect"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.lectPicPath}" onerror="this.src='${pageContext.request.contextPath}/images/common/img_profile_default.jpg'" alt="${item.lectrNm} 인물 사진"></dd>
												</dl>
											</a>
                                        </li>
                                <c:if test="${status.index%6 eq 5 or status.last}">
                                    </ul>
                                </li>
                                </c:if>
                                </c:forEach>
							</ul>
							<!--PC버전 수업리스트 end-->

							<!--Mobile버전 수업리스트 start-->
							<ul class="mobile-slide">
							    <c:forEach items="${recommandLecture}" var="item" varStatus="status">
                                <li>
                                    <a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${item.lectSer}&lectTims=${item.lectTims}&schdSeq=${item.schdSeq}">
                                        <dl class="lesson-info">
                                            <dt class="mento"><strong>${item.lectrNm}</strong><em>${item.jobNm}</em></dt>
                                            <dd class="rating">
                                                <span class="ico-ls-type">${item.lectTypeCdNm}</span>
                                                <c:if test="${fn:contains('101534,101537,101539,101540',item.lectTargtCd)}"><span class="icon-rating elementary">초</span></c:if>
                                                <c:if test="${fn:contains('101535,101537,101538,101540',item.lectTargtCd)}"><span class="icon-rating middle">중</span></c:if>
                                                <c:if test="${fn:contains('101536,101538,101539,101540',item.lectTargtCd)}"><span class="icon-rating high">고</span></c:if>
                                                <c:if test="${fn:contains('101713',item.lectTargtCd)}"><span class="icon-rating etc">기타</span></c:if>
                                            </dd>
                                            <dd class="date-time">
                                                <span class="date">${fn:substring(item.lectDay,0,4)}-${fn:substring(item.lectDay,4,6)}-${fn:substring(item.lectDay,6,8)}</span><span class="time">${fn:substring(item.lectStartTime,0,2)}:${fn:substring(item.lectStartTime,2,4)}~${fn:substring(item.lectEndTime,0,2)}:${fn:substring(item.lectEndTime,2,4)} (${item.lectRunTime}분)</span>
                                            </dd>
                                            <c:if test="${fn:contains('101543',item.lectStatCd)}"><c:set var="classColor" value="orange" /></c:if> <%-- 수강모집 --%>
                                            <c:if test="${fn:contains('101548',item.lectStatCd)}"><c:set var="classColor" value="yellow" /></c:if> <%-- 수업확정 --%>
                                            <c:if test="${fn:contains('101549,101550',item.lectStatCd)}"><c:set var="classColor" value="skyblue" /></c:if> <%-- 수업예정/수업중 --%>
                                            <c:if test="${fn:contains('101551',item.lectStatCd)}"><c:set var="classColor" value="" /></c:if> <%-- 수업완료 --%>
                                            <dd class="title"><span class="icon-lesson ${classColor}">${item.lectStatCdNm}</span><span>${item.lectTitle}</span></dd>
                                            <dd class="info"><p>${item.lectIntdcInfo}</p></dd>
                                            <dd class="image aspect"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.lectPicPath}" onerror="this.src='${pageContext.request.contextPath}/images/common/img_profile_default.jpg'" alt="${item.lectrNm} 인물 사진"></dd>
                                        </dl>
                                    </a>
                                </li>
                                </c:forEach>
							</ul>
							<!--Mobile버전 수업리스트 end-->
				            </c:otherwise>
				            </c:choose>
						</div>
					</div>
				</div>
				<div class="cont-mid">
					<ul class="mentos-tab">
						<li>HOT멘토</li>
						<li>NEW멘토</li>
					</ul>
					<div class="mentos-cont">
						<h2><span>HOT</span> 멘토</h2>
						<div class="mento-slide-wrap">
                            <c:choose>
                            <c:when test="${empty hotMentors}">
							<div class="mento-empty">
								<p>멘토가 없습니다.</p>
							</div>
                            </c:when>
                            <c:otherwise>
							<ul class="hot-slide">
                                <c:forEach items="${hotMentors}" var="item" varStatus="status">
                                <c:if test="${status.index%4 eq 0 or status.first}">
                                <li>
                                    <ul class="hot-list">
                                </c:if>
                                        <li>
                                            <a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=${item.mbrNo}">
                                                <span class="mento-pic aspect">
                                                <c:choose>
                                                <c:when test="${not empty item.profFileSer}">
                                                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/common/img_profile_default.jpg'" alt="${item.jobNm} ${item.nm} 멘토 사진" />
                                                </c:when>
                                                <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/common/img_profile_default.jpg" alt="멘토 프로필 사진" />
                                                </c:otherwise>
                                                </c:choose>
                                                </span>
                                                <p class="mento-job">${item.jobNm}</p>
                                                <p class="mento-nm">${item.nm}</p>
                                                <p class="mento-desc">${item.intdcInfo}</p>
                                            </a>
                                        </li>
                                <c:if test="${status.index%4 eq 3 or status.last}">
                                    </ul>
                                </li>
                                </c:if>
                                </c:forEach>
							</ul>
                            </c:otherwise>
                            </c:choose>
						</div>
					</div>
					<div class="mentos-cont small">
						<h2><span>NEW</span> 멘토</h2>
						<div class="mento-slide-wrap">
                            <c:choose>
                            <c:when test="${empty mentorInfos}">
							<div class="mento-empty">
								<p>멘토가 없습니다.</p>
							</div>
                            </c:when>
                            <c:otherwise>
							<ul class="new-slide">
                                <c:forEach items="${mentorInfos}" var="item" varStatus="status">
                                <c:if test="${status.index%2 eq 0 or status.first}">
                                <li>
                                    <ul class="new-list">
                                </c:if>
                                        <li>
                                            <a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=${item.mbrNo}">
                                                <span class="mento-pic aspect">
                                                <c:choose>
                                                <c:when test="${not empty item.profFileSer}">
                                                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/common/img_profile_default.jpg'" alt="${item.jobNm} ${item.nm} 멘토 사진" />
                                                </c:when>
                                                <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/common/img_profile_default.jpg" alt="멘토 프로필 사진" />
                                                </c:otherwise>
                                                </c:choose>
                                                </span>
                                                <p class="mento-job">${item.jobNm}</p>
                                                <p class="mento-nm">${item.nm}</p>
                                                <p class="mento-desc">${item.profIntdcInfo}</p>
                                            </a>
                                        </li>
                                <c:if test="${status.index%2 eq 1 or status.last}">
                                    </ul>
                                </li>
                                </c:if>
                                </c:forEach>
							</ul>
                            </c:otherwise>
                            </c:choose>
						</div>
					</div>
				</div>
				<div class="cont-bot">
					<div class="active-mento-area">
						<h2>활동멘토</h2>
						<ul class="field-mento-list">
							<li><a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/listMentorIntroduce.do"><span class="txt-hid">전체</span><span class="count" id="totMCount">(0)</span></a></li>
							<c:set var="count" value="0" />
                            <c:forEach items="${listJobClsf}" var="each" varStatus="vs">
                            <c:set var="count" value="${count + each.mentorCnt}" />
                            <li data="${each.jobCd}|${each.jobNm}|${each.mentorCnt}"><a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/listMentorIntroduce.do?jobClsfCd=${each.jobCd}"><span class="txt-hid">${each.jobNm}</span><span class="count">(${each.mentorCnt})</span></a></li>
                            </c:forEach>
						</ul>
						<script type="text/javascript">
						    $('#totMCount').html('(' + ${count} + ')');
						</script>
					</div>
					<div class="main-board">
						<h2>공지사항</h2>
						<table class="mboard-tbl" id="notice-list">
							<caption>공지사항 목록</caption>
							<colgroup>
								<col>
								<col style="width:136px">
							</colgroup>
							<tbody>
                                <c:forEach items="${lecNoticeBoards}" var="item">
								<tr>
									<td class="title"><a href="${pageContext.request.contextPath}/guide/notice/noticeList.do?arclSer=${item.arclSer}" data="<fmt:formatDate value="${item.regDtm}" pattern="yyyy.MM.dd"/>"><c:out value="${item.title}" /></a></td>
									<td class="last"><fmt:formatDate value="${item.regDtm}" pattern="yyyy.MM.dd"/></td>
								</tr>
                                </c:forEach>
							</tbody>
						</table>
						<a href="${pageContext.request.contextPath}/guide/notice/noticeList.do" class="btn-mboard-more">공지사항 더보기</a>
					</div>
					<div class="main-board">
						<h2>Q &amp; A</h2>
						<table class="mboard-tbl" id="qna-list">
							<caption>Q &amp; A 목록</caption>
							<colgroup>
								<col>
								<col style="width:136px">
							</colgroup>
							<tbody>
                                <c:forEach items="${lecQnAs}" var="item">
								<tr>
									<td class="title"><a href="${pageContext.request.contextPath}/community/qna/qnaList.do?arclSer=${item.arclSer}" data="<fmt:formatDate value="${item.regDtm}" pattern="yyyy.MM.dd"/>"><c:out value="${item.title}" /></a></td>
									<td class="last"><fmt:formatDate value="${item.regDtm}" pattern="yyyy.MM.dd"/></td>
								</tr>
                                </c:forEach>
							</tbody>
						</table>
						<a href="${pageContext.request.contextPath}/community/qna/qnaList.do" class="btn-mboard-more">Q &amp; A 더보기</a>
					</div>
				</div>
			</div>
		</div>
		<div class="cont-quick double">
			<!--a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동"></a-->
			<a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동"></a>
		</div>

<script type="text/html" id="myLectureInfo">
<li>
    <p class="teacher-nm">\${lectrNm}</p>
    <p class="lesson-title">\${lectTitle}</p>
    <p class="lesson-date"><em>\${mentor.parseDate(lectDay).format('yyyy-MM-dd')}</em> \${mentor.parseTime(lectStartTime)}~\${mentor.parseTime(lectEndTime)} (\${lectRunTime}분)</p>
    {{if (lectStatCd == '${code['CD101541_101549_수업대기']}')||(lectStatCd == '${code['CD101541_101550_수업중']}')}}
    <a href="javascript:void(0)" class="ls-label" onClick="_fCallTomms('\${lectSessId}','\${clasRoomSer}')">입장</a>
    {{else}}
    <a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectSer}&lectTims=\${lectTims}&schdSeq=\${schdSeq}" class="ls-label waiting">대기</a>
    {{/if}}
</li>
</script>
<script type="text/javascript">

    $(document).ready(function(){

        //수업신청현황 날짜추가
        fnSetDispDate(0);

        $('.carousel-slide').bxSlider({
            auto: true,
            autoHover:true,
            autoControls: true,
            controls: false
        });
        $('.lesson-slide').bxSlider({
            pager:false
        });
        $('.mobile-slide').bxSlider({
            pager:false
        });
        $('.hot-slide').bxSlider({
            controls:false
        });
        $('.new-slide').bxSlider({
            controls:false
        });

        var windowW = $(window).width(),
               windowH = $(window).height();

         if (windowW <= 640){
             $('.lesson-slide').parent().parent('.bx-wrapper').hide();
             $('.mobile-slide').parent().parent('.bx-wrapper').show();
        } else {
            $('.mobile-slide').parent().parent('.bx-wrapper').hide();
            $('.lesson-slide').parent().parent('.bx-wrapper').show();
        }

        //수업현황 TAB 이벤트
        $('.lesson-tab > li').click(function(e) {
            e.preventDefault();
            $(this).siblings().removeClass('on');
            $(this).addClass('on');
            getLectrList($(this).attr('data'));
        });

        $('#totalSearch').click(function(e) {
            e.preventDefault();
            $(this).closest('form').submit()
        });

        $('#totalSearchForm').submit(function() {
            if (!!!this.searchKey.value || this.searchKey.value.trim().length < 2) {
                alert('검색은 2글자 이상 입력해야 합니다.');
                return false;
            }
        });

        //공지사항에 신규마크
        $("#notice-list td a").each(function(){
            var arclDate = mentor.parseDate($(this).attr('data'));
            if(arclDate > mentor.calDate(mentor.parseDate('${nowDate}'), 0, 0, -2)){
                $(this).addClass('new');
            }
        });
        //Q&A에 신규마크
        $("#qna-list td a").each(function(){
            var arclDate = mentor.parseDate($(this).attr('data'));
            if(arclDate > mentor.calDate(mentor.parseDate('${nowDate}'), 0, 0, -2)){
                $(this).addClass('new');
            }
        });


		//window.open ("${pageContext.request.contextPath}/notice.html","공지사항","scrollbars=yes,width=510px,height=650px,left=100px,top=180px");

    });

    function setSetSer(obj, setSer){
        $(obj).closest("div").find("button").removeClass("on");
        $(obj).addClass("on");
        getList(setSer);
    }

    function getList(setSer){
        $.ajax({
            url: "${pageContext.request.contextPath}/ajax.listAppliedLecture.do",
            data : {'setSer':setSer},
            success: function(rtnData) {
                $('#my-lesson-list').empty();
                if(rtnData != null && rtnData.length > 0) {
                    $('#my-lesson-list').append('<ul class="weekly-slide"></ul>');
                    $("#myLectureInfo").tmpl(rtnData).appendTo('.weekly-slide');

                    $('.weekly-slide').bxSlider({
                        pager:false,
                        minSlides:1,
                        maxSlides:3,
                        moveSlides:1,
                        slideWidth:228,
                        slideMargin:30,
                        infiniteLoop:false,
                        hideControlOnEnd: true
                    });
                } else {
                    $('#my-lesson-list').append('<div class="lesson-empty"><p>수업이 없습니다.</p></div>');
                }

                //수업신청현황 날짜추가
                fnSetDispDate(setSer);
            }
        });
    }

    function fnSetDispDate(setSer){
        var now = new Date();
        var afterDate = new Date(Date.parse(now) + setSer * 1000 * 60 * 60 * 24);

        var month = (now.getMonth()+1) + ""; // 문자형태
        if(month.length == "1") var month = "0" + month; // 두자리 정수형태

        var day = now.getDate() + ""; // 문자형태
        if(day.length == "1") var day = "0" + day; // 두자리 정수형태

        var week = new Array('일', '월', '화', '수', '목', '금', '토');

        if(setSer > 0){
            var afterMonth = (afterDate.getMonth()+1) + ""; // 문자형태
            if(afterMonth.length == "1") var afterMonth = "0" + afterMonth; // 두자리 정수형태

            var afterDay = afterDate.getDate() + ""; // 문자형태
            if(afterDay.length == "1") var afterDay = "0" + afterDay; // 두자리 정수형태

            $("#dispDate").html(now.getFullYear() + "-" + month + "-" + day + "(" +  week[now.getDay()] +") ~ "  + afterMonth + "-" + afterDay + "(" +  week[afterDate.getDay()] +")");
        }else{
            $("#dispDate").html(now.getFullYear() + "-" + month + "-" + day + "(" +  week[now.getDay()] +")");
        }
        $("#dispDate").show();
    }

    function getLectrList(type) {
        $.ajax({
            url: "${pageContext.request.contextPath}/ajax.lectureList.do",
            data : {'lectRunTime':type},
            dataType: 'HTML',
            success: function(rtnData) {
                $('.lesson-slide-wrap').empty().append($(rtnData).find('.lesson-slide-wrap').html());
                $('.lesson-slide').bxSlider({
                    pager:false
                });
                $('.mobile-slide').bxSlider({
                    pager:false
                });

                var windowW = $(window).width(),
                       windowH = $(window).height();

                 if (windowW <= 640){
                     $('.lesson-slide').parent().parent('.bx-wrapper').hide();
                     $('.mobile-slide').parent().parent('.bx-wrapper').show();
                } else {
                    $('.mobile-slide').parent().parent('.bx-wrapper').hide();
                    $('.lesson-slide').parent().parent('.bx-wrapper').show();
                }
            }
        });
    }

    function fn_lect_enter(lectSer, lectTims, schdSeq, clasRoomSer, setSer, lectSessId) {

        $.ajax({
            url: mentor.contextpath+"/myPage/myLecture/ajax.regObsvHist.do",
            data : {
                lectSer : lectSer,
                lectTims : lectTims,
                schdSeq : schdSeq,
                clasRoomSer : clasRoomSer,
                setSer : setSer
            },
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                _fCallTomms(lectSessId, clasRoomSer);
            },
            error: function(xhr, status, err) {
                console.error("ajax.regObsvHist.do", status, err.toString());
            }
        });
    }


</script>