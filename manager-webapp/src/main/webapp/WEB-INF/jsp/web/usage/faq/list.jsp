<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>자주찾는질문</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>커뮤니티관리</li>
            <li>자주찾는질문</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="arclSer" name="arclSer" />
    <input style="display:none;"> <%-- 폼에 input text가 하나만 존재하면 엔터키로 무조건 submit을 막기위해 --%>
    <div class="search-area general-srch">
        <ul>
            <li class="condition-big">
                <p><strong>채널</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="expsTargtCd" value="" <c:if test="${empty param.expsTargtCd}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="expsTargtCd" value="101635" <c:if test="${param.expsTargtCd eq '101635'}">checked='checked'</c:if> /> 학교포탈</label>
                    </li>
                    <li>
                        <label><input type="radio" name="expsTargtCd" value="101636" <c:if test="${param.expsTargtCd eq '101636'}">checked='checked'</c:if> /> 멘토포탈</label>
                    </li>
                </ul>
            </li>
            <li class="condition-big">
                <p><strong>문의유형</strong></p>
                <spring:eval expression="@comunityService.getBoardPrefInfo('mtFAQ')" var="list" />
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="prefNo" value="" <c:if test="${empty param.prefNo}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <c:forEach items="${list}" var="list" varStatus="vs">
                    <li>
                        <label><input type="radio" name="prefNo" value="${list.prefNo}" <c:if test="${list.prefNo eq param.prefNo}">checked='checked'</c:if> /> ${list.prefNm}</label>
                    </li>
                    </c:forEach>
                </ul>
            </li>
            <li class="condition-big">
                <strong>조건검색</strong>
                <select id="searchKey" name="searchKey">
                    <option value="all" <c:if test="${param.searchKey eq 'all'}">selected='selected'</c:if>>전체</option>
                    <option value="title" <c:if test="${param.searchKey eq 'title'}">selected='selected'</c:if>>제목</option>
                    <option value="sust" <c:if test="${param.searchKey eq 'sust'}">selected='selected'</c:if>>내용</option>
                </select>
                <input type="text" id="searchWord" name="searchWord" value="${param.searchWord}">
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onClick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
    </div>
    <div class="board-bot">
        <ul>
            <li><button type="button" class="btn-orange" onClick="javascript:location.href='${pageContext.request.contextPath}/web/usage/faq/view.do'"><span>등록</span></button></li>
            <li><button type="button" class="btn-gray"><span>삭제</span></button></li>
        </ul>
    </div>
</div>

<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={loadData} totalRecordCount={0} currentPageNo={1} recordCountPerPage={20} pageSize={10} />,
        document.getElementById('paging')
    );
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

    var searchFlag = 'load';

    $(document).ready(function(){
        enterFunc($("#searchWord"),goSearch);
        loadData(1);
    });

    function goSearch(curPage){
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(arclSer) {
        $('#arclSer').val(arclSer);
        var qry = $('#frm').serialize();
        $(location).attr('href', 'view.do?' + qry);
    }

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
        colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'채널', name:'expsTargtNm',index:'expsTargtNm', width:40, align:'center', sortable: false});
        colModels.push({label:'분류', name:'prefNm',index:'prefNm', width:40, align:'center', sortable: false});
        colModels.push({label:'질문', name:'title',index:'title', width:70, sortable: false});
        colModels.push({label:'작성자', name:'regMbrNm',index:'regMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm',width:60, align:'center', sortable: false});
        colModels.push({label:'조회수', name:'vcnt',index:'vcnt', width:20, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({
                       'boardId' : 'mtFAQ'
                      ,'prefNo':$('input[name=prefNo]:checked').val()
                      ,'expsTargtCd':$('input[name=expsTargtCd]:checked').val()
                      ,'searchKey':$("#searchKey").val()
                      ,'searchWord':$("#searchWord").val()
                      }, dataSet.params);

                      //console.log(_param);

        $.ajax({
            url: "${pageContext.request.contextPath}/web/community/ajax.simpleArclList.do",
            data : $.param(_param, true),
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }


                var data = rtnData.map(function(item, index) {
                    item.gridRowId = item.arclSer;
                    item.rn = totalCount - item.rn + 1;
                    item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');
                    var strLinkUrl = mentor.contextpath + "/web/usage/faq/view.do?arclSer=" + item.arclSer;
                    //item.title = "<a href='" + strLinkUrl + "' class='underline'>" + item.title + "</a>";
                    item.title = "<a href='javascript:void(0)' class='underline' onclick='goView(\"" + item.arclSer + "\")'>" + item.title + "</a>";

                    return item;
                });

                // grid data binding
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable', 'boardArea', 500, data, emptyText);
                // grid data binding


                mentor.pageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });

    }

    // 삭제버튼 클릭
    $('.btn-gray').click(function(){
        if(confirm("삭제하시겠습니까?")){
            var arclSers =  $('#boardTable').jqGrid('getGridParam','selarrrow');
            $.ajax({
                url: "${pageContext.request.contextPath}/web/community/ajax.deleteArcl.do",
                data : {'arclSers':arclSers},
                contentType: "application/json",
                dataType: 'json',
                type: 'GET',
                traditional: true,
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert(rtnData.data);
                        location.reload();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.deleteArcl.do", status, err.toString());
                }
            });

        }
    });

</script>