<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<table class="tbl-style">
    <colgroup>
        <col style="width:147px;" />
        <col />
        <col style="width:147px;" />
        <col />
    </colgroup>
    <tbody>
        <tr>
            <th scope="col" class="ta-l">기간검색</th>
            <td colspan="3">
                <input type="text" id="searchStDate" class="date-input text" />
                <span> ~ </span>
                <input type="text" id="searchEndDate" class="date-input text" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </td>
            <tr>
                <th scope="col" class="ta-l">수업명</th>
                <td><input type="text" class="text" id="lectTitle" name="lectTitle" /></td>
                <th scope="col" class="ta-l">멘토명</th>
                <td><input type="text" class="text" id="lectrNm" name="lectrNm" /></td>
            </tr>
            <tr>
                <th scope="col" class="ta-l">학교</th>
                <td><input type="text" class="text" id="schNm" name="schNm" /></td>
                <th scope="col" class="ta-l">교실명</th>
                <td><input type="text" class="text" id="clasRoomNm" name="clasRoomNm" /></td>
            </tr>
        </tr>
    </tbody>
</table>
<p class="search-btnbox">
    <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
</p>
<div class="board-top">
    <p class="total-num">총 <strong>0</strong> 건</p>
    <ul>
    <li>
        <select id="lectStatCd">
            <option value="">전체</option>
            <option value="101543">수강모집</option>
            <option value="101547">모집취소</option>
            <option value="101548">수업예정</option>
            <option value="101550">수업중</option>
            <option value="101551">수업완료</option>
        </select>
    </li>
</ul>
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

    var searchFlag = 'load';

    mentor.PageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:loadData, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );

    $(document).ready(function() {

        enterFunc($("#lectTitle"), goSearch);
        enterFunc($("#lectrNm"), goSearch);
        enterFunc($("#schNm"), goSearch);
        enterFunc($("#clasRoomNm"), goSearch);

        $('#lectStatCd').change(function() {
            goSearch(1);
        });

        $( "#searchStDate" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#searchEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $( "#searchEndDate" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#searchStDate").datepicker("option", "maxDate", selectedDate);
            }
        });

        // 1일 버튼 클릭 event
        $("#btnDayRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            //var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 1)).format("yyyy-MM-dd");
            $("#searchStDate").val(sEndDate);
        });

        // 7일 버튼 클릭 event
        $("#btnWeekRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
            $("#searchStDate").val(sStartDate);
        });

        // 1개월 버튼 클릭 event
        $("#btnMonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
            $("#searchStDate").val(sStartDate);
        });

        // 6개월 버튼 클릭 event
        $("#btn6MonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 6)).format("yyyy-MM-dd");
            $("#searchStDate").val(sStartDate);
        });

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    // 수업 현황 조회
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
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle', width:70, sortable: false});
        colModels.push({label:'멘토명', name:'lectrNm', index:'lectrNm', width:30, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm', index:'lectrNm', width:30, align:'center', sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', width:40, align:'center', sortable: false});
        colModels.push({label:'유형', name:'applClassNm', index:'applClassNm', width:20, align:'center', sortable: false});
        colModels.push({label:'수업상태', name:'lectStatNm', index:'lectStatNm', width:30, align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm', index:'schNm', width:35, align:'center', sortable: false});
        colModels.push({label:'교실명', name:'clasRoomNm', index:'clasRoomNm', width:40, align:'center', sortable: false});
        colModels.push({label:'신청일/취소일', name:'regDtm', index:'regDtm', width:20, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'regStatCd':$("#regStatCd").val()
                                    ,'mbrNo': ${param.reqMbrNo}
                                    ,'lectStatCd':$("#lectStatCd").val()
                                    ,'lectTitle':$("#lectTitle").val()
                                    ,'lectrNm':$("#lectrNm").val()
                                    ,'schNm':$("#schNm").val()
                                    ,'clasRoomNm':$("#clasRoomNm").val()
                                    ,'searchStDate':$("#searchStDate").val()
                                    ,'searchEndDate':$("#searchEndDate").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/general/ajax.tabLectureList.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.regDtm = new Date(item.regDtm).format('yyyy.MM.dd');
                    item.lectDay = String(item.lectDay).toDay() + " " + String(item.lectStartTime).toTime() + "(" + item.lectRunTime + "분)";
                    item.lectTitle = "[" + item.lectTypeNm + "] " + item.lectTitle;

                    return item;
                });

                // grid data binding
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '신청한 수업 정보가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
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