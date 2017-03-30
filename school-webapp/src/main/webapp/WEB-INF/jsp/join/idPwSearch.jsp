<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">로그인</span>
        <span>아이디/비밀번호찾기</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">아이디/비밀번호찾기</h2>
        <p class="tit-desc-txt">회원정보를 이용한 아이디/비밀번호 찾기 입니다. 원하시는 항목을 선택해주세요.</p>
        <div class="id-pw-search">
            <!-- 아이디 찾기 -->
            <div class="id-search">
                <div class="board-title">
                    <h3 class="board-tit"><span>아이디</span> 찾기</h3>
                    <div>
                        <span>회원가입 시 입력하신 정보를 기입해 주세요.</span>
                        <a href="#"><img src="${pageContext.request.contextPath}/images/utility/btn_idpw_search.png" alt="열기/닫기" /></a>
                    </div>
                </div>
                <div class="board-input-type none"><form:form id="idSearchFrm" action="idSearchFinish.do" method="post">
                    <table>
                        <caption>아이디찾기 - 이름, 생년월일</caption>
                        <colgroup>
                            <col style="width:65px;" />
                            <col style="width:350px;" />
                            <col style="width:92px;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><label for="name">이름</label></th>
                                <td><input type="hidden" name="birthday">
                                    <input type="text" class="inp-style1" id="name" title="이름 입력" style="width:150px;" name="username" />
                                    <span class="mgl-15">
                                    <label class="radio-skin checked" title="남자"><input type="radio" name="genCd" class="radio-skin" checked="checked" value="100323"/>남자</label>
                                    <label class="radio-skin" title="여자"><input type="radio" name="genCd" class="radio-skin" value="100324"/>여자</label>
                                    </span>
                                </td>
                                <th scope="row"><label for="birthdayYear">생년월일</label></th>
                                <td><fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
                                    <select title="생년월일 연도"  id="birthdayYear">
                                        <c:forEach begin="${1}" end="${70}" var="item">
                                        <option value="${year-item}">${year-item}</option>
                                        </c:forEach>
                                    </select>
                                    <label for="birthdayMonth" class="label-none">생년월일 월</label>
                                    <select title="생년월일 월" id="birthdayMonth">
                                        <c:forEach begin="${1}" end="${12}" var="item">
                                        <option value="${item}">${item}</option>
                                        </c:forEach>
                                    </select>
                                    <label for="birthdayDay" class="label-none">생년월일 일</label>
                                    <select title="생년월일 일"  id="birthdayDay">
                                        <c:forEach begin="${1}" end="${31}" var="item">
                                        <option value="${item}">${item}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table></form:form>
                    <div class="btn-area">
                        <a href="#" class="btn-type2" onClick="idSearch()">아이디찾기</a>
                    </div>
                </div>
            </div>
            <!-- //아이디 찾기 -->

            <!-- 비밀번호 찾기 -->
            <div class="pw-search">
                <div class="board-title">
                    <h3 class="board-tit"><span>비밀번호</span> 찾기</h3>
                    <div>
                        <span>입력하신 정보가 확인되면 비밀번호를 새로 발급해 드립니다.</span>
                        <a href="#"><img src="${pageContext.request.contextPath}/images/utility/btn_idpw_search.png" alt="열기/닫기" /></a>
                    </div>
                </div>
                <div class="board-input-type"><form id="pwSearchFrm">
                    <table>
                        <caption>비밀번호찾기 - 아이디, 생년월일, 비밀번호찾기 질문</caption>
                        <colgroup>
                            <col style="width:136px;" />
                            <col style="width:282px;" />
                            <col style="width:114px;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><label for="user-id">아이디</label></th>
                                <td>
                                    <input type="text" class="inp-style1" title="아이디 입력" id="user-id" style="width:150px;" name="id" />
                                </td>
                                <th scope="row"><label for="birth-year1">생년월일</label></th>
                                <td><input type="hidden" name="birthday">
                                    <select title="생년월일 연도"  id="birthdayYearForPass">
                                        <c:forEach begin="${1}" end="${70}" var="item">
                                        <option value="${year-item}">${year-item}</option>
                                        </c:forEach>
                                    </select>
                                    <label for="birthdayMonth" class="label-none">생년월일 월</label>
                                    <select title="생년월일 월" id="birthdayMonthForPass">
                                        <c:forEach begin="${1}" end="${12}" var="item">
                                        <option value="${item}">${item}</option>
                                        </c:forEach>
                                    </select>
                                    <label for="birthdayDay" class="label-none">생년월일 일</label>
                                    <select title="생년월일 일"  id="birthdayDayForPass">
                                        <c:forEach begin="${1}" end="${31}" var="item">
                                        <option value="${item}">${item}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><label for="pw-question">비밀번호찾기 질문</label></th>
                                <td colspan="3" class="pw-question">
                                    <select id="pw-question" title="질문 선택" name="pwdQuestCd" style="width:270px;">
                                        <c:forEach items="${code100221}" var="item">
                                            <option value="${item.cd}">${item.cdNm}</option>
                                        </c:forEach>
                                    </select>
                                    <label for="question-answer" class="label-none">질문에 대한 답변</label>
                                    <input type="text" id="question-answer" class="inp-style1" style="width:414px;" title="질문에 대한 답변" placeholder="질문에 대한 답변" name="pwdAnsSust" />
                                </td>
                            </tr>
                        </tbody>
                    </table></form>
                    <div class="btn-area">
                        <a href="javascript:void(0)" class="btn-type2" onClick="pwSearch()">비밀번호찾기</a>
                    </div>
                </div>
            </div>
            <!-- //비밀번호 찾기 -->

            <!-- 이메일로 찾기 -->
            <div class="email-search">
                <div class="board-title">
                    <h3 class="board-tit"><span>이메일</span>로 아이디/비밀번호찾기</h3>
                    <div>
                        <span>회원 가입 시 등록하신 이메일 주소를 기재해주세요.<br />아이디와 임시비밀번호를 보내 드립니다.</span>
                        <a href="#"><img src="${pageContext.request.contextPath}/images/utility/btn_idpw_search.png" alt="열기/닫기" /></a>
                    </div>
                </div>
                <div class="board-input-type"><form:form id="searchWithEmailFrm">
                    <table>
                        <caption>이메일로 아이디/비밀번호찾기 - 이메일 주소</caption>
                        <colgroup>
                            <col style="width:136px;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><label for="email-adrs">이메일 주소</label></th>
                                <td colspan="3"><input type="hidden" name="emailAddr" />
                                    <input type="text" id="email-adrs1" class="inp-style1" title="이메일주소 입력" style="width:180px;" /> @
                                    <label for="email-adrs2" class="label-none">도메인 선택</label>
                                    <select id="email-adrs2" title="도메인 선택" style="width:160px;">
                                    <option value="">직접입력</option>
                                    <c:forEach items="${code100533}" var="item">
                                        <option value="${item.cdNm}">${item.cdNm}</option>
                                    </c:forEach>
                                    </select>
									<label for="email-adrs3" class="label-none">도메인 직접입력</label>
                                    <input type="text" title="도메인 직접입력" id="email-adrs3" style=""/>
                                </td>
                            </tr>
                            <!-- 도메인 직접 입력 시 출력
                            <tr>
                                <th scope="row"><label for="domain-form">도메인 입력</label></th>
                                <td colspan="3"><input type="text" id="domain-form" class="inp-style1" title="도메인 입력" style="width:180px;" name="" /></td>
                            </tr>
                             -->
                        </tbody>
                    </table></form:form>
                    <div class="btn-area">
                        <a href="javascript:void(0);" class="btn-type2" onClick="searchWithEmail()">아이디/비밀번호찾기</a>
                    </div>
                </div>
            </div>
            <!-- //이메일로 찾기 -->
        </div>

    </div>
