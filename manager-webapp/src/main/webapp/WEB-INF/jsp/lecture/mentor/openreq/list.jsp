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
        <h2>수업개설신청</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업개설관리</li>
            <li>수업개설신청</li>
        </ul>
    </div>
    <div class="search-area leeson-state-srch">
        <ul>
            <li class="condition-big lesson-name">
                <p><strong>제목</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="lectTitle" id="lectTitle" class="text" />
                    </li>
                 </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>승인상태</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="authStatCd" value="" checked='checked' /> 전체</label>
                        <c:forEach items="${authType}" var="info">
                            <label><input type="radio" name="authStatCd" value="${info.cd}" /> ${info.cdNm}</label>
                        </c:forEach>

                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big lesson-name">
                <p><strong>멘토</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="targtMbrNm" id="targtMbrNm" class="text" />
                    </li>
                 </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>오픈유무</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="openYn" value="" checked='checked' /> 전체</label>
                        <label><input type="radio" name="openYn" value="Y" /> 오픈중</label>
                        <label><input type="radio" name="openYn" value="N" /> 오픈안함</label>
                    </li>
                </ul>
            </li>
        </ul>
		<ul>
            <li class="condition-big lesson-name">
                <p><strong>직업명</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="targtJobNm" id="targtJobNm" class="text" />
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
			<li class="condition-big">
				<p><strong>등록기간</strong></p>
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
            searchStDate: $("#searchStDate").val(),
            searchEndDate: $("#searchEndDate").val(),
            authStatCd: $(':radio[name="authStatCd"]:checked').val(),
            openYn: $(':radio[name="openYn"]:checked').val(),
            lectTitle: $("#lectTitle").val(),
            targtMbrNm: $("#targtMbrNm").val(),
            targtJobNm: $("#targtJobNm").val()
        }
    };

    var searchFlag = 'load';

    $(document).ready(function () {

        enterFunc($("#lectTitle"), goSearch);
        enterFunc($("#targtMbrNm"), goSearch);
        enterFunc($("#targtJobNm"), goSearch);


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

        dataSet.params.searchStDate= $("#searchStDate").val();
        dataSet.params.searchEndDate= $("#searchEndDate").val();
        dataSet.params.authStatCd= $(':radio[name="authStatCd"]:checked').val();
        dataSet.params.openYn= $(':radio[name="openYn"]:checked').val();
        dataSet.params.lectTitle= $("#lectTitle").val();
        dataSet.params.targtMbrNm= $("#targtMbrNm").val();
        dataSet.params.targtJobNm= $("#targtJobNm").val();


        loadData();
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
        colModels.push({label:'제목', name:'lectTitle', index:'lectTitle' , sortable: false});
        colModels.push({label:'수업계획서', name:'fileBtn', index:'fileBtn', width:25, align:'center', sortable: false});
        colModels.push({label:'등록자(멘토)', name:'targtMbrNm', index:'targtMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'targtJobNm', index:'targtJobNm' , width:80, sortable: false});
        colModels.push({label:'등록일', name:'reqDtm', index:'reqDtm', width:25, align:'center', sortable: false});
        colModels.push({label:'승인상태', name:'authStatCdNm', index:'authStatCdNm', width:25, align:'center', sortable: false});
        colModels.push({label:'오픈유무', name:'openYn', index:'openYn', width:25, align:'center', sortable: false});
        colModels.push({label:'조회수', name:'vcnt', index:'vcnt', width:25, align:'center', sortable: false});


        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting
        $('.jqgrid-overlay').show();
        $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/openreq/ajax.list.do",
            data : $.param(dataSet.params, true),
            method:"post",
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;


                    var strViewtUrl = mentor.contextpath + "/lecture/mentor/openreq/view.do?reqSer=" + item.reqSer;
                    if(item.lectTitle != null){
                        var lectTitle = "<a href=" + strViewtUrl +" class='underline'>" + item.lectTitle + "</a>";
                        item.lectTitle = lectTitle;
                    }

                    var strFileDownUrl = mentor.contextpath + "/fileDown.do?fileSer=" + item.fileSer;
                    item.fileBtn = "<a href=" + strFileDownUrl +"><img src='${pageContext.request.contextPath}/images/bg_allfile_down.png'/></a>";

                    item.reqDtm = new Date(item.reqDtm).format('yyyy.MM.dd');
                    item.openYn = (item.openYn == 'Y'  ? '오픈' : '오픈안함');

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