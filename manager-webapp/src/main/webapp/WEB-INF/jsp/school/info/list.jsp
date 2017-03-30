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
        <h2>학교정보관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>학교관리</li>
            <li>학교정보관리</li>
        </ul>
    </div>
    <script type="text/javascript">
        var userCategory = {
            '${codeConstants["CD100494_100495_초등학교"]}': '초',
            '${codeConstants["CD100494_100496_중학교"]}': '중',
            '${codeConstants["CD100494_100497_고등학교"]}': '고',
            '${codeConstants["CD100494_101736_기타"]}': '기타',
        };
    </script>
    <form id="frm">
    <div class="search-area general-srch">

        <input type="hidden" id="schNo" name="schNo"/>
        <ul>
            <li class="condition-big">
                <p><strong>학교급</strong></p>
                <ul class="detail-condition" id="rdoMbrCualfCds">
                    <li>
                        <label><input type="radio" name="schClassCd" value="" checked='checked' /> 전체</label>
                    </li>
                </ul>
            </li>
            <li class="condition-big">
                <p><strong>사용유무</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="useChck" <c:if test="${empty param.useChck}">checked='checked'</c:if>  value="" /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="useChck" <c:if test="${param.useChck eq 'Y'}">checked='checked'</c:if>  value="Y" /> 사용중</label>
                    </li>
                    <li>
                        <label><input type="radio" name="useChck" <c:if test="${param.useChck eq 'N'}">checked='checked'</c:if> value="N" /> 사용안함</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <!-- <li class="condition-big">
            <strong>등록기간</strong>
            <input type="text"id="clasStartDay"  class="date-input" readonly="readonly" value="${param.clasStartDay}"  />
            <span> ~ </span>
            <input type="text"id="clasEndDay"  class="date-input" readonly="readonly" value="${param.clasEndDay}"  />
            </li>
            <li>
            <strong>배정그룹</strong>
            <input type="text" id="grpNm" value="${param.grpNm}" />
            </li>-->
            <!--<li>
                <strong>학교급</strong>
                <select id="schClassCd" style="width:290px;" name="schClassCd"><option value="">전체</option></select>
            </li>-->
            <li>
            <strong>지역/시군구</strong>
            <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100135_100351_지역코드'])" var="sidoNm" />
            <select id="sidoNm" name="sidoNm">
                <option value="" <c:if test="${param.sidoNm eq ''}">selected='selected'</c:if>>전체</option>
                <c:forEach items="${sidoNm}" var="eachObj" varStatus="vs">
                <option value="${eachObj.cdNm}" <c:if test="${param.sidoNm eq eachObj.cdNm}">selected='selected'</c:if> >${eachObj.cdNm}</option>
                </c:forEach>
            </select>
            /
            <select id="sgguNm" name="sgguNm" title="지역선택(구/군)">
                <option value="">시군구선택</option>
            </select>
            </li>
            <li>
                <strong class="w-auto">학교관리자 아이디</strong>
                <input type="text" class="w-text" id="userId" name="userId" value="${param.userId}" />
            </li>
            <li>
                <strong class="w-auto">학교명</strong>
                <input type="text" class="w-text" id="schNm" name="schNm" value="${param.schNm}" />
            </li>
            <li>
                <strong class="w-auto">학교코드</strong>
                <input type="text" class="w-text" id="schCd" name="schCd" value="${param.schCd}" />
            </li>
        </ul>
        <ul>
            <li>
                <strong>등록기간</strong>
                <input type="text" id="clasStartDay" name="clasStartDay" readonly="readonly" class="date-input" value="${param.clasStartDay}" />
                <span> ~ </span>
                <input type="text" id="clasEndDay" name="clasEndDay" readonly="readonly" class="date-input" value="${param.clasEndDay}" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>일간</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>주간</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>월간</span></button>
            </li>
        </ul>

        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
        <!-- <p class="search-btnbox">
            <a href="javascript:void(0)" onclick="goSearch(1)"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색" /></a>
        </p>-->
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

