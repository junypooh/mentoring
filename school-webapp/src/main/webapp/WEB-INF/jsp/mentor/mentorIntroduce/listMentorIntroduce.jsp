<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div id="container">
    <div class="location">
        <a href="#" class="home">HOME</a>
        <span class="first">멘토</span>
        <span>멘토소개</span>
    </div>
    <div class="content sub">
        <h2>멘토소개</h2>
        <div class="review-tbl-wrap">
            <div class="review-tbl">
                <table>
                    <caption>멘토소개 검색창 - 수업상태, 성별, 키워드,직업</caption>
                    <colgroup>
                        <col class="size-tbl1" />
                        <col class="size-tbl2" />
                        <col class="size-tbl1" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="lessonCondition">수업상태</label></th>
                            <td>
                                <div class="selectbox-zindex-wrap"><!-- 2015-11-16 추가 -->
                                    <select id="lectStatCd">
                                        <option value="">전체</option>
                                        <option value="101543" <c:if test="${param.lectStatCd eq '101543'}">selected</c:if>>수강모집</option>
                                        <option value="101548" <c:if test="${param.lectStatCd eq '101548'}">selected</c:if>>수업예정</option>
                                        <option value="101549" <c:if test="${param.lectStatCd eq '101549'}">selected</c:if>>수업대기</option>
                                        <option value="101550" <c:if test="${param.lectStatCd eq '101550'}">selected</c:if>>수업중</option>
                                        <option value="101551" <c:if test="${param.lectStatCd eq '101551'}">selected</c:if>>수업완료</option>
                                    </select>
                                </div>
                            </td>
                            <th scope="row"><label for="mentorSex">성별</label></th>
                            <td>
                                <div class="selectbox-zindex-wrap"><!-- 2015-11-16 추가 -->
                                    <select id="genCd">
                                        <option value="">전체</option>
                                        <option value="100323" <c:if test="${param.genCd eq '100323'}">selected</c:if>>남자</option>
                                        <option value="100324" <c:if test="${param.genCd eq '100324'}">selected</c:if>>여자</option>
                                    </select>
                                    <div class="selectbox-zindex-box">
                                        <div></div>
                                        <iframe scrolling="no" title="빈프레임" frameborder="0"></iframe>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="schoolKeyword">키워드</label></th>
                            <td>
                                <div class="keyword-search">
                                    <select id="searchKey" class="keyword-slt" title="키워드 종류">
                                        <option value="">전체</option>
                                        <option value="mentor" <c:if test="${param.searchKey eq 'mentor'}">selected</c:if>>멘토</option>
                                        <option value="jobNm" <c:if test="${param.searchKey eq 'jobNm'}">selected</c:if>>직업</option>
                                    </select>
                                    <input type="text" id="searchWord" class="keyword-inp" title="키워드입력란" value="${param.searchWord}" />
                                </div>
                            </td>
                            <th scope="row">직업</th>
                            <td>
                                <a href="#jobSearch" title="직업선택 - 열기" class="btn-job layer-open m-none">직업선택</button>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">직업명</th>
                            <td colspan="3">
                                <ul class="btn-dic">
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
                <a href="javascript:fn_btnSearch()" class="btn-search"><span>검색</span></a>
                <a href="javascript:fn_againSearch()" class="btn-reload"><span>다시검색</span></a>
            </div>
        </div>
        <div class="introduction-list mentor">
            <div class="result-total-wrap">
                <div class="result-total-top">
                    <span class="result-class">
                        <span></span>
                        <p class="result-total">검색결과 총 :  <strong>19</strong> 명</p>
                    </span>
                </div>
            </div>
            <ul id="mentorList"></ul>
        </div>
        <div class="paging" id="paging"></div>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layer/layerJobSelector.jsp">
    <jsp:param name="callback" value="jobLayerConfirmCallback" />
    <jsp:param name="jobClsfCd" value="${param.jobClsfCd}" />
    <jsp:param name="chrstcClsfCds" value="${param.chrstcClsfCds}" />
