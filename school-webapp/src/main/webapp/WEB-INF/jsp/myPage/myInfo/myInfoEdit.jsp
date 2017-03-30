<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<jsp:useBean id="now" class="java.util.Date" />
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span>마이페이지</span>
        <span>나의정보</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">나의정보</h2>
        <p class="tit-desc-txt">나의 정보를 수정할 수 있습니다. 교실 정보 관리는 나의 교실 메뉴에서 할 수 있습니다.</p>
        <form:form commandName="user" action="myInfoEdit.do" id="frm">
        <div id="errors" style="display:none"><form:errors path="*" cssClass="error" /></div>
        <div class="join-info-write myinfo">
            <div class="board-title">
                <h3 class="board-tit">필수 정보</h3>
                <div>
                    <span>모든 항목은 필수 입력사항 입니다.</span>
                </div>
            </div>
            <div class="board-input-type">
                <table>
                    <caption>가입정보 입력 - 아이디, 비밀번호, 비밀번호 확인, 비밀번호찾기 질문, 이름, 생년월일, 이메일 주소, 이메일수신</caption>
                    <colgroup>
                        <col style="width:136px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="id-form">아이디</label></th>
                            <td><em id="reId"><security:authentication property="principal.id" /></em></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="pw-form">비밀번호</label></th>
                            <td>
                                <input type="password" id="pw-form" class="inp-style2" title="비밀번호 입력" name="password" maxlength="20"/>
                                <span class="refer">* 영문, 숫자 또는 특수문자를 포함한 10~20자리<em>가</em> 가능<em>합니다.</em></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="re_password">비밀번호 확인</label></th>
                            <td>
                                <input type="password" class="inp-style2" id="re_password"  maxlength="20"/>
                                <span class="layer" style="display:none" id="chkPwdDisp">비밀번호가 일치하지 않습니다.</span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="question">비밀번호찾기 질문</label></th>
                            <td class="pw-question"><form:hidden path="pwdQuestNm"/>
                                <form:select path="pwdQuestCd" id="question" title="비밀번호 찾기 질문 선택" cssStyle="width:270px;">
                                    <form:options items="${code100221}" itemLabel="cdNm" itemValue="cd"/>
                                </form:select>
                                <form:input cssClass="inp-style2" cssStyle="width:390px;" title="질문에 대한 답변 입력" path="pwdAnsSust"  maxlength="40"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="name-form">이름</label></th>
                            <td>
                                <span class="mgl-text"><security:authentication property="principal.username" /></span>
                                <span class="mgl-15">
                                    <label class="radio-skin ${(user.genCd eq '100323')?'checked':''}"><input type="radio" id="genCd" name="genCd" class="radio-skin" value="100323" title="남자" ${(user.genCd eq '100323' or empty user.genCd)?'checked':''} />남자</label>
                                    <label class="radio-skin ${(user.genCd eq '100324')?'checked':''}"><input type="radio" id="genCd" name="genCd" class="radio-skin" value="100324" title="여자" ${(user.genCd eq '100324')?'checked':''} />여자</label>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="birthday">생년월일</label></th>
                            <td class="birthday-slt">
                                <form:hidden path="birthday"/>
                                <fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
                                <select id="birth-year" title="생년월일 연도">
                                    <c:forEach begin="${1}" end="${70}" var="item">
                                        <option value="${year-item}" ${(fn:substring(user.birthday,0,4) eq (year-item))?'selected':''}>${year-item}</option>
                                    </c:forEach>
                                </select>
                                <label for="birth-month" class="label-none">생년월일 월</label>
                                <select title="생년월일 월" id="birth-month">
                                    <c:forEach begin="${1}" end="${12}" var="item">
                                        <option value="${item}" ${(fn:substring(user.birthday,4,6) == (item))?'selected':''}>${item}</option>
                                    </c:forEach>
                                </select>
                                <label for="birth-day" class="label-none">생년월일 월</label>
                                <select id="birth-day" title="생년월일 일">
                                    <c:forEach begin="${1}" end="${31}" var="item">
                                        <option value="${item}" ${(fn:substring(user.birthday,6,8) == (item))?'selected':''}>${item}</option>
                                    </c:forEach>
                                </select>
                                <input type="hidden" name="lunarYn" value="${empty user.lunarYn ? 'N' : user.lunarYn}" />
                                <%--span class="mgl-15">
                                    <label class="radio-skin ${(user.lunarYn eq 'N')?'checked':''}"><input type="radio" id="lunarYn" name="lunarYn" cssClass="radio-skin" value="N" title="양력" ${(user.lunarYn eq 'N' or empty user.lunarYn)?'checked':''} />양력</label>
                                    <label class="radio-skin ${(user.lunarYn eq 'Y')?'checked':''}"><input type="radio" id="lunarYn" name="lunarYn" cssClass="radio-skin" value="Y" title="음력" ${(user.lunarYn eq 'Y')?'checked':''} />음력</label>
                                </span--%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="email-adrs">이메일 주소</label></th>
                            <td class="email-slt"><form:hidden path="emailAddr"/>
                                <input type="text" id="email-adrs" title="이메일주소 입력" class="inp-style2 bk" value="${fn:substring(user.emailAddr,0,fn:indexOf(user.emailAddr,'@'))}"  maxlength="20"/>
                                @
                                <label for="domain-choice1" class="label-none">도메인 선택</label>
                                <select title="도메인 선택" id="domain-choice1">
                                        <option value="">직접입력</option>
                                    <c:forEach items="${code100533}" var="item">
                                        <c:if test="${(fn:substring(user.emailAddr,fn:indexOf(user.emailAddr,'@')+1,-1) eq item.cdNm)}"><c:set var="selected" value="selected"/></c:if>
                                        <option value="${item.cdNm}" ${(fn:substring(user.emailAddr,fn:indexOf(user.emailAddr,'@')+1,-1) eq item.cdNm)?'selected':''}>${item.cdNm}</option>
                                    </c:forEach>
                                </select>
                                    <span class="minor-form" <c:if test="${!empty selected}">style="display:none"</c:if> ><input type="text" id="email-entry1" title="이메일 도메인 직접 입력" class="inp-style2" style="width:180px;" value="${fn:substring(user.emailAddr,fn:indexOf(user.emailAddr,'@')+1,-1)}"  maxlength="20"/></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">이메일 수신</th>
                            <td>
