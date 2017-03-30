<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<div id="container">
    <div class="location">
        <a href="#" class="home">HOME</a>
        <span class="first">멘토</span>
        <span>멘토소개</span>
    </div>
    <form id="frm">
        <input type="hidden" name="genCd" value="${param.genCd}" />
        <input type="hidden" name="consonants" value="${param.consonants}" />
        <input type="hidden" name="jobClsfCd" value="${param.jobClsfCd}" />
        <input type="hidden" name="lectStatCd" value="${param.lectStatCd}" />
        <input type="hidden" name="searchKey" value="${param.searchKey}" />
        <input type="hidden" name="searchWord" value="${param.searchWord}" />
        <input type="hidden" name="currentPageNo" value="${param.currentPageNo}" />
        <input type="hidden" name="chrstcClsfCds" value="${param.chrstcClsfCds}" />
        <input type="hidden" name="consonantsVal" value="${param.consonantsVal}" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
    <div class="content sub">
        <h2>멘토상세</h2>
        <div class="replay-detail">
            <div class="detail-info">
                <strong class="stit">${mentor.profTitle} <em>${mentor.nm}</em></strong>
                <div class="img-star type2">
                    <div class="eximg">
                        <div class="img">
                            <ul class="bxslider1">
                                <c:choose>
                                    <c:when test="${!empty listMbrProfPicInfo}">
                                        <c:forEach items="${listMbrProfPicInfo}" var="list" varStatus="vs">
                                            <li><div><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${list.fileSer}" alt="멘토 이미지" /></div></li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li><div><img src="${pageContext.request.contextPath}/images/common/mlogo.gif" alt="멘토 이미지" style="" /></div></li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                            <ul class="navi slide-btn">
                                <c:choose>
                                    <c:when test="${!empty listMbrProfPicInfo}">
                                        <c:forEach begin="1" end="${fn:length(listMbrProfPicInfo)}" varStatus="vs">
                                            <li <c:if test="${vs.first}">class="active"</c:if>><button type="button">관련 직업 ${vs.count}</button></li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="active"><button type="button">관련 직업 1</button></li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                        <div class="txt">
                            <ul>
                                <li>
                                    <em>멘토</em>
                                    <span class="r-txt">${mentor.nm}<c:if test="${mentor.iconKindCd eq '101598'}"> <span class="don">재능기부</span></c:if></span>
                                </li>
                                <li>
                                    <em>분류</em>
                                    <span class="r-txt"><!-- 특징분류 / 직업 분류 -->
                                        ${mentor.jobStruct3}<c:if test="${!empty listMbrJobChrstcInfos}"> / </c:if>
                                        <c:forEach items="${listMbrJobChrstcInfos}" var="eachObj" varStatus="vs">
                                            <c:if test="${not vs.first}"> / </c:if>${eachObj.jobChrstcCdNm}
                                        </c:forEach>&nbsp;
                                    </span>
                                </li>
                                <li>
                                    <em>직업</em>
                                    <span class="r-txt">${mentor.jobNm}</span>
                                </li>
                                <li>
                                    <em>태그</em>
                                    <span class="r-txt">${mentor.jobTagInfo}</span>
                                </li>
                                <!-- 2016.08.04 주석처리
                                <c:if test="${!empty listMbrProfScrpInfo}">
                                    <li>
                                        <em>관련 정보</em>
                                        <div class="block-txt">
                                            <ul>
                                                <c:forEach items="${listMbrProfScrpInfo}" var="list" varStatus="vs">
                                                    <li><span class="sort">${list.scrpClassCdNm}</span><a href="${list.scrpURL}" title="새창열림" target="_blank">${list.scrpTitle}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </li>
                                </c:if>
                                -->
                            </ul>
                        </div>
                    </div>
                    <div class="star">
                        <div class="grade">
                            <ul>
                                <c:choose>
                                    <c:when test="${mentor.tchrAsmPnt ne '0' and mentor.stdntAsmPnt ne '0'}">
                                        <li>
                                            <em class="teacher">교사</em>
                                            <span class="score">평점<strong><fmt:formatNumber pattern="#.#" value="${mentor.tchrAsmPnt}" var="tchrAsmPnt" />${tchrAsmPnt}</strong>점</span>
                                            <span class="mark">
                                                <c:if test="${tchrAsmPnt ne '0'}">
                                                    <img src="${pageContext.request.contextPath}/images/lesson/score_star${fn:replace(tchrAsmPnt,'.', '_')}.png" alt="${tchrAsmPnt}" />
                                                </c:if>
                                            </span><!-- score_star0_5 :0.5점, score_star1 :1점, score_star1_5 :1.5점, score_star2 :2점, score_star2_5 :2.5점, score_star3 :3점, score_star3_5 :3.5점, score_star4 :4점, score_star4_5 :4.5점, score_star5 :5점 -->
                                        </li>
                                        <li>
                                            <em class="student">학생</em>
                                            <span class="score">평점<strong><fmt:formatNumber pattern="#.#" value="${mentor.stdntAsmPnt}" var="stdntAsmPnt" />${stdntAsmPnt}</strong>점</span>
                                            <span class="mark">
                                                <c:if test="${stdntAsmPnt ne '0'}">
                                                    <img src="${pageContext.request.contextPath}/images/lesson/score_star${fn:replace(stdntAsmPnt,'.', '_')}.png" alt="${stdntAsmPnt}" />
                                                </c:if>
                                            </span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- 평점 없을 때, 대체이미지 -->
                                        <img src="${pageContext.request.contextPath}/images/mentor/img_grade_default.jpg" alt="원격 영상 진로 멘토링과 함께하는 나의 꿈!" />
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                        <ul class="btn">
                            <li class="interest-lesson" id="interest-lesson"><a href="javascript:void(0)" id="save-interest-mentor">관심멘토</a></li>
                            <security:authorize access="hasRole('ROLE_TEACHER') or hasRole('ROLE_RPS_TEACHER') or hasRole('ROLE_SCHOOL')">
                                <!-- li class="request"><a href="#lessonRequest" title="수업요청 팝업 - 열기" class="layer-open m-none">수업요청</a></li -->
                                <!-- 임시로 막음 -->
                                <li class="request"><a href="javascript:void(0)" onClick="lectReq()" title="수업요청 팝업 - 열기" class="m-none">수업요청</a></li>
                                <script type="text/javascript">$('.star .btn').addClass('two');</script>
                            </security:authorize>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="detail-anchor mobile">
                <div class="anchor-tab-area">
                    <div class="move-bar tab-action">
                        <span class="title-bar">${mentor.profTitle} <em>${mentor.nm}</em></span>
                        <ul class="tab-type1 tab05">
                            <li class="active"><a href="javascript:void(0);" onClick="tabChg(0);">멘토소개</a></li>
                            <li><a href="javascript:void(0);" onClick="tabChg(1);">문의하기</a></li>
                            <li><a href="javascript:void(0);" onClick="tabChg(2);">멘토자료</a></li>
                            <li><a href="javascript:void(0);" onClick="tabChg(3);">멘토수업</a></li>
                            <li><a href="javascript:void(0);" onClick="tabChg(4);">관련멘토</a></li>
                        </ul>
                    </div>
                </div>

                <div class="tab-action-cont"></div><!-- Tab 클릭 시 보이는 컨텐츠 -->

            </div>
        </div>
    </div>
</div>

<div class="cont-quick double">
    <!--a href="javascript:void(0)" onClick="fn_goList()"><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
    <a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>

<security:authorize access="isAuthenticated()">
    <div id="layerPopupDiv"></div>
    <script type="text/javascript">
    $().ready(function() {

        var params = $.param({"mbrNo" : "${mentor.mbrNo}", "mbrNm" : "${mentor.nm}", "jobNo" : "${mentor.jobNo}", "jobNm" : "${mentor.jobNm}"});

        $('#layerPopupDiv').load('${pageContext.request.contextPath}/layer/layerPopupLectureReq.do?' + params);
    });
    </script>
</security:authorize>


<script type="text/javascript">
    $(document).ready(function(){
        tabChg(0);

        // 관심멘토 등록
        $('#save-interest-mentor').click(function(e) {
            e.preventDefault();
            $.ajax({
                url: '${pageContext.request.contextPath}/ajax.saveMyInterestForMentor.do?itrstTargtNo=${mentor.mbrNo}',
                type: 'get',
                success: function(jsonData) {
                    if(jsonData.success){
                        alert(jsonData.data);
                        $("#interest-lesson").addClass("active");
                    }else{
                        alert(jsonData.message);
                    }
                }
            });
        });

        // 관심멘토로 등록했는지 판단
        $.ajax({
            url: "${pageContext.request.contextPath}/ajax.isMyInterestForMentor.do?itrstTargtNo=${mentor.mbrNo}",
            success: function(rtnData) {
                if(rtnData){
                    $("#interest-lesson").addClass("active");
                }
            }
        });

        // 프로필이미지 슬라이드
		$(function(){
			$('.bxslider1').sistarGallery({
				$animateTime_ : 500,
				$animateEffect_ : "easeInOutQuint",
				$autoDelay : 2000,
				$focusFade : 500,
				$currentNum : 1
			});
		});

    });

    function tabChg(number){
        $('.tab-action > ul > li').each(function(){
            $(this).removeClass('active');
        });
        $('.tab-action > ul > li').eq(number).addClass('active');

        switch (number) {
            case 0 :
                $('.tab-action-cont').load('${pageContext.request.contextPath}/mentor/mentorIntroduce/tabMentorIntroduce.do?mbrNo='+'${param.mbrNo}');
                break;
            case 1  :
                $('.tab-action-cont').load('${pageContext.request.contextPath}/mentor/mentorIntroduce/tabMentorQna.do?mbrNo='+'${param.mbrNo}');
                break;
            case 2  :
                $('.tab-action-cont').load('${pageContext.request.contextPath}/mentor/mentorIntroduce/tabMentorData.do?mbrNo='+'${param.mbrNo}');
                break;
            case 3  :
                $('.tab-action-cont').load('${pageContext.request.contextPath}/mentor/mentorIntroduce/tabMentorLecture.do?mbrNo='+'${param.mbrNo}');
                break;
            case 4  :
                $('.tab-action-cont').load('${pageContext.request.contextPath}/mentor/mentorIntroduce/tabMentorRelation.do?mbrNo='+'${param.mbrNo}');
                break;
        }
    }

    // 리스트 이동
    function fn_goList(){
        $('#frm').attr('action', '${pageContext.request.contextPath}/mentor/mentorIntroduce/listMentorIntroduce.do');
        $('#frm').attr('method', 'post');
        $('#frm').submit();
    }

    // 임시로 막음
    function lectReq(){
        alert('준비 중 입니다.');
    }
</script>