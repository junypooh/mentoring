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
        var _param = jQuery.extend({'schNo': '${param.schNo}'
                                          ,'schMbrCualfCd': '101698'
                                          ,'cualfRegStatCd': '101702'}, dataSet.params);



        $.ajax({
            url: mentor.contextpath +"/school/info/ajax.schoolClassTcherRepresent.do",
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var colModels = [];
                colModels.push({label:'구분', name:'schMbrCualfNm',index:'schMbrCualfNm', width:25, align:'center', sortable: false});
                colModels.push({label:'학교', name:'schNm',index:'schNm', width:50, align:'center', sortable: false});
                colModels.push({label:'아이디', name:'userId', index:'userId', width:60, sortable: false});
                colModels.push({label:'이름', name:'username', index:'username', width:60, align:'center', sortable: false});
                colModels.push({label:'등록자', name:'authNm', index:'authNm', width:60, align:'center', sortable: false});
                colModels.push({label:'등록일', name:'authDtm', index:'authDtm', width:60, align:'center', sortable: false});

                console.log(rtnData);
                initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
                //initJqGridTable('boardTable', colModels, 10, false);
                //resizeJqGridWidth('boardTable', 'boardArea', 500);

                var emptyText = '등록된 학교 대표 교사가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData, emptyText);

                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                }
            }
        });
    }


</script>



