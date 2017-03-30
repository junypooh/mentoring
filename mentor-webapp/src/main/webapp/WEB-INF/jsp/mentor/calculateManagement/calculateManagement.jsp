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
        <td>\${lectureCnt}</td>
        <td><a href="javascript:void(0)" onClick="fn_goLectureDetailView('\${lectSer}','\${lectTims}','\${schdSeq}');">\${lectTypeCdNm}</a></td>
        <td class="al-left"><a href="#" onClick="fn_goLectureDetailView('\${lectSer}','\${lectTims}','\${schdSeq}');">\${lectTitle}</a></td>
        <td><a href="javascript:void(0)" onclick="fn_openLayerPopupApplDevice('\${lectSer}','\${lectTims}','\${schdSeq}');">\${applCnt}</a></td>
        <td><a href="javascript:void(0)" onclick="fn_openLayerPopupObsvDevice('\${lectSer}','\${lectTims}','\${schdSeq}');">\${obsvCnt}</a></td>
    </tr>
</script>
<script type="text/html" id="listInfo4Sms">
    <tr>
        <td>\${fn_getNo(rn)}</td>
        <td>\${sendDate}</td>
        <td>\${sendDetail}</td>
        <td>\${sender}</td>
        <td class="al-center">\${price}원</td>
    </tr>
</script>
<script type="text/html" id="emptyListInfo4Sms">
    <tr>
        <td colspan=5>전송 내역이 존재하지 않습니다.</td>
    </tr>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    <span>총 수업 참여 수<em>\${totalLectDay}</em></span>
    <span>총 수업 횟수<em>\${totalLectCnt}</em></span>
</script>
<%-- Template ================================================================================ --%>

<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo4Sms">
    <div>
    <span class="num">총 전송 횟수(회) <em>\${totalSendCnt}회</em></span>
    <span class="won">총 금액(원) <em>\${totalSendPrice}원</em></span>
    </div>
    <p>※ 매월 1일 부터 말일까지의 누적 사용량 표시 </p>
