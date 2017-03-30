<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<%--<div class="page-loader" style="display:none;">
    <img src="${pageContext.request.contextPath}/images/img_page_loader.gif" alt="페이지 로딩 이미지">
</div>--%>
<div class="cont">
    <div class="title-bar">
        <h2>문자전송</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>알림관리</li>
            <li>문자전송</li>
        </ul>
    </div>
    <div class="board-area">
        <div class="send-msg-area">
            <div class="send-msg-left">
                <p class="lead-txt">메시지 입력</p>
                <div class="msg-box">
                    <textarea id="smsMessage" name="smsMessage"></textarea>
                    <div class="msg-bot">
                        <span class="count-byte"><strong id="result">0</strong> bytes</span>
                    </div>
                </div>
                <ul class="msg-ps">
                    <li><span>90bytes 이상 입력 시 MMS로 발송됩니다.</li>
                    <li>- SMS  (90bytes 이하) : 건당 30원</li>
                    <li>- MMS (90bytes 초과) : 건당 200원 </li>
                </ul>
            </div>
            <div class="send-msg-right">
            <input type="hidden" id="msgSer" name="msgSer" value="${param.msgSer}"/>
                <table class="tbl-style tbl-message">
                    <colgroup>
                        <col style="width:145px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="col">발송번호</th>
                            <td><input type="text" class="text" id="sender" name="sender" /></td>
                        </tr>
                        <tr>
                            <th scope="col">수신자 불러오기</th>
                            <td><button type="button" id="smsPopup" class="btn-style01"><span>불러오기</span></button></td>
                        </tr>
                        <tr>
                            <th scope="col">수신자 직접입력</th>
                            <td>
                                <input type="text" class="text recipient-name" placeholder="이름" name="appendName" id="appendName" />
                                <input type="text" class="text" placeholder="휴대폰번호(`-`없이 입력)"  name="appendNumber" id="appendNumber" />
                                <button type="button" class="btn-style01" onclick="appendReceiver();"><span>추가</span></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div id="boardArea" class="board-area">
                    <div class="board-bot">
                        <p class="bullet-gray">수신자목록</p>
                        <ul>
                            <li class="mr10"><button type="button" class="btn-gray" onclick="delRow();"><span>삭제</span></button></li><!-- 2016-06-10 수정 -->
                        </ul>
                    </div>
                    <table id="boardTable"></table>
                </div>
            </div>
        </div>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="sendSMS();"><span>문자전송</span></button></li><!-- 2016-06-10 수정 -->
            </ul>
        </div>
    </div>
<c:import url="/popup/smsSearch.do">
  <c:param name="popupId" value="_smsPopup" />
  <c:param name="callbackFunc" value="callbackSmsSelected" />
