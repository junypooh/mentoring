
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<spring:eval expression="T(kr.or.career.mentor.util.EgovProperties).getProperty('MENTORING_SCHOOL')" var="SCHOOL_DOMAIN" />
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>
<style>
    .board-type1 table tr td .lesson-mngmt-info .time2{width:194px;height:20px;display:inline-block}
</style>

<!-- //header -->
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>수업관리</span>
        <span>수업현황</span>
	</div>
	<div class="content">
		<h2>수업현황</h2>
		<div class="cont type3">
			<div class="calculate-management lists">
				<div class="search-box">
					<dl>
						<dt>날짜</dt>
						<dd>
							<span class="calendar">
								<input type="text" class="inp-style1" style="width:110px;" id="searchStDate" name="" />
								~
								<input type="text" class="inp-style1" style="width:110px;" id="searchEndDate" name="" />
							</span>
							<span class="btn">
								<em class="school">학교급</em>
								<span>
								    <form:select path="schoolGrd" id="schoolGrd" style="width:108px;">
                                        <form:option value="">전체</form:option>
                                        <form:options items="${schoolGrd}" itemLabel="cdNm" itemValue="cd"/>
                                    </form:select>
                                </span>
							</span>
						</dd>
						<dt>키워드</dt>
						<dd>
                            <select title="키워드 종류" id="seachType" style="width:108px;">
                                <option value="all">전체</option>
                                <option value="lectTitle">수업</option>
                                <option value="mentorNm">멘토</option>
                                <option value="jobTagInfo">태그</option>
                                <option value="jobNm">직업</option>
                            </select>
							<input type="text" class="inp-style1" title="키워드입력란" id="searchKey" style="width:282px;"/>
							<span class="btn">
								<em>수업유형</em>
								<span>
                                    <form:select path="lectType" id="lectType" style="width:108px;">
                                        <form:option value="">전체</form:option>
                                        <form:options items="${lectType}" itemLabel="cdNm" itemValue="cd"/>
                                    </form:select>
								</span>
							</span>
						</dd>
					</dl>
					<div class="btn-area">
					    <a href="javascript:void(0)" class="btn-search" id="aSearch"><span>검색</span></a>
					</div>
				</div>
			</div>
			<div class="tab-action">
                <ul class="sub-tab tab05">
                    <li class="active"><a href="javascript:void(0);" id="lessonTab01">전체</a></li>
                    <li><a href="javascript:void(0);" id="lessonTab02">수강모집</a></li>
                    <li><a href="javascript:void(0);" id="lessonTab03">수업예정</a></li>
                    <li><a href="javascript:void(0);" id="lessonTab04">수업대기</a></li>
                    <li><a href="javascript:void(0);" id="lessonTab05">수업완료</a></li>
                </ul>
                <div class="tab-action-cont" id="mentorLectTabViewTotal"></div>

			</div>
		</div>
	</div>
	<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>

<a href="#layer5" class="layer-open" id="layerOpen"></a>

<!-- layerpopup -->
<div id="layerPopupDiv"></div>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/mentorLectList.js"></script>

<script type="text/javascript">
    var SCHOOL_DOMAIN = "${SCHOOL_DOMAIN}";
</script>

<script type="text/javascript">

    $(document).ready(function(){
        $('#searchKey').keydown(function(e) {
            if (e.which == 13) {/* 13 == enter key@ascii */
                searchList();
            }
            $('#layerPopupDiv').load(function() {
                $('body').addClass('dim');
                $("#layer5").attr('tabindex',0).show().focus();
            });
        });

        _applyDatepicker($("#searchStDate"));
        _applyDatepicker($("#searchEndDate"));

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");

        <c:choose>
            <c:when test="${!empty param.tab}">
                $("#${param.tab}").click();
            </c:when>
            <c:when test="${!empty param.listType}">
                $("#lessonTab0${param.listType + 1}").click();
            </c:when>
            <c:otherwise>
                mentor.activeTab = "0";
            </c:otherwise>
        </c:choose>
        mentor.mentorLectTabViewTotal = React.render(
          React.createElement(MentorLectTabView, {url:'${pageContext.request.contextPath}/lecture/lectureState/mentorLectureList.do', recordCountPerPage:$("#recordCountPerPage").val()}),
          document.getElementById('mentorLectTabViewTotal')
        );

    });

    function searchList(curPage) {
        mentor.mentorLectTabViewTotal.getList({
            'listType': mentor.activeTab,
            'currentPageNo': (curPage != null) ? curPage : 1,
            'recordCountPerPage': $("#recordCountPerPage").val()
        });
    }

    $('#searchKey').keydown(function(e) {
        if (e.which == 13) {/* 13 == enter key@ascii */
            $("#aSearch").click();
        }
    });

    $("#aSearch").click(function(){
        $("#lessonTab01").click();
    });

    mentor._callbackTabClick = function(idx){

        mentor.activeTab = idx;
        if($("#mentorLectTabViewTotal").html() != ""){
            searchList();
        }
    }

</script>