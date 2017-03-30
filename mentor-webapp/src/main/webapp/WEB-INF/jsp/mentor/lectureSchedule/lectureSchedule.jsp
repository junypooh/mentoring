<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listInfo">
    <tr>
        <td>\${fn_getNo(rn)}</td>
        <td>\${to_date_format(lectDay, ".")}</td>
        <td>\${to_time_format(lectStartTime, ":")} ~ \${to_time_format(lectEndTime, ":")}<br/> (\${to_time_space(lectStartTime,lectEndTime)}분)</td>
        <td>\${lectrNm}</td>
        <td>\${jobNm}</td>
        <td><a href="javascript:void(0)" onClick="fn_goLectureDetailView('\${lectSer}','\${lectTims}','\${schdSeq}');">\${lectTypeCdNm}</a></td>
        <td class="al-left"><a href="javascript:void(0)" onClick="fn_goLectureDetailView('\${lectSer}','\${lectTims}','\${schdSeq}');">\${lectTitle}</a></td>
        <td><a href="javascript:void(0)" onclick="fn_openLayerPopupApplDevice('\${lectSer}','\${lectTims}','\${schdSeq}');">\${applCnt}</a></td>
        <td><a href="javascript:void(0)" onclick="fn_openLayerPopupObsvDevice('\${lectSer}','\${lectTims}','\${schdSeq}');">\${obsvCnt}</a></td>
        <td><a href="javascript:void(0)" onClick="fn_goLectureDetailView('\${lectSer}','\${lectTims}','\${schdSeq}');">\${lectStatCdNm}</a></td>
    </tr>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="noData">
    <tr><td className="board-no-data" colSpan="9">등록된 수업이 없습니다.</td></tr>
</script>
<%-- Template ================================================================================ --%>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            searchStDate:"",
            searchEndDate:"",
            lectStatCd: "",
            category:"",
            keyword: "",
            ${_csrf.parameterName}: "${_csrf.token}"
        },
        data: {}
    };
    mentor.mentorDataSet = dataSet;
</script>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>활동이력</span>
        <span>수업스케줄</span>
    </div>
    <div class="content">
        <h2>수업스케줄</h2>

        <div class="cont">
            <div class="calculate-management">
                <div class="search-box">
                    <dl>
                        <dt>기간</dt>
                        <dd>
                            <span class="calendar">
                                <input type="text" class="inp-style1" style="width:110px;" id="searchStDate"/> ~
                                <%--<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_calendar.png" alt="달력"/></a> ~--%>
                                <input type="text" class="inp-style1" style="width:110px;" id="searchEndDate"/>
                                <%--<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_calendar.png" alt="달력"/></a>--%>
                            </span>
                            <span class="btn">
                                <em>상태</em>
                                <span>
                                    <select name="" style="width:108px;" id="searchLectStatCd">
                                        <option value="">전체</option>
                                        <c:forEach items="${code101541}" var="item">
                                            <option value="${item.cd}">${item.cdNm}</option>
                                        </c:forEach>
                                    </select>
                                </span>
                            </span>
                        </dd>
                        <dt>키워드</dt>
                        <dd>
                            <select name="" style="width:108px;" id="category">
                                <option value="">전체</option>
                                <c:forEach items="${code101512}" var="item">
                                    <option value="${item.cd}">${item.cdNm}</option>
                                </c:forEach>
                            </select>
                            <input type="text" class="inp-style1" style="width:505px;" name="" id="keyword"/>
                        </dd>
                    </dl>
                    <div class="btn-area">
                        <a href="#" class="btn-search" id="aSearch"><span>검색</span></a>
                    </div>
                </div>
                <div class="board-type1 schedule">
                    <span class="excel-file-down"><a href="#" id="aExcelDown">엑셀파일 다운로드</a></span>
                    <table>
                        <caption>정산관리 - 번호, 수업일, 시간, 멘토명, 직업명, 유형, 수업명, 신청디바이스, 상태</caption>
                        <colgroup>
                            <col style="width:65px;"/>
                            <col style="width:92px;"/>
                            <col style="width:112px;"/>
                            <col style="width:83px;"/>
                            <col style="width:102px;"/>
                            <col style="width:64px;"/>
                            <col style="width:150px;"/>
                            <col style="width:67px;"/>
                            <col style="width:67px;"/>
                            <col/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">수업일</th>
                            <th scope="col">시간</th>
                            <th scope="col">멘토명</th>
                            <th scope="col">직업명</th>
                            <th scope="col">유형</th>
                            <th scope="col">수업명</th>
                            <th scope="col">신청</th>
                            <th scope="col">참관</th>
                            <th scope="col">상태</th>
                        </tr>
                        </thead>
                        <tbody id="listBody">
                        <%--<tr>--%>
                            <%--<td>100</td>--%>
                            <%--<td>2015.08.28</td>--%>
                            <%--<td>10:00 ~ 11:00</td>--%>
                            <%--<td><a href="#">홍길동</a></td>--%>
                            <%--<td>노무사</td>--%>
                            <%--<td><a href="#">연강</a></td>--%>
                            <%--<td class="al-left"><a href="#">세상을 평정한 1인 미디어세상을 평정한 1인 미디어</a></td>--%>
                            <%--<td><a href="#layer1" class="layer-open">5</a></td>--%>
                            <%--<td><a href="#">수강모집</a></td>--%>
                        <%--</tr>--%>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="paging" id="divPaging"></div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동"/></a></div>
