<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>
<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
</security:authorize>


<div id="container">
            <div class="location">
                <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
                <span class="first">수업</span>
                <span>수업전체</span>
            </div>
            <div class="content sub">
            <input type="hidden" id="listType" value="1" />
                <div class="title-group">
                    <h2 class="title">수업전체</h2>
                    <c:if test="${mbrClassCd == '101707' or mbrClassCd == '100859'}">
                        <div class="btn m-blind"><a href="#testLecture" title="테스트 수업입장 - 입장" class="btn-border-type m-none" id="testLecture">입장테스트</a></div>
                        <%-- div class="btn m-blind"><a href="#lessonRequest" title="수업요청 팝업 - 열기" class="btn-border-type layer-open m-none">수업요청</a></div --%>
                    </c:if>
                </div>
                <div class="review-tbl-wrap">
                    <div class="review-tbl">
                        <table>
                            <caption>수업 다시보기 검색창 - 날짜,학교,시간,수업유형,키워드,직업</caption>
                            <colgroup>
                                <col class="size-tbl1" />
                                <col class="size-tbl2" />
                                <col class="size-tbl1" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row"><label for="reviewDate">날짜</label></th>
                                    <td class="review-cardat">
                                        <input type="text" id="searchStDate" title="시작일 선택 달력" style="width: 100px;"/>
                                        <span class="calendar-hyphen">~</span>
                                        <input type="text" id="searchEndDate" title="마지막 선택 달력" style="width: 100px;"/>
                                    </td>
                                    <th scope="row"><label for="schoolGrd">학교급</label></th>
                                    <td>
                                        <div class="selectbox-zindex-wrap"><!-- 2015-11-16 추가 -->
                                            <div class="checkbox-wrap">
												<label><input type="checkbox" name="schoolGrd" value="101534"/>초</label>
												<label><input type="checkbox" name="schoolGrd" value="101535"/>중</label>
												<label><input type="checkbox" name="schoolGrd" value="101536"/>고</label>
												<label><input type="checkbox" name="schoolEtcGrd" value="101713"/>기타</label>
											</div>
                                            <input type="hidden" id="lectTargtCd" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><label for="lectTime">시간</label></th>
                                    <td>
                                        <select id="lectTime" title="시간정보 - 1시간 단위">
                                            <option value="">전체</option>
                                            <option value="0800">08:00</option>
                                            <option value="0900">09:00</option>
                                            <option value="1000">10:00</option>
                                            <option value="1100">11:00</option>
                                            <option value="1200">12:00</option>
                                            <option value="1300">13:00</option>
                                            <option value="1400">14:00</option>
                                            <option value="1500">15:00</option>
                                            <option value="1600">16:00</option>
                                        </select>
                                    </td>
                                    <th scope="row"><label for="lectType">수업유형</label></th>
                                    <td>
                                        <form:select path="lectType" id="lectType" title="수업유형">
                                            <form:option value="">전체</form:option>
                                            <form:options items="${lectType}" itemLabel="cdNm" itemValue="cd"/>
                                        </form:select>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row"><label for="schoolKeyword">키워드</label></th>
                                    <td>
                                        <div class="keyword-search">
                                            <%--
                                            <select class="keyword-slt" title="키워드 종류" id="seachType">
                                                <option value="all">전체</option>
                                                <option value="lectTitle">수업</option>
                                                <option value="mentorNm">멘토</option>
                                                <option value="jobTagInfo">태그</option>
                                                <option value="jobNm">직업</option>
                                            </select>
                                            --%>
                                            <input type="text" class="keyword-inp" title="키워드입력란" id="searchKey" style="border: 1px solid #b2b2b2;"/>
                                        </div>
                                    </td>
                                    <th scope="row">직업</th>
                                    <td>
                                        <a href="#jobSearch" title="직업선택 팝업 - 열기" class="btn-job layer-open m-none">직업선택</a>
                                    </td>
                                    <input type="hidden" id="jobChrstc" value="" />
                                    <input type="hidden" id="jobDetail" value="" />
                                </tr>
								<tr>
									<th scope="row">배정사업</th>
									<td colspan="3">
										<select id="grpNo" title="배정사업" style="width:378px;">
											<option value="">전체</option>
											<c:forEach items="${bizGrpList}" var="eachObj">
                                                <option value="${eachObj.grpNo}">${eachObj.grpNm}</option>
                                            </c:forEach>
										</select>
									</td>
								</tr>
                                <tr>
                                    <th scope="row">수업명</th>
                                    <td colspan="3">
                                        <ul class="btn-dic">
                                            <input type="hidden" id="consonantsVal" />
                                            <li><a href="javascript:void(0)" data="^[가-기+ㅎ].*" <c:if test="${param.consonantsVal eq '^[가-기+ㅎ].*'}">class="on"</c:if>>ㄱ</a></li>
                                            <li><a href="javascript:void(0)" data="^[나-니+ㅎ].*" <c:if test="${param.consonantsVal eq '^[나-니+ㅎ].*'}">class="on"</c:if>>ㄴ</a></li>
                                            <li><a href="javascript:void(0)" data="^[다-디+ㅎ].*" <c:if test="${param.consonantsVal eq '^[다-디+ㅎ].*'}">class="on"</c:if>>ㄷ</a></li>
                                            <li><a href="javascript:void(0)" data="^[라-리+ㅎ].*" <c:if test="${param.consonantsVal eq '^[라-리+ㅎ].*'}">class="on"</c:if>>ㄹ</a></li>
                                            <li><a href="javascript:void(0)" data="^[마-미+ㅎ].*" <c:if test="${param.consonantsVal eq '^[마-미+ㅎ].*'}">class="on"</c:if>>ㅁ</a></li>
                                            <li><a href="javascript:void(0)" data="^[바-비+ㅎ].*" <c:if test="${param.consonantsVal eq '^[바-비+ㅎ].*'}">class="on"</c:if>>ㅂ</a></li>
                                            <li><a href="javascript:void(0)" data="^[사-시+ㅎ].*" <c:if test="${param.consonantsVal eq '^[사-시+ㅎ].*'}">class="on"</c:if>>ㅅ</a></li>
                                            <li><a href="javascript:void(0)" data="^[아-이+ㅎ].*" <c:if test="${param.consonantsVal eq '^[아-이+ㅎ].*'}">class="on"</c:if>>ㅇ</a></li>
                                            <li><a href="javascript:void(0)" data="^[자-지+ㅎ].*" <c:if test="${param.consonantsVal eq '^[자-지+ㅎ].*'}">class="on"</c:if>>ㅈ</a></li>
                                            <li><a href="javascript:void(0)" data="^[차-치+ㅎ].*" <c:if test="${param.consonantsVal eq '^[차-치+ㅎ].*'}">class="on"</c:if>>ㅊ</a></li>
                                            <li><a href="javascript:void(0)" data="^[카-키+ㅎ].*" <c:if test="${param.consonantsVal eq '^[카-키+ㅎ].*'}">class="on"</c:if>>ㅋ</a></li>
                                            <li><a href="javascript:void(0)" data="^[타-티+ㅎ].*" <c:if test="${param.consonantsVal eq '^[타-티+ㅎ].*'}">class="on"</c:if>>ㅌ</a></li>
                                            <li><a href="javascript:void(0)" data="^[파-피+ㅎ].*" <c:if test="${param.consonantsVal eq '^[파-피+ㅎ].*'}">class="on"</c:if>>ㅍ</a></li>
                                            <li><a href="javascript:void(0)" data="^[하-히+ㅎ].*" <c:if test="${param.consonantsVal eq '^[하-히+ㅎ].*'}">class="on"</c:if>>ㅎ</a></li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn-area">
                        <a href="javascript:void(0)" class="btn-search" id="aSearch"><span>검색</span></a>
                        <a href="javascript:void(0)" class="btn-reload" id="aClear"><span>다시검색</span></a>

                    </div>
                </div>
                <div class="result-total-wrap" style="visibility: hidden;">
                    <span class="result-class">

                    </span>
                    <p class="result-total">검색 결과 총 <strong></strong> 건</p>
                </div>
                <div class="tab-action">
                    <ul class="tab-type1 tab05">
                        <li><a href="javascript:void(0);" id="lessonTab01">전체</a></li>
                        <li class="active"><a href="javascript:void(0);" id="lessonTab02">수강모집</a></li>
                        <li><a href="javascript:void(0);" id="lessonTab03">수업확정</a></li>
                        <li><a href="javascript:void(0);" id="lessonTab04">오늘의 수업</a></li>
                        <li><a href="javascript:void(0);" id="lessonTab05">수업완료</a></li>
                    </ul>
                    <div class="tab-action-cont">
                        <div class="tab-cont active" id="lectureTabViewTotal"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="cont-quick">
            <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
        </div>

