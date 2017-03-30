<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="layer-pop-wrap w710" id="layer1">
    <div class="title">
        <strong>수업일시 추가</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
<form:form action="${pageContext.request.contextPath}/lecture/lectureState/retrieveIectureSchdInfoInsert.do?${_csrf.parameterName}=${_csrf.token}" method="post" id="schdfrm" >
    <input type="hidden" name="lectTimsInfo.lectSer" id="lectTimsInfoLectSer"/>
    <input type="hidden" name="lectTimsInfo.lectTitle" id="timsTitle"/>
    <input type="hidden" name="lectTimsInfo.lectrMbrNo" id="lectTimsInfoLectrMbrNo"/>
    <input type="hidden" name="selectedStudios" id="selectedStudios" value=""/>
    <input type="hidden" name="selectedMcs" id="selectedMcs" value=""/>
    <div class="layer-cont2">
        <div class="studio-search-list">
            <div class="lesson-add-first">
                <strong>연강 단위</strong>
                <select class="slt-style" title="회차횟수" id="selectTims">
                    <option value="">선택</option>
                    <option value="2">총 2회차</option>
                    <option value="3">총 3회차</option>
                    <option value="4">총 4회차</option>
                </select>
                <span>저장과 동시에 승인 요청 혹은 수강 모집을 자동 진행합니다.</span>
            </div>
            <div class="layer-pop-scroll" style="border-top:1px solid #666;width:672px;">
            </div>
        </div>
        <div class="btn-area">
            <a href="javascript:void(0)" class="btn-type2 blue" id="aConfirm">확인</a>
            <a href="javascript:void(0)" class="btn-type2 gray" onclick="fnClosePopup()">취소</a>
        </div>
    </div>
</form:form>
</div>

<div class="tbl-add-area" id="timsDiv" style="display:none;">
    <input type="hidden" id="lectStartTime"/>
    <input type="hidden" id="lectEndTime"/>
    <em>1회차</em>
    <div class="add-area" style="width:570px;">
        <div class="add-date">
            <strong>일시</strong>
            <input type="text" class="inp-style1" style="width:110px" id="lectDay"/>
            <%--<span class="add-calendar">달력선택</span>--%>
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
        </div>
        <div class="add-studio" id="studioNo">
        <input type="hidden" id="stdoNo" name="stdoNo" value="">
            <strong>스튜디오</strong>
            <label class="radio-skin">사용안함
                <input type="radio" name="radioStudio" id="radioStudio1" />
            </label>
            <label class="radio-skin checked">사용
                <input type="radio" name="radioStudio" id="radioStudio2" />
            </label>
            <a href="#" class="studio-search">스튜디오 찾기</a>
            <span></span>
        </div>
        <div class="add-mc" id="mcRadioNo">
        <input type="hidden" id="mcNo" name="mcNo" value="">
            <strong>MC</strong>
            <label class="radio-skin">지정안함
                <input type="radio" name="radioMc" id="radioMc1" />
            </label>
            <label class="radio-skin checked">직접 지정
                <input type="radio" name="radioMc" id="radioMc2" />
            </label>
            <a href="#" class="mc-search">MC 찾기</a>
            <span></span>
        </div>
    </div>
</div>

