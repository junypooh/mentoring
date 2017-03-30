<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>가입현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>회원통계</li>
            <li>가입현황</li>
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
                    <button type="button" class="btn-style02" id="excelDown"><span>엑셀다운로드</span></button>
                </li>
            </ul>
        </div>
        <table id="boardTable"></table>
        <p class="ta-right pt5" id="updateTime">* Update : 00월 00일 00시 기준</p>
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
            var url = "${pageContext.request.contextPath}/statistics/member/join/excel.do";
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
        colModels.push({label:'일시', name:'day', index:'day', width:100, align:'center', sortable: false});
        colModels.push({label:'초', name:'element', index:'element', align:'center', sortable: false});
        colModels.push({label:'중', name:'middle', index:'middle', align:'center', sortable: false});
        colModels.push({label:'고', name:'high', index:'high', align:'center', sortable: false});
        colModels.push({label:'대학', name:'univ', index:'univ', align:'center', sortable: false});
        colModels.push({label:'일반', name:'normal', index:'normal', align:'center', sortable: false});
        colModels.push({label:'학부모', name:'parent', index:'parent', align:'center', sortable: false});
        colModels.push({label:'교사', name:'teacher', index:'teacher', align:'center', sortable: false});
        colModels.push({label:'멘토', name:'mentor', index:'mentor', align:'center', sortable: false});
        colModels.push({label:'전체', name:'totcnt', index:'totcnt', align:'center', sortable: false});

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
        colModels.push({label:'일시', name:'day', index:'day', width:100, align:'center', sortable: false});
        colModels.push({label:'초', name:'element', index:'element', align:'center', sortable: false});
        colModels.push({label:'중', name:'middle', index:'middle', align:'center', sortable: false});
        colModels.push({label:'고', name:'high', index:'high', align:'center', sortable: false});
        colModels.push({label:'대학', name:'univ', index:'univ', align:'center', sortable: false});
        colModels.push({label:'일반', name:'normal', index:'normal', align:'center', sortable: false});
        colModels.push({label:'학부모', name:'parent', index:'parent', align:'center', sortable: false});
        colModels.push({label:'교사', name:'teacher', index:'teacher', align:'center', sortable: false});
        colModels.push({label:'멘토', name:'mentor', index:'mentor', align:'center', sortable: false});
        colModels.push({label:'전체', name:'totcnt', index:'totcnt', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false, null, {footerrow:true, userDataOnFooter:true});

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
            url: "${pageContext.request.contextPath}/statistics/member/join/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData.list, emptyText);
                // grid data binding

                var elementSum = $("#boardTable").jqGrid('getCol','element', false, 'sum');
                var middleSum = $("#boardTable").jqGrid('getCol','middle', false, 'sum');
                var highSum = $("#boardTable").jqGrid('getCol','high', false, 'sum');
                var univSum = $("#boardTable").jqGrid('getCol','univ', false, 'sum');
                var normalSum = $("#boardTable").jqGrid('getCol','normal', false, 'sum');
                var parentSum = $("#boardTable").jqGrid('getCol','parent', false, 'sum');
                var teacherSum = $("#boardTable").jqGrid('getCol','teacher', false, 'sum');
                var mentorSum = $("#boardTable").jqGrid('getCol','mentor', false, 'sum');
                var totcntSum = $("#boardTable").jqGrid('getCol','totcnt', false, 'sum');

                $("#boardTable").jqGrid('footerData','set',{day:'합계',element:elementSum, middle:middleSum, high:highSum, univ:univSum, normal:normalSum, parent:parentSum, teacher:teacherSum, mentor:mentorSum, totcnt:totcntSum});

                $("#updateTime").html("* Update : {0}월 {1}일 {2}시 기준".format(rtnData.iMonth, rtnData.iDate, rtnData.iHour));

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }
</script>