</div>

    <div class="cont-quick">
        <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
    </div>

<a href="#pwPopup" class="btn-border-type layer-open" title="패스워드 찾기 팝업 - 열기" style="display:none" id="pwPopBtn">패스워드 찾기</a>
<div class="layer-pop-wrap" id="pwPopup">
    <div class="layer-pop class m-blind">
        <div class="layer-header">
            <strong class="title">비밀번호 찾기</strong>
        </div>
        <div class="layer-cont">
            <div class="box-style none-border">
                <strong class="title-style">임시비밀번호 발급 완료</strong>
                <div class="box-style2 border">
                    <p><strong>임시비밀번호</strong><em id="tempPw"></em></p>
                </div>
                <ul class="pass-info">
                    <li>비밀번호 입력란에 임시비밀번호를 복사하여 붙여 넣으시면<br />보다 편리하게 이용하실 수 있습니다.</li>
                    <li>로그인 후, [마이페이지] 메뉴에서 비밀번호를 변경하여 이용하시기 바랍니다.</li>
                </ul>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup cancel">확인</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<script type="text/javascript">
function idSearch(){
    if($("input[name='username']","#idSearchFrm").val() === ""){
        alert("이름을 입력해주세요.");
        return false;
    }
    $("input[name='birthday']","#idSearchFrm").val($("#birthdayYear","#idSearchFrm").val().zf(4)+$("#birthdayMonth","#idSearchFrm").val().zf(2)+$("#birthdayDay","#idSearchFrm").val().zf(2));
    $("#idSearchFrm").submit();
}

function pwSearch(){
    if($("input[name='id']","#pwSearchFrm").val() === ""){
        alert("아이디를 입력해주세요.");
        return false;
    }
    if($("input[name='pwdAnsSust']","#pwSearchFrm").val() === ""){
        alert("비밀번호 찾기 질문에 대한 답을 입력해주세요.");
        return false;
    }
    $("input[name='birthday']","#pwSearchFrm").val($("#birthdayYearForPass","#pwSearchFrm").val().zf(4)+$("#birthdayMonthForPass","#pwSearchFrm").val().zf(2)+$("#birthdayDayForPass","#pwSearchFrm").val().zf(2));
    $.ajax({
        url: "ajax.pwSearchFinish.do",
        data : $("#pwSearchFrm").serialize(),
        method:"post",
        success: function(rtnData) {
            if(rtnData.success === "true"){
                $("#tempPw").text(rtnData.password);
                $("#pwPopBtn").click();
            }else{
                alert(rtnData.message);
            }
        }
    });
}

function searchWithEmail(){
    if($("#email-adrs1","#searchWithEmailFrm").val() === "" || $("#email-adrs3","#searchWithEmailFrm").val() ===""){
        alert("이메일 주소를 올바르게 입력해주세요.\n예) abc@abc.com");
        return false;
    }
    $("input[name='emailAddr']","#searchWithEmailFrm").val($("#email-adrs1","#searchWithEmailFrm").val()+"@"+$("#email-adrs3","#searchWithEmailFrm").val());
    $.ajax({
        url: "ajax.idPwSearchWithEmail.do",
        data : $("#searchWithEmailFrm").serialize(),
        method:"post",
        success: function(rtnData) {
            alert(rtnData.message);
        }
    });
}
$(function(){
    $("#email-adrs2").change(function(){
        if($(this).val() === ""){
            $("#email-adrs3").show();
        }else{
            $("#email-adrs3").hide();
        }
        $("#email-adrs3").val($(this).val());
    });
<c:if test="${!empty message}">
    alert("${message}");
</c:if>
})
</script>
