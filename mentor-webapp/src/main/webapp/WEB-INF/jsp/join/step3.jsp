<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<jsp:useBean id="now" class="java.util.Date" />

<script type="text/javascript">
var selectedJobInfo;
$().ready(function() {

    $('.radio-skin').each(function() {
        if($(this).hasClass('checked')) {
            $(this).children().prop('checked', true);
        }
    });

    $.ajax({
            url: '${pageContext.request.contextPath}/jobClsfCdByJobNo.do',
            data: { jobNo: '${jobInfo.jobNo}' },
            success: function(rtnData) {
                selectedJobInfo = rtnData;
            }
        });
    $.ajax({
        url: '${pageContext.request.contextPath}/code.do',
        data : {'supCd':'${code["CD100423_100533_이메일"]}'},
        success: function(rtnData) {
            $('#domain-choice1').loadSelectOptions(rtnData,'','cdNm','cdNm',1).change();
            $('#domain-choice2').loadSelectOptions(rtnData,'','cd','cdNm',0).change();
        }
    });

    $.ajax({
        url: '${pageContext.request.contextPath}/code.do',
        data : {'supCd':'${code["CD100211_100221_비밀번호_분실_시_확인질문"]}'},
        success: function(rtnData) {
            $('#question').loadSelectOptions(rtnData,'','cd','cdNm',0).change();
            if('${user.pwdQuestCd}' !== '')
                $('#question').val('${user.pwdQuestCd}');
        }
    });

    $.ajax({
        url: '${pageContext.request.contextPath}/code.do',
        data : { supCd: '${code["CD101512_101564_직업특성분류"]}' },
        success: function(rtnData) {
            $('#jobChrstcInfoSelector').loadSelectOptions(rtnData,'','cd','cdNm',0).change();
        }
    });

    $.ajax({
        url: '${pageContext.request.contextPath}/jobClsfCd.do',
        data: { cdLv: 1 },
        success: function(rtnData) {
            $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);

            if(selectedJobInfo !== undefined && selectedJobInfo.length > 0){
                $('#jobLv1Selector').val(selectedJobInfo[0].cd).change();
            }
        }
    });

    $('#idCheck2').keypress(function (e) {
        if (e.keyCode==13) {
            $('#checkIdDupl').click();
        }
    });

    $('#chkPwd').change(function (e) {
        if ($('input[name="password"]').val() != '') {
            if ($('#chkPwd').val() != $('input[name="password"]').val()) {
                $('#chkPwdDisp').show();
            }
            else {
                $('#chkPwdDisp').hide();
            }
        }
        else {
            $('#chkPwdDisp').hide();
        }
    });

    $('input[name="password"]').change(function (e) {
        if ($('#chkPwd').val() != '') {
            if ($('#chkPwd').val() != $('input[name="password"]').val()) {
                $('#chkPwdDisp').show();
            }
            else {
                $('#chkPwdDisp').hide();
            }
        }
        else {
            $('#chkPwdDisp').hide();
        }
    });

    $('select.email').change(function() {
        $(this).siblings('span.minor-form').find('input').val($(this).val());
        if ($(this).val() == '') {
            $(this).siblings('span.minor-form').show();
        }
        else {
            $(this).siblings('span.minor-form').hide();
        }
    });

    $('#checkIdDupl').click(function(e) {
        e.preventDefault();
        $.ajax({
            url: '${pageContext.request.contextPath}/join/ajax.checkIdDupl.do',
            data : {'id':$('#idCheck2').val()},
            contentType: 'application/json',
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                $("[id^='idDplTextArea-']").hide();
                if (rtnData.success === 'true') {
                    $("#idDplTextArea-3-1").text($("#idCheck2").val()).show();
                    $("#idDplTextArea-3").show();
                    $("#idDplTextArea-4").show();
                    //$('input[name="id"]').val($('#idCheck2').val());
                    //$('#layer1 .layer-close').click();
                }
                else {
                    if(rtnData.type == "id_validate"){
                        $("#idDplTextArea-1").show();
                        alert(rtnData.message);
                    }else{
                        $("#idDplTextArea-2-1").text($("#idCheck2").val()).show();
                        $("#idDplTextArea-2").show();
                    }
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    });


    $('#birthday,#birth-month,#birth-day').change(checkUnder14);

    // 직업분류 추가
    $.template('jobChrstcInfo', '<li><a href="#">\${jobNm}</a><input type="hidden" value="\${jobNo}" /></li>');
    $('#jobChrstcInfoAdder').click(function(e) {
        e.preventDefault();

        // 3개까지 선택 가능
        if ($('#jobChrstcInfoSelected li').length >= 3) {
            alert('특징분류는 3개까지 선택 가능 합니다.');
            return;
        }

        if ($('#jobChrstcInfoSelected :has(:hidden[value="' + $('#jobChrstcInfoSelector option:selected').val() + '"])').length) {
            alert('추가된 특징분류 입니다.');
            return;
        }

        $.tmpl('jobChrstcInfo', {
            jobNo: $('#jobChrstcInfoSelector option:selected').val(),
            jobNm: $('#jobChrstcInfoSelector option:selected').text()
        }).appendTo('#jobChrstcInfoSelected');
        indexingJobChrstcCd();
    });

    // 직업분류 삭제
    $('#jobChrstcInfoSelected').on('click', 'li > a', function(e) {
        e.preventDefault();
        $(this).closest('li').remove();
        indexingJobChrstcCd();
    });

    var indexingJobChrstcCd = function() {
        // 특정분류 이름 인덱싱
        $('#jobChrstcInfoSelected').find(':hidden').each(function(i, o) {
            $(o).attr('name', 'mbrJobChrstcInfos[{0}].jobChrstcCd'.format(i));
            //name="mbrJobChrstcInfos"
        });
    };


    // 1차 분류 변경
    $('#jobLv1Selector').change(function() {
        //if (!this.value) {
            $('#jobLv2Selector').find('option:not(:first)').remove()
                .end().val('').change();
        //    return;
        //}

        //console.log("value[1] :::> " + this.value);

        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                data: { cdLv: 2, supCd: this.value },
                success: function(rtnData) {
                    //console.log("value[2] :::> " + rtnData);
                    $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);

                    if(selectedJobInfo !== undefined && selectedJobInfo[1]){
                        $('#jobLv2Selector').val(selectedJobInfo[1].cd).change();
                    }
                }
            });
        }
    });

    // 2차 분류 변경
    $('#jobLv2Selector').change(function() {
        //if (!this.value) {
            $('#jobLv3Selector').find('option:not(:first)').remove()
                .end().val('').change();
        //    return;
        //}
        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                data: { cdLv: 3, supCd: this.value },
                success: function(rtnData) {
                    $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    if(selectedJobInfo !== undefined && selectedJobInfo[2]){
                        $('#jobLv3Selector').val(selectedJobInfo[2].cd).change();
                    }
                }
            });
        }
    });

    // 3차 분류 변경
    $('#jobLv3Selector').change(function() {
        //if (!this.value) {
            $('#jobInfoSelector').find('option:not(:first)').remove()
                .end().val('').change();
        //    return;
        //}
        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/jobInfo.do', {
                data: { jobClsfCd: this.value },
                success: function(rtnData) {
                    $('#jobInfoSelector').loadSelectOptions(rtnData,'','jobNo','jobNm',1);
                    if(selectedJobInfo !== undefined){
                        $('#mbrJobInfo-jobNm').attr('type', 'hidden');
                        $('#jobInfoSelector').val('${jobInfo.jobNo}');
                    }
                }
            });
        }
    });

    $('#jobInfoSelector').change(function() {
        $('#mbrJobInfo-jobNm').attr('type', 'hidden');
        $('#mbrJobInfo-jobNm').val($(this).find(':selected').text());
    });

    $('#mbrProfInfo-intdcInfo').bind('keyup', function(e) {

        var textLength = $.trim(this.value).length;
        var normalChar = "";
        var byteCnt = 0;
        for (i = 0; i < textLength; i++) {
            var charTemp = this.value.charAt(i);
            if (escape(charTemp).length > 4) {
                byteCnt += 2;
            } else {
                byteCnt += 1;
            }

            if(byteCnt <= 400) {
                normalChar += charTemp;
            }
        }
        if( byteCnt > 400){
            alert("입력 가능한 최대 글자수는 한글 200자, 영문 400자입니다.");
            this.value = normalChar;
            byteCnt = 0;
            var textLength = $.trim(this.value).length;
            for (i = 0; i < textLength; i++) {
                var charTemp = this.value.charAt(i);
                if (escape(charTemp).length > 4) {
                    byteCnt += 2;
                } else {
                    byteCnt += 1;
                }

                if(byteCnt <= 400) {
                    normalChar += charTemp;
                }
            }
            $('.txt-area-form .length').text(byteCnt);
        }
        $('.txt-area-form .length').text(byteCnt);

        /*
        if (this.value.length > 200) {
            this.value = this.value.substring(0, 200);
            alert('200글자 이상 입력할수 없습니다.');
        }
        $('.txt-area-form .length').text(this.value.length);
        */
        return false;
    });



    // 직업등록 레이어
    $('#openSaveJobLayer').bindFirst('click', function(e) {

        if (!$('#jobLv3Selector').val() || !$('#jobLv2Selector').val() || !$('#jobLv1Selector').val()) {
            e.stopImmediatePropagation();
            alert('3차분류 직업 선택후 직업 등록 가능.')
            return false;
        }
        $('#mbrJobInfo-jobNm').attr('type', 'text');
        $('#mbrJobInfo-jobNm').val('');
        $('#jobInfoSelector').val('');
        return false;

        /*
        initInsertJobLayer(
                $('#jobLv3Selector').val(),
                $('#jobLv3Selector option:selected').text(),
                $('#jobLv2Selector option:selected').text(),
                $('#jobLv1Selector option:selected').text());

        return false;
        */
    });



    $('#joinForm').submit(function() {

        if (!!!(this.id.value)) {
            alert('아이디 중복확인 하세요.');
            return false;
        }

        if (!!!(this.password.value)) {
            alert('비밀번호를 입력하세요.');
            return false;
        }

        if (this.password.value !== $('#chkPwd').val()) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }

        var SamePass_0 = 0; //ID와 3자이상 중복체크

        var chr_pass_0;
        var chr_pass_1;
        var chr_pass_2;

        var chr_id_0;
        var chr_id_1;
        var chr_id_2;

        for(var i=0; i < (this.password.value.length-2); i++) {

            chr_pass_0 = this.password.value.charAt(i);
            chr_pass_1 = this.password.value.charAt(i+1);
            chr_pass_2 = this.password.value.charAt(i+2);

            for(var j=0; j < ($("#id").val().length-2); j++) {
                chr_id_0 = $("#id").val().charAt(j);
                chr_id_1 = $("#id").val().charAt(j+1);
                chr_id_2 = $("#id").val().charAt(j+2);
                if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                    SamePass_0=1;
                }
            }
        }
        if(this.password.value.search(/\s/) != -1){
            alert("비밀번호는 공백없이 입력해주세요.");
            return false;
        }

        if(SamePass_0 >0){
            alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
            return false;
        }

        if(/([\w\W\d])\1\1/.test(this.password.value)) {
            alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
            return false;
        }

        var regex = /^((?=.*[a-zA-Z])|(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:'",.<>\/?]))((?=.*\d)|(?=.*[!@#$%^*()\-_=+\\\|\[\]{};:'",.<>\/?])).{10,20}$/;
        if(!regex.test(this.password.value) || (!/\d/.test(this.password.value)&&!/[a-zA-Z]/.test(this.password.value))){
            alert("비밀번호는 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.");
            return false;
        }

        /*
        if (!/^.{10,20}$/ig.test(this.password.value)) {
            alert('비밀번호가 형식에 맞지 않습니다.\n영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.');
            return false;
        }
        */

        if (!!!(this.pwdAnsSust.value)) {
            alert('비밀번호 찾기 답변을 입력하세요.');
            return false;
        }

        if (!!!(this.username.value)) {
            alert('이름을 입력하세요.');
            return false;
        }

        if (!!!$('#email-adrs1').val()) {
            alert('이메일 주소를 입력하세요.');
            return false;

        }

        if (!!!$('#email-entry1').val()) {
            alert('이메일 주소를 입력하세요.');
            return false;
        }

        var pattern = /[\u3131-\u314e|\u314f-\u3163|\uac00-\ud7a3]/g;
        if(pattern.test($('#email-adrs1').val()) || pattern.test($('#email-entry1').val())) {
            alert("메일주소는 영문으로만 입력하세요.");
            return false;
        }

        if (!!!$('#number-middle').val()) {
            alert('연락처를 입력하세요.');
            return false;

        }

        if (!!!$('#number-middle').val()) {
            alert('연락처를 입력하세요.');
            return false;

        }

        if (!!!$('#number-last').val()) {
            alert('연락처를 입력하세요.');
            return false;
        }

        var anum = /(^\d+$)|(^\d+\.\d+$)/
        if (!anum.test($('#number-middle').val()) || !anum.test($('#number-last').val())) {
            alert('연락처는 숫자로만 입력하세요.');
            return false;

        }

        var jobChrstcInfoSelectedCnt = 0;
        $('#jobChrstcInfoSelected').find('li').each(function() {
            jobChrstcInfoSelectedCnt++;
        });
        if(jobChrstcInfoSelectedCnt == 0) {
            alert('직업 특징분류를 추가하세요.');
            return false;
        }

        if (!!!$('#mbrJobInfo-jobNm').val()) {
            alert('직업을 선택하세요.');
            return false;
        }

        var duplJobNm = false;
        if($('#mbrJobInfo-jobNm').attr('type') == 'text') {
            $('#jobInfoSelector').find('option').each(function() {
                if($(this).text() == $.trim($('#mbrJobInfo-jobNm').val())) {
                    duplJobNm = true;
                }
            });
        }
        if(duplJobNm) {
            alert('이미 등록된 직업명이 있습니다.');
            return false;
        }

        if (!!!$('#mbrProfInfo-intdcInfo').val()) {
            alert('멘토약력 및 자기소개를 입력하세요.');
            return false;
        }

        $('input[name="mobile"]').val($('#dialing-code').val()+'-'+$('#number-middle').val()+'-'+$('#number-last').val());
        $('input[name="emailAddr"]').val($('#email-adrs1').val()+'@'+$('#email-entry1').val());
        //$('input[name='prtctrEmailAddr']').val($('#email-adrs2').val()+'@'+$('#domain-choice2').val());
        $('input[name="birthday"]').val(getBirthday());

        //return false;
    });
    //checkUnder14();

    $("#idDplTextArea-4").click(function(){
        $("input[name='id']").val($("#idDplTextArea-3-1").text());
        $("#layer1 .layer-close").click();
    });
});