</div>

<a href="#layer1" class="layer-open" id="layerOpen"></a>

<!-- layerpopup -->
<div id="layerPopupDiv">

</div>

<script type="text/jsx;harmony=true">
mentor.PageNavi = React.render(
    <PageNavi url={mentor.contextpath + "mentor/lectureSchedule/ajax.listLectureSchedule.do"} pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} contextPath={'${pageContext.request.contextPath}'}/>,
    document.getElementById('divPaging'), function(){
    fn_search(1);
    }
);
</script>

<script type="text/javascript">
    $(document).ready(function () {

        //달려 초기화
        _applyDatepicker($("#searchStDate"));
        _applyDatepicker($("#searchEndDate"));

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

    });
</script>

<script type="text/javascript">
    var isFirstSearch = true;

    //검색 버튼 클릭 event
    $("#aSearch").click(function () {
        dataSet.params.searchStDate = $("#searchStDate").val().replace(/-/gi, "");
        dataSet.params.searchEndDate = $("#searchEndDate").val().replace(/-/gi, "");
        dataSet.params.category = $("#category option:selected").val();
        dataSet.params.keyword = $("#keyword").val();
        dataSet.params.lectStatCd = $("#searchLectStatCd option:selected").val();

        mentor.PageNavi._pageFunc(1);
        fn_search(1,"${param.reqSer}");
    });

    var fn_search = function(pageNum){
        dataSet.params.currentPageNo = pageNum;
        $.ajax({
            url: "${pageContext.request.contextPath}/mentor/lectureSchedule/ajax.listLectureSchedule.do",
            data : $.param(dataSet.params, true),
            success: function(rtnData) {

                dataSet.data = rtnData;

                if(rtnData != null && rtnData.length > 0){
                    dataSet.params.totalRecordCount = rtnData[0].totalRecordCount;

                    $("#listBody").empty();
                    $("#listInfo").tmpl(dataSet.data).appendTo("#listBody");
                }else{
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;

                    $("#listBody").empty();
                    $("#noData").tmpl().appendTo("#listBody");
                }

                mentor.PageNavi.setData(dataSet.params);

                //$('.layer-open').layerOpen();
                isFirstSearch = false;
            }
        });
    }

    function fn_openLayerPopupApplDevice(sLectSer, sLectTims, sSchdSeq){
        //신청디바이스 조회 팝업
        $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupApplDevice.do?lectSer="+sLectSer+"&lectTims="+sLectTims+"&schdSeq="+sSchdSeq, function(){$("#layerOpen").trigger("click");} );
    }

    function fn_openLayerPopupObsvDevice(sLectSer, sLectTims, sSchdSeq){
        //신청디바이스 조회 팝업
        $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupObsvDevice.do?lectSer="+sLectSer+"&lectTims="+sLectTims+"&schdSeq="+sSchdSeq, function(){$("#layerOpen").trigger("click");} );

    }

    //엑셀다운로드 버튼 클릭
    $("#aExcelDown").click(function(e){
        e.preventDefault();

        if(isFirstSearch){
            alert("엑셀파일 다운로드를 하시기 전에 검색을 해주십시오.");
            return false;
        }

        var url = "${pageContext.request.contextPath}/mentor/lectureSchedule/ajax.excelDownListLectureSchedule.do";
        var paramData = $.param(dataSet.params, true);
        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
        });

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";

        jQuery(sForm).appendTo("body").submit().remove();
    });

    //수업상세화면이동
    function fn_goLectureDetailView(sLectSer, sLectTims, sSchdSeq){
        var url = mentor.contextpath + "/lecture/lectureState/lectureDetailView.do?lectSer="+sLectSer+"&lectTims="+sLectTims+"&schdSeq="+sSchdSeq;
        window.open(url, '_blank');
    }

    //멘토상세화면이동
    function fn_goMentorView(sLectrMbrNo){
        var url = mentor.contextpath + "/mentor/belongMentor/belongMentorShow.do?mbrNo="+sLectrMbrNo;
        window.open(url, '_blank');
    }

    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }
    function to_time_space(start, end){
        var startTime = to_time_format(start, ":");
        var startDate = new Date("8/24/2009 " + startTime);
        var endTime = to_time_format(end, ":");
        var endDate  = new Date("8/24/2009 " + endTime);
        var tmp = (endDate.getTime() - startDate.getTime()) / 60000;
        return tmp;
    }
</script>