<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<%--<div class="page-loader" style="display:none;">
    <img src="${pageContext.request.contextPath}/images/img_page_loader.gif" alt="페이지 로딩 이미지">
</div>--%>
<div class="cont">
    <div class="title-bar">
        <h2>문자전송내역</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>알림관리</li>
            <li>문자전송내역</li>
        </ul>
    </div>
    <div class="search-area">
        <ul>
           <li class="condition-big">
                <p><strong>기간선택</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text"id="searchStDate"  class="date-input" />
                        <span> ~ </span>
                        <input type="text"id="searchEndDate"  class="date-input" />
                        <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                        <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                        <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                        <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>조건검색</strong>
                <select id="searchType" name="searchType" >
                    <option value="">전체</option>
                    <option value="1">발송인</option>
                    <option value="2">메세지</option>
                </select>
                <input type="text" id="searchNm" />
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
            <ul>
                <li><button type="button" class="btn-orange" onclick="copyList(1);"><span>수신자복사전송</span></button></li>
                <li><button type="button" class="btn-orange" onclick="copyList(2)"><span>동일메시지전송</span></button></li>
                <li><button type="button" class="btn-orange" onclick="location.href='../sms/list.do'"><span>신규문자전송</span></button></li>
            </ul>
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


<form:form commandName="mcInfo" action="${pageContext.request.contextPath}/notify/sms/list.do" method="post" id="frm">
</form:form>
<c:import url="/popup/smsHistorySearch.do">
  <c:param name="popupId" value="_smsHistoryPopup" />
  <c:param name="callbackFunc" value="callbackSmsSelected" />
</c:import>
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
        colModels.push({label:'발송인유형', name:'coNm',index:'coNm', width:50, align:'center', sortable: false});
        colModels.push({label:'발송인', name:'nm',index:'nm', width:50, align:'center', sortable: false});
        colModels.push({label:'발송일', name:'sendDate',index:'sendDate', width:50, align:'center', sortable: false});
        colModels.push({label:'채널', name:'chanel',index:'chanel', width:60, align:'center', sortable: false});
        colModels.push({label:'종류', name:'sendTargtNm',index:'sendTargtNm', width:60, align:'center', sortable: false});
        colModels.push({label:'메시지', name:'sendMsg',index:'sendMsg', width:100, sortable: false});
        colModels.push({label:'수신자', name:'sendCnt',index:'sendCnt', width:45, align:'center', sortable: false});
        colModels.push({label:'성공건', name:'sendSuccessCnt',index:'sendSuccessCnt', width:45, align:'center', sortable: false});
        colModels.push({label:'실패건', name:'sendFallCnt',index:'sendFallCnt', width:45, align:'center', sortable: false});
        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);
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
        var _param = jQuery.extend({'searchStDate':$("#searchStDate").val()
                                    ,'searchEndDate':$("#searchEndDate").val()
                                    ,'searchType':$('#searchType').val()
                                    ,'searchNm':$("#searchNm").val()
                                    ,'sendTargtCd':'101673'}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/notify/hist/ajax.sendSmsHistoryList.do",
            data : $.param(_param, true),
            success: function(rtnData) {
            console.log(rtnData);
                var totalCount = 0;
                var smsData = rtnData.map(function(item, index) {
                    totalCount = rtnData[0].totalRecordCount;
                    item.gridRowId = item.msgSer;
                    item.rn = totalCount - item.rn + 1;
                    if(item.chanel == null){
                        item.chanel = '어드민';
                    }
                    if(item.sendCnt > 0){
                        var grpStr = "<a class='underline' href='#' onclick='historyPop("+item.msgSer+");'>" + item.sendCnt +"</a>";
                        item.sendCnt = grpStr;
                    }

                    return item;
                });

                // grid data binding
                //setDataJqGridTable('boardTable', schoolData);
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable', 'boardArea', 500, smsData, emptyText);
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


    function copyList(num){
        var inputs = "";
        var selSms =  $('#boardTable').jqGrid('getGridParam','selarrrow');
        if(selSms.length > 1){
            alert("발송한 메시지 중 하나만 선택해주세요.");
            return false;
        }else if(selSms.length == 0){
            alert("발송한 메시지를 선택해주세요.");
            return false;
        }

        if(num == 1){
            inputs+="<input type='hidden' name='msgSer' value='"+ selSms[0] +"' />";
        }else{
            var sendMsg = $('#boardTable').jqGrid('getRowData', selSms[0]).sendMsg;
            inputs+="<input type='hidden' name='sendMsg' value='"+ sendMsg +"' />";
        }
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";
        $('#frm').empty().append(inputs);
        $("#frm").submit();
    }

    function historyPop(msgSer){
        $('.popup-area').css({'display': 'block'});
        goPage(msgSer);
    }

</script>
