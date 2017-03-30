<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2><c:if test="${param.bannerType eq '101640'}">멘토배너관리</c:if><c:if test="${param.bannerType eq '101639'}">학교배너관리</c:if></h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>프론트관리</li>
            <li><c:if test="${param.bannerType eq '101640'}">멘토배너관리</c:if><c:if test="${param.bannerType eq '101639'}">학교배너관리</c:if></li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>

        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-style02" onclick="addBanner()"><span>추가</span></button></li>
                <li><button type="button" class="btn-gray" onclick="removeBanner()"><span>삭제</span></button></li>
            </ul>
        </div>
    </div>
    <form name="frm" id="frm" method="get">
        <input type="hidden" name="bnrTypeCd" value="${param.bannerType}"/>
    </form>
</div>
<%--<c:import url="/popup/layerMentors.do">
    <c:param name="popupId" value="_mentorInfoPopup" />
</c:import>--%>
<script type="text/javascript">

    var searchFlag = 'load';
    var totalCount;

    $(document).ready(function() {
        //jqGrid
        var colModels = [];
        colModels.push({label:'노출순서', name:'dispSeq',index:'dispSeq', width:25, align:'center', sortable: false});
        colModels.push({label:'구분', name:'bnrZoneNm',index:'bnrZoneNm', width:45, align:'center', sortable: false, key: true});
        colModels.push({label:'배너위치', name:'bnrTypeNm',index:'bnrTypeNm', width:60, align:'center', sortable: false});
        colModels.push({label:'배너명', name:'bnrNm',index:'bnrNm',  align:'center', sortable: false});
        colModels.push({label:'노출여부', name:'useYn',index:'useYn', align:'center', width:50, sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm',index:'regMbrNm', align:'center', width:120, sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', align:'center', width:120, sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);

        //jQuery("#grid_id").getRowData( rowid );

        goSearch();

        jQuery("#boardTable").jqGrid('sortableRows',
                {
                    update : function(e,ui) {
                        var movedId = ui.item[0].id;
                        var toIndex = ui.item[0].rowIndex;
                        var fromIndex = parseInt(ui.item[0].children[1].firstChild.data);

                        console.log("fromIndex : %d , toIndex : %d, id : %s, targtCd : %s",fromIndex,toIndex,movedId,${param.bannerType});

                        $('.jqgrid-overlay').show();
                        $('.loading').show();

                        $.ajax({
                            url: "${pageContext.request.contextPath}/web/front/ajax.changeBnrOrder.do",
                            data : JSON.stringify({'fromIndex': fromIndex,'toIndex': toIndex, 'id': movedId, 'targtCd':${param.bannerType}}),
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


        var _param = {
            'bnrTypeCd': ${param.bannerType}
            ,'useYn':'Y'
        };

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.bnrList.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: callbackListData
        });
    }

    function callbackListData(rtnData){

        totalCount = rtnData.length;
        var data = rtnData.map(function(item, index) {

            item.rn = totalCount - item.rn + 1;
            item.gridRowId = item.bnrSer;
            if(item.useYn == 'Y') item.useYn = '노출';
            else item.useYn = '노출안함';
            item.regDtm = (new Date(item.regDtm)).format('yyyy-MM-dd');


            var url = "";
            <c:if test="${param.bannerType eq '101640'}"> url = "/web/front/mentorBanner/imageBannerEdit.do";</c:if>
            <c:if test="${param.bannerType eq '101639'}"> url = "/web/front/mainBanner/imageBannerEdit.do";</c:if>;

            var strLinkUrl = mentor.contextpath +  url +"?bnrSer=" + item.bnrSer;

            debugger

            item.bnrNm = "<a class='underline' href=" + strLinkUrl +"><div>" + item.bnrNm + "</div></a>";
            return item;
        });

        if(rtnData != null && rtnData.length > 0) {
            $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
        } else {
            $('.board-top .total-num').html('총 <strong>0</strong> 건');
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

    function addBanner(){
        var bannerCount = <c:if test="${param.bannerType eq '101640'}">4</c:if><c:if test="${param.bannerType eq '101639'}">5</c:if>;

        if(totalCount >= bannerCount) {
            alert('최대 ' + bannerCount + '개의 배너만 등록할 수 있습니다.');
            return;
        }

        var menuId = '<c:if test="${param.bannerType eq '101640'}">mentorBanner</c:if><c:if test="${param.bannerType eq '101639'}">mainBanner</c:if>';
        $('#frm').attr('action','${pageContext.request.contextPath}/web/front/' + menuId + '/imageBannerEdit.do');
        $('#frm').submit();
    }

    function removeBanner(){
        var data = $( "#boardTable" ).jqGrid('getGridParam', 'selarrrow');

        if(data.length == 0){
            alert('삭제하고자 하는 배너를 선택하세요.');
            return false;
        }

        var _param = [];

        data.forEach(function(val,index){
            _param.push({"id":parseInt(val),"targtCd":${param.bannerType}});
        });

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.deleteBnrInfo.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: callbackListData
        });

    }
</script>
