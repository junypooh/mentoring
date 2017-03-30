<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="tab-cont"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
    <div class="board-top">
        <p class="total-num">총 <strong>00</strong> 건</p>
        <ul>
        <li>
            <select id="grpState" name="grpState">
                <option value="">전체</option>
                <option value="1">예정</option>
                <option value="2">진행중</option>
                <option value="3">종료</option>
            </select>
        </li>
        </ul>
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

        $('#grpState').change(function(){
            goSearch(1);
        });
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


        var _param = jQuery.extend({'schNo': '${param.schNo}', 'grpState':$("#grpState option:selected").val()}
                      ,dataSet.params);

        $.ajax({
            url: mentor.contextpath +"/school/info/ajax.schoolAssignGroupState.do",
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var colModels = [];
                colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
                colModels.push({label:'구분', name:'setTargtCd',index:'setTargtCd', width:50, align:'center', sortable: false});
                colModels.push({label:'배정명', name:'grpNm', index:'grpNm', width:60, sortable: false});
                colModels.push({label:'배정기간', name:'clasDay', index:'clasDay', width:100, align:'center', sortable: false});
                colModels.push({label:'상태', name:'grpYn', index:'grpYn', width:60, align:'center', sortable: false});
                colModels.push({label:'주관기관', name:'nm', index:'nm', width:60, align:'center', sortable: false});
                colModels.push({label:'총 배정횟수', name:'clasCnt', index:'clasCnt', width:60, align:'center', sortable: false});
                colModels.push({label:'사용횟수', name:'clasEmpCnt', index:'clasEmpCnt', width:60, align:'center', sortable: false});
                colModels.push({label:'잔여횟수', name:'clasPermCnt', index:'clasPermCnt', width:60, align:'center', sortable: false});

                console.log(rtnData);
                initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
                //initJqGridTable('boardTable', colModels, 10, false);
                //resizeJqGridWidth('boardTable', 'boardArea', 500);
                var timeInMs = Date.now(); // 현재 일자
                var clasCnt = 0;
                var clasEmpCnt = 0;
                var clasPermCnt = 0;
                var assignData = rtnData.map(function(item, index) {
                    // 관련 배정기간 설정
                    if(item.clasStartDay != null && item.clasEndDay != null){
                        item.clasDay = mentor.parseDate(item.clasStartDay).format('yyyy.MM.dd') + "~" + mentor.parseDate(item.clasEndDay).format('yyyy.MM.dd')

                    }
                    if(item.setTargtCd == '101601'){
                        item.setTargtCd = '배정사업';
                     }else{
                        item.setTargtCd = '학교자체';
                     }
                     if(item.clasEmpCnt == 0 && item.clasPermCnt == 0 && item.clasCnt != 0){
                        item.clasPermCnt =  item.clasCnt;
                     }else{
                        item.clasCnt = Number(item.clasPermCnt)+Number(item.clasEmpCnt);
                     }
                     clasCnt += Number(item.clasCnt);
                     clasEmpCnt += Number(item.clasEmpCnt);
                     clasPermCnt += Number(item.clasPermCnt);
                    return item;
                });

                var emptyText = '등록된 사업이 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData, emptyText);
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건 (총 배정횟수 :' + clasCnt + '회 / 사용횟수 : ' + clasEmpCnt + '회 / 잔여횟수 : ' + clasPermCnt + '회)');
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


</script>



