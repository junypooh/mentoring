<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="username" property="principal.username" />
</security:authorize>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>푸시알림발송 </h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>알림관리</li>
            <li>푸시알림발송 </li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-email">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">발송대상</th>
                    <td>
                        <input type="radio" name="osType" value="" checked="checked">전체</input>
                        <input type="radio" name="osType" value="android" >안드로이드</input>
                        <input type="radio" name="osType" value="ios" >아이폰</input>
                    </td>
                </tr>
                <tr>
                    <th scope="col">푸시메시지</th>
                    <td>
                        <span><input id="pushContent" name="pushContent" style="width:60%" type="text" value="" maxlength="33"/></span><span style="padding-left:10px;">* 푸시메시지 33자 이내로 입력해주세요.</span>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="sendPush();"><span>발송</span></button></li><!-- 2016-06-10 수정 -->
                <li><button type="button" class="btn-gray" onclick="clearForm();"><span>취소</span></button></li><!-- 2016-06-10 수정 -->
            </ul>
        </div>
    </div>
</div>

<script type="text/javascript">

    function clearForm(){
        if(confirm('작성 내용은 저장되지 않습니다. 취소하시겠습니까?') == true){
            $('#pushContent').val("");
        }
    }

    function sendPush(){

        var message = {
                    'messageRecievers':[],
                    'messageSender':{},
                    'simplePayLoad':{},
                    'sendType': 1,
                    'osType' : undefined
                };

        if($('#pushContent').val() == ''){
            alert('푸시 메시지를 입력하세요.');
            return false;
        }


        message.messageSender.senderName = "산들바람";
        message.simplePayLoad.content = $('#pushContent').val();
        message.simplePayLoad.title = "푸시";
        message.osType = $('input:radio[name=osType]:checked').val();



        $.ajax({
                url: "${pageContext.request.contextPath}/notify/push/ajax.sendMessage.do",
                data : JSON.stringify(message),
                contentType: "application/json",
                dataType : "json",
                cache: false,
                method:"post",
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('푸시 메시지 발송을 요청하였습니다.');
                    } else {
                        alert(rtnData.message);
                    }

                }
        });

    }

</script>

