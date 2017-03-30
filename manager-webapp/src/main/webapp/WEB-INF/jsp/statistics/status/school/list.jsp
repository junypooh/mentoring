<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>학교참여현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>종합 리포트</li>
            <li>학교참여현황</li>
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
            var url = mentor.contextpath + "/statistics/status/excel.areaSummaryList.do";
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
        colModels.push({label:'지역', name:'sidoNm', index:'sidoNm', width:180, align:'center', sortable: false});

        //대상학교
        colModels.push({label:'초등학교', name:'etargtCnt', index:'etargtCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'중학교', name:'mtargtCnt', index:'mtargtCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'고등학교', name:'htargtCnt', index:'htargtCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'계', name:'ttargtCnt', index:'ttargtCnt', width:100, align:'center', sortable: false});

        //수업참여학교수
        colModels.push({label:'초등학교', name:'eschCnt', index:'eschCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'중학교', name:'mschCnt', index:'mschCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'고등학교', name:'hschCnt', index:'hschCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'계', name:'tschCnt', index:'tschCnt', width:100, align:'center', sortable: false});

        //참여수업수
        colModels.push({label:'초등학교', name:'eclasCnt', index:'eclasCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'중학교', name:'mclasCnt', index:'mclasCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'고등학교', name:'hclasCnt', index:'hclasCnt', width:100, align:'center', sortable: false});
        colModels.push({label:'계', name:'tclasCnt', index:'tclasCnt', width:100, align:'center', sortable: false});

        //학교당 참여수업수 평균
        colModels.push({label:'초등학교', name:'eratio', index:'eratio', width:100, align:'center', sortable: false});
        colModels.push({label:'중학교', name:'mratio', index:'mratio', width:100, align:'center', sortable: false});
        colModels.push({label:'고등학교', name:'hratio', index:'hratio', width:100, align:'center', sortable: false});
        colModels.push({label:'계', name:'tratio', index:'tratio', width:100, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        // 셀 병합 메서드
        jQuery("#boardTable").jqGrid('setGroupHeaders', {
            useColSpanStyle:true,
            groupHeaders: [
                {startColumnName: 'etargtCnt', numberOfColumns: 4, titleText: '대상학교'},
                {startColumnName: 'eschCnt', numberOfColumns: 4, titleText: '수업참여학교수'},
                {startColumnName: 'eclasCnt', numberOfColumns: 4, titleText: '참여수업수'},
                {startColumnName: 'eratio', numberOfColumns: 4, titleText: '학교당 참여수업수 평균'}
            ]
        });

        var _param = jQuery.extend({'setSer':$("#setSer").val()}
                , dataSet.params);

        $('.jqgrid-overlay').show();
        $('.loading').show();


        $.ajax({
            url: "${pageContext.request.contextPath}/statistics/status/ajax.areaSummaryList.do",
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