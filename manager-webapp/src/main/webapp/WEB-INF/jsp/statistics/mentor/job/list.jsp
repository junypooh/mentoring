<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<div class="cont">
    <div class="title-bar">
        <h2>직업별</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>멘토리포트</li>
            <li>직업별</li>
        </ul>
    </div>
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>기간</strong>
                <input type="text" id="searchStDate" name="searchStDate" class="date-input" />
                <span> ~ </span>
                <input type="text" id="searchEndDate" name="searchEndDate" class="date-input" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li><!-- 2016-06-27 수정[E] -->
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" id="search"><span class="search">조회</span></button>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <ul>
            </ul>
        </div>
        <table id="boardTable"></table>

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

        $("#search").click(function(){
            loadData();
        });

        $("#btnWeekRange").click();

        emptyData();
    });

    function emptyData() {

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'1depth', name:'jobStruct1', index:'jobStruct1', align:'center', sortable: false});
        colModels.push({label:'2depth', name:'jobStruct2', index:'jobStruct2', align:'center', sortable: false});
        colModels.push({label:'3depth', name:'jobStruct3', index:'jobStruct3', align:'center', sortable: false});
        colModels.push({label:'보유 멘토', name:'haveMentor', index:'haveMentor', align:'center', sortable: false});
        colModels.push({label:'등록 수업', name:'haveLect', index:'haveLect', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        // 셀 병합 메서드
        jQuery("#boardTable").jqGrid('setGroupHeaders', {
        useColSpanStyle:true,
            groupHeaders: [
                {startColumnName: 'jobStruct1', numberOfColumns: 3, titleText: '고용직업 분류'}
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
        colModels.push({label:'1depth', name:'jobStruct1', index:'jobStruct1', align:'center', sortable: false});
        colModels.push({label:'2depth', name:'jobStruct2', index:'jobStruct2', align:'center', sortable: false});
        colModels.push({label:'3depth', name:'jobStruct3', index:'jobStruct3', align:'center', sortable: false});
        colModels.push({label:'보유 멘토', name:'haveMentor', index:'haveMentor', align:'center', sortable: false});
        colModels.push({label:'등록 수업', name:'haveLect', index:'haveLect', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false, null, {footerrow:true, userDataOnFooter:true});

        // 셀 병합 메서드
        jQuery("#boardTable").jqGrid('setGroupHeaders', {
        useColSpanStyle:true,
            groupHeaders: [
                {startColumnName: 'jobStruct1', numberOfColumns: 3, titleText: '고용직업 분류'}
            ]
        });
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                      ,'searchEndDate':$("#searchEndDate").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/statistics/mentor/job/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData.list, emptyText);
                // grid data binding

                var jobStruct2Cnt = rtnData.jobCnt.jobStruct1Cnt + '개 직군' + rtnData.jobCnt.jobStruct2Cnt + '개 직종';
                var jobStruct3Cnt = rtnData.jobCnt.jobStruct3Cnt + '개 직업';
                var haveMentorSum = $("#boardTable").jqGrid('getCol','haveMentor', false, 'sum');
                var haveLectSum = $("#boardTable").jqGrid('getCol','haveLect', false, 'sum');


                $("#boardTable").jqGrid('footerData','set',{jobStruct1:'총 계', jobStruct2:jobStruct2Cnt, jobStruct3:jobStruct3Cnt, haveMentor:haveMentorSum, haveLect:haveLectSum});

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }



</script>
