<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>


<script type="text/jsx;harmony=true">
mentor.pageNavi = React.render(
    <PageNavi pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={9} contextPath={mentor.contextpath} />,
    document.getElementById('paging')
);
</script>

<script type="text/javascript">
var dataSet = {
    source: '${pageContext.request.contextPath}/mentor/jobIntroduce/ajax.listJobIntroduce.do',
    params: {
        recordCountPerPage: 9,
        totalRecordCount: 0,
        currentPageNo: 1,
        searchKey: null,
        searchType: null,
        chrstcClsfCds: null,
        jobClsfCd: null,
    },
    data: {},
}; mentor.mentorDataSet = dataSet;

$().ready(function() {

    var loadData = function(before) {
        $.ajax(dataSet.source, {
            type: 'post',
            data: $.param(dataSet.params, true),
            success: function(data) {
                if (before) {
                    before();
                }
                if (dataSet.params.currentPageNo === 1 && data.length) {
                    dataSet.params.totalRecordCount = data[0].totalRecordCount;
                }
                dataSet.data = data;
                appendData();
                updateMoreButton();
                updateTotalRecordCount();
            },
            cache: false,
            async: false,
        });
    };

    var appendData = function() {
        $('#jobInfo').tmpl(dataSet.data)
            .appendTo('.introduction-list ul.job-list');
    };

    var updateMoreButton = function() {
        $('.btn-more-view')
            .find('span').text(dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9))
            .end()
            .css({display: (dataSet.params.totalRecordCount - (dataSet.params.currentPageNo * 9)) > 0 ? '' : 'none'});
    };

    var updateTotalRecordCount = function() {
        if (!dataSet.params.searchKey
                && !dataSet.params.chrstcClsfCds.length
                && !dataSet.params.jobClsfCd) {
            return;
        }
/*
        $('.result-total')
            .find('strong').text(dataSet.params.totalRecordCount);

        $('.result-total-wrap')
            .find('.result-class').empty()
                .append(function() {
                    var ls = [];
                    // 특징 분류
                    $.each(dataSet.params.chrstcClsfCds, function(i, v) {
                        var el = $('#chrstcClsfSelector label:has(:checkbox[value=' + v + '])');
                        if (!el.length) {
                            return;
                        }
                        ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                    });

                    // 직업 분류
                    if (dataSet.params.jobClsfCd) {
                        var el = $('#jobClsfSelector label:has(:radio[value=' + dataSet.params.jobClsfCd + '])');
                        if (el.length) {
                            ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                        }
                    }
                    return ls;
                }).end()
            .css({visibility: 'visible'});
*/
    };

    var onMore = function(e) {
        e.preventDefault();
        ++dataSet.params.currentPageNo;
        loadData();
    }
/*
    var onSearch = function(e) {
        e.preventDefault();
        $(this).closest('form').submit();
    }
*/
    var onSubmit = function() {
        if ($('#searchKey').val() && $('#searchKey').val().length < 2) {
            alert('키워드는 2글자 이상 입력해주세요.');
            return false;
        }
    };
/*
    var initParameters = function() {
        $.extend(dataSet.params, {
            searchType: $('#schoolKeyword').val(),
            searchKey: $('#searchKey').val(),
            chrstcClsfCds: $.map($('#chrstcClsfSelector :checkbox:checked'), function(o) { return o.value; }),
            jobClsfCd: $('#jobClsfSelector :radio:checked').val(),
        });
    };

    initParameters();
*/
    if(${isMobile}){
        $('.btn-more-view a').click(onMore);
        //$('.btn-search').click(onSearch);
        $('#mentorSearch').submit(onSubmit);
        loadData();
    }else{
        fn_search(1);
    }
});


// 검색버튼 클릭
function fn_btnSearch(){
    if(validation()){
        fn_search(1);
    }
}

// 밸리데이션 체크
function validation(){
    if ($('#searchKey').val() && $('#searchKey').val().length < 2) {
        alert('키워드는 2글자 이상 입력해주세요.');
        return false;
    }

    return true;
}

