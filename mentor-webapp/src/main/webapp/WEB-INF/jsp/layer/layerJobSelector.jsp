<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<!-- 직업검색 -->
<script type="text/javascript">
$().ready(function() {
    var callback = '${not empty param.callback ? param.callback : "jobLayerConfirm"}';

    $('#chrstcClsfSelector label:has(:checkbox:checked)')
        .addClass('checked');

    $('#jobClsfSelector label').removeClass('checked')
        .filter(':has(:radio:checked)').addClass('checked');

    $('#jobLayerConfirm').click(function(e) {
        e.preventDefault();
        $('.pop-close').click();

        if (callback) {
            eval(callback).call(null,
                    $.map($('#chrstcClsfSelector :checkbox:checked'), function(o) { return o.value; }) || [],
                    $('#jobClsfSelector :radio:checked').val() || ''
                );
        }
    });

    $('#jobLayerCancel').click(function(e) {
        e.preventDefault();
    });
});
</script>

<!-- 직업선택 레이어 -->
<div class="layer-pop-wrap w720" id="jobSearch">
    <div class="title">
        <strong>직업 선택</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont board">
        <div class="layer-pop-scroll">
            <div class="box-style job-select-wrap">
                <strong class="job-select-tit">특징 분류</strong>
                <ul class="job-select-ul" id="chrstcClsfSelector">
                    <spring:eval expression="@mentorCommonMapper.listChrstcClsf()" var="listChrstcClsf" />
                    <c:forEach items="${listChrstcClsf}" var="each" varStatus="vs">
                        <li>
                            <label class="chk-skin"><span class="job-wrap"><span>${each.chrstcNm}</span></span><em>(${each.mentorCnt})</em>
                                <input type="checkbox" class="check-style" name="chrstcClsfCds" value="${each.chrstcCd}"
                                        <c:if test="${cnet:contains(pageContext.request.parameterMap['chrstcClsfCds'], each.chrstcCd)}">checked="checked"</c:if>
                                    />
                            </label>
                        </li>
                    </c:forEach>
                </ul>

                <strong class="job-select-tit">직업 분류</strong>
                <div class="job-selection" style="position:relative;">
                    <ul class="job-select-ul other-btm" id="jobClsfSelector">
                        <li>
                            <label class="radio-skin checked">선택 안함
                                <input type="radio" name="jobClsfCd" value=""/>
                            </label>
                        </li>
                        <spring:eval expression="@mentorCommonMapper.listJobClsf()" var="listJobClsf" />
                        <c:forEach items="${listJobClsf}" var="each" varStatus="vs">
                            <li>
                                <label class="radio-skin" style="font-size: .9em; letter-spacing: -1.5px;"><span class="job-wrap"><span>${each.jobNm}</span></span><em>(${each.mentorCnt})</em>
                                    <input type="radio" name="jobClsfCd" value="${each.jobCd}"
                                            <c:if test="${param.jobClsfCd eq each.jobCd}">checked="checked"</c:if>
                                        />
                                </label>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
        <div class="btn-area type1">
            <a href="#" class="btn-type2" id="jobLayerConfirm">확인</a>
            <a href="#" class="btn-type2 gray">취소</a>
        </div>

    </div>
</div>
<!-- //직업검색 -->
