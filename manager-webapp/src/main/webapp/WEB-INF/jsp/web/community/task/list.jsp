<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>수업과제</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>커뮤니티관리</li>
            <li>수업과제</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="arclSer" name="arclSer" />
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>기간선택</strong>
                <input type="text" id="sStartDate" name="sStartDate" class="date-input" value="${param.sStartDate}" />
                <span> ~ </span>
                <input type="text" id="sEndDate" name="sEndDate" class="date-input" value="${param.sEndDate}" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <strong>검색조건</strong>
                <select id="searchKey" name="searchKey">
                    <option value="all" <c:if test="${param.searchKey eq 'all'}">selected='selected'</c:if>>전체</option>
                    <option value="title" <c:if test="${param.searchKey eq 'title'}">selected='selected'</c:if>>제목</option>
                    <option value="cntntsTargtNm" <c:if test="${param.searchKey eq 'cntntsTargtNm'}">selected='selected'</c:if>>수업명</option>
                    <option value="lectrNm" <c:if test="${param.searchKey eq 'lectrNm'}">selected='selected'</c:if>>멘토명</option>
                    <option value="schNm" <c:if test="${param.searchKey eq 'schNm'}">selected='selected'</c:if>>학교</option>
                    <option value="clasRoomNm" <c:if test="${param.searchKey eq 'clasRoomNm'}">selected='selected'</c:if>>반</option>
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
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-gray"><span>삭제</span></button></li>
            </ul>
        </div>
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

        // Datepicker
        $( "#sStartDate" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#sStartDate").datepicker("option", "maxDate", selectedDate);
            }
        });
        $( "#sEndDate" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#sEndDate").datepicker("option", "minDate", selectedDate);
            }
        });

        // 1일 버튼 클릭 event
        $("#btnDayRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#sEndDate").val(sEndDate);
            //var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 1)).format("yyyy-MM-dd");
            $("#sStartDate").val(sEndDate);
        });

        // 7일 버튼 클릭 event
        $("#btnWeekRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#sEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
            $("#sStartDate").val(sStartDate);
        });

        // 1개월 버튼 클릭 event
        $("#btnMonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#sEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
            $("#sStartDate").val(sStartDate);
        });

        // 6개월 버튼 클릭 event
        $("#btn6MonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#sEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 6)).format("yyyy-MM-dd");
            $("#sStartDate").val(sStartDate);
        });

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
        colModels.push({label:'수업일', name:'lectDay',index:'lectDay', width:40, align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'lectrNm',index:'lectrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:40, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'cntntsTargtNm',index:'cntntsTargtNm', width:80, sortable: false});
        colModels.push({label:'수업과제', name:'title',index:'title', width:80, sortable: false});
        colModels.push({label:'첨부', name:'fileCnt',index:'fileCnt',width:20, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm',index:'regMbrNm',width:50, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm',width:50, align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm',width:50, align:'center', sortable: false});
        colModels.push({label:'반', name:'clasRoomNm',index:'clasRoomNm',width:40, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', width:40, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);

        //jqGrid setting
        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({
                       'boardId' : 'lecWork'
                      ,'sStartDate':$('#sStartDate').val()
                      ,'sEndDate':$('#sEndDate').val()
                      ,'searchKey':$("#searchKey").val()
                      ,'searchWord':$("#searchWord").val()
                      }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/web/community/ajax.classTaskList.do",
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
                    item.lectDay = to_date_format(item.lectDay, '.');
                    var strLinkUrl = mentor.contextpath + "/web/community/task/view.do?arclSer=" + item.arclSer;
                    //item.title = "<a href='" + strLinkUrl + "' class='underline'>" + item.title + "</a>";
                    item.title = "<a href='javascript:void(0)' class='underline' onclick='goView(\"" + item.arclSer + "\")'>" + item.title + "</a>";
                    item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');

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