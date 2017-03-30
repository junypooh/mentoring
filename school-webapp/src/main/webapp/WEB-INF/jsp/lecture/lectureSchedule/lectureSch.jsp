<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <div id="container">
        <div class="location">
            <a href="#" class="home">HOME</a>
            <span class="first">수업</span>
            <span>수업일정</span>
        </div>
        <div class="content sub">
            <h2 class="txt-type">수업일정</h2>

            <!--s : 수업캘린더-->
            <div class="sch-calendar" id="calendarInfo">
                <input type="hidden" id="thisMonth" value="${thisMonthStr}" />
                <div class="sch-month"><a href="javascript:void(0)" onclick="previous()">이전달</a><span id="thisMonthTxt">${thisMonth}</span>월<a href="javascript:void(0)" onclick="next()">다음달</a></div>
                <table>
                    <caption>일요일에서 월요일까지의 수업캘린더</caption>
                    <colgroup>
                        <col style="width:10%">
                        <col style="width:10%">
                        <col style="width:10%">
                        <col style="width:10%">
                        <col style="width:10%">
                        <col style="width:10%">
                        <col style="width:10%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>SUNDAY</th>
                            <th>MONDAY</th>
                            <th>TUESDAY</th>
                            <th>WEDNESDAY</th>
                            <th>THUSDAY</th>
                            <th>FRIDAY</th>
                            <th>SATURDAY</th>
                        </tr>
                    <tbody>
                        <c:forEach items="${calendarInfo}" var="calendarInfo">
                        <c:if test="${calendarInfo.d eq 1}">
                        <tr>
                        </c:if>
                            <td<c:if test="${not empty calendarInfo.thisMonth}"> class="${calendarInfo.thisMonth}"</c:if> id="${calendarInfo.dtm}">
                                <a href="javascript:void(0)"<c:if test="${not empty calendarInfo.toDay}"> class="${calendarInfo.toDay}"</c:if> onclick="getLectList($(this));">
                                    <input type="hidden" id="dtm" value="${calendarInfo.dtm}" />
                                    <input type="hidden" id="eleCnt" value="${calendarInfo.eleCnt}" />
                                    <input type="hidden" id="midCnt" value="${calendarInfo.midCnt}" />
                                    <input type="hidden" id="highCnt" value="${calendarInfo.highCnt}" />
                                    <b>${calendarInfo.numDay}</b>
                                    <c:if test="${calendarInfo.eleCnt > 0}">
                                    <span class="lecture-con lv1" title="초등학교">초</span>
                                    </c:if>
                                    <c:if test="${calendarInfo.midCnt > 0}">
                                    <span class="lecture-con lv2" title="중학교">중</span>
                                    </c:if>
                                    <c:if test="${calendarInfo.highCnt > 0}">
                                    <span class="lecture-con lv3" title="고등학교">고</span>
                                    </c:if>
                                </a>
                            </td>
                        <c:if test="${calendarInfo.d eq 7}">
                        </tr>
                        </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <!--e : 수업캘린더-->

            <!--s : 수업리스트-->
            <div id="calendarLectList">
            </div>
            <!--e : 수업리스트-->
        </div>
    </div>

<script type="text/javascript">
    var firstCall = false;
    var aTag;
    var tdList;
    var eleCnt = 0;
    var midCnt = 0;
    var highCnt = 0;

    $(document).ready(function(){
    });

    /* 날짜 클릭 시 수업 리스트 조회 */
    function getLectList(obj) {
        var dtm = $.trim(obj.find("input[id='dtm']").val());
        eleCnt = $.trim(obj.find("input[id='eleCnt']").val());
        midCnt = $.trim(obj.find("input[id='midCnt']").val());
        highCnt = $.trim(obj.find("input[id='highCnt']").val());

        tdList = $('#calendarInfo').find('td');
        tdList.each(function(idx) {
            $(this).removeClass("select-on");
        });
        obj.parent().addClass("select-on");

        var param = {'searchStDate':dtm, 'searchEndDate':dtm, 'eleCnt':eleCnt, 'midCnt':midCnt, 'highCnt':highCnt, 'schoolGrd': ''};
        mentor.CalendarLectList.getList(param);
    }

    /* 하단 수업 디폴트 리스트 조회 날짜 가져오기 */
    function getDefaultDtm() {
        var dtm;
        tdList = $('#calendarInfo').find('td');
        tdList.each(function(idx) {
            aTag = $(this).find('a');
            if(aTag.hasClass('today')) {
                $(this).addClass("select-on");
                dtm = $.trim(aTag.find("input[id='dtm']").val());
                eleCnt = $.trim(aTag.find("input[id='eleCnt']").val());
                midCnt = $.trim(aTag.find("input[id='midCnt']").val());
                highCnt = $.trim(aTag.find("input[id='highCnt']").val());
            }
        });

        if(typeof dtm == "undefined") {
            dtm = $('#thisMonth').val() + "01";
            $('#'+dtm).addClass("select-on");
            aTag = $('#'+dtm).find('a');
            dtm = $.trim(aTag.find("input[id='dtm']").val());
            eleCnt = $.trim(aTag.find("input[id='eleCnt']").val());
            midCnt = $.trim(aTag.find("input[id='midCnt']").val());
            highCnt = $.trim(aTag.find("input[id='highCnt']").val());
        }

        return dtm;
    }

    /* 이전 달 */
    function previous() {
        var param = {'thisMonth': $('#thisMonth').val(), 'calPreNxt':-1}
        showCalendar(param);
    }

    /* 다음 달 */
    function next() {
        var param = {'thisMonth': $('#thisMonth').val(), 'calPreNxt':1}
        showCalendar(param);
    }

    /* 달력 갱신 */
    function showCalendar(param) {
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureSchedule/lectureSch.do',
            data : param,
            contentType: "application/json",
            dataType: 'HTML',
            cache: false,
            success: function(result) {
				if($(result).find('#calendarInfo').html() != null) {
					$('#calendarInfo').empty().append($(result).find('#calendarInfo').html());
				}
				/* 수업 리스트 조회 */
                var param = {'searchStDate':getDefaultDtm(), 'searchEndDate':getDefaultDtm(), 'eleCnt': eleCnt, 'midCnt': midCnt, 'highCnt': highCnt, 'schoolGrd': ''};
                mentor.CalendarLectList.getList(param);
            },
            error: function(xhr, status, err) {
            }
        });
    }

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureInfoCalendar.js"></script>
<script type="text/javascript">
    mentor.defaultDay = getDefaultDtm();
    mentor.CalendarLectList = React.render(
      React.createElement(CalendarLect, {url:'${pageContext.request.contextPath}/lecture/lectureSchedule/ajax.lectureSchLectureList.do', lectDay: mentor.defaultDay, eleCnt: eleCnt, midCnt: midCnt, highCnt: highCnt}),
      document.getElementById('calendarLectList')
    );
</script>