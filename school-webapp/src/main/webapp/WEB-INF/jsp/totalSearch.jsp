<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<%
    String searchKey = request.getParameter("searchKey");
%>

<c:set var="searchKey" value="<%=searchKey %>" />

<script type="text/javascript">
$().ready(function() {

    // 텝기능 추가
    $('.tab-anchor').click(function() {
        $('.tab-cont').removeClass('active')
            .filter($(this).attr('href'))
            .addClass('active');
    });

 // 수업 검색 결과
    (function() {
        var dataSet = {
            source: '${pageContext.request.contextPath}/mentor/lectureIntroduce/ajax.listLectureInfo.do',
            params: {
                totalRecordCount: 0,
                currentPageNo: 1,
                searchKey: null,
            },
            data: {},
        }; mentor.lectureDataSet = dataSet;

        var loadData = function(before) {
            $.ajax(dataSet.source, {
                type: 'post',
                data: $.param(dataSet.params, true),
                success: function(data) {
                    if (dataSet.params.currentPageNo === 1 && data.length) {
                        dataSet.params.totalRecordCount = data[0].totalRecordCount;
                    }
                    dataSet.data = data;
                    appendData();
                    updateMoreButton();
                    updateTotalRecordCount();
                },
                cache: false,
                async: true,
            });
        };

        var appendData = function() {
            $('#lectureInfo').tmpl(dataSet.data)
                    .appendTo('.search-list-type.lecture ul');
        };

        var updateMoreButton = function() {
            $('.btn-more-view.more-lecture')
                    .find('span').text(dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9))
                    .end()
                    .css({display: (dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9)) > 0 ? '' : 'none'});
        };

        var updateTotalRecordCount = function() {
            $('.tab-anchor.lecture')
                    .find('span').text(dataSet.params.totalRecordCount);
            updateAllCount();
        };

        var onMore = function(e) {
            e.preventDefault();
            dataSet.params.currentPageNo++;
            loadData();
        };

        var initParameters = function() {
            $.extend(dataSet.params, {
                searchKey: $('#searchKey').val().trim().replace(/ +/g, '|'),
            });
        };

        $('.btn-more-view.more-lecture a').click(onMore);

        initParameters();
        loadData();
    })();


    // 멘토 검색 결과
    (function() {
        var dataSet = {
            source: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.listMentorInfo.do',
            params: {
                totalRecordCount: 0,
                currentPageNo: 1,
                searchKey: null,
            },
            data: {},
        }; mentor.mentorDataSet = dataSet;


        var loadData = function(before) {
            $.ajax(dataSet.source, {
                type: 'post',
                data: $.param(dataSet.params, true),
                success: function(data) {
                    if (dataSet.params.currentPageNo === 1 && data.length) {
                        dataSet.params.totalRecordCount = data[0].totalRecordCount;
                    }
                    dataSet.data = data;
                    appendData();
                    updateMoreButton();
                    updateTotalRecordCount();
                },
                cache: false,
                async: true,
            });
        };

        var appendData = function() {
            $('#mentorInfo').tmpl(dataSet.data)
                .appendTo('.introduction-list.mentor ul');
        };

        var updateMoreButton = function() {
            $('.btn-more-view.more-mentor')
                .find('span').text((Math.floor((dataSet.params.totalRecordCount + 1) / 9) - dataSet.params.currentPageNo) + 1)
                .end()
                .css({display: (dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9)) > 0 ? '' : 'none'});
        };

        var updateTotalRecordCount = function() {
            $('.tab-anchor.metor')
                .find('span').text(dataSet.params.totalRecordCount);
            updateAllCount();
        };

        var onMore = function(e) {
            e.preventDefault();
            dataSet.params.currentPageNo++;
            loadData();
        };

        var initParameters = function() {
            $.extend(dataSet.params, {
                searchKey: $('#searchKey').val().trim().replace(/ +/g, '|'),
            });
        };

        $('.btn-more-view.more-mentor a').click(onMore);

        initParameters();
        loadData();
    })();



    // 직업 검색 결과
    (function() {
        var dataSet = {
            source: '${pageContext.request.contextPath}/mentor/jobIntroduce/ajax.listJobInfo.do',
            params: {
                totalRecordCount: 0,
                currentPageNo: 1,
                searchKey: null,
            },
            data: {},
        }; mentor.jobDataSet = dataSet;

        var loadData = function(before) {
            $.ajax(dataSet.source, {
                type: 'post',
                data: $.param(dataSet.params, true),
                success: function(data) {
                    if (dataSet.params.currentPageNo === 1 && data.length) {
                        dataSet.params.totalRecordCount = data[0].totalRecordCount;
                    }
                    dataSet.data = data;
                    appendData();
                    updateMoreButton();
                    updateTotalRecordCount();
                },
                cache: false,
                async: true,
            });
        };

        var appendData = function() {
            $('#jobInfo').tmpl(dataSet.data)
                .appendTo('.introduction-list.job ul');
        };

        var updateMoreButton = function() {
            $('.btn-more-view.more-job')
                .find('span').text(dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9))
                .end()
                .css({display: (dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9)) > 0 ? '' : 'none'});
        };

        var updateTotalRecordCount = function() {
            $('.tab-anchor.job')
                .find('span').text(dataSet.params.totalRecordCount);
            updateAllCount();
        };

        var onMore = function(e) {
            e.preventDefault();
            dataSet.params.currentPageNo++;
            loadData();
        };

        var initParameters = function() {
            $.extend(dataSet.params, {
                searchKey: $('#searchKey').val().trim().replace(/ +/g, '|'),
            });
        };

        $('.btn-more-view.more-job a').click(onMore);

        initParameters();
        loadData();
    })();


    // 전체 검색결과
    var updateAllCount = (function() {
        $('.result-total strong').text(function() {
            return $.map($('.tab-anchor > span'), function(o) { return Number(o.innerHTML); }).reduce(function(pv, cv) {
                return pv + cv;
            })
        });
    });
});

