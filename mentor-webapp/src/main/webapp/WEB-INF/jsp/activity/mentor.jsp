<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:eval expression="T(kr.or.career.mentor.util.EgovProperties).getProperty('MENTORING_SCHOOL')" var="SCHOOL_DOMAIN" />

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<jsp:useBean id="now" class="java.util.Date" />

		<div id="container">
			<div class="location">
				<a href="#" class="home">메인으로 이동</a>
				<span>활동멘토</span>
				<span>활동멘토</span>
			</div>
			<div class="content">
				<h2>활동멘토</h2>
				<div class="cont">
					<h3 class="sub-tit">원격진로멘토링 생생후기</h3>
					<div class="tab-action">
                    <ul class="sub-tab tab03">
                        <li class="active"><a href="#">실패를 두려워 말고 도전하라!</a></li>
                        <li><a href="#">과거에 없던 진로교육, 효과를 발휘하다</a></li>
                        <li><a href="#">알찬 시간, 산들바람 진로멘토링</a></li>
                    </ul>

                    <div class="tab-action-cont">
                        <!-- tab01 -->
                        <div class="tab-cont active">
                            <div class="act-mento-cont">
                                <div class="act-info">
                                    <span class="act-pic"><img src="${pageContext.request.contextPath}/images/active_mento/1.jpg" alt="비보이 이준학" /></span>
                                    <div class="act-desc">
                                        <p class="act-job">비보이</p>
                                        <p class="act-nm"><span>이준학</span>멘토</p>
                                        <!--<p class="act-slogan">실패를 두려워 말고 도전하라!</p>-->
                                        <p class="act-state">저는 통합예술 공연을 통하여 대한민국의 많은 학생들이 비보잉을 접하고, 즐길 수 있도록 노력하고 있습니다. 산들바람 진로멘토링 사업을 통해서 비보잉에 대한 소개할 수 있었고, 저 스스로 발전하는 계기가 되었습니다. 앞으로도 기회가 된다면 지속적으로 참여하고 싶습니다.</p>
                                    </div>
                                </div>
                                <div class="review-box">
                                    <p class="tit-review">학생들에게 한마디</p>
                                    <!--<p class="sub-tit-review">실패를 두려워 말고 도전하라!</p>
                                    <p class="mentee-nm">세종중학교 김학생</p>-->
                                    <p class="txt-review">
                                        저는 지금까지 21년이라는 시간동안 비보이 예술가로 살아오고 있습니다. 단순 비보이 공연 외에도 기획, 교육 등 다양한 분야로 제 꿈을 확장하고 있습니다. 여러분도 실패를 두려워하지 말고 도전하세요! 언제나 즐기며 긍정적으로 임한다면 꿈을 이룰 수 있을 것입니다.
                                        <!--<a href="#" class="more">더보기</a>-->
                                    </p>
                                </div>
                            </div>
                        </div>
                        <!-- tab02 -->
                        <div class="tab-cont">
                            <div class="act-mento-cont">
                                <div class="act-info">
                                    <span class="act-pic"><img src="${pageContext.request.contextPath}/images/active_mento/2.jpg" alt="아쿠아리스트 조원규 사진" /></span>
                                    <div class="act-desc">
                                        <p class="act-job">아쿠아리스트</p>
                                        <p class="act-nm"><span>조원규</span>멘토</p>
                                        <!--<p class="act-slogan">실패를 두려워 말고 도전하라!</p>-->
                                        <p class="act-state">과거에는 없었던 진로교육이 지금의 어린 학생들에게 실시되고 있다는 것은 매우 바람직하게 생각되고 저 또한 여기에 동참할 수 있어 큰 보람을 느낍니다. 추후 더욱더 효과적이고 발전된 형태로 학생들에게 도움을 줄 수 있는 프로그램이 되었으면 좋겠습니다.</p>
                                    </div>
                                </div>
                                <div class="review-box">
                                    <p class="tit-review">학생들에게 한마디</p>
                                    <!--<p class="sub-tit-review">과거에 없던 진로교육, 효과를 발휘하다</p>
                                    <p class="mentee-nm">세종중학교 김학생</p>-->
                                    <p class="txt-review">
                                        열심히 노력하셔서 꼭 자신이 원하는 바를 이루시기를 바랍니다. 포기하지 마시고 끝까지 도전하시면 언젠간 꼭 이루어진답니다.^^
                                    </p>
                                </div>
                            </div>
                        </div>
                        <!-- tab03 -->
                        <div class="tab-cont">
                            <div class="act-mento-cont">
                                <div class="act-info">
                                    <span class="act-pic"><img src="${pageContext.request.contextPath}/images/active_mento/3.jpg" alt="아나운서 강주형 사진" /></span>
                                    <div class="act-desc">
                                        <p class="act-job">아나운서</p>
                                        <p class="act-nm"><span>강주형</span>멘토</p>
                                        <!--<p class="act-slogan">실패를 두려워 말고 도전하라!</p>-->
                                        <p class="act-state">보통은 온라인이 아닌 오프라인 멘토링을 많이 진행했는데 원격으로 진행하니 이동거리가 줄어들어 그 만큼 더 많은 학생들과 함께 할 수 있어서 좋았습니다. 또한 수업 커리큘럼이 명확하고 구성이 좋아서 다른 멘토링에 비해 훨씬 알찬 시간이 되는 것 같아 만족스러웠습니다. 감사합니다. </p>
                                    </div>
                                </div>
                                <div class="review-box">
                                    <p class="tit-review">학생들에게 한마디</p>
                                    <!--<p class="sub-tit-review">알찬 시간, 산들바람 진로멘토링</p>
                                    <p class="mentee-nm">세종중학교 김학생</p>-->
                                    <p class="txt-review">
                                        진로를 정하는데 있어 얼마만큼의 정보를 얻을 수 있느냐도 중요하지만, 보다 많은 것들을 경험하고 도전해 보는 것이 중요한 것 같습니다. 그를 위해 저도 학생 여러분들께 조금이나마 도움이 되기 위해 앞으로 최선을 다하겠습니다.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
					<div class="field-mento">
						<div class="top-util">
							<h3 class="sub-tit">분야별 활동멘토</h3>
							<span class="count-num">총 활동멘토 <em id="totCount">0</em>명</span>
							<div class="search-box">
								<input type="text" class="inp-style1" id="searchValue" placeholder="검색어를 입력하세요">
								<a href="javascript:void(0)" onclick="searchActivityMentor()" class="btn-search small"><span>검색</span></a>
							</div>
						</div>
						<ul class="field-mento-list" id="listBody">
						    <li class="on" data=""><a href="javascript:void(0)" onclick="clickJobClsf($(this))" title="전체"><span class="txt-hid">전체</span><span class="count" id="totMCount">(0)</span></a></li>
						    <spring:eval expression="@mentorCommonMapper.listJobClsfInfoStndMento()" var="listJobClsf" />
							<c:set var="count" value="0" />
                            <c:forEach items="${listJobClsf}" var="each" varStatus="vs">
                            <c:set var="count" value="${count + each.mentorCnt}" />
                            <li data="${each.jobCd}|${each.jobNm}|${each.mentorCnt}"><a href="javascript:void(0)" onclick="clickJobClsf($(this))" title="${each.jobNm}"><span class="txt-hid">${each.jobNm}</span><span class="count">(${each.mentorCnt})</span></a></li>
                            </c:forEach>
						</ul>
						<script type="text/javascript">
						    $('#totMCount').html('(' + ${count} + ')');
						    $('#totCount').html(${count});

                            $('#listBody').find('li').each(function() {
                                if($(this).hasClass('on')) {
                                    $(this).attr('data', '100040|전체 활동멘토|${count}')
                                }
                            });
						</script>
						<div class="field-result-area">
							<p class="field-result-txt"><strong id="jobNm">교육및 자연,사회과학</strong>현재 <em id="mentorCount">16</em> 명 활동 중</p>
							<ul class="field-result-list" id="mentorList"></ul>
							<div id="paging"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
		</div>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listJobClsfInfo">
    <li data="\${jobCd}|\${jobNm}|\${mentorCnt}"><a href="javascript:void(0)" title="\${jobNm}" onclick="clickJobClsf($(this))"><span class="txt-hid">\${jobNm}</span><span class="count">(\${mentorCnt})</span></a></li>
</script>
<script type="text/html" id="listMentorInfo">
    <li>
        <a href="${SCHOOL_DOMAIN}mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=\${mbrNo}" target="_blank">
            <span class="field-img">
                {{if profFileSer != null }}
                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${profFileSer}" onerror="this.src='${pageContext.request.contextPath}/images/active_mento/img_act_mento_default.jpg'" alt="\${jobNm} \${nm} 사진" />
                {{else}}
                <img src="${pageContext.request.contextPath}/images/active_mento/img_act_mento_default.jpg" alt="사진" />
                {{/if}}
            </span>
            <div class="field-txt">
                <p class="field-job">\${jobNm}</p>
                <p class="field-nm"><em>\${nm}</em>멘토</p>
                <p class="field-desc">\${lectTitle}</p>
            </div>
        </a>
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={showMentors} totalRecordCount={0} currentPageNo={1} recordCountPerPage={15} pageSize={10} />,
                 document.getElementById('paging')
             );
</script>
<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 15,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function() {
        enterFunc($("#searchValue"), searchActivityMentor);
        showMentors();
    });

    // 검색
    function searchActivityMentor() {
        //if($('#searchValue').val()) {
            $.ajax({
                url: '${pageContext.request.contextPath}/activity/ajax.jobClsfInfoSearch.do',
                data : { value: $('#searchValue').val() },
                success: function(rtnData) {

                    var count = 0;
                    $.each(rtnData, function() {
                        count += this.mentorCnt;
                    });

                    $("#listBody").empty().append('<li class="on" data=""><a href="javascript:void(0)" onclick="clickJobClsf($(this))" title="전체"><span class="txt-hid">전체</span><span class="count" id="totMCount">(0)</span></a></li>');
                    $("#listJobClsfInfo").tmpl(rtnData).appendTo("#listBody");

                    $('#totMCount').html('(' + count + ')');
                    $('#totCount').html(count);
                    $('#mentorCount').html(count);

                    $('#listBody').find('li').each(function() {
                        if($(this).hasClass('on')) {
                            $(this).attr('data', '100040|' + $('#searchValue').val() + '|' + count)
                        }
                    });

                    showMentors();
                }
            });
        //}
    }

    // 직업 분야 클릭 이벤트
    function clickJobClsf(obj) {

        $('#listBody').find('li').each(function(idx) {
            if($(this).hasClass('on')) {
                $(this).removeClass('on');
            }
        });
        obj.parents('li').addClass('on');
        showMentors();
    }

    // 현재 활성화 되어있는 직업 분야의 멘토 정보 노출
    function showMentors(curPage) {
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        $('#listBody').find('li').each(function() {
            if($(this).hasClass('on')) {
                var data = $(this).attr('data').split('|');
                if($("#searchValue").val() != '') {
                    $('#jobNm').text($("#searchValue").val());
                } else {
                    $('#jobNm').text(data[1]);
                }
                $('#mentorCount').text(data[2]);

                var _param = jQuery.extend({'searchKey':$("#searchValue").val()
                                            ,'clsfCd':data[0]}, dataSet.params);

                $.ajax({
                    url: '${pageContext.request.contextPath}/activity/ajax.activityMentors.do',
                    data : $.param(_param, true),
                    success: function(rtnData) {
                        $("#mentorList").empty();
                        $("#listMentorInfo").tmpl(rtnData).appendTo("#mentorList");

                        var totalCount = 0;
                        if(rtnData.length > 0) {
                            totalCount = rtnData[0].totalRecordCount;
                        }
                        dataSet.params.totalRecordCount = totalCount;

                        mentor.pageNavi.setData(dataSet.params);
                    }
                });
            }
        });
    }
</script>