<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript">
$().ready(function() {
    $(document.body).on('click', '.layer-open', function(e) {
        e.preventDefault();
        var $this  = $(this);
        var $layer = $($this.attr('href') || null);
        $('body').addClass('dim');
        $layer.attr('tabindex',0).show().focus();
        $layer.find('.layer-close, .btn-area.popup a.cancel, .btn-type2.cancel, .btn-type2.popup').on('click',function (e) {
            e.preventDefault();
            $('body').removeClass('dim');
            $layer.hide();
            $this.focus();
        });
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
                <h2>직업소개</h2>

                <!-- React start -->
                <div id="job-info-contents">
                </div>
                <!-- React end -->

                <%-- <form:form action="${pageContext.request.contextPath}/mentor/jobIntroduce/listJobIntroduce.do" method="get" id="searchFrm">
                    <div class="review-tbl-wrap">
                        <div class="review-tbl">
                            <table>
                                <caption>직업소개 검색창 - 키워드,직업</caption>
                                <colgroup>
                                    <col class="size-tbl1" />
                                    <col class="size-tbl2" />
                                    <col class="size-tbl1" />
                                    <col />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row"><label for="schoolKeyword">키워드</label></th>
                                        <td>
                                            <div class="keyword-search">
                                                <select id="searchType" name="searchType" class="keyword-slt" title="키워드 종류">
                                                    <option value="all" <c:if test="${mentorSearchVo.searchType == 'all'}">selected="selected"</c:if>>전체 </option>
                                                    <option value="class" <c:if test="${mentorSearchVo.searchType == 'class'}">selected="selected"</c:if> >수업 </option>
                                                    <option value="mentor" <c:if test="${mentorSearchVo.searchType == 'mentor'}">selected="selected"</c:if> >멘토</option>
                                                    <option value="tag" <c:if test="${mentorSearchVo.searchType == 'tag'}">selected="selected"</c:if> >태그</option>
                                                    <option value="job" <c:if test="${mentorSearchVo.searchType == 'job'}">selected="selected"</c:if> >직업</option>
                                                </select>
                                                <input type="text" id="searchKeyWord" name="searchKeyWord" value="${mentorSearchVo.searchKeyWord }" class="keyword-inp" title="키워드입력란" />
                                            </div>
                                        </td>
                                        <th scope="row">직업</th>
                                        <td>
                                            <a href="#jobSearch" title="직업선택 팝업 - 열기" class="btn-job layer-open">직업선택</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn-area">
                            <a href="javaScript:searchKeyword();" class="btn-search"><span>검색</span></a>
                        </div>
                    </div>
                </form:form> --%>

                <%-- <form:form action="${pageContext.request.contextPath}/mentor/jobIntroduce/viewDetailJobIntroduce.do" method="get" id="jobFrm">
                    <input type="hidden" id="jobNo" name="jobNo"/>
                    <input type="hidden" id="jobClsfCd" name="jobClsfCd"/>
                </form:form> --%>

                <%-- <div>
                    <p class="result-total">검색 결과 총 <strong>${totalCnt}</strong> 건</p>
                    <div class="introduction-list">
                        <ul>
                         <c:forEach items="${resultList}" var="item">
                            <li>
                                <a href="javaScript:detailJobInfo('${item.jobNo }', '${item.jobClsfCd}' );">
                                    <dl class="introduction-info">
                                        <dt class="title">${item.jobNm }</dt>
                                        <dd class="info">${item.jobIntdcInfo }</dd>
                                        <dd class="icon"><span class="icon-total-mentor">멘토 ${item.mentorCnt}명</span></dd>
                                        <dd class="img"><img src="${item.jobPicInfo}" alt="국악인 인물사진"></dd>
                                    </dl>
                                </a>
                            </li>
                        </c:forEach>
                        </ul>
                    </div>
                    <div class="btn-more-view">
                        <a href="#">더 보기 (<span>00</span>)</a>
                    </div>
                </div> --%>
            </div>
        </div>

        <div class="cont-quick">
            <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
        </div>

        <!-- 직업검색 -->
        <%--
        <div class="layer-pop-wrap" id="jobSearch">
            <div class="layer-pop">
                <div class="layer-header">
                    <strong class="title">직업 선택</strong>
                </div>
                <div class="layer-cont">
                    <div class="box-style none-border">
                        <strong>특징 분류</strong>
                        <ul class="job-select-ul">
                            <li>
                                <label class="chk-skin">첨단&middot;정보(ICT)기술<em>(5)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">글로벌&middot;세계화 인재<em>(6)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">환경 관련 녹색직업<em>(11)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">잘 알려진 직업<em>(00)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">생소한 직업<em>(00)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">아시아나 교육기부<em>(00)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">감성,웰빙 트렌드<em>(9)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">기업가정신<em>(000)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                            <li>
                                <label class="chk-skin">대한민국명장 교육기부<em>(00)</em>
                                    <input type="checkbox" class="check-style" name="특징분류" />
                                </label>
                            </li>
                        </ul>

                        <strong>직업 분류</strong>
                        <div class="job-selection" style="position:relative;">
                            <ul class="job-select-ul other-btm">
                                <li>
                                    <label class="radio-skin">선택 안함
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">경영&middot;회계&middot;사무<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">금융&middot;보험<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">보건&middot;의료<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">사회 복지 및 종교<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">교육 및 자연과학, 사회과학 연구<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">영업 및 판매<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">경비 및 청소<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">법률&middot;경찰&middot;소방&middot;교도<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">전기&middot;전자<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">음식 서비스<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">문화&middot;예술&middot;디자인&middot;방송<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">화학<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">기계<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">정보통신<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">농림어업<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">건설<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">식품가공<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin other">군인<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin other">재료(금속&middot;유리&middot;점토&middot;시멘트)<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin other">환경&middot;인쇄&middot;목재&middot;가구&middot;공예 및<br /> 생산단순<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">섬유 및 의복<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">미용&middot;숙박&middot;여행&middot;오락&middot;스포츠<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li></li>
                                <li>
                                    <label class="radio-skin">운전 및 운송<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                                <li>
                                    <label class="radio-skin">관리<em>(5)</em>
                                    <input type="radio" name="job" />
                                    </label>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="btn-area border">
                        <a href="#" class="btn-type2 popup">확인</a>
                        <a href="#" class="btn-type2 cancel">취소</a>
                    </div>
                    <a href="#" class="layer-close">팝업 창 닫기</a>
                </div>
            </div>
        </div>
        --%>
        <!-- //직업검색 -->


<script type="text/javascript">
    function searchKeyword(){
        $("#searchFrm").attr("action","${pageContext.request.contextPath}/mentor/jobIntroduce/listJobIntroduce.do");
        $("#searchFrm").submit();
        return false;
    }

    function detailJobInfo(jobNo, jobClsfCd){

        alert("jobNo = "+jobNo);
        alert("jobClsfCd = "+jobClsfCd);

        $("#jobNo").val(jobNo);
        $("#jobClsfCd").val(jobClsfCd);

        $("#jobFrm").attr("action","${pageContext.request.contextPath}/mentor/jobIntroduce/viewDetailJobIntroduce.do");
        $("#jobFrm").submit();
    }
</script>
<script type="text/jsx;harmony=true" src="${pageContext.request.contextPath}/js/mentor/mentor.react.js"></script>
<%--
<script type="text/jsx;harmony=true">
//<![CDATA[
var JobInfo = React.createClass({
    render: function() {
        return (
        );
    }
});


var JobInfoSearch = React.createClass({
    render: function() {
        return (
            <div />
        );
    }
});

var JobInfoList = React.createClass({
    render: function() {
        return (
            <div>
                <h1>직업소개</h1>
            </div>
        );
    }
});

React.render(
    <JobInfoList />,
    document.getElementById('job-info-contents')
);
// ]]>
</script>
--%>

