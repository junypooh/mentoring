<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>직업별수업수</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>종합 리포트</li>
            <li>직업별수업수</li>
        </ul>
    </div>
    <!-- Datepicker 스크립트[E] -->
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>배정그룹</strong>
                <select id="setSer" name="setSer">
                    <c:forEach items="${bizGrps}" var="item">
                        <option value="${item.setSer}">${item.grpNm}</option>
                    </c:forEach>
                </select>
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


    $(document).ready(function() {
        $("#search").click(function(){
            loadData();
        });

        $("#schoolExcelDown").click(function(e){
            e.preventDefault();
            var url = mentor.contextpath + "/statistics/status/excel.lectureSummaryByJob.do";
            var paramData = $.param(dataSet.params, true);

            excelDownLoad(paramData, url);

        });

        loadData();

    });

    function loadData(){

        $("#gbox_boardTable").remove();
        $(".board-top").after('<table id="boardTable"></table>');

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'직업ID', name:'jobNo', index:'jobNo', width:180, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm', index:'jobNm', width:100, align:'center', sortable: false});
        colModels.push({label:'고용직업분류', name:'jobClsfNm', index:'jobClsfNm', width:100, align:'center', sortable: false});
        colModels.push({label:'멘토수', name:'mentorCnt', index:'mentorCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'수업수', name:'lectCnt', index:'lectCnt', width:100, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        var _param = jQuery.extend({'setSer':$("#setSer").val()}
                , dataSet.params);

        $('.jqgrid-overlay').show();
        $('.loading').show();


        $.ajax({
            url: "${pageContext.request.contextPath}/statistics/status/ajax.lectureSummaryByJob.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
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

        inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";
        inputs +="<input type='text' name='setSer' value='"+$("#setSer").val()+"'/>";
        inputs +="<input type='text' name='grpNm' value='"+$("#setSer option:selected").text()+"'/>";


        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";

        jQuery(sForm).appendTo("body").submit().remove();
    }
</script>