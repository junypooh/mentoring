<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<jsp:useBean id="now" class="java.util.Date" />
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />

<script type="text/javascript">
$().ready(function() {
    $('.radio-skin:has(:checked)').addClass('checked');

    // 비밀번호 비교
    $('#chkPwd').bind('change', function (e) {
        $(this).bind('keyup', function() {
                ($('input[name="password"]').val() && $('#chkPwd').val() != $('input[name="password"]').val())
                        ? $('#chkPwdDisp').show()
                        : $('#chkPwdDisp').hide();
                return arguments.callee;
            }()).unbind('change');
    });


    // 이메일
    $('#domain-choice1').change(function(e) {
        !(this.value) ? $('#email-entry1').show()
                : $('#email-entry1').hide();
        $('#email-entry1').val(this.value);
    }).filter(function() { return !!this.value; }).change();


    // 수정 버튼
    $('#updateMyInfoConfirmBtn').click(function(e) {
        e.preventDefault();
        $(this).closest('form').submit();
    });


    // 폼 전송
    $('#updateMyInfoForm').submit(function() {
        if ($('input[name="password"]').val() !== $('#chkPwd').val()) {
            alert('비밀번호를 확인하세요');
            return false;
        }

        var SamePass_0 = 0; //ID와 3자이상 중복체크

        var chr_pass_0;
        var chr_pass_1;
        var chr_pass_2;

        var chr_id_0;
        var chr_id_1;
        var chr_id_2;

        for(var i=0; i < ($("#chkPwd").val().length-2); i++) {

            chr_pass_0 = $("#chkPwd").val().charAt(i);
            chr_pass_1 = $("#chkPwd").val().charAt(i+1);
            chr_pass_2 = $("#chkPwd").val().charAt(i+2);

            for(var j=0; j < ($("#reId").text().length-2); j++) {
                chr_id_0 = $("#reId").text().charAt(j);
                chr_id_1 = $("#reId").text().charAt(j+1);
                chr_id_2 = $("#reId").text().charAt(j+2);
                if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                    SamePass_0=1;
                }
            }
        }
        if($("#chkPwd").val().search(/\s/) != -1){
            alert("비밀번호는 공백없이 입력해주세요.");
            return false;
        }

        if(SamePass_0 >0){
            alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
            return false;
        }

        if(/([\w\W\d])\1\1/.test($("#chkPwd").val())) {
            alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
            return false;
        }

        var chkPwd = $("#chkPwd").val();

        var regex = /^((?=.*[a-zA-Z])|(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:'",.<>\/?]))((?=.*\d)|(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:'",.<>\/?])).{10,20}$/;
        if(!regex.test(chkPwd) || (!/\d/.test(chkPwd)&&!/[a-zA-Z]/.test(chkPwd))){
            alert("비밀번호는 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.");
            return false;
        }

        if (!$('input[name="pwdAnsSust"]').val()) {
            alert('질문에 대한 답변을 입력하세요.');
            return false;
        }

        if (!$('#email-adrs1').val() || !$('#email-entry1').val()) {
            alert('이메일을 입력하세요.');
            return false;
        }

        $('input[name="mobile"]').val($('#dialing-code').val()+'-'+$('#number-middle').val()+'-'+$('#number-last').val());
        $('input[name="emailAddr"]').val($('#email-adrs1').val()+'@'+$('#email-entry1').val());
        $('input[name="birthday"]').val($('#birth-year').val().zf(4)+$('#birth-month').val().zf(2)+$('#birth-day').val().zf(2));
    });
});
</script>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원정보</span>
        <span>내 정보 수정</span>
    </div>

    <form:form modelAttribute="user" action="${pageContext.request.contextPath}/myPage/myInfo/updateMyInfo.do" id="updateMyInfoForm">
        <input type="hidden" name="tmpPwdYn" value="Y">
        <c:if test="${empty errorCode}">
            <div id="errors" style="display:none">
                <spring:bind path="*">
                    <c:forEach items="${status.errorMessages}" var="error"><span class="error">${error}</span></c:forEach>
                </spring:bind>
                <script type="text/javascript">$("#errors:has(span.error)").each(function() {
                    alert($(this).find('span.error:first').text());
                });</script>
            </div>
        </c:if>

        <div class="content">
            <h2>내 정보 수정</h2>
            <p class="tit-desc-txt">회원님의 회원정보를 수정할 수 있습니다.<a href="${pageContext.request.contextPath}/myPage/myInfo/profile.do" class="btn-profill-set">프로필 관리</a></p>
            <div class="cont type1">
                <div class="board-title1">
                    <h3 class="board-tit">회원정보</h3>
                    <span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
                </div>
                <div class="board-input-type all-view">
                    <table>
                        <caption>내 정보 수정 - 아이디, 비밀번호, 비밀번호 확인, 비밀번호찾기 질문, 이름, 생년월일, 휴대폰 번호, 이메일, 이메일</caption>
                        <colgroup>
                            <col style="width:136px;" />
                            <col style="width:289px;" />
                            <col style="width:75px;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="compulsory">아이디</th>
                                <td colspan="3" id="reId">${user.id}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">비밀번호</th>
                                <td colspan="3">
                                    <input type="password" class="inp-style1" style="width:150px;" name="password" value="" />
                                    <span class="refer">* 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">비밀번호 확인</th>
                                <td colspan="3">
                                    <input type="password" class="inp-style1" style="width:150px;" id="chkPwd" />
                                    <span class="layer" id="chkPwdDisp" style="display: none;">비밀번호가 일치하지 않습니다.</span>
                                </td>
                            </tr>

                            <tr>
                                <th scope="row" class="compulsory">비밀번호찾기 질문</th>
                                <td colspan="3">
                                    <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD100211_100221_비밀번호_분실_시_확인질문'])" var="questCodes" />
                                    <form:select path="pwdQuestCd" style="width:270px;">
                                        <form:options items="${questCodes}" itemLabel="cdNm" itemValue="cd" />
                                    </form:select>
                                    <form:input path="pwdAnsSust" class="inp-style1" style="width:150px;" />
                                </td>
                            </tr>

                            <tr>
                                <th scope="row" class="compulsory">이름</th>
                                <td colspan="3">${user.username}, ${code['CD100322_100323_남자'] eq user.genCd ? '남자' : '여자'}</td>
                            </tr>

                            <tr>
                                <th scope="row" class="compulsory">생년월일</th>
                                <td colspan="3">
                                    <form:hidden path="birthday" />
                                    <fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
                                    <select id="birth-year" style="width:80px;">
                                        <c:forEach begin="${1}" end="${70}" var="item">
                                            <option value="${year - item}"
                                                    <c:if test="${cnet:substring(user.birthday, 0, 4) eq (year - item)}">selected="selected"</c:if>>${year-item}</option>
                                        </c:forEach>
                                    </select>
                                    <select id="birth-month" style="width:56px;">
                                        <c:forEach begin="${1}" end="${12}" var="item">
                                            <option value="${item}"
                                                    <c:if test="${cnet:substring(user.birthday, 4, 6) eq cnet:leftPad((item), 2, '0')}">selected="selected"</c:if>>${item}</option>
                                        </c:forEach>
                                    </select>
                                    <select id="birth-day" style="width:56px;">
                                        <c:forEach begin="${1}" end="${31}" var="item">
                                            <option value="${item}"
                                                    <c:if test="${cnet:substring(user.birthday, 6, 8) eq cnet:leftPad((item), 2, '0')}">selected="selected"</c:if>>${item}</option>
                                        </c:forEach>
                                    </select>
                                    <span class="mgl-15">
                                        <c:if test="${empty user.lunarYn}">
                                            <c:set target="${user}" property="lunarYn" value="Y" />
                                        </c:if>
                                        <label class="radio-skin"><form:radiobutton path="lunarYn" value="N" class="radio-skin" />양력</label>
                                        <label class="radio-skin"><form:radiobutton path="lunarYn" value="Y" class="radio-skin" />음력</label>
                                    </span>
                                </td>
                            </tr>

                            <tr>
                                <th scope="row">휴대폰 번호</th>
                                <td colspan="3">
                                    <form:hidden path="mobile" />
                                    <spring:eval expression="{'010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                                    <select id="dialing-code" title="번호앞자리 선택" style="width:80px;">
                                        <c:forEach items="${dialingCode}" var="eachObj">
                                            <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(user.mobile, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                                        </c:forEach>
                                    </select> -
                                    <input type="text" class="inp-style1" id="number-middle" style="width:65px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 1)}" /> -
                                    <input type="text" class="inp-style1" id="number-last" style="width:65px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 2)}"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">이메일</th>
                                <td colspan="3">
                                    <form:hidden path="emailAddr" />
                                    <input type="text" class="inp-style1" style="width:180px;" id="email-adrs1" maxlength="50" value="${cnet:splitWithIndex(user.emailAddr, '@', 0)}"> @
                                    <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD100423_100533_이메일'])" var="emailCodes" />
                                    <select id="domain-choice1" style="width:160px;">
                                        <option value="">직접입력</option>
                                        <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                            <option value="${eachObj.cdNm}"
                                                    <c:if test="${cnet:splitWithIndex(user.emailAddr, '@', 1) eq eachObj.cdNm}">selected="selected"</c:if>>${eachObj.cdNm}</option>
                                        </c:forEach>
                                    </select>
                                    <input type="text" class="inp-style1" style="width:180px;" id="email-entry1" maxlength="50" value="${cnet:splitWithIndex(user.emailAddr, '@', 1)}">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">이메일 수신</th>
                                <td colspan="3">
                                    <spring:bind path="agrees[0].agrClassCd">
                                        <label class="radio-skin"><form:radiobutton path="agrees[0].agrClassCd" value="${code['CD100939_100944_메일수집동의']}" class="radio-skin" />예</label>
                                        <label class="radio-skin"><input type="radio" name="agrees[0].agrClassCd" value="" class="radio-skin"
                                                <c:if test="${status.value ne code['CD100939_100944_메일수집동의']}">checked="checked"</c:if> />아니오</label>
                                    </spring:bind>
                                </td>
                            </tr>
                            <%-- <tr>
                                <th scope="row">문자서비스 아이디</th>
                                <td colspan="3">
                                    <div class="interlock">
                                        <a href="#layer1" class="btn-type1 layer-open">연동</a>
                                        <span class="id">mentoring02</span>
                                    </div>
                                </td>
                            </tr> --%>
                            <% // CD100204_101502_소속멘토 %>
                            <security:authorize access="hasRole('ROLE_COP_MENTOR')">
                                <tr>
                                    <th scope="row">소속</th>
                                    <td>${corporation.username}</td>
                                    <th scope="row">지원</th>
                                    <td>${organization.username}</td>
                                </tr>
                            </security:authorize>
                        </tbody>
                    </table>
                </div>
                <div class="btn-area">
                    <a href="#" class="btn-type2" id="updateMyInfoConfirmBtn">수정</a>
                    <a href="${pageContext.request.contextPath}/" class="btn-type2 gray">취소</a>
                    <a href="javascript:void(0)" class="mem-withdrawal" onClick="fn_secession()">탈퇴신청</a>
                </div>
            </div>
        </div>
    </form:form>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="top" /></a></div>
</div>

<script type="text/javascript">
    var fn_secession = function(e){
        $.ajax({
            url: "${pageContext.request.contextPath}/myPage/myInfo/ajax.secessionCheck.do",
            success: function(rtnData) {
                if(rtnData.success){
                    var url = "${pageContext.request.contextPath}/myPage/myInfo/secession.do";
                    $(location).attr("href", url);
                }else{
                    alert(rtnData.message);
                }
            }
        });
    }
</script>