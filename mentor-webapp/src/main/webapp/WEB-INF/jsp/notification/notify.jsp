<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/notification.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/JSXTransformer.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/mentor.react.js"></script>
<script type="text/javascript">
mentor.contextpath = "${pageContext.request.contextPath}";
mentor.csrf = "${_csrf.token}";
</script>
<div id="wrap">
        <!-- 757 * 707 -->
    <div class="win-pop-wrap">
        <!--
        <div class="title">
            <strong>알림</strong>
            <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"></a>
        </div>
        -->

        <div class="cont-scroll">
            <div class="cont tab-action">
                <ul class="tab">
                    <li class="active" id="smsSendTab"><a href="#" onclick="activateTab('smsSendTab');return false;">문자전송</a></li>
                    <li id="pushSendTab"><a href="#" onclick="activateTab('pushSendTab');return false;">푸시알림 발송</a></li>
                    <li id="emailSendTab"><a href="#" onclick="activateTab('emailSendTab');return false;">이메일 발송</a></li>
                </ul>

                <div class="tab-action-cont">
                    <!-- 문자전송 -->
                    <div class="tab-cont active">
                        <form name="smsForm" method="post">
                        <div class="message-send">
                            <div class="phone-wrap">
                                <div class="phone">
                                    <dl>
                                        <dt>보내는 사람 번호</dt>
                                        <dd><input type="text" name="sender" id="sender" maxlength="11"/></dd>
                                        <dt>전송 메시지</dt>
                                        <dd><textarea name="smsMessage" id="smsMessage" rows="" cols="" ></textarea>
                                            <p><span id="result">0</span>/최대 90byte입력 (건 별 30원)</p>
                                        </dd>
                                    </dl>
                                </div>
                                <div class="message-btn-area">
                                    <a href="#" onclick="sendSMS();return false;">문자전송</a>
                                </div>
                            </div>
                            <div class="number-list">
                                <%--<p>※ 수신폰이 스팸차단 서비스에 등록된 경우 성공이나 미수신 될 수 있습니다.<br/>전송 및 결제 내역 조회는 SMS17 서비스(<span>www.sms17.com</span>) 에서 조회 가능합니다.  </p>--%>
                                <strong class="tit">받는 사람 번호</strong>
                                <div id="smsTargetDataList"></div>
                            </div>
                        </div>
                        </form>

                    </div>
                    <!-- //문자전송 -->

                    <!-- 푸시알림 발송 -->
                    <div class="tab-cont">
                        <form name="pushForm" method="post" action="">
                        <div class="push-btn">
                            <a href="#" onclick="sendPush();return false;">발송</a>
                            <a href="#" class="gray" onclick="clearPush();">취소</a>
                        </div>
                        <div class="number-board push-send">
                            <table>
                                <caption></caption>
                                <colgroup>
                                    <col style="width:102px" />
                                    <col />
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">대상 앱</th>
                                        <td>앱 이름: 산들바람</td>
                                    </tr>
                                    <tr>
                                        <th scope="row">푸시 메시지</th>
                                        <td>
                                            <input type="text" class="push" name="pushContent" id="pushContent" maxlength="33"/>
                                            <span>* 푸시메시지 33자 이내로 입력해주세요.</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">발송 대상</th>
                                        <td class="board">
                                            <div id="pushTargetDataList"></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        </form>
                    </div>
                    <!-- //푸시알림 발송 -->

                    <!-- 이메일 발송 -->
                    <div class="tab-cont">
                        <form name="emailForm" method="post" action="">
                        <div class="push-btn">
                            <a href="#" onclick="sendEmail();">발송</a>
                            <a href="#" class="gray" onclick="clearEmail();">취소</a>
                        </div>
                        <div class="number-board push-send">
                            <table class="email-send">
                                <caption></caption>
                                <colgroup>
                                    <col style="width:102px">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">발신자 이름</th>
                                        <td><input type="text" value="" name="senderName" id="senderName" /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">발신자 이메일</th>
                                        <td><input type="text" value="" name="emailAddress" id="emailAddress"/></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">제목</th>
                                        <td><input type="text" value="" name="title" id="title" /></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">내용</th>
                                        <td><textarea name="emailContent" id="emailContent" rows="" cols=""></textarea></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">수신자 이메일</th>
                                        <td class="board">
                                            <div id="emailTargetDataList"></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        </form>
                    </div>
                    <!-- //이메일 발송 -->
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/jsx;harmony=true">
    var rtnData;

$(document).ready(

    function(){
            $.ajax({
                url: '${pageContext.request.contextPath}/notification/ajax.selectMessageTargetList.do',
                data : {'keyword': ${keyword}},
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                success: function(data) {
                    rtnData = data;

                    var target = React.render(
                      <SmsTargetData/>,
                      document.getElementById('smsTargetDataList')
                    );
                    target.getList(data);
                }.bind(this),
                error: function(xhr, status, err) {
                    console.error(this.props.url, status, err.toString());
                }.bind(this)
            });


    }


);

