<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title> admin-page-login </title>
        <link href="${pageContext.request.contextPath}/css/admin-login.css" type="text/css" rel="stylesheet">
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.11.1.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/mentor.common.js"></script>
        <c:if test="${not empty param.error and not empty SPRING_SECURITY_LAST_EXCEPTION}">
            <script type="text/javascript">
            $().ready(function() {
                alert('${SPRING_SECURITY_LAST_EXCEPTION.message}');
            });
            </script>
        </c:if>
    </head>
    <body>
        <div id="wrap" class="login-wrap">
        <form:form action="${pageContext.request.contextPath}/j_spring_security_check.do" method="post" id="frm">
            <h1 class="admin-title"><a href="#"><img src="${pageContext.request.contextPath}/images/admin-login/img_h1_sdwd.png" alt="산들바람">관리자 페이지</a></h1>
            <div class="login-box-admin" >
                <div class="id">
                    <label for="admin-id"><img src="${pageContext.request.contextPath}/images/admin-login/bg_login_id_admin.png" alt="아이디"></label>
                    <input type="text" name="username" class="inp-style1" placeholder="아이디 입력" />
                </div>
                <div class="pw">
                    <label for="admin-pw"><img src="${pageContext.request.contextPath}/images/admin-login/bg_login_pw_admin.png" alt="비밀번호"></label>
                    <input type="password" name="password" class="inp-style1" placeholder="비밀번호 입력" />
                </div>
                <span class="id-save"><a href="${pageContext.request.contextPath}/join/idPwSearch.do">아이디/비밀번호 찾기</a><label class="chk-skin"><input type="checkbox" class="chk-skin" checked="checked" id="idSaveCheck"/> 아이디 기억하기</label></span>
                <div class="btn-area">
                    <button type="submit" class="btn-type1" >로그인</button>
                </div>
                <%--
                <div class="admin-info-find">
                    <a href="${pageContext.request.contextPath}/join/idPwSearch.do">아이디/비밀번호 찾기</a>
                    <a href="#" class="join">신규 아이디등록</a>
                </div>
                --%>
            </div>
            <button style="display:none"></button>
            <%--
            <p>이용문의: 1600-9548 (stbt@koreaboardgames.com)</p>
            <p>이용문의: 1600-9548 (adminadmin@koreaboardgames.com)</p>
            --%>
        </form:form>
        </div>
    </body>
</html>
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