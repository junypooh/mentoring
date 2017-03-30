<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<c:choose>
    <c:when test="${param.lectTargtCd eq code['CD101533_101535_중학교']}">
        <c:set var="validateTime" value="70"/>
    </c:when>
    <c:when test="${param.lectTargtCd eq code['CD101533_101536_고등학교']}">
        <c:set var="validateTime" value="70"/>
    </c:when>
    <c:when test="${param.lectTargtCd eq code['CD101533_101538_중_고등학교']}">
        <c:set var="validateTime" value="70"/>
    </c:when>
    <c:otherwise>
        <c:set var="validateTime" value="60"/>
    </c:otherwise>
</c:choose>

<div class="layer-pop-wrap" id="layer1">
    <div class="title">
        <strong>수업일시 추가</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
    </div>
<form:form action="${pageContext.request.contextPath}/lecture/lectureState/retrieveIectureSchdInfoInsert.do?${_csrf.parameterName}=${_csrf.token}" method="post" id="schdfrm" >
    <input type="hidden" name="lectTimsInfo.lectSer" id="lectTimsInfoLectSer"/>
    <input type="hidden" name="lectTimsInfo.lectTitle" id="timsTitle"/>
    <input type="hidden" name="lectTimsInfo.lectrMbrNo" id="lectTimsInfoLectrMbrNo"/>
    <input type="hidden" id="lectStartTime"/>
    <input type="hidden" id="lectEndTime"/>

    <div class="cont type3">
        <div class="studio-search-list">
            <div class="lesson-add-wrap">
                <strong class="title-640">날짜</strong>
                <input type="text" class="inp-style1" style="width:110px" id="lectDay"/>
            </div>
                <div class="lesson-add-wrap other">
                <strong class="title-640" style="width:100px;">시간</strong>

                <div class="add-time">
                    <label title="시작">시작
                        <select class="slt-style" title="시" id="startHour">
                            <option value="">시</option>
                            <option value="09">09</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                        </select>
                        <select class="slt-style" title="분" id="startMin">
                            <option value="">분</option>
                            <option value="00">00</option>
                            <option value="05">05</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                            <option value="25">25</option>
                            <option value="30">30</option>
                            <option value="35">35</option>
                            <option value="40">40</option>
                            <option value="45">45</option>
                            <option value="50">50</option>
                            <option value="55">55</option>
                        </select>
                    </label>
                    <label title="종료">종료
                        <select class="slt-style" title="시" id="endHour">
                            <option value="">시</option>
                            <option value="09">09</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                        </select>
                        <select class="slt-style" title="분" id="endMin">
                            <option value="">분</option>
                            <option value="00">00</option>
                            <option value="05">05</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                            <option value="25">25</option>
                            <option value="30">30</option>
                            <option value="35">35</option>
                            <option value="40">40</option>
                            <option value="45">45</option>
                            <option value="50">50</option>
                            <option value="55">55</option>
                        </select>
                    </label>
                    <span>
                    <c:choose>
                        <c:when test="${param.lectTypeCd == '101532'}">블록 수업 시간 ${validateTime}분 이상 240분 미만</c:when>
                        <c:otherwise>초등학교 수업 교시 30분 / 중·고등학교 35분</c:otherwise>
                    </c:choose>
                    </span>
                </div>
                <div class="lesson-add-wrap">
                    <input type="hidden" id="stdoNo" name="stdoNo" value="">
                    <strong>스튜디오</strong>
                    <label class="radio-skin">사용안함
                        <input type="radio" name="studioNo" id="radioStudio1" />
                    </label>
                    <label class="radio-skin checked">사용
                        <input type="radio" name="studioNo" id="radioStudio2" />
                    </label>
                    <a href="#" class="studio-search">스튜디오 찾기</a>
                    <span></span>
                </div>
                <div class="lesson-add-wrap">
                    <input type="hidden" id="mcNo" name="mcNo" value="">
                    <strong>MC</strong>
                    <label class="radio-skin">지정안함
                        <input type="radio" name="microNo" id="radioMc1" />
                    </label>
                    <label class="radio-skin checked">직접 지정
                        <input type="radio" name="microNo" id="radioMc2" />
                    </label>
                    <a href="#" class="mc-search">MC 찾기</a>
                    <span></span>
                </div>
            </div>
        </div>
        <div class="btn-area">
            <a href="javascript:void(0)" class="btn-type2 blue" id="aConfirm">확인</a>
            <a href="javascript:void(0)" class="btn-type2 gray" onclick="fnClosePopup()">취소</a>
        </div>
    </div>
