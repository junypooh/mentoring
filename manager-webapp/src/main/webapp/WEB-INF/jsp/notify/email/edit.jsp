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
        <h2>이메일 발송</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>알림관리</li>
            <li>이메일 발송</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
    <form id="frm1" name="frm1" action="list.do">
        <table class="tbl-style tbl-email">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">보내는 사람</th>
                    <td>
                        <input type="text" id="name" name="name" placeholder="이름" class="text input-email01" /> <input type="text" id="sender" name="sender" placeholder="이메일" class="text input-email01" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">받는 사람</th>
                    <td>
                        <input type="text" class="text" id="receiver" readonly="readonly"  placeholder="이메일" name="receiver" />
                        <button type="button" class="btn-style01" id="mailPopup" ><span>불러오기</span></button>
                    </td>
                </tr>
                <tr>
                    <th scope="col">받는 사람(직접입력)</th>
                    <td>
                    <input type="text" class="text" id="receiver2" placeholder="이메일"name="receiver2" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">제목</th>
                    <td>	<input type="text" class="text" id="sendTitle" name="sendTitle"  /></td>
                </tr>
                <tr>
                    <th scope="col">내용</th>
                    <td>
                        <jsp:include page="/layer/editor.do" flush="true">
                            <jsp:param name="wrapperId" value="sust"/>
                            <jsp:param name="contentId" value="sust"/>
                            <jsp:param name="formName" value="frm1"/>
                        </jsp:include>
                        <textarea id="sust" name="sust" style="display:none;"  class="textarea" cols="30" rows="10"></textarea>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="sendEmail();"><span>발송</span></button></li><!-- 2016-06-10 수정 -->
                <li><button type="button" class="btn-gray" onclick="clearForm();"><span>취소</span></button></li><!-- 2016-06-10 수정 -->
            </ul>
        </div>
    </div>
    </form>
</div>
<form method="post" id="frm">
</form>
<c:import url="/popup/emailSearch.do">
  <c:param name="popupId" value="_emailPopup" />
  <c:param name="callbackFunc" value="callbackSmsSelected" />
