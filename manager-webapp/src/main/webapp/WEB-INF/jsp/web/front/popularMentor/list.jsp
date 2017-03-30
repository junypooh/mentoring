<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>인기멘토</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>프론트관리</li>
            <li>인기멘토</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>

        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-style02" onclick="addMentorPopUp()"><span>추가</span></button></li>
                <li><button type="button" class="btn-gray" onclick="removeMentor()"><span>삭제</span></button></li>
            </ul>
        </div>
    </div>
</div>
<c:import url="/popup/layerRecommandMentorSearch.do">
    <c:param name="popupId" value="_mentorInfoPopup" />
    <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>
<script type="text/javascript">

    var searchFlag = 'load';

    var recomTargtCd = '101642';

    $(document).ready(function() {
        //jqGrid
        var colModels = [];
        colModels.push({label:'노출순서', name:'sortSeq',index:'sortSeq', width:25, align:'center', sortable: false});
        //colModels.push({label:'추천번호', name:'recomSer',index:'recomSer', width:25, align:'center', sortable: false,key: true});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:50, align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'mbrNm',index:'mbrNm', width:50, align:'center', sortable: false});
        colModels.push({label:'예정수업일', name:'expectLectDay',index:'expectLectDay', width:85, align:'center', sortable: false});
        colModels.push({label:'최근종료수업일', name:'recentLectDay',index:'recentLectDay', align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', align:'center', width:90, sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);

        //jQuery("#grid_id").getRowData( rowid );

        goSearch();

        jQuery("#boardTable").jqGrid('sortableRows',
                {
                    update : function(e,ui) {
                        var movedId = ui.item[0].id;
                        var toIndex = ui.item[0].rowIndex;
                        var fromIndex = parseInt(ui.item[0].children[1].firstChild.data);

                        console.log("fromIndex : %d , toIndex : %d",fromIndex,toIndex);

                        $('.jqgrid-overlay').show();
                        $('.loading').show();

                        $.ajax({
                            url: "${pageContext.request.contextPath}/web/front/ajax.changeOrder.do",
                            data : JSON.stringify({'fromIndex': fromIndex,'toIndex': toIndex, 'id': movedId, 'targtCd':recomTargtCd}),
                            contentType: "application/json",
                            dataType : "json",
                            method:"post",
                            success: callbackListData
                        });

                    }});
    });

    function goSearch(){
        searchFlag = 'search';

        $('.jqgrid-overlay').show();
        $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.popularMentors.do",
            success: callbackListData
        });
    }

    function callbackListData(rtnData){
        debugger
        var data = rtnData.map(function(item, index) {

            item.gridRowId = item.recomSer;
            item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');
            item.expectLectDay = item.expectLectDay ? item.expectLectDay.toDay() : '';
            item.recentLectDay = item.recentLectDay ? item.recentLectDay.toDay() : '';

            return item;
        });

        if(rtnData != null && rtnData.length > 0) {
            $('.cont .board-top .total-num').html('총 <strong>' + rtnData.length +'</strong> 건');
        } else {
            $('.cont .board-top .total-num').html('총 <strong>0</strong> 건');
        }

        // grid data binding
        var emptyText = '';
        if(searchFlag == 'load') {
            emptyText = '등록된 데이터가 없습니다.';
        } else {
            emptyText = '검색된 결과가 없습니다.';
        }
        setDataJqGridTable('boardTable', 'boardArea', 500, data, emptyText);

        $('.loading').hide();
        $('.jqgrid-overlay').hide();
    }

    function addMentorPopUp(){
        initailizePopup()
    }

    function callbackUpdated(selectedMentors){
        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.insertPopularMentor.do",
            data : JSON.stringify(selectedMentors),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: callbackListData
        });
    }

    function removeMentor(){
        var data = $( "#boardTable" ).jqGrid('getGridParam', 'selarrrow');

        if(data.length == 0){
            alert('삭제하고자 하는 멘토를 선택하세요.');
            return false;
        }

        var _param = [];

        data.forEach(function(val,index){
            _param.push({"id":parseInt(val),"targtCd":recomTargtCd});
        });

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.deletePopularMentors.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: callbackListData
        });

    }
</script>
