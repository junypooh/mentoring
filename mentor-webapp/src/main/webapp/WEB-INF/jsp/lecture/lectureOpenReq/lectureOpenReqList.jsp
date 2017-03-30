<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listInfo">
						<tr>
							<td>\${rn}</td>
							<td>\${authStatCdNm}</td>
							<td>{{if openYn == 'Y'}}오픈{{else}}미오픈{{/if}}</td>
							<td class="al-left"><a href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqView.do?reqSer=\${reqSer}">\${lectTitle}</a></td>
							<td>{{if fileSer != null}}<a href="${pageContext.request.contextPath}/fileDown.do?fileSer=\${fileSer}" class="all-file-down"></a>{{/if}}</td>
							<td>\${getReqDtm(reqDtm)}
							</td>
							<td>\${getReqDtm(procDtm)}</td>
						</tr>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>

<script type="text/javascript">

    function getReqDtm(reqDtm){
        return reqDtm = new Date(reqDtm).format('yyyy.MM.dd');
    }


var dataSet = {
    params: {
        recordCountPerPage: 10,
        totalRecordCount: 0,
        currentPageNo: 1,
        searchStDate:"",
        searchEndDate:"",
        ${_csrf.parameterName}: "${_csrf.token}"
    },
    data: {}
};
mentor.mentorDataSet = dataSet;
</script>

<div id="container">
    <div class="location">
		<a href="#" class="home">메인으로 이동</a>
		<span>수업관리</span>
		<span>수업개설신청</span>
	</div>
	<div class="content">
		<h2>수업개설신청</h2>
		<p class="tit-desc-txt">수업계획서를 작성하여 수업개설을 신청하여 주시면 확인 후 수업을 개설합니다. </p>
		<div class="cont type3">
			<div class="calculate-management lists">
				<div class="search-box">
					<dl>
						<dt>기간</dt>
						<dd>
							<span class="calendar">
                                <input type="text" class="inp-style1" style="width:110px;" id="searchStDate"/> ~
                                <input type="text" class="inp-style1" style="width:110px;" id="searchEndDate"/>
							</span>
                             <span class="btn">
                                 <a href="javascript:void(0);" class="btn-type1" id="aLinkWeek">1주일</a>
                                 <a href="javascript:void(0);" class="btn-type1" id="aLinkMonth">1개월</a>
                                 <a href="javascript:void(0);" class="btn-type1" id="aLinkThreeMonth">3개월</a>
                             </span>
						</dd>
					</dl>
					<div class="btn-area">
						<a href="#" class="btn-search" onClick="fn_search(1)"><span>검색</span></a>
					</div>
				</div>
			</div>
			<div class="lesson-task">
				<span class="list-num">
                    <select id="perPage" style="width:70px;">
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="30">30</option>
                    </select>
                </span>
            </div>
            <div class="result-info">
                <p class="search-result"></p>
            </div>
            <div class="board-type1 schedule">
                <table>
					<caption>수업개설신청 - 번호, 상태, 오픈여부, 제목, 수업계획서, 등록일, 승인/반려일</caption>
					<colgroup>
						<col style="width:65px;">
						<col style="width:92px;">
						<col style="width:92px;">
						<col>
						<col style="width:85px;">
						<col style="width:100px;">
						<col style="width:100px;">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">상태</th>
							<th scope="col">오픈여부</th>
							<th scope="col">제목</th>
							<th scope="col">수업계획서</th>
							<th scope="col">등록일</th>
							<th scope="col">승인/반려일</th>
						</tr>
					</thead>
					<tbody id="lectOpenReqList">

					</tbody>
				</table>
			</div>
			<div class="paging-btn">
				<span class="l-btn"><a href="${pageContext.request.contextPath}/fileDown.do?fileSer=10003123" class="btn-type5">수업계획서 다운로드</a></span>
				<div class="paging" id="divPaging"></div>
				<span class="r-btn"><a href="#" class="btn-type5" onClick="fnRegisterForm()">수업개설신청</a></span>
			</div>
		</div>
	</div>
	<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>


<script type="text/jsx;harmony=true">
mentor.PageNavi = React.render(
  <PageNavi url={mentor.contextpath + "/lecture/lectureOpenReq/ajax.list.do"} pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} contextPath={'${pageContext.request.contextPath}'}/>,
  document.getElementById('divPaging')
);
</script>

<script type="text/javascript">
    $(document).ready(function () {

        //달려 초기화
        _applyDatepicker($("#searchStDate"));
        _applyDatepicker($("#searchEndDate"));

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );
            $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");
        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
            $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");
        });

        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");


        //1주일 버튼 클릭 event
        $("#aLinkWeek").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
            $("#searchStDate").val(sStartDate);
        });

        //1개월 버튼 클릭 event
        $("#aLinkMonth").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
            $("#searchStDate").val(sStartDate);
        });

        //3개월 버튼 클릭 event
        $("#aLinkThreeMonth").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 3)).format("yyyy-MM-dd");
            $("#searchStDate").val(sStartDate);
        });

        fn_search(1);

    });
</script>

<script type="text/javascript">
    var isFirstSearch = true;

    //검색 버튼 클릭 event
    $("#btnSearch").click(function () {
        mentor.PageNavi._pageFunc(1);
    });

    var fn_search = function(pageNum){
        dataSet.params.currentPageNo = pageNum;

        dataSet.params.searchStDate = $("#searchStDate").val().replace(/-/gi, "");
        dataSet.params.searchEndDate = $("#searchEndDate").val().replace(/-/gi, "");


        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureOpenReq/ajax.list.do',
            data : $.param(dataSet.params, true),
            success: function(rtnData) {

                dataSet.data = rtnData;
                if(rtnData != null && rtnData.length > 0){
                    dataSet.params.totalRecordCount = rtnData[0].totalRecordCount;
                }else{
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                $('#lectOpenReqList').empty();
                mentor.PageNavi.setData(dataSet.params);
                if(rtnData.length >0){
                    $("#divPaging").show();
                    $('#listInfo').tmpl(dataSet.data).appendTo('#lectOpenReqList');
                }else{
                    $('#lectOpenReqList').append(
                            '<tr><td colspan="7" class="board-no-data">수업 개설신청을 추가하세요.</td></tr>'
                    );
                }
            }
        });

    }

    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }

    $('#perPage').change(function(){
        dataSet.params.recordCountPerPage = $('#perPage').val();
        fn_search(1);
    });

    function fnRegisterForm(){

        location.href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqInsert.do";
    }

</script>