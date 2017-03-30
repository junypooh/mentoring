<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<!-- Popup -->
<div class="popup-area" id="_lectTimsAddPopup" style="display:none;">
    <div class="pop-title-box">
		<p class="pop-title">수업일시 추가</p>
	</div>
	<div class="pop-cont-box">
<c:if test="${lectInfo.lectTypeCd eq '101530' }">
		<div class="board-bot">
			<p class="bullet-gray fl-l">연강 단위
                <select id="selectSchdSeq">
                    <option value="0" id="init">선택</option>
                    <option value="2">2회차</option>
                    <option value="3">3회차</option>
                    <option value="4">4회차</option>
                </select>
            </p>
		</div>
</c:if>
		<table class="tbl-style" id="lectSchdlTbl">
			<colgroup>
				<col style="width:50px;">
				<col style="width:80px;">
				<col>
			</colgroup>
		</table>
    </div>
    <div class="pop-cont-box" id="applUpdate">
        <table class="tbl-style">
			<colgroup>
				<col style="width:50px;">
				<col style="width:80px;">
				<col>
			</colgroup>
            <tr>
    			<th scope="col" class="ta-l">수업 신청 기기</th>
				<td>
	    			<input type="text" class="text ta-r" id="timsAddApplCnt" name="timsAddApplCnt" maxlength="3" /><span> 대</span>
				</td>
			</tr>
			<tr>
				<th scope="col" class="ta-l">참관 신청 기기</th>
				<td>
					<input type="text" class="text ta-r" id="timsAddObsvCnt" name="timsAddObsvCnt" maxlength="3" /><span> 대</span>
				</td>
			</tr>
		</table>
		<div class="btn-group-c">
			<button type="button" class="btn-orange" id="donePop"><span class="search">저장</span></button>
			<button type="button" class="btn-gray" id="cnclPopUp"><span class="search">취소</span></button>
		</div>
    </div>
    <a href="javascript:void(0)" id="closePopup" class="btn-close-pop">닫기</a>
</div>
<form  method="post" id="addSchdfrm">
</form>

<!-- Popup[E] -->