mentor.curDate = mentor.parseDate('<fmt:formatDate value='${now}' pattern='yyyyMMdd'/>');
mentor.under14Date = mentor.calDate(mentor.curDate,-14,0,0);
function checkUnder14() {
    var selDate = mentor.parseDate(getBirthday());
    if (mentor.under14Date < selDate) {
        $('#parentsEmail').show();
        return true;
    }
    else {
        $('#parentsEmail').hide();
        return false;
    }

}

function getBirthday() {
    return $('#birthday').val().zf(4)+$('#birth-month').val().zf(2)+$('#birth-day').val().zf(2);
}

function insertJobConfirm() {
    $.template("prevRegistedJobNm","<li style='margin-bottom: 0px;padding-bottom: 0px;'><div><span style='font-size: 12px;margin-right:15px;'>[기등록]</span><span style='font-size: 12px;margin-right:15px;'>\${jobClsfNmLv1}</span><span style='font-size: 12px;margin-right:15px;'>\${jobClsfNmLv2}</span><span style='font-size: 12px;margin-right:15px;'>\${jobClsfNm}</span><em style='margin-top: 0px;font-size: 12px;font-weight:bold;'>\${jobNm}</em></div></li>");

    $('.board-input-type .job-choice').find('li:gt(2)').remove();
    if(this != null && this != window){
        $(this).each(
            function(index,value){
               $.tmpl('prevRegistedJobNm', {
                           jobNm: value.jobNm,
                           jobClsfNmLv1: value.jobClsfNmLv1,
                           jobClsfNmLv2:value.jobClsfNmLv2,
                           jobClsfNm: value.jobClsfNm
                       }).appendTo('.board-input-type .job-choice');
            }
        );
    }
    $('#jobLv3Selector').change();
}

