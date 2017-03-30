<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />

<script type="text/javascript">
mentor.totalRecordCount = Number('${not empty mentorList ? mentorList[0].totalRecordCount : 0}');
mentor.currentPageNo = Number('${mentorSearch.currentPageNo}');
mentor.recordCountPerPage = Number('${mentorSearch.recordCountPerPage}');

$().ready(function() {

    // 검색 버튼
    $('#mentorSearchBtn').click(function() {
        $(this).closest('form').submit();
    });

    // 페이지 이동
    var goPage = mentor.goPage =function(pageNo) {
        $('#currentPageNo').val(pageNo);
        //$('#mentorSearchBtn').click();
        $('#belongMentorData').load('belongMentorList.do #belongMentorData', $('#mentorSearchForm').serialize());
    };

    $('#reload').click(function(e) {
        $('#belongMentorData').load('belongMentorList.do #belongMentorData', $('#mentorSearchForm').serialize());
        mentor.pageNavi.setData({totalRecordCount: ++mentor.totalRecordCount});
    }).hide();
});

function jobLayerConfirmCallback() {
}

function insertMentorConfirm() {
    $('#belongMentorData').load('belongMentorList.do #belongMentorData', $('#mentorSearchForm').serialize());
    mentor.pageNavi.setData({totalRecordCount: ++mentor.totalRecordCount});
}
</script>
<a href='#' id="reload">리로드</a>

<script type="text/jsx;harmony=true">
mentor.pageNavi = React.render(
    React.createElement(PageNavi, {
        pageFunc: mentor.goPage,
        totalRecordCount: mentor.totalRecordCount,
        currentPageNo: mentor.currentPageNo,
         recordCountPerPage: mentor.recordCountPerPage,
        contextPath: '${pageContext.request.contextPath}',
    }),
    $('.paging-btn > div')[0]
);
</script>


<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>멘토관리</span>
    </div>

    <form:form modelAttribute="mentorSearch" action="${pageContext.request.contextPath}/mentor/belongMentor/belongMentorList.do" method="get" id="mentorSearchForm">
        <form:hidden path="currentPageNo" />
        <form:hidden path="recordCountPerPage" />
        <div class="content">
            <h2>멘토관리</h2>
            <div class="cont">
                <div class="calculate-management">
                    <div class="search-box management">
                        <dl class="mentor-search">
                            <dt>직업</dt>
                            <dd><a href="#jobSearch" class="btn-type1 layer-open">직업선택</a></dd>
                            <dt>멘토명</dt>
                            <dd>
                                <input type="hidden" name="searchType" value="nm" />
                                <form:input path="searchKey" class="inp-style1" style="width:203px;" />
                            </dd>
                        </dl>
                        <div class="btn-area">
                            <a href="#" class="btn-search" id="mentorSearchBtn"><span>검색</span></a>
                        </div>
                    </div>
                    <div class="board-type1">
                        <span class="excel-file-down"><a href="excel.belongMentorList.do">엑셀파일 다운로드</a></span>
                        <table id="belongMentorData">
                            <caption>정산관리 - 번호, 아이디, 멘토명, 직업명, 상태, 성별, 정상/탈퇴, 등록일</caption>
                            <colgroup>
                                <col style="width:10%;" />
                                <col style="width:12%;" />
                                <col style="width:16%;" />
                                <col />
                                <col style="width:10%;" />
                                <col style="width:10%;" />
                                <col style="width:10%;" />
                                <col style="width:17%;" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">번호</th>
                                    <th scope="col">아이디</th>
                                    <th scope="col">멘토명</th>
                                    <th scope="col">직업명</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">정상/탈퇴</th>
                                    <th scope="col">성별</th>
                                    <th scope="col">등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${mentorList}" var="eachObj" varStatus="vs">
                                    <tr>
                                        <td>${mentorList[0].totalRecordCount - (eachObj.rn - 1)}</td>
                                        <td class="al-left"><a href="${pageContext.request.contextPath}/mentor/belongMentor/belongMentorShow.do?mbrNo=${eachObj.mbrNo}" target="_self">${eachObj.id}</a></td>
                                        <td><a href="${pageContext.request.contextPath}/mentor/belongMentor/belongMentorShow.do?mbrNo=${eachObj.mbrNo}" target="_self">${eachObj.nm}</a></td>
                                        <td class="al-left job">${eachObj.jobNm}</td>
                                        <td>${eachObj.loginPermYn}</td>
                                        <td>${eachObj.mbrStatNm}</td>
                                        <td>
                                            <c:if test="${code['CD100322_100323_남자'] eq eachObj.genCd}">남</c:if>
                                            <c:if test="${code['CD100322_100324_여자'] eq eachObj.genCd}">여</c:if>
                                        </td>
                                        <td><fmt:formatDate value="${eachObj.regDtm}" pattern="yyyy.MM.dd" /></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="paging-btn">
                    <div style="height: 21px;"><!-- 페이징 들어가는 위치 --></div>
                    <span class="r-btn"><a href="#insertMentorLayer" class="btn-type1 layer-open">멘토등록</a></span>
                </div>
            </div>
        </div>
        <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>

        <%-- 직업선택 레이어 --%>
        <jsp:include page="/WEB-INF/jsp/layer/layerJobSelector.jsp">
            <jsp:param name="callback" value="jobLayerConfirmCallback" />
        </jsp:include>
    </form:form>
</div>

<!-- 멘토 등록 -->
<jsp:include page="/WEB-INF/jsp/layer/layerPopupInsertMentor.jsp">
    <jsp:param name="callback" value="insertMentorConfirm" />
</jsp:include>
