<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />
<jsp:useBean id="now" class="java.util.Date" />
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span>회원가입</span>
    </div>
    <div class="content sub">
        <h2>회원가입</h2>
        <span class="join-step-img"><img src="${pageContext.request.contextPath}/images/utility/img_join_step3.gif" alt="step1.회원분류 선택, step2.약관동의, step.3 가입정보 입력, step4.접수완료 중 step3.가입정보 입력" /></span>

        <div class="join-info-write">
            <form:form action="step4.do" commandName="user" id="frm">
            <c:if test="${empty errorCode}">
                <div id="errors" style="display:none">
                    <spring:bind path="*">
                        <c:forEach items="${status.errorMessages}" var="error"><span class="error">${error}</span></c:forEach>
                    </spring:bind>
                    <%-- <form:errors path="*" cssClass="error" delimiter="" /> --%>
                </div>
            </c:if>

            <p class="desc-txt">회원님의 소중한 개인정보를 동의 없이 공개 또는 제공하지 않습니다. </p>
            <div class="board-title">
                <h3 class="board-tit">필수 입력항목</h3>
                <div>
                    <span>모든 항목은 필수 입력사항 입니다.</span>
                </div>
            </div>
            <div class="board-input-type">
				<div class="selectbox-zindex-wrap">
					<!-- <div class="selectbox-zindex-wrap">
                            <div class="selectbox-zindex-box">
                                <div class="m-height540"></div>
                                <iframe scrolling="no" title="빈프레임" class="m-height540" frameborder="0"></iframe>
                            </div>
                        </div> -->
				</div>
                <table>
                    <caption>가입정보 입력 - 아이디, 비밀번호, 비밀번호 확인, 비밀번호찾기 질문, 이름, 생년월일, 이메일 주소, 이메일수신</caption>
                    <colgroup>
                        <col style="width:136px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="id">아이디</label></th>
                            <td>
                                <form:input cssClass="inp-style2" cssStyle="width:150px;" title="아이디 입력" path="id" readonly="true" onclick="idClick()"/> <a href="#layer1" title="아이디 중복확인 팝업 - 열기" class="btn-type1 layer-open" id="btnIdDuplChk">아이디 중복확인</a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="pw-form">비밀번호</label></th>
                            <td>
                                <input type="password" id="pw-form" class="inp-style2" title="비밀번호 입력" style="width:150px;" name="password"  maxlength="20"/>
                                <span class="refer">* 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.</span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="chkPwd">비밀번호 확인</label></th>
                            <td>
                                <input type="password" class="inp-style2" title="비밀번호 확인 입력" style="width:150px;" id="chkPwd"  maxlength="20"/>
                                <span class="layer" style="display:none" id="chkPwdDisp">비밀번호가 일치하지 않습니다.</span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="question">비밀번호찾기 질문</label></th>
                            <td class="pw-question">
                                <form:select path="pwdQuestCd" id="question" title="비밀번호 찾기 질문 선택" cssStyle="width:270px;">
                                    <form:options items="${code100221}" itemValue="cd" itemLabel="cdNm" />
                                </form:select>
                                <form:input cssClass="inp-style2" cssStyle="width:390px;" title="질문에 대한 답변 입력" path="pwdAnsSust" maxlength="500"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="name-form">이름</label></th>
                            <td>
                                <form:input cssClass="inp-style2" cssStyle="width:150px;" id="name-form" title="이름 입력" path="username" maxlength="10"/>
                                <span class="mgl-15">
                                    <label class="radio-skin checked" title="남자"><input type="radio" name="genCd" class="radio-skin" checked="checked" value="100323"/>남자</label>
                                    <label class="radio-skin" title="여자"><input type="radio" name="genCd" class="radio-skin" value="100324"/>여자</label>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="birthday">생년월일</label></th>
                            <td><fmt:formatDate value="${now}" var="year" pattern="yyyy"/><input type="hidden" name="birthday"/>
                                <select id="birthday" title="생년월일 연도" style="width:80px;">
                                    <c:forEach begin="${1}" end="${70}" var="item">
                                        <option value="${year-item}">${year-item}</option>
                                    </c:forEach>
                                </select>
                                <label for="birth-month" class="label-none">생년월일 월</label>
                                <select title="생년월일 월" id="birth-month" style="width:70px;">
                                    <c:forEach begin="${1}" end="${12}" var="item">
                                        <option value="${item}">${item}</option>
                                    </c:forEach>
                                </select>
                                <label for="birth-day" class="label-none">생년월일 일</label>
                                <select id="birth-day" title="생년월일 일" style="width:70px;">
                                    <c:forEach begin="${1}" end="${31}" var="item">
                                        <option value="${item}">${item}</option>
                                    </c:forEach>
                                </select>
                                <input type="hidden" name="lunarYn" value="N" />
                                <%--span class="mgl-15">
                                    <label class="radio-skin checked" title="양력"><input type="radio" name="lunarYn" class="radio-skin" checked="checked" value="N"/>양력</label>
                                    <label class="radio-skin" title="음력"><input type="radio" name="lunarYn" class="radio-skin" value="N"/>음력</label>
                                </span--%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="email-adrs1">이메일 주소</label></th>
                            <td><form:hidden path="emailAddr" />
                                <input type="text" id="email-adrs1" title="이메일주소 입력" class="inp-style2" style="width:180px;" value="" maxlength="40"/>
                                @
                                <label for="domain-choice1" class="label-none">도메인 선택</label>
                                <select id="domain-choice1" title="도메인 선택" style="width:160px;" class="email">
                                    <option value="">직접입력</option>
                                <c:forEach items="${code100533}" var="item">
                                    <option value="${item.cdNm}">${item.cdNm}</option>
                                </c:forEach>
                                </select>
                                <label for="email-entry1" class="label-none">이메일 도메인 직접 입력</label>
                                <span class="minor-form" ><input type="text" id="email-entry1" title="이메일 도메인 직접 입력" class="inp-style2" style="width:180px;" value="" maxlength="40"/></span>
                            </td>
                        </tr>
                        <tr id="parentsEmail" style="display:none">
                            <th scope="row"><label for="email-adrs2">보호자 이메일</label></th>
                            <td><form:hidden path="prtctrEmailAddr"/>
                                <span class="refer type1"><em>만14세 미만은 보호자(법정대리인)의 동의를 받아야합니다.</em><br/>보호자 동의 메일을 보내기 위한 이메일 주소를 입력해주세요. 이메일 주소와 보호자 이메일 주소는 동일할 수 없습니다.</span>
                                <input type="text" id="email-adrs2" title="이메일주소 입력" class="inp-style2" style="width:180px;" value="" maxlength="40"/>
                                @
                                <label for="domain-choice2" class="label-none">도메인 선택</label>
                                <select id="domain-choice2" title="도메인 선택" style="width:160px;" class="email">
                                    <option value="">직접입력</option>
                                <c:forEach items="${code100533}" var="item">
                                    <option value="${item.cdNm}">${item.cdNm}</option>
                                </c:forEach>
                                </select>
                                <label for="email-entry2" class="label-none">이메일 도메인 직접 입력</label>
                                <span class="minor-form" ><input type="text" id="email-entry2" title="이메일 도메인 직접 입력" class="inp-style2" style="width:180px;" value="" maxlength="40"/></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">이메일 수신</th>
                            <td>
                                <label class="radio-skin checked" title="예"><input type="radio" name="agrees[2].agrClassCd" class="radio-skin" checked="checked" value="100944"/>예</label>
                                <label class="radio-skin" title="아니오"><input type="radio" name="agrees[2].agrClassCd" class="radio-skin" value=""  />아니오</label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="board-title" id="_addiInfo_1" style="display:none">
                <h3 class="board-tit">추가정보 항목</h3>
                <div>
                    <span>원활한 원격진로멘토링 서비스 이용을 위해서 선택 아래의 정보가 필요합니다.</span>
                </div>
            </div>
            <div class="board-input-type" id="_addiInfo_2" style="display:none">
                <table>
                    <caption>추가정보 항목 - 연락처</caption>
                    <colgroup>
                        <col style="width:157px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="dialing-code">연락처</label></th>
                            <td><input type="hidden" name="mobile" /><c:set var="tel" value="${fn:split(user.mobile,'-')}" />
                                <select id="dialing-code" title="번호앞자리 선택" style="width:80px;">
                                    <option value="010" ${(tel[0] eq '010')?"selected":""}>010</option>
                                    <option value="011" ${(tel[0] eq '011')?"selected":""}>011</option>
                                    <option value="016" ${(tel[0] eq '016')?"selected":""}>016</option>
                                    <option value="017" ${(tel[0] eq '017')?"selected":""}>017</option>
                                    <option value="018" ${(tel[0] eq '018')?"selected":""}>018</option>
                                    <option value="019" ${(tel[0] eq '019')?"selected":""}>019</option>
                                </select> -
                                <label for="number-middle" class="label-none">번호중간자리 입력</label>
                                <input type="text" class="inp-style2" id="number-middle" style="width:65px;" value="${tel[1]}" maxlength="4"/> -
                                <label for="number-last" class="label-none">번호끝자리 입력</label>
                                <input type="text" id="number-last" class="inp-style2" style="width:65px;" value="${tel[2]}" maxlength="4"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area">
                <button type="sbumit" class="btn-type2">가입</button>
                <a href="#" class="btn-type2 gray">취소</a>
            </div>
            </form:form>
        </div>
    </div>