</script>
<script type="text/javascript">

    var selectedTab = 'smsSendTab';

    $(function () {
        var $input = $("#smsMessage");

        var $count = $('#result', this);

        var maximumByte = 90;
        // update 함수는 keyup, paste, input 이벤트에서 호출한다.
        var update = function () {
            var str_len = $input.val().length;
            var cbyte = 0;
            var li_len = 0;
            for (i = 0; i < str_len; i++) {
                var ls_one_char = $input.val().charAt(i);
                if (escape(ls_one_char).length > 4) {
                    cbyte += 2; //한글이면 2를 더한다
                } else {
                    cbyte++; //한글아니면 1을 다한다
                }
                if (cbyte <= maximumByte) {
                    li_len = i + 1;
                }
            }
            // 사용자가 입력한 값이 제한 값을 초과하는지를 검사한다.
            if (parseInt(cbyte) > parseInt(maximumByte)) {
                alert('허용된 글자수가 초과되었습니다.\r\n\n초과된 부분은 자동으로 삭제됩니다.');
                var str = $input.val();
                var str2 = $input.val().substr(0, li_len);
                $input.val(str2);
                var cbyte = 0;
                for (i = 0; i < $input.val().length; i++) {
                    var ls_one_char = $input.val().charAt(i);
                    if (escape(ls_one_char).length > 4) {
                        cbyte += 2; //한글이면 2를 더한다
                    } else {
                        cbyte++; //한글아니면 1을 다한다
                    }
                }
            }
            $count.text(cbyte);
        };
        // input, keyup, paste 이벤트와 update 함수를 바인드한다
        $input.bind('input keyup keydown paste change', function () {
            setTimeout(update, 0)
        });
        update();
    }
    );



    function allToggle(check){
        var targetName;

        if(selectedTab == 'smsSendTab')
            targetName = 'smsTarget';
        else if(selectedTab == 'pushSendTab')
            targetName = 'pushTarget';
        else if(selectedTab == 'emailSendTab')
            targetName = 'emailTarget';

        if(check){
            $('[name='+ targetName +']').each(function(index){
                var thx = $(this);
                if(this.checked)
                    thx.click();
            });
        }else{
            $('[name='+ targetName +']').each(function(index){
                var thx = $(this);
                if(!this.checked)
                    thx.click();
            });
        }
    }

    function clearEmail(){
        $('#senderName').val("");
        $('#emailAddress').val('');
        $('#title').val('');
        $('#emailContent').val('');

        if($('#emailTargetDataList #checkAll').is(":checked"))
            $('#emailTargetDataList #checkAll').click();

        allToggle(true);

    }

    function clearPush(){
        $('#pushContent').val('');

        if($('#pushTargetDataList #checkAll').is(":checked"))
            $('#pushTargetDataList #checkAll').click();

        allToggle(true);
    }


    function sendSMS(){
        var regExp = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
        var message = {
            'messageRecievers':[],
            'messageSender':{},
            'simplePayLoad':{},
            'sendType': 4

        };


        // 필요에 따라 송신자의 전화번호의 유효성을 체크한다.
        // 유효하지 않다면 체크박스를 강제로 해제시킨다.
        /*
        $('[name=smsTarget]').each(function(index){
            alert(index + "::::" + this.checked);
        });
        */

        if($('#sender').val() == ''){
            alert('보내는 사람 번호를 입력하세요.');
            $('#sender').focus();
            return false;
        }

        if ( !regExp.test( $('#sender').val() ) ) {
                alert("잘못된 휴대폰 번호입니다. 숫자만 입력하세요.");
                $('#sender').val('');
                $('#sender').focus();
              return false
        }

        if($('#smsMessage').val() == ''){
            alert('전송메시지를 입력하세요.');
            $('#smsMessage').focus();
            return false;
        }

        $(".number-board input:checkbox[name='smsTarget']").each(
            function (index) {
                if(this.checked){
                    var messageReciever = new Object();
                    messageReciever.memberNo = this.value;
                    messageReciever.telNo = $('input[name="telNo"]')[index].value;
                    message.messageRecievers.push(messageReciever);
                }
            }
        );

        if(message.messageRecievers.length == 0){
            alert('받는 사람을 선택하세요.');
            return false;
        }

        message.messageSender.mobileNum = $('#sender').val();
        message.messageSender.mbrNo = '${keyword}';
        message.simplePayLoad.content = $('#smsMessage').val();

        $.ajax({
                url: "${pageContext.request.contextPath}/notification/ajax.sendSms.do",
                data : JSON.stringify(message),
                contentType: "application/json",
                dataType : "json",
                cache: false,
                method:"post",
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('문자전송을 요청하였습니다.');
                    } else {
                        alert(rtnData.message);
                    }

                }
            });


    }

    function sendPush(){

        var message = {
                    'messageRecievers':[],
                    'messageSender':{},
                    'simplePayLoad':{},
                    'sendType': 1

                };

        var sendMessage = $('#pushContent').val();
        if(sendMessage.length > 33){
            alert('33자이내로 입력하세요.');
            $('#pushContent').focus();
            return false;
        }

        if($('#pushContent').val() == ''){
            alert('푸시 메시지를 입력하세요.');
            return false;
        }

        $(".number-board input:checkbox[name='pushTarget']").each(
            function (index) {
                if(this.checked){
                    var messageReciever = new Object();
                    messageReciever.memberNo = this.value;
                    messageReciever.deviceToken = $('input[name="deviceToken"]')[index].value;
                    messageReciever.osType = $('input[name="osType"]')[index].value;
                    message.messageRecievers.push(messageReciever);
                }
            }
        );

        if(message.messageRecievers.length == 0){
            alert('수신자를 선택하세요.');
            return false;
        }

        message.messageSender.senderName = "산들바람";
        message.messageSender.mbrNo = '${keyword}';
        message.simplePayLoad.content = $('#pushContent').val();

        $.ajax({
                url: "${pageContext.request.contextPath}/notification/ajax.sendSms.do",
                data : JSON.stringify(message),
                contentType: "application/json",
                dataType : "json",
                cache: false,
                method:"post",
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('푸시 알림 전송을 요청하였습니다.');
                    } else {
                        alert(rtnData.message);
                    }
                }
            });
    }

    function sendEmail(){

        var regExp = /^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

        var message = {
            'messageRecievers':[],
            'messageSender':{},
            'simplePayLoad':{},
            'sendType': 2

        };


        // 필요에 따라 송신자의 전화번호의 유효성을 체크한다.
        // 유효하지 않다면 체크박스를 강제로 해제시킨다.
        /*
        $('[name=emailTarget]').each(function(index){
            alert(index + "::::" + this.checked);
        });
        */

        if($('#senderName').val() == ''){
            alert('발신자 이름을 입력하세요.');
            $('#senderName').focus();

            return false;
        }

        if ( !regExp.test( $('#emailAddress').val() ) ) {
              alert("잘못된 메일 유형입니다. 확인바랍니다.");
              $('#emailAddress').focus();
              return false
        }

        if($('#title').val() == ''){
            alert('제목을 입력하세요.');
            $('#title').focus();
            return false;
        }

        if($('#emailContent').val() == ''){
            alert('내용을 입력하세요.');
            $('#emailContent').focus();
            return false;
        }

        $(".number-board input:checkbox[name='emailTarget']").each(
            function (index) {
                if(this.checked){
                    var messageReciever = new Object();
                    messageReciever.memberNo = this.value;
                    messageReciever.mailAddress = $('input[name="mailAddress"]')[index].value;
                    message.messageRecievers.push(messageReciever);
                }
            }
        );

        if(message.messageRecievers.length == 0){
            alert('수신자를 선택하세요.');
            return false;
        }

        message.messageSender.mailAddress = $('#emailAddress').val();
        message.messageSender.senderName = $('#senderName').val();
        message.messageSender.mbrNo = '${keyword}';
        message.simplePayLoad.title = $('#title').val();
        message.simplePayLoad.content = $('#emailContent').val();

        $.ajax({
                url: "${pageContext.request.contextPath}/notification/ajax.sendSms.do",
                data : JSON.stringify(message),
                contentType: "application/json",
                dataType : "json",
                cache: false,
                method:"post",
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('메일전송을 요청하였습니다.');
                    } else {
                        alert(rtnData.message);
                    }
                }
            });
    }
</script>
<script type="text/jsx;harmony=true" src="${pageContext.request.contextPath}/js/react/message.js"></script>
<script type="text/jsx;harmony=true">
    function activateTab(selectTab){
        selectedTab = selectTab;

        $(".tab:first-child").children().each(
            function(index){
                var tab = $(".tab-action-cont").children()[index];
                if(selectTab == this.id){
                    $(this).addClass('active');
                    $(tab).addClass('active');
                }else{
                    $(this).removeClass('active');
                    $(tab).removeClass('active');
                }
                if(index == 0){
                    var target = React.render(
                                          <SmsTargetData/>,
                                          document.getElementById('smsTargetDataList')
                                        );
                    target.getList(rtnData);
                }

                if(index == 1){
                    var target = React.render(
                                          <PushTargetData/>,
                                          document.getElementById('pushTargetDataList')
                                        );
                    target.getList(rtnData);
                }
                if(index == 2){
                    var target = React.render(
                                          <EmailTargetData/>,
                                          document.getElementById('emailTargetDataList')
                                        );
                    target.getList(rtnData);
                }
            }
        );

    }
</script>