</script>
<%-- Template ================================================================================ --%>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 5,
            totalRecordCount: 0,
            currentPageNo: 1,
            searchStDate:"",
            searchEndDate:"",
            lectType: "",
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
        <span>나의수업이력</span>
    </div>
    <div class="content">
        <h2>나의수업내역</h2>

        <div class="cont">
            <div class="tab-action">
                <ul class="sub-tab tab02">
                    <li class="active"><a href="#">수업 정산</a></li>
                    <li><a href="#">문자 정산</a></li>
                </ul>
                <div class="tab-action-cont">
                    <!-- 수업정산 -->
                    <div class="tab-cont active">
                        <div class="calculate-management">
                            <div class="search-box business">
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
                                            <a href="javascript:void(0)" class="btn-type1" id="aLinkWeek">1주일</a>
                                            <a href="javascript:void(0)" class="btn-type1" id="aLinkMonth">1개월</a>
                                            <a href="javascript:void(0)" class="btn-type1" id="aLinkThreeMonth">3개월</a>
                                        </span>
                                    </dd>
                                    <dt>키워드</dt>
                                    <dd>
                                        <select style="width:108px;" id="category">
                                            <option value="">전체</option>
                                            <c:forEach items="${code101512}" var="item">
                                                <c:if test="${item.cd ne '101651'}">
                                                    <option value="${item.cd}">${item.cdNm}</option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                        <input type="text" class="inp-style1" style="width:380px;" id="keyword"/>
                                        <select style="width:108px;" id="searchLectTypeCd">
                                            <option value="">유형</option>
                                            <c:forEach items="${code101528}" var="item">
                                                <option value="${item.cd}">${item.cdNm}</option>
                                            </c:forEach>
                                        </select>
                                    </dd>
                                </dl>
                                <div class="btn-area">
                                    <a href="javascript:void(0)" class="btn-search" id="aSearch"><span>검색</span></a>
                                </div>
                                <div class="total-lesson">
                                    <span>총 수업 참여 수<em>0</em></span>
                                    <span>총 수업 횟수<em>0</em></span>
                                </div>
                            </div>
                            <p class="lesson-participate">※ 수업 참여 수: 수업 일수, 수업 횟수: 수업 제공 수를 의미함</p>

                            <div class="board-type1 schedule">
                                <span class="excel-file-down"><a href="#" id="aExcelDown">엑셀파일 다운로드</a></span>
                                <table>
                                    <caption>정산관리 - 번호, 수업일, 시간, 수업횟수, 멘토명, 유형, 수업명, 신청디바이스</caption>
                                    <colgroup>
                                        <col style="width:65px;"/>
                                        <col style="width:93px;"/>
                                        <col style="width:115px;"/>
                                        <col style="width:93px;"/>
                                        <col style="width:54px;"/>
                                        <col/>
                                        <col style="width:60px;"/>
                                        <col style="width:60px;"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th scope="col">번호</th>
                                        <th scope="col">수업일</th>
                                        <th scope="col">시간</th>
                                        <th scope="col">수업횟수</th>
                                        <th scope="col">유형</th>
                                        <th scope="col">수업명</th>
                                        <th scope="col">신청</th>
                                        <th scope="col">참관</th>
                                    </tr>
                                    </thead>
                                    <tbody id="listBody">
                                        <%--<tr>--%>
                                            <%--<td>100</td>--%>
                                            <%--<td>2015.08.28</td>--%>
                                            <%--<td>10:00 ~ 11:00</td>--%>
                                            <%--<td>2</td>--%>
                                            <%--<td class="al-left"><a href="#">홍길동</a></td>--%>
                                            <%--<td><a href="#">연강</a></td>--%>
                                            <%--<td class="al-left"><a href="#">세상을 평정한 1인 미디어 크리에이터세상을 평정한 1인 미디어 크리에이터</a></td>--%>
                                            <%--<td><a href="#layer1" class="layer-open">5</a></td>--%>
                                        <%--</tr>--%>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="paging" id="divPaging"></div>

					</div>
					<div class="tab-cont">
                        <div class="calculate-management">
                            <div class="total-send">
                                <div>
                                    <span class="num">총 전송 횟수(회) <em>0회</em></span>
                                    <span class="won">총 금액(원) <em>0원</em></span>
                                </div>
                                <p>※ 매월 1일 부터 말일까지의 누적 사용량 표시 </p>
                            </div>

                            <div class="search-box business">
                                <dl>
                                    <dt>기간</dt>
                                    <dd>
                                        <span class="calendar">
                                            <input type="text" class="inp-style1" style="width:110px;" name="searchStartDate4Sms" id="searchStartDate4Sms" /> ~
                                            <input type="text" class="inp-style1" style="width:110px;" name="searchEndDate4Sms" id="searchEndDate4Sms" />
                                        </span>
                                        <span class="btn">
                                            <a href="javascript:void(0)" class="btn-type1" id="aLinkWeek4Sms">1주일</a>
                                            <a href="javascript:void(0)" class="btn-type1" id="aLinkMonth4Sms">1개월</a>
                                            <a href="javascript:void(0)" class="btn-type1" id="aLinkThreeMonth4Sms">3개월</a>
                                        </span>
                                    </dd>
                                </dl>
                                <div class="btn-area">
                                    <a href="#" class="btn-search" id="smsSearch"><span>검색</span></a>
                                </div>
                            </div>
                            <span class="list-number">
                                <select name="cntPerPage" style="width:70px;" id="cntPerPage">
                                    <option value="5" selected>5</option>
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                </select>
                            </span>
                            <div class="board-type1 schedule">

                                <span class="excel-file-down" style="margin-right: 75px;">
                                    <a href="javascript:void(0)" id="bExcelDown">엑셀파일 다운로드</a>
                                </span>
                                <table>
                                    <caption>문자정산 - 번호, 전송일시, 내역, 발송자, 금액(원)</caption>
                                    <colgroup>
                                        <col style="width:10%;" />
                                        <col style="width:20%;" />
                                        <col style="width:20%;" />
                                        <col style="width:20%;" />
                                        <col />
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th scope="col">번호</th>
                                            <th scope="col">전송일시</th>
                                            <th scope="col">내역</th>
                                            <th scope="col">발송자</th>
                                            <th scope="col">금액(원)</th>
                                        </tr>
                                    </thead>
                                    <tbody id="listBody4Sms">
                                        <tr>
                                            <td colspan=5>전송 내역이 존재하지 않습니다.</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="paging" id="divPaging4Sms"></div>
                    </div>
				</div>
			</div>
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
    <PageNavi url={mentor.contextpath + "calculateManagement/ajax.listCalculateLectureByMentor.do"} pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={5} contextPath={'${pageContext.request.contextPath}'}/>,
    document.getElementById('divPaging')
);