</div>
<!-- layerpopup -->
<div class="layer-pop-wrap" id="layer1">
    <div class="layer-pop class">
        <div class="layer-header">
            <strong class="title">아이디 중복확인</strong>
        </div>
        <div class="layer-cont">
            <div class="box-style none-border2" id="idDplTextArea">
                <strong id="idDplTextArea-1" class="title-style">아이디를 입력하세요.</strong>
                <strong id="idDplTextArea-2" style="display:none;" class="title-style id-check"><em id="idDplTextArea-2-1">SandleWind00</em><em class="gray">는 현재 사용 중인 아이디입니다.</em><br />다른 아이디를 사용해주세요.</strong>
                <strong id="idDplTextArea-3" style="display:none;" class="title-style"><em id="idDplTextArea-3-1">SandleWind00</em>는 사용 가능합니다.</strong>
                <a href="javascript:void(0)" id="idDplTextArea-4" style="display:none;" class="btn-type2 search">아이디 사용하기</a>
                <div class="box-style2 border">
                    <strong><label for="idCheck2">아이디</label></strong>
                    <input type="text" id="idCheck2" name="id" placeholder="아이디를 입력해주세요." title="아이디" maxlength="12"/>
                    <a href="javascript:void(0);"  class="btn-type2 search" onClick="checkIdDupl()">아이디 중복확인</a>
                </div>
                <span class="pass-point"><span>중요</span>5자리 ~ 12자리 영문 소문자, 숫자 및 기호 '_', '-' 만 사용 가능합니다.</span>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    <c:if test="${user.mbrClassCd eq code['CD100857_100859_교사']}">
    $("[id^='_addiInfo_']").show();
    </c:if>
    $.ajax({
        url: "${pageContext.request.contextPath}/code.do",
        data : {"supCd":"100533"},
        success: function(rtnData) {
            <c:if test="${!empty user.emailAddr}">
            <c:set value="${fn:split(user.emailAddr,'@')}" var="emailAddr" />
            </c:if>

            <c:if test="${!empty user.prtctrEmailAddr}">
            <c:set value="${fn:split(user.prtctrEmailAddr,'@')}" var="prtctrEmailAddr" />
            </c:if>
            $("#domain-choice1").loadSelectOptions(rtnData,"${emailAddr[1]}","cdNm","cdNm",1).change();
            $("#domain-choice2").loadSelectOptions(rtnData,"${prtctrEmailAddr[1]}","cdNm","cdNm",1).change();

            $("#email-adrs1").val("${emailAddr[0]}");
            $("#email-entry1").val("${emailAddr[1]}");
            $("#email-adrs2").val("${prtctrEmailAddr[0]}");
            $("#email-entry2").val("${prtctrEmailAddr[1]}");

        }
    });
    $.ajax({
        url: "${pageContext.request.contextPath}/code.do",
        data : {"supCd":"100221"},
        success: function(rtnData) {
            $("#question").loadSelectOptions(rtnData,"${user.pwdQuestCd}","cd","cdNm",0).change();
        }
    });

    $("#idCheck2").keypress(function (e){
        if(e.keyCode==13){
            checkIdDupl();
        }
    });
    $("#chkPwd").change(function (e){
        if($("input[name='password']").val() != ""){
            if($("#chkPwd").val() != $("input[name='password']").val()){
                $("#chkPwdDisp").show();
            }else{
                $("#chkPwdDisp").hide();
            }
        }else{
            $("#chkPwdDisp").hide();
        }
    });
    $("select.email").change(function(){
        $(this).siblings("span.minor-form").find("input").val($(this).val());
        if($(this).val() == ""){
            $(this).siblings("span.minor-form").show();
        }else{
            $(this).siblings("span.minor-form").hide();
        }
    });

    <c:if test="${!empty user.birthday}">
    $("#birthday").val("${fn:substring(user.birthday,0,4)}");
    $("#birth-month").val("${fn:substring(user.birthday,4,6)}"*1);
    $("#birth-day").val("${fn:substring(user.birthday,6,8)}"*1);
    </c:if>

    $("#domain-choice1").change(function(){
        $("#email-entry1").val($(this).val());
    });

    $("#domain-choice2").change(function(){
        $("#email-entry2").val($(this).val());
    });


    $("#birthday,#birth-month,#birth-day").change(checkUnder14)
        .filter('#birthday').change();

    $("#frm").submit(function(){
        if (!!!(this.id.value)) {
            alert('아이디 중복확인 하세요.');
            return false;
        }

        if (!!!(this.password.value)) {
            alert('비밀번호를 입력하세요.');
            return false;
        }

        if (this.password.value !== $('#chkPwd').val()) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }


        var SamePass_0 = 0; //ID와 3자이상 중복체크

        var chr_pass_0;
        var chr_pass_1;
        var chr_pass_2;

        var chr_id_0;
        var chr_id_1;
        var chr_id_2;

        for(var i=0; i < (this.password.value.length-2); i++) {

            chr_pass_0 = this.password.value.charAt(i);
            chr_pass_1 = this.password.value.charAt(i+1);
            chr_pass_2 = this.password.value.charAt(i+2);

            for(var j=0; j < ($("#id").val().length-2); j++) {
                chr_id_0 = $("#id").val().charAt(j);
                chr_id_1 = $("#id").val().charAt(j+1);
                chr_id_2 = $("#id").val().charAt(j+2);
                if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                    SamePass_0=1;
                }
            }
        }
        if(this.password.value.search(/\s/) != -1){
            alert("비밀번호는 공백없이 입력해주세요.");
            return false;
        }

        if(SamePass_0 >0){
            alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
            return false;
        }

        if(/([\w\W\d])\1\1/.test(this.password.value)) {
            alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
            return false;
        }

        var regex = /^((?=.*[a-zA-Z])|(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:'",.<>\/?]))((?=.*\d)|(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:'",.<>\/?])).{10,20}$/;
        if(!regex.test(this.password.value) || (!/\d/.test(this.password.value)&&!/[a-zA-Z]/.test(this.password.value))){
            alert("비밀번호는 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.");
            return false;
        }

        /*
        if (!/^.{10,20}$/ig.test(this.password.value)) {
            alert('비밀번호가 형식에 맞지 않습니다.\n영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.');
            return false;
        }
        */

        if (!!!(this.pwdAnsSust.value)) {
            alert('비밀번호 찾기 답변을 입력하세요.');
            return false;
        }

        if (!!!(this.username.value)) {
            alert('이름을 입력하세요.');
            return false;
        }

        if (!!!$('#email-adrs1').val()) {
            alert('이메일 주소를 입력하세요.');
            return false;
        }

        if (!!!$('#email-entry1').val()) {
            alert('이메일 주소를 입력하세요.');
            return false;
        }

        if (checkUnder14()) {
            if (!!!$('#email-adrs2').val()) {
                alert('보호자 이메일 주소를 입력하세요.');
                return false;
            }
            if (!!!$('#email-entry2').val()) {
                alert('보호자 이메일 주소를 입력하세요.');
                return false;
            }
        }

        if($("#email-adrs1").val()+"@"+$("#email-entry1").val() == $("#email-adrs2").val()+"@"+$("#email-entry2").val()) {
            alert('이메일 주소가 보호자 이메일 주소와 같을 수 없습니다.');
            return false;
        }

        $("input[name='mobile']").val($("#dialing-code").val()+"-"+$("#number-middle").val()+"-"+$("#number-last").val());
        $("input[name='emailAddr']").val($("#email-adrs1").val()+"@"+$("#email-entry1").val());
        $("input[name='prtctrEmailAddr']").val($("#email-adrs2").val()+"@"+$("#email-entry2").val());
        $("input[name='birthday']").val(getBirthday());
    });

    $("#idDplTextArea-4").click(function(){
        $("input[name='id']").val($("#idDplTextArea-3-1").text());
        $("#layer1 .layer-close").click();
    });

});

