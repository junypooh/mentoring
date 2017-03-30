<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>기관관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>기관관리</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="coNo" name="coNo" />
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>기간선택</strong>
                <input type="text" id="regDtmBegin" name="regDtmBegin" class="date-input" value="${param.regDtmBegin}" />
                <span> ~ </span>
                <input type="text" id="regDtmEnd" name="regDtmEnd" class="date-input" value="${param.regDtmEnd}" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li>
        </ul>
        <ul>
            <li>
                <strong>조건검색</strong>
                <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101659_업체구분코드'])" var="coClassCd" />
                <select id="coClassCd" name="coClassCd">
                    <option value="">전체</option>
                    <c:forEach items="${coClassCd}" var="eachObj" varStatus="vs">
                    <option value="${eachObj.cd}" <c:if test="${eachObj.cd eq param.coClassCd}">selected='selected'</c:if>>${eachObj.cdNm}</option>
                    </c:forEach>
                </select>
                <input type="text" name="coNm" id="coNm" class="text" value="${param.coNm}" />
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>활동유무</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="useYn" value="" <c:if test="${empty param.useYn}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="useYn" value="Y" <c:if test="${param.useYn eq 'Y'}">checked='checked'</c:if> /> 활동</label>
                    </li>
                    <li>
                        <label><input type="radio" name="useYn" value="N" <c:if test="${param.useYn eq 'N'}">checked='checked'</c:if> /> 활동안함</label>
                    </li>
                </ul>
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
                <li><button type="button" class="btn-orange" onclick="location.href='view.do'"><span>추가</span></button></li>
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

        enterFunc($("#coNm"), goSearch);

        $( "#regDtmBegin" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#regDtmEnd").datepicker("option", "minDate", selectedDate);
            }
        });
        $( "#regDtmEnd" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#regDtmBegin").datepicker("option", "maxDate", selectedDate);
            }
        });

        // 1일 버튼 클릭 event
        $("#btnDayRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#regDtmEnd").val(sEndDate);
            //var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 1)).format("yyyy-MM-dd");
            $("#regDtmBegin").val(sEndDate);
        });

        // 7일 버튼 클릭 event
        $("#btnWeekRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#regDtmEnd").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
            $("#regDtmBegin").val(sStartDate);
        });

        // 1개월 버튼 클릭 event
        $("#btnMonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#regDtmEnd").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
            $("#regDtmBegin").val(sStartDate);
        });

        // 6개월 버튼 클릭 event
        $("#btn6MonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#regDtmEnd").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 6)).format("yyyy-MM-dd");
            $("#regDtmBegin").val(sStartDate);
        });

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(coNo) {
        $('#coNo').val(coNo);
        var qry = $('#frm').serialize();
        $(location).attr('href', 'view.do?' + qry);
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
        colModels.push({label:'번호', name:'rn', index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'Code', name:'coNo', index:'coNo', width:30, align:'center', sortable: false});
        colModels.push({label:'기관/기업명', name:'coNm', index:'coNm', width:70, sortable: false});
        colModels.push({label:'담당자명', name:'mngrNm', index:'mngrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'연락처', name:'tel', index:'tel', width:40, align:'center', sortable: false});
        colModels.push({label:'활동유무', name:'useYn', index:'useYn', width:30, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm', index:'regMbrNm', width:30, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm', index:'regDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'regDtmBegin':$("#regDtmBegin").val()
                      ,'regDtmEnd':$("#regDtmEnd").val()
                      ,'mbrCualfCds':$(':radio[name="mbrCualfCds"]:checked').val()
                      ,'useYn':$(':radio[name="useYn"]:checked').val()
                      ,'coNm':$('#coNm').val()
                      ,'coClassCd':$('#coClassCd').val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/corp/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    //item.coNm = "<a class='underline' href='view.do?coNo=" + item.coNo + "'>" + item.coNm + "</a>";
                    item.coNm = "<a class='underline' href='javascript:void(0)' onclick='goView(\"" + item.coNo +"\")'>" + item.coNm + "</a>";
                    item.regDtm = new Date(item.regDtm).format('yyyy.MM.dd');

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