<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="board-top">
    <p class="total-num">총 <strong>0</strong> 건</p>
</div>
<table id="boardTable"></table>
<div id="paging"></div>

<script type="text/javascript">

    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function() {

        loadData(1);
    });

    mentor.PageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:loadData, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );

    // 반 대표 조회
    function loadData(curPage, recordCountPerPage){

        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'번호', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm', index:'schNm', width:70, sortable: false});
        colModels.push({label:'교실명', name:'clasRoomNm', index:'clasRoomNm', width:70, sortable: false});
        colModels.push({label:'반대표', name:'repStdntNm', index:'repStdntNm', width:50, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'repStdntRegMbrNm', index:'repStdntRegMbrNm', width:50, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'repStdntRegDtm', index:'repStdntRegDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'reqMbrNo': ${param.reqMbrNo}}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/teacher/ajax.tabClassRepList.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.repStdntRegDtm = new Date(item.repStdntRegDtm).format('yyyy.MM.dd');
                    item.repStdntNm = item.repStdntNm + " (" + item.repStdntClassNm + ")";
                    item.repStdntRegMbrNm = item.repStdntRegMbrNm + " (" + item.repStdntRegMbrClassNm + ")";

                    return item;
                });

                // grid data binding
                var emptyText = '등록된 반대표 이력이 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 1300, memberData, emptyText);
                // grid data binding

                if(rtnData != null && rtnData.length > 0) {
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.PageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

</script>