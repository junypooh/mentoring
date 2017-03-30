<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
</security:authorize>

<!-- 멘토자료 -->
<div class="lesson-introduce navi-content tab-cont active">
    <h3>멘토자료</h3>
    <ul class="lesson-data-list" id="dataList"></ul>
    <div class="paging" id="paging"></div>
</div>
<!-- //멘토자료 -->


<%-- Template ================================================================================ --%>
<script type="text/html" id="listDataInfo">
<li>
    <div class="title">
        <a href="javascript:void(0);" onClick="dataDetailShow(this, \${dataSer});">
            <em>\${dataNm}</em>
            <span class="file">\${dataTypeNm}</span>
        </a>
    </div>
    <div class="file-list">
        <div class="relation-lesson">
        </div>
        <ul>
            {{if dataTypeCd == '101761'}}
                <li>
                    <span class="file-type link">
                        <!-- span>\${linkTitle}</span><a href="\${dataUrl}" class="link-addr" target="_blank">\${dataUrl}</a -->
                        <span><a href="\${dataUrl}" class="link-addr" target="_blank">\${linkTitle}</a></span>
                    </span>
                </li>
            {{else dataTypeCd == '101760'}}
                <li>
                    <span class="file-type avi">
                        <a href="javascript:videoPlay(\${cntntsId});">\${fileTitle}</a>
                    </span>
                </li>
            {{else dataTypeCd == '101759'}}
                <li>
                    <span class="file-type jpg">
                        {{if '${id}' == '' || '${id}' == null}}
                        <a href="javascript:void(0)" onclick="alert('로그인 후 이용이 가능합니다.'); $(location).attr('href','${pageContext.request.contextPath}/login.do');">\${oriFileNm}</a>
                        {{else}}
                        <a href="${pageContext.request.contextPath}/fileDown.do?origin=true&fileSer=\${fileSer}">\${oriFileNm}</a>
                        {{/if}}
                    </span>
                    <span class="file-size">\${Math.ceil(fileSize/1024/1024)}MB</span>
                </li>
            {{/if}}
        </ul>
    </div>
</li>
</script>
<%-- Template ================================================================================ --%>


<%-- Template ================================================================================ --%>
<script type="text/html" id="emptyData">
<li>
    <div class="title">
        <a href="javascript:void(0);">
            <p><center>등록된 자료가 없습니다.</center></p>
        </a>
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
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:fn_mentorData, totalRecordCount:0, recordCountPerPage:5, pageSize:10}),
            document.getElementById('paging')
    );


    $(document).ready(function(){
        fn_mentorData();
    });

    function fn_mentorData(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'ownerMbrNo' : '${param.mbrNo}'
              , 'intdcDataYn' : 'Y'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.lectureDataList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                    $("#dataList").empty();
                    $("#listDataInfo").tmpl(rtnData).appendTo("#dataList");
                }else{
                    $("#dataList").empty();
                    $("#emptyData").tmpl(1).appendTo("#dataList");
                }
                dataSet.params.totalRecordCount = totalCount;



                mentor.pageNavi.setData(dataSet.params);

                //detailTab();

            }
        });
    }

    /* 동영상재생 */
    function videoPlay(cntntsId){
        window.open("http://movie.career.go.kr/test/player/index.asp?cID="+ cntntsId, "", "scrollbars=no, resizeable=no, width=672, height=590");
    }

    /* 상세 펼치기 */
    function dataDetailShow(obj, dataSer){
        if(!$(obj).parent().hasClass('active')){
            $('.lesson-data-list .title').removeClass('active');
            $(obj).parent().addClass('active');

        }else{
            $(obj).parent().removeClass('active');
        }
        //수업자료일때만 사용
        //getConnectLect(dataSer, obj);

    }

    /* 연결수업 조회 */
    function getConnectLect(dataSer, obj){
        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.connectLectList.do',
            data : {'dataSer' : dataSer},
            dataType: 'json',
            success: function(rtnData) {
                if(rtnData.length > 0){
                    var str = '';
                    str += '<span>';
                    str += '<strong>관련수업 </strong>';

                    for(var i=0; rtnData.length > i; i++){
                        if( i > 0 ){
                            str += ',';
                        }
                        str += '<a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer'+rtnData[i].lectSer+'&lectTims=1&schdSeq=1">'+rtnData[i].lectTitle+'</a>';
                    }
                    str += '</span>';
                    $(obj).parent().parent().find('.relation-lesson').empty().append(str);
                }
            }
        });
    }


</script>