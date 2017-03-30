<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>배정사업관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>배정관리</li>
            <li>배정사업관리</li>
        </ul>
    </div>
    <form:form action="saveAssignGroup.do" id="assignSubmit" method="post" commandName="bizSetInfo">
    <form:hidden path="bizGrpInfo.maxApplCnt" value="${clasSetHist.maxApplCnt}" />
    <form:hidden path="bizGrpInfo.maxObsvCnt" value="${clasSetHist.maxObsvCnt}"/>
    <div class="board-area">
        <table class="tbl-style tbl-mento-modify">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">배정사업 <span class="red-point">*</span></th>
                    <td id="grpNm">
                        <form:input path="bizGrpInfo.grpNm" cssClass="text" maxlength="10"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">주관기간 <span class="red-point">*</span></th>
                    <td>

                        <spring:eval expression="@coInfoMapper.listCoInfoByCoClassCd(codeConstants['CD101659_101660_기관_교육청_'])" var="organizationCoInfos" />
                        <form:select path="bizGrpInfo.coNo">
                            <form:option value="">선택</form:option>
                            <c:forEach items="${organizationCoInfos}" var="eachObj">
                                <form:option value="${eachObj.coNo}">${eachObj.coNm}</form:option>
                            </c:forEach>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">배정기간 <span class="red-point">*</span></th>
                    <td>
                        <form:input path="clasStartDay" cssClass="date-input"/>
                        <span> ~ </span>
                        <form:input path="clasEndDay" cssClass="date-input"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">배정횟수 <span class="red-point">*</span></th>
                    <td>
                        <form:input path="clasCnt" cssClass="text" maxlength="3"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">수업 신청 기기 </th>
                    <td>${clasSetHist.maxApplCnt} 대</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">참관 신청 기기 </th>
                    <td>${clasSetHist.maxObsvCnt} 대</td>
                </tr>
            </tbody>
        </table>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
            <ul>
                <li>
                     <button type="button" class="btn-orange" id="schoolPopup"><span>추가</span></button>
                </li>
                <li>
                     <button type="button" class="btn-gray" onclick="delRow();"><span>삭제</span></button>
                </li>
            </ul>
        </div>
        <table id="boardTable2"></table>
        <div id="paging"></div>
		<div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" id="assignSubmitButton"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" onclick="location.href='list.do'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
    </form:form>
</div>
<form id='schRpsForm' name='schRpsForm' method='POST'>
<input type="hidden" id="schNoYn" name="schNoYn" value="Y"/>
</form>
<c:import url="/popup/schoolSearch.do">
  <c:param name="popupId" value="_schoolPopup" />
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
<script type="text/jsx;harmony=true">
    mentor.assignPageNavi = React.render(
        <PageNavi  pageFunc={goSearch} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
        document.getElementById('paging')
    );
</script>
<script type="text/javascript">
    var elements = [];
    var totalCnt = 0;
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
         $('#assignSubmitButton').click(function(e) {

            if($("input[name='bizGrpInfo.grpNm']").val() == ""){
                 alert("배정그룹을 입력하세요");
                 return false;
             }
             if($("input[name='clasCnt']").val() == ""){
                 alert("배정횟수을 입력하세요");
                 return false;
             }
             if($("input[name='clasStartDay']").val() == "" || $("input[name='clasEndDay']").val() == ""){
                 alert("배정기간을 입력하세요");
                 return false;
             }
             if($("select[name='bizGrpInfo.coNo']").val() == ""){
                 alert("주관기관을 선택해주세요");
                 return false;
             }
            if(confirm('저장하시겠습니까?')) {
                var grYn = "";

                $.ajax({
                    url: "${pageContext.request.contextPath}/assign/biz/ajax.assignGroupName.do",
                    data : {'grpNm':$("input[name='bizGrpInfo.grpNm']").val()},
                    contentType: "application/json",
                    dataType: 'json',
                    success: function(rtnData) {
                        if(rtnData.data == 'Y'){
                            alert("같은 배정그룹명이 존재합니다.");
                            return false;
                        }else{
                            $('#assignSubmitButton').closest('form').submit();
                        }
                    }
                });
                return false;
            } else {
                return false;
            }
        });
        $('#assignSubmit').submit(function() {

            var input = new Array();
            var selSchool =  $('#boardTable2').jqGrid('getDataIDs');
            selSchool.map(function(item, index) {
                input[index] = document.createElement("input");
                $(input[index]).attr("type","hidden");
                $(input[index]).attr('name',"bizGrpInfo.listSchInfo["+index+"].schNo");
                $(input[index]).attr("value",item);
                $('#boardTable2').append(input[index]);
            });

        });

        // 지역시 변경
        $('#sidoNm').change(function() {
            $('#sgguNm').find('option:not(:first)').remove()
                .end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/school/info/ajax.sgguInfo.do', {
                    data: { sidoNm: this.value },
                    success: function(rtnData) {
                        $('#sgguNm').loadSelectOptions(rtnData,'','sgguNm','sgguNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });


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


        //jqGrid
        var colModels = [];
        colModels.push({label:'학교급', name:'schClassNm',index:'schClassNm', width:'30%', align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:'30%', align:'center', sortable: false});
        colModels.push({label:'시군구', name:'sgguNm',index:'sgguNm', width:'30%', align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:'30%', align:'center', sortable: false});

        initJqGridTable('boardTable2', 'boardArea', 500, colModels, true);
        //initJqGridTable('boardTable2', colModels, 10, false);
        resizeJqGridWidth('boardTable2', 'boardArea', 500);


        var emptyText ="등록된 학교 목록이 없습니다.";
        setDataJqGridTable('boardTable2', 'boardArea', 500, "", emptyText);


        $("#schoolPopup").click(function(){
            $('body').addClass('dim');
            $('.popup-area').css({'display': 'block'});
            $("#aSearch").click();
            emptySchoolGridSet();
        });

    });



    function goSearch(curPage, recordCountPerPage){

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
                                            ,'sgguNm':$("#sgguNm").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/school/info/ajax.listAssignGroup.do",
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
                        return item;
                    });

                    return item;
                });

                // grid data binding
                //setDataJqGridTable('boardTable2', schoolData);
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 배정사업이 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable2', 'boardArea', 500, schoolData, emptyText);
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



            }
        });
    }

