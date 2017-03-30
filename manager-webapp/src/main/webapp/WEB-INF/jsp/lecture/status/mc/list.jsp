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
        <h2>MC 현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업현황관리</li>
            <li>MC 현황</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="mcNo" name="mcNo" />
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>MC명</strong>
                <input type="text" id="mcNm" name="mcNm" value="${param.mcNm}" />
            </li>
            <li class="condition-big">
               <p><strong>상태</strong></p>
               <ul class="detail-condition">
                   <li>
                       <label><input type="radio" name="useYn" value="" <c:if test="${empty param.useYn}">checked='checked'</c:if> /> 전체</label>
                   </li>
                   <li>
                       <label><input type="radio" name="useYn" value="Y" <c:if test="${param.useYn eq 'Y'}">checked='checked'</c:if> /> 활동중</label>
                   </li>
                   <li>
                       <label><input type="radio" name="useYn" value="N" <c:if test="${param.useYn eq 'N'}">checked='checked'</c:if> /> 활동안함</label>
                   </li>
               </ul>
           </li>
        </ul>
        <ul>
            <li>
                <strong>소속기업</strong>
                <input type="text" id="mngrPosNm" name="mngrPosNm" value="${param.mngrPosNm}"/>
            </li>
            <li class="condition-big">
               <p><strong>성별</strong></p>
               <ul class="detail-condition">
                   <li>
                       <label><input type="radio" name="genCd" value="" <c:if test="${empty param.genCd}">checked='checked'</c:if> /> 전체</label>
                   </li>
                   <li>
                       <label><input type="radio" name="genCd" value="100323" <c:if test="${param.genCd eq '100323'}">checked='checked'</c:if> /> 남</label>
                   </li>
                   <li>
                       <label><input type="radio" name="genCd" value="100324" <c:if test="${param.genCd eq '100324'}">checked='checked'</c:if> /> 여</label>
                   </li>
               </ul>
           </li>
        </ul>
        <ul>
           <li class="condition-big">
                <p><strong>등록기간</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text"id="searchStDate" name="searchStDate"  class="date-input" value="${param.searchStDate}" />
                        <span> ~ </span>
                        <input type="text"id="searchEndDate" name="searchEndDate"  class="date-input" value="${param.searchEndDate}" />
                        <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                        <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                        <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                        <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
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
        colModels.push({label:'MC명', name:'mcNm',index:'mcNm', width:50, align:'center', sortable: false});
        colModels.push({label:'성별', name:'genCd',index:'genCd', width:50, align:'center', sortable: false});
        //colModels.push({label:'휴대전화', name:'contTel',index:'contTel', width:60, align:'center', sortable: false});
        colModels.push({label:'소속기업', name:'mngrPosNm',index:'mngrPosNm', width:60, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm',index:'regMbrNm', width:60, align:'center', sortable: false});
        colModels.push({label:'사용유무', name:'useYn',index:'useYn', width:45, align:'center', sortable: false});
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

        var _param = jQuery.extend({'mcNm':$("#mcNm").val()
                                            ,'contTel':$("#contTel").val()
                                            ,'mngrPosNm':$('#mngrPosNm').val()
                                            ,'searchStDate':$("#searchStDate").val()
                                            ,'searchEndDate':$("#searchEndDate").val()
                                            ,'sidoNm':$("#sidoNm").val()
                                            ,'coNm':$("#coNm").val()
                                            ,'useYn':$(':radio[name="useYn"]:checked').val()
                                            ,'genCd':$(':radio[name="genCd"]:checked').val()
                                            ,'sgguNm':$("#sgguNm").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/ajax.listMc.do",
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


                    var strDlistUrl = mentor.contextpath + "/lecture/status/mc/view.do?mcNo=" + item.mcNo;
                    if(item.mcNm != null){
                        var mcNm = "<a href='#' class='underline' onclick='goView(\"" + item.mcNo + "\");'>" + item.mcNm + "</a>";
                        item.mcNm = mcNm;
                    }

                    if(item.genCd != null){
                        if(item.genCd == '100323'){
                            item.genCd = '남';
                        }else{
                            item.genCd = '여';
                        }
                     }
                    if(item.useYn == 'Y'){
                        item.useYn = '활동중';
                    }else{
                        item.useYn = "<font color='red'>활동정지</font>";
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

    function goView(mcNo){
        $('#mcNo').val(mcNo);
        var qry = $('#frm').serialize();
        $(location).attr('href', mentor.contextpath+'/lecture/status/mc/view.do?' + qry);
    }
</script>
