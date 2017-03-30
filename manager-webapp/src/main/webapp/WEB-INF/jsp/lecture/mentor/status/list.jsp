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
        <h2>수업현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업개설관리</li>
            <li>수업현황</li>
        </ul>
    </div>
    <div class="search-area leeson-state-srch">
        <input type="hidden" id="lectStatCd" value=""/>
        <ul>
            <li class="condition-big">
                <p><strong>수업유형</strong></p>
                <ul class="detail-condition" id="rdoLectTypeCds">
                    <li>
                        <label><input type="radio" name="lectType" value="" checked='checked' /> 전체</label>
                    <c:forEach items="${lectType}" var="info">
                    <li>
                        <label><input type="radio" name="lectType" value="${info.cd}" /> ${info.cdNm}</label>
                    </li>
                    </c:forEach>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>수업대상</strong></p>
                <ul class="detail-condition">
                    <input type="hidden" id="lectTargtCd" value=""/>
					<li>
						<label><input type="checkbox" name="cntntsType" value="101534"/> 초</label>
					</li>
					<li>
						<label><input type="checkbox" name="cntntsType" value="101535"//> 중</label>
					</li>
					<li>
						<label><input type="checkbox" name="cntntsType" value="101536"/> 고</label>
					</li>
					<li>
						<label><input type="checkbox" name="schoolEtcGrd" value="101713"/> 기타</label>
					</li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big lesson-name">
                <p><strong>수업명</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="lectTitle" id="lectTitle" class="text" />
                    </li>
                 </ul>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>노출여부</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="expsYn" value="" checked='checked' /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="expsYn" value="Y" /> 노출</label>
                    </li>
                    <li>
                        <label><input type="radio" name="expsYn" value="N" /> 비노출</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>멘토</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="lectrNm" id="lectrNm" class="text" />
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>배정사업</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="grpNm" id="grpNm" class="text" />
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>직업명</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="lectrJob" id="lectrJob" class="text" />
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>교육수행기관</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="coNm" id="coNm" class="text" />
                    </li>
                </ul>
            </li>
        </ul>
		<ul>
			<li class="condition-big">
				<p><strong>수업기간</strong></p>
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
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
	<div class="state-process">
		<ul>
			<li>
			    <a href="javascript:void(0);">
				    <span>수업전체</span>
				    <strong id="v0">1</strong>
				</a>
			</li>
			<li class="state-blue">
			    <a href="javascript:void(0);">
				    <span>수강모집</span>
				    <strong id="v1">1</strong>
				</a>
			</li>
			<li>
			    <a href="javascript:void(0);">
				    <span>수업예정</span>
				    <strong id="v2">1</strong>
				</a>
			</li>
			<li>
			    <a href="javascript:void(0);">
				    <span>진행중</span>
				    <strong id="v3">1</strong>
				</a>
			</li>
			<li class="state-red">
			    <a href="javascript:void(0);">
				    <span>모집취소</span>
				    <strong id="v4">1</strong>
				</a>
			</li>
			<li>
			    <a href="javascript:void(0);">
				    <span>수업완료</span>
				    <strong id="v5">1</strong>
				</a>
			</li>
		</ul>
	</div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">수업차수 : 총 <strong id="totalCnt">0</strong> 건  (※ 진행되는 수업 회차는 <strong id="totalLectCnt">0</strong> 건입니다.)</p>
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

    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
            searchStDate: $("#searchStDate").val(),
            searchEndDate: $("#searchEndDate").val(),
            orderBy: 'lectDay',
            lectType: $(':radio[name="lectType"]:checked').val(),
            lectStatCd: $("#lectStatCd").val(),
            schoolGrd: $("#lectTargtCd").val(),
            schoolEtcGrd: $('input[name=schoolEtcGrd]:checked').val(),
            lectrNm: $("#lectrNm").val(),
            lectrJob: $("#lectrJob").val(),
            lectTitle: $("#lectTitle").val(),
            grpNm: $("#grpNm").val(),
            coNm: $("#coNm").val(),
            expsYn: $(':radio[name="expsYn"]:checked').val()
        }
    };

    var searchFlag = 'load';

    $(document).ready(function () {


        enterFunc($("#lectrNm"), goSearch);
        enterFunc($("#lectrJob"), goSearch);
        enterFunc($("#lectTitle"), goSearch);
        enterFunc($("#grpNm"), goSearch);
        enterFunc($("#coNm"), goSearch);


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

        $("#v1").click(function () {
            setData(1);
            dataSet.params.lectStatCd = "101543";
            $("#lectStatCd").val("101543")
            loadData(1);
            searchCnt();
        });
        $("#v2").click(function () {
            setData(1);
            dataSet.params.lectStatCd = "101548";
            $("#lectStatCd").val("101548")
            loadData(1);
            searchCnt();
        });
        $("#v3").click(function () {
            setData(1);
            dataSet.params.lectStatCd = "101550";
            $("#lectStatCd").val("101550")
            loadData(1);
            searchCnt();
        });
        $("#v4").click(function () {
            setData(1);
            dataSet.params.lectStatCd = "101547";
            $("#lectStatCd").val("101547")
            loadData(1);
            searchCnt();
        });
        $("#v5").click(function () {
            setData(1);
            dataSet.params.lectStatCd = "101551";
            $("#lectStatCd").val("101551");
            loadData(1);
            searchCnt();
        });
        $("#v0").click(function () {
            setData(1);
            dataSet.params.lectStatCd = "";
            $("#lectStatCd").val("");
            loadData(1);
            searchCnt();
        });

        loadData(1);
        searchCnt();
    });


    function setData(curPage) {
        // 수업대상
        var checkLectType = new Array;

        // 대상선택 체크박스
        $('input[name=cntntsType]:checked').each(function(index){
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

        dataSet.params.currentPageNo = curPage;
        dataSet.params.searchStDate= $("#searchStDate").val();
        dataSet.params.searchEndDate= $("#searchEndDate").val();
        dataSet.params.orderBy= 'lectDay';
        dataSet.params.lectType= $(':radio[name="lectType"]:checked').val();
        dataSet.params.expsYn= $(':radio[name="expsYn"]:checked').val();
        dataSet.params.schoolGrd= $("#lectTargtCd").val();
        dataSet.params.schoolEtcGrd= $('input[name=schoolEtcGrd]:checked').val();
        dataSet.params.lectrNm= $("#lectrNm").val();
        dataSet.params.lectrJob= $("#lectrJob").val();
        dataSet.params.lectTitle= $("#lectTitle").val();
        dataSet.params.grpNm= $("#grpNm").val();
        dataSet.params.coNm= $("#coNm").val();
    }

    function goSearch(curPage) {
        searchFlag = 'search';

        setData(1);
        dataSet.params.lectStatCd='';
        loadData(curPage);
        searchCnt();
    }

    // 엑셀다운로드
    function fn_excelDown(){
        var url = "${pageContext.request.contextPath}/lecture/mentor/status/excel.list.do";
        var paramData = $.param(dataSet.params, true);

        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            if(pair[0] != 'lectTitle' && pair[0] != 'lectrNm' && pair[0] != 'grpNm' && pair[0] != 'lectrJob' && pair[0] != 'coNm') {
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            }
        });

        inputs+="<input type='hidden' name='lectTitle' value='" + $("#lectTitle").val() + "' />";
        inputs+="<input type='hidden' name='lectrNm' value='" + $("#lectrNm").val() + "' />";
        inputs+="<input type='hidden' name='grpNm' value='" + $("#grpNm").val() + "' />";
        inputs+="<input type='hidden' name='lectrJob' value='" + $("#lectrJob").val() + "' />";
        inputs+="<input type='hidden' name='coNm' value='" + $("#coNm").val() + "' />";


        //debugger
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";
        jQuery(sForm).appendTo("body").submit().remove();
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
        colModels.push({label:'수업유형', name:'lectTypeCdNm', index:'lectTypeCdNm', width:45, align:'center', sortable: false});
        colModels.push({label:'수업대상', name:'lectTargtCd', index:'lectTargtCd', width:45, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle' , sortable: false});
        colModels.push({label:'멘토', name:'lectrNm',index:'lectrNm', width:45, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:60, sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', width:80, align:'center', sortable: false});
        colModels.push({label:'노출여부', name:'expsYn', index:'expsYn', width:30, align:'center', sortable: false});
        colModels.push({label:'신청', name:'applCnt', index:'applCnt', width:30, align:'center', sortable: false});
        colModels.push({label:'참관', name:'obsvCnt', index:'obsvCnt', width:30, align:'center', sortable: false});
        colModels.push({label:'상태', name:'lectStatCdNm', index:'lectStatCdNm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting
                $('.jqgrid-overlay').show();
                $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.list.do",
            data : $.param(dataSet.params, true),
            method:"post",
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.id = "<a class='underline' href='view.do?mbrNo='" + item.mbrNo + ">" + item.id + "</a>";
                    item.expsYn = (item.expsYn == 'Y'  ? '노출' : '비노출');
                    var sTm = item.lectStartTime.match(/\d{2}/g);     // 2자리씩 추출 배열0->시 배열1->분
                    var eTm = item.lectEndTime.match(/\d{2}/g);     // 2자리씩 추출 배열0->시 배열1->분
                    var sTime = parseInt(sTm[0],10)*60 + parseInt(sTm[1]); // 분 데이타로 변환
                    var eTime = parseInt(eTm[0],10)*60 + parseInt(eTm[1]); // 분 데이타로 변환
                    var rTime = eTime-sTime;            // 차이 계산
                    item.lectDay = to_date_format(item.lectDay, ".") + "  " + to_time_format(item.lectStartTime, ":") + " (" +  rTime + "분)";
                    item.applCnt = item.applCnt + '/' + item.maxApplCnt;
                    item.obsvCnt = item.obsvCnt + '/' + item.maxObsvCnt;
                    if(item.lectTargtCd == 101534) {
                        item.lectTargtCd = '초'
                    } else if(item.lectTargtCd == 101535) {
                        item.lectTargtCd = '중'
                    } else if(item.lectTargtCd == 101536) {
                        item.lectTargtCd = '고'
                    } else if(item.lectTargtCd == 101537) {
                        item.lectTargtCd = '초중'
                    } else if(item.lectTargtCd == 101538) {
                        item.lectTargtCd = '중고'
                    } else if(item.lectTargtCd == 101539) {
                        item.lectTargtCd = '초고'
                    } else if(item.lectTargtCd == 101540) {
                        item.lectTargtCd = '초중고'
                    } else if(item.lectTargtCd == 101713) {
                        item.lectTargtCd = '기타'
                    }

                    var strDlistUrl = mentor.contextpath + "/lecture/mentor/status/view.do?lectSer=" + item.lectSer + "&lectTims=" + item.lectTims;
                    if(item.lectTitle != null){
                        var lectTitle = "<a href=" + strDlistUrl +" class='underline'>" + item.lectTitle + "</a>";
                        item.lectTitle = lectTitle;
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
                    //$('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건 (※ 진행되는 수업 회차는 <strong id="totalLectCnt">0</strong> 건입니다.)' );
                    $('#totalCnt').text(totalCount);
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    //$('.board-top .total-num').html('총 <strong>0</strong> 건');
                    $('#totalCnt').text(0);
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.schoolPageNavi.setData(dataSet.params);
                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    function searchCnt(){
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/mentor/status/ajax.lectureStatusCnt.do',
            data: $.param(dataSet.params, true),
            method:"post",
            success: function (rtnData) {
                var cntObj = {};
                if (rtnData == null || rtnData.length == 0) {
                    $("#v1").text("0");
                    $("#v2").text("0");
                    $("#v3").text("0");
                    $("#v4").text("0");
                    $("#v5").text("0");
                    $("#v0").text("0");
                } else {
                    var totalCount = 0;
                    var totalLectCnt = 0;
                    totalLectCnt = rtnData[0].totalLectCnt;

                    for (var i = 0; i < rtnData.length; i++) {
                        totalCount += Number(_nvl(rtnData[i].lectStatCnt));
                        cntObj[rtnData[i].lectStatCd] = rtnData[i].lectStatCnt;
                    }

                    //수업완료에서 수업취소 및 수업폐강까지 추가
                    cntObj["101551"] = _nvl(cntObj["101551"],0) + _nvl(cntObj["101553"],0) + _nvl(cntObj["101545"],0);

                    $("#v1").text(_nvl(cntObj["101543"], "0"));
                    $("#v2").text(_nvl(cntObj["101548"], "0"));
                    $("#v3").text(_nvl(cntObj["101550"], "0"));
                    $("#v4").text(_nvl(cntObj["101547"], "0"));
                    $("#v5").text(_nvl(cntObj["101551"], "0"));
                    $("#v0").text(totalCount);

                    $('#totalLectCnt').text(totalLectCnt);
                }
            }
        });
    }

</script>