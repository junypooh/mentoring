<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>인기수업</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>프론트관리</li>
            <li>인기수업</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>

        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-style02" onclick="addLecturePopUp()"><span>추가</span></button></li>
                <li><button type="button" class="btn-gray" onclick="removeLecture()"><span>삭제</span></button></li>
            </ul>
        </div>
    </div>
</div>
<c:import url="/popup/layerLectureTimsInfoSearch.do">
    <c:param name="popupId" value="_lectTimsInfoPopup" />
    <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>
<script type="text/javascript">

    var searchFlag = 'load';

    $(document).ready(function() {
        //jqGrid
        var colModels = [];
        colModels.push({label:'노출순서', name:'sortSeq',index:'sortSeq', width:25, align:'center', sortable: false});
        //colModels.push({label:'추천번호', name:'recomSer',index:'recomSer', width:25, align:'center', sortable: false,key: true});
        colModels.push({label:'학교급', name:'lectTargtNm',index:'lectTargtNm', width:50, align:'center', sortable: false});
        colModels.push({label:'유형', name:'lectTypeNm',index:'lectTypeNm', width:50, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:85, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle',index:'lectTitle', align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'lectrMbrNm',index:'lectrMbrNm', align:'center', width:60, sortable: false});
        colModels.push({label:'수업상태', name:'lectStatNm',index:'lectStatNm', align:'center', width:90, sortable: false});
        colModels.push({label:'수업일', name:'lectDay',index:'lectDay', align:'center', width:90, sortable: false});
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
                        data : JSON.stringify({'fromIndex': fromIndex,'toIndex': toIndex, 'id': movedId, 'targtCd':'101643'}),
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
            url: "${pageContext.request.contextPath}/web/front/ajax.popularLectures.do",
            success: callbackListData
        });
    }

    function callbackListData(rtnData){
        var data = rtnData.map(function(item, index) {

            item.gridRowId = item.recomSer;
            item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');
            item.lectDay = item.lectDay.toDay();

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

    function addLecturePopUp(){
        initailizePopup()
    }

    function callbackUpdated(selectedLectures){
        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.insertPopularLecture.do",
            data : JSON.stringify(selectedLectures),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: callbackListData
        });
    }

    function removeLecture(){
        var data = $( "#boardTable" ).jqGrid('getGridParam', 'selarrrow');

        if(data.length == 0){
            alert('삭제하고자 하는 수업을 선택하세요.');
            return false;
        }

        var _param = [];

        data.forEach(function(val,index){
            _param.push({"id":parseInt(val),"targtCd":"101643"});
        });

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.deletePopularLectures.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: callbackListData
        });

    }
</script>
