<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<!-- Popup -->
<div class="popup-area mc-studio" id="_mcStdoPopup" style="display:none;">
    <div class="pop-title-box">
		<p class="pop-title">MC 및 스튜디오 수정</p>
	</div>
	<div class="pop-cont-box">
		<div class="board-bot">
			<p class="bullet-gray fl-l">연강 단위 <span class="orange-txt" id="lectSchdSeq"></span></p>
		</div>
		<table class="tbl-style">
			<colgroup>
				<col style="width:50px;">
				<col style="width:80px;">
				<col>
			</colgroup>
			    <tbody id="lectMcStdoInfoTable"></tbody>
		</table>
		<div class="btn-group-c">
			<button type="button" class="btn-orange" id="donePop"><span class="search">저장</span></button>
			<button type="button" class="btn-gray" id="cnclPopUp"><span class="search">취소</span></button>
		</div>
	</div>
    <a href="javascript:void(0)" id="closePopup" class="btn-close-pop">닫기</a>
</div>
<form name="mcStdofrm" id="mcStdofrm"  method="post" >
</form>
<!-- Popup[E] -->

<script type="text/html" id="lectMcStdoInfo">
    {{each lectSchdInfo}}
        <tr>
            <th scope="col" rowspan="3">\${schdSeq}회차</th>
                <td>수업일시</td>
                <td>\${lectDay}  \${lectStartTime} ~ \${lectEndTime} (\${lectRunTime}분)</td>
        </tr>
        <tr>
            <td>스튜디오</td>
            <td class="stdoList">
                <label>
                    <input type="radio" name="use\${schdSeq}" id="radioStudio1" onclick="fnStdoRadioChange(this)" /> 사용안함
                </label>
                <label>
                    <input type="radio" name="use\${schdSeq}" id="radioStudio2" onclick="fnStdoRadioChange(this)" checked/> 사용
                </label>
                <button class="btn-style01"  onclick="fnSeachStdo(this, '\${lectDay}', '\${lectStartTime}', '\${lectEndTime}')"><span>스튜디오 찾기</span></button> <strong>\${stdoNm}</strong>
                <input type="hidden" name="stdoNo" id="stdNo\${schdSeq}"  value="\${stdoNo}"/>
                <input type="hidden" name="lectSer" id="lectSer\${schdSeq}" value="\${lectSer}"/>
                <input type="hidden" name="lectTims" id="lectTims\${schdSeq}" value="\${lectTims}"/>
                <input type="hidden" name="schdSeq" id="schdSeq\${schdSeq}" value="\${schdSeq}"/>
            </td>
        </tr>
        <tr>
            <td>MC</td>
            <td class="mcList">
                <label>
                    <input type="radio" name="appoint\${schdSeq}" id="radioMc1" onclick="fnMcRadioChange(this)" /> 지정안함
                </label>
                <label>
                    <input type="radio" name="appoint\${schdSeq}" id="radioMc2" onclick="fnMcRadioChange(this)" checked /> 직접 지정
                </label>
                <button class="btn-style01"  onclick="fnSeachMc(this, '\${lectDay}', '\${lectStartTime}', '\${lectEndTime}')"><span>MC 찾기</span></button> <strong>\${mcNm}</strong>
                <input type="hidden" id="mcNo\${schdSeq}" name="mcNo" value="\${mcNo}">
            </td>
        </tr>
    {{/each}}


</script>


<script type="text/javascript">

    $(document).ready(function() {

        $("#closePopup").click(function(){
            closePop();
        });

        $("#cnclPopUp").click(function(){
            closePop();
        });

        $("#donePop").click(function(){
            updateMcStdo();
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closePop();
            }
        });

    });


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
    function updateMcStdo() {

        var returnFlag = true;
        $(".stdoList").each(function() {
            if($(this).find('#radioStudio2').is(":checked") && $(this).find('input[name=stdoNo]').val() == ""){
                alert("스튜디오를 지정하세요.");
                returnFlag = false;
                return false;
            }
        });

        if(!returnFlag){
            return false;
        }
        $(".mcList").each(function() {
            if($(this).find('#radioMc2').is(":checked") && $(this).find('input[name=mcNo]').val() == ""){
                alert("MC를 지정하세요.");
                returnFlag = false;
                return false;
            }
        });

        if(!returnFlag){
            return false;
        }

        if(!confirm("수정 하시겠습니까?")) {
            return false;
        }

        var stdoList ="";
        $(".stdoList").each(function(idx) {

            //스튜디오 번호
            var stdoNo = $(this).find('input:hidden[name=stdoNo]').val();
            var lectSer = $(this).find('input:hidden[name=lectSer]').val();
            var lectTims = $(this).find('input:hidden[name=lectTims]').val();
            var schdSeq = $(this).find('input:hidden[name=schdSeq]').val();

            stdoList = stdoList + '<input type="hidden" name="lectSchdInfo[' + idx + '].stdoNo" value="' + stdoNo +'" >';
            stdoList = stdoList + '<input type="hidden" name="lectSchdInfo[' + idx + '].lectSer" value="' + lectSer +'" >';
            stdoList = stdoList + '<input type="hidden" name="lectSchdInfo[' + idx + '].lectTims" value="' + lectTims +'" >';
            stdoList = stdoList + '<input type="hidden" name="lectSchdInfo[' + idx + '].schdSeq" value="' + schdSeq +'" >';

        });

        var mcList = "";
        $(".mcList").each(function(idx) {
            var mcNo = $(this).find('input:hidden[name=mcNo]').val();
            mcList = mcList + '<input type="hidden" name="lectSchdInfo[' + idx + '].mcNo" value="' + mcNo +'" >';
        });

        $("#mcStdofrm").append(stdoList);
        $("#mcStdofrm").append(mcList);

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/mentor/status/ajax.lectUpdateMcStdo.do',
            data : $("#mcStdofrm").serialize(),
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    closePop();
                    getTimsSchdInfo();
                }else{
                    alert(rtnData.data);
                }
            }
        });
        $("#mcStdofrm").empty();
    }

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('.popup-area').css({'display': 'none'});
         $('body').removeClass('dim');
    }

    function fnSeachStdo(obj,lectDay, lectStartTime, lectEndTime){
        var stdoUrl = mentor.contextpath + "/windowPopup/popupStudioSearch.do?lectDay=" + lectDay + "&lectStartTime=" + lectStartTime + "&lectEndTime=" + lectEndTime + "&stdoNo="+$(obj).parent().find('input:hidden[name=stdoNo]').attr("id");
        var popobj = window.open(stdoUrl, 'popupStudioSearch', 'width=720, height=726, menubar=no, status=no, toolbar=no, scrollbars=no');
        popobj.focus();
    }

    function fnSeachMc(obj, lectDay, lectStartTime, lectEndTime){
        var mcUrl = mentor.contextpath + "/windowPopup/popupMcSearch.do?lectDay=" + lectDay + "&lectStartTime=" + lectStartTime + "&lectEndTime=" + lectEndTime + "&mcNo="+$(obj).parent().find('input:hidden[name=mcNo]').attr("id");
        var popobj = window.open(mcUrl, 'popupMcSearch', 'width=720, height=726, menubar=no, status=no, toolbar=no, scrollbars=no');
        popobj.focus();
    }


</script>