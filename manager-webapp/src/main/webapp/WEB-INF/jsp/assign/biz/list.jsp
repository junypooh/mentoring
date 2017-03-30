<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<%--<div class="page-loader" style="display:none;">
    <img src="${pageContext.request.contextPath}/images/img_page_loader.gif" alt="페이지 로딩 이미지">
</div>--%>
<div class="cont">
    <div class="title-bar">
        <h2>배정사업관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>배정관리</li>
            <li>배정사업관리</li>
        </ul>
    </div>
    <form id="frm">
    <div class="search-area">
        <input type="hidden" id="setTargtNo" name="setTargtNo" />
        <ul>
            <li>
                <strong>배정사업</strong>
                <input type="text" id="grpNm" name="grpNm" value="${param.grpNm}" />
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>상태</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="grpState" value="" <c:if test="${empty param.grpState}">checked='checked'</c:if>  /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="grpState" value="1" <c:if test="${param.grpState eq '1'}">checked='checked'</c:if> /> 예정</label>
                    </li>
                    <li>
                        <label><input type="radio" name="grpState" value="2" <c:if test="${param.grpState eq '2'}">checked='checked'</c:if> /> 진행중</label>
                    </li>
                    <li>
                        <label><input type="radio" name="grpState" value="3" <c:if test="${param.grpState eq '3'}">checked='checked'</c:if> /> 종료</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>배정기간</strong>
                <input type="text"id="clasStartDay" name="clasStartDay"  class="date-input" readonly="readonly" value="${param.clasStartDay}"/>
                <span> ~ </span>
                <input type="text"id="clasEndDay" name="clasEndDay"  class="date-input" readonly="readonly" value="${param.clasEndDay}" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>일간</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>주간</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>월간</span></button>
            </li>
            <li>
                <strong>주관기관</strong>
                <input type="text" id="coNm" name="coNm" value="${param.coNm}" />
            </li>
        </ul>

        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
		<div class="board-bot">
            <ul>
                <!--<li><a href="javascript:void(0)" onclick="excelDownLoad()"><img src="${pageContext.request.contextPath}/images/btn_excel_down.gif" alt="엑셀 다운로드" /></a></li>-->
                <li><a href="edit.do"><img src="${pageContext.request.contextPath}/images/btn_regist.gif" alt="등록" /></a></li>
                <!--<li><a href="#"><img src="${pageContext.request.contextPath}/images/btn_delet.gif" alt="삭제" /></a></li>-->
            </ul>
        </div>
    </div>
</div>
<script type="text/jsx;harmony=true">
    mentor.assignPageNavi = React.render(
        <PageNavi  pageFunc={goSearch} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
        document.getElementById('paging')
    );
</script>
<script type="text/javascript">
    var searchFlag = 'load';
    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function() {

        enterFunc($("#coNm"),goSearch);
        enterFunc($("#grpNm"),goSearch);

        $( "#clasStartDay" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#clasEndDay").datepicker("option", "minDate", selectedDate);
            }
        });
        $( "#clasEndDay" ).datepicker({
            showOn: "both",
            buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
            buttonImagesOnly:true,
            dateFormat: "yy-mm-dd",
            onClose: function(selectedDate) {
                $("#clasStartDay").datepicker("option", "maxDate", selectedDate);
            }
        });

        //일간 버튼 클릭 event
        $("#btnDayRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#clasStartDay").val(sEndDate);
            //var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 1)).format("yyyy-MM-dd");
            $("#clasEndDay").val(sEndDate);
        });

        //주간 버튼 클릭 event
        $("#btnWeekRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 6)).format("yyyy-MM-dd");
            $("#clasStartDay").val(sStartDate);
            $("#clasEndDay").val(sEndDate);
        });

        //월간 버튼 클릭 event
        $("#btnMonthRange").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 30)).format("yyyy-MM-dd");
            $("#clasStartDay").val(sStartDate);
            $("#clasEndDay").val(sEndDate);
        });

        //$("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");

        initCode($("#schClassCd"),"${codeConstants['CD100211_100494_학교']}","${param.schClassCd}");
