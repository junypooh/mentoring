<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div id="container">

    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">로그인</span>
        <span>동의 메일 재발송</span>
    </div>
    <div class="content sub">
    <form:form id="resendForm" method="post" commandName="user">
        <%--<form:input type="hidden" path="mbrNo"/>--%>
        <input type="hidden" name="mbrNo" id="mbrNo" value="${user.mbrNo}"/>
        <h2 class="txt-type">보호자동의메일재발송</h2>
        <p class="tit-desc-txt">로그인을 위해서 보호자 동의가 필요합니다.</p>
        <div class="protector_mail">
            <em>회원 가입 시 기재하신 아래의 주소로 보호자 동의여부 메일을 발송하였습니다.</em>
            <p>
                메일을 다시 발송하기 원하시면 이메일 주소 입력 후<br/><span>[보호자 동의 메일 다시 발송]</span>을 눌러주세요.
            </p>
            <span class="mail-form">
                <label class="label-none" for="prtctrEmailAddr">이메일</label>
                <input type="text" name="prtctrEmailAddr" id="prtctrEmailAddr" value="${user.prtctrEmailAddr}"/>
            </span>
            <div class="btn-area">
                <a href="#" class="btn-type2 w-auto" onclick="resendMail();">보호자 동의 메일 다시 발송</a>
            </div>
        </div>
    </form:form>
    </div>
</div>

<div class="cont-quick">
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
<%--
<div class="cont-quick double">
    <a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a>
    <a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
--%>

<script type="text/javascript">

function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/);
    return pattern.test(emailAddress);
}
function resendMail(){
    if(!isValidEmailAddress($("#prtctrEmailAddr").val())){
        alert("이메일 주소를 올바르게 입력해주세요.\n예) abc@abc.com");
        return false;
    }

    $.ajax({
        url: "ajax.resendMail.do",
        data: $('#resendForm').serialize(),
        method:"post",
        success: function(rtnData) {
            alert(rtnData.message);
        }
    });
}
</script>