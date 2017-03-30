<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>멘토회원</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>멘토회원관리</li>
            <li>멘토회원</li>
        </ul>
    </div>
    <form:form modelAttribute="user" id="mentorBaseForm" action="${pageContext.request.contextPath}/member/mentor/mentor/editSubmit.do">
    <form:hidden path="mbrNo" />
    <c:forEach items="${user.mbrpropicInfos}" var="eachObj" varStatus="vs">
    <form:hidden path="mbrpropicInfos[${vs.index}].fileSer" />
    </c:forEach>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-mento-modify">
            <colgroup>
                <col style="width:147px;" />
                <col style="width:100px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">아이디</th>
                    <td colspan="2">${user.id}</td>
                </tr>
                <tr>
                    <th scope="col">이름 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <input type="text" name="username" id="username" class="text mr10" value="${user.username}" />
                        <c:if test="${empty user.genCd}">
                            <c:set target="${user}" property="genCd" value="${codeConstants['CD100322_100323_남자']}" />
                        </c:if>
                        <label>
                            <input type="radio" name="gender" ${codeConstants['CD100322_100323_남자'] eq user.genCd ?'checked="checked"':''} value="${codeConstants['CD100322_100323_남자']}" /> 남
                        </label>
                        <label>
                            <input type="radio" name="gender" ${codeConstants['CD100322_100324_여자'] eq user.genCd ?'checked="checked"':''} value="${codeConstants['CD100322_100324_여자']}" /> 여
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="col">생년월일 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <form:hidden path="birthday" />
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
                        <select id="birth-year">
                        <c:forEach begin="${1}" end="${70}" var="item">
                            <option value="${year - item}" <c:if test="${cnet:substring(user.birthday, 0, 4) eq (year - item)}">selected="selected"</c:if>>${year-item}년</option>
                        </c:forEach>
                        </select>
                        <select id="birth-month">
                        <c:forEach begin="${1}" end="${12}" var="item">
                            <option value="${item}" <c:if test="${cnet:substring(user.birthday, 4, 6) eq cnet:leftPad((item), 2, '0')}">selected="selected"</c:if>>${item}월</option>
                        </c:forEach>
                        </select>
                        <select id="birth-day" class="mr10">
                        <c:forEach begin="${1}" end="${31}" var="item">
                            <option value="${item}" <c:if test="${cnet:substring(user.birthday, 6, 8) eq cnet:leftPad((item), 2, '0')}">selected="selected"</c:if>>${item}일</option>
                        </c:forEach>
                        </select>
                        <c:if test="${empty user.lunarYn}">
                            <c:set target="${user}" property="lunarYn" value="N" />
                        </c:if>
                        <label>
                            <form:radiobutton path="lunarYn" value="N" /> 양력
                        </label>
                        <label>
                            <form:radiobutton path="lunarYn" value="Y" /> 음력
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="col">휴대전화</th>
                    <td colspan="2" class="mobile">
                        <form:hidden path="mobile" />
                        <spring:eval expression="{'010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                        <select id="dialing-code">
                            <c:forEach items="${dialingCode}" var="eachObj">
                                <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(user.mobile, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                            </c:forEach>
                        </select>
                        -
                        <input type="text" class="text" id="number-middle" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 1)}" />
                        -
                        <input type="text" class="text" id="number-last" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 2)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">이메일 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <form:hidden path="emailAddr" />
                        <input type="text" class="text" id="email-adrs1" value="${cnet:splitWithIndex(user.emailAddr, '@', 0)}" />
                        <span>@</span>
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100423_100533_이메일'])" var="emailCodes" />
                        <select id="domain-choice1">
                            <option value="">직접입력</option>
                            <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cdNm}" <c:if test="${cnet:splitWithIndex(user.emailAddr, '@', 1) eq eachObj.cdNm}">selected="selected"</c:if>>${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                        <input type="text" class="text" style="display:none;" id="email-entry1" value="${cnet:splitWithIndex(user.emailAddr, '@', 1)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">이메일 수신 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <spring:bind path="agrees[0].agrClassCd">
                        <label><form:radiobutton path="agrees[0].agrClassCd" value="${codeConstants['CD100939_100944_메일수집동의']}" /> 동의</label>
                        <label><input type="radio" name="agrees[0].agrClassCd" value="" class="radio-skin" <c:if test="${status.value ne codeConstants['CD100939_100944_메일수집동의']}">checked="checked"</c:if> /> 동의안함</label>
                        </spring:bind>
                    </td>
                </tr>
                <tr>
                    <th rowspan="3">직업</th>
                    <td>특정분류</td>
                    <td class="select-category">
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101564_직업특성분류'])" var="jobChrstcCodes" />
                        <select id="jobChrstcInfoSelector">
                            <c:forEach items="${jobChrstcCodes}" var="eachObj">
                                <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn-style01" id="jobChrstcInfoAdder"><span>추가</span></button>
                        <span class="ml5">* 최대 3개까지 추가가 가능합니다. 분류 선택 후 추가 버튼을 클릭하세요.</span>
                        <ul class="category-list" id="jobChrstcInfoSelected">
                            <c:forEach items="${user.mbrJobChrstcInfos}" var="eachObj" varStatus="vs">
                            <li>
                                <span class="underline">${eachObj.jobChrstcCdNm}</span>
                                <button type="button" class="item-delete"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="삭제" />
                                <form:hidden path="mbrJobChrstcInfos[${vs.index}].jobChrstcCd" />
                            </li>
                            </c:forEach>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td>직업분류</td>
                    <td>
                        <select style="width:150px;" id="jobLv1Selector">
                            <option value="">1차분류</option>
                        </select>
                        <select style="width:150px;" id="jobLv2Selector">
                            <option value="">2차분류</option>
                        </select>
                        <select style="width:150px;" id="jobLv3Selector" name="mbrJobInfo.jobClsfCd">
                            <option value="">3차분류</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>직업명</td>
                    <td>
                        <input type="hidden" id="mbrJobInfo-jobNo" value="${user.mbrJobInfo.jobNo}" />
                        <select style="width:150px;" name="mbrJobInfo.jobNo" id="jobInfoSelector">
                            <option value="">4차분류</option>
                        </select>
                        <input type="text" class="text" name="mbrJobInfo.jobNm" id="mbrJobInfo-jobNm" style="display:none;" />
                        <!-- <button type="button" class="btn-style01"><span>직업명 등록/추가</span></button>2016-06-27 삭제 -->
                        <span class="ml5">* 등록된 직업명이 없는 경우 직접입력항목을 클릭하세요.</span>
                    </td>
                </tr>
                <tr>
                    <th scope="col">멘토소개</th>
                    <td colspan="2">
                        <div class="textarea-wrap">
                            <textarea class="textarea" name="mbrProfInfo.intdcInfo" cols="30" rows="10">${user.mbrProfInfo.intdcInfo}</textarea>
                            <p class="count-byte"><strong>0</strong> / 200자</p>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th scope="col">사용유무 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <label><form:radiobutton path="loginPermYn" value="Y" /> 사용중</label>
                        <label><form:radiobutton path="loginPermYn" value="N" /> 사용안함</label>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" id="updateMentor"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" id="cancelMentor"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
    </form:form>
</div>

<script type="text/javascript">

    $(document).ready(function() {

        $('#updateMentor').click(function(e) {
            e.preventDefault();
            if(confirm('저장하시겠습니까?')) {
                $(this).closest('form').submit();
            }
        });

        $('#cancelMentor').click(function(e) {
            e.preventDefault();
            $(location).attr('href', 'view.do?mbrNo=${param.mbrNo}');
        });

        $('#domain-choice1').change(function() {
            $('#email-entry1').val(this.value)
                .toggle(!this.value);
        }).filter(function() { return !this.value; }).change();

        //email주소가 직접 입력 이었을 경우 지워짐,,
        $('#email-entry1').val("${cnet:splitWithIndex(user.emailAddr, '@', 1)}");

        $('#mentorBaseForm').submit(function() {

            if (!$('#username').val()) {
                alert('이름을 입력하세요.');
                return false;
            }

            if (!$('#email-adrs1').val() || !$('#email-entry1').val()) {
                alert('이메일을 입력하세요.');
                return false;
            }
            if ($('#jobChrstcInfoSelected li').length < 1) {
                alert('특징분류를 선택하세요.');
                return false;
            }

            if(!$('#mbrJobInfo-jobNm').val()) {
                alert('직업을 입력하세요.');
                return false;
            }

            // 이메일 수신과 사용유무는 무조건 선택되어 있기 때문에 따로 validate 체크 하지 않는다.

            $('input[name="mobile"]').val($('#dialing-code').val()+'-'+$('#number-middle').val()+'-'+$('#number-last').val());
            $('input[name="emailAddr"]').val($('#email-adrs1').val()+'@'+$('#email-entry1').val());
            $('input[name="birthday"]').val($('#birth-year').val().zf(4)+$('#birth-month').val().zf(2)+$('#birth-day').val().zf(2));
        });


        // 직업분류 추가
        $.template('jobChrstcInfo', '<li><span class="underline">\${jobNm}</span><button type="button" class="item-delete"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="삭제" /><input type="hidden" name="job" value="\${jobNo}" /></li>');
        $('#jobChrstcInfoAdder').click(function(e) {
            e.preventDefault();

            // 3개까지 선택 가능
            if ($('#jobChrstcInfoSelected li').length >= 3) {
                alert('특징분류는 3개까지 선택 가능 합니다.');
                return;
            }

            if ($('#jobChrstcInfoSelected :has(:hidden[value="' + $('#jobChrstcInfoSelector option:selected').val() + '"])').length) {
                alert('추가된 특징분류 입니다.');
                return;
            }

            $.tmpl('jobChrstcInfo', {
                jobNo: $('#jobChrstcInfoSelector option:selected').val(),
                jobNm: $('#jobChrstcInfoSelector option:selected').text()
            }).appendTo('#jobChrstcInfoSelected');
            indexingJobChrstcCd();
        });

        // 직업분류 삭제
        $('#jobChrstcInfoSelected').on('click', 'li > button', function(e) {
            e.preventDefault();
            $(this).closest('li').remove();
            indexingJobChrstcCd();
        });

        // 특정분류 인덱싱
        var indexingJobChrstcCd = function() {
            $('#jobChrstcInfoSelected').find(':hidden').each(function(i, o) {
                $(o).attr('name', 'mbrJobChrstcInfos[{0}].jobChrstcCd'.format(i));
            });
        };

        // 1차 분류 코드 정보
        $.ajax({
            url: '${pageContext.request.contextPath}/jobClsfCd.do',
            data: { cdLv: 1 },
            success: function(rtnData) {
                $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });

        // 1차 분류 변경
        $('#jobLv1Selector').change(function() {

            $('#jobLv2Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 2, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 2차 분류 변경
        $('#jobLv2Selector').change(function() {

            $('#jobLv3Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 3, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 3차 분류 변경
        $('#jobLv3Selector').change(function() {

            // 직접 입력 선택 option 을 유지하기 위해 삭제하지 않는다.
            $('#jobInfoSelector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $('#jobInfoSelector').loadSelectOptions([{jobNo: 'userWrite', jobNm: '직접입력'}],'','jobNo','jobNm',1);
                $.ajax('${pageContext.request.contextPath}/jobInfo.do', {
                    data: { jobClsfCd: this.value },
                    success: function(rtnData) {
                        $('#jobInfoSelector').loadSelectOptions(rtnData,'','jobNo','jobNm',2);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 직업선택시 직업명 값도 설정
        $('#jobInfoSelector').change(function() {
            $('#mbrJobInfo-jobNm').val($(this).find(':selected').text());
            if($(this).find(':selected').val() == 'userWrite') {
                $('#mbrJobInfo-jobNm').toggle(true);
                $('#mbrJobInfo-jobNm').val('');
            } else {
                $('#mbrJobInfo-jobNm').toggle(false);
            }
        });

        // 등록된 직업이 있을경우 처리
        if ($('#mbrJobInfo-jobNo').val()) {
            //alert($('#mbrJobInfo-jobNo').val())
            $.ajax('${pageContext.request.contextPath}/jobClsfCdByJobNo.do', {
                data: { jobNo: $('#mbrJobInfo-jobNo').val() },
                success: function(rtnData) {
                    if (!rtnData|| !rtnData.length) {
                        return;
                    }
                    $('#jobLv1Selector').val(rtnData[0].cd).change();
                    $('#jobLv2Selector').val(rtnData[1].cd).change();
                    $('#jobLv3Selector').val(rtnData[2].cd).change();
                    $('#jobInfoSelector').val($('#mbrJobInfo-jobNo').val()).change();
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    });
</script>