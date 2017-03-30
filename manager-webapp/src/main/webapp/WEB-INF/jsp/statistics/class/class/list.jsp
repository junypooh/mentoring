<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>클래스별</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>클래스리포트</li>
            <li>클래스별</li>
        </ul>
    </div>
    <!-- Datepicker 스크립트[E] -->
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>기간</strong>
                <input type="text" id="searchStDate" name="searchStDate" class="date-input" readOnly="readOnly" />
                <span> ~ </span>
                <input type="text" id="searchEndDate" name="searchEndDate" class="date-input" readOnly="readOnly" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" id="search"><span class="search">조회</span></button>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <ul>
                <li>
                    <button type="button" class="btn-style02" id="schoolExcelDown"><span>엑셀다운로드</span></button>
                </li>
            </ul>
        </div>
        <table id="boardTable"></table>
        <p class="ta-right pt5" id="updateTime">※ 상세내용은 엑셀을 다운받아 확인하세요.</p>
    </div>
</div>
<script type="text/javascript">
    var dataSet = {
        params: {
        }
    };

    var searchFlag = 'load';

    $(document).ready(function() {

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

        // 학교목록 엑셀다운로드
        $("#schoolExcelDown").click(function(e){
            e.preventDefault();
            var url = mentor.contextpath + "/statistics/class/excelSchoolList.do";
            var paramData = $.param(dataSet.params, true);

            excelDownLoad(paramData, url);

        });


        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                      ,'searchEndDate':$("#searchEndDate").val()}, dataSet.params);

        $("#excelDown").click(function(e){
            e.preventDefault();
            var url = "${pageContext.request.contextPath}/statistics/class/excelClassLectureList.do";
            var paramData = $.param({'searchStDate':$("#searchStDate").val() ,'searchEndDate':$("#searchEndDate").val()}, true);
            var inputs = "";
            jQuery.each(paramData.split('&'), function(){
                var pair = this.split('=');
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            });
            inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";

            var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";

            jQuery(sForm).appendTo("body").submit().remove();
        });

        $("#search").click(function(){
            loadData();
        });

        $("#btnWeekRange").click();

        emptyData();
    });

    function emptyData() {

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'클래스명', name:'clasRoomNm', index:'clasRoomNm', width:100, align:'center', sortable: false});
        colModels.push({label:'시도', name:'sidoNm', index:'sidoNm', align:'center', sortable: false});
        colModels.push({label:'지역', name:'sgguNm', index:'sgguNm', align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassNm', index:'schClassNm', align:'center', sortable: false});
        colModels.push({label:'학교ID', name:'schNo', index:'schNo', align:'center', sortable: false});
        colModels.push({label:'학교명', name:'schNm', index:'schNm', align:'center', sortable: false});
        colModels.push({label:'수업회차', name:'lectTims', index:'lectTims', align:'center', sortable: false});
        colModels.push({label:'수업상태', name:'lectStatCdNm', index:'lectStatCdNm', align:'center', sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', align:'center', sortable: false});
        colModels.push({label:'수업시간', name:'lectTime', index:'lectTime', align:'center', sortable: false});
        colModels.push({label:'고용직업분류', name:'lectJobClsfNm', index:'lectJobClsfNm', align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm', index:'jobNm', align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'lectrNm', index:'lectrNm', align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        // 셀 병합 메서드
        jQuery("#boardTable").jqGrid('setGroupHeaders', {
        useColSpanStyle:true,
            groupHeaders: [
                {startColumnName: 'element', numberOfColumns: 6, titleText: '일반'},
            ]
        });

        //jqGrid setting
         setDataJqGridTable('boardTable', 'boardArea', 500, [], '기간 선택 후, 조회 버튼을 클릭해주세요.');
    }

    function loadData(){

        $("#gbox_boardTable").remove();
        $(".board-top").after('<table id="boardTable"></table>');

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'클래스명', name:'clasRoomNm', index:'clasRoomNm', width:100, align:'center', sortable: false});
        colModels.push({label:'시도', name:'sidoNm', index:'sidoNm', align:'center', sortable: false});
        colModels.push({label:'지역', name:'sgguNm', index:'sgguNm', align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassNm', index:'schClassNm', align:'center', sortable: false});
        colModels.push({label:'학교ID', name:'schNo', index:'schNo', align:'center', sortable: false});
        colModels.push({label:'학교명', name:'schNm', index:'schNm', align:'center', sortable: false});
        colModels.push({label:'수업회차', name:'lectTims', index:'lectTims', align:'center', sortable: false});
        colModels.push({label:'수업상태', name:'lectStatCdNm', index:'lectStatCdNm', align:'center', sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', align:'center', sortable: false});
        colModels.push({label:'수업시간', name:'lectTime', index:'lectTime', align:'center', sortable: false});
        colModels.push({label:'고용직업분류', name:'lectJobClsfNm', index:'lectJobClsfNm', align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm', index:'jobNm', align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'lectrNm', index:'lectrNm', align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        // 셀 병합 메서드
        jQuery("#boardTable").jqGrid('setGroupHeaders', {
        useColSpanStyle:true,
            groupHeaders: [
                {startColumnName: 'element', numberOfColumns: 6, titleText: '일반'},
            ]
        });
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                      ,'searchEndDate':$("#searchEndDate").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/statistics/class/ajax.classLectureList.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                // grid data binding
                var emptyText = '표시할 데이터가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData, emptyText);
                // grid data binding

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }


    // 엑셀다운로드
    function excelDownLoad(paramData, url) {
        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            if( pair[0] != 'keyword') {
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            }
        });
        inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";
        inputs +="<input type='text' id='searchStDate' name='searchStDate' value='"+$("#searchStDate").val()+"'/>";
        inputs +="<input type='text' id='searchEndDate' name='searchEndDate' value='"+$("#searchEndDate").val()+"'/>";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";

        jQuery(sForm).appendTo("body").submit().remove();
    }
</script>