</c:import>
<script type="text/javascript">
    var searchFlag = 'load';
    var rowCnt = 0;

    $(document).ready(function() {

        var $input = $("#smsMessage");
        var $count = $('#result', this);

        var maximumByte = 2000;
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
            alert(maximumByte);
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

        var colModels = [];
        colModels.push({label:'no', name:'rn',index:'rn', width:80, align:'center', sortable: false});
        colModels.push({label:'회원번호', name:'memberNo',index:'memberNo', width:80, align:'center', sortable: false, hidden: true});
        colModels.push({label:'회원유형', name:'mbrCualfNm',index:'mbrCualfNm', width:190, align:'center', sortable: false, key: true});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:190, align:'center', sortable: false});
        colModels.push({label:'소속', name:'posconm',index:'posconm', width:80, align:'center', sortable: false});
        colModels.push({label:'이름', name:'username',index:'username', width:80, align:'center', sortable: false});
        colModels.push({label:'전화번호', name:'mobile',index:'mobile', width:80, align:'center', sortable: false});
        initJqGridTable('boardTable', 'boardArea', 1300, colModels,  true, 310);

        if("${sendResultDTO.sendMsg}" != null && "${sendResultDTO.sendMsg}" != ''){
            $("#smsMessage").text("${sendResultDTO.sendMsg}");
            update();
        }
        var sendTargtSers = "${sendResultDTO.sendTargtSers.size()}"
        if(("${sendResultDTO.msgSer}" != null && "${sendResultDTO.msgSer}" != '' ) || Number(sendTargtSers) > 0 ){
            loadHistoryCall();
        }else{
            var schoolData = "";
            var emptyText ="대상이 존재하지 않습니다.";
            setDataJqGridTable('boardTable', 'boardArea', 500, schoolData, emptyText);
        }

        $("#smsPopup").click(function(){
            $('body').addClass('dim');
            $(".popup-area").css("display","");
            $("input[name=keyword]").val("");
            var xmlData ="";
            initJqGridTable('userList', 'popBoardArea', 500, colModels,  true, 310);
            var emptyText = "대상을 선택해주세요.";
            setDataJqGridTable('userList', 'popBoardArea', 500, "", emptyText, 310);

        });

    });

    function callbackSmsSelected(smsInfos){
        $("#closePopup").click();
        var selSms =  $('#boardTable').jqGrid('getDataIDs');
        var inputs = "";
        var send = false;
        var mbrNos = new Array();
        $.each(smsInfos, function(idx){
            // 중복 제거
            var selSmsList =  $('#boardTable').jqGrid('getRowData', smsInfos[idx]);
            if(selSmsList.username == null) {
                mbrNos.push(smsInfos[idx]);
                inputs+="<input type='hidden' name='" + "schNos".format(idx) + "' value='"+ smsInfos[idx] +"' />";
                send = true;


            }
        });
        if(send == true){
            var _param = {'mbrNos':mbrNos
                                   };
            $.ajax({
                url: '${pageContext.request.contextPath}/user/manager/ajax.searchUser.do',
                data : JSON.stringify(_param),
                contentType: "application/json",
                dataType: 'json',
                method:"post",
                cache: false,
                success: function(data) {


                    var emptyText = "조건에 맞는 회원이 존재하지 않습니다.";

                    var data2 = new Array();
                    var smsData = data.map(function(item, index) {

                        var regExp = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
                        var disabled = (!regExp.test( item.mobile ) )  ? true : false;

                        if(!disabled){
                            item.gridRowId = item.mbrNo;
                            item.memberNo = item.mbrNo;
                            item.mobile = item.mobile;
                            item.rn = rowCnt+1;
                            data2[rowCnt] = item;
                            rowCnt++;
                        }else{
                            item.mobile = "";
                        }
                        if(searchFlag != 'load'){
                            $('#boardTable').jqGrid('addRowData', item.mbrNo, item);
                        }
                        return item;
                    });

                    if(searchFlag == 'load'){
                        setDataJqGridTable('boardTable', 'boardArea', 500, data2, emptyText, 310);
                        searchFlag ="";
                    }
                }
            });
        }
    }
    function appendReceiver(){
        var selSms =  $('#boardTable').jqGrid('getDataIDs');
        var regExp = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;


        if($('#appendName').val() == ''){
          alert("이름을 입력하세요.");
          $('#appendName').focus();
          return false;
        }

        if ( !regExp.test( $('#appendNumber').val() ) ) {
            alert("잘못된 휴대폰 번호입니다. 숫자만 입력하세요.");
            $('#appendNumber').focus();
            return false;
        }

        var addData = new Object();
        addData.rn = selSms.length+1;
        addData.gridRowId = $('#appendName').val()+addData.rn;
        addData.mbrCualfNm = "직접입력";
        addData.sidoNm = "직접입력";
        addData.posconm = "직접입력";
        addData.username = $('#appendName').val();
        addData.mobile = $('#appendNumber').val();
        var emptyText = "조건에 맞는 회원이 존재하지 않습니다.";

        if(searchFlag == 'load'){
            setDataJqGridTable('boardTable', 'boardArea', 500, addData, emptyText, 310);
            searchFlag ="";
            $('#boardTable').jqGrid('addRowData', addData.gridRowId, addData);
        }else{
            $('#boardTable').jqGrid('addRowData', addData.gridRowId, addData);
        }
        rowCnt++;
    }

    function delRow(){
        var selSms =  $('#boardTable').jqGrid('getGridParam','selarrrow');
        if(selSms.length > 0){
        var i = selSms.length;
            for(i;i>selSms.length-1;i--){
                delDataJqGridTable('boardTable',selSms[i-1]);
            }
        }else{
            alert("삭제할 수신자를 선택해주세요");
        }
        schoolData = "";
        var selSms =  $('#boardTable').jqGrid('getDataIDs');
        if(selSms.length < 1){
            rowCnt = 0;
            var schoolData = "";
            var emptyText ="대상이 존재하지 않습니다.";
            setDataJqGridTable('boardTable', 'boardArea', 500, schoolData, emptyText, 310);
            searchFlag ="load";
        }

    }

    function sendSMS(){
        var regExp = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
        var regExp2 = /^\d{2,3}-\d{3,4}-\d{4}$/;
        var num_regx=/^[0-9]*$/;
        var message = {
            'messageRecievers':[],
            'messageSender':{},
            'simplePayLoad':{'message':{'sendTitle':''}},
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

        if (($('#sender').val().length >= 9 && $('#sender').val().length < 12) && num_regx.test( $('#sender').val()) ) {
        }else{
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

        var delChk = true;
        var inputs = "";
        var selSms =  $('#boardTable').jqGrid('getGridParam','selarrrow');



        $.each(selSms, function(idx){
            var messageReciever = new Object();
            messageReciever.memberNo = $('#boardTable').jqGrid('getRowData', selSms[idx]).memberNo;
            messageReciever.telNo = $('#boardTable').jqGrid('getRowData', selSms[idx]).mobile;
            messageReciever.name = $('#boardTable').jqGrid('getRowData', selSms[idx]).username;
            message.messageRecievers.push(messageReciever);
        });

        if(message.messageRecievers.length == 0){
            alert('받는 사람을 선택하세요.');
            return false;
        }
        var sendContent = new Object();
        message.messageSender.mobileNum = $('#sender').val();

        message.simplePayLoad.content = $('#smsMessage').val();
        message.simplePayLoad.title = "메시지 전송";

        message.simplePayLoad.message.sendTitle = "메시지 전송";

        $.ajax({
                url: "${pageContext.request.contextPath}/notify/sms/ajax.sendMessage.do",
                data : JSON.stringify(message),
                contentType: "application/json",
                dataType : "json",
                cache: false,
                method:"post",
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('문자 발송을 요청하였습니다.');
                    } else {
                        alert(rtnData.message);
                    }

                }
        });
    }

    function loadHistoryCall(){
    var sendTargtSer;
    var msgSer = '${sendResultDTO.msgSer}';
    sendTargtSer ='${sendResultDTO.sendTargtSers}';

        var _param = {
        'sendTargtSer':sendTargtSer,
        'msgSer':msgSer,
        'sendTargtCd':'101673',
                                           };
        $.ajax({
            url: '${pageContext.request.contextPath}/user/manager/ajax.searchHistoryUser.do',
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType: 'json',
            method:"post",
            cache: false,
            success: function(data) {
                var emptyText = "조건에 맞는 회원이 존재하지 않습니다.";

                var data2 = new Array();
                var smsData = data.map(function(item, index) {
                    if(item.mbrNo != null){

                        item.gridRowId = item.mbrNo;
                        var regExp = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
                        var disabled = (!regExp.test( item.mobile ) )  ? true : false;

                        if(!disabled){
                            item.mobile = item.mobile;
                            item.rn = rowCnt+1;
                            data2[rowCnt] = item;
                            rowCnt++;
                        }else{
                            item.mobile = "";
                        }
                    }else{
                        item.gridRowId = item.sendTargtMbrNo;
                        var regExp = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
                        var disabled = (!regExp.test( item.sendTargtInfo ) )  ? true : false;

                        if(!disabled){
                            item.mobile = item.sendTargtInfo;
                            item.rn = rowCnt+1;
                            item.mbrCualfNm = "직접입력";
                            item.sidoNm = "직접입력";
                            item.posCoNm = "직접입력";
                            item.username = "직접입력";
                            data2[rowCnt] = item;
                            rowCnt++;
                        }else{
                            item.mobile = "";
                        }

                    }
                    if(searchFlag != 'load'){
                        $('#boardTable').jqGrid('addRowData', item.mbrNo, item);
                    }
                    return item;
                });

                if(searchFlag == 'load'){
                    setDataJqGridTable('boardTable', 'boardArea', 500, data2, emptyText, 310);
                    searchFlag ="";
                }
                var idArry = $("#boardTable").jqGrid('getDataIDs'); //grid의 id 값을 배열로 가져옴

                for(var i=0 ; i < idArry.length; i++){
                    var ret =  $("#userList").getRowData(idArry[i]); // 해당 id의 row 데이터를 가져옴

                    if("1" != ret.column1){ //해당 row의 특정 컬럼 값이 1이 아니면 multiselect checkbox disabled 처리
                      //해당 row의 checkbox disabled 처리 "jqg_list_" 이 부분은 grid에서 자동 생성
                      $("#jqg_list_"+idArry[i]).attr("disabled", true);
                    }
                }

            }
        });
    }
</script>
