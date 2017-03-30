<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
 <security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
</security:authorize>
<c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
    <script type="text/javascript">
    $().ready(function() {
        alert('${SPRING_SECURITY_LAST_EXCEPTION.message}');
    });
    </script>
</c:if>
<c:choose>
<c:when test="${empty id}">

        <form:form action="${pageContext.request.contextPath}/mobile/j_spring_security_check.do" method="post">
        <input type="hidden" id="osInfo" name="osInfo" value=""/>
        <input type="hidden" id="token" name="token" value=""/>


            <div class="login-wrap">
                <div class="login-top"><img src="${pageContext.request.contextPath}/mobile/images/utility/bg_title.jpg" alt="산들바람 원격진로멘토링"></div>
                <div class="login-box">
                    <div class="login id">
                        <label for="loginId">아이디</label>
                        <input type="text" id="user_id" title="아이디 입력" name="username" class="inp-style1"  placeholder="아이디를 입력하세요." >
                    </div>
                    <div class="login pw">
                        <label for="loginPw">비밀번호</label>
                        <input type="password" title="비밀번호 입력" id="user_pw" name="password" class="inp-style1" placeholder="비밀번호를 입력하세요." >
                    </div>
<!-- 					<label for="chkKeep" class="chk-skin" ><input type="checkbox" id="remember_me" name ="_spring_security_remember_me" >로그인 유지</label> -->
                    <label for="_spring_security_remember_me" class="chk-skin" title="로그인 유지"><input type="checkbox" id="_spring_security_remember_me" name ="_spring_security_remember_me" >로그인 유지</label>
                    <div class="btn-area">
                        <button type="submit" class="btn-type-01" id="loginButton">로그인</button>
                    </div>
                </div>
                <!--p class="login-info-txt" style="margin-top:0px;">회원가입, 아이디 및 비밀번호 찾기는 <br> 산들바람 학교 웹사이트 <a href="#">PC버전</a>으로 접속하세요.</p-->
                <p class="login-info-txt" style="margin-top:0px;">회원가입, 아이디 및 비밀번호 찾기는 <br> 산들바람 진로멘토링 <a href="#">홈페이지</a>로 접속하세요.</p>
                <!--<p style="padding-top:10px;text-align:center;">
                    <a href="http://www.moe.go.kr/main.do" target="_blank">
                        <img src="${pageContext.request.contextPath}/mobile/images/utility/logo.png" style="margin-right:20px;width:86px"/>
                    </a>

                    <a href="http://www.krivet.re.kr/ku/index.jsp" target="_blank">
                        <img src="${pageContext.request.contextPath}/mobile/images/utility/logo2.gif" style="width:168px;margin-bottom:3px"/>
                    </a>
                </p>-->

            </form:form>
        </div>
</c:when>
<c:otherwise>

<script type="text/javascript">
    var url = mentor.contextpath + "/mobile/main.do";
    $(location).attr('href', url);
</script>

</c:otherwise>
</c:choose>
<script type="text/javascript">
$(document).ready(function(){
    <c:choose>
    <c:when test="${empty id}">
// 		var username = null;
// 		var password = null;
    </c:when>
    <c:otherwise>
    </c:otherwise>
    </c:choose>

    $("#remember_me").change(function(){ // 체크박스에 변화가 있다면,
        if($("#remember_me").is(":checked")){ // ID 저장하기 체크했을 때,
            var userInputId = $("input[name='username']").val();
        }else{ // ID 저장하기 체크 해제 시,
        }
    });

//     // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("input[name='username']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
        if($("#remember_me").is(":checked")){ // ID 저장하기를 체크한 상태라면,
            var userInputId = $("input[name='username']").val();
        }
    });

    // 로그인 클릭
    $('#loginButton').click(function() {
        if($("#_spring_security_remember_me").is(":checked")){
            var userInputId = $("input[name='username']").val();
            var passInputId = $("input[name='password']").val();
            setAutoLogin(userInputId,passInputId);
        }else{
            setAutoLogin("","")
        }
    });
});

function setToken(obj){

     $("input[name='token']").val(obj);
     $("input[name='osInfo']").val(currentOS);
}
function setUserName(name,pass){
    if((name =="")||(pass =="")||(name ==null)||(pass ==null)||(name ==undefined)||(pass ==undefined)){
        //
    }else{
          $("input[name='username']").val(name);
          $("input[name='password']").val(pass);
          $('#loginButton').click();
    }

}
</script>