function idClick(){
    $("#btnIdDuplChk").click();
}
</script>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>회원가입</span>
    </div>
    <div class="content">
        <h2 class="tab-tit">회원가입</h2>
        <div class="tab-area">
            <img src="${pageContext.request.contextPath}/images/member/img_join_step3.gif" alt="가입정보 입력" />
        </div>
        <div class="cont">
            <form:form action="step4.do" modelAttribute="user" id="joinForm">
                <form:hidden path="mbrNo"/>
                <c:if test="${empty errorCode}">
                    <div id="errors" style="display:none">
                            <spring:bind path="*">
                                <c:forEach items="${status.errorMessages}" var="error"><span class="error">${error}</span></c:forEach>
                            </spring:bind>
                        <%-- <form:errors path="*" cssClass="error" delimiter="" /> --%>
                    </div>
                    <script type="text/javascript">$("#errors:has(span.error)").each(function() {
                        alert($(this).find('span.error:first').text());
                    });</script>
                </c:if>

                <div class="join-info-write">
                    <p class="desc-txt">회원님의 소중한 개인정보를 동의 없이 공개 또는 제공하지 않습니다. </p>
                    <div class="board-title active">
                        <h3 class="board-tit">필수 입력항목</h3>
                        <div>
                            <span>모든 항목은 필수 입력사항 입니다.</span>
                            <a href="#">입력폼 접기, 펼치기</a>
                        </div>
                    </div>
                    <div class="board-input-type">
						<div class="selectbox-zindex-wrap">
							<div class="selectbox-zindex-box">
								<div class="m-height540"></div>
								<iframe scrolling="no" class="m-height540" frameborder="0"></iframe>
							</div>
						</div>
                        <table>
                            <caption>가입정보 입력 - 아이디, 비밀번호, 비밀번호 확인, 비밀번호찾기 질문, 이름, 생년월일, 이메일 주소, 이메일수신</caption>
                            <colgroup>
                                <col style="width:157px;" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">아이디</th>
                                    <td>
                                        <form:input cssClass="inp-style1" style="width:150px;" title="아이디 입력" path="id" readonly="readonly"  onClick="idClick()" /> <a href="#layer1" class="btn-type1 layer-open" id="btnIdDuplChk">아이디 중복확인</a>
                                        <span class="refer">* 5자리 ~ 12자리 영문, 숫자 및 기호 '_', '-' 만 가능합니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">비밀번호</th>
                                    <td>
                                        <input type="password" class="inp-style1" style="width:150px;" name="password" value="" />
                                        <span class="refer">* 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">비밀번호 확인</th>
                                    <td>
                                        <input type="password" class="inp-style1" style="width:150px;" id="chkPwd" value="" />
                                        <span class="layer" style="display:none" id="chkPwdDisp">비밀번호가 일치하지 않습니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">비밀번호찾기 질문</th>
                                    <td>
                                        <form:select path="pwdQuestCd" id="question" title="비밀번호 찾기 질문 선택" cssStyle="width:270px;" />
                                        <form:input cssClass="inp-style2" cssStyle="width:390px;" title="질문에 대한 답변 입력" path="pwdAnsSust" />
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">이름</th>
                                    <td>
                                        <form:input cssClass="inp-style1" cssStyle="width:150px;" title="이름 입력" path="username" />
                                        <span class="mgl-15">
                                            <label class="radio-skin ${(user.genCd eq '100323' || user.genCd eq null)?'checked':''}"><form:radiobutton path="genCd" cssClass="radio-skin" value="100323"/>남자</label>
                                            <label class="radio-skin ${(user.genCd eq '100324')?'checked':''}"><form:radiobutton path="genCd" cssClass="radio-skin" value="100324"/>여자</label>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">생년월일</th>
                                    <td><fmt:formatDate value="${now}" var="year" pattern="yyyy"/><input type="hidden" name="birthday" value=""/>
                                        <select id="birthday" title="생년월일 연도" style="width:80px;">
                                            <c:forEach begin="${1}" end="${70}" var="item">
                                                <option value="${year-item}" ${(fn:substring(user.birthday,0,4) eq (year-item))?'selected':''}>${year-item}</option>
                                            </c:forEach>
                                        </select>
                                        <select title="생년월일 월" id="birth-month" style="width:70px;">
                                            <c:forEach begin="${1}" end="${12}" var="item">
                                                <option value="${item}" ${(fn:substring(user.birthday,4,6) == (item))?'selected':''}>${item}</option>
                                            </c:forEach>
                                        </select>
                                        <select id="birth-day" title="생년월일 일" style="width:70px;">
                                            <c:forEach begin="${1}" end="${31}" var="item">
                                                <option value="${item}" ${(fn:substring(user.birthday,6,8) == (item))?'selected':''}>${item}</option>
                                            </c:forEach>
                                        </select>
                                        <span class="mgl-15">
                                            <label class="radio-skin ${(user.lunarYn eq 'N' || user.lunarYn eq null)?'checked':''}"><form:radiobutton path="lunarYn" cssClass="radio-skin" value="N"/>양력</label>
                                            <label class="radio-skin ${(user.lunarYn eq 'Y')?'checked':''}"><form:radiobutton path="lunarYn" cssClass="radio-skin" value="Y"/>음력</label>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">이메일 주소</th>
                                    <td><form:hidden path="emailAddr" />
                                        <input type="text" id="email-adrs1" title="이메일주소 입력" class="inp-style1" style="width:180px;" value="${fn:substring(user.emailAddr,0,fn:indexOf(user.emailAddr,'@'))}" />
                                        @
                                        <select title="도메인 선택" id="domain-choice1" class="email">
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
                                        <c:set var="emailIdx" value="${fn:length(user.agrees)}" />
                                        <c:forEach var="item" items="${user.agrees}" varStatus="status">
                                          <c:if test="${item.agrClassCd eq '100944'}">
                                            <c:set var="contains" value="true" />
                                            <c:set var="emailIdx" value="${status.count}" />
                                          </c:if>
                                        </c:forEach>

                                        <label class="radio-skin ${(contains || contains eq null)? 'checked':'' }"><input type="radio" name="agrees[${emailIdx}].agrClassCd" class="radio-skin" ${(contains || contains eq null)? 'checked':'' } value="100944"/>예</label>
                                        <label class="radio-skin ${(contains eq null)? '':'checked' }"><input type="radio" name="agrees[${emailIdx}].agrClassCd" class="radio-skin" value=""/>아니오</label>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="board-title active">
                        <h3 class="board-tit">멘토 상세정보 입력</h3>
                        <div>
                            <span>*모든 항목을 입력하셔야 관리자 검토 후 승인이 됩니다.</span>
                            <a href="#" >입력폼 접기, 펼치기</a>
                        </div>
                    </div>
                    <div class="board-input-type">
                        <table>
                            <caption>추가정보 항목 - 연락처, 직업선택, 멘토약력 및 자기소개</caption>
                            <colgroup>
                                <col style="width:157px;" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td colspan="2" class="txt-area">
                                        <span class="refer">* 멘토회원 서비스를 이용하시려면 반드시 ‘추가정보‘를 입력해야 합니다.</span>
                                        <span class="refer">* 추가정보 항목은 관리자가 승인여부를 판단할 근거 자료로 활용됩니다.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">연락처</th>
                                    <td>
                                        <form:hidden path="mobile" />
                                        <c:set var="tel" value="${fn:split(user.mobile,'-')}" />
                                        <select id="dialing-code" title="번호앞자리 선택" style="width:80px;">
                                            <option value="010">010</option>
                                            <option value="011">011</option>
                                            <option value="016">016</option>
                                            <option value="017">017</option>
                                            <option value="018">018</option>
                                            <option value="019">019</option>
                                        </select> -
                                        <input type="text" class="inp-style1" id="number-middle" style="width:65px;" value="${tel[1]}" maxlength="4"/> -
                                        <input type="text" class="inp-style1" id="number-last" style="width:65px;" value="${tel[2]}" maxlength="4"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">직업선택</th>
                                    <td>
                                        <ul class="job-choice">
                                            <li>
                                                <em>- 특징분류</em>
                                                <div class="form">
                                                    <select name="" style="width:173px;" id="jobChrstcInfoSelector">
                                                        <option value="">특징분류</option>
                                                    </select>
                                                    <a href="#" class="btn-type1" id="jobChrstcInfoAdder">추가</a>
                                                    <ul id="jobChrstcInfoSelected">
                                                        <c:forEach var="item" items="${jobChrstcInfos}">
                                                        <li><a href="#">${item.jobChrstcCdNm}</a><input type="hidden" value="${item.jobChrstcCd}" /></li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </li>
                                            <li>
                                                <em>- 직업분류</em>
                                                <div class="form">
                                                    <select name="" style="width:173px;" id="jobLv1Selector">
                                                        <option value="">1차분류</option>
                                                    </select>
                                                    <select name="" style="width:173px;" id="jobLv2Selector">
                                                        <option value="">2차분류</option>
                                                    </select>
                                                    <select name="mbrJobInfo.jobClsfCd" style="width:173px;" id="jobLv3Selector">
                                                        <option value="">3차분류</option>
                                                    </select>
                                                </div>
                                            </li>
                                            <li>
                                                <em>- 직업명</em>
                                                <div class="form">
                                                    <input type="hidden" id="mbrJobInfo-jobNo" value="${jobInfo.jobNo}" />
                                                    <select name="mbrJobInfo.jobNo" style="width:150px;" id="jobInfoSelector">
                                                        <option value="">4차분류</option>
                                                    </select>
                                                    <a href="javascript:void(0)" class="btn-type1" id="openSaveJobLayer">직접입력</a>
                                                    <input type="hidden" name="mbrJobInfo.jobNm" id="mbrJobInfo-jobNm" placeholder="직업명을 입력하세요." />
                                                </div>
                                            </li>
                                            <li>
                                                <div class="form">
                                                    <span class="job-name">※ 등록 된 직업명이 없을 경우 ‘직접입력‘ 버튼을 클릭해 직업명을 추가해주세요. </span>
                                                </div>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">멘토약력 및<br/>자기소개</th>
                                    <td>
                                        <div class="txt-area-form">
                                            <textarea name="mbrProfInfo.intdcInfo" rows="" class="textarea" cols="" id="mbrProfInfo-intdcInfo" >${profInfo.intdcInfo}</textarea>
                                            <span><em class="length">0</em>/400byte</span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <p class="desc-txt type1">입력 완료 후 [승인요청] 버튼을 클릭하시면, 관리자 승인 후 멘토 회원 가입이 완료됩니다.</p>
                    <div class="btn-area">
                        <button class="btn-type2" type="submit">승인요청</button>
                        <a href="${pageContext.request.contextPath}/index.do" class="btn-type2 gray">취소</a>
                    </div>
                </div>
            </form:form></div>

        <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
    </div>