</c:import>
<script type="text/javascript">

    var isSelected = false;

    var userCategory = {
        '100858': {
            '100205': '초등학생 회원',
            '100206': '중학생 회원',
            '100207': '고등학생 회원',
            '100208': '대학생 회원',
            '100209': '일반 회원',
            '100210': '학부모 회원',
        },
        '100859': {
            '100214': '교사 회원',
            '100215': '진로상담교사 회원',
        },
    };

    var siteCategory = {
            'S': {
                '100858': '일반회원',
                '100859': '교사회원',
            },
            'M': {
                '101501': '기업멘토',
                '101502': '소속멘토',
                '101503': '개인멘토',
            },
        };

    function searchUser(){

        if($('#checkAllForMember').is(':checked'))
            $('#checkAllForMember').click();

        var userSearch = {};
        userSearch.name = $('#searchWord').val();
        console.log(userSearch.name);
        if($('#siteGubunSelector').val() == 'S'){
            if($('#mbrClassCdSelector').val() !== ''){
                userSearch.mbrClassCds = [$('#mbrClassCdSelector').val()];

                if($('#mbrClassCdSelector').val() == '100858'){
                    if($('#mbrCualfCdSelector').val() !== ''){
                        userSearch.mbrCualfCds = [$('#mbrCualfCdSelector').val()];
                    }else{
                        userSearch.mbrCualfCds = ['100205','100206','100207','100208','100209','100210'];
                    }
                }else if($('#mbrClassCdSelector').val() == '100859'){
                    if($('#mbrCualfCdSelector').val() !== ''){
                        userSearch.mbrCualfCds = [$('#mbrCualfCdSelector').val()];
                    }else{
                        userSearch.mbrCualfCds = ['100214','100215'];
                    }
                }
            }else{
                userSearch.mbrClassCds = ['100858','100859'];
            }

        }else if($('#siteGubunSelector').val() == 'M'){
            if($('#mbrClassCdSelector').val() !== ''){
                userSearch.mbrCualfCds = [$('#mbrClassCdSelector').val()];
            }else{
                userSearch.mbrCualfCds = ['101501','101502','101503'];
            }
        }

        $.ajax({
                url: '${pageContext.request.contextPath}/user/manager/ajax.searchUser.do',
                data : JSON.stringify(userSearch),
                contentType: "application/json",
                dataType: 'json',
                method:"post",
                cache: false,
                success: function(data) {
                    $('#totalCnt').html(data.length);
                     searchMemberData.getList(data);
                }.bind(this),
                error: function(xhr, status, err) {
                    //console.error( err.toString());
                }.bind(this)
            });
    }


    $(function () {

        $("#mailPopup").click(function(){
            $('body').addClass('dim');
            $(".popup-area").css("display","");
            $("input[name=keyword]").val("");
            var xmlData ="";
            var emptyText = "대상을 선택해주세요.";
            var colModels = [];
            colModels.push({label:'no', name:'rn',index:'rn', width:50, align:'center', sortable: false});
            colModels.push({label:'회원유형', name:'mbrCualfNm',index:'mbrCualfNm', width:90, align:'center', sortable: false, key: true});
            colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:90, align:'center', sortable: false});
            colModels.push({label:'소속', name:'posCoNm',index:'posCoNm', width:80, align:'center', sortable: false});
            colModels.push({label:'이름', name:'username',index:'username', width:80, align:'center', sortable: false});
            colModels.push({label:'이메일', name:'emailAddr',index:'emailAddr', width:110, align:'center', sortable: false});
            initJqGridTable('userList', 'popBoardArea', 1300, colModels,  true, 310);
            setDataJqGridTable('userList', 'popBoardArea', 1300, "", emptyText, 310);

        });


        $('#siteGubunSelector').change(
            function() {
                if(this.value == 'M'){
                    $('#mbrCualfCdSelector').hide();
                }else{
                    $('#mbrCualfCdSelector').show();
                }
                $('#mbrClassCdSelector').find('option:not(:first)').remove().end()
                    .append(function() {
                                if (this.value) {
                                    var options = [];
                                    $.each(siteCategory[this.value],
                                        function(k, v) {
                                            options.push($('<option value="' + k + '">' + v + '</option>'));
                                        }
                                    )
                                    return options;
                                }
                            }.bind(this));
                    }).filter(function() { return !!this.value; }).change();


        $('#mbrClassCdSelector').val($('#mbrClassCdSelector').attr('default'));


        $('#mbrClassCdSelector').change(function() {
                        $('#mbrCualfCdSelector').find('option:not(:first)').remove().end()
                            .append(function() {
                                if (this.value) {
                                    var options = [];
                                    $.each(userCategory[this.value], function(k, v) {
                                        options.push($('<option value="' + k + '">' + v + '</option>'));
                                    })
                                    return options;
                                }
                            }.bind(this));
                    }).filter(function() { return !!this.value; }).change();
        $('#mbrCualfCdSelector').val($('#mbrCualfCdSelector').attr('default'));

        }
    );



     function allToggleForMember(check){
         if(check){
             $('[name=selectedTarget]').each(function(index){
                 var thx = $(this);
                 if(this.checked)
                     thx.click();
             });
         }else{
             $('[name=selectedTarget]').each(function(index){
                 var thx = $(this);
                 if(!this.checked)
                     thx.click();
             });
         }
     }


    function clearForm(){
        if(confirm('작성 내용은 저장되지 않습니다. 취소하시겠습니까?') == true){
            $('#sender').val("");
            $('#sendTitle').val('');
            $('#sust').val('');
            $('#name').val('');
            $('#receiver').val('');
            isSelected = false;
        }
    }



    function sendEmail(){
        var regExp = /^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
        var message = {
            'messageRecievers':[],
            'messageSender':{},
            'simplePayLoad':{},
            'sendType': 2

        };

        if($('#name').val() == ''){
            alert('발신자 이름을 입력하세요.');
            $('#senderName').focus();

            return false;
        }

        if ( !regExp.test( $('#sender').val() ) ) {
              alert("잘못된 메일 유형입니다. 확인바랍니다.");
              $('#sender').focus();
              return false;
        }



        if($('#sendTitle').val() == ''){
            alert('제목을 입력하세요.');
            $('#sendTitle').focus();
            return false;
        }



        var receiverString = $.trim($('#receiver').val());
        var receiverString2 = $.trim($('#receiver2').val());
        if(receiverString == '' && receiverString2 == ''){
           alert('수신자 이메일을 세팅하거나 입력하세요.');
           return false;
        }
        if(receiverString != ''){
            var index = 0;
            var receivers = receiverString.split(',');
            receivers.map(function(item){

                    if ( !regExp.test( item ) ) {
                        alert("잘못된 메일 유형입니다. 확인바랍니다.");
                        $('#receiver').focus();
                        return false;
                    }
                    var messageReciever = new Object();
                    messageReciever.memberNo = $('input[name="selectedTarget"]')[index].value;
                    messageReciever.mailAddress = item;
                    message.messageRecievers.push(messageReciever);
                    index++;
                }
            );
        }

       if(receiverString2 != ''){
            var receivers2 = receiverString2.split(',');
            receivers2.map(function(item){
                    if ( !regExp.test( item ) ) {
                        alert("잘못된 메일 유형입니다. 확인바랍니다.");
                        $('#receiver').focus();
                        return false;
                    }
                    var messageReciever = new Object();
                    messageReciever.memberNo = "";
                    messageReciever.mailAddress = item;
                    message.messageRecievers.push(messageReciever);

            });
        }
        saveContent();
        message.messageSender.mailAddress = $('#sender').val();
        message.messageSender.senderName = $('#name').val();
        message.simplePayLoad.title = $('#sendTitle').val();
        message.simplePayLoad.content = $('#sust').val();



        $.ajax({
                url: "${pageContext.request.contextPath}/notify/email/ajax.sendMessage.do",
                data : JSON.stringify(message),
                contentType: "application/json",
                dataType : "json",
                cache: false,
                method:"post",
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('이메일 발송을 요청하였습니다.');
                        location.href = "list.do";
                    } else {
                        alert(rtnData.message);
                    }
                }
        });
    }


    function callbackSmsSelected(emailInfos){
        $("#closePopup").click();
        var selEmail =  $('#boardTable').jqGrid('getDataIDs');
        var inputs = "";
        var send = false;
        var mbrNos = new Array();
        $.each(emailInfos, function(idx){
            // 중복 제거
            var emails = emailInfos[idx].split("|");
            inputs+="<input type='hidden' name='" + "selectedTarget".format(idx) + "' value='"+ emails[0] +"' />";
            $('#receiver').val($('#receiver').val()+emails[1]+',');
            $('#frm').empty().append(inputs);

        });
    }

    $(document).ready(function(){
        // 팝업설정여부
        $('input[name=popYn]').change(function(){
            if($(this).val() == 'N'){
                $('#popWidth').val('');
                $('#popHigh').val('');
                $('#popWidth').attr('readonly', true);
                $('#popHigh').attr('readonly', true);
            }else{
                $('#popWidth').attr('readonly', false);
                $('#popHigh').attr('readonly', false);
            }
        });

        // 팝업 미사용시 팝업사이즈지정 readonly
        if($(':radio[name="popYn"]:checked').val() == 'N'){
            $('#popWidth').attr('readonly', true);
            $('#popHigh').attr('readonly', true);
        }
    });
</script>
