<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 관련멘토 -->
<div class="lesson-connection mento-type tab-cont active">
    <p class="result-total"> 총 : <strong>00</strong> 명 </p>
    <ul id="relationList"></ul>
    <div class="paging" id="paging"></div>
</div>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listRelationInfo">
    <li>
        <span class="comento-pic">
            {{if profFileSer != null}}
                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${profFileSer}" alt="멘토 \${nm} 사진">
            {{else}}
                <img src="${pageContext.request.contextPath}/images/common/img_profile_default.jpg" alt="멘토 \${nm} 사진">
            {{/if}}
        </span>
        <div class="title"><strong><a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=\${mbrNo}">\${profTitle} <span>\${nm}</span></a></strong></div>
        <p>
            <a href="javascript:void(0);" onClick="fn_introduceShow(this);" class="view">멘토소개보기</a>
            <span>\${profIntdcInfo}</span>
        </p>
    </li>
</script>
<%-- Template ================================================================================ --%>

<%-- Template ================================================================================ --%>
<script type="text/html" id="emptyRelation">
    <li>
        <p><center>등록된 관련 멘토가 없습니다.</center></p>
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
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:fn_mentorRelation, totalRecordCount:0, recordCountPerPage:5, pageSize:dataSet.params.pageSize}),
            document.getElementById('paging')
    );

    $(document).ready(function(){
        fn_mentorRelation();
    });

    function fn_mentorRelation(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
            'mbrNo' : '${param.mbrNo}'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.mentorRelation.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                    $("#relationList").empty();
                    $("#listRelationInfo").tmpl(rtnData).appendTo("#relationList");
                }else{
                    $("#relationList").empty();
                    $("#emptyRelation").tmpl(1).appendTo("#relationList");
                }
                dataSet.params.totalRecordCount = totalCount;

                $('.result-total > strong').text(totalCount);


                mentor.pageNavi.setData(dataSet.params);

            }
        });
    }

    // 모바일용 멘토소개 보기
    function fn_introduceShow(obj){
        if($('#relationList > li > p > a').hasClass('active')){
            if($(obj).hasClass('active')){
                $(obj).removeClass('active');
            }else{
                $('#relationList > li > p > a').removeClass('active');
                $(obj).addClass('active');
            }
        }else{
            $(obj).addClass('active');
        }
    }


</script>