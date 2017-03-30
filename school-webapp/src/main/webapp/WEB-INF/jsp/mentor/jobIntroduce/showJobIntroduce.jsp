<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<script type="text/javascript">
$().ready(function() {
    $('#tabDetail-tabJobIntroduce').load('${pageContext.request.contextPath}/mentor/jobIntroduce/sub/tabJobIntroduce.do?jobNo=${jobInfo.jobNo}');
    $('#tabDetail-tabRelationMentor').load('${pageContext.request.contextPath}/mentor/jobIntroduce/sub/tabRelationMentor.do?jobNo=${jobInfo.jobNo}');
    $('#tabDetail-tabRelationLecture').load('${pageContext.request.contextPath}/mentor/jobIntroduce/sub/tabRelationLecture.do?jobNo=${jobInfo.jobNo}');

    $('#tabJobIntroduce, #tabRelationMentor, #tabRelationLecture').click(function(e) {
        e.preventDefault();
        $('.tab-action-cont .tab-cont').removeClass('active');
        $('#tabDetail-' + this.id).find('.tab-cont').addClass('active');
    });

    $('#save-interest-job').click(function(e) {
        e.preventDefault();
        $.ajax(this.href, {
            type: 'get',
            success: function(jsonData) {
                jsonData.success ? alert(jsonData.data) : alert(jsonData.message);
            }
        });
    });

    $.ajax({
        url: "${pageContext.request.contextPath}/ajax.isMyInterestForJob.do?itrstTargtNo=${jobInfo.jobNo}",
        success: function(rtnData) {
            if(rtnData){
                $("#interest-lesson").addClass("active");
            }
        }
    });
});
</script>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">멘토</span>
        <span>직업소개</span>
    </div>

    <div class="content sub">
        <h2>직업상세</h2>
        <div class="replay-detail">
            <div class="detail-info">
                <strong class="stit">${jobInfo.jobNm}</strong>
                <div class="img-star type2">
                    <div class="eximg">
                        <div class="img">
                            <c:if test="${not empty jobInfo.picInfoList}">
                                <ul class="bxslider1">
                                    <c:forEach var="picInfo" items="${jobInfo.picInfoList}" varStatus="vs" end="4">
                                        <c:if test="${not empty picInfo.picUrl}">
                                            <li><div><img src="${picInfo.picUrl}" alt="관련 직업 이미지 ${vs.count}" /></div></li>
                                        </c:if>
                                        <c:if test="${not empty picInfo.fileSer}">
                                            <li><div><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${picInfo.fileSer}" alt="관련 직업 이미지 ${vs.count}" /></div></li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                                <ul class="navi slide-btn">
                                    <c:forEach begin="1" end="${fn:length(jobInfo.picInfoList) < 5 ? fn:length(jobInfo.picInfoList) : 5}" varStatus="vs">
                                        <li <c:if test="${vs.first}">class="active"</c:if>><button type="button">관련 직업 ${vs.count}</button></li>
                                    </c:forEach>
                                </ul>
                            </c:if>
                            <c:if test="${empty jobInfo.jobPicInfo and empty jobInfo.mentorProfPicInfo}">
                                <ul class="bxslider1">
                                    <li><div><img src="${pageContext.request.contextPath}/images/common/mlogo.gif" alt="관련 직업 이미지" style="" /></div></li>
                                </ul>
                            </c:if>
                        </div>

                        <div class="txt">
                            <p>${jobInfo.jobDefNm}</p>
                            <ul>
                                <li>
                                    <em>분류</em>
                                    <span class="r-txt">${jobInfo.jobClsfNm}&nbsp;</span>
                                </li>
                                <li>
                                    <em>핵심능력</em>
                                    <span class="r-txt">${jobInfo.coreAblInfo}&nbsp;</span>
                                </li>
                                <li>
                                    <em>관련학과</em>
                                    <span class="r-txt">${jobInfo.assoSchDeptInfo }&nbsp;</span>
                                </li>
                                <li>
                                    <em>관련자격</em>
                                    <span class="r-txt">${jobInfo.assoCualfInfo }&nbsp;</span>
                                </li>
                                <li>
                                    <em>유사직업</em>
                                    <span class="r-txt">${jobInfo.smlrJobNm }&nbsp;</span>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="star">
                        <div class="job-relation-wrap" id="relationMentorInfo">
                            <ul class="slide_list">
                                <c:forEach items="${relMentorList}" var="relMentor" varStatus="vs">
                                    <li <c:if test="${vs.first}">class="current"</c:if>>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=${relMentor.mbrNo}" <%-- title="새창열림" --%> target="_self"> <%--멘토상세 이동--%>
                                                <div class="job-relation-info">
                                                    <div class="info">
                                                        <strong class="title">${relMentor.profTitle} ${relMentor.nm}</strong>
                                                        <p class="job">${relMentor.jobNm} <c:if test="${relMentor.iconKindCd eq '101598'}"><span class="icon">재능기부</span></c:if></p>
                                                    </div><div class="img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${relMentor.profFileSer}" alt="${relMentor.nm}"></div>
                                                </div>
                                            </a>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                            <ul class="navi slide-btn">
                                <c:forEach items="${relMentorList}" var="relMentor" varStatus="vs">
                                    <li <c:if test="${vs.first}">class="active"</c:if>><button type="button">${relMentor.nm}</button></li>
                                </c:forEach>
                            </ul>
                        </div>
                        <ul class="btn">
                            <li class="interest-lesson" id="interest-lesson"><a href="${pageContext.request.contextPath}/ajax.saveMyInterestForJob.do?itrstTargtNo=${jobInfo.jobNo}" id="save-interest-job">관심직업</a></li>
                            <security:authorize access="hasRole('ROLE_TEACHER')">
                                <li class="request"><a href="#lessonRequest" title="수업요청 팝업 - 열기" class="layer-open">수업요청</a></li>
                                <script type="text/javascript">$('.star .btn').addClass('two');</script>
                            </security:authorize>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="detail-anchor mobile">
                <div class="anchor-tab-area">
                    <div class="move-bar tab-action">
                        <%--<span class="title-bar">[연강] 세상을 평정한 1인 미디어 크리에이터 <span>수강모집</span></span>--%>
                        <ul class="tab-type1 tab03">
                            <li class="active"><a href="#" id="tabJobIntroduce">직업소개</a></li>
                            <li><a href="#" id="tabRelationMentor">관련멘토</a></li>
                            <li><a href="#" id="tabRelationLecture">관련수업</a></li>
                        </ul>
                    </div>
                </div>

                <div class="tab-action-cont" id="tabDetail-tabJobIntroduce"></div>
                <div class="tab-action-cont" id="tabDetail-tabRelationMentor"></div>
                <div class="tab-action-cont" id="tabDetail-tabRelationLecture"></div>
            </div>
        </div>
    </div>
    <div class="cont-quick double">
        <!--a href="javascript:void(0)" id="aGoList"><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
        <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a>
    </div>
</div>


<security:authorize access="isAuthenticated()">
    <div id="layerPopupDiv"></div>
    <script type="text/javascript">
    $().ready(function() {
        var params = $.param({"jobNo" : "${jobInfo.jobNo}", "jobNm" : "${jobInfo.jobNm}", "mentorCnt" : "${fn:length(relMentorList)}"});
        $('#layerPopupDiv').load('${pageContext.request.contextPath}/layer/layerPopupLectureReq.do?' + params);
    });
    </script>
</security:authorize>


<script type="text/javascript">
    $().ready(function(){
        $('.slide_list').sistarGallery({
            $animateTime_ : 500,
            $animateEffect_ : "easeInOutQuint",
            $autoDelay : 2000,
            $focusFade : 500,
            $currentNum : 1
        });

        $('.bxslider1').sistarGallery({
            $animateTime_ : 500,
            $animateEffect_ : "easeInOutQuint",
            $autoDelay : 2000,
            $focusFade : 500,
            $currentNum : 1
        });
    });

    //[리스트로 이동] 버튼 클릭
    $("#aGoList").click(function(){
        var url = mentor.contextpath + "/mentor/jobIntroduce/listJobIntroduce.do";
        $(location).attr('href', url);
    });
</script>