/*
        $("#m1").click( function() {
        	var s;
        	s = $('#boardTable').jqGrid('getGridParam','selarrrow');

        });
        $("#m1s").click( function() {
        	$('#boardTable').jqGrid('setSelection', '0000001245');
        });
*/
        goSearch(1);
    });



    function goSearch(curPage, recordCountPerPage){

        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'배정사업', name:'grpNm',index:'grpNm', width:50, align:'center', sortable: false});
        colModels.push({label:'배정기간', name:'clasDay',index:'clasDay', width:60, align:'center', sortable: false});
        colModels.push({label:'상태', name:'grpYn',index:'grpYn', width:60, align:'center', sortable: false});
        colModels.push({label:'총배정횟수', name:'clasCnt',index:'clasCnt', width:60, align:'center', sortable: false});
        colModels.push({label:'사용횟수', name:'clasEmpCnt',index:'clasEmpCnt', width:45, align:'center', sortable: false});
        colModels.push({label:'잔여횟수', name:'clasPermCnt',index:'clasPermCnt', width:45, align:'center', sortable: false, key: true});
        colModels.push({label:'주관기관', name:'coNm',index:'coNm', width:45, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', width:45, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
        //initJqGridTable('boardTable', colModels, 10, false);
        //resizeJqGridWidth('boardTable', 'boardArea', 500);

        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'clasStartDay':$("#clasStartDay").val()
                                            ,'clasEndDay':$("#clasEndDay").val()
                                            ,'schClassCd':$('#schClassCd').val()
                                            ,'grpNm':$("#grpNm").val()
                                            ,'schNm':$("#schNm").val()
                                            ,'sidoNm':$("#sidoNm").val()
                                            ,'coNm':$("#coNm").val()
                                            ,'grpState':$(':radio[name="grpState"]:checked').val()
                                            ,'sgguNm':$("#sgguNm").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/assign/biz/ajax.listAssignGroup.do",
            data : $.param(_param, true),
            success: function(rtnData) {
            console.log(rtnData);
                var totalCount = 0;
                var schoolData = rtnData.map(function(item, index) {
                    totalCount = rtnData[0].totalRecordCount;

                    item.rn = totalCount - item.rn + 1;
                    var groups = [];

                    item.regDtm = new Date(item.regDtm).format('yyyy.MM.dd');

                    var assignData = rtnData.map(function(item, index) {
                        // 관련 배정기간 설정
                        if(item.clasStartDay != null && item.clasEndDay != null){
                            item.clasDay = mentor.parseDate(item.clasStartDay).format('yyyy.MM.dd') + "~" + mentor.parseDate(item.clasEndDay).format('yyyy.MM.dd')
                        }
                        if(item.clasEmpCnt == 0 && item.clasPermCnt == 0 && item.clasCnt != 0){
                            item.clasPermCnt =  item.clasCnt;
                        }
                        item.clasCnt = Number(item.clasPermCnt) + Number(item.clasEmpCnt);
                        return item;
                    });
                    var strLinkUrl = mentor.contextpath + "/assign/biz/view.do?setTargtNo=" + item.setTargtNo;
                    var grpStr = "<a class='underline' href='#' onclick='goView(\""+item.setTargtNo+"\");'>" + item.grpNm +"</a>";

                    item.grpNm = grpStr;

                    return item;
                });

                // grid data binding
                //setDataJqGridTable('boardTable', schoolData);
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 배정사업이 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable', 'boardArea', 500, schoolData, emptyText);
                // grid data binding

                if(rtnData != null && rtnData.length > 0) {
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.assignPageNavi.setData(dataSet.params);

                //$(".page-loader").hide();
                //$('body').removeClass('dim');

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });

    }
    function goView(setTargtNo) {
        $('#setTargtNo').val(setTargtNo);
        var qry = $('#frm').serialize();
        $(location).attr('href', mentor.contextpath+'/assign/biz/view.do?' + qry);
    }
</script>