mentor.smsPageNavi = React.render(
    <PageNavi url={mentor.contextpath + "calculateManagement/ajax.listCalculateSmsSendResult.do"} pageFunc={fn_search4Sms} totalRecordCount={0} currentPageNo={1} recordCountPerPage={5} contextPath={'${pageContext.request.contextPath}'}/>,
    document.getElementById('divPaging4Sms')
);
</script>

<script type="text/javascript">
    $(document).ready(function () {

       // tabAction_orig();

        //신청디바이스 조회 팝업
        //$("#layerPopupDiv").load("${pageContext.request.contextPath}/calculateManagement/layerPopupApplDevice.do");

        //달려 초기화
        _applyDatepicker($("#searchStDate"));
        _applyDatepicker($("#searchEndDate"));

        _applyDatepicker($('#searchStartDate4Sms'));
        _applyDatepicker($('#searchEndDate4Sms'));

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

        $('#searchStartDate4Sms').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate4Sms").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndDate4Sms').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStartDate4Sms").datepicker( "option", "maxDate", selectedDate );
        });

        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");

        // 디폴트 날짜 셋팅(월초 ~ 현재)
        var tCurrentDate = new Date()
        var tEndDate = tCurrentDate.format("yyyy-MM-dd");
        $("#searchEndDate").val(tEndDate);
        $("#searchEndDate4Sms").val(tEndDate);
        var tStartDate = new Date(tCurrentDate.setDate(1)).format("yyyy-MM-dd");
        $("#searchStDate").val(tStartDate);
        $("#searchStartDate4Sms").val(tStartDate);

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


        //1주일 버튼 클릭 event
        $("#aLinkWeek4Sms").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate4Sms").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
            $("#searchStartDate4Sms").val(sStartDate);
        });

        //1개월 버튼 클릭 event
        $("#aLinkMonth4Sms").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate4Sms").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
            $("#searchStartDate4Sms").val(sStartDate);
        });

        //3개월 버튼 클릭 event
        $("#aLinkThreeMonth4Sms").click(function(){
            var dCurrentDate = new Date()
            var sEndDate = dCurrentDate.format("yyyy-MM-dd");
            $("#searchEndDate4Sms").val(sEndDate);
            var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 3)).format("yyyy-MM-dd");
            $("#searchStartDate4Sms").val(sStartDate);
        });

        $('#cntPerPage').change(
            function(){
                dataSet.params.recordCountPerPage = $(this).val();
                fn_search4Sms(dataSet.params.currentPageNo);
            }
        );

        autoSearch();
    });
</script>