<c:set var="contains" value="false" />
<c:forEach var="item" items="${user.agrees}" varStatus="status">
  <c:if test="${item.agrClassCd eq '100944'}">
    <c:set var="contains" value="true" />
  </c:if>
</c:forEach>
                                <label class="radio-skin ${(contains)?'checked':'' }"><input type="radio" name="agrees[0].agrClassCd" class="radio-skin" value="100944" title="예" ${(contains)?'checked':'' }/>예</label>
                                <label class="radio-skin ${(contains)?'':'checked' }"><input type="radio" name="agrees[0].agrClassCd" class="radio-skin" value="" title="아니오" ${(contains)?'':'checked' }/>아니오</label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h3 class="board-tit">선택 정보</h3>
            <div class="board-input-type">
                <table>
                    <caption>추가정보 항목 - 연락처</caption>
                    <colgroup>
                        <col style="width:157px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="dialing-code">연락처</label></th>
                            <td class="telephone-slt"><form:hidden path="mobile"/>
                            <c:set var="tel" value="${fn:split(user.mobile,'-')}" />
                                <select id="dialing-code" title="번호앞자리 선택">
                                    <option value="010" ${(tel[0] eq '010')?"selected":""}>010</option>
                                    <option value="011" ${(tel[0] eq '011')?"selected":""}>011</option>
                                    <option value="016" ${(tel[0] eq '016')?"selected":""}>016</option>
                                    <option value="017" ${(tel[0] eq '017')?"selected":""}>017</option>
                                    <option value="018" ${(tel[0] eq '018')?"selected":""}>018</option>
                                    <option value="019" ${(tel[0] eq '019')?"selected":""}>019</option>

                                </select> -
                                <label for="number-middle" class="label-none">번호중간자리 입력</label>
                                <input type="text" class="inp-style2 bk" id="number-middle" value="${tel[1]}" maxlength="4"/> -
                                <label for="number-last" class="label-none">번호끝자리 입력</label>
                                <input type="text" id="number-last" class="inp-style2 bk" value="${tel[2]}" maxlength="4"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area">
                <a href="javascript:void(0)" class="btn-type2" onclick="submit()">수정</a>
                <a href="myInfoView.do" class="btn-type2 gray">취소</a>
            </div>
            </form:form>
        </div>
    </div>
</div>
    <div class="cont-quick">
        <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
    </div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    $("#frm").submit(function(){
        $("input[name='birthday']").val($("#birth-year").val().zf(4)+$("#birth-month").val().zf(2)+$("#birth-day").val().zf(2));
        if(!$("#domain-choice1").val().isEmpty()){
            $("input[name='emailAddr']").val($("#email-adrs").val()+"@"+$("#domain-choice1").val());
        }
        $("input[name='mobile']").val($("#dialing-code").val()+"-"+$("#number-middle").val()+"-"+$("#number-last").val());
        $("input[name='pwdQuestNm']").val($("select[name='pwdQuestCd']>option:selected").text());
    });
    $("#errors>span.error").each(function(){
        alert($(this).text());
    });

    $("#domain-choice1").change(function(){
        if($(this).val().isEmpty()){
            $("#email-entry1").val("");
            $(this).next().show();
        }else{
            $(this).next().hide();
        }
    });

    $("#re_password,input[name='password']").blur(function(){
        if(($("input[name='password']").val() != "" && $("#re_password").val() != "")
                && ($("input[name='password']").val() != $("#re_password").val())) {
            $("#chkPwdDisp").show();
        }else{
            $("#chkPwdDisp").hide();
        }
    });
});
function submit(){
    if($("input[name='password']").val() != $("#re_password").val()){
        alert("비밀번호를 확인해주세요.");
        return false;
    }

    var SamePass_0 = 0; //ID와 3자이상 중복체크

    var chr_pass_0;
    var chr_pass_1;
    var chr_pass_2;

    var chr_id_0;
    var chr_id_1;
    var chr_id_2;

    for(var i=0; i < ($("#re_password").val().length-2); i++) {

        chr_pass_0 = $("#re_password").val().charAt(i);
        chr_pass_1 = $("#re_password").val().charAt(i+1);
        chr_pass_2 = $("#re_password").val().charAt(i+2);

        for(var j=0; j < ($("#reId").text().length-2); j++) {
            chr_id_0 = $("#reId").text().charAt(j);
            chr_id_1 = $("#reId").text().charAt(j+1);
            chr_id_2 = $("#reId").text().charAt(j+2);
            if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                SamePass_0=1;
            }
        }
    }
    if($("#re_password").val().search(/\s/) != -1){
        alert("비밀번호는 공백없이 입력해주세요.");
        return false;
    }

    if(SamePass_0 >0){
        alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
        return false;
    }

    if(/([\w\W\d])\1\1/.test($("#re_password").val())) {
        alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
        return false;
    }

    var regex = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
    if(!regex.test($("#re_password").val())){
        alert("비밀번호는 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.");
        return false;
    }

    $("#frm").submit();
}
</script>