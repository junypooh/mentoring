<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
</security:authorize>


<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>수업관리</span>
        <span>수업현황</span>
    </div>
    <div class="content">
        <h2 class="fs24">수업상세</h2>
        <div class="cont type3">
            <div class="lesson_detail">
            <input type="hidden" id="lectTims" value="${lectTimsInfo.lectTims}"/>
                <h3>
                    <c:if test="${lectInfo.lectTypeCd ne code['CD101528_101529_단강']}">[${lectInfo.lectTypeCdNm}]</c:if>${lectInfo.lectTitle}
                    <em class="mt-nmjob">(<span>${lectInfo.lectrNm}</span>/<span>${lectInfo.lectrJobNm}</span>)</em>
                </h3>
                <div class="board-slide">
                    <div class="slide">
                        <ul class="bxslider1">
                            <c:forEach items="${lectInfo.listLectPicInfo}" var="lectPicInfo" varStatus="vs">
                                <li><div>
                                     <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${lectPicInfo.fileSer}" alt="수업이미지${vs.count}"  onerror="fnDefaultImg(this)"/>
                                </div></li>
                            </c:forEach>
                        </ul>
                        <ul class="navi slide-btn">
                            <c:forEach items="${lectInfo.listLectPicInfo}" var="lectPicInfo" varStatus="vs">
                                <li <c:if test="${vs.first}">class="active"</c:if> ><button type="button">수업이미지${vs.count}</button></li>
                            </c:forEach>
                        </ul>
                    </div>
                    <div class="board-type2 detail">
                        <table>
                            <caption>수업상세 - 수업개요, 태그, 수업유형, 학교급, 수업상태, 수업일시 스튜디오 MC</caption>
                            <colgroup>
                                <col style="width:114px;"/>
                                <col/>
                                <col style="width:114px;"/>
                                <col>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row">수업개요</th>
                                <td colspan="3">${lectInfo.lectOutlnInfo}</td>
                            </tr>
                            <tr>
                                <th scope="row">태그</th>
                                <td colspan="3">${lectInfo.jobTagInfo}</td>
                            </tr>
                            <tr>
                                <th scope="row">수업유형</th>
                                <td>${lectInfo.lectTypeCdNm}</td>
                                <th scope="row">학교급</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101534_초등학교']}">
                                            <span class="icon-rating elementary">초</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101535_중학교']}">
                                            <span class="icon-rating middle">중</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101536_고등학교']}">
                                            <span class="icon-rating high">고</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101537_초등_중학교']}">
                                            <span class="icon-rating elementary">초</span>
                                            <span class="icon-rating middle">중</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101538_중_고등학교']}">
                                            <span class="icon-rating middle">중</span>
                                            <span class="icon-rating high">고</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101539_초등_고등학교']}">
                                            <span class="icon-rating elementary">초</span>
                                            <span class="icon-rating high">고</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq code['CD101533_101540_초등_중_고등학교']}">
                                            <span class="icon-rating elementary">초</span>
                                            <span class="icon-rating middle">중</span>
                                            <span class="icon-rating high">고</span>
                                        </c:when>
                                        <c:when test="${lectInfo.lectTargtCd eq '101713'}">
                                            <span class="icon-rating etc">기타</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">수업상태</th>
                                <td colspan="3">
                                    <c:choose>
                                        <c:when test="${empty lectTimsInfo}">${lectInfo.lectStatCdNm}</c:when>
                                        <c:otherwise>${lectTimsInfo.lectStatCdNm}</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr class="last">
                                <th scope="row">수업일시<br/>스튜디오<br/>MC</th>
                                <td colspan="3">
                                    <ul class="schedule-cont">
                                        <c:forEach var="schdInfo" items="${lectSchdInfo}">
                                            <li>
                                                <c:if test="${schdInfo.schdSeq eq schdSeq}">
                                                    <strong>
                                                </c:if>
                                                <span>${schdInfo.lectDay} ${schdInfo.lectStartTime} ~ ${schdInfo.lectEndTime}</span>
                                                <span><c:if test="${schdInfo.stdoNm eq null}">지정안함</c:if>${schdInfo.stdoNm}</span>
                                                <span><c:if test="${schdInfo.mcNm eq null}">지정안함</c:if>${schdInfo.mcNm}</span>
                                                <c:if test="${schdInfo.schdSeq eq schdSeq}">
                                                    </strong>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="board-type2 info">
                        <table>
                            <caption>수업상세 - 신청기기, 참관기기, 수업소개, 수업내용</caption>
                            <colgroup>
                                <c:choose>
                                    <c:when test="${lectInfo.lectTypeCd eq code['CD101528_101529_단강']}">
                                        <col style="width:114px;"/>
                                        <col/>
                                        <col style="width:114px;"/>
                                        <col>
                                    </c:when>
                                    <c:otherwise>
                                        <col style="width:114px;" />
                                        <col style="width:191px;" />
                                        <col style="width:114px;" />
                                        <col />
                                    </c:otherwise>
                                </c:choose>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row">신청기기</th>
                                <td><span class="request-equipment">
                                        <em> <c:choose><c:when test="${lectTimsInfo eq null}">0</c:when><c:otherwise>${lectTimsInfo.applCnt}</c:otherwise></c:choose></em>
                                        /
                                        <c:choose><c:when test="${lectTimsInfo eq null}">${lectInfo.maxApplCnt}</c:when><c:otherwise>${lectTimsInfo.maxApplCnt}</c:otherwise></c:choose>
                                    </span>
                                </td>
                                <th scope="row">참관기기</th>
                                <td><span class="request-equipment">
                                        <em> <c:choose><c:when test="${lectTimsInfo eq null}">0</c:when><c:otherwise>${lectTimsInfo.obsvCnt}</c:otherwise></c:choose></em>
                                        /
                                        <c:choose><c:when test="${lectTimsInfo eq null}">${lectInfo.maxObsvCnt}</c:when><c:otherwise>${lectTimsInfo.maxObsvCnt}</c:otherwise></c:choose>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">수업소개</th>
                                <td colspan="3">
                                    <div class="lesson-cont">
                                        <span>
                                        <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectInfo.lectIntdcInfo)"></spring:eval>
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">수업내용</th>
                                <td colspan="3">
                                    <div class="lesson-cont detail">
                                        <span class="detail-btn" onclick="fnShowDetail(this)"><span>※상세보기는 우측 펼치기 아이콘을 클릭하세요.</span></span>
                                        <div class="detail-cont">${lectInfo.lectSustInfo}</div>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="btn-area r-align">
                    <a href="#" class="btn-type4 modify" id="aLectureModify">수정</a>
                    <a href="#" class="btn-type4 list" id="aLectureList">목록</a>
                </div>
            </div>
            <div class="tab-action">
                <ul class="sub-tab">
                    <li class="active"><a href="#" id="tabLectureInquiry">수업문의</a></li>
                    <li><a href="#" id="tabLectureHomework">수업과제</a></li>
                    <li><a href="#" id="tabLectureData">수업자료</a></li>
                    <li><a href="#" id="tabLectureSchedule">수업일시</a></li>
                </ul>

                <div class="tab-action-cont">
                </div>

            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동"/></a></div>
