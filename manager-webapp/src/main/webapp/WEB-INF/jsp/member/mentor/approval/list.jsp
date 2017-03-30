<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>가입탈퇴승인</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>멘토회원관리</li>
            <li>가입탈퇴승인</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="mbrNo" name="mbrNo" />
    <input type="hidden" id="statChgSer" name="statChgSer" />
    <div class="search-area general-srch">
        <ul>
            <li class="condition-big">
                <p><strong>구분</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="statChgClassCd" value="" <c:if test="${empty param.statChgClassCd}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="statChgClassCd" value="${codeConstants['CD101718_101719_회원가입요청상태']}" <c:if test="${param.statChgClassCd eq codeConstants['CD101718_101719_회원가입요청상태']}">checked='checked'</c:if> /> 회원가입</label>
                    </li>
                    <li>
                        <label><input type="radio" name="statChgClassCd" value="${codeConstants['CD101718_101751_회원탈퇴요청상태']}" <c:if test="${param.statChgClassCd eq codeConstants['CD101718_101751_회원탈퇴요청상태']}">checked='checked'</c:if> /> 회원탈퇴</label>
                    </li>
                </ul>
            </li>
            <li class="condition-big">
                <p><strong>상태</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="statChgRsltCd" value="" <c:if test="${empty param.statChgRsltCd}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="statChgRsltCd" value="REQ" <c:if test="${param.statChgRsltCd eq 'REQ'}">checked='checked'</c:if> /> 승인요청</label>
                    </li>
                    <li>
                        <label><input type="radio" name="statChgRsltCd" value="OK" <c:if test="${param.statChgRsltCd eq 'OK'}">checked='checked'</c:if> /> 승인완료</label>
                    </li>
                    <li>
                        <label><input type="radio" name="statChgRsltCd" value="NOK" <c:if test="${param.statChgRsltCd eq 'NOK'}">checked='checked'</c:if> /> 반려</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>아이디</strong>
                <input type="text" name="id" id="id" class="text" value="${param.id}" />
            </li>
            <li>
                <strong class="w-auto">휴대전화</strong>
                <input type="text" name="mobile" id="mobile" class="text" value="${param.mobile}" />
            </li>
            <li>
                <strong class="w-auto">이름</strong>
                <input type="text" name="name" id="name" class="text" value="${param.name}" />
            </li>
            <li>
                <strong class="w-auto">직업명</strong>
                <input type="text" name="job" id="job" class="text" value="${param.job}" />
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <input type="hidden" name="jobClsfCd" id="jobClsfCd" value="${param.jobClsfCd}" />
                <p><strong>직업분류</strong></p>
                <ul class="detail-condition">
                    <li class="mr5">
                        <select id="jobLv1Selector" name="jobLv1Selector" style="width:200px;">
                            <option value="">1차분류</option>
                        </select>
                    </li>
                    <li class="mr5">
                        <select id="jobLv2Selector" name="jobLv2Selector" style="width:200px;">
                            <option value="">2차분류</option>
                        </select>
                    </li>
                    <li class="mr5">
                        <select id="jobLv3Selector" name="jobLv3Selector" style="width:200px;">
                            <option value="">3차분류</option>
                        </select>
                    </li>
                </ul>
            </li>
        </ul>
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
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
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

        enterFunc($("#id"), goSearch);
        enterFunc($("#name"), goSearch);
        enterFunc($("#job"), goSearch);
        enterFunc($("#mobile"), goSearch);

        <c:if test="${empty param.statChgRsltCd}">
        $('input:radio[name=statChgRsltCd]:input[value=REQ]').prop("checked", true);
        </c:if>

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

        // 1차 분류 코드 정보
        $.ajax({
            url: '${pageContext.request.contextPath}/jobClsfCd.do',
            data: { cdLv: 1 },
            success: function(rtnData) {
                $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });

        // 1차 분류 변경
        $('#jobLv1Selector').change(function() {
            $('#jobLv2Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 2, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 2차 분류 변경
        $('#jobLv2Selector').change(function() {
            $('#jobLv3Selector').find('option:not(:first)').remove().end().val('').change();
            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 3, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        <c:if test="${not empty param.jobLv1Selector}">
        $('#jobLv1Selector').val('${param.jobLv1Selector}').change();
        </c:if>
        <c:if test="${not empty param.jobLv2Selector}">
        $('#jobLv2Selector').val('${param.jobLv2Selector}').change();
        </c:if>
        <c:if test="${not empty param.jobLv3Selector}">
        $('#jobLv3Selector').val('${param.jobLv3Selector}');
        </c:if>

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(mbrNo, statChgSer) {
        $('#mbrNo').val(mbrNo);
        $('#statChgSer').val(statChgSer);
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

        if($('#jobLv1Selector').val() != '') {
            if($('#jobLv2Selector').val() != '') {
                if($('#jobLv3Selector').val() != '') {
                    $('#jobClsfCd').val($('#jobLv3Selector').val());
                } else {
                    $('#jobClsfCd').val($('#jobLv2Selector').val());
                }
            } else {
                $('#jobClsfCd').val($('#jobLv1Selector').val());
            }
        }

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'번호', name:'rn', index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'구분', name:'statChgClassNm', index:'statChgClassNm', width:60, align:'center', sortable: false});
        colModels.push({label:'아이디', name:'id', index:'id', width:60, align:'center', sortable: false});
        colModels.push({label:'이름', name:'username', index:'username', width:60, align:'center', sortable: false});
        colModels.push({label:'휴대전화', name:'mobile', index:'mobile', width:70, align:'center', sortable: false});
        colModels.push({label:'직업1차분류', name:'jobStruct1',index:'jobStruct1', width:80, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm', index:'jobNm', width:60, align:'center', sortable: false, cellattr: function(rowId, val, rawObject, cm, rdata) { return 'title="' + _nvl(rawObject.jobTagInfo) +'"'}});
        colModels.push({label:'상태', name:'status', index:'status', width:60, align:'center', sortable: false});
        colModels.push({label:'요청일', name:'chgRegDtm', index:'chgRegDtm', width:60, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'statChgHistRegDtmBegin':$("#regDtmBegin").val()
                      ,'statChgHistRegDtmEnd':$("#regDtmEnd").val()
                      ,'statChgClassCds':$(':radio[name="statChgClassCd"]:checked').val()
                      ,'statChgRsltCd':$(':radio[name="statChgRsltCd"]:checked').val()
                      ,'id':$('#id').val()
                      ,'mobile':$('#mobile').val()
                      ,'name':$('#name').val()
                      ,'job':$('#job').val()
                      ,'jobClsfCd':$('#jobClsfCd').val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/member/mentor/approval/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    //item.id = "<a class='underline' href='view.do?mbrNo=" + item.mbrNo + "&statChgSer=" + item.statChgHistInfo.statChgSer +"'>" + item.id + "</a>";
                    item.id = "<a class='underline' href='javascript:void(0)' onclick='goView(\"" + item.mbrNo + "\",\"" + item.statChgHistInfo.statChgSer + "\")'>" + item.id + "</a>";
                    item.chgRegDtm = new Date(item.statChgHistInfo.chgRegDtm).format('yyyy.MM.dd');
                    item.statChgClassNm = (item.statChgHistInfo.statChgClassNm).substring(0,4);

                    if ( item.statChgHistInfo.statChgClassCd == '${codeConstants['CD101718_101719_회원가입요청상태']}' ) {
                        if( item.statChgHistInfo.statChgRsltCd == '${codeConstants['CD100861_101506_승인요청']}' ) {
                            item.status = '승인요청';
                        } else if( item.statChgHistInfo.statChgRsltCd == '${codeConstants['CD100861_100862_정상이용']}' ) {
                            item.status = '승인완료';
                        } else if( item.statChgHistInfo.statChgRsltCd == '${codeConstants['CD100861_100863_이용중지']}' ) {
                            item.status = '반려';
                        }
                    } else if ( item.statChgHistInfo.statChgClassCd == '${codeConstants['CD101718_101751_회원탈퇴요청상태']}' ) {
                        if( item.statChgHistInfo.statChgRsltCd == '${codeConstants['CD100861_101572_탈퇴요청']}' ) {
                            item.status = '승인요청';
                        } else if( item.statChgHistInfo.statChgRsltCd == '${codeConstants['CD100861_100864_탈퇴']}' ) {
                            item.status = '승인완료';
                        } else if( item.statChgHistInfo.statChgRsltCd == '${codeConstants['CD100861_100862_정상이용']}' ) {
                            item.status = '반려';
                        }
                    }

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