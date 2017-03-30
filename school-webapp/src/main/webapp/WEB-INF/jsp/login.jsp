<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<c:if test="${not empty param.error and not empty SPRING_SECURITY_LAST_EXCEPTION}">
    <script type="text/javascript">
    $().ready(function() {
        alert('${SPRING_SECURITY_LAST_EXCEPTION.message}');
    });
    </script>
</c:if>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">로그인</span>
    </div>
    <div class="content sub">
        <form:form action="${pageContext.request.contextPath}/j_spring_security_check.do" method="post">
        <h2 class="txt-type">회원로그인</h2>
        <p class="tit-desc-txt">사이트를 이용하기 위하여 로그인이 필요합니다. 아래의 로그인 정보를 입력해주세요.</p>
        <div class="login-box">
            <div class="box-line">
                <span class="id">
                    <span>
                        <label class="label-none" for="user_id">아이디</label>
                        <input type="text" id="user_id" title="아이디 입력"name="username" class="inp-style1" placeholder="아이디 입력" />
                    </span>
                </span>
                <span class="pw">
                    <span>
                        <label class="label-none" for="user_pw">비밀번호</label>
                        <input type="password" title="비밀번호 입력" id="user_pw" name="password" class="inp-style1" placeholder="비밀번호 입력" />
                    </span>
                    <span class="caps-lock">
                        <em>&lt;Caps Lock&gt;이 켜져 있습니다.</em>
                        <p>
                            비밀번호 입력 시 영문 대문자, 소문자를 구분합니다.<br/>대문자, 소문자 확인 후 입력해주세요.
                        </p>
                    </span>
                </span>
                <span class="id-save"><label class="chk-skin" title="아이디 저장"><input type="checkbox" id="idSaveCheck" class="chk-skin" />아이디 저장</label></span>
            </div>
            <div class="btn-area">
                <button type="submit" class="btn-type2">로그인</button>
            </div>
            <c:if test="${! isMobile }">
            <div class="info-search">
                <a href="${pageContext.request.contextPath}/join/idPwSearch.do">아이디/비밀번호 찾기</a>
                <a href="${pageContext.request.contextPath}/join/step1.do" class="join">회원가입</a>
            </div>
            </c:if>
        </div>
        <%--<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/> --%>
        <input type="hidden" name="_spring_security_target_url" value="<c:out value="${param._spring_security_target_url}" />"/>
        </form:form>
    </div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    var userInputId = getCookie("username");
    $("input[name='username']").val(userInputId);

    if(userInputId != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
        $("#idSaveCheck").prop("checked", "checked").parent().addClass("checked"); // ID 저장하기를 체크 상태로 두기.
    }

    $("#idSaveCheck").change(function(){ // 체크박스에 변화가 있다면,
        if($("#idSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
            var userInputId = $("input[name='username']").val();
            setCookie("username", userInputId, 7); // 7일 동안 쿠키 보관
        }else{ // ID 저장하기 체크 해제 시,
            deleteCookie("username");
        }
    });

    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("input[name='username']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
        if($("#idSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
            var userInputId = $("input[name='username']").val();
            setCookie("username", userInputId, 7); // 7일 동안 쿠키 보관
        }
    });
});
</script>