<script type="text/javascript">
    var isFirstSearch = true;

     var summaryData = {
                        'totalSendCnt': 0,
                        'totalSendPrice': 0
                    };

    //검색 버튼 클릭 event
    $("#aSearch").click(function () {
        //dataSet.params.searchStDate = $("#searchStDate").val().replace(/-/gi, "");
        //dataSet.params.searchEndDate = $("#searchEndDate").val().replace(/-/gi, "");
        //dataSet.params.category = $("#category option:selected").val();
        //dataSet.params.keyword = $("#keyword").val();
        //dataSet.params.lectType = $("#searchLectTypeCd option:selected").val();

        mentor.PageNavi._pageFunc(1);
    });

    //검색 버튼 클릭 event
    $("#smsSearch").click(function (e) {
        e.preventDefault();
        //dataSet.params.searchStDate = $("#searchStartDate4Sms").val().replace(/-/gi, "");
        //dataSet.params.searchEndDate = $("#searchEndDate4Sms").val().replace(/-/gi, "");

        mentor.smsPageNavi._pageFunc(1);
    });

    // 자동 검색
    function autoSearch() {
        $(".sub-tab").find('li').each(function(idx){
            if($(this).hasClass('active')) {
                if(idx == 0) {
                    fn_search(1);
                } else {
                    fn_search4Sms(1);
                }
            }
        });
    }

    var fn_search = function(pageNum){
        dataSet.params.currentPageNo = pageNum;

        dataSet.params.searchStDate = $("#searchStDate").val().replace(/-/gi, "");
        dataSet.params.searchEndDate = $("#searchEndDate").val().replace(/-/gi, "");
        dataSet.params.category = $("#category option:selected").val();
        dataSet.params.keyword = $("#keyword").val();
        dataSet.params.lectType = $("#searchLectTypeCd option:selected").val();

        $.ajax({
            url: "${pageContext.request.contextPath}/mentor/calculateManagement/ajax.listCalculateLectureByMentor.do",
            data : $.param(dataSet.params, true),
            success: function(rtnData) {

                $(".total-lesson").empty();
                $("#totalInfo").tmpl(rtnData).appendTo(".total-lesson");

                dataSet.data = rtnData.lectureInfomationDTOList;

                if(rtnData.lectureInfomationDTOList != null && rtnData.lectureInfomationDTOList.length > 0){
                    dataSet.params.totalRecordCount = rtnData.lectureInfomationDTOList[0].totalRecordCount;
                }else{
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                mentor.PageNavi.setData(dataSet.params);

                $("#listBody").empty();
                $("#listInfo").tmpl(dataSet.data).appendTo("#listBody");

                //$('.layer-open').layerOpen();
                isFirstSearch = false;
            }
        });
    }

    var fn_search4Sms = function(pageNum){
        dataSet.params.currentPageNo = pageNum;

        dataSet.params.searchStDate = $("#searchStartDate4Sms").val().replace(/-/gi, "");
        dataSet.params.searchEndDate = $("#searchEndDate4Sms").val().replace(/-/gi, "");


        $.ajax({
            url: "${pageContext.request.contextPath}/mentor/calculateManagement/ajax.listCalculateSmsSendResult.do",
            data : $.param(dataSet.params, true),
            success: function(rtnData) {

                $(".total-send").empty();




                dataSet.data = rtnData;

                $("#listBody4Sms").empty();

                if(dataSet.data != null && dataSet.data.length > 0){
                    dataSet.params.totalRecordCount = dataSet.data[0].totalRecordCount;
                    $("#listInfo4Sms").tmpl(dataSet.data).appendTo("#listBody4Sms");
                    summaryData.totalSendCnt = dataSet.data[0].totalRecordCount;
                    summaryData.totalSendPrice = dataSet.data[0].totalRecordCount * 30;
                    $("#totalInfo4Sms").tmpl(summaryData).appendTo(".total-send");
                }else{
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                    summaryData.totalSendCnt = 0;
                    summaryData.totalSendPrice = 0;
                    $("#totalInfo4Sms").tmpl(summaryData).appendTo(".total-send");
                    $("#emptyListInfo4Sms").tmpl(dataSet.data).appendTo("#listBody4Sms");
                }

                mentor.smsPageNavi.setData(dataSet.params);



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



    $("#keyword").keydown(function(e){
        if (e.which == 13) {/* 13 == enter key@ascii */
            $("#aSearch").click();
        }
    });

    //엑셀다운로드 버튼 클릭
    $("#aExcelDown").click(function(e){
        e.preventDefault();

        if(isFirstSearch){
            alert("엑셀파일 다운로드를 하시기 전에 검색을 해주십시오.");
            return false;
        }

        var url = "${pageContext.request.contextPath}/calculateManagement/ajax.excelDownListCalculate.do";
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