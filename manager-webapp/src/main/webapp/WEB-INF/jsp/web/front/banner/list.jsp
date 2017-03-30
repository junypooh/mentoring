<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>배너관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>WEB관리</li>
            <li>프론트관리</li>
            <li>배너관리</li>
        </ul>
    </div>
    <div class="search-area">
        <ul>
            <li>
                <strong>구분/위치</strong>
                <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101633_배너구역코드'])" var="bnrZoneCds" />
                <select id="bnrZoneCd" style="width:162px;">
                    <c:forEach items="${bnrZoneCds}" var="eachObj" varStatus="vs">
                        <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                    </c:forEach>
                </select>
                <select id="bnrTypeCd" style="width:162px;">
                    <option value="101638">상단띠배너</option>
                </select>
            </li>
            <li>
                <strong>노출여부</strong>
                <select id="useYn" style="width:162px;">
                    <option value="">전체</option>
                    <option value="Y">노출</option>
                    <option value="N">노출안함</option>
                </select>
            </li>
        </ul>
        <p class="search-btnbox">
            <a href="javascript:void(0)" onclick="goSearch(1)"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색" /></a>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
		<div class="board-bot">
            <ul>
                <li><a href="edit.do"><img src="${pageContext.request.contextPath}/images/btn_regist.gif" alt="등록" /></a></li>
                <li><a href="${pageContext.request.contextPath}/web/front/banner/deleteBanner" onclick="removeBanner();return false;">
                    <img src="${pageContext.request.contextPath}/images/btn_delet.gif" alt="삭제" /></a>
                </li>
            </ul>
        </div>
    </div>
</div>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    var searchFlag = 'load';

    $(document).ready(function() {

        //enterFunc($("#grpNm"),goSearch);
        //enterFunc($("#schNm"),goSearch);
        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'구분', name:'bnrZoneNm',index:'bnrZoneNm', width:45, align:'center', sortable: false, key: true});
        colModels.push({label:'배너위치', name:'bnrTypeNm',index:'bnrTypeNm', width:60, align:'center', sortable: false});
        colModels.push({label:'배너명', name:'bnrNm',index:'bnrNm',  align:'center', sortable: false});
        colModels.push({label:'노출여부', name:'useYn',index:'useYn', align:'center', width:50, sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm',index:'regMbrNm', align:'center', width:120, sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', align:'center', width:120, sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);
        //resizeJqGridWidth('boardTable', 'boardArea', 500);

        goSearch(1);
    });

    function goSearch(curPage, recordCountPerPage){

        $('.jqgrid-overlay').show();
        $('.loading').show();

        searchFlag = 'search';
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        var _param = jQuery.extend({'bnrZoneCd':$("#bnrZoneCd").val()
                      ,'bnrTypeCd':$("#bnrTypeCd").val()
                      ,'useYn':$("#useYn").val()
                      }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.bnrList.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: function(rtnData) {

            console.log(rtnData);

                var totalCount = rtnData[0].totalRecordCount;
                var data = rtnData.map(function(item, index) {

                    item.rn = totalCount - item.rn + 1;
                    item.gridRowId = item.bnrSer;
                    if(item.useYn == 'Y') item.useYn = '노출';
                    else item.useYn = '노출안함';
                    item.regDtm = (new Date(item.regDtm)).format('yyyy-MM-dd');

                    var strLinkUrl = mentor.contextpath + "/web/front/banner/edit.do?bnrSer=" + item.bnrSer;
                    item.bnrNm = "<a class='underline' href=" + strLinkUrl +"><div>" + item.bnrNm + "</div></a>";
                    return item;
                });

                if(rtnData != null && rtnData.length > 0) {
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                // grid data binding
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable', 'boardArea', 500, data, emptyText);

                mentor.pageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    function removeBanner(){
        var data = $( "#boardTable" ).jqGrid('getGridParam', 'selarrrow');

        if(data.length == 0){
            alert('삭제하고자 하는 배너를 선택하세요.');
            return false;
        }

        var _param = [];

        data.forEach(function(val,index){
            _param.push({"id":parseInt(val)});
        });

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.deleteBanner.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: function(rtnData){
                if(rtnData.success){
                    alert('삭제되었습니다.');
                } else {
                    alert('삭제중 에러가 발생하였습니다.');
                }
                goSearch();
            }
        });

    }
</script>
<script type="text/javascript">
    mentor.pageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:goSearch, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );
</script>
