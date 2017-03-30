<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>교사회원</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>일반회원관리</li>
            <li>교사회원</li>
        </ul>
    </div>
    <form:form modelAttribute="user" id="updateMember" action="editSubmit.do">
    <form:hidden path="mbrNo" />
    <form:hidden path="birthday" />
    <form:hidden path="mobile" />
    <form:hidden path="emailAddr" />
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-mento-modify">
            <colgroup>
                <col style="width:147px;" />
                <col style="width:100px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">회원유형 <span class="red-point">*</span></th>
                    <td colspan="2">교사</td>
                </tr>
                <tr>
                    <th scope="col">아이디</th>
                    <td colspan="2">${user.id}</td>
                </tr>
                <tr>
                    <th scope="col">이름 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <form:input path="username" class="text mr10" />
                        <label>
                            <form:radiobutton path="genCd" value="${codeConstants['CD100322_100323_남자']}"/> 남
                        </label>
                        <label>
                            <form:radiobutton path="genCd" value="${codeConstants['CD100322_100324_여자']}"/> 여
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="col">생년월일 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
                        <select title="생년월일 연도" class="birthday">
                            <c:forEach begin="${1}" end="${70}" var="item">
                                <option value="${year - item}" ${(fn:substring(user.birthday,0,4) eq cnet:leftPad(cnet:toString(year - item, null), 2, '0')) ? 'selected' : ''}>${year - item}년</option>
                            </c:forEach>
                        </select>
                        <select title="생년월일 월" class="birthday">
                            <c:forEach begin="${1}" end="${12}" var="item">
                                <option value="${cnet:leftPad(cnet:toString(item, null), 2, '0')}" ${(fn:substring(user.birthday,4,6) eq cnet:leftPad(cnet:toString(item, null), 2, '0')) ? 'selected' : ''}>${item}월</option>
                            </c:forEach>
                        </select>
                        <select title="생년월일 일" class="mr10 birthday">
                            <c:forEach begin="${1}" end="${31}" var="item">
                                <option value="${cnet:leftPad(cnet:toString(item, null), 2, '0')}" ${(fn:substring(user.birthday,6,8) eq cnet:leftPad(cnet:toString(item, null), 2, '0')) ? 'selected' : ''}>${item}일</option>
                            </c:forEach>
                        </select>
                        <label>
                            <form:radiobutton path="lunarYn" value="N"/> 양력
                        </label>
                        <label>
                            <form:radiobutton path="lunarYn" value="Y"/> 음력
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="col">휴대전화</th>
                    <td colspan="2" class="mobile">
                        <spring:eval expression="{'010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                        <select class="mobile-number" title="번호앞자리 선택">
                            <c:forEach items="${dialingCode}" var="eachObj">
                                <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(user.mobile, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                            </c:forEach>
                        </select>
                        -
                        <input type="text" class="text mobile-number" style="width:100px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 1)}" />
                        -
                        <input type="text" class="text mobile-number" style="width:100px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 2)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">이메일 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100423_100533_이메일'])" var="emailCodes" />
                        <input type="text" class="text email-address" value="${cnet:splitWithIndex(user.emailAddr, '@', 0)}" />
                        <span>@</span>
                        <select id="email-entry">
                            <option value="">직접입력</option>
                            <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cdNm}"
                                        <c:if test="${cnet:splitWithIndex(user.emailAddr, '@', 1) eq eachObj.cdNm}">selected="selected"</c:if>>${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                        <input type="text" class="text email-address" maxlength="50" value="${cnet:splitWithIndex(user.emailAddr, '@', 1)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">이메일 수신 <span class="red-point">*</span></th>
                    <td colspan="2">
                        <label><input type="radio" name="agrees[0].agrClassCd" <c:if test="${fn:contains(user.agrees, codeConstants['CD100939_100944_메일수집동의'])}">checked="checked"</c:if> value="${codeConstants['CD100939_100944_메일수집동의']}" /> 동의</label>
                        <label><input type="radio" name="agrees[0].agrClassCd" <c:if test="${!fn:contains(user.agrees, codeConstants['CD100939_100944_메일수집동의'])}">checked="checked"</c:if> value="" /> 동의안함</label>
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
                <li><button type="button" class="btn-orange" id="updateMemberButton"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" onclick="location.href='view.do?mbrNo=${param.mbrNo}'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
    </form:form>
</div>
<script type="text/javascript">

    $(document).ready(function() {
        var emptyFilter = function() {
            return !this.value;
        };
        var notEmptyFilter = function() {
            return !!this.value;
        };


        // 이메일 선택
        $('#email-entry').change(function() {
            $('.email-address:last').val(this.value).toggle(!this.value);
        }).filter(notEmptyFilter).change();

        $('#prtctr-email-entry').change(function() {
            $('.prtctr-email-address:last').val(this.value).toggle(!this.value);
        }).filter(notEmptyFilter).change();

        // 저장 클릭
        $('#updateMemberButton').click(function(e) {
            if(confirm('저장하시겠습니까?')) {
                $(this).closest('form').submit();
                return false;
            } else {
                return false;
            }
        });

        $('#updateMember').submit(function() {
            if (!!!$('[name="username"]', this).val()) {
                alert('이름을 입력하세요.');
                return false;
            }

            if ($('.email-address', this).filter(emptyFilter).length) {
                alert('이메일을 입력하세요.');
                return false;
            }

            $('[name="birthday"]', this).val($('.birthday').map(function() { return this.value; }).get().join(''));
            $('[name="mobile"]', this).val($('.mobile-number').map(function() { return this.value; }).get().join('-'));
            $('[name="emailAddr"]', this).val($('.email-address').map(function() { return this.value; }).get().join('@'));

            return;
        });
    });
</script>