</div>

<!-- 아이디 중복 검사 레이어 -->
<div class="layer-pop-wrap w480" id="layer1">
    <div class="title">
        <strong>아이디 중복확인</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont board">
        <div class="box-style none-border" id="idDplTextArea">
            <strong id="idDplTextArea-1" class="title-style">아이디를 입력하세요.</strong>
            <strong id="idDplTextArea-2" style="display:none;" class="title-style id-check"><em id="idDplTextArea-2-1"></em><em class="gray">는 현재 사용 중인 아이디입니다.</em><br />다른 아이디를 사용해주세요.</strong>
            <strong id="idDplTextArea-3" style="display:none;" class="title-style id-check"><em id="idDplTextArea-3-1"></em><em class="gray">는 사용 가능합니다. </em></strong>
            <a href="#" id="idDplTextArea-4" style="display:none;" class="btn-type1">아이디 사용하기</a>
            <div class="id-overlap">
                <input type="text" class="inp-style1" style="width:249px;" id="idCheck2" name="id" placeholder="아이디를 입력해주세요." title="아이디" maxlength="12"/>
                <a href="#"  class="btn-type1 search" id="checkIdDupl">아이디 중복확인</a>
            </div>
            <p class="id-overlap-txt">* 5자리 ~ 12자리 영문, 숫자 및 기호 '_', '-' 만 가능합니다.</p>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type2 pop-close layer-close">확인</a>
        </div>
    </div>