<!-- layerpopup -->
<div id="layerPopupDiv">

</div>

<%-- 직업선택 : 레이어팝업 --%>
<jsp:include page="/WEB-INF/jsp/layer/layerJobSelector.jsp">
    <jsp:param name="callback" value="jobLayerConfirmCallback" />
</jsp:include>

<script type="text/javascript">
    var dataSet = {
        params: {
            totalRecordCount: 0,
            currentPageNo: 1,
            searchKey: null,
            searchType: null,
            jobChrstcList: null,
            lectrJob: null,
            consonantsVal : null
        },
        data: {},
    };
    mentor.mentorDataSet = dataSet;

    $(document).ready(function(){

        <c:if test="${mbrClassCd == '101707' or mbrClassCd == '100859'}">
            $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupLectureReq.do");
            $('#testLecture').click(
                function(){
                    _fCallTomms('4503');
                }
            );
        </c:if>

        _applyDatepicker($("#searchStDate"), '시작일 선택 달력');
        _applyDatepicker($("#searchEndDate"), '마지막 선택 달력');


        $("#aClear").click(function(){
            dataSet.params.consonantsVal = '';
            dataSet.params.jobChrstcList = '';
            dataSet.params.lectrJob = '';
            $("input[name=schoolEtcGrd]").attr("checked", false);

            $("input[name=schoolGrd]:checkbox").each(function() {
				$(this).attr("checked", false);
			});

            $("#lectType").val("");
            $("#searchStDate").val("");
            $("#searchEndDate").val("");
            $("#searchKey").val("");
            $("#lectTime").val("");
            $("#grpNo").val("");
            $("#jobChrstc").val("");
            $("#jobDetail").val("");
            $('.btn-dic > li > a').removeClass();
            $('.result-class').empty();

            $("#aSearch").click();

        });


        // 직업명 초성검색
        $('.btn-dic li').click(function(){
            var idx = $('.btn-dic li').index(this);

            if($('.btn-dic li').eq(idx).find('a').hasClass('on')){
                $('.btn-dic li').eq(idx).find('a').removeClass();
                dataSet.params.consonantsVal = '';
            }else{
                if($('.btn-dic > li'))
                $('.btn-dic > li > a').removeClass();
                $('.btn-dic li').eq(idx).find('a').addClass('on');
                var consonantsVal = $('.btn-dic li').eq(idx).find('a').attr('data');
                dataSet.params.consonantsVal = consonantsVal;
            }
        });

        $('.hasDatepicker').keyup(function(e) {

            var dateExp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

            if($(this).val().length >= 10) {
                $(this).val($(this).val().substring(0, 10));

                if(!dateExp.test($(this).val())) {
                    alert('날짜 형식에 맞지 않습니다. ex) 2015-10-26');
                    $(this).val('');
                }
                return;
            } else {
                if($(this).val().length == 4) {
                    $(this).val($(this).val() + "-");
                }
                if($(this).val().length == 7) {
                    $(this).val($(this).val() + "-");
                }
            }
        });

        $('#searchKey').keydown(function(e) {
            if (e.which == 13) {/* 13 == enter key@ascii */
                $("#aSearch").click();
            }
        });

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );

        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");


    });

    function initParameters(){
        $.extend(dataSet.params, {
            jobChrstcList: $.map($('#chrstcClsfSelector :checkbox:checked'), function(o) { return o.value; }),
            lectrJob: $('#jobClsfSelector :radio:checked').val(),
        });
    };

    function jobLayerConfirmCallback(chrstcClsfCds, jobClsfCd) {
        initParameters();
    }

    function searchList(){
        if($("#searchStDate").val().trim() != "" && $("#searchEndDate").val().trim() == ""){
            alert("검색종료 날짜를 입력하세요.");
            return false;
        }

        if($("#searchStDate").val().trim() == "" && $("#searchEndDate").val().trim() != ""){
            alert("검색시작 날짜를 입력하세요.");
            return false;
        }

        mentor.lectureTabViewTotal.getList({'listType':mentor.activeTab, 'isMore' :false, 'params' : dataSet.params});
    }

    $("#aSearch").click(function(){
        var checkLectType = new Array;

        // 대상선택 체크박스
        $('input[name=schoolGrd]:checked').each(function(index){
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

        $("#lessonTab02").click();
    });

    mentor._callbackTabClick = function(idx){
        mentor.activeTab = idx;
        $("#listType").val(idx);

        searchList();
    }

    function goPage(curPage){
        mentor.lectureTabViewTotal.getList({'currentPageNo':curPage, 'listType':mentor.activeTab, 'params' : dataSet.params});
    }

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/lectureList.js"></script>
<script type="text/javascript">


    $("input[name=schoolGrd][value='${lectureSearch.schoolGrd}']").attr("checked", true);
    $("#lectTargtCd").val(${lectureSearch.schoolGrd});


    mentor.activeTab = $("#listType").val();

    $(".tab-type1").children().removeClass();
    var listType = Number(mentor.activeTab) + 1;

    $("#lessonTab0"+listType).parent().addClass("active");

        mentor.lectureTabViewTotal = React.render(
          React.createElement(LectureTabViewWeb, {url:'${pageContext.request.contextPath}/lecture/lectureTotal/ajax.lectureList.do', schoolGrd:$("#schoolGrd").val()}),
          document.getElementById('lectureTabViewTotal')
        );

</script>

