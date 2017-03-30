<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <form:form action="saveSchoolInfo.do" method="post" commandName="schInfo" id="frm">
        <form:input path="schNo" type="hidden"/>
        <form:input path="contTel" type="hidden"/>
        <form:input path="tel" type="hidden"/>
        <form:input path="mbrNo" type="hidden"/>
        <form:input path="emailAddr" type="hidden"/>
        <div class="title-bar">
            <h2>학교정보관리</h2>
            <ul class="location">
                <li class="home">Home</li>
                <li>학교관리</li>
                <li>학교정보관리</li>
            </ul>
        </div>
        <div class="board-area" id="boardArea">
            <table class="tbl-style tbl-mento-modify">
                <colgroup>
                    <col style="width:147px;" />
                    <col style="width:100px;" />
                    <col />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="col">학교급 <span class="red-point">*</span></th>
                        <td colspan="2">
                            <label>
                                <form:radiobuttons path="schClassCd" items="${code100494}" itemLabel="cdNm" itemValue="cd" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">아이디 <span class="red-point">*</span></th>
                        <td colspan="2">
                            <c:if test="${schInfo.userId == null}">
                                <form:input path="userId" className="text" value="" maxlength="20" />
                                <button type="button" class="btn-style01" id="checkIdDupl"><span>중복확인</span></button>
                            </c:if>
                            <c:if test="${schInfo.userId != null}">
                            <form:input path="userId" type="hidden"/>
                                ${schInfo.userId}
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">비밀번호 <c:if test="${schInfo.schNo eq null}"><span class="red-point">*</span></c:if></th>
                        <td colspan="2">
                            <input type="password" name="password" id="password" maxlength="20" class="text" value="" />
                            <span class="ml5">10자 이상의 영문, 숫자, 특수기호 조합</span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">비밀번호 확인 <c:if test="${schInfo.schNo eq null}"><span class="red-point">*</span></c:if></th>
                        <td colspan="2">
                            <input type="password" class="text" id="chkPwd" maxlength="20" value=""/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">학교명 <span class="red-point">*</span></th>
                        <td colspan="2">
                            <form:input path="schNm" maxlength="20" className="text" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">연락처</th>
                        <td colspan="2" class="mobile">
                            <spring:eval expression="{'02', '031', '032', '033', '041', '042', '043', '044', '051', '052', '053', '054', '055', '061', '062', '063', '064', '010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                            <select style="width:100px;" id="contTel1">
                                <option value="">선택</option>
                                <c:forEach items="${dialingCode}" var="eachObj">
                                    <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(schInfo.contTel, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                                </c:forEach>
                            </select>
                            <span>-</span>
                            <input type="text" class="text" id="contTel2" maxlength="4" onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style="IME-MODE:disabled;" value="${cnet:splitWithIndex(schInfo.contTel, '-', 1)}" />
                            <span>-</span>
                            <input type="text" class="text" id="contTel3" maxlength="4" onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style="IME-MODE:disabled;" value="${cnet:splitWithIndex(schInfo.contTel, '-', 1)}" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">담당자<span class="red-point">*</span></th>
                        <td colspan="2">
                             <form:input path="username" maxlength="20" className="text" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">담당 휴대전화</th>
                        <td colspan="2" class="mobile">
                            <spring:eval expression="{'010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                            <select style="width:100px;" id="tel1">
                                <option value="">선택</option>
                                <c:forEach items="${dialingCode}" var="eachObj">
                                    <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(schInfo.tel, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                                </c:forEach>
                            </select>
                            <span>-</span>
                            <input type="text" class="text" id="tel2" onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style="IME-MODE:disabled;" value="${cnet:splitWithIndex(schInfo.tel, '-', 1)}" maxlength="4"/>
                            <span>-</span>
                            <input type="text" class="text" id="tel3" onKeypress="if(event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;" style="IME-MODE:disabled;" value="${cnet:splitWithIndex(schInfo.tel, '-', 2)}" maxlength="4" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">담당 이메일</th>
                        <td colspan="2">
                            <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100423_100533_이메일'])" var="emailCodes" />
                            <input type="text" class="text" id="emailAddr1" value="${cnet:splitWithIndex(schInfo.emailAddr, '@', 0)}" axlength="30" />
                            <span>@</span>
                            <select id="email-entry">
                                <option value="">직접입력</option>
                                <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                    <option value="${eachObj.cdNm}" <c:if test="${cnet:splitWithIndex(schInfo.emailAddr, '@', 1) eq eachObj.cdNm}">selected="selected"</c:if>>${eachObj.cdNm}</option>
                                </c:forEach>
                            </select>
                            <input type="text" class="text" id="emailAddr2" value="${cnet:splitWithIndex(schInfo.emailAddr, '@', 1)}" maxlength="10" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">홈페이지</th>
                        <td colspan="2"><form:input path="siteUrl" maxlength="30" class="text" /></td>
                    </tr>
                    <tr>
                        <th scope="col">보유장비 <span class="red-point">*</span></th>
                        <td colspan="2">
                            <label class="pr5">
                                <input type="checkbox" name="deviceTypeHold" value="101683"
                                <c:if test="${fn:indexOf(schInfo.deviceTypeHold, '101683') > -1}">checked="checked"</c:if> /> 욱성
                            </label>
                            <label class="pr5">
                                <input type="checkbox" name="deviceTypeHold" value="101684"
                                <c:if test="${fn:indexOf(schInfo.deviceTypeHold,'101684') > -1}">checked="checked"</c:if> /> 웹캠
                            </label>
                            <span class="pr5"> / </span>
                            <strong class="pr5">사용장비</strong>
                            <label class="pr5">
                                <form:radiobutton path="deviceType" value="101683" label="욱성"/>
                            </label>
                            <label class="pr5">
                                <form:radiobutton path="deviceType" value="101684" label="웹캠"/>
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">참여구분 <span class="red-point">*</span></th>
                        <td colspan="2">
                            <form:select path="joinClass" >
                            <form:options items="${code101685}" itemLabel="cdNm" itemValue="cd"/>
                            </form:select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" rowspan="2">주소 <span class="red-point">*</span></th>
                        <th>기본주소</th>
                        <td class="address02">
                            <form:input path="locaAddr" />
                            <form:hidden path="postCd" />
                            <form:hidden path="sidoNm" />
                            <form:hidden path="sgguNm" />
                            <form:hidden path="umdngNm" />
                            <button type="button" id="addressPopup" class="btn-style01"><span>주소검색</span></button>
                        </td>
                    </tr>
                    <tr>
                        <th>상세주소</th>
                        <td class="address02"><form:input path="locaDetailAddr" class="text" /></td>
                    </tr>
                    <tr>
                        <th>분류유형</th>
                        <td class="select-category" colspan="2">
                            <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100033_101731_학교직업분류코드'])" var="jobChrstcCodes" />
                               <select id="jobChrstcInfoSelector" style="width:150px;">
                                   <option value="">선택</option>
                                   <c:forEach items="${jobChrstcCodes}" var="eachObj">
                                       <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                                   </c:forEach>
                               </select>
                            <button type="button" class="btn-style01" id="jobChrstcInfoAdder"><span>추가</span></button>
                            <span class="ml5">* 최대 5개까지 추가가 가능합니다. 분류 선택 후 추가 버튼을 클릭하세요.</span>
                            <ul class="category-list" id="jobChrstcInfoSelected">
                                <c:forEach items="${schInfo.schJobGroup}" var="eachObj" varStatus="vs">
                                    <li><a href="#">${eachObj.schChrstcNm}</a><form:hidden path="schJobGroup[${vs.index}].schChrstcCd" /><button onclick="return false" class="item-delete"> <img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="삭제"></button></li>
                                </c:forEach>
                            </ul>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">사용유무 <span class="red-point">*</span></th>
                        <td colspan="2">
                            <label class="pr5">
                                <form:radiobutton path="useYn" value="Y" label="사용중"/>
                            </label>
                            <label class="pr5">
                                <form:radiobutton path="useYn" value="N" label="사용안함"/>
                            </label>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="board-bot">
                <ul>
                    <li><button type="button" class="btn-orange" onclick="on_submit();"><span>저장</span></button></li>
                    <c:choose>
                    <c:when test="${schInfo.schNo ne null}">
                    <li><button type="button" class="btn-gray" onclick="location.href='view.do?schNo=${schInfo.schNo}'"><span>취소</span></button></li>
                    </c:when>
                    <c:otherwise>
                    <li><button type="button" class="btn-gray" onclick="location.href='list.do'"><span>취소</span></button></li>
                    </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </form:form>
</div>
<c:import url="/popup/addressSearch.do">
  <c:param name="popupId" value="_addressPopup" />
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
<script type="text/javascript">

var schClassCd = '${schInfo.schClassCd}';
if(schClassCd == ''){
    $('input:radio[name=schClassCd]:eq(0)').attr("checked","checked");
}
var idChk = "N";
$(document).ready(function(){
    var emptyFilter = function() {
        return !this.value;
    };
    var notEmptyFilter = function() {
        return !!this.value;
    };
    $("#addressPopup").click(function(){
        $('body').addClass('dim');
        $(".popup-area").css("display","");

        $("input[name=keyword]").val("");
        var xmlData ="";
        dataSet.params.totalRecordCount = 0;
        mentor.addrPageNavi.setData(dataSet.params);
        var emptyText = '검색어가 입력되지 않았습니다.';
        setDataJqGridTable('lectureList', 'popBoardArea', 1300, xmlData, emptyText, 310);
        getAddr(1);
    });

    <c:if test="${schInfo.contTel ne null}">
        var contTel = '${schInfo.contTel}';
        var contTels = contTel.split("-");
        if(contTels.length > 1){
            $("#contTel1").val(contTels[0]);
            $("#contTel2").val(contTels[1]);
            $("#contTel3").val(contTels[2]);
        }else{
            if(contTels[0].length == 11){
                $("#contTel1").val(contTels[0].substring(0,3));
                $("#contTel2").val(contTels[0].substring(3,7));
                $("#contTel3").val(contTels[0].substring(7,11));
            }
            if(contTels[0].length == 10){
                $("#contTel1").val(contTels[0].substring(0,3));
                $("#contTel2").val(contTels[0].substring(3,6));
                $("#contTel3").val(contTels[0].substring(6,10));
            }
        }
    </c:if>
    <c:if test="${schInfo.tel ne null}">
        var tel = '${schInfo.tel}';
        var tels = tel.split("-");
        if(tels.length > 1){
            $("#tel1").val(tels[0]);
            $("#tel2").val(tels[1]);
            $("#tel3").val(tels[2]);
        }else{
            if(tels[0].length == 11){
                $("#tel1").val(tels[0].substring(0,3));
                $("#tel2").val(tels[0].substring(3,7));
                $("#tel3").val(tels[0].substring(7,11));
            }
            if(tels[0].length == 10){

                $("#tel1").val(tels[0].substring(0,3));
                $("#tel2").val(tels[0].substring(3,6));
                $("#tel3").val(tels[0].substring(6,10));
            }
        }
    </c:if>
    <c:if test="${!empty param.setTargtNo}">
        $.ajax({
            url: "${pageContext.request.contextPath}/school/info/ajax.listAssignGroup.do",
            data : {'setTargtNo':'${param.setTargtNo}','schMbrCualfCd':'101699'},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                if(rtnData != null && rtnData.length > 0){
                    $("#grpNm").text(rtnData[0].bizGrpInfo.grpNm);
                    $("#clasCnt").text(rtnData[0].lectApplCnt.clasApplCnt);
                    $("#clasApplCnt").text(rtnData[0].clasCnt);
                    $("#clasDay").text("{0} ~ {1}".format(mentor.parseDate(rtnData[0].clasStartDay).format('yyyy.MM.dd'),mentor.parseDate(rtnData[0].clasEndDay).format('yyyy.MM.dd')));
                }else{
                    location.href = "assignGroup.do";
                }
            }
        });
    </c:if>

    $('#email-entry').change(function() {
        $('#emailAddr2:last').val(this.value).toggle(!this.value);
    }).filter(notEmptyFilter).change();

     // 학교관리 직업정보 처리 =======================================++++++++++++++++++++++++++++==================
    // 직업분류 추가
    $.template('jobChrstcInfo', '<li> <a href="#"><span class="underline">\${jobNm}</span></a><input type="hidden" name="job" value="\${jobNo}" /><button onclick="return false" class="item-delete"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="삭제"></button></li>');
    $('#jobChrstcInfoAdder').click(function(e) {
        e.preventDefault();

        // 5개까지 선택 가능
        if ($('#jobChrstcInfoSelected li').length >= 5) {
            alert('분류유형은 5개까지 선택 가능 합니다.');
            return;
        }

        if ($('#jobChrstcInfoSelected :has(:hidden[value="' + $('#jobChrstcInfoSelector option:selected').val() + '"])').length) {
            alert('추가된 분류유형 입니다.');
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

    // 특정분류 인덱싱
    var indexingJobChrstcCd = function() {
        $('#jobChrstcInfoSelected').find(':hidden').each(function(i, o) {
            $(o).attr('name', 'schJobGroup[{0}].schChrstcCd'.format(i));
            //name="schJobGroup"
        });
    };

});

function on_submit(){

    if($("#schNo").val() == ""){

        if ($("#userId").val() == "") {
          alert('아이디를 입력해주세요.');
          return false;
        }

        if (idChk == "N") {
          alert('아이디 중복 확인 해주세요.');
          return false;
        }

        if($("#password").val() == ""){
            alert('비밀번호를 입력하세요.');
            return false;
        }
        if($("#chkPwd").val() != $("#password").val()){
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }

        if($("#password").val().length < 10){
            alert('비밀번호는 10자 이상의 영문, 숫자, 특수기호 조합으로  입력해주세요.');
            return false;
        }

        var SamePass_0 = 0; //ID와 3자이상 중복체크

        var chr_pass_0;
        var chr_pass_1;
        var chr_pass_2;

        var chr_id_0;
        var chr_id_1;
        var chr_id_2;

        for(var i=0; i < ($("#password").val().length-2); i++) {

          chr_pass_0 = $("#password").val().charAt(i);
          chr_pass_1 = $("#password").val().charAt(i+1);
          chr_pass_2 = $("#password").val().charAt(i+2);

          for(var j=0; j < ($("#userId").val().length-2); j++) {
              chr_id_0 = $("#userId").val().charAt(j);
              chr_id_1 = $("#userId").val().charAt(j+1);
              chr_id_2 = $("#userId").val().charAt(j+2);
              if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                  SamePass_0=1;
              }
          }
        }
        if($("#password").val().search(/\s/) != -1){
          alert("비밀번호는 공백없이 입력해주세요.");
          return false;
        }

        if(SamePass_0 >0){
          alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
          return false;
        }

        if(/([\w\W\d])\1\1/.test($("#password").val())) {
          alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
          return false;
        }

        if (!!!($("#username").val())) {
            alert('이름을 입력하세요.');
            return false;
        }
    }else{
        if($("#chkPwd").val() != ""){
            if($("#chkPwd").val() != $("#password").val()){
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }

            if($("#password").val().length < 10){
                alert('비밀번호는 10자 이상의 영문, 숫자, 특수기호 조합으로  입력해주세요.');
                return false;
            }

            var SamePass_0 = 0; //ID와 3자이상 중복체크

            var chr_pass_0;
            var chr_pass_1;
            var chr_pass_2;

            var chr_id_0;
            var chr_id_1;
            var chr_id_2;

            for(var i=0; i < ($("#password").val().length-2); i++) {

                chr_pass_0 = $("#password").val().charAt(i);
                chr_pass_1 = $("#password").val().charAt(i+1);
                chr_pass_2 = $("#password").val().charAt(i+2);

                for(var j=0; j < ($("#userId").val().length-2); j++) {
                    chr_id_0 = $("#userId").val().charAt(j);
                    chr_id_1 = $("#userId").val().charAt(j+1);
                    chr_id_2 = $("#userId").val().charAt(j+2);
                    if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                      SamePass_0=1;
                    }
                }
            }
            if($("#password").val().search(/\s/) != -1){
              alert("비밀번호는 공백없이 입력해주세요.");
              return false;
            }



            if(SamePass_0 >0){
              alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
              return false;
            }

            if(/([\w\W\d])\1\1/.test($("#password").val())) {
              alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
              return false;
            }
        }
    }

    if($("#emailAddr1").val() != ""){
        $("#emailAddr").val($("#emailAddr1").val() + "@" + $("#emailAddr2").val());
        if(!isValidEmailAddress($("#emailAddr").val())){
            alert("이메일 주소를 올바르게 입력해주세요.\n예) abc@abc.com");
            $("#emailAddr").val("");
            return false;
        }
    }

    if($("input[name=schClassCd]:checked").val() == ""){
        alert('학교급을 선택해주세요.');
        return false;
    }

    if($("#schNm").val() == ""){
        alert('학교을 입력하세요.');
        return false;
    }
    if($("#locaAddr").val() == 'undefined' || $("#locaAddr").val() == ''){
        alert('주소를 입력해주세요.');
        return false;
    }


    if($('input[name=deviceTypeHold]:checked').length < 1){
        alert('보유장비를 선택해주세요.');
        return false;
    }
    var contTel = ""
    if($("#contTel2").val() != "" && $("#contTel3").val() != ""){
        if($("#contTel1").val() == ""){
            alert('연락처를 선택해주세요');
            return false;
        }
        contTel =  $("#contTel1").val() + "-" +  $("#contTel2").val() +"-"+  $("#contTel3").val();
    }
    $("#contTel").val(contTel);

    var tel = "";
    if($("#tel2").val() != "" && $("#tel3").val() != ""){
        if($("#tel1").val() == ""){
            alert('담당 휴대전화를 선택해주세요');
            return false;
        }
        tel =  $("#tel1").val() + "-" +  $("#tel2").val() +"-"+  $("#tel3").val();
    }
    $("#tel").val(tel);
    $("#selSchoolList>tr").each(function(idx){
        var schItem = $(this).find("td").eq(0).find("input");
        schItem.attr("name","bizGrpInfo.listSchInfo[{0}].schNo".format(idx)).prop("checked","checked");
    });
    $('#frm').submit();
}

function callbackSelected(schInfos){
    $("#locaAddr").val(schInfos.ROADADDR);
    $("#postCd").val(schInfos.ZIPNO);
    var splitAddr = schInfos.JIBUNADDR.split(" ");
    $("#sidoNm").val(splitAddr[0]);
    $("#sgguNm").val(splitAddr[1]);
    $("#umdngNm").val(splitAddr[2]);
}

 $('#checkIdDupl').click(function(e) {
        e.preventDefault();

        if (!$('#userId').val()) {
            alert('중복검사 할 아이디를 입력해주세요.');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/ajax.checkIdDupl.do',
            data : {'id':$('#userId').val()},
            contentType: 'application/json',
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                if (rtnData.success === 'true') {
                    $('#checkIdDuplValue').toggleClass('warning', !(useable = true));
                    alert('사용가능한 아이디 입니다.');
                    idChk = "Y";
                }
                else {
                    $('#checkIdDuplValue').toggleClass('warning', !(useable = false));
                    alert(rtnData.message);
                    idChk = "N";
                }
            }.bind(this),
            error: function(xhr, status, err) {
            }.bind(this)
        });
    });

    function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/);
        return pattern.test(emailAddress);
    }
</script>