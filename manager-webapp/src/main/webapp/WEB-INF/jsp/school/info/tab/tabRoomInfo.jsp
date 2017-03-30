<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="tab-cont"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
    <div class="board-top">
        <p class="total-num">총 <strong>00</strong> 건</p>
    </div>
    <div id="boardArea">
    <table id="boardTable"></table>
    </div>
    <div id="tcherPaging"></div>
</div>

<script type="text/jsx;harmony=true">
/*
     mentor.schoolTcherPageNavi = React.render(
        React.createElement(PageNavi, {pageFunc:'goSearch', totalRecordCount:'0', recordCountPerPage:'10',pageSize:'10'}),
        document.getElementById('tcherPaging')
    );
*/
</script>

<script type="text/javascript">

     mentor.schoolTcherPageNavi = React.render(
        React.createElement(PageNavi, {pageFunc:goSearch, totalRecordCount:'0', recordCountPerPage:'10',pageSize:'10'}),
        document.getElementById('tcherPaging')
    );
    /*
    mentor.schoolTcherPageNavi = React.render(
        React.createElement(
            PageNavi,
                { pageFunc: goSearch, totalRecordCount: 0, currentPageNo: 1, recordCountPerPage: 10, pageSize :10 }
        )
        , document.getElementById('tcherPaging'));
*/
    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    $(document).ready(function() {
        goSearch(1);
    });

    function goSearch(curPage, recordCountPerPage){
    console.log(curPage);
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }


        var _param = jQuery.extend({'schNo': '${param.schNo}'}
                      ,dataSet.params);

        $.ajax({
            url: mentor.contextpath +"/school/info/ajax.schoolClassRoomInfo.do",
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var colModels = [];
                colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
                colModels.push({label:'구분', name:'clasRoomType',index:'clasRoomType', width:50, align:'center', sortable: false});
                colModels.push({label:'교실명', name:'clasRoomNm', index:'clasRoomNm', width:60, sortable: false});
                colModels.push({label:'개설자', name:'tchrMbrNm', index:'tchrMbrNm', width:60, align:'center', sortable: false});
                colModels.push({label:'등록신청중', name:'clasUserCnt', index:'clasUserCnt', width:60, align:'center', sortable: false});
                colModels.push({label:'학생현황', name:'studCnt', index:'studCnt', width:60, align:'center', sortable: false});
                colModels.push({label:'개설일', name:'reqDtm', index:'reqDtm', width:60, align:'center', sortable: false});
                colModels.push({label:'관리 교사', name:'tchrNm', index:'tchrNm', width:60, sortable: false, cellattr: function(rowId, val, rawObject, cm, rdata) { return 'title="' + String(rawObject.username).replaceAll(',', '\r\n') +'"'} });
                colModels.push({label:'관리', name:'clasRoomSer', index:'clasRoomSer', width:60, align:'center', sortable: false});

                console.log(rtnData);
                initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
                //initJqGridTable('boardTable', colModels, 10, false);
                //resizeJqGridWidth('boardTable', 'boardArea', 500);

                var schoolData = rtnData.map(function(item, index) {
                    // 관련 교사 설정
                    var tcheres = [];
                    if(item.tchrNm != null) {
                        classes = item.tchrNm.split(",");
                        if(classes.length > 1) {
                            item.tchrNm = classes[0] + " > 외" + (classes.length-1);
                        } else {
                            item.tchrNm = classes[0];
                        }
                    }
                    if(item.clasRoomSer != null) {
                        var clasRoomSer = '<button type="button" class="btn-style01" onClick="clickDelete('+item.clasRoomSer+');"><span>삭제</span></button>';
                        item.clasRoomSer = clasRoomSer;
                    }
                    return item;
                });
                var emptyText = '등록된 교실 정보가 없습니다..';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData, emptyText);

                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.schoolTcherPageNavi.setData(dataSet.params);

            }
        });
    }


    function clickDelete(index){
        if(!confirm('삭제 하시겠습니까?')){
            return false;
        }

        var _param = jQuery.extend({'schNo': '${param.schNo}'
                              ,'clasRoomSers': index
                              }, dataSet.params);
        //return false;
            $.ajax({
                url: mentor.contextpath +"/school/info/ajax.deleteSchoolTcher.do",
                data : _param,
                contentType: "application/json",
                dataType: 'json',
                success: function(rtnData) {
                    if (rtnData.success) {
                    alert("삭제되었습니다");
                        tabmenu(2);
                    }
                }
            });


        }


</script>



