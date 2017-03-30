<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 멘토수업 -->
<div class="lesson-connection tab-cont active">
    <h3>멘토수업</h3>
    <ul id="lectureList"></ul>
    <div class="paging" id="paging"></div>
</div>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listLectureInfo">
    <li>
        <div class="title">
            <span class="tit"><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectTimsInfo.lectInfo.lectSer}&lectTims=\${lectTimsInfo.lectInfo.lectTims}&schdSeq=\${lectTimsInfo.lectInfo.schdSeq}">[\${lectTimsInfo.lectInfo.lectTypeCdNm}] \${lectTitle}</a></span>
            <!-- a href="#" class="video">동영상보기</a -->
            <span class="r-align">
                {{if lectTimsInfo.lectInfo.lectTargtCd == '101534'}}
                    <span class="icon-rating elementary">초</span>
                {{else lectTimsInfo.lectInfo.lectTargtCd == '101535'}}
                    <span class="icon-rating middle">중</span>
                {{else lectTimsInfo.lectInfo.lectTargtCd == '101536'}}
                    <span class="icon-rating high">고</span>
                {{else lectTimsInfo.lectInfo.lectTargtCd == '101537'}}
                    <span class="icon-rating elementary">초</span>
                    <span class="icon-rating middle">중</span>
                {{else lectTimsInfo.lectInfo.lectTargtCd == '101538'}}
                    <span class="icon-rating middle">중</span>
                    <span class="icon-rating high">고</span>
                {{else lectTimsInfo.lectInfo.lectTargtCd == '101539'}}
                    <span class="icon-rating elementary">초</span>
                    <span class="icon-rating high">고</span>
                {{else lectTimsInfo.lectInfo.lectTargtCd == '101540'}}
                    <span class="icon-rating elementary">초</span>
                    <span class="icon-rating middle">중</span>
                    <span class="icon-rating high">고</span>
                {{/if}}
                {{if lectStatCd == '101543'}}
                    <em>수강모집</em>
                {{else lectStatCd == '101547'}}
                    <em>모집취소</em>
                {{else lectStatCd == '101548'}}
                    <em>수업예정</em>
                {{else lectStatCd == '101549'}}
                    <em>수업대기</em>
                {{else lectStatCd == '101550'}}
                    <em>수업중</em>
                {{else lectStatCd == '101551'}}
                    <em>수업완료</em>
                {{else lectStatCd == '101553'}}
                    <em>수업취소</em>
                {{/if}}
            </span>
        </div>
        <div class="date">
            <span class="user mentor">\${lectTimsInfo.lectInfo.lectrNm}</span>
            <p>\${to_date_format(lectDay,'.')} <span class="t-mobile-blind">/</span> <strong>\${to_time_format(lectStartTime, ':')}~\${to_time_format(lectEndTime, ':')}</strong></p>
        </div>
        <p>
            <a href="javascript:void(0);" onClick="fn_introduceShow(this)" class="view">수업소개보기</a>
            <span>\${lectTimsInfo.lectInfo.lectIntdcInfo}</span>
        </p>
    </li>
</script>
<%-- Template ================================================================================ --%>

<%-- Template ================================================================================ --%>
<script type="text/html" id="emptyLecture">
    <li>
        <div class="title">
            <p><center>등록된 수업이 없습니다.</center></p>
        </div>
    </li>
</script>
<%-- Template ================================================================================ --%>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 5,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10
        }
    };

    if(${isMobile}){
        dataSet.params.pageSize = 5;
    }

    mentor.pageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:fn_mentorLecture, totalRecordCount:0, recordCountPerPage:5, pageSize:dataSet.params.pageSize}),
            document.getElementById('paging')
    );

    $(document).ready(function(){
        fn_mentorLecture();
    });

    function fn_mentorLecture(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
            'mbrNo' : '${param.mbrNo}'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureTotal/mentorLectureList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                    $("#lectureList").empty();
                    $("#listLectureInfo").tmpl(rtnData).appendTo("#lectureList");
                }else{
                    $("#lectureList").empty();
                    $("#emptyLecture").tmpl(1).appendTo("#lectureList");
                }
                dataSet.params.totalRecordCount = totalCount;


                mentor.pageNavi.setData(dataSet.params);

            }
        });
    }

    // 수업소개 보기
    function fn_introduceShow(obj){
        $('#lectureList > li > p > a').removeClass('active');
        $(obj).addClass('active');
    }


</script>