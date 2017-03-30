<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="cont">
    <div class="title-bar">
        <h2>멘토별수업</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>멘토리포트</li>
            <li>멘토별수업</li>
        </ul>
    </div>
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
            </li><!-- 2016-06-27 수정[E] -->
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" id="search"><span class="search">조회</span></button>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <ul>
                <li>
                    <button type="button" class="btn-style02" id="excelDown"><span>엑셀다운로드</span></button>
                </li>
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


        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                      ,'searchEndDate':$("#searchEndDate").val()}, dataSet.params);

        $("#excelDown").click(function(e){
            e.preventDefault();
            var url = "${pageContext.request.contextPath}/statistics/mentor/lecture/excel.do";
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
        colModels.push({label:'1depth', name:'jobStruct1', index:'jobStruct1', align:'center', sortable: false});
        colModels.push({label:'2depth', name:'jobStruct2', index:'jobStruct2', align:'center', sortable: false});
        colModels.push({label:'3depth', name:'jobStruct3', index:'jobStruct3', align:'center', sortable: false});
        colModels.push({label:'보유 멘토', name:'haveMentor', index:'haveMentor', align:'center', sortable: false});
        colModels.push({label:'등록 수업', name:'haveLect', index:'haveLect', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        //jqGrid setting
         setDataJqGridTable('boardTable', 'boardArea', 500, [], '기간 선택 후, 조회 버튼을 클릭해주세요.');
    }

    function loadData(){

        $("#gbox_boardTable").remove();
        $(".board-top").after('<table id="boardTable"></table>');

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'멘토ID', name:'id', index:'id', align:'center', sortable: false});
        colModels.push({label:'이름', name:'nm', index:'nm', align:'center', sortable: false});
        colModels.push({label:'직업', name:'jobNm', index:'jobNm', align:'center', sortable: false});
        colModels.push({label:'수업회차', name:'lectTims', index:'lectTims', align:'center', sortable: false});
        colModels.push({label:'수업아이디', name:'lectSer', index:'lectSer', align:'center', sortable: false});
        colModels.push({label:'수업상태', name:'lectStatNm', index:'lectStatNm', align:'center', sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', align:'center', sortable: false});
        colModels.push({label:'수업시간', name:'lectDateTime', index:'lectDateTime', align:'center', sortable: false});
        colModels.push({label:'등록업체', name:'coNm', index:'coNm', align:'center', sortable: false});
        colModels.push({label:'참여클래스수', name:'applCnt', index:'applCnt', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                      ,'searchEndDate':$("#searchEndDate").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/statistics/mentor/lecture/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData.list, emptyText);
                // grid data binding

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }



</script>