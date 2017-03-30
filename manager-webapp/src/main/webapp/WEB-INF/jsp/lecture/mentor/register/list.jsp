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
        <h2>수업등록관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업개설관리</li>
            <li>수업등록관리</li>
        </ul>
    </div>
    <div class="search-area leeson-state-srch">
        <ul>
            <li class="condition-big">
                <p><strong>수업유형</strong></p>
                <ul class="detail-condition" id="rdoLectTypeCds">
                    <li>
                        <label><input type="radio" name="lectType" value="" checked='checked' /> 전체</label>
                    </li>
                    <c:forEach items="${lectType}" var="info">
                    <li>
                        <label><input type="radio" name="lectType" value="${info.cd}" /> ${info.cdNm}</label>
                    </li>
                    </c:forEach>
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
            orderBy: 'lectDay',
            lectType: $(':radio[name="lectType"]:checked').val(),
            lectStatCd: '',
            schoolGrd: $("#lectTargtCd").val(),
            schoolEtcGrd: $('input[name=schoolEtcGrd]:checked').val(),
            lectrNm: $("#lectrNm").val(),
            lectrJob: $("#lectrJob").val(),
            lectTitle: $("#lectTitle").val(),
            grpNm: $("#grpNm").val(),
            coNm: $("#coNm").val()
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

        loadData(1);

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
        colModels.push({label:'수업유형', name:'lectTypeCdNm', index:'lectTypeCdNm', width:25, align:'center', sortable: false});
        colModels.push({label:'수업대상', name:'lectTargtCd', index:'lectTargtCd', width:25, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle' , sortable: false});
        colModels.push({label:'멘토', name:'lectrNm',index:'lectrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'lectrJobNm',index:'lectrJobNm', width:40, sortable: false});
        colModels.push({label:'배정사업', name:'grpNm', index:'grpNm', width:80, align:'center', sortable: false});
        colModels.push({label:'교육수행기관', name:'coNm', index:'coNm', width:80, align:'center', sortable: false});
        colModels.push({label:'수업차수', name:'lectTimsCnt', index:'lectTimsCnt', width:25, align:'center', sortable: false});
        colModels.push({label:'최종수정일', name:'chgDtm', index:'chgDtm', width:35, align:'center', sortable: false});


        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting
                $('.jqgrid-overlay').show();
                $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/register/ajax.list.do",
            data : $.param(dataSet.params, true),
            method:"post",
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
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

                    var strDlistUrl = mentor.contextpath + "/lecture/mentor/register/view.do?lectSer=" + item.lectSer;
                    if(item.lectTitle != null){
                        var lectTitle = "<a href=" + strDlistUrl +" class='underline'>" + item.lectTitle + "</a>";
                        item.lectTitle = lectTitle;
                    }
                    item.chgDtm = new Date(item.chgDtm).format('yyyy.MM.dd');

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