<script type="text/javascript">
    var diffDate = ${param.assignDay} + 1;
    $(document).ready(function() {

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                fnClosePopup();
            }
        });

        var timsCount = 0;
        $("#selectTims").bind("change", function(){
            var selectcount =  this.value;

            if(selectcount == ""){  //선택안할시 목록 일괄삭제
                $(".studio-search-list").find(".tbl-add-area").each(function(idx) {
                    $(this).remove();
                });
            }else if(selectcount > ($(".tbl-add-area").length-1)){
                for(var i=($(".tbl-add-area").length-1); i < selectcount; i++){
                    var cloneTims = $(".tbl-add-area:last").clone().show();
                    cloneTims.find("em").text((i+1)+"회차");
                    cloneTims.find("#lectDay").attr("id", "lectDay"+timsCount);
                    cloneTims.find("#stdoNo").attr("id", "stdoNo"+timsCount);
                    cloneTims.find("#mcNo").attr("id", "mcNo"+timsCount);
                    cloneTims.find("#studioNo").attr("id", "studioNo"+timsCount);
                    cloneTims.find("#mcRadioNo").attr("id", "mcRadioNo"+timsCount);
                    cloneTims.find('input[name=radioStudio]').attr("name", "radioStudio"+timsCount);
                    cloneTims.find('input[name=radioMc]').attr("name", "radioMc"+timsCount);

                    //$(".studio-search-list").append(cloneTims);
                    $(".layer-pop-scroll").append(cloneTims);

                    $("#lectDay"+timsCount).removeClass('hasDatepicker').datepicker({
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

                    //스튜디오, mc찾기 이벤트 바인딩
                    $("#studioNo"+timsCount).find(".studio-search").bind('click', function(){
                        if(!fnValidateForStudio(this)){
                            return false;
                        }

                        var id = $(this).parent().attr('id');
                        var idx = id.substring(id.length-1);
                        var parent = $(this).parent().parent();

                        var query = "&lectDay=" + $('#lectDay'+idx).val().replace(/-/gi,'') + "&lectStartTime=" + parent.find("#startHour").val() + parent.find("#startMin").val() +"&lectEndTime=" + parent.find("#endHour").val() + parent.find("#endMin").val();
                        var stdoUrl = mentor.contextpath + "/layer/popupStudioSearch.do?stdoNo="+$(this).parent().find('input:hidden').attr("id") + query;
                        var popobj = window.open(stdoUrl, 'popupStudioSearch', 'width=660, height=670, menubar=no, status=no, toolbar=no');
                        popobj.focus();
                    });

                    $("#mcRadioNo"+timsCount).find(".mc-search").bind('click', function(){
                        if(!fnValidateForStudio(this)){
                            return false;
                        }
                        var id = $(this).parent().attr('id');
                        var idx = id.substring(id.length-1);
                        var parent = $(this).parent().parent();

                        var query = "&lectDay=" + $('#lectDay'+idx).val().replace(/-/gi,'') + "&lectStartTime=" + parent.find("#startHour").val() + parent.find("#startMin").val() +"&lectEndTime=" + parent.find("#endHour").val() + parent.find("#endMin").val();
                        var mcUrl = mentor.contextpath + "/layer/popupMcSearch.do?mcNo="+$(this).parent().find('input:hidden').attr("id") + query;
                        var popobj = window.open(mcUrl, 'popupMcSearch', 'width=660, height=670, menubar=no, status=no, toolbar=no');
                        popobj.focus();
                    });

                    $(function(){
                        $("#studioNo"+timsCount).find("input[type=radio]").bind('click', function(){
                            if($(this).parent().parent().find("#radioStudio2").is(":checked")){
                                $(this).parent().parent().find(".studio-search").css("display", "");
                            }else{
                                $(this).parent().parent().find("input[name=stdoNo]").val("");
                                $(this).parent().parent().find("span").text("");
                                $(this).parent().parent().find(".studio-search").css("display", "none");
                            }
                        });
                    });

                    $(function(){
                        $("#mcRadioNo"+timsCount).find("input[type=radio]").bind('click', function(){
                            if($(this).parent().parent().find("#radioMc2").is(":checked")){
                                $(this).parent().parent().find(".mc-search").css("display", "");
                            }else{
                                $(this).parent().parent().find("input[name=mcNo]").val("");
                                $(this).parent().parent().find("span").text("");
                                $(this).parent().parent().find(".mc-search").css("display", "none");
                            }
                        });
                    });
                    timsCount++
                }
            }else if(selectcount < ($(".tbl-add-area").length-1)){
                $($(".studio-search-list").find(".tbl-add-area").get().reverse()).each(function() {
                    var length = $($(".studio-search-list").find(".tbl-add-area").get().reverse()).length;
                    if(length == selectcount){
                        return false;
                    }
                    $(this).remove();
                });
            }
            fn_positionCenter();
        });
        position_cm();
    });


    function fnValidateForStudio(target){
            var id = $(target).parent().attr('id');
            var idx = id.substring(id.length-1);
            var parent = $(target).parent().parent();
            if($("#lectDay"+idx).val() == ""){
                alert("강의날짜를 입력해주세요.");
                $("#lectDay"+idx).focus();
                return false;
            }

            if(parent.find("#startHour").val() == ""){
                alert("강의시작 시각을 입력해주세요.");
                parent.find("#startHour").focus();
                return false;
            }

            if(parent.find("#startMin").val() == ""){
                alert("강의시작 분을 입력해주세요.");
                parent.find("#startMin").focus();
                return false;
            }

            if(parent.find("#endHour").val() == ""){
                alert("강의종료 시각을 입력해주세요.");
                parent.find("#endHour").focus();
                return false;
            }

            if(parent.find("#endMin").val() == ""){
                alert("강의종료 분을 입력해주세요.");
                parent.find("#endMin").focus();
                return false;
            }
            return true;
        }

    function fn_positionCenter(){
        var windowWidth = $(window).width();
        var windowHeight = $(window).height();
        var $obj = $("#layer1");
        var thisW = $obj.width();
        var thisH = $obj.height();

        $obj.css({'left':(windowWidth/2)-(thisW/2),'top':(windowHeight/2)-(thisH/2)});
    }

    function unique(list) {
        var result = [];
        $.each(list, function(i, e) {
            if ($.inArray(e, result) == -1) result.push(e);
        });
        return result;
    }

    function fnClosePopup(){
        $(".pop-close").click();
    }

    function fnValidationInsert(){
        var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
        var returnFlag = true;

        var $obj = $(".studio-search-list").find(".tbl-add-area");
        var schdLength = $obj.length;
        var i = 0;

        var scheDays = [];

        $(".studio-search-list").find(".inp-style1").each(function(idx){
             scheDays.push($(this).val());
        });

        $obj.each(function(idx) {

            if($(this).find("#radioStudio2").parent().hasClass("checked") && $(this).find("input[name=stdoNo]").val() == ""){
                alert("스튜디오를 지정하세요.");
                returnFlag = false;
                return false;
            }

            if($(this).find("#radioMc2").parent().hasClass("checked") && $(this).find("input[name=mcNo]").val() == ""){
                alert("MC를 지정하세요.");
                returnFlag = false;
                return false;
            }

            var $val = $(this).find(".inp-style1").val();

            if($val == ""){
                alert("강의날짜를 입력해주세요.");
                returnFlag = false;
                return false;
            }



            if($(this).find("#startHour").val() == ""){
                alert("강의시작 시각을 입력해주세요.");
                returnFlag = false;
                return false;
            }

            if($(this).find("#startMin").val() == ""){
                alert("강의시작 분을 입력해주세요.");
                returnFlag = false;
                return false;
            }

            if($(this).find("#endHour").val() == ""){
                alert("강의종료 시각을 입력해주세요.");
                returnFlag = false;
                return false;
            }

            if($(this).find("#endMin").val() == ""){
                alert("강의종료 분을 입력해주세요.");
                returnFlag = false;
                return false;
            }

            //수업시간
            var startTime =  toTimeObject($(this).find(".inp-style1").val().replace(regExp, "") +$(this).find("#startHour").val() + $(this).find("#startMin").val());
            var endTime = toTimeObject($(this).find(".inp-style1").val().replace(regExp, "") +$(this).find("#endHour").val() + $(this).find("#endMin").val());

            var btMs = endTime.getTime() - startTime.getTime() ;
            var btTime = btMs / (1000*60) ;

            if( ${param.lectTargtCd} != '101713'){  //기타제외
                if(btTime <40 || btTime >110) {
                    //TODO 연강의 수업제한은 어떻게 하는가?
                    alert("수업시간은 40분이상 110분미만입니다.");
                    returnFlag = false;
                    return false;
                }
            }

            //수업일시는 회차순서와 동일한 시간순으로 입력되어야 함
            //수업시간이 회차별로 서로 겹치면 안됨
            if(i < schdLength - 1){
                var nextObj = $obj.eq(i + 1);
                var nextStartTime =  toTimeObject($(nextObj).find(".inp-style1").val().replace(regExp, "") +$(nextObj).find("#startHour").val() + $(nextObj).find("#startMin").val());
                var nextEndTime = toTimeObject($(nextObj).find(".inp-style1").val().replace(regExp, "") +$(nextObj).find("#endHour").val() + $(nextObj).find("#endMin").val());

                if(endTime > nextStartTime){
                    if(startTime >= nextEndTime){
                        alert("수업일시는 회차와 동일한 시간순서로 입력해야 합니다.");
                    }else{
                        alert("수업일시는 회차별로 겹치지 않게 입력해야 합니다.");
                    }

                    returnFlag = false;
                    return false;
                }
            }

            i++;
        });

        return returnFlag;
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

        $(".studio-search-list").find(".tbl-add-area").each(function(idx) {
            //강의날짜
            $(this).find(".inp-style1").attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].lectDay");

            //강의시작시간
            $(this).find("#lectStartTime").val($(this).find("#startHour").val() + $(this).find("#startMin").val());
            $(this).find("#lectStartTime").attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].lectStartTime");

            //강의종료시간
            $(this).find("#lectEndTime").val($(this).find("#endHour").val() + $(this).find("#endMin").val());
            $(this).find("#lectEndTime").attr("name", "lectTimsInfo.lectSchdInfo[" +idx +"].lectEndTime");

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
                    $(".layer-pop-wrap.w710").find(".btn-type2.gray").trigger('click');
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
