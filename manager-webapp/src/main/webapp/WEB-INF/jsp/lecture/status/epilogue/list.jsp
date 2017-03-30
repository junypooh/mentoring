<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>

<div class="cont">
    <div class="title-bar">
        <h2>수업후기</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업정보관리</li>
            <li>수업후기</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="cmtSer" name="cmtSer" />
    <div class="search-area general-srch">
        <ul>
            <li class="condition-big">
                <p><strong>수업유형</strong></p>
                <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD101512_101528_강의유형코드'])" var="list" />
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="lectTypeCd" value="" <c:if test="${empty param.lectTypeCd}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <c:forEach items="${list}" var="list" varStatus="vs">
                        <li>
                            <label><input type="radio" name="lectTypeCd" value="${list.cd}" <c:if test="${param.lectTypeCd eq list.cd}">checked='checked'</c:if> /> ${list.cdNm}</label>
                        </li>
                    </c:forEach>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>회원유형</strong></p>
                <ul class="detail-condition">
					<li>
						<label><input type="radio" name="mbrCualfType" value="" <c:if test="${empty param.mbrCualfType}">checked='checked'</c:if> /> 전체</label>
					</li>
					<li>
						<label><input type="radio" name="mbrCualfType" value="student" <c:if test="${param.mbrCualfType eq 'student'}">checked='checked'</c:if> /> 학생</label>
					</li>
					<li>
						<label><input type="radio" name="mbrCualfType" value="teacher" <c:if test="${param.mbrCualfType eq 'teacher'}">checked='checked'</c:if> /> 교사</label>
					</li>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>수업명</strong>
                <input type="text" name="lectTitle" id="lectTitle" class="text" value="${param.lectTitle}" />
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>학교급</strong></p>
                <ul class="detail-condition">
                    <input type="hidden" id="lectTargtCd" name="lectTargtCd" value="${param.lectTargtCd}"/>
					<li>
                        <c:set var="checkVal" value="false" />
					    <c:if test="${param.lectTargtCd eq code['CD101533_101534_초등학교'] or param.lectTargtCd eq code['CD101533_101537_초등_중학교'] or param.lectTargtCd eq code['CD101533_101539_초등_고등학교'] or param.lectTargtCd eq code['CD101533_101540_초등_중_고등학교']}">
					        <c:set var="checkVal" value="true" />
					    </c:if>
						<label><input type="checkbox" name="lectTargtCode" value="101534" <c:if test="${checkVal}">checked='checked'</c:if>/> 초</label>
					</li>
					<li>
                        <c:set var="checkVal" value="false" />
					    <c:if test="${param.lectTargtCd eq code['CD101533_101535_중학교'] or param.lectTargtCd eq code['CD101533_101537_초등_중학교'] or param.lectTargtCd eq code['CD101533_101538_중_고등학교'] or param.lectTargtCd eq code['CD101533_101540_초등_중_고등학교']}">
					        <c:set var="checkVal" value="true" />
					    </c:if>
						<label><input type="checkbox" name="lectTargtCode" value="101535" <c:if test="${checkVal}">checked='checked'</c:if>/> 중</label>
					</li>
					<li>
                        <c:set var="checkVal" value="false" />
					    <c:if test="${param.lectTargtCd eq code['CD101533_101536_고등학교'] or param.lectTargtCd eq code['CD101533_101538_중_고등학교'] or param.lectTargtCd eq code['CD101533_101539_초등_고등학교'] or param.lectTargtCd eq code['CD101533_101540_초등_중_고등학교']}">
					        <c:set var="checkVal" value="true" />
					    </c:if>
						<label><input type="checkbox" name="lectTargtCode" value="101536" <c:if test="${checkVal}">checked='checked'</c:if>/> 고</label>
					</li>
					<li>
						<label><input type="checkbox" name="schoolEtcGrd" value="101713" <c:if test="${param.schoolEtcGrd eq '101713'}">checked='checked'</c:if> /> 기타</label>
					</li>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>멘토</strong>
                <input type="text" name="lectrNm" id="lectrNm" class="text" value="${param.lectrNm}" />
            </li>
        </ul>
        <ul>
            <li>
                <strong>배정사업</strong>
                <input type="text" name="grpNm" id="grpNm" class="text" value="${param.grpNm}" />
            </li>
        </ul>
        <ul>
            <li>
                <strong>직업명</strong>
                <input type="text" name="jobNm" id="jobNm" class="text" value="${param.jobNm}" />
            </li>
        </ul>
        <ul>
            <li>
                <strong>교육수행기관</strong>
                <input type="text" name="coNm" id="coNm" class="text" value="${param.coNm}" />
            </li>
        </ul>
		<ul>
            <li>
                <strong>등록기간</strong>
                <input type="text" id="searchStDate" name="searchStDate" class="date-input" value="${param.searchStDate}" />
                <span> ~ </span>
                <input type="text" id="searchEndDate" name="searchEndDate" class="date-input" value="${param.searchEndDate}" />
                <button class="btn-style01" type="button" id="btnDayRange"><span>1일</span></button>
                <button class="btn-style01" type="button" id="btnWeekRange"><span>7일</span></button>
                <button class="btn-style01" type="button" id="btnMonthRange"><span>1개월</span></button>
                <button class="btn-style01" type="button" id="btn6MonthRange"><span>6개월</span></button>
            </li>
		</ul>
        <ul>
            <li>
                <strong>작성자</strong>
                <input type="text" name="regMbrNm" id="regMbrNm" class="text" value="${param.regMbrNm}" />
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
            <ul>
                <li>
                    <button type="button" class="btn-style02" onClick="fn_excelDown();"><span>엑셀다운로드</span></button>
                </li>
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
            pageSize: 10
        }
    };
    var searchFlag = 'load';

    $(document).ready(function(){

        enterFunc($("#lectTitle"),goSearch);
        enterFunc($("#lectrNm"),goSearch);
        enterFunc($("#grpNm"),goSearch);
        enterFunc($("#jobNm"),goSearch);
        enterFunc($("#coNm"),goSearch);
        enterFunc($("#regMbrNm"),goSearch);


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

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(cmtSer) {
        $('#cmtSer').val(cmtSer);
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
        colModels.push({label:'번호', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'수업유형', name:'lectTypeNm', index:'lectTypeNm', width:20, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle', width:70, sortable: false});
        colModels.push({label:'멘토', name:'lectrNm', index:'lectrNm', width:30, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm', index:'jobNm', width:30, align:'center', sortable: false});
        colModels.push({label:'후기내용', name:'cmtSust', index:'cmtSust', width:70, sortable: false});
        colModels.push({label:'평점', name:'asmPnt', index:'asmPnt', width:20, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'lectTargtNm', index:'lectTargtNm', width:30, align:'center', sortable: false});
        colModels.push({label:'작성자', name:'regMbrNm', index:'regMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm', index:'regDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        // 수업대상 체크박스
        var checkLectType = new Array;
        $('input[name=lectTargtCode]:checked').each(function(index){
            checkLectType.push($(this).val());
        });

        if(checkLectType.length == 1){
            $("#lectTargtCd").val(checkLectType[0]);
        }else if(checkLectType.length == 2){
            if (!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101535_중학교']}")) { //초등,중학교
                $("#lectTargtCd").val("${code['CD101533_101537_초등_중학교'] }");
            } else if (!!~checkLectType.indexOf("${code['CD101533_101535_중학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")) { //중등,고등학교
                $("#lectTargtCd").val("${code['CD101533_101538_중_고등학교'] }");
            } else if (!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")) { //초등,고등학교
                $("#lectTargtCd").val("${code['CD101533_101539_초등_고등학교'] }");
            }
        }else if(checkLectType.length == 3){
            $("#lectTargtCd").val("${code['CD101533_101540_초등_중_고등학교'] }");
        }else{
            $("#lectTargtCd").val("");
        }

        var _param = jQuery.extend({
                       'lectTypeCd' : $('input[name=lectTypeCd]:checked').val()
                      ,'mbrCualfType': $('input[name=mbrCualfType]:checked').val()
                      ,'lectTitle':$('#lectTitle').val()
                      ,'schoolGrd': $("#lectTargtCd").val()
                      ,'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val()
                      ,'lectrNm':$('#lectrNm').val()
                      ,'grpNm':$('#grpNm').val()
                      ,'jobNm':$('#jobNm').val()
                      ,'coNm':$('#coNm').val()
                      ,'regMbrNm':$('#regMbrNm').val()
                      ,'searchStDate':$('#searchStDate').val()
                      ,'searchEndDate':$('#searchEndDate').val()
                      }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/epilogue/ajax.list.do",
            data : $.param(_param, true),
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                var data = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;

                    var lectTargtNm;
                    if(item.lectTargtCd == "${code['CD101533_101534_초등학교']}"){
                        lectTargtNm = '초';
                    }else if(item.lectTargtCd == "${code['CD101533_101535_중학교']}"){
                        lectTargtNm = '중';
                    }else if(item.lectTargtCd == "${code['CD101533_101536_고등학교']}"){
                        lectTargtNm = '고';
                    }else if(item.lectTargtCd == "${code['CD101533_101537_초등_중학교']}"){
                        lectTargtNm = '초중';
                    }else if(item.lectTargtCd == "${code['CD101533_101538_중_고등학교']}"){
                        lectTargtNm = '중고';
                    }else if(item.lectTargtCd == "${code['CD101533_101539_초등_고등학교']}"){
                        lectTargtNm = '초고';
                    }else if(item.lectTargtCd == "${code['CD101533_101540_초등_중_고등학교'] }"){
                        lectTargtNm = '초중고';
                    }
                    item.lectTargtNm = lectTargtNm;

                    if(item.mbrCualfCd == '100205' || item.mbrCualfCd == '100206' || item.mbrCualfCd == '100207' || item.mbrCualfCd == '100208'){
                        item.mbrCualfNm = '학생';
                    }else if(item.mbrCualfCd == '100214' || item.mbrCualfCd == '100215'){
                        item.mbrCualfNm = '교사';
                    }

                    item.regMbrNm = item.regMbrNm + '(' + item.mbrCualfNm + ')';

                    var strLinkUrl = mentor.contextpath + "/lecture/status/epilogue/view.do?cmtSer=" + item.cmtSer;
                    //item.cmtSust = "<a href='" + strLinkUrl + "' class='underline'>" + item.cmtSust + "</a>";
                    item.cmtSust = "<a href='javascript:void(0)' class='underline' onclick='goView(\"" + item.cmtSer + "\")'>" + item.cmtSust + "</a>";

                    // 개행문자 처리
                    item.cmtSust = String(item.cmtSust).replaceAll('\n',' ');

                    item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');
                    return item;
                });

                // grid data binding
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable', 'boardArea', 500, data, emptyText);
                // grid data binding


                mentor.pageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    // 엑셀다운로드
    function fn_excelDown(){
        var url = "${pageContext.request.contextPath}/lecture/status/epilogue/excel.list.do";
        var paramData = $.param({
                       'lectTypeCd' : $('input[name=lectTypeCd]:checked').val()
                      ,'mbrCualfType': $('input[name=mbrCualfType]:checked').val()
                      ,'lectTitle':$('#lectTitle').val()
                      ,'schoolGrd': $("#lectTargtCd").val()
                      ,'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val()
                      ,'lectrNm':$('#lectrNm').val()
                      ,'grpNm':$('#grpNm').val()
                      ,'jobNm':$('#jobNm').val()
                      ,'coNm':$('#coNm').val()
                      ,'regMbrNm':$('#regMbrNm').val()
                      ,'searchStDate':$('#searchStDate').val()
                      ,'searchEndDate':$('#searchEndDate').val()
        }, true);

        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            if(pair[0] != 'lectTitle' && pair[0] != 'lectrNm' && pair[0] != 'grpNm' && pair[0] != 'jobNm' && pair[0] != 'coNm' && pair[0] != 'regMbrNm') {
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            }
        });
        inputs+="<input type='hidden' name='lectTitle' value='" + $("#lectTitle").val() + "' />";
        inputs+="<input type='hidden' name='lectrNm' value='" + $("#lectrNm").val() + "' />";
        inputs+="<input type='hidden' name='grpNm' value='" + $("#grpNm").val() + "' />";
        inputs+="<input type='hidden' name='jobNm' value='" + $("#jobNm").val() + "' />";
        inputs+="<input type='hidden' name='coNm' value='" + $("#coNm").val() + "' />";
        inputs+="<input type='hidden' name='regMbrNm' value='" + $("#regMbrNm").val() + "' />";

        //debugger
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";
        jQuery(sForm).appendTo("body").submit().remove();
    }
</script>