<form id='schRpsForm' method='POST'>
</form>
<script type="text/jsx;harmony=true">
    mentor.schoolPageNavi = React.render(
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
        sidoInfo();
        // 지역시 변경
        $('#sidoNm').change(function() {
            $('#sgguNm').find('option:not(:first)').remove()
                .end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/school/info/ajax.sgguInfo.do', {
                    data: { sidoNm: this.value },
                    success: function(rtnData) {
                        $('#sgguNm').loadSelectOptions(rtnData,'','sgguNm','sgguNm',1);
                        $("#sgguNm").val('${param.sgguNm}');
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        var mbrCualfCds = [];
        $.each(userCategory, function(k, v) {
            mbrCualfCds.push($('<li><label><input type="radio" name="schClassCd" value="' + k + '" /> ' + v + '</label></li>'));
        });

        $('#rdoMbrCualfCds').append(mbrCualfCds);



        enterFunc($("#grpNm"),goSearch);
        enterFunc($("#schNm"),goSearch);

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
        $("input:radio[name='schClassCd']:radio[value='${param.schClassCd}']").attr("checked",true);

        $("select[name='sidoNm']").val('${param.sidoNm}').attr("selected",true);

        $("#sidoNm").change();




/*
        $("#m1").click( function() {
        	var s;
        	s = $('#boardTable').jqGrid('getGridParam','selarrrow');
        	alert(s);
        });
        $("#m1s").click( function() {
        	$('#boardTable').jqGrid('setSelection', '0000001245');
        });


*/
        goSearch(1);
    });

    function excelDownLoad() {
        var url = mentor.contextpath + "/school/info/ajax.excelDownListSchInfoWithGroup.do";
        var paramData = $.param({'clasStartDay':$("#clasStartDay").val()
                                ,'clasEndDay':$("#clasEndDay").val()
                                ,'grpNm':$("#grpNm").val()
                                ,'schClassCd':$("#schClassCd").val()
                                ,'schMbrCualfCd':'101699'
                                ,'schCd':$("#schCd").val()
                                }, true);

        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
        });

        //debugger
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";
        inputs+="<input type='hidden' name='schNm' value='" + $("#schNm").val() + "' />";
        inputs+="<input type='hidden' name='sidoNm' value='" + $("#sidoNm").val() + "' />";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";

        jQuery(sForm).appendTo("body").submit().remove();
    }

    function goSearch(curPage, recordCountPerPage){
        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassNm',index:'schClassNm', width:50, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:60, align:'center', sortable: false});
        colModels.push({label:'시군구', name:'sgguNm',index:'sgguNm', width:60, align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:60, align:'center', sortable: false});
        colModels.push({label:'교실수', name:'clasRoomCnt',index:'schNm', width:45, align:'center', sortable: false});
        colModels.push({label:'학교관리자 아이디', name:'userId',index:'userId', width:45, align:'center', sortable: false});
        colModels.push({label:'학교코드', name:'schNo',index:'schNo', width:45, align:'center', sortable: false, key: true});
        colModels.push({label:'현재사업수', name:'clasCnt',index:'clasCnt', width:45, align:'center', sortable: false});
        colModels.push({label:'잔여횟수', name:'clasPermCnt',index:'clasPermCnt', width:45, align:'center', sortable: false});
        colModels.push({label:'사용유무', name:'useYn',index:'useYn', width:45, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', width:45, align:'center', sortable: false});


        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
        //initJqGridTable('boardTable', colModels, 10, false);
        //resizeJqGridWidth('boardTable', 'boardArea', 500);

        //$('body').addClass('dim');
        //$(".page-loader").show();
        $('.jqgrid-overlay').show();
        $('.loading').show();


        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        var _param = jQuery.extend({'clasStartDay':$("#clasStartDay").val()
                      ,'clasEndDay':$("#clasEndDay").val()
                      ,'grpNm':$("#grpNm").val()
                      ,'schClassCd':$(':radio[name="schClassCd"]:checked').val()
                      ,'useYn':$(':radio[name="useChck"]:checked').val()
                      ,'schNm':$("#schNm").val()
                      ,'sidoNm':$("#sidoNm").val()
                      ,'sgguNm':$("#sgguNm").val()
                      ,'schCd':$("#schCd").val()
                      ,'userId':$("#userId").val()
                      ,'schMbrCualfCd':'101699'}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/school/info/ajax.listSchInfoWithGroup.do",
            data : $.param(_param, true),
            success: function(rtnData) {

            console.log(rtnData);
                var totalCount = 0;
                var schoolData = rtnData.map(function(item, index) {
                    totalCount = rtnData[0].totalRecordCount;
                    var useYn = item.useYn;
                    //alert(useYn);
                    if(useYn.indexOf('Y')> -1){
                        useYn = "사용중";
                    }else{
                        useYn = "<font color='red'>사용안함</font>";
                    }
                    item.useYn = useYn;

                    item.rn = totalCount - item.rn + 1;
                    item.gridRowId = item.schNo;
                    var groups = [];
                    if(item.grpData != null){
                    /*
                        groups = item.grpData.split("],[");
                        var grpStr = '';
                        var dpDt = groups.map(function(group,index){
                            var grpDt = group.split("},{");
                            var strLinkUrl = mentor.contextpath + "/school/info/viewAssignGroup.do?setTargtNo=" + grpDt[0];

                            grpStr += "<a href=" + strLinkUrl +"><div>" + grpDt[1] + "({0}~{1})".format(mentor.parseDate(grpDt[2]).format("yyyy.MM.dd"), mentor.parseDate(grpDt[3]).format("yyyy.MM.dd")) + "</div></a>";
                            return group;
                        });
                        item.grpData = grpStr;
                    */

                    }


                    var strDlistUrl = mentor.contextpath + "/school/info/view.do?schNo=" + item.schNo;
                    if(item.schNm != null){
                        var schStr = "<a href='#' class='underline' onclick='goView(\""+item.schNo+"\");'>" + item.schNm + "</a>";
                        item.schNm = schStr;
                    }
                    if(item.userId != null){
                        var userId = "<a href='#' class='underline' onclick='goView(\""+item.schNo+"\");'>" + item.userId + "</a>";
                        item.userId = userId;
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
                mentor.schoolPageNavi.setData(dataSet.params);

                //$(".page-loader").hide();
                //$('body').removeClass('dim');

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    function sidoInfo(){
        $('#sidoNm').find('option:not(:first)').remove()
            .end().val('').change();
        $.ajax('${pageContext.request.contextPath}/school/info/ajax.sidoInfo.do', {
            success: function(rtnData) {
                $('#sidoNm').loadSelectOptions(rtnData,'','sidoNm','sidoNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });
    }

/*

function callbackSelected(schInfos){
    $("#locaAddr").val(schInfos.ROADADDR);
    $("#postCd").val(schInfos.ZIPNO);
    var splitAddr = schInfos.JIBUNADDR.split(" ");
    $("#sidoNm").val(splitAddr[0]);
    $("#sgguNm").val(splitAddr[1]);
    $("#umdngNm").val(splitAddr[2]);
    alert(schInfos.ROADADDR);
}

*/

function goView(schNo) {
    $('#schNo').val(schNo);
    var qry = $('#frm').serialize();
    $(location).attr('href', mentor.contextpath+'/school/info/view.do?' + qry);
}
</script>