function callbackSelected(schInfos){

    //선택한 정보를 기준으로 저장할 DATA를 만든다.
    var selSchool =  $('#boardTable2').jqGrid('getDataIDs');
    closePop();

    var send = false;
    var inputs = "";

     var schInfo = {
                'schNos':[]
            };
    $.each(schInfos, function(idx){
        // 중복 제거
        var selSchoolList =  $('#boardTable2').jqGrid('getRowData', schInfos[idx]);
        if(selSchoolList.schNm == null) {
            inputs+="<input type='hidden'  name='" + "schNos".format(idx) + "' value='"+ schInfos[idx] +"' />";
            schInfo.schNos.push(schInfos[idx]);
            send = true;
        }
    });
    $('#schRpsForm').empty().append(inputs);
    $('.jqgrid-overlay').show();
    $('.loading').show();


    $.ajax({
        url: "${pageContext.request.contextPath}/ajax.listAssignSchool.do",
        data : JSON.stringify(schInfo),
        contentType: "application/json",
        dataType: 'json',
        type: 'POST',
        success: function(rtnData) {

            var schoolData = rtnData.map(function(item, index) {

                item.gridRowId = item.schNo;
                var groups = [];

                return item;
            });
            var emptyText ="등록된 학교 목록이 없습니다.";

            if(searchFlag == 'load'){
                setDataJqGridTable('boardTable2', 'boardArea', 500, schoolData, emptyText);
                searchFlag = "";
            }else{
                $('#boardTable2').jqGrid('addRowData', 'gridRowId', schoolData);
            }

            var selSchool =  $('#boardTable2').jqGrid('getDataIDs');
            if(selSchool.length > 20){
                $("#boardTable2").jqGrid('setGridHeight','649');
                resizeJqGridWidth('boardTable2', 'boardArea', 500);
            }
            var totalCount = 0;


            if(rtnData != null && rtnData.length > 0) {
                $('.board-top .total-num').html('총 <strong>' + selSchool.length +'</strong> 건');
                dataSet.params.totalRecordCount = totalCount;
            } else {
                $('.board-top .total-num').html('총 <strong>0</strong> 건');
                dataSet.params.currentPageNo = 1;
                dataSet.params.totalRecordCount = 0;
            }

            $('.loading').hide();
            $('.jqgrid-overlay').hide();
        }
    });

    totalCntTxt();
}



function delRow(){
    var selSchool =  $('#boardTable2').jqGrid('getGridParam','selarrrow');
    if(selSchool.length > 0){
        for(var i=0;selSchool.length;i++){
            delDataJqGridTable('boardTable2',selSchool[i]);
        }
    }
    totalCntTxt();
}

function totalCntTxt(){
    var selSchool =  $('#boardTable2').jqGrid('getDataIDs');
    $('.board-top .total-num').html('총 <strong>' + totalCnt +'</strong> 건');
}




</script>
