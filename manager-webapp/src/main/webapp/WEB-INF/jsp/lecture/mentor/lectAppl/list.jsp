<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>
<%--<div class="page-loader" style="display:none;">
    <img src="${pageContext.request.contextPath}/images/img_page_loader.gif" alt="페이지 로딩 이미지">
</div>--%>

<div class="cont">
    <div class="title-bar">
        <h2>수업신청/취소현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업개설관리</li>
            <li>수업신청/취소현황</li>
        </ul>
    </div>
    <div class="search-area general-srch">
        <ul>
            <li class="condition-big">
                <p><strong>구분</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="rdoApplStat" value="" checked='checked' /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" id="lectApplStat" name="rdoApplStat" value="101576" /> 수업신청</label>
                    </li>
                    <li>
                        <label><input type="radio" id="lectObsvStat" name="rdoApplStat" value="101576" /> 참관신청</label>
                    </li>
                    <li>
                        <label><input type="radio" id="lectApplStat" name="rdoApplStat" value="101578" /> 수업취소</label>
                    </li>
                    <li>
                        <label><input type="radio" id="lectObsvStat" name="rdoApplStat" value="101578" /> 참관취소</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>학교급</strong></p>
                <ul class="detail-condition">
                    <input type="hidden" id="schoolGrd" value=""/>

                    <c:forEach items="${schoolGrd}" var="info">
                    <li>
                        <label><input type="checkbox" name="schoolGrd" value="${info.cd}" /> ${info.cdNm}</label>
                    </li>
                    </c:forEach>
                </ul>
            </li>
        </ul>
        <ul>
            <li>
                <strong>학교명</strong>
                <input type="text" name="schNm" id="schNm" class="text"/>
            </li>
            <li>
                <strong class="w-auto">멘토</strong>
                <input type="text" name="lectrNm" id="lectrNm" class="text" />
            </li>
            <li>
                <strong class="w-auto">신청자</strong>
                <input type="text" name="applMbrNm" id="applMbrNm" class="text" />
            </li>
            <li>
                <strong class="w-auto">직업명</strong>
                <input type="text" name="lectrJob" id="lectrJob" class="text"/>
            </li>
        </ul>
        <ul>
            <li class="condition-big lesson-name">
                <p><strong>수업명</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="lectTitle" id="lectTitle" class="text"  style="width:324px;"  />
                    </li>
                 </ul>
            </li>
        </ul>
		<ul>
			<li class="condition-big">
				<p><strong>일시선택</strong></p>
				<ul class="detail-condition">
					<li>
						<input type="text" id="searchStDate"  class="date-input" />
						<span> ~ </span>
						<input type="text" id="searchEndDate"  class="date-input" />
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
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>0</strong> 건</p>
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
    mentor.schoolPageNavi = React.render(
        <PageNavi  pageFunc={loadData} totalRecordCount={0} currentPageNo={1} recordCountPerPage={20} pageSize={10} />,
        document.getElementById('paging')
    );
</script>