function idClick(){
    $("#btnIdDuplChk").click();
}
function checkIdDupl(){
    $.ajax({
        url: "${pageContext.request.contextPath}/join/ajax.checkIdDupl.do",
        data : {'id':$("#idCheck2").val()},
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
            $("#idDplTextArea").removeClass("none-border2").addClass("none-border");
            $("[id^='idDplTextArea-']").hide();
            if(rtnData.success === "true"){
                $("#idDplTextArea-3-1").text($("#idCheck2").val()).show();
                $("#idDplTextArea-3").show();
                $("#idDplTextArea-4").show();
                //$("input[name='id']").val($("#idCheck2").val());
                //$("#layer1 .layer-close").click();
            }else{
                if(rtnData.type == "id_validate"){
                    $("#idDplTextArea-1").show();
                    alert(rtnData.message);
                }else{
                    $("#idDplTextArea-2-1").text($("#idCheck2").val()).show();
                    $("#idDplTextArea-2").show();
                }

            }
        }.bind(this),
        error: function(xhr, status, err) {
            console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
}

function idCheck(){
    var idReg = /^[a-z]+[a-z0-9]{5,19}$/g;
    if( !idReg.test( $("input[name=uid]").val() ) ) {
        alert("아이디는 영문자로 시작하는 6~20자 영문자 또는 숫자이어야 합니다.");
        return;
    }
}

mentor.curDate = mentor.parseDate("<fmt:formatDate value="${now}" pattern="yyyyMMdd"/>");
mentor.under14Date = mentor.calDate(mentor.curDate,-14,0,0);
function checkUnder14(){
    var selDate = mentor.parseDate(getBirthday());
    if(mentor.under14Date >= selDate || ${user.mbrClassCd} == '100859'){
        $("#parentsEmail").hide();
        return false;
    }else{
        $("#parentsEmail").show();
        return true;
    }

}

function getBirthday(){
    return $("#birthday").val().zf(4)+$("#birth-month").val().zf(2)+$("#birth-day").val().zf(2);
}
$("#errors:has(span.error)").each(function() {
    alert($(this).find('span.error:first').text());
});
</script>