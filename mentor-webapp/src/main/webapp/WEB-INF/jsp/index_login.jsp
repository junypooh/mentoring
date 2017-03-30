<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="nowDate" pattern="yyyyMMdd"/>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
    <security:authentication var="authCd" property="principal.authCd" />
    <security:authentication var="posCoNm" property="principal.posCoNm" />
    <security:authentication var="profFileSer" property="principal.profFileSer" />
</security:authorize>

<div id="container">
	<div class="after-main">
		<div class="status-area">
			<div class="profile-box">
            <c:choose>
                <c:when test="${mbrCualfCd eq code['CD100204_101501_업체담당자'] }">
				<span class="profile-pic"><img src="${pageContext.request.contextPath}/images/main/img_profile_default.jpg" alt="프로필 이미지" /></span>
				<p class="profile-nm"><security:authentication property="principal.posCoNm" /></p>
				<p class="total-lesson">총 누적수업 <strong>${totLectInfo.finishLect}</strong>건</p>
                </c:when>
                <c:otherwise>
				<span class="profile-pic"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/main/img_profile_default.jpg'" alt="프로필 이미지" /></span>
				<p class="profile-nm"><security:authentication property="principal.username" /></p>
				<p class="total-lesson">총 누적수업 <strong>${totLectInfo.finishLect}</strong>건</p>
				<a href="${pageContext.request.contextPath}/myPage/myInfo/profile.do" class="btn-setting">설정</a>
                </c:otherwise>
            </c:choose>
			</div>
			<c:choose>
			<c:when test="${mbrCualfCd eq code['CD100204_101501_업체담당자'] }">
			<!-- 교육수행기관일 때 -->
			<div class="lesson-state full">
				<p class="lead-title">한달간 수업개설</p>
				<ul>
					<li>
						<strong class="gray">${monthLectInfo.openWaitLect}</strong>
						<p>오픈대기</p>
					</li>
					<li>
						<strong class="gray">${monthLectInfo.applLect}</strong>
						<p>수강모집</p>
					</li>
					<li>
						<strong>${monthLectInfo.expectLect}</strong>
						<p>수업예정</p>
					</li>
					<li>
						<strong>${monthLectInfo.cancelLect}</strong>
						<p>수업취소</p>
					</li>
					<li>
						<strong>${monthLectInfo.closeLect}</strong>
						<p>수업폐강</p>
					</li>
					<li>
						<strong>${monthLectInfo.finishLect}</strong>
						<p>수업완료</p>
					</li>
				</ul>
			</div>
			</c:when>
			<c:otherwise>
			<!-- 개인멘토일 때-->
			<div class="lesson-state">
				<p class="lead-title">올해의 수업개설</p>
				<ul>
					<li>
						<strong class="gray"><a href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqList.do">${totLectReqInfo.applCnt}</a></strong>
						<p>검토중</p>
					</li>
					<li>
						<strong><a href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqList.do">${totLectReqInfo.apprCnt}</a></strong>
						<p>승인</p>
					</li>
					<li>
						<strong class="pink"><a href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqList.do">${totLectReqInfo.rjtCnt}</a></strong>
						<p><span class="pink">반려</span><c:if test="${totLectReqInfo.rjtCnt gt 0}"><a href="#rejectPop" class="layer-open">사유</a></c:if></p>
					</li>
				</ul>
			</div>
			<div class="lesson-state">
				<p class="lead-title">한달간 수업현황</p>
				<ul>
					<li>
						<strong class="gray"><a href="${pageContext.request.contextPath}/lecture/lectureState/mentorLectList.do?tab=lessonTab02">${monthLectInfo.applLect}</a></strong>
						<p>수강모집중</p>
					</li>
					<li>
						<strong><a href="${pageContext.request.contextPath}/lecture/lectureState/mentorLectList.do?tab=lessonTab03">${monthLectInfo.expectLect}</a></strong>
						<p>수업예정</p>
					</li>
					<li>
						<strong><a href="${pageContext.request.contextPath}/lecture/lectureState/mentorLectList.do?tab=lessonTab05">${monthLectInfo.finishLect}</a></strong>
						<p>수업완료</p>
					</li>
				</ul>
			</div>
			</c:otherwise>
			</c:choose>
		</div>
		<div class="weekly-area">
			<div class="weekly-info">
			    <c:forEach items="${calendarInfos}" var="item" varStatus="status">
			    <c:if test="${status.first}"><span>${item.year}년</span> ${item.month}월 ${item.day}일 ~</c:if> <c:if test="${status.last}">${item.month}월 ${item.day}일</c:if>
			    </c:forEach>
				<a href="javascript:void(0)" onclick="beforeWeek()" class="week-prev">이전 주</a>
				<a href="javascript:void(0)" onclick="nextWeek()" class="week-next">다음 주</a>
			</div>
			<ul class="daily-tab">
			    <c:forEach items="${calendarInfos}" var="item" varStatus="status">
			    <li<c:if test="${nowDate eq item.strDay}"> class="on"</c:if> data="${item.strDay}" onclick="drawLectureInfo('${item.strDay}', $(this))">${item.date}</li>
			    </c:forEach>
			</ul>
			<div class="daily-tab-cont">
				<div class="tab-cont-wrap">
				    <c:choose>
				    <c:when test="${empty lectureInfos}">
					<div class="lesson-empty">
						<p>해당 날짜에 수업이 없습니다.</p>
					</div>
				    </c:when>
				    <c:otherwise>
					<ul class="lesson-list">
					    <c:forEach items="${lectureInfos}" var="item" varStatus="status">
						<li>
							<p class="lesson-time"><span class="count">${item.rn} / ${fn:length(lectureInfos)}</span> <fmt:formatDate value="${cnet:parseTime(item.lectStartTime)}" pattern="HH:mm"/>~<fmt:formatDate value="${cnet:parseTime(item.lectEndTime)}" pattern="HH:mm"/></p>
							<strong class="lesson-title">[${item.lectTypeNm}] ${item.lectTitle}</strong>
							<p class="lesson-mento">${item.lectrNm}</p>
							<div class="lesson-info">
								<ul class="level-label">
								    <c:choose>
								    <c:when test="${item.lectTargtCd eq '101534'}">
								    <li class="elementary">초</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101535'}">
								    <li class="middle">중</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101536'}">
								    <li class="high">고</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101537'}">
									<li class="elementary">초</li>
									<li class="middle">중</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101538'}">
									<li class="middle">중</li>
									<li class="high">고</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101539'}">
									<li class="elementary">초</li>
									<li class="high">고</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101540'}">
									<li class="elementary">초</li>
									<li class="middle">중</li>
									<li class="high">고</li>
								    </c:when>
								    <c:when test="${item.lectTargtCd eq '101713'}">
								    <li class="etc">기타</li>
								    </c:when>
								    </c:choose>
								</ul>
								<p><span class="request">신청 ${item.applCnt}/${item.maxApplCnt}</span><span class="visit">참관 ${item.obsvCnt}/${item.maxObsvCnt}</span></p>
							</div>
							<c:if test="${item.lectStatCd eq '101549' or item.lectStatCd eq '101550'}">
							<button type="button" class="btn-enter" onClick="_fCallTomms('${item.lectSessId}')">입장</button>
							</c:if>
						</li>
					    </c:forEach>
					</ul>
				    </c:otherwise>
				    </c:choose>
				</div>
			</div>
		</div>
		<div class="main-board">
			<p class="mboard-title">질문답변</p>
			<table class="mboard-tbl">
				<caption>질문답변 목록</caption>
				<colgroup>
					<col style="width:45px;" />
					<col style="width:73px;" />
					<col style="width:87px;" />
					<col />
					<col style="width:82px;" />
					<col style="width:80px;" />
					<col style="width:80px;" />
					<col style="width:145px;" />
					<col style="width:90px;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" class="first">번호</th>
						<th scope="col">답변여부</th>
						<th scope="col">문의유형</th>
						<th scope="col">제목</th>
						<th scope="col">회원유형</th>
						<th scope="col">등록자</th>
						<th scope="col">지역</th>
						<th scope="col">학교</th>
						<th scope="col" class="last">등록일</th>
					</tr>
				</thead>
				<tbody>
				    <c:if test="${empty lecQnAInfos}">
				    <tr>
				        <td colspan="9">미답변 질문이 없습니다.</td>
				    </tr>
				    </c:if>
				    <c:forEach items="${lecQnAInfos}" var="item" varStatus="status">
					<tr>
						<td class="first">${fn:length(lecQnAInfos) - item.rn + 1}</td>
						<td>
						    <c:choose>
						    <c:when test="${item.ansYn eq 'Y'}">
						    답변
						    </c:when>
						    <c:otherwise>
						    미답변
						    </c:otherwise>
						    </c:choose>
						</td>
						<td>${item.prefNm}</td>
						<td class="td-title"><a href="${pageContext.request.contextPath}/community/qna/qnaList.do?arclSer=${item.arclSer}">${item.title}</a></td>
						<td>
						    <c:choose>
						    <c:when test="${item.regClassNm eq 'teacher'}">
						    교사
						    </c:when>
						    <c:when test="${item.regClassNm eq 'mentor'}">
						    멘토
						    </c:when>
						    <c:otherwise>
						    학생
						    </c:otherwise>
						    </c:choose>
						</td>
						<td>${item.regMbrNm}</td>
						<td>${item.sidoNm}</td>
						<td>${item.schNm}</td>
						<td class="last"><fmt:formatDate value="${item.regDtm}" pattern="yyyy-MM-dd"/></span></td>
					</tr>
				    </c:forEach>
				</tbody>
			</table>
			<a href="${pageContext.request.contextPath}/community/qna/qnaList.do" class="btn-more">질문답변 더보기</a>
		</div>
		<div class="main-board">
			<p class="mboard-title">수업과제</p>
			<table class="mboard-tbl">
				<caption>수업과제 목록</caption>
				<colgroup>
					<col style="width:45px;" />
					<col style="width:73px;" />
					<col style="width:87px;" />
					<col />
					<col style="width:82px;" />
					<col style="width:80px;" />
					<col style="width:80px;" />
					<col style="width:145px;" />
					<col style="width:90px;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class="first">번호</th>
						<th scope="row">답변여부</th>
						<th scope="row">수업일</th>
						<th scope="row">제목</th>
						<th scope="row">회원유형</th>
						<th scope="row">등록자</th>
						<th scope="row">지역</th>
						<th scope="row">학교</th>
						<th scope="row" class="last">등록일</th>
					</tr>
				</thead>
				<tbody>
				    <c:if test="${empty lecWorkInfos}">
				    <tr>
				        <td colspan="9">미답변 수업과제가 없습니다.</td>
				    </tr>
				    </c:if>
				    <c:forEach items="${lecWorkInfos}" var="item" varStatus="status">
					<tr>
						<td class="first">${fn:length(lecWorkInfos) - item.rn + 1}</td>
						<td>
						    <c:choose>
						    <c:when test="${item.ansYn eq 'Y'}">
						    답변
						    </c:when>
						    <c:otherwise>
						    미답변
						    </c:otherwise>
						    </c:choose>
						</td>
						<td>${cnet:stringToDatePattern(item.lectDay, 'yyyy.MM.dd')}</td>
						<td class="td-title"><a href="${pageContext.request.contextPath}/community/work/workList.do?arclSer=${item.arclSer}">${item.lectTitle}</a></td>
						<td>
						    <c:choose>
						    <c:when test="${item.regClassNm eq 'teacher'}">
						    교사
						    </c:when>
						    <c:when test="${item.regClassNm eq 'mentor'}">
						    멘토
						    </c:when>
						    <c:otherwise>
						    학생
						    </c:otherwise>
						    </c:choose>
						</td>
						<td>${item.regMbrNm}</td>
						<td>${item.sidoNm}</td>
						<td>${item.schNm}</td>
						<td class="last"><fmt:formatDate value="${item.regDtm}" pattern="yyyy-MM-dd"/></span></td>
					</tr>
				    </c:forEach>
				</tbody>
			</table>
			<a href="${pageContext.request.contextPath}/community/work/workList.do" class="btn-more">수업과제 더보기</a>
		</div>
		<div class="main-board s-board fl">
			<p class="mboard-title">요청수업</p>
			<table class="mboard-tbl">
				<caption>요청수업 목록</caption>
				<colgroup>
					<col />
					<col style="width:92px" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class="first">주제</th>
						<th scope="row" class="last">등록일</th>
					</tr>
				</thead>
				<tbody>
				    <c:if test="${empty lectReqInfos}">
				    <tr>
				        <td colspan="2">요청 수업이 없습니다.</td>
				    </tr>
				    </c:if>
				    <c:forEach items="${lectReqInfos}" var="item" varStatus="status">
					<tr>
						<td class="first td-title"><a href="javascript:alert('준비중입니다.');">${item.lectTitle}</a></td>
						<td class="last"><fmt:formatDate value="${item.reqDtm}" pattern="yyyy-MM-dd"/></td>
					</tr>
				    </c:forEach>
				</tbody>
			</table>
			<a href="javascript:alert('준비중입니다.');" class="btn-more">요청수업 더보기</a>
		</div>
		<div class="main-board s-board fr">
			<p class="mboard-title">공지사항</p>
			<table class="mboard-tbl">
				<caption>공지사항 목록</caption>
				<colgroup>
					<col />
					<col style="width:92px" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class="first">공지</th>
						<th scope="row" class="last">등록일</th>
					</tr>
				</thead>
				<tbody>
				    <c:if test="${empty noticeInfos}">
				    <tr>
				        <td colspan="2">등록된 공지사항이 없습니다.</td>
				    </tr>
				    </c:if>
				    <c:forEach items="${noticeInfos}" var="item" varStatus="status">
					<tr>
						<td class="first td-title"><a href="${pageContext.request.contextPath}/useGuide/notice/noticeList.do?arclSer=${item.arclSer}">${item.title}</a></td>
						<td class="last"><fmt:formatDate value="${item.regDtm}" pattern="yyyy-MM-dd"/></td>
					</tr>
				    </c:forEach>
				</tbody>
			</table>
			<a href="${pageContext.request.contextPath}/useGuide/notice/noticeList.do" class="btn-more">공지사항 더보기</a>
		</div>
	</div>
