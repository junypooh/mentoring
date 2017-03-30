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
        $('.layer-close').click();

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

<div class="layer-pop-wrap my-class-reg" id="jobSearch">
    <div class="layer-pop m-blind">
        <div class="layer-header">
            <strong class="title">직업 선택</strong>
        </div>
        <div class="layer-cont">
            <div class="layer-pop-scroll">
                <div class="box-style none-border">
                    <strong>특징 분류</strong>
                    <c:choose>
                        <c:when test="${param.type eq 'jobIntroduce'}"> (직업수)</c:when>
                        <c:otherwise>(멘토수)</c:otherwise>
                    </c:choose>
                    <ul class="job-select-ul" id="chrstcClsfSelector">
                        <c:choose>
                            <c:when test="${param.type eq 'jobIntroduce'}">
                                <spring:eval expression="@mentorCommonMapper.listChrstcClsfInfo()" var="listChrstcClsf" />
                            </c:when>
                            <c:otherwise>
                                <spring:eval expression="@mentorCommonMapper.listChrstcClsf()" var="listChrstcClsf" />
                            </c:otherwise>
                        </c:choose>
                        <c:forEach items="${listChrstcClsf}" var="each" varStatus="vs">
                            <li>
                                <label class="chk-skin" title="${each.chrstcNm}"><span class="job-wrap"><span>${each.chrstcNm}</span></span><em>(${each.mentorCnt})</em>
                                    <input type="checkbox" class="check-style" name="chrstcClsfCds" value="${each.chrstcCd}"
                                            <c:if test="${cnet:contains(pageContext.request.parameterMap['chrstcClsfCds'], each.chrstcCd)}">checked="checked"</c:if>
                                        />
                                </label>
                            </li>
                        </c:forEach>
                    </ul>

                    <strong>직업 분류</strong>
                    <c:choose>
                        <c:when test="${param.type eq 'jobIntroduce'}"> (직업수)</c:when>
                        <c:otherwise>(멘토수)</c:otherwise>
                    </c:choose>
                    <div class="job-selection" style="position:relative;">
                        <ul class="job-select-ul other-btm" id="jobClsfSelector">
                            <li>
                                <label class="radio-skin" title="선택 안함">선택 안함
                                    <input type="radio" name="jobClsfCd" value="" <c:if test="${empty param.jobClsfCd}">checked="checked"</c:if> />
                                </label>
                            </li>
                            <c:choose>
                                <c:when test="${param.type eq 'jobIntroduce'}">
                                    <spring:eval expression="@mentorCommonMapper.listJobClsfInfo()" var="listJobClsf" />
                                </c:when>
                                <c:otherwise>
                                    <spring:eval expression="@mentorCommonMapper.listJobClsfInfoStndMento()" var="listJobClsf" />
                                </c:otherwise>
                            </c:choose>
                            <c:forEach items="${listJobClsf}" var="each" varStatus="vs">
                                <li>
                                    <label class="radio-skin" title="${each.jobNm}"><span class="job-wrap"><span>${each.jobNm}</span></span><em>(${each.mentorCnt})</em>
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
            <div class="btn-area border">
                <a href="#" class="btn-type2 popup" id="jobLayerConfirm">확인</a>
                <a href="#" class="btn-type2 cancel" id="jobLayerCancel">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<!-- //직업검색 -->