</div>


<%--직업등록 레이어
<jsp:include page="/WEB-INF/jsp/layer/layerPopupInsertJob.jsp">
    <jsp:param value="insertJobConfirm" name="callback"/>
</jsp:include>
--%>
<script type="text/javascript">
var settingJobInfo =
function(){
    if ($('#mbrJobInfo-jobNo').val()) {
        $.ajax('${pageContext.request.contextPath}/jobClsfCdByJobNo.do',
            {
                data: { jobNo: $('#mbrJobInfo-jobNo').val() },
                success: function(rtnData) {
                    //console.log(rtnData);
                    if (!rtnData|| !rtnData.length) {
                        return;
                    }
                    $('#jobLv1Selector').val(rtnData[0].cd);
                    $('#jobLv1Selector').change();
                    $('#jobLv2Selector').val(rtnData[1].cd);
                    $('#jobLv3Selector').val(rtnData[2].cd);
                    $('#jobInfoSelector').val($('#mbrJobInfo-jobNo').val());
                    //$('#jobLv1Selector').val(rtnData[0].cd).change();
                    //$('#jobLv2Selector').val(rtnData[1].cd).change();
                    //$('#jobLv3Selector').val(rtnData[2].cd).change();
                    //$('#jobInfoSelector').val($('#mbrJobInfo-jobNo').val()).change();
                },
                async: false,
                cache: false,
                type: 'post',
            }
        );
    }
};
</script>