/*
 * yyyyMMdd 날짜문자열을 gubun으로 포맷을 변경
 */
function to_date_format(date_str, gubun)
{
    var yyyyMMdd = String(date_str);
    var sYear = yyyyMMdd.substring(0,4);
    var sMonth = yyyyMMdd.substring(4,6);
    var sDate = yyyyMMdd.substring(6,8);

    return sYear + gubun + sMonth + gubun + sDate;
}

/*
 * hh24mi 시간문자열을 gubun으로 포맷을 변경
 */
function to_time_format(time_str, gubun)
{
    var time = String(time_str);
    var hh = time.substring(0,2);
    var mm = time.substring(2,4);
    return hh + gubun + mm;
}

function fnDefaultImg(imtPath){
    imtPath.src = "${pageContext.request.contextPath}/images/lesson/img_epilogue_default.gif";
}

function fnDefaultJobImg(imtPath){
    imtPath.src = "${pageContext.request.contextPath}/images/lesson/img_epilogue_default.gif";
}

function parsePicInfo(source) {
    if (source) {
        source = source.replace(/^([^,]+).*/, '$1');
    }
    return source;
}
</script>

<%-- Template ============================================================================== --%>
<!-- 멘토 정보 -->
<script type="text/html" id="mentorInfo">
<li>
    <a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=\${mbrNo}" title="새창열림" target="_self">
        <dl class="introduction-info">
            <dt class="title">\${nm}</dt>
            <dd class="info">\${profTitle}</dd>
            <dd class="job">\${jobNm}</dd>
            {{if iconKindCd == '101598'}}
                <dd class="icon"><span class="icon-donation">재능기부</span></dd>
            {{/if}}
            <dd class="img">
                {{if profFileSer != null}}
                    <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${profFileSer}" alt="\${nm} 인물사진">
                {{/if}}
            </dd>
        </dl>
    </a>
</li>
</script>

