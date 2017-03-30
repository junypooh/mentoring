<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>종합현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>통계&amp;리포트</li>
            <li>종합 리포트</li>
            <li>종합현황</li>
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
            var url = mentor.contextpath + "/statistics/status/excel.summary.do";
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
        colModels.push({label:'구분', name:'classificationName', index:'classificationName', width:100, align:'center', sortable: false});
        colModels.push({label:'실적', name:'classificationData', index:'classificationData', align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        var _param = jQuery.extend({'setSer':$("#setSer").val()}
                , dataSet.params);

        $('.jqgrid-overlay').show();
        $('.loading').show();


        $.ajax({
            url: "${pageContext.request.contextPath}/statistics/status/ajax.totalListByBizGroup.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                debugger

                var data = [];
                data.push({"classificationName":"대상 학교수","classificationData":rtnData.bizSetSchoolCnt});
                data.push({"classificationName":"수업참여 학교수","classificationData":rtnData.appliedSchoolCnt});
                data.push({"classificationName":"학교 수업참여수 누적","classificationData":rtnData.appliedClassCnt});
                data.push({"classificationName":"학교당 참여수업수 평균(대상교 전체 기준)","classificationData":rtnData.avgOfAppliedClassBySchool});
                data.push({"classificationName":"학교당 참여수업수 평균(불참교 제외)","classificationData":rtnData.avgOfAppliedClassExpect});
                data.push({"classificationName":"개설 수업수","classificationData":rtnData.openClassCnt});
                data.push({"classificationName":"수업당 참여학교수 평균","classificationData":rtnData.avgOfSchoolCntPerClass});
                data.push({"classificationName":"전체 멘토수","classificationData":rtnData.totalMentorCnt});
                data.push({"classificationName":"멘토 직업수","classificationData":rtnData.jobCntOfMentor});
                data.push({"classificationName":"수업 멘토수","classificationData":rtnData.mentorCntOfLecture});
                data.push({"classificationName":"수업 직업수","classificationData":rtnData.jobCntOfLecture});

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, data, emptyText);
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