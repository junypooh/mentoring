<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>탈퇴회원조회</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>탈퇴회원조회</li>
        </ul>
    </div>
<script type="text/javascript">
    var userCategory = {
        '${codeConstants["CD100204_100205_초등학생"]}': '초',
        '${codeConstants["CD100204_100206_중학생"]}': '중',
        '${codeConstants["CD100204_100207_고등학생"]}': '고',
        '${codeConstants["CD100204_100208_대학생"]}': '대학',
        '${codeConstants["CD100204_100209_일반"]}': '일반',
        '${codeConstants["CD100204_100210_일반_학부모_"]}': '일반(학부모)',
        '${codeConstants["CD100204_100214_교사"]}': '교사',
        '${codeConstants["CD100204_101502_소속멘토"]}': '멘토',
    };
</script>
    <div class="search-area general-srch">
        <ul>
            <li class="condition-big">
                <p><strong>회원유형</strong></p>
                <ul class="detail-condition" id="rdoMbrCualfCds">
                    <li>
                        <label><input type="radio" name="mbrCualfCds" value="" checked='checked' /> 전체</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>아이디</strong>
                <input type="text" name="id" id="id" class="text" />
            </li>
            <li>
                <strong class="w-auto">사유</strong>
                <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101752_회원_탈퇴_유형'])" var="coClassCd" />
                <select id="mbrWithDrawnType" name="mbrWithDrawnType">
                    <option value="">전체</option>
                    <c:forEach items="${coClassCd}" var="eachObj" varStatus="vs">
                    <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                    </c:forEach>
                </select>
            </li>
        </ul>
        <ul>
            <li>
                <strong>기간선택</strong>
                <input type="text" id="regDtmBegin" class="date-input" />
                <span> ~ </span>
                <input type="text" id="regDtmEnd" class="date-input" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>0</strong> 건</p>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
    </div>
</div>
<script type="text/jsx;harmony=true">
    mentor.schoolPageNavi = React.render(
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

    var searchFlag = 'load';

    $(document).ready(function() {

        var mbrCualfCds = [];
        $.each(userCategory, function(k, v) {
            mbrCualfCds.push($('<li><input type="radio" name="mbrCualfCds" value="' + k + '" /> ' + v + '</label></li>'));
        });

        $('#rdoMbrCualfCds').append(mbrCualfCds);

        enterFunc($("#id"), goSearch);

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
        colModels.push({label:'회원유형', name:'mbrCualfNm', index:'mbrCualfNm', width:30, align:'center', sortable: false});
        colModels.push({label:'아이디', name:'id', index:'id', width:40, align:'center', sortable: false});
        colModels.push({label:'사유', name:'mbrWithdrawnTypeNm', index:'mbrWithdrawnTypeNm', width:30, align:'center', sortable: false});
        colModels.push({label:'최근 로그인', name:'lastLoginDtm', index:'lastLoginDtm', width:30, align:'center', sortable: false});
        colModels.push({label:'탈퇴일', name:'delDtm', index:'delDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'delDtmBegin':$("#regDtmBegin").val()
                      ,'delDtmEnd':$("#regDtmEnd").val()
                      ,'mbrCualfCds':$(':radio[name="mbrCualfCds"]:checked').val()
                      ,'id':$('#id').val()
                      ,'mbrWithDrawnType':$('#mbrWithDrawnType').val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/member/withdrawal/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.delDtm = new Date(item.delDtm).format('yyyy.MM.dd HH:mm');
                    item.lastLoginDtm = new Date(item.lastLoginDtm).format('yyyy.MM.dd HH:mm');

                    // 회원유형 설정
                    var mbrCualfNm = '';
                    if(item.mbrCualfCd == '${codeConstants["CD100204_100205_초등학생"]}') {
                        mbrCualfNm = '초';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100206_중학생"]}') {
                        mbrCualfNm = '중';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100207_고등학생"]}') {
                        mbrCualfNm = '고';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100208_대학생"]}') {
                        mbrCualfNm = '대학';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100209_일반"]}') {
                        mbrCualfNm = '일반';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100210_일반_학부모_"]}') {
                        mbrCualfNm = '일반(학부모)';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100214_교사"]}') {
                        mbrCualfNm = '교사';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_100215_교사_진로상담_"]}') {
                        mbrCualfNm = '교사';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_101502_소속멘토"]}') {
                        mbrCualfNm = '멘토';
                    } else if(item.mbrCualfCd == '${codeConstants["CD100204_101503_개인멘토"]}') {
                        mbrCualfNm = '멘토';
                    }
                    item.mbrCualfNm = mbrCualfNm;

                    return item;
                });

                // grid data binding
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
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
                mentor.schoolPageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }
</script>
