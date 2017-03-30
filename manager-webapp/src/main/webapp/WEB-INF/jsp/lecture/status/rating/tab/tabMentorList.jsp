<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<table class="tbl-style">
    <colgroup>
        <col style="width:147px;" />
        <col />
        <col style="width:147px;" />
        <col />
    </colgroup>
    <tbody>
        <tr>
            <th scope="col" class="ta-l">멘토</th>
            <td>
                <input type="text" class="text" id="lectrNm" />
            </td>
            <th scope="col" class="ta-l">직업</th>
            <td>
                <input type="text" class="text" id="jobNm" />
            </td>
        </tr>
        <tr>
        <th scope="col" class="ta-l">기간검색</th>
            <td>
                <input type="text" id="lectStartDay" class="date-input text" />
                <span> ~ </span>
                <input type="text" id="lectEndDay" class="date-input text" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </td>
            <th scope="col" class="ta-l">평점</th>
            <td>
                <select id="avgPoint">
                    <option value="">선택</option>
                    <option value="1">1점</option>
                    <option value="2">2점</option>
                    <option value="3">3점</option>
                    <option value="4">4점</option>
                    <option value="5">5점</option>
                </select>
            </td>
        </tr>
    </tbody>
</table>
<p class="search-btnbox">
    <button type="button" class="btn-style02" onClick="goSearch(1);"><span class="search">조회</span></button>
</p>
<div class="board-top">
    <p class="total-num">총 <strong>00</strong> 건</p>
    <ul>
    <li>
        <button type="button" class="btn-style02" onClick="fn_excelDown();"><span>엑셀다운로드</span></button>
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

    mentor.pageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:loadData, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );

    $(document).ready(function(){

        $( "#lectStartDay" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#lectEndDay").datepicker("option", "minDate", selectedDate);
            }
        });

        $( "#lectEndDay" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#lectStartDay").datepicker("option", "maxDate", selectedDate);
            }
        });

        // 1일 버튼 클릭 event
        $("#btnDayRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#lectEndDay").val(sEndDate);
            //var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 1)).format("yyyy-MM-dd");
            $("#lectStartDay").val(sEndDate);
        });

        // 7일 버튼 클릭 event
        $("#btnWeekRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#lectEndDay").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
            $("#lectStartDay").val(sStartDate);
        });

        // 1개월 버튼 클릭 event
        $("#btnMonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#lectEndDay").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
            $("#lectStartDay").val(sStartDate);
        });

        // 6개월 버튼 클릭 event
        $("#btn6MonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#lectEndDay").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 6)).format("yyyy-MM-dd");
            $("#lectStartDay").val(sStartDate);
        });

        loadData(1);

    });

    function goSearch(curPage){
        searchFlag = 'search';
        loadData(curPage);
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
        colModels.push({label:'번호', name:'rn',index:'rn', width:20, align:'center'});
        colModels.push({label:'멘토', name:'lectrNm',index:'lectrNm', width:50});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:50});
        colModels.push({label:'수업수', name:'lectCnt',index:'lectCnt', width:20, align:'center'});
        colModels.push({label:'교사(명)', name:'teacherCnt',index:'teacherCnt', width:20, align:'center'});
        colModels.push({label:'교사평점', name:'techerPoint',index:'techerPoint', width:20, align:'center'});
        colModels.push({label:'학생(명)', name:'stuCnt',index:'stuCnt', width:20, align:'center'});
        colModels.push({label:'학생평점', name:'stuPoint',index:'stuPoint', width:20, align:'center'});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        //jqGrid setting
        $('.jqgrid-overlay').show();
        $('.loading').show();
        var _param = jQuery.extend({
                    'lectrNm':$('#lectrNm').val()
                  , 'jobNm':$('#jobNm').val()
                  , 'avgPoint':$('#avgPoint').val()
                  , 'lectStartDay':$('#lectStartDay').val()
                  , 'lectEndDay':$('#lectEndDay').val()
        }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/rating/ajax.ratingByMentor.do",
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

                var data = rtnData.map(function(item, index){
                    item.rn = totalCount - item.rn + 1;
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

    // 엑셀다운로드
    function fn_excelDown(){
        var url = "${pageContext.request.contextPath}/lecture/status/rating/excel.ratingByMentor.do";
        var paramData = $.param({
                    'lectrNm':$('#lectrNm').val()
                  , 'jobNm':$('#jobNm').val()
                  , 'avgPoint':$('#avgPoint').val()
                  , 'lectStartDay':$('#lectStartDay').val()
                  , 'lectEndDay':$('#lectEndDay').val()
        }, true);

        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            if(pair[0] != 'lectrNm' && pair[0] != 'jobNm') {
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            }
        });
        inputs+="<input type='hidden' name='lectrNm' value='" + $("#lectrNm").val() + "' />";
        inputs+="<input type='hidden' name='jobNm' value='" + $("#jobNm").val() + "' />";

        //debugger
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";
        jQuery(sForm).appendTo("body").submit().remove();
    }


</script>