</form:form>
</div>
<script type="text/javascript">
    var diffDate = ${param.assignDay} +1;
    $(document).ready(function() {
        position_cm();

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                fnClosePopup();
            }
        });

       $(".studio-search").click(function(){
           if(!fnValidateForStudio()){
               return false;
           }

           if($('#mcNo').val() != ''){
              $('#mcNo').val('');
              $("#mcNo").parent().find("span").text('');
           }

           var stdoUrl = mentor.contextpath + "/layer/popupStudioSearch.do?lectSer="+$("#lectSer").val() + "&lectDay=" + $('#lectDay').val().replace(/-/gi,'') + "&lectStartTime=" + $("#startHour").val() + $("#startMin").val() +"&lectEndTime=" + $("#endHour").val() + $("#endMin").val();
           var popobj = window.open(stdoUrl, 'popupStudioSearch', 'width=660, height=670, menubar=no, status=no, toolbar=no');
           popobj.focus();
       });

        $(".mc-search").click(function(){
            if(!fnValidateForStudio()){
                return false;
            }
            if($("#radioStudio2").parent().hasClass("checked") && $('#stdoNo').val() == ''){
                alert('스튜디오를 선택하세요.');
                return false;
            }
            var mcUrl = mentor.contextpath + "/layer/popupMcSearch.do?lectSer="+$("#lectSer").val()  + "&lectDay=" + $('#lectDay').val().replace(/-/gi,'') + "&lectStartTime=" + $("#startHour").val() + $("#startMin").val() +"&lectEndTime=" + $("#endHour").val() + $("#endMin").val();
            var popobj = window.open(mcUrl, 'popupMcSearch', 'width=660, height=670, menubar=no, status=no, toolbar=no');
            popobj.focus();
        });

        $("#lectDay").removeClass('hasDatepicker').datepicker({
            showMonthAfterYear:true,
            showOn: "both",
            buttonImage: mentor.contextpath + "/images/common/img_calendar.png",
            buttonImageOnly:true,
            dateFormat:'yy-mm-dd',
            nextText:'다음 달',
            prevText:'이전 달',
            dayNamesMin:['일','월','화','수','목','금','토'],
            monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
            minDate:diffDate,
            defaultDate:+diffDate
        }).attr('readonly','readonly');

        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");

        $(function(){
            $("input:radio[name='studioNo']").click(function(){
                if($("#radioStudio2").is(":checked")){
                    $(".studio-search").show();
                    if($('#mcNo').val() != ''){
                       $('#mcNo').val('');
                       $("#mcNo").parent().find("span").text('');
                    }
                }else{
                    $("#stdoNo").val("");
                    $(this).parent().parent().find("span").text("");
                    $(".studio-search").hide();
                }
            });
        });
        $(function(){
            $("input:radio[name='microNo']").click(function(){
                if($("#radioMc2").is(":checked")){
                    $(".mc-search").show();
                }else{
                    $("#mcNo").val("");
                    $(this).parent().parent().find("span").text("");
                    $(".mc-search").hide();
                }
            });
        });
    });

    function fnValidateForStudio(){
        if($("#lectDay").val() == ""){
            alert("강의날짜를 입력해주세요.");
            $("#lectDay").focus();
            return false;
        }

        if($("#startHour").val() == ""){
            alert("강의시작 시각을 입력해주세요.");
            $("#startHour").focus();
            return false;
        }

        if($("#startMin").val() == ""){
            alert("강의시작 분을 입력해주세요.");
            $("#startMin").focus();
            return false;
        }

        if($("#endHour").val() == ""){
            alert("강의종료 시각을 입력해주세요.");
            $("#endHour").focus();
            return false;
        }

        if($ ("#endMin").val() == ""){
            alert("강의종료 분을 입력해주세요.");
            $("#endMin").focus();
            return false;
        }
        return true;
    }

    function fnValidationInsert(){

        if(!fnValidateForStudio()){
            return false;
        }

        if($("#radioStudio2").parent().hasClass("checked") && $("#stdoNo").val() == ""){
            alert("스튜디오를 지정하세요.");
            return false;
        }

        if($("#radioMc2").parent().hasClass("checked") && $("#mcNo").val() == ""){
            alert("MC를 지정하세요.");
            return false;
        }

        var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

        var startTime =  toTimeObject($("#lectDay").val().replace(regExp, "") +$("#startHour").val() + $("#startMin").val());
        var endTime = toTimeObject($("#lectDay").val().replace(regExp, "") +$("#endHour").val() + $("#endMin").val());

        var btMs = endTime.getTime() - startTime.getTime() ;
        var btTime = btMs / (1000*60) ;

        if( ${param.lectTargtCd} != '101713'){  //기타제외
            if($("#lectTypeCd").val() == '101532'){  //블록계산
                if(btTime < parseInt(${validateTime}) || btTime > 240){
                    alert("수업시간은 ${validateTime}분이상 240분미만입니다.");
                    return false;
                }
            }else{
                if(btTime <30 || btTime > 35){
                    alert("수업시간은 30분이상 35분까지입니다.");
                    return false;
                }
            }
        }
        return true;
    }

    function fnClosePopup(){
        $(".pop-close").click();
    }

    $("#aConfirm").click(function(){
        lectureSchdInfoSave();
    });


    function lectureSchdInfoSave(){
        if(!fnValidationInsert()){
            return false;
        }

        if(!confirm("수업일시정보를 저장 하시겠습니까?")) {
            return false;
        }


        //수업일련번호
        $("#lectTimsInfoLectSer").val($("#lectSer").val());
        //수업제목
        $("#timsTitle").val($("#lectTitle").val());
        //멘토회원번호
        $("#lectTimsInfoLectrMbrNo").val($("#lectrMbrNo").val());

        $(".studio-search-list").each(function(idx) {
            //강의날짜
            $(this).find(".inp-style1").attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].lectDay");

            //강의시작시간
            $("#lectStartTime").val($(this).find("#startHour").val() + $(this).find("#startMin").val());
            $("#lectStartTime").attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].lectStartTime");

            //강의종료시간
            $("#lectEndTime").val($(this).find("#endHour").val() + $(this).find("#endMin").val());
            $("#lectEndTime").attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].lectEndTime");

            //스튜디오 번호
            $(this).find('input:hidden[name=stdoNo]').attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].stdoNo");

            //MC번호
            $(this).find('input:hidden[name=mcNo]').attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].mcNo");
        });

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureState/retrieveIectureSchdInfoInsert.do',
            data : $("#schdfrm").serialize(),
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    $("#layer1").find(".btn-type2.gray").trigger('click');
                    fnClosePopup();
                    if($("#lectTims").val() == ""){
                        var parameter = $.param({"lectSer":$("#lectSer").val(), "lectTims": "1", "schdSeq": "1", "listType": "4"});
                        var url = mentor.contextpath + "/lecture/lectureState/lectureDetailView.do?"+ parameter;
                        $(location).attr('href', url);
                    }else{
                        fn_search(dataSet.params.currentPageNo);
                    }
                }else{
                    alert(rtnData.message);
                     fnClosePopup();
                }
            }
        });


    }
</script>