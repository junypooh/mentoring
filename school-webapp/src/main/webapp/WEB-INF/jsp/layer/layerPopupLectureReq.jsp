<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
%>
<!-- 수업요청 -->
<div class="layer-pop-wrap my-class-reg" id="lessonRequest">
    <div class="layer-pop m-blind">
        <div class="layer-header">
            <strong class="title">수업요청</strong>
        </div>
        <div class="layer-cont">
            <p class="pop-cont-desc">요청하신 내용은 수업 가능 유무 확인 후, 개설되어지며 상황에 따라 변경되어질 수 있습니다. <br />
        							찾으시는 멘토 또는 직업이 검색되지 않는 경우 내용에 상세하게 입력해주세요.
            </p>
            <div class="layer-pop-scroll">
                <div class="tbl-style demend">
                    <table>
                        <caption>수업요청 - 교사,학교,주제,내용,학교급,희망일시,직업,멘토</caption>
                        <colgroup>
                            <col style="width:20%" />
                            <col />
                        </colgroup>
                        <tbody>
                        <tr>
                            <th scope="row">교사</th>
                            <td><c:out value="${user.username}" ></c:out></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="schInfoList">학교</label></th>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:length(schInfoList) > 1}">
                                        <form:select path="schInfoList" class="slt-style" id="schInfoList">
                                            <form:options items="${schInfoList}" itemLabel="schNm" itemValue="schNo"/>
                                        </form:select>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${schInfoList[0].schNm}" ></c:out>
                                        <input type="hidden" id="schInfoList" value="${schInfoList[0].schNo}"/>
                                    </c:otherwise>
                                </c:choose>
                                <%--
                                <select id="schoolGroup" name="schoolGroup" title="교실">
                                    <option value="">선택</option>
                                </select>
                                --%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="schClassCd">학교급</label></th>
                            <td>
                                <form:select path="schoolGrd" class="slt-style" id="schClassCd">
                                    <form:option value="">선택</form:option>
                                    <form:options items="${schoolGrd}" itemLabel="cdNm" itemValue="cd"/>
                                </form:select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="wishDate">희망일시</label></th>
                            <td id="cloneTd" class="td-wish-dat">
                                <div class="wish-dat">
                                    <input type="text" id="lectPrefDay0" title="희망 날짜 선택" class="inp-style date" style="width:100px;"/>
                                    <select id="reqTime0" class="slt-style" title="희망 시간">
                                        <option value="0800">08:00</option>
                                        <option value="0900">09:00</option>
                                        <option value="1000">10:00</option>
                                        <option value="1100">11:00</option>
                                        <option value="1200">12:00</option>
                                        <option value="1300">13:00</option>
                                        <option value="1400">14:00</option>
                                        <option value="1500">15:00</option>
                                        <option value="1600">16:00</option>
                                    </select>
                                    <span class="add-time"></span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">직업</th>
                            <td>
                                <div class="job-area">
                                    <c:if test="${empty param.jobNo}">
                                        <span class="inp-radio">
                                            <label class="radio-skin checked" title="선택 안함">
                                                <input type="radio" name="jobRadio" id="jobRadio1" checked="checked" />선택 안함
                                            </label>
                                        </span>
                                        <span class="inp-radio">
                                            <label class="radio-skin" title="선택">
                                                <input type="radio" name="jobRadio" id="jobRadio2"/>선택
                                            </label>
                                        </span>
                                        <a href="#" class="job-search" style="display:none;" id="jobRadioSearch">검색</a>
                                    </c:if>
                                    <input type="hidden" id="targtJobNo" value="${param.jobNo}"/>
                                    <span id="targtJobNm">${param.jobNm}</span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">멘토</th>
                            <td>
                                <div class="job-area">
                                    <c:if test="${empty param.mbrNo}">
                                        <span class="inp-radio">
                                            <label class="radio-skin checked" title="지정 안함">
                                                <input type="radio" name="mentorRadio" id="mentorRadio1" checked="checked"/>지정 안함
                                            </label>
                                        </span>
                                        <span class="inp-radio">
                                            <label class="radio-skin" title="지정">
                                                <input type="radio" name="mentorRadio" id="mentorRadio2"/>지정
                                            </label>
                                        </span>
                                        <a href="#" class="job-search" style="display:none;" id="mentorRadioSearch">검색</a>
                                    </c:if>
                                    <input type="hidden" id="targtMbrNo" value="${param.mbrNo}"/>
                                    <input type="hidden" id="mentorCnt" value="${param.mentorCnt}" />
                                    <span id="targtMentorNm">${param.mbrNm}</span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">영상 솔루션</th>
                            <td>
                                <div class="job-area" id="solutionArea">
                                    <span class="inp-radio">
                                        <label class="radio-skin checked" title="기본 솔루션">
                                            <input type="radio" name="solutionRadio" id="solutionRadio1" checked="checked"/>기본 솔루션
                                        </label>
                                    </span>
                                    <span class="inp-radio">
                                        <label class="radio-skin" title="기타 솔루션">
                                            <input type="radio" name="solutionRadio" id="solutionRadio2"/>기타 솔루션
                                        </label>
                                    </span>
                                    <!-- 지정옵션 선택 시 -->
                                    <div class="solution-designation">
                                        <span class="choice">
                                            <form:select path="solutionKinds" id="solKindCd" title="영상솔루션 지정 선택" class="slt-style" cssStyle="width:110px">
                                                <form:option value="">선택</form:option>
                                                <form:options items="${solutionKinds}" itemLabel="cdNm" itemValue="cd"/>
                                            </form:select>
                                        </span>
                                        <span class="contact">
                                            <em><label for="solCoTel">연락처</label></em>
                                            <span><input type="text" id="solCoTel" class="inp-style" style="width:225px;" title="연락처" /></span>
                                            <p>
                                                ※ 산들바람에서 제공하는 기본 솔루션 외 타 수업 방식을 원하시는 경우,<br/>
                                                 멘토님과 연락이 가능한 연락처를 꼭 입력해주세요.<br/>
                                                멘토님이 요청내용을 확인하신 후 직접 연락드립니다.
                                            </p>
                                        </span>
                                    </div>
                                    <!-- //지정옵션 선택 시 -->
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectTitle">수업주제</label></th>
                            <td><input type="text" id="lectTitle" class="inp-style" title="수업주제" /></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectSust">내용</label></th>
                            <td>
                                <div class="text-area popup">
                                    <textarea id="lectSust" class="ta-style" name="text" style="width:468px;"></textarea>
                                    <span class="text-limit"><strong>0</strong> / 400자</span>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup" onclick="lectureReqInsert();">확인</a>
                <a href="#" class="btn-type2 cancel" id="aCancel">취소</a>
            </div>
            <a href="#" class="layer-close" id="aClose">팝업 창 닫기</a>
        </div>
    </div>