</div>

<script type="text/javascript">
    <c:choose>
        <c:when test="${result gt 0}">
            alert('저장 되었습니다.');
        </c:when>
    </c:choose>

    function fnDefaultImg(imtPath){
            imtPath.src = "${pageContext.request.contextPath}/images/main/img_popup_01.jpg";
        }

    $(document).ready(function () {

        $('.bxslider1').sistarGallery({
            $animateTime_: 500,
            $animateEffect_: "easeInOutQuint",
            $autoDelay: 2000,
            $focusFade: 500,
            $currentNum: 1
        });

        //수업문의 탭 클릭
        $("#tabLectureInquiry").click(function(){
            $(".tab-action-cont").load("${pageContext.request.contextPath}/lecture/lectureState/tabLectureInquiry.do?lectSer=${lectInfo.lectSer}&lectTims=${param.lectTims}&schdSeq=${param.schdSeq}&lectrMbrNo=${lectInfo.lectrMbrNo}&lectTypeCd=${lectInfo.lectTypeCd}&arclSer="+mentor.tempArclSer);
            mentor.tempArclSer = "";
        });

        //수업과제 탭 클릭
        $("#tabLectureHomework").click(function(){
            $(".tab-action-cont").load("${pageContext.request.contextPath}/lecture/lectureState/tabLectureHomework.do?lectSer=${lectInfo.lectSer}&lectTims=${param.lectTims}&schdSeq=${param.schdSeq}&lectrMbrNo=${lectInfo.lectrMbrNo}&lectTypeCd=${lectInfo.lectTypeCd}&arclSer="+mentor.tempArclSer);
            mentor.tempArclSer = "";
        });

        //수업자료 탭 클릭
        $("#tabLectureData").click(function(){
            $(".tab-action-cont").load("${pageContext.request.contextPath}/lecture/lectureState/tabLectureData.do?lectSer=${lectInfo.lectSer}&lectTims=${param.lectTims}&schdSeq=${param.schdSeq}&lectrMbrNo=${lectInfo.lectrMbrNo}&lectTypeCd=${lectInfo.lectTypeCd}&lectCoNo=${lectInfo.lectCoNo}&arclSer="+mentor.tempArclSer);
            mentor.tempArclSer = "";
        });

        //수업일시 탭 클릭
        $("#tabLectureSchedule").click(function(){
            var parameters = $.param({"lectSer":${lectInfo.lectSer}, "lectTims": $("#lectTims").val(), "lectrMbrNo":${lectInfo.lectrMbrNo}, "lectTypeCd":${lectInfo.lectTypeCd},"lectStatCd":${lectInfo.lectStatCd},"lectTitle": "${lectInfo.lectTitle}","lectTargtCd":"${lectInfo.lectTargtCd}","assignDay":${assignDay} });
            var url = "${pageContext.request.contextPath}/lecture/lectureState/tabLectureSchedule.do?" + parameters;
            $(".tab-action-cont").load(url);
        });

        //수정버튼 클릭
        $("#aLectureModify").click(function (e) {
            e.preventDefault();
            location.href = "${pageContext.request.contextPath}/lecture/lectureState/lectureModify.do?lectSer=${lectInfo.lectSer}&schdSeq=${schdSeq}&lectTims=${lectTimsInfo.lectTims}";
        });

        //목록버튼 클릭
        $("#aLectureList").click(function (e) {
            e.preventDefault();
            location.href = "${pageContext.request.contextPath}/lecture/lectureState/mentorLectList.do?listType=${param.listType}";
        });
        <c:choose>
        <c:when test="${empty param.tab}">
        //화면로딩 수업문의 탭페이지 보이기
        $("#tabLectureInquiry").click();
        </c:when>
        <c:otherwise>
        mentor.tempArclSer = "${param.arclSer}";
        $("#${param.tab}").click();
        </c:otherwise>
        </c:choose>

        if(${param.listType == '4'}){
            $("#tabLectureSchedule").click();
        }
    });


    function fnShowDetail(obj){
        if($(obj).hasClass("active")){
            $(obj).children().show();
        }else{
            $(obj).children().hide();
        }
    }
</script>