</div>

<div class="layer-pop-wrap w480" id="rejectPop">
    <div class="title">
        <strong>알림</strong>
        <a href="javascript:void(0)" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont board">
        <div class="box-style alert">
            <div class="alert-set-wrap">
                <c:forEach items="${lectReqRejectList}" var="item" varStatus="status">
                <div class="alert-set">
                    <p class="alert-date"><fmt:formatDate value="${item.procDtm}" pattern="yyyy.MM.dd"/></p>
                    <p class="alert-txt">[수업개설 반려] 개설 신청 하신 수업이 반려되었습니다. </p>
                    <div class="alert-desc">
                        <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(item.procSust)"></spring:eval>
                    </div>
                    <%--p class="alert-memo">${username} 선생님<br />수업과 관련하여 따로 연락 드리도록 하겠습니다.</p--%>
                </div>
                </c:forEach>
            </div>
        </div>
        <div class="btn-area">
            <a href="javascript:void(0)" onclick="$('.pop-close').click()" class="btn-type2">닫기</a>
        </div>
    </div>
</div>
<%-- Template ================================================================================ --%>
<script type="text/html" id="listLectureInfo">
    <li>
        <p class="lesson-time"><span class="count">\${rn} / \${totalCount}</span> \${to_time_format(lectStartTime, ':')}~\${to_time_format(lectEndTime, ':')}</p>
        <strong class="lesson-title">[\${lectTypeNm}] \${lectTitle}</strong>
        <p class="lesson-mento">\${lectrNm}</p>
        <div class="lesson-info">
            <ul class="level-label">
                {{if lectTargtCd == '101534'}}
                    <li class="elementary">초</li>
                {{/if}}
                {{if lectTargtCd == '101535'}}
                    <li class="middle">중</li>
                {{/if}}
                {{if lectTargtCd == '101536'}}
                    <li class="high">고</li>
                {{/if}}
                {{if lectTargtCd == '101537'}}
                    <li class="elementary">초</li>
                    <li class="middle">중</li>
                {{/if}}
                {{if lectTargtCd == '101538'}}
                    <li class="middle">중</li>
                    <li class="high">고</li>
                {{/if}}
                {{if lectTargtCd == '101539'}}
                    <li class="elementary">초</li>
                    <li class="high">고</li>
                {{/if}}
                {{if lectTargtCd == '101540'}}
                    <li class="elementary">초</li>
                    <li class="middle">중</li>
                    <li class="high">고</li>
                {{/if}}
                {{if lectTargtCd == '101713'}}
                    <li class="etc">기타</li>
                {{/if}}
            </ul>
            <p><span class="request">신청 \${applCnt}/\${maxApplCnt}</span><span class="visit">참관 \${obsvCnt}/\${maxObsvCnt}</span></p>
        </div>
        {{if lectStatCd == '101549' || lectStatCd == '101550'}}
        <button type="button" class="btn-enter" onClick="_fCallTomms('\${lectSessId}')">입장</button>
        {{/if}}
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/javascript">
    // 날짜 Tab 활성화
    function dailyTabSetting() {
        var classOn = false;
        $('.daily-tab').find('li').each(function() {
            if(getToday() == $(this).attr('data')) {
                $(this).addClass('on');
            }
            if($(this).hasClass('on')) {
                classOn = true;
            }
        });

        if(!classOn) {
            $('.daily-tab > li').eq(0).addClass('on');
        }
    }

    dailyTabSetting();

    // 다음 주 클릭
    function nextWeek() {
        var searchDate = $('.daily-tab > li').eq(6).attr('data');
        searchDate = mentor.calDate(mentor.parseDate(searchDate), 0, 0, 1).format("yyyyMMdd");
        drawWeekDate(searchDate);
    }

    // 이전 주 클릭
    function beforeWeek() {
        var searchDate = $('.daily-tab > li').eq(0).attr('data');
        searchDate = mentor.calDate(mentor.parseDate(searchDate), 0, 0, -1).format("yyyyMMdd");
        drawWeekDate(searchDate);
    }

    // 날짜 갱신
    function drawWeekDate(searchDate) {

        $.ajax({
            url: '${pageContext.request.contextPath}/main/ajax.weekDateInfo.do',
            data : {searchDate: searchDate},
            success: function(rtnData) {

                var weekInfoHtml = '';
                var dailyInfoHtml = '';
                $.each(rtnData, function(idx) {
                    if(idx == 0) {
                        weekInfoHtml += '<span>'+this.year+'년</span> '+this.month+'월 '+this.day+'일 ~ ';
                    }
                    if(idx == 6) {
                        weekInfoHtml += this.month+'월 '+this.day+'일';
                    }

                    dailyInfoHtml += '<li data="'+this.strDay+'" onclick="drawLectureInfo(\''+this.strDay+'\', $(this))">'+this.date+'</li>';
                });

                weekInfoHtml += '<a href="javascript:void(0)" onclick="beforeWeek()" class="week-prev">이전 주</a>';
                weekInfoHtml += '<a href="javascript:void(0)" onclick="nextWeek()" class="week-next">다음 주</a>';

                $('.weekly-info').empty();
                $('.weekly-info').append(weekInfoHtml);

                $('.daily-tab').empty();
                $('.daily-tab').append(dailyInfoHtml);

                // 날짜 Tab 활성화
                dailyTabSetting();

                // 활성화 된 날짜 가져오기
                $('.daily-tab').find('li').each(function() {
                    if($(this).hasClass('on')) {
                       drawLectureInfo($(this).attr('data'), $(this));
                    }
                });
            }
        });
    }

    // 수업정보 갱신
    function drawLectureInfo(searchDate, obj) {
        $('.daily-tab').find('li').each(function() {
            $(this).removeClass('on');
        });
        obj.addClass('on');

        $.ajax({
            url: '${pageContext.request.contextPath}/main/ajax.lectureInfo.do',
            data : {searchStDate: searchDate, searchEndDate: searchDate},
            success: function(rtnData) {

                $.each(rtnData, function() {
                    this.totalCount = rtnData.length;
                });

                $('.tab-cont-wrap').empty();
                if(rtnData.length > 0) {
                    $('.tab-cont-wrap').append('<ul class="lesson-list"></ul>');
                    $('#listLectureInfo').tmpl(rtnData).appendTo('.lesson-list');

                    $('.lesson-list').bxSlider({
                        pager: false,
                        minSlides:2,
                        maxSlides:2,
                        moveSlides:1,
                        slideWidth:448,
                        slideMargin:2
                    });
                } else {
                    $('.tab-cont-wrap').append('<div class="lesson-empty"><p>해당 날짜에 수업이 없습니다.</p></div>');
                }
            }
        });
    }

    $(document).ready(function () {

        $('.lesson-list').bxSlider({
            pager: false,
            minSlides:2,
            maxSlides:2,
            moveSlides:1,
            slideWidth:448,
            slideMargin:2
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".pop-close").click();
            }
        });
    });
</script>