</div>
<script type="text/javascript">
    var lectTime = ""
    $(document).ready(function(){
        //_applyDatepicker($("#lectPrefDay0"));

        $("#lectPrefDay0").removeClass('hasDatepicker').datepicker({
                    showMonthAfterYear:true,
                    showOn: "both",
                    buttonImage: mentor.contextpath + "/images/lesson/img_calendar.png",
                    buttonImageOnly:true,
                    dateFormat:'yy-mm-dd',
                    nextText:'다음 달',
                    prevText:'이전 달',
                    dayNamesMin:['일','월','화','수','목','금','토'],
                    monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] ,
                    monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] ,
                    minDate:7,
                    defaultDate:+7
                }).attr('readonly','readonly');

        position_cm();
        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");

        $("#schInfoList").trigger("change");

    });

    $("#lectTitle").keyup(function() {
        var stringByteLength = $("#lectTitle").val().length;
        if(stringByteLength > 20){
            alert("입력글자수를 초과하였습니다.");
            var sText = $("#lectTitle").val();
            $("#lectTitle").val(sText.substr(0, 20));
            return false;
        }
    });

    $("#lectSust").keyup(function() {
        var stringByteLength = $("#lectSust").val().length;
        if(stringByteLength > 400){
            alert("입력글자수를 초과하였습니다.");
            var sText = $("#lectSust").val();
            $("#lectSust").val(sText.substr(0, 400));
            return false;
        }
        $(".text-limit").children().html('<strong>'+ stringByteLength +'</strong>');
    });

    $("#solCoTel").keyup(function() {
        $(this).val( $(this).val().replace(/[^0-9]/gi,"") );

        var stringByteLength = $("#solCoTel").val().length;
        if(stringByteLength > 20){
            alert("입력글자수를 초과하였습니다.");
            var sText = $("#solCoTel").val();
            $("#solCoTel").val(sText.substr(0, 20));
            return false;
        }
    });

    <c:if test="${empty param.jobNo}">
    $(function(){
        $("input:radio[name='jobRadio']").click(function(){
            if($("#jobRadio2").is(':checked')){
                $("#jobRadioSearch").show();
            }else{
                $("#jobRadioSearch").css("display", "none");
                $("#targtJobNo").val("");
            }
        });
    });
    </c:if>

    <c:if test="${empty param.mbrNo}">
    $(function(){
        $("input:radio[name='mentorRadio']").click(function(){
            if(this.id == 'mentorRadio2' && $('#mentorCnt').val() != '' && $('#mentorCnt').val() == 0){
                alert('해당 직업에 지정할 멘토가 없습니다');
                return false;
            }
            if($("#mentorRadio2").is(':checked')){
                $("#mentorRadioSearch").show();
            }else{
                $("#mentorRadioSearch").hide();
                $("#targtMbrNo").val("");
            }
        });
    });
    </c:if>

    $(function(){
        $("input:radio[name='solutionRadio']").click(function(){
//            if($("#solutionRadio1").parent().hasClass('checked')){
            if(this.id == "solutionRadio2"){
                $("#solutionArea").addClass("view");
            }else{
                $("#solutionArea").removeClass("view");
                $("#solKindCd").val("");
                $("#solCoTel").val("");
            }
        });
    });


    var cloneCount = 0;
    $(".add-time").click(function() {

        cloneCount = $(".wish-dat").length-1;

        lectTime = $(".wish-dat:last").clone();

        lectTime.find(".add-time").html('<button type="button" onClick="deleteTime(this)" class="btn-type3 popup" name="삭제">삭제</button>');
        lectTime.find(".add-time").removeClass("add-time");
        lectTime.find(".add-time").remove();
        lectTime.find("#lectPrefDay"+cloneCount).val("");
        lectTime.find("#reqTime"+cloneCount).attr("id", "reqTime" + (cloneCount+1));
        lectTime.find("#lectPrefDay"+cloneCount).attr("id", "lectPrefDay" + (cloneCount+1));

        if($(".wish-dat").length >= 5){
            alert("희망일시는 최대5개까지 입력가능합니다.")
            return false;
        }

        $("#cloneTd").append(lectTime);


        $(".wish-dat:last >img").remove();

        $("#lectPrefDay"+ (cloneCount+1)).removeClass('hasDatepicker').datepicker({
            showMonthAfterYear:true,
            showOn: "both",
            buttonImage: mentor.contextpath + "/images/lesson/img_calendar.png",
            buttonImageOnly:true,
            dateFormat:'yy-mm-dd',
            nextText:'다음 달',
            prevText:'이전 달',
            dayNamesMin:['일','월','화','수','목','금','토'],
            monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] ,
            monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] ,
            minDate:7,
            defaultDate:+7
        }).attr('readonly','readonly');
        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");
    });

    // 희망일시 삭제
    function deleteTime(obj){
        $(obj).parent().parent().remove();

        // id 재정의
        $.each($('.wish-dat'), function(idx, val){
            $(this).children().eq(0).attr('id', 'lectPrefDay'+idx);
            $(this).children().eq(2).attr('id', 'reqTime'+idx);
        });
    }

    <c:if test="${empty param.jobNo}">
    $("#jobRadioSearch").click(function() {
        var url = mentor.contextpath + "/lecture/lectureTotal/popupJobSearch.do";
        window.open(url, 'popupJobSearch', 'width=720, height=636, menubar=no, status=no, toolbar=no');
    });
    </c:if>

    <c:if test="${empty param.mbrNo}">
    $("#mentorRadioSearch").click(function() {
        var url = mentor.contextpath + "/lecture/lectureTotal/popupMentorSearch.do?jobNo=${param.jobNo}&jobNm=${param.jobNm}";
        window.open(url, 'popupMentorSearch', 'width=720, height=636, menubar=no, status=no, toolbar=no');
    });
    </c:if>

    function validationReqInsert(){
        var validationDay = [];

        if($("#lectTitle").val() == ""){
            alert("주제를 입력하세요.");
            return false;
        }

        if($("#lectSust").val() == ""){
            alert("내용을 입력하세요.");
            return false;
        }

        if($("#schClassCd option:selected").val() == ""){
            alert("학교급을 선택하세요.");
            return false;
        }

        for(var i=0; i< $(".wish-dat").length;i++){
            if($("#lectPrefDay"+i).val() == ""){
                alert("희망일시를 입력하세요.");
                return false;
                break;
            }
            validationDay.push($("#lectPrefDay"+i).val()+$("#reqTime"+i).val());
        }

        var uniqueNames = [];
        var returnContinue = true;

        $.each(validationDay, function(i, el){
            if($.inArray(el, uniqueNames) == -1){
                uniqueNames.push(el);
            }else{
                alert("희망일시가 중복되었습니다.");
                returnContinue = false;
                return false;
            }
        });

        if(!returnContinue){
            return false;
        }

        <c:if test="${empty param.jobNo}">
        if(($("#jobRadio2").is(':checked')) && ($("#targtJobNo").val() == "")){
            alert("직업을 선택하세요.");
            return false;
        }
        </c:if>

        <c:if test="${empty param.mbrNo}">
        if(($("#mentorRadio2").is(':checked')) && ($("#targtMbrNo").val() == "")){
            alert("멘토를 선택하세요.");
            return false;
        }
        </c:if>

        if(($("#solutionRadio2").is(':checked')) && ($("#solKindCd").val() == "")){
            alert("솔루션을 선택하세요.");
            return false;
        }

        if(($("#solutionRadio2").is(':checked')) && ($("#solCoTel").val() == "")){
            alert("연락처를 입력하세요.");
            return false;
        }
        return true;
    }

    var timeArray = new Array();
    var dayArray = new Array();

    function lectureReqInsert(){

        if(!validationReqInsert()){
            return false;
        }

        if(!confirm("수업요청 하시겠습니까?")) {
            return false;
        }

        $('.wish-dat').each(function(idx, item){
            timeArray.push($("#reqTime"+idx).val());
            dayArray.push($("#lectPrefDay"+idx).val());
        });

        var _param = {'lectReqTimeInfo':timeArray,
                      'lectReqDayInfo':dayArray,
                       'schClassCd':$("#schInfoList").val(),
                       //'clasRoomSer':$("#schoolGroup option:selected").val(),
                       'schClassCd':$("#schClassCd option:selected").val(),
                      'lectTitle':$("#lectTitle").val(),
                      'lectSust':$("#lectSust").val(),
                      'targtJobNo':$("#targtJobNo").val(),
                      'targtMbrNo':$("#targtMbrNo").val(),
                      'solKindCd':$("#solKindCd").val(),
                      'solCoTel':$("#solCoTel").val()
                       };
        $.ajax({
            url: mentor.contextpath + '/layer/lectureReqInsert.do',
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            traditional: true,
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                }else{
                    alert(rtnData.message);
                }
                $("#aClose").click();
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });

        timeArray = new Array();
        dayArray  = new Array();
    }

</script>