<!-- 직업 정보 -->
<script type="text/html" id="jobInfo">
<li>
    <a href="${pageContext.request.contextPath}/mentor/jobIntroduce/showJobIntroduce.do?jobNo=\${jobNo}" title="새창열림" target="_self">
        <dl class="introduction-info">
            <dt class="title">\${jobNm}</dt>
            <dd class="info">\${jobDefNm.substrBytes(0, 60)}</dd>
            <dd class="icon">
                {{/*if mentorCnt != 0*/}}
                    <span class="icon-total-mentor">멘토 \${mentorCnt}명</span>
                {{/*/if*/}}
            </dd>
            <dd class="img">
                {{if jobPicInfo}}
                    <img src="\${parsePicInfo(jobPicInfo)}" alt="\${jobNm} 인물사진">
                {{else mentorProfPicInfo}}
                    <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${parsePicInfo(mentorProfPicInfo)}" alt="\${jobNm} 인물사진">
                {{else}}
                    <!-- Not found picture -->
                {{/if}}
            </dd>
        </dl>
    </a>
 </li>
</script>

<!-- 수업 정보 -->
<script type="text/html" id="lectureInfo">
    <li>
        <a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectSer}&lectTims=\${lectTims}&schdSeq=\${schdSeq}" target="_blank>
            <dl class="lesson-info">
                <dt class="mento"><strong>\${lectTimsInfo.lectInfo.lectrNm}</strong><em>/ \${lectTimsInfo.lectInfo.lectIntdcInfo}</em></dt>
                <dd class="rating">
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101534'}}
                        <span class="icon-rating elementary">초</span>
                    {{/if}}
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101535'}}
                        <span class="icon-rating middle">중</span>
                    {{/if}}
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101536'}}
                        <span class="icon-rating high">고</span>
                    {{/if}}
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101537'}}
                        <span class="icon-rating elementary">초</span><span class="icon-rating middle">중</span>
                    {{/if}}
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101538'}}
                        <span class="icon-rating middle">중</span><span class="icon-rating high">고</span>
                    {{/if}}
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101539'}}
                        <span class="icon-rating elementary">초</span><span class="icon-rating high">고</span>
                    {{/if}}
                    {{if lectTimsInfo.lectInfo.lectTargtCd == '101540'}}
                        <span class="icon-rating elementary">초</span><span class="icon-rating middle">중</span><span class="icon-rating high">고</span>
                    {{/if}}
                </dd>
                <dd class="date-time">
                    <span class="date">\${to_date_format(lectDay, "-")}</span><span class="time">\${to_time_format(lectStartTime, ":")}~\${to_time_format(lectEndTime, ":")}</span>
                </dd>
                <dd class="title"><span>\${lectTimsInfo.lectInfo.mbrJobInfo[0].jobNm}</span></dd>
                <dd class="info"><p>\${lectTimsInfo.lectInfo.lectOutlnInfo}</p></dd>
                <dd class="image"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${lectTimsInfo.lectInfo.lectPicPath}" alt="\${lectTitle}\${lectTimsInfo.lectInfo.lectPicPath}" onerror="fnDefaultImg(this)"></dd>
            </dl>
        </a>
    </li>
</script>
<%-- Template ============================================================================== --%>

<!-- 원 검색키 -->
<input type="hidden" value="${searchKey}" id="searchKey" />

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">검색</span>
    </div>

    <div class="content sub">

        <c:if test="${not empty searchKey}">
            <h2 class="search-title">
                <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).splitSearchKeyToHTML(searchKey)" /><!-- &lsquo;웹툰작가&rsquo;, &lsquo;조석&rsquo;, &lsquo;븅따악&rsquo; -->&nbsp;
            </h2>
        </c:if>

        <p class="result-total">검색 결과 총 <strong></strong> 건 </p>
        <div class="tab-action">
            <ul class="tab-type1 tab03">
                <li class="active"><a href="#tab-lecture" class="tab-anchor lecture">수업(<span>0</span>)</a></li>
                <li><a href="#tab-mentor" id="lessonTab02" class="tab-anchor metor">멘토(<span>0</span>)</a></li>
                <li><a href="#tab-job" id="lessonTab03" class="tab-anchor job">직업(<span>0</span>)</a></li>
            </ul>
            <div class="tab-action-cont">
                <div class="tab-cont active" id="tab-lecture">
                    <h3 class="invisible">수업 검색 결과</h3>
                    <div class="search-list-type lecture">
                        <ul>
                            <%--<c:forEach begin="1" end="9">--%>
                                <%--<li>--%>
                                    <%--&lt;%&ndash;<a href="#">&ndash;%&gt;--%>
                                        <%--&lt;%&ndash;<dl class="lesson-info">&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;<dt class="mento"><strong>12항공승무원</strong><em>/ 아시아나 항공승무원아시아나 항공승무원</em></dt>&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;<dd class="rating"><span class="icon-rating elementary">초</span><span class="icon-rating middle">중</span><span class="icon-rating high">고</span></dd>&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;<dd class="date-time">&ndash;%&gt;--%>
                                                <%--&lt;%&ndash;<span class="date">2015-07-11</span><span class="time">10:00~10:50</span>&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;</dd>&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;<dd class="title"><span>플로리스트, 미디어 크리에이터 등 직업명이 들어갑니다.</span></dd>&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;<dd class="info"><p>경쾌하고 익살스러운 만화 속 세상! 웹툰 만화가들은 어떻게 웹툰을...경쾌하고 익살스러운 만화 속 세상! 웹툰 만화가들은 어떻게 웹툰을...</p></dd>&ndash;%&gt;--%>
                                            <%--&lt;%&ndash;<dd class="image"><img src="${pageContext.request.contextPath}/images/lesson/thumb_289x169_01.jpg" alt="항공승무원 인물 사진"></dd>&ndash;%&gt;--%>
                                        <%--&lt;%&ndash;</dl>&ndash;%&gt;--%>
                                    <%--&lt;%&ndash;</a>&ndash;%&gt;--%>
                                <%--</li>--%>
                            <%--</c:forEach>--%>
                        </ul>
                    </div>
                    <div class="btn-more-view more-lecture" style="display: none;">
                        <a href="#">더 보기 (<span>0</span>)</a>
                    </div>
                    <a href="#lessonTab02" class="btn-focus-move">수강모집 메뉴로 이동</a>
                </div>
                <!-- 수강모집 -->
                <div class="tab-cont" id="tab-mentor">
                    <h3 class="invisible">멘토 검새 결과</h3>
                    <div class="introduction-list result mentor">
                        <ul>
                            <%-- <c:forEach begin="1" end="9">
                                <li>
                                    <a href="#">
                                        <dl class="introduction-info">
                                            <dt class="title">조석</dt>
                                            <dd class="info">경쾌하고 익살스러운 그림 속 세상에서 살아 움직이는 친구들</dd>
                                            <dd class="job">웹툰 작가</dd>
                                            <dd class="icon"><span class="icon-donation">재능기부</span></dd>
                                            <dd class="img"><img src="../images/mentor/thumb_132x132_01.jpg" alt="조석 인물사진"></dd>
                                        </dl>
                                    </a>
                                </li>
                            </c:forEach> --%>
                        </ul>
                    </div>
                    <div class="btn-more-view more-mentor">
                        <a href="#">더 보기 (<span>0</span>)</a>
                    </div>
                </div>
                <!-- 직업 -->
                <div class="tab-cont" id="tab-job">
                    <h3 class="invisible">직업검색 내용</h3>
                    <div class="introduction-list result job">
                        <ul>
                            <%-- <c:forEach begin="1" end="9">
                                <li>
                                    <a href="#">
                                        <dl class="introduction-info">
                                            <dt class="title">국악인</dt>
                                            <dd class="info">우리 전통음악을 연주하거나, 공연하는 사람</dd>
                                            <dd class="icon"><span class="icon-total-mentor">멘토 13명</span></dd>
                                            <dd class="img"><img src="../images/mentor/thumb_132x132_01.jpg" alt="국악인 인물사진"></dd>
                                        </dl>
                                    </a>
                                </li>
                            </c:forEach> --%>
                        </ul>
                    </div>
                    <div class="btn-more-view more-job">
                        <a href="#">더 보기 (<span>0</span>)</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="cont-quick">
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
