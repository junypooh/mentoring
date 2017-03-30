<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
</security:authorize>
<%
    String evl = request.getParameter("evl");
    String replay = request.getParameter("replay");
%>
<script type="text/javascript">
    $(document).ready(function(){
        $('.slider-type1').sistarGallery({
            $animateTime_ : 500,
            $animateEffect_ : "easeInOutQuint",
            $autoDelay : 2000,
            $focusFade : 500,
            $currentNum : 1
        });
        $('.slide-type1').sistarGallery({
            $animateTime_ : 500,
            $animateEffect_ : "easeInOutQuint",
            $autoDelay : 2000,
            $focusFade : 500,
            $currentNum : 1
        });
        $('.slider-area').slider({
            range: "min",
            value: 5, /* value값 제한해주세요 */
            min: 0,
            max: 10
        });
        $('#save-interest-mentor,#save-interest-lecture').click(function(e) {
            e.preventDefault();
            $.ajax(this.href, {
                type: 'get',
                target:$(this),
                success: function(jsonData) {
                    if(jsonData.success){
                        alert(jsonData.data);
                        this.target.parent().addClass("active");
                    }else{
                        alert(jsonData.message);
                    }
                }
            });
        });

        $.ajax({
            url: "${pageContext.request.contextPath}/ajax.isMyInterestForMentor.do?itrstTargtNo=${lectInfo.lectrMbrNo}",
            success: function(rtnData) {
                if(rtnData){
                    $("#interest-mentor").addClass("active");
                }
            }
        });

        $.ajax({
            url: "${pageContext.request.contextPath}/ajax.isMyInterestForLecture.do?itrstTargtNo=${lectInfo.lectSer}",
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
                <span class="first">수업</span>
                <span>수업전체</span>
            </div>
            <div class="content sub">
                <h2>수업상세</h2>
                <div class="replay-detail">
                    <div class="detail-info">
                        <strong class="stit">
                            <c:if test="${lectInfo.lectTypeCd ne code['CD101528_101529_단강']}">
                                [${lectInfo.lectTypeCdNm}]
                            </c:if>
                            ${lectInfo.lectTitle}
                            <span>${lectTimsInfo.lectStatCdNm}</span>
                        </strong>
                        <div class="img-star">
                            <div class="eximg">
                                <div class="img">
                                    <ul class="bxslider1 slider-type1">
                                        <%--수업이미지--%>
                                        <c:choose>
                                            <c:when test="${fn:length(lectInfo.listLectPicInfo) > 0}">
                                                <c:forEach items="${lectInfo.listLectPicInfo}" var="lectPicInfo" varStatus="vs">
                                                    <li>
                                                        <div>
                                                            <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${lectPicInfo.fileSer}" alt="수업이미지${vs.count}" onError="fnDefaultImg(this)"/>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/images/lesson/img_epilogue_default.gif" alt="수업이미지${vs.count}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </ul>
                                    <ul class="navi slide-btn">
                                        <%--수업이미지--%>
                                        <c:forEach items="${lectInfo.listLectPicInfo}" var="lectPicInfo" varStatus="vs">
                                            <li <c:if test="${vs.first}">class="active"</c:if> ><button type="button">수업이미지${vs.count}</button></li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <div class="txt">
                                    <p>${lectInfo.lectOutlnInfo}</p>
                                    <ul>
                                        <li>
                                            <em>멘토</em>
                                            <span class="r-txt">${lectInfo.lectrNm}
                                                <c:if test="${lectInfo.iconKindCd eq code['CD101597_101598_재능기부']}">
                                                    <span class="don">재능기부</span>
                                                </c:if>
                                            </span>
                                        </li>
                                        <li>
                                            <em>일시</em>
                                            <div class="r-txt">
                                                <ul>
                                                    <c:forEach var="schdInfo" items="${lectTimsInfo.lectSchdInfo}">
                                                        <li>
                                                            <c:if test="${schdInfo.schdSeq eq lectureSearch.schdSeq}">
                                                                <strong>
                                                            </c:if>
                                                            ${schdInfo.lectDay}  ${schdInfo.lectStartTime} ~ ${schdInfo.lectEndTime}
                                                            <c:if test="${schdInfo.schdSeq eq lectureSearch.schdSeq}">
                                                                </strong>
                                                            </c:if>
                                                        </li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </li>
                                        <li>
                                            <em>대상</em>
                                            <span class="r-txt">
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
                                                    <c:when test="${lectInfo.lectTargtCd eq '101713' }">
                                                        <span class="icon-rating etc">기타</span>
                                                    </c:when>
                                                </c:choose>
                                            </span>
                                        </li>
                                        <li>
                                            <em>태그</em>
                                            <span class="r-txt">${lectInfo.jobTagInfo}<c:if test="${lectInfo.jobTagInfo == null}"> 없음  </c:if></span>
                                        </li>
                                    </ul>
                                    <p class="round-txt"><em>${lectInfo.grpNm}</em> 배정사업을 보유한 학교만 수업신청이 가능합니다.</p>
                                </div>
                            </div>
                            <div class="star">
                                <div class="num"></div>
                                <div class="grade">
                                <c:choose>
                                    <c:when test="${lectureRatingInfo.totalRecordCount > 0}">
                                        <ul>
                                            <li>
                                                <em class="teacher">교사</em>
                                                <span class="score">평점
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${lectureRatingInfo.teacherRating eq 0.0}">
                                                                0
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber type="number" pattern="0.0" value="${lectureRatingInfo.teacherRating}"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>점
                                                </span>
                                                <span class="mark">
                                                    <img src="${pageContext.request.contextPath}/images/lesson/score_star${lectureRatingInfo.imgTeacherRating}.png" alt="${lectureRatingInfo.teacherRating}" onerror="fnDefaultImg(this)"/>
                                                </span><!-- score_star0_5 :0.5점, score_star1 :1점, score_star1_5 :1.5점, score_star2 :2점, score_star2_5 :2.5점, score_star3 :3점, score_star3_5 :3.5점, score_star4 :4점, score_star4_5 :4.5점, score_star5 :5점 -->
                                            </li>
                                            <li>
                                                <em class="student">학생</em>
                                                <span class="score">평점
                                                    <strong>
                                                        <c:choose>
                                                            <c:when test="${lectureRatingInfo.studentRating eq 0.0}">
                                                                0
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber type="number" pattern="0.0" value="${lectureRatingInfo.studentRating}"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>점
                                                </span>
                                                <span class="mark"><img src="${pageContext.request.contextPath}/images/lesson/score_star${lectureRatingInfo.imgStudentRating}.png" alt="${lectureRatingInfo.studentRating}" /></span>
                                            </li>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-star"><img src="${pageContext.request.contextPath}/images/lesson/img_no_star.jpg" alt="원격 영상 진로 멘토링과 함께하는 나의 꿈!" /></div>
                                    </c:otherwise>
                                </c:choose>
                                </div>

                                <ul class="btn two">
                                    <li class="lesson" id="interest-lesson"><a href="${pageContext.request.contextPath}/ajax.saveMyInterestForLecture.do?itrstTargtNo=${lectInfo.lectSer}" id="save-interest-lecture">관심수업</a></li>
                                    <li class="mentor" id="interest-mentor"><a href="${pageContext.request.contextPath}/ajax.saveMyInterestForMentor.do?itrstTargtNo=${lectInfo.lectrMbrNo}" id="save-interest-mentor">관심멘토</a></li>
                                </ul>
                            </div>
                        </div>
						<div class="btn-request-group">
							<c:choose>
							    <c:when test="${lectTimsInfo.lectStatCd == '101543'}">
							        <c:choose>
							            <c:when test="${lectTimsInfo.applCnt < lectTimsInfo.maxApplCnt}">
							                <a href="javascript:void(0)" class="btn-lesson-req" onClick="fnSetLectApprove('101715')">수업신청</a>
                                        </c:when>
                                        <c:otherwise>
							                <span class="finish">수업신청 마감</span>
							            </c:otherwise>
							        </c:choose>
							        <c:choose>
							            <c:when test="${lectTimsInfo.obsvCnt < lectTimsInfo.maxObsvCnt}">
							                <a href="javascript:void(0)" class="btn-visit-req" onClick="fnSetLectApprove('101716')" >참관신청</a>
                                        </c:when>
                                        <c:otherwise>
							                <span class="finish">참관신청 마감</span>
							            </c:otherwise>
							        </c:choose>
							    </c:when>
							    <c:otherwise>
							        <span class="finish">수업신청 종료</span>
							        <span class="finish">참관신청 종료</span>
							    </c:otherwise>
							</c:choose>

							<ul class="req-count">
								<li><strong>수업 :</strong><span class="count-num"><em>${lectTimsInfo.applCnt}</em> / <span>${lectTimsInfo.maxApplCnt}</span>대</span></li>
								<li><strong>참관 :</strong><span class="count-num"><em>${lectTimsInfo.obsvCnt}</em> / <span>${lectTimsInfo.maxObsvCnt}</span>대</span></li>
							</ul>
						</div>

                    </div>
                    <div class="detail-anchor mobile">
                        <div class="anchor-tab-area">
                            <div class="move-bar tab-action">
                                <span class="title-bar"><c:if test="${lectInfo.lectTypeCd ne code['CD101528_101529_단강']}">[${lectInfo.lectTypeCdNm}]</c:if>${lectInfo.lectTitle}&nbsp;<span>${lectTimsInfo.lectStatCdNm}</span></span>
                                <ul class="tab-type1 tab05">
                                    <li class="active"><a href="javascript:void(0);" id="tabLectureInfo">수업소개</a></li>
                                    <li><a href="javascript:void(0);" id="tabMentorInfo">멘토소개</a></li>
                                    <li><a href="javascript:void(0);" id="tabLectureInquiry">수업문의</a></li>
                                    <li><a href="javascript:void(0);" id="tabLectureGradeMark">평점 및 후기</a></li>
                                    <li><a href="javascript:void(0);" id="tabRelationLecture">관련수업</a></li>
                                </ul>
                            </div>
                        </div>

                        <div id="tabDetail"></div>

                    </div>
                </div>
            </div>

            <div class="cont-quick double">
                <!--a href="javascript:void(0)" id="aGoList"><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
                <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
            </div>
        </div>
        <a href="#layer1" class="layer-open" title="팝업 열기" id="layerOpen"></a>

        <!-- layerpopup -->
        <div id="layerPopupDiv"></div>
<STYLE type="text/css">
#popup{
    position:absolute;
    top:0;
    left:0;
    width:500px;
    height:500px;
}
</style>

<script type="text/javascript">
    $(document).ready(function(){

        /*수업소개 탭 클릭*/
        $("#tabLectureInfo").click(function(){
            $("#tabDetail").removeAttr("style");
            $("#tabDetail").load("${pageContext.request.contextPath}/lecture/lectureTotal/tabLectureInfo.do?lectSer="+"${lectTimsInfo.lectSer}"+"&lectTims="+"${lectTimsInfo.lectTims}"+"&lectrMbrNo="+"${lectInfo.lectrMbrNo}");
        });

        /*멘토소개 탭 클릭*/
        $("#tabMentorInfo").click(function(){
            $("#tabDetail").removeAttr("style");
            $("#tabDetail").load("${pageContext.request.contextPath}/lecture/lectureTotal/tabMentorInfo.do?mbrNo=${lectInfo.lectrMbrNo}");
        });

        /*문의하기 탭 클릭*/
        $("#tabLectureInquiry").click(function(){
            $("#tabDetail").removeAttr("style");
            $("#tabDetail").load("${pageContext.request.contextPath}/lecture/lectureTotal/tabLectureInquiry.do?lectSer=${lectureSearch.lectSer}&lectTims=${lectureSearch.lectTims}&schdSeq=${lectureSearch.schdSeq}&lectrMbrNo=${lectInfo.lectrMbrNo}&lectrJobNo=${lectInfo.lectrJobNo}");
        });

        /*평점 및 후기 탭 클릭*/
        $("#tabLectureGradeMark").click(function(){
            $("#tabDetail").removeAttr("style");
            $("#tabDetail").load("${pageContext.request.contextPath}/lecture/lectureTotal/tabLectureGradeMark.do?lectSer=${lectureSearch.lectSer}&lectTims=${lectureSearch.lectTims}&schdSeq=${lectureSearch.schdSeq}");
        });


        /*관련수업 탭 클릭*/
        $("#tabRelationLecture").click(function(){
            $("#tabDetail").removeAttr("style");
            $("#tabDetail").load("${pageContext.request.contextPath}/lecture/lectureTotal/tabRelationLecture.do?lectSer="+"${lectureSearch.lectSer}"+"&lectTims="+"${lectureSearch.lectTims}"+"&schdSeq="+"${lectureSearch.schdSeq}");
        });


        if('<%=evl%>' != 'null'){
            //마이페이지에서 수업평가 눌럿을경우
            $("#tabLectureGradeMark").trigger("click");
        } else {
            /*화면 로드시에 수업소개탭 보여주기*/
            $("#tabLectureInfo").trigger("click");
        }
    });


    function fnSetLectApprove(applClassCd){
        if(${ (!empty id) and mbrClassCd ne code['CD100857_100859_교사'] and mbrClassCd ne '101707' and rpsStdtYn ne 'Y'} ){
            alert("수업신청은 일반학생은 불가능합니다.");
            return false;
        }else if(${empty id}){
            $(location).attr("href", "${pageContext.request.contextPath}/login.do");
            return false;
        }
        if(mentor.isMobile){
            location.href = "${pageContext.request.contextPath}/myPage/myLecture/mWebLectureApply.do?lectSer=${lectureSearch.lectSer}&lectTims=${lectureSearch.lectTims}"+"&applClassCd="+applClassCd+"&schdSeq=${lectureSearch.schdSeq}";
        }else{
            $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupLectureApply.do?lectSer="+"${lectureSearch.lectSer}"+"&lectTims="+"${lectureSearch.lectTims}"+"&applClassCd="+applClassCd, function(){ $("#layerOpen").trigger("click");});
        }

    }


    function fnDefaultImg(imtPath){
        imtPath.src = "${pageContext.request.contextPath}/images/lesson/img_epilogue_default.gif";
    }

    //[리스트로 이동] 버튼 클릭
    $("#aGoList").click(function(){
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureList.do";
        $(location).attr('href', url);
    });
</script>