<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript">
$().ready(function() {

    var loadRelMentor = function(jobNo) {
        var dataSet = {
            jobNo: jobNo,
            recordCountPerPage: 5,
            totalRecordCount: 0,
            currentPageNo: 1,
            resource: '${pageContext.request.contextPath}/mentor/jobIntroduce/sub/ajax.relationMentor.do',
            data: {},
        }; mentor.relMentorDataSet = dataSet;

        var loadRealMentorInfo = function() {
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
                    appendMentorInfo();
                    updateMoreButton();
                },
                cache: false,
            });
        };

        var appendMentorInfo = function() {
            $('#mentorInfo').tmpl(dataSet.data)
                .appendTo('#mentor-info-list');
            fn_expand();
        };

        var fn_expand = function(){
            var connecTion = $("#mentor-info-list").find('a.view');

            connecTion.on('click',function(e){
                e.preventDefault();

                var _this = $(this);
                if(!_this.hasClass('active')){
                    $("#mentor-info-list").find('a.view').removeClass('active');
                    _this.addClass('active');
                }else{
                    _this.removeClass('active');
                }

            });
        };

        var updateMoreButton = function() {
            $('#moreMentor')
                .find('span').text((Math.floor((dataSet.totalRecordCount + 1) / dataSet.recordCountPerPage) - dataSet.currentPageNo) + 1)
                .end()
                .css({display: (dataSet.totalRecordCount - (dataSet.currentPageNo * dataSet.recordCountPerPage)) > 0 ? '' : 'none'});
        };


        $('#moreMentor').click(function(e) {
            e.preventDefault();
            dataSet.currentPageNo++;
            loadRealMentorInfo();
        });

        loadRealMentorInfo();
    };

    loadRelMentor('${param.jobNo}');
    //loadRelMentor('1000000000');
});
</script>

<%-- Template ============================================= --%>
<script type="text/html" id="mentorInfo">
<li>
    <div class="title"><strong><a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=\${mbrNo}">\${profTitle} / \${nm}</a></strong>{{if iconKindCd == '101598'}} <em style="float: none; display: inline-block;">재능기부</em>{{/if}}</div>
    <p>
        <a href="#" class="view" title="새창열림" target="_blank">멘토소개보기</a>
        <span>\${profIntdcInfo}</span>
    </p>
</li>
</script>
<%-- Template ============================================= --%>

<!-- 관련멘토 -->
<div class="lesson-connection mento-type tab-cont">
    <h3>관련멘토</h3>
    <ul id="mentor-info-list">
        <%-- <li>
            <div class="title"><strong><a href="#">기업의 경쟁력! 데이터를 관리하는 IT전문가 / 김인범</a></strong></div>
            <p>
                <a href="#" class="view">멘토소개보기</a>
                <span>인류의 건강을 책임질 심층수와 직업세계: 해양심층수란 햇빛이 도달하지 않는 수심 200m 이하 바닷물을 뜻합니다. 2도의 찬 온도와 깊은 수심으로 유기물이나 오염물질이 없으니을 책임질 심층수와 직업세계: 해양심층수란 햇빛이 도달하지 않는 을 책임질 심층수와 직업세계: 해양심층수란...인류의 건강을 책임질 심층수와 직업세계: 해양심층수란 햇빛이 도달하지 않는 수심 200m 이하 바닷물을 뜻합니다. 2도의 찬 온도와 깊은 수심으로 유기물이나 오염물질이 없으니을 책임질 심층수와 직업세계: 해양심층수란 햇빛이 도달하지 않는 을 책임질 심층수와 직업세계: 해양심층수란...</span>
            </p>
        </li> --%>
    </ul>
    <div class="btn-more-view" id="moreMentor">
        <a href="#">더 보기 (<span>00</span>)</a>
    </div>
</div>