</jsp:include>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listMentorInfo">
    <li>
        <a href="javascript:void(0)" onClick="fn_mentorDetail(\${mbrNo})">
            <dl class="introduction-info">
                <dt class="title">\${nm}</dt>
                <dd class="info">\${profTitle}</dd>
                <dd class="job">\${fnNmLength(jobNm)}</dd>
                <dd class="desc">
                    {{if jobStruct3 != null && jobChrstcCdNm != null}}
                        \${jobStruct3}/\${jobChrstcCdNm}
                    {{else jobStruct3 != null && jobChrstcCdNm == null}}
                        \${jobStruct3}
                    {{else}}
                        \${jobChrstcCdNm}
                    {{/if}}
                </dd>
                <dd class="img">
                    {{if profFileSer != null}}
                        <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=\${profFileSer}" alt="\${nm} 인물사진">
                    {{/if}}
                </dd>
            </dl>
        </a>
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={dataSet.params.pageSize} contextPath={mentor.contextpath} />,
                 document.getElementById('paging')
             );
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 9,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10
        },
        data: {}
    };
    mentor.mentorDataSet = dataSet;

    if(${isMobile}){
        dataSet.params.pageSize = 5;
    }

    $(document).ready(function(){
        enterFunc($("#searchWord"), fn_search);
        fn_search();
    });

    function fn_search(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'lectStatCd' : $('#lectStatCd').val()
              , 'genCd' : $('#genCd').val()
              , 'searchWord' : $('#searchWord').val()
              , 'searchKey' : $('#searchKey').val()
              , 'chrstcClsfCds': $.map($('#chrstcClsfSelector :checkbox:checked'), function(o) { return o.value; })
              , 'jobClsfCd': $('#jobClsfSelector :radio:checked').val()
              , 'consonantsVal' : dataSet.params.consonantsVal
        }, dataSet.params);
        dataSet.data = _param;

        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.selectMentorList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                $("#mentorList").empty();
                $("#listMentorInfo").tmpl(rtnData).appendTo("#mentorList");
                $('.result-total > strong').text(totalCount);
                $('.btn-more-view > a > span').text(totalCount);

                mentor.pageNavi.setData(dataSet.params);

                classifySet(_param);
            }
        });
    }

    // 절삭
    function fnNmLength(obj){
        if(obj == null){
            return "";
        }
        if(obj.length > 20){
            obj = obj.substr(0, 20)+"...";
        }
        return obj;
    }

    // 직업명 초성검색
    $('.btn-dic li').click(function(){
        var idx = $('.btn-dic li').index(this);

        if($('.btn-dic li').eq(idx).find('a').hasClass('on')){
            $('.btn-dic li').eq(idx).find('a').removeClass();
            dataSet.params.consonantsVal = '';
        }else{
            $('.btn-dic > li > a').removeClass();
            $('.btn-dic li').eq(idx).find('a').addClass('on');
            var consonantsVal = $('.btn-dic li').eq(idx).find('a').attr('data');
            dataSet.params.consonantsVal = consonantsVal;
        }
    });

    // 레이어 콜백
    function jobLayerConfirmCallback(chrstcClsfCds, jobClsfCd) {
    }

    // 검색조건분류 화면에 표시하기
    function classifySet(_param){
        if(_param.chrstcClsfCds.length > 0 || _param.jobClsfCd.length > 0){
            var ls = [];
            // 특징분류
            $.each(_param.chrstcClsfCds, function(i, v){
                var el = $('#chrstcClsfSelector label:has(:checkbox[value=' + v + '])');
                if (!el.length) {
                    return;
                }
                ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
            });

            // 직업 분류
            if (_param.jobClsfCd.length > 0) {
                var el = $('#jobClsfSelector label:has(:radio[value=' + _param.jobClsfCd + '])');
                if (el.length) {
                    ls.push($('<a href="#">' +  el.find('.job-wrap').text() + '</a>'));
                }
            }
            $('.result-total-wrap').find('.result-class > span').empty().append(ls).end().css({visibility: 'visible'});
        }else{
            $('.result-total-wrap').find('.result-class > span').empty();
        }

    }

    // 검색버튼 클릭
    function fn_btnSearch(){
        if(validation()){
            fn_search(1);
        }
    }

    // 밸리데이션 체크
    function validation(){
        if ($('#searchWord').val() && $('#searchWord').val().length < 2) {
            alert('키워드는 2글자 이상 입력해주세요.');
            return false;
        }

        return true;
    }

    // 멘토소개 상세 이동
    function fn_mentorDetail(mbrNo){
        location.href = '${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo='+mbrNo+'&'+$.param(dataSet.data, true);
    }

    // 다시검색 버튼 클릭
    function fn_againSearch(){
        // 검색조건 초기화
        $('.btn-dic > li > a').removeClass();
        $('#lectStatCd').val('');
        $('#genCd').val('');
        $('#searchWord').val('');
        $('#searchKey').val('');
        dataSet.params.consonantsVal = null;

        // 레이어 초기화
        $('.chk-skin').removeClass('checked');
        $('input:checkbox[name="chrstcClsfCds"]').prop('checked', false);
        $('input:radio[name="jobClsfCd"]').removeAttr('checked');
        $('label.radio-skin').eq(0).trigger('click');

        fn_search();
    }

</script>