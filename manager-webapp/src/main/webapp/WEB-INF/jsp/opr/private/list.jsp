<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>개인정보접속관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>개인정보접속관리</li>
        </ul>
    </div>
    <form id="frm">
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>기간선택</strong>
                <input type="text" id="searchStDate" name="searchStDate" class="date-input" value="${param.searchStDate}" />
                <span> ~ </span>
                <input type="text" id="searchEndDate" name="searchEndDate" class="date-input" value="${param.searchEndDate}" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li>
        </ul>
        <ul>
            <li>
                <strong>조건검색</strong>
                <select id="searchKey" name="searchKey">
                    <option value="">전체</option>
                    <option value="id">ID</option>
                    <option value="nm">관리자명</option>
                </select>
                <input type="text" name="searchWord" id="searchWord" class="text" value="${param.searchWord}" />
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>0</strong> 건</p>
            <ul>
                <li><button type="button" class="btn-orange" id="excelDown"><span>엑셀다운로드</span></button></li>
            </ul>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
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

    $(document).ready(function() {

        enterFunc($("#searchWord"), goSearch);

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

        $("#excelDown").click(function(e){
            e.preventDefault();
            var url = "${pageContext.request.contextPath}/opr/private/excel.do";
            var paramData = $.param({'searchStDate':$("#searchStDate").val(),'searchEndDate':$("#searchEndDate").val(),'searchKey':$("#searchKey").val()}, true);
            var inputs = "";
            jQuery.each(paramData.split('&'), function(){
                var pair = this.split('=');
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            });
            inputs +="<input type='hidden' name='searchWord' value='"+$("#searchWord").val()+"' />";
            inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";

            var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";

            jQuery(sForm).appendTo("body").submit().remove();
        });

        loadData(1);
    });

    function goSearch(curPage) {
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
        colModels.push({label:'번호', name:'rn', index:'rn', align:'center', sortable: false});
        colModels.push({label:'접속일자', name:'workDtm', index:'workDtm', align:'center', sortable: false});
        colModels.push({label:'접속메뉴', name:'workSust', index:'workSust', sortable: false});
        colModels.push({label:'조회대상', name:'targtMbrNm', index:'targtMbrNm', sortable: false});
        colModels.push({label:'소속', name:'coNm', index:'coNm', align:'center', sortable: false});
        colModels.push({label:'ID', name:'id', index:'id', align:'center', sortable: false});
        colModels.push({label:'관리자명', name:'nm', index:'nm', align:'center', sortable: false});
        colModels.push({label:'접속권한', name:'authNm', index:'authNm', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                      ,'searchEndDate':$("#searchEndDate").val()
                      ,'searchKey':$('#searchKey').val()
                      ,'searchWord':$('#searchWord').val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/private/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.workDtm = new Date(item.workDtm).format('yyyy.MM.dd hh:mm');

                    return item;
                });

                // grid data binding
                var emptyText = '등록된 데이터가 없습니다.';
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
                mentor.pageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

</script>