// 검색조건분류, 검색건수 화면에 표시하기
function classifySet(){
    if(dataSet.params.chrstcClsfCds.length > 0 || dataSet.params.jobClsfCd != "" || dataSet.params.searchKey != ""){
        $('.result-total')
            .find('strong').text(dataSet.params.totalRecordCount);

        $('.result-total-wrap')
            .find('.result-class').empty()
                .append(function() {
                    var ls = [];
                    // 특징 분류
                    $.each(dataSet.params.chrstcClsfCds, function(i, v) {
                        var el = $('#chrstcClsfSelector label:has(:checkbox[value=' + v + '])');
                        if (!el.length) {
                            return;
                        }
                        ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                    });

                    // 직업 분류
                    if (dataSet.params.jobClsfCd) {
                        var el = $('#jobClsfSelector label:has(:radio[value=' + dataSet.params.jobClsfCd + '])');
                        if (el.length) {
                            ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                        }
                    }
                    return ls;
                }).end()
            .css({visibility: 'visible'});
    }else{
        $('.result-total-wrap').css({visibility: 'hidden'});
    }

}

function fn_search(pageNum) {
    // 검색조건 setting
    dataSet.params.searchType = $('#schoolKeyword').val();
    dataSet.params.searchKey = $('#searchKey').val();
    dataSet.params.chrstcClsfCds = $.map($('#chrstcClsfSelector :checkbox:checked'), function(o) { return o.value; });
    dataSet.params.jobClsfCd = $('#jobClsfSelector :radio:checked').val();

    dataSet.params.currentPageNo = pageNum;

    $.ajax(dataSet.source, {
        data : $.param(dataSet.params, true),
        success: function(rtnData) {
            dataSet.data = rtnData;

            if(rtnData != null && rtnData.length > 0){
                dataSet.params.totalRecordCount = rtnData[0].totalRecordCount;
            }else{
                dataSet.params.currentPageNo = 1;
                dataSet.params.totalRecordCount = 0;
            }
            mentor.pageNavi.setData(dataSet.params);
            // 추천직업 show, hide
            if(dataSet.params.searchKey != "" || dataSet.params.chrstcClsfCds.length > 0 || dataSet.params.jobClsfCd != "") {
                $('.recomm-job').css('display', 'none');
            }else{
                $('.recomm-job').css('display', '');
            }

            $(".introduction-list ul.job-list").empty();
            $('#jobInfo').tmpl(dataSet.data).appendTo('.introduction-list ul.job-list');

            classifySet();

        }
    });
}

function parsePicInfo(source) {
    if (source) {
        source = source.replace(/^([^,]+).*/, '$1');
    }
    return source;
}

function jobLayerConfirmCallback(chrstcClsfCds, jobClsfCd) {
}
function fnNmLength(obj){
    if(obj != null){
        if(obj.length > 30){
            obj = obj.substr(0, 30)+"...";
        }
    }else{
        obj = "";
    }
    return obj;
}
</script>

<%-- Template ================================================================================ --%>
<script type="text/html" id="jobInfo">
<li>
    <a href="${pageContext.request.contextPath}/mentor/jobIntroduce/showJobIntroduce.do?jobNo=\${jobNo}" title="\${jobDefNm}" target="_self">
        <dl class="introduction-info">
            <dt class="title">\${jobNm}</dt>
            <dd class="info">\${fnNmLength(jobDefNm)}</dd>
            <dd class="icon">
                {{/*if mentorCnt != 0*/}}
                    <span class="icon-total-mentor">멘토 \${mentorCnt}명</span>
                {{/*/if*/}}
            </dd>
            <dd class="img">
                {{if jobPicInfo}}
                    <img src="\${parsePicInfo(jobPicInfo)}" alt="\${jobNm} 인물사진" onerror='this.style.display = "none"'>
                {{else mentorProfPicInfo}}
                    <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${parsePicInfo(mentorProfPicInfo)}" alt="\${jobNm} 인물사진" onerror='this.style.display = "none"'>
                {{else}}
                    <!-- Not found picture -->
                {{/if}}
            </dd>
        </dl>
    </a>
 </li>
</script>
<%-- Template ================================================================================ --%>

<form:form modelAttribute="mentorSearch" action="${pageContext.request.contextPath}/mentor/jobIntroduce/listJobIntroduce.do" method="get">
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">멘토</span>
        <span>직업소개</span>
    </div>
    <div class="content sub">
        <h2>직업소개</h2>

        <!-- React start -->
        <div id="job-info-contents">
        </div>
        <!-- React end -->

        <%-- <form:form action="${pageContext.request.contextPath}/mentor/jobIntroduce/listJobIntroduce.do" method="get" id="searchFrm"> --%>
        <div class="review-tbl-wrap">
            <div class="review-tbl">
                <table>
                    <caption>직업소개 검색창 - 키워드,직업</caption>
                    <colgroup>
                        <col class="size-tbl1" />
                        <col class="size-tbl2" />
                        <col class="size-tbl1" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="schoolKeyword">키워드</label></th>
                            <td>
                                <div class="keyword-search">
                                    <div class="selectbox-zindex-wrap"><!-- 2015-11-16 추가 -->
                                        <form:select id="schoolKeyword" class="keyword-slt" title="키워드 종류" path="searchType">
                                            <form:option value="all">전체</form:option>
                                            <%-- <form:option value="class" >수업 </form:option> --%>
                                            <form:option value="mentor">멘토</form:option>
                                            <%-- <form:option value="tag">태그</form:option> --%>
                                            <form:option value="job">직업</form:option>
                                        </form:select>
                                        <div class="selectbox-zindex-box">
                                            <div></div>
                                            <iframe scrolling="no" title="빈프레임" frameborder="0"></iframe>
                                        </div>
                                    </div>
                                    <form:input type="text" path="searchKey" class="keyword-inp" id="searchKey" title="키워드입력란" />
                                </div>
                            </td>
                            <th scope="row">직업</th>
                            <td>
                                <a href="#jobSearch" title="직업선택 팝업 - 열기" class="btn-job layer-open m-none">직업선택</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area">
                <a href="javascript:fn_btnSearch();" class="btn-search"><span>검색</span></a>
            </div>
        </div>
        <%-- </form:form> --%>

        <%-- <form:form action="${pageContext.request.contextPath}/mentor/jobIntroduce/viewDetailJobIntroduce.do" method="get" id="jobFrm">
            <input type="hidden" id="jobNo" name="jobNo"/>
            <input type="hidden" id="jobClsfCd" name="jobClsfCd"/>
        </form:form> --%>

        <div class="introduction-list">
            <c:if test="${not empty recomJobList}">
                <div class="recomm-job">
                    <h3 class="recomm">- 추천직업</h3>
                    <ul>
                        <c:forEach items="${recomJobList}" var="each" varStatus="vs">
                            <li>
                                <a href="${pageContext.request.contextPath}/mentor/jobIntroduce/showJobIntroduce.do?jobNo=${each.jobNo}" title="${each.jobDefNm}" target="_self">
                                    <dl class="introduction-info">
                                        <dt class="title">${each.jobNm}</dt>
                                        <dd class="info">${each.jobDefNm}</dd>
                                        <dd class="icon"><span class="icon-total-mentor">멘토${each.mentorCnt}명</span></dd>
                                        <dd class="img">
                                            <c:if test="${not empty each.jobPicInfo}">
                                                <img src="${cnet:parsePicInfo(each.jobPicInfo)}" alt="${each.jobNm} 인물사진" onerror='this.style.display = "none"'/>
                                            </c:if>
                                            <c:if test="${empty each.jobPicInfo && not empty each.mentorProfPicInfo}">
                                                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${cnet:parsePicInfo(each.mentorProfPicInfo)}" alt="${each.jobNm} 인물사진" onerror='this.style.display = "none"'/>
                                            </c:if>
                                            <c:if test="${empty each.jobPicInfo && empty each.mentorProfPicInfo}">
                                                <!-- Not found picture -->
                                            </c:if>
                                        </dd>
                                    </dl>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <div class="result-total-wrap" style="visibility: hidden;">
                <span class="result-class">

                </span>
                <p class="result-total">검색 결과 총 <strong></strong> 건</p>
            </div>

            <ul class="job-list">
             <%-- <c:forEach items="${resultList}" var="item">
                <li>
                    <a href="javaScript:detailJobInfo('${item.jobNo }', '${item.jobClsfCd}' );">
                        <dl class="introduction-info">
                            <dt class="title">${item.jobNm }</dt>
                            <dd class="info">${item.jobIntdcInfo }</dd>
                            <dd class="icon"><span class="icon-total-mentor">멘토 ${item.mentorCnt}명</span></dd>
                            <dd class="img"><img src="${item.jobPicInfo}" alt="국악인 인물사진"></dd>
                        </dl>
                    </a>
                </li>
            </c:forEach> --%>
            </ul>
        </div>
        <div class="btn-more-view" style="display: none;">
            <a href="#">더 보기 (<span></span>)</a>
        </div>
        <c:if test="${!isMobile}">
            <div class="paging" id="paging"></div>
        </c:if>
    </div>
</div>


<div class="cont-quick">
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>

<jsp:include page="/WEB-INF/jsp/layer/layerJobSelector.jsp">
    <jsp:param name="callback" value="jobLayerConfirmCallback" />
    <jsp:param name="type" value="jobIntroduce" />
</jsp:include>

</form:form>