<script type="text/javascript">

    var applClassCd = "";
    var applStatCd = "";

    var applStat = $('#lectApplStat:checked').val();
    var obsvStat = $('#lectObsvStat:checked').val();

    if(applStat != null){
        applClassCd = '101715';
        applStatCd = $('#lectApplStat:checked').val();
    }else if(obsvStat != null){
        applClassCd = '101716';
        applStatCd = $('#lectObsvStat:checked').val();
    }

    var checkLectType = new Array;

    // 대상선택 체크박스
    $('input[name=schoolGrd]:checked').each(function(index){
        checkLectType.push($(this).val());
    });

    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
            searchStDate: $("#searchStDate").val(),
            searchEndDate: $("#searchEndDate").val(),
            applClassCd : applClassCd,
            applStatCd : applStatCd,
            schClassCds : checkLectType,
            lectrNm: $("#lectrNm").val(),
            lectrJob: $("#lectrJob").val(),
            lectTitle: $("#lectTitle").val(),
            schNm: $("#schNm").val(),
            applMbrNm: $("#applMbrNm").val()
        }
    };

    var searchFlag = 'load';

    $(document).ready(function () {

        enterFunc($("#lectrNm"), goSearch);
        enterFunc($("#lectrJob"), goSearch);
        enterFunc($("#lectTitle"), goSearch);
        enterFunc($("#schNm"), goSearch);
        enterFunc($("#applMbrNm"), goSearch);


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


    function setData(curPage) {
        // 수업대상
        var checkLectType = new Array;

        // 대상선택 체크박스
        $('input[name=schoolGrd]:checked').each(function(index){
            checkLectType.push($(this).val());
        });

        var applStat = $('#lectApplStat:checked').val();
        var obsvStat = $('#lectObsvStat:checked').val();

        var applClassCd = "";
        var applStatCd = "";

        if(applStat != null){
            applClassCd = '101715';
            applStatCd = $('#lectApplStat:checked').val();
        }else if(obsvStat != null){
            applClassCd = '101716';
            applStatCd = $('#lectObsvStat:checked').val();
        }

        dataSet.params.currentPageNo = curPage;
        dataSet.params.searchStDate= $("#searchStDate").val();
        dataSet.params.searchEndDate= $("#searchEndDate").val();
        dataSet.params.applClassCd= applClassCd;
        dataSet.params.applStatCd= applStatCd;
        dataSet.params.schClassCds = checkLectType;
        dataSet.params.lectrNm= $("#lectrNm").val();
        dataSet.params.lectrJob= $("#lectrJob").val();
        dataSet.params.lectTitle= $("#lectTitle").val();
        dataSet.params.schNm= $("#schNm").val();
        dataSet.params.applMbrNm= $("#applMbrNm").val();
    }

    // 엑셀다운로드
    function fn_excelDown(){
        var url = "${pageContext.request.contextPath}/lecture/mentor/lectAppl/excel.list.do";
        var paramData = $.param(dataSet.params, true);

        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            if(pair[0] != 'lectTitle' && pair[0] != 'lectrNm' && pair[0] != 'schNm' && pair[0] != 'lectrJob' && pair[0] != 'applMbrNm') {
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            }
        });

        inputs+="<input type='hidden' name='lectTitle' value='" + $("#lectTitle").val() + "' />";
        inputs+="<input type='hidden' name='lectrNm' value='" + $("#lectrNm").val() + "' />";
        inputs+="<input type='hidden' name='applMbrNm' value='" + $("#applMbrNm").val() + "' />";
        inputs+="<input type='hidden' name='lectrJob' value='" + $("#lectrJob").val() + "' />";
        inputs+="<input type='hidden' name='schNm' value='" + $("#schNm").val() + "' />";


        //debugger
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";
        jQuery(sForm).appendTo("body").submit().remove();
    }

    function goSearch(curPage) {
        searchFlag = 'search';

        setData(1);
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
        colModels.push({label:'번호', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'일시', name:'applRegDtm', index:'applRegDtm', width:40, align:'center', sortable: false});
        colModels.push({label:'상태', name:'applClassCdNm', index:'applClassCdNm', width:35, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassCdNm', index:'schClassCdNm', width:25, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm', index:'sidoNm', width:40, align:'center', sortable: false});
        colModels.push({label:'시군구', name:'sgguNm', index:'sgguNm' , width:40, sortable: false});
        colModels.push({label:'학교명', name:'schoolNm', index:'schoolNm' , width:50, sortable: false});
        colModels.push({label:'교실정보(인원수)', name:'clasRoomNm', index:'clasRoomNm' , width:60, sortable: false});
        colModels.push({label:'신청자유형', name:'clasRoomCualfCdNm', index:'clasRoomCualfCdNm', width:40, align:'center', sortable: false});
        colModels.push({label:'신청자', name:'tchrNm', index:'tchrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'배정사업', name:'grpNm', index:'grpNm' , width:70, sortable: false});
        colModels.push({label:'유형', name:'lectTypeCdNm', index:'lectTypeCdNm', width:25, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle' ,width:70, sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', width:100, align:'center', sortable: false});
        colModels.push({label:'멘토', name:'lectrNm',index:'lectrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:40, sortable: false});


        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting
                $('.jqgrid-overlay').show();
                $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/lectAppl/ajax.list.do",
            data : $.param(dataSet.params, true),
            method:"post",
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;

                    item.lectDay = to_date_format(item.lectDay, ".") + " " + to_time_format(item.lectStartTime, ":") + "~" + to_time_format(item.lectEndTime, ":") + " (" + item.lectRunTime + "분)";
                    item.clasRoomNm = item.clasRoomNm + " (" + item.clasPersonCnt + ")";


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