<script type="text/javascript">

    $(document).ready(function() {

        $("#timsAddApplCnt").keyup(function() {
            $(this).val( $(this).val().replace(/[^0-9]/gi,"") );
        });

        $("#timsAddObsvCnt").keyup(function() {
            $(this).val( $(this).val().replace(/[^0-9]/gi,"") );
        });

        if(${lectInfo.lectTypeCd != '101530' }){
            fnAddSchdSeq(1);
        }

        $("#selectSchdSeq").bind("change", function(){
            fnAddSchdSeq(this.value);
        });

        $("#closePopup").click(function(){
            $("#lectSchdlTbl").empty();
            fnCleanData();
        });

        $("#cnclPopUp").click(function(){
            $("#lectSchdlTbl").empty();
            fnCleanData();
        });

        $("#donePop").click(function(){
            saveTimsSchdList();
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                fnCleanData();
            }
        });
    });

    function fnCleanData(){
        $('#selectSchdSeq option:eq(0)').attr('selected', 'selected');
        $("#lectSchdlTbl").empty();

        $('#timsAddApplCnt').val($('#BizMaxApplCnt').val());
        $('#timsAddApplCnt').val($('#BizMaxObsvCnt').val());

        closePop();

    }


    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('.popup-area').css({'display': 'none'});
        $('body').removeClass('dim');
    }

    function fnAddSchdSeq(schdSeq){
        var selectcount =  schdSeq;

         var timsCount = 1;

        if(selectcount > ($(".lectMcStdoInfoTable").length-1)){

            for(var i=($(".lectMcStdoInfoTable").length); i < selectcount; i++){

                fnAddSchdHtml(i);

                $( "#lectDay"+i ).datepicker({
                    showOn: "both",
                    buttonImage: "${pageContext.request.contextPath}/images/ico_date.png",
                    buttonImagesOnly:true,
                    dateFormat: "yy-mm-dd",
                    minDate : + ${assignDay+1}
                });
            }
        }else if(selectcount < ($(".lectMcStdoInfoTable").length)){
            $($(".lectMcStdoInfoTable").get().reverse()).each(function() {
                var length = $($(".lectMcStdoInfoTable").get().reverse()).length;
                if(length == selectcount){
                    return false;
                }
                $(this).remove();
            });
        }
    }

    function fnAddSchdHtml(index){
            var schdHtml =  '<tbody class="lectMcStdoInfoTable">';
            schdHtml +=  '  <input type="hidden" id="lectStartTime"/>';
            schdHtml +=  '  <input type="hidden" id="lectEndTime"/>';
            schdHtml +=  '      <tr>';
            schdHtml +=  '          <th scope="col" rowspan="4">'+(index+1)+' 회차</th>';
            schdHtml +=  '          <td>날짜</td>';
            schdHtml +=  '          <td><input type="text"id="lectDay'+index+'" name="selectDate" class="date-input" /></td>';
            schdHtml +=  '      </tr>';
            schdHtml +=  '      <tr>';
            schdHtml +=  '          <td>시간</td>';
            schdHtml +=  '          <td>';
            schdHtml +=  '              <span>시작</span>';
            schdHtml +=  '              <select id="startHour">';
            schdHtml +=  '                  <option value="">시</option>';
            schdHtml +=  '                  <option value="09">09</option>';
            schdHtml +=  '                  <option value="10">10</option>';
            schdHtml +=  '                  <option value="11">11</option>';
            schdHtml +=  '                  <option value="12">12</option>';
            schdHtml +=  '                  <option value="13">13</option>';
            schdHtml +=  '                  <option value="14">14</option>';
            schdHtml +=  '                  <option value="15">15</option>';
            schdHtml +=  '                  <option value="16">16</option>';
            schdHtml +=  '                  <option value="17">17</option>';
            schdHtml +=  '              </select>';
    		schdHtml +=	 '              <select id="startMin">';
    		schdHtml +=  '                  <option value="">분</option>';
    		schdHtml +=  '                  <option value="00">00</option>';
    		schdHtml +=  '                  <option value="05">05</option>';
    		schdHtml +=  '                  <option value="10">10</option>';
    		schdHtml +=  '                  <option value="15">15</option>';
    		schdHtml +=	 '                  <option value="20">20</option>;'
    		schdHtml +=  '                  <option value="25">25</option>';
    		schdHtml +=  '                  <option value="30">30</option>';
    		schdHtml +=  '                  <option value="35">35</option>';
    		schdHtml +=  '                  <option value="40">40</option>';
    		schdHtml +=  '                  <option value="45">45</option>';
    		schdHtml +=  '                  <option value="50">50</option>';
    		schdHtml +=  '                  <option value="55">55</option>';
    		schdHtml +=  '              </select>';
    		schdHtml +=	 '              <span class="ml10">종료</span>';
    		schdHtml +=	 '              <select id="endHour">';
    		schdHtml +=  '                  <option value="">시</option>';
    		schdHtml +=  '                  <option value="09">09</option>';
    		schdHtml +=  '                  <option value="10">10</option>';
    		schdHtml +=  '                  <option value="11">11</option>';
    		schdHtml +=  '                  <option value="12">12</option>';
            schdHtml +=	 '                  <option value="13">13</option>';
            schdHtml +=  '                  <option value="14">14</option>';
            schdHtml +=  '                  <option value="15">15</option>';
            schdHtml +=  '                  <option value="16">16</option>';
            schdHtml +=  '                  <option value="17">17</option>';
            schdHtml +=  '              </select>';
    		schdHtml +=	 '              <select id="endMin">';
    		schdHtml +=  '                  <option value="">분</option>';
    		schdHtml +=  '                  <option value="00">00</option>';
    		schdHtml +=  '                  <option value="05">05</option>';
    		schdHtml +=  '                  <option value="10">10</option>';
    		schdHtml +=  '                  <option value="15">15</option>';
    		schdHtml +=	 '                  <option value="20">20</option>';
    		schdHtml +=  '                  <option value="25">25</option>';
    		schdHtml +=  '                  <option value="30">30</option>';
    		schdHtml +=  '                  <option value="35">35</option>';
    		schdHtml +=  '                  <option value="40">40</option>';
    		schdHtml +=  '                  <option value="45">45</option>';
    		schdHtml +=  '                  <option value="50">50</option>';
    		schdHtml +=  '                  <option value="55">55</option>';
    		schdHtml +=  '              </select>';
            schdHtml +=  '          </td>';
            schdHtml +=  '      </tr>';
            schdHtml +=  '      <tr>';
            schdHtml +=  '          <td>스튜디오</td>';
            schdHtml +=  '          <td>';
            schdHtml +=  '              <label><input type="radio" name="use'+index+'" id="radioStudio1" onclick="fnStdoRadioChange(this)" /> 사용안함</label>';
            schdHtml +=  '              <label><input type="radio" name="use'+index+'" id="radioStudio2" onclick="fnStdoRadioChange(this)" checked/> 사용</label>';
            schdHtml +=  '              <button class="btn-style01"  onclick="fnSeachStdo(this, '+index+')"><span>스튜디오 찾기</span></button> <strong></strong>';
            schdHtml +=  '              <input type="hidden" id="stdoNo'+index+'" name="stdoNo" >';
            schdHtml +=  '          </td>';
            schdHtml +=  '      </tr>';
            schdHtml +=  '      <tr>';
            schdHtml +=  '          <td>MC</td>';
            schdHtml +=  '          <td>';
            schdHtml +=  '              <label><input type="radio" name="appoint'+index+'" id="radioMc1" onclick="fnMcRadioChange(this)" /> 사용안함</label>';
            schdHtml +=  '              <label><input type="radio" name="appoint'+index+'" id="radioMc2" onclick="fnMcRadioChange(this)" checked/> 사용</label>';
            schdHtml +=  '              <button class="btn-style01"  onclick="fnSeachMc(this, '+index+')"><span>MC 찾기</span></button> <strong></strong>';
            schdHtml +=  '              <input type="hidden" id="mcNo'+index+'" name="mcNo" >';
            schdHtml +=  '          </td>';
            schdHtml +=  '      </tr>';
            schdHtml +=  '  </tbody>';

             $("#lectSchdlTbl").append(schdHtml);
    }


    function fnStdoRadioChange(obj){
        if($(obj).parent().parent().find("#radioStudio2").is(":checked")){
            $(obj).parent().parent().find("button").show();
        }else{
            $(obj).parent().parent().find("button").hide();
            $(obj).parent().parent().find("strong").text("");
            $(obj).parent().parent().find('input[name=stdoNo]').val("");
        }
    }

    function fnMcRadioChange(obj){
        if($(obj).parent().parent().find("#radioMc2").is(":checked")){
            $(obj).parent().parent().find("button").show();

        }else{
            $(obj).parent().parent().find("button").hide();
            $(obj).parent().parent().find("strong").text("");
            $(obj).parent().parent().find('input[name=mcNo]').val("");
        }
    }

    /** 확인 버튼 클릭 */
    function saveTimsSchdList() {

        if(!fnValidationInsert()){
            return false;
        }

        if(!confirm("수업일시정보를 저장 하시겠습니까?")) {
            return false;
        }

        var schdList = "";

        $('#lectSchdlTbl').find(".lectMcStdoInfoTable").each(function(idx) {
            var lectDay = $(this).find(".date-input").val();
            var lectStartTime = $(this).find("#startHour").val() + $(this).find("#startMin").val();
            var lectEndTime = $(this).find("#endHour").val() + $(this).find("#endMin").val();
            var stdoNo = $(this).find('input:hidden[name=stdoNo]').val();
            var mcNo = $(this).find('input:hidden[name=mcNo]').val();

            schdList += '<input type="hidden" name="lectSchdInfo[' + idx + '].lectDay" value="' + lectDay +'" >';
            schdList += '<input type="hidden" name="lectSchdInfo[' + idx + '].lectStartTime" value="' + lectStartTime +'" >';
            schdList += '<input type="hidden" name="lectSchdInfo[' + idx + '].lectEndTime" value="' + lectEndTime +'" >';
            schdList += '<input type="hidden" name="lectSchdInfo[' + idx + '].stdoNo" value="' + stdoNo +'" >';
            schdList += '<input type="hidden" name="lectSchdInfo[' + idx + '].mcNo" value="' + mcNo +'" >';
        });

        var maxApplCnt = $('#timsAddApplCnt').val();
        var maxObsvCnt = $('#timsAddObsvCnt').val();
        schdList += '<input type="hidden" name="lectrMbrNo" value="${lectInfo.lectrMbrNo}" >';
        schdList += '<input type="hidden" name="lectSer" value="${lectSer}" >';
        schdList += '<input type="hidden" name="maxApplCnt" value="' + maxApplCnt +'" >';
        schdList += '<input type="hidden" name="maxObsvCnt" value="' + maxObsvCnt +'" >';
        schdList += '<input type="hidden" name="lectTitle" value="${lectInfo.lectTitle}" >';


        $("#addSchdfrm").empty();
        $("#addSchdfrm").append(schdList);

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/mentor/register/ajax.IectureSchdInfoInsert.do',
            data : $("#addSchdfrm").serialize(),
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    loadTimsList();

                }else{
                    alert(rtnData.message);
                }
            }
        });
        fnCleanData();
    }


    function fnSeachStdo(obj, index){
        var $parent = $(obj).parent().parent().parent();

        if( $('#lectDay'+index).val() == '' ||
            $parent.find('#startHour').val() == '' || $parent.find('#startMin').val() == '' ||
            $parent.find('#endHour').val() == '' || $parent.find('#endMin').val() == '')
        {
            alert("학습 날짜 또는 시간을 지정해주세요");
            return false;
        }
        var lectDay = $('#lectDay'+index).val();
        var lectStartTime = $parent.find('#startHour').val() + $parent.find('#startMin').val();
        var lectEndTime = $parent.find('#endHour').val() + $parent.find('#endMin').val();


        var stdoUrl = mentor.contextpath + "/windowPopup/popupStudioSearch.do?lectDay=" + lectDay + "&lectStartTime=" + lectStartTime + "&lectEndTime=" + lectEndTime + "&stdoNo="+$(obj).parent().find('input:hidden[name=stdoNo]').attr("id");
        var popobj = window.open(stdoUrl, 'popupStudioSearch', 'width=720, height=726, menubar=no, status=no, toolbar=no, scrollbars=no');
        popobj.focus();
    }

    function fnSeachMc(obj, index){
        var $parent = $(obj).parent().parent().parent();

        if( $('#lectDay'+index).val() == '' ||
            $parent.find('#startHour').val() == '' || $parent.find('#startMin').val() == '' ||
            $parent.find('#endHour').val() == '' || $parent.find('#endMin').val() == '')
        {
            alert("학습 날짜 또는 시간을 지정해주세요");
            return false;
        }

        var lectDay = $('#lectDay'+index).val();
        var lectStartTime = $parent.find('#startHour').val() + $parent.find('#startMin').val();
        var lectEndTime = $parent.find('#endHour').val() + $parent.find('#endMin').val();

        var mcUrl = mentor.contextpath + "/windowPopup/popupMcSearch.do?lectDay=" + lectDay + "&lectStartTime=" + lectStartTime + "&lectEndTime=" + lectEndTime + "&mcNo="+$(obj).parent().find('input:hidden[name=mcNo]').attr("id");
        var popobj = window.open(mcUrl, 'popupMcSearch', 'width=720, height=726, menubar=no, status=no, toolbar=no, scrollbars=no');
        popobj.focus();
    }


    function unique(list) {
        var result = [];
        $.each(list, function(i, e) {
            if ($.inArray(e, result) == -1) result.push(e);
        });
        return result;
    }

    function fnValidationInsert(){
        var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
        var returnFlag = true;

        var $obj = $('#lectSchdlTbl').find(".lectMcStdoInfoTable");
        var schdLength = $obj.length;
        var i = 0;

        var scheDays = [];

        $(".lectMcStdoInfoTable").find(".date-input").each(function(idx){
             scheDays.push($(this).val());
        });

        if(schdLength == 0)
        {
            alert("수업 회차를 추가해주세요");
            returnFlag = false;
            return false;
        }

        if($('#timsAddApplCnt').val() == "" || $('#timsAddApplCnt').val() < 1 )
        {
            alert("수업 신청 기기수를 입력해주세요");
            returnFlag = false;
            return false;
        }

        if($('#timsAddObsvCnt').val() == "" || $('#timsAddObsvCnt').val() < 0)
        {
            alert("참관 신청 기기수를 입력해주세요");
            returnFlag = false;
            return false;
        }

        $obj.each(function(idx) {

            var $val = $(this).find(".date-input").val();

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
            var startTime =  toTimeObject($(this).find(".date-input").val().replace(regExp, "") +$(this).find("#startHour").val() + $(this).find("#startMin").val());
            var endTime = toTimeObject($(this).find(".date-input").val().replace(regExp, "") +$(this).find("#endHour").val() + $(this).find("#endMin").val());

            var btMs = endTime.getTime() - startTime.getTime() ;
            var btTime = btMs / (1000*60) ;

            if(${lectInfo.lectTargtCd != '101713'}){
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
                var nextStartTime =  toTimeObject($(nextObj).find(".date-input").val().replace(regExp, "") +$(nextObj).find("#startHour").val() + $(nextObj).find("#startMin").val());
                var nextEndTime = toTimeObject($(nextObj).find(".date-input").val().replace(regExp, "") +$(nextObj).find("#endHour").val() + $(nextObj).find("#endMin").val());

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

          if($(this).find('#radioStudio2').is(":checked") && $(this).find("input[name=stdoNo]").val() == ""){
                alert("스튜디오를 지정하세요.");
                returnFlag = false;
                return false;
            }

            if($(this).find('#radioMc2').is(":checked") && $(this).find("input[name=mcNo]").val() == ""){
                alert("MC를 지정하세요.");
                returnFlag = false;
                return false;
            }

            i++;
        });

        return returnFlag;
    }


</script>