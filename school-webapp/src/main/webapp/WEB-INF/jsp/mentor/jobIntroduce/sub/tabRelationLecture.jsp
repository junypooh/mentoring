<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript">
$().ready(function() {

    var loadRelLecture = function(jobNo) {
        var dataSet = {
            jobNo: jobNo,
            recordCountPerPage: 5,
            totalRecordCount: 0,
            currentPageNo: 1,
            resource: '${pageContext.request.contextPath}/mentor/jobIntroduce/sub/ajax.relationLecture.do',
            data: {},
        }; mentor.relLectureDataSet= dataSet;

        var loadRealLectureInfo = function() {
            var params = {
                currentPageNo: dataSet.currentPageNo,
                recordCountPerPage: dataSet.recordCountPerPage,
                jobNo: dataSet.jobNo,
            };
            $.ajax(dataSet.resource, {
                type: 'get',
                dataType: 'json',
                data: $.param(params, true),
                success: function(data) {
                    if (dataSet.currentPageNo == 1 && data.length) {
                        dataSet.totalRecordCount = data[0].totalRecordCount;
                    }
                    dataSet.data = data;
                    appendLectureInfo();
//return;
                    updateMoreButton();
                },
                cache: false,
            });
        };


        var appendLectureInfo = function() {
            $('#lectureInfo').tmpl(dataSet.data)
                .appendTo('#lecture-info-list');
            fn_expand();
        };

        var fn_expand = function(){
            var connecTion = $("#lecture-info-list").find('a.view');

            connecTion.on('click',function(e){
                e.preventDefault();

                var _this = $(this);
                if(!_this.hasClass('active')){
                    $("#lecture-info-list").find('a.view').removeClass('active');
                    _this.addClass('active');
                }else{
                    _this.removeClass('active');
                }

            });
        };


        var updateMoreButton = function() {
            $('#moreLecture')
                .find('span').text((Math.floor((dataSet.totalRecordCount + 1) / dataSet.recordCountPerPage) - dataSet.currentPageNo) + 1)
                .end()
                .css({display: (dataSet.totalRecordCount - (dataSet.currentPageNo * dataSet.recordCountPerPage)) > 0 ? '' : 'none'});
        };


        $('#moreLecture').click(function(e) {
            e.preventDefault();
            dataSet.currentPageNo++;
            loadRealLectureInfo();
        });

        loadRealLectureInfo();
    };

    loadRelLecture('${param.jobNo}');
    //loadRelLecture('1000000000');
});
</script>

<%-- Template ============================================= --%>
<script type="text/html" id="lectureInfo">
<li>
    <div class="title">
        <span class="tit"><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectSer}&lectTims=\${lectTims}&schdSeq=\${schdSeq}" title="새창열림" target="_self">[\${lectTypeNm}]\${lectTitle}</a></span>
        <em>\${lectStatCdNm}</em>
        {{if cntntsId !== null}}
        <a href="${pageContext.request.contextPath}/lecture/lectureReplay/lectureReplyView.do?arclSer=\${arclSer}&cId=\${cntntsId}" class="video" title="새창열림" target="_blank">동영상보기</a>
        {{/if}}
        <span class="r-align">
            {{if lectTargtCd == '101534'}}
                <span class="icon-rating elementary">초</span>
            {{/if}}
            {{if lectTargtCd == '101535'}}
                <span class="icon-rating middle">중</span>
            {{/if}}
            {{if lectTargtCd == '101536'}}
                <span class="icon-rating high">고</span>
            {{/if}}
            {{if lectTargtCd == '101537'}}
                <span class="icon-rating elementary">초</span>
                <span class="icon-rating middle">중</span>
            {{/if}}
            {{if lectTargtCd == '101538'}}
                <span class="icon-rating middle">중</span>
                <span class="icon-rating high">고</span>
            {{/if}}
            {{if lectTargtCd == '101539'}}
                <span class="icon-rating elementary">초</span>
                <span class="icon-rating high">고</span>
            {{/if}}
            {{if lectTargtCd == '101540'}}
                <span class="icon-rating elementary">초</span>
                <span class="icon-rating middle">중</span>
                <span class="icon-rating high">고</span>
            {{/if}}
        </span>
    </div>
    <div class="date">
        <span class="user mentor">\${lectrMbrNm}</span>
        <p>\${lectDay && lectDay.toDay()} <span class="t-mobile-blind">/</span> <strong>\${lectStartTime && lectStartTime.toTime()}~\${lectEndTime && lectEndTime.toTime()}</strong></p>
    </div>
    <p>
        <a href="#" class="view">수업소개보기</a>
        <span>\${lectIntdcInfo}</span>
    </p>
</li>
</script>
<%-- Template ============================================= --%>

<!-- 멘토수업 -->
<div class="lesson-connection tab-cont">
	<h3>관련수업</h3>
	<ul id="lecture-info-list">
		<!-- <li>
			<div class="title">
				<span class="tit"><a href="#">인류의 건강을 책임질 심층수와 직업세계</a></span>
				<em>수업중</em>
				<a href="#" class="video">동영상보기</a>
				<span class="r-align">
					<span class="icon-rating middle">중</span>
					<span class="icon-rating high">고</span>
				</span>
			</div>
			<div class="date">
				<span class="user">박주용</span>
				<p>2015.08.23 <span class="t-mobile-blind">/</span> <strong>10:00~12:00</strong></p>
			</div>
			<p>
				<a href="#" class="view">수업소개보기</a>
				<span>어떤 일을 하는지? 한번 주위를 둘러보세요. 냄새가 있죠. 이처럼 우리 주위에는 늘 냄새가 있습니다. 제가 하는 일이 바로 이런 향어떤 일을 하는지? 한번 주위를 둘러보세요. 냄새가 있죠. 이처럼 우리 주위에는 늘 냄새가 있습니다. 제가 하는 일이 바로 이런 향</span>
			</p>
		</li> -->
	</ul>
	<div class="btn-more-view" id="moreLecture" style="display: none;">
		<a href="#">더 보기 (<span>00</span>)</a>
	</div>
</div>


