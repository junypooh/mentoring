<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

		<div id="container">
			<div class="location">
				<a href="#" class="home">HOME</a>
				<span class="first">마이페이지</span>
				<span>나의관심</span>
			</div>
			<div class="content sub">
				<h2 class="txt-type">나의관심</h2>
				<p class="tit-desc-txt">나의 관심으로 등록한 정보를 확인할 수 있습니다.</p>
				<div class="my_interest">
					<div>
						<ul class="tab-type1 tab02">
							<li class="active"><a href="javascript:void(0)" onclick="tabClick('lectr', $(this))" id="intrLectr">관심수업(${fn:length(interestLecture)})</a></li>
							<li><a href="javascript:void(0)" onclick="tabClick('mentor', $(this))" id="intrMentor">관심멘토(${fn:length(interestMentor)})</a></li>
						</ul>
						<div class="tab-action-cont">
							<!-- 관심수업 -->
							<div class="tab-cont active">
								<ul>
									<li>
										<ul id="contentBody">
										    <c:if test="${empty interestLecture}">
										    <li class="no-lesson-txt">등록된 관심수업이 없습니다.</li>
										    </c:if>
										    <c:forEach items="${interestLecture}" var="item" varStatus="vs">
											<li class="thumb">
												<a href="javascript:void(0)" class="set-up">설정</a>
												<div class="layer">
													<div>
														<span class="set-btn">
															<a href="javascript:void(0)">관심 해제 설정</a>
														</span>
														<ul>
															<li>
																<em>${item.lectTitle}</em>
																<a href="javascript:void(0)" onclick="deleteMyInterest('${item.itrstTargtCd}', '${item.itrstTargtNo}')">해제</a>
															</li>
														</ul>
													</div>
												</div>
												<div class="lesson">
													<span class="img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${item.fileSer}" onerror="this.src='${pageContext.request.contextPath}/images/mentor/bg_thumb_132x132.gif'" alt="${item.lectTitle}"></span>
													<strong class="title"><em>${item.lectTitle}</em></strong>
													<span class="day"><fmt:formatDate value="${item.regDtm}" pattern="yyyy.MM.dd"/></span>
													<strong class="name">${item.nm}</strong><span>${item.jobNm}</span>
													<a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${item.lectSer}&lectTims=${item.lectTims}&schdSeq=${item.schdSeq}" class="detail-view">자세히보기</a>
												</div>
											</li>
										    </c:forEach>
										</ul>
									</li>
								</ul>
								<div id="paging"></div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="cont-quick double">
			<!--a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
			<a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
		</div>
<%-- Template ================================================================================ --%>
<script type="text/html" id="listLectrInfo">
<li class="thumb">
    <a href="javascript:void(0)" class="set-up">설정</a>
    <div class="layer">
        <div>
            <span class="set-btn">
                <a href="javascript:void(0)">관심 해제 설정</a>
            </span>
            <ul>
                <li>
                    <em>\${lectTitle}</em>
                    <a href="javascript:void(0)" onclick="deleteMyInterest('\${itrstTargtCd}', '\${itrstTargtNo}')">해제</a>
                </li>
            </ul>
        </div>
    </div>
    <div class="lesson">
        <span class="img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${fileSer}" onerror="this.src='${pageContext.request.contextPath}/images/mentor/bg_thumb_132x132.gif'" alt="\${lectTitle}"></span>
        <strong class="title"><em>\${lectTitle}</em></strong>
        <span class="day">\${fn_date_to_string(regDtm)}</span>
        <strong class="name">\${nm}</strong><span>\${jobNm}</span>
        <a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectSer}&lectTims=\${lectTims}&schdSeq=\${schdSeq}" class="detail-view">자세히보기</a>
    </div>
</li>
</script>
<script type="text/html" id="listMentorInfo">
<li class="thumb">
    <a href="javascript:void(0)" class="set-up">설정</a>
    <div class="layer">
        <div>
            <span class="set-btn">
                <a href="javascript:void(0)">관심 해제 설정</a>
            </span>
            <ul>
                <li>
                    <em>\${nm}</em>
                    <a href="javascript:void(0)" onclick="deleteMyInterest('\${itrstTargtCd}', '\${itrstTargtNo}')">해제</a>
                </li>
            </ul>
        </div>
    </div>
    <div class="lesson">
        <span class="img"><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${fileSer}" onerror="this.src='${pageContext.request.contextPath}/images/mentor/bg_thumb_132x132.gif'" alt="\${nm}"></span>
        <strong class="title"><span class="mentor">\${nm}</span><em>\${jobNm}</em></strong>
        <span class="day">\${fn_date_to_string(regDtm)}</span>
        <a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=\${itrstTargtNo}" class="detail-view">자세히보기</a>
    </div>
</li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 5,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
            type: 'lectr',
            url: '${pageContext.request.contextPath}/myPage/myInterest/ajax.myInterestLecture.do',
            templateId: 'listLectrInfo'
        }
    };

    mentor.PageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:search, totalRecordCount:0, recordCountPerPage:5,pageSize:10}),
            document.getElementById('paging')
    );

    $(document).ready(function(){
        setBtn();
        dataSet.params.totalRecordCount = ${fn:length(interestLecture)};
        mentor.PageNavi.setData(dataSet.params);
    });

    // 설정 버튼 컨트롤
    function setBtn() {
        var selectBtn = $('.my_interest ul li a.set-up');

        selectBtn.on('click', function(e) {
            e.preventDefault();
            if(!$(this).hasClass('active')){
                $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
                $(this).addClass('active');

            }else{
                $(this).removeClass('active');
            }
        });
    }

    function tabClick(type, obj) {
        var _this = obj.parent('li');
        _this.addClass('active').siblings().removeClass('active');

        dataSet.params.type = type;
        if(type == 'lectr') {
            dataSet.params.url = '${pageContext.request.contextPath}/myPage/myInterest/ajax.myInterestLecture.do';
            dataSet.params.templateId = 'listLectrInfo';
        } else {
            dataSet.params.url = '${pageContext.request.contextPath}/myPage/myInterest/ajax.myInterestMentor.do';
            dataSet.params.templateId = 'listMentorInfo';
        }

        search(1);
    }

    function search(curPage) {
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        $.ajax({
            url: dataSet.params.url,
            data : $.param(dataSet.params, true),
            success: function(rtnData) {
                $("#contentBody").empty();

                var totalCount = 0;
                var emptyMsg = '';
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                if(dataSet.params.type == 'lectr') {
                    $('#intrLectr').html("관심수업(" + totalCount + ")");
                    emptyMsg = '등록된 관심수업이 없습니다.';
                } else {
                    $('#intrMentor').html("관심멘토(" + totalCount + ")");
                    emptyMsg = '등록된 관심멘토가 없습니다.';
                }
                if(totalCount > 0) {
                    $("#" + dataSet.params.templateId).tmpl(rtnData).appendTo("#contentBody");
                } else {
                    $("#contentBody").append('<li class="no-lesson-txt">' + emptyMsg + '</li>')
                }

                dataSet.params.totalRecordCount = totalCount;

                mentor.PageNavi.setData(dataSet.params);
                setBtn();

            }
        });
    }

    function deleteMyInterest(itrstTargtCd, itrstTargtNo){
        $.ajax({
            url: "ajax.deleteMyInterest.do",
            data : {"itrstTargtCd":itrstTargtCd,"itrstTargtNo":itrstTargtNo},
            success: function(rtnData) {
                search(dataSet.params.currentPageNo);
            }
        });
    }
</script>