<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<!-- Popup -->
<div class="popup-area mc-studio" id="_applCntMcStdoUpdatePopup" style="display:none;">
    <div class="pop-title-box">
		<p class="pop-title">수업일시 수정</p>
	</div>
	<div class="pop-cont-box">
<c:if test="${lectInfo.lectTypeCd eq '101530' }">
		<div class="board-bot">
			<p class="bullet-gray fl-l">연강 단위 <span class="orange-txt" id="lectSchdSeq"></span></p>
		</div>
</c:if>
		<table class="tbl-style">
			<colgroup>
				<col style="width:50px;">
				<col style="width:80px;">
				<col>
			</colgroup>
			    <tbody id="lectApplCntMcStdoTbl"></tbody>
		</table>
	</div>
    <div class="pop-cont-box">
        <table class="tbl-style">
			<colgroup>
				<col style="width:50px;">
				<col style="width:80px;">
				<col>
			</colgroup>
            <tr>
    			<th scope="col" class="ta-l">수업 신청 기기</th>
				<td>
	    			<input type="text" class="text ta-r" id="updateApplCnt" name="updateApplCnt" maxlength="3" /><span> 대</span>
				</td>
			</tr>
			<tr>
				<th scope="col" class="ta-l">참관 신청 기기</th>
				<td>
					<input type="text" class="text ta-r" id="updateObsvCnt" name="updateObsvCnt" maxlength="3"/><span> 대</span>
				</td>
			</tr>
		</table>
		<div class="btn-group-c" id="updateTimsBtn">
			<button type="button" class="btn-orange" id="doneUpdatePop"><span class="search">저장</span></button>
			<button type="button" class="btn-gray" id="cnclUpdatePopUp"><span class="search">취소</span></button>
		</div>
    </div>
    <a href="javascript:void(0)" id="closeUpdatePopup" class="btn-close-pop">닫기</a>
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
                {{if '101543,101548'.indexOf(lectStatCd) >=0  }}
                <label>
                    <input type="radio" name="useStdo\${schdSeq}" id="rdoStudio1" onclick="fnStdoRdoChange(this)" {{if stdoNm == null}}checked{{/if}} /> 사용안함
                </label>
                <label>
                    <input type="radio" name="useStdo\${schdSeq}" id="rdoStudio2" onclick="fnStdoRdoChange(this)" {{if stdoNm != null}}checked{{/if}}/> 사용
                </label>
                <button class="btn-style01"  onclick="fnGetStdo(this, '\${lectDay}', '\${lectStartTime}', '\${lectEndTime}')"><span>스튜디오 찾기</span></button> <strong>\${stdoNm}</strong>
                <input type="hidden" name="stdoNo" id="stdNo\${schdSeq}"  value="\${stdoNo}"/>
                <input type="hidden" name="lectSer" id="lectSer\${schdSeq}" value="\${lectSer}"/>
                <input type="hidden" name="lectTims" id="lectTims\${schdSeq}" value="\${lectTims}"/>
                <input type="hidden" name="schdSeq" id="schdSeq\${schdSeq}" value="\${schdSeq}"/>
                {{else}}
                    <strong>{{if mcNm == null}}지정안함{{else}}\${stdoNm}{{/if}}</strong>
                {{/if}}
            </td>
        </tr>
        <tr>
            <td>MC</td>
            <td class="mcList">
                {{if '101543,101548'.indexOf(lectStatCd) >=0  }}
                <label>
                    <input type="radio" name="appointMc\${schdSeq}" id="rdoMc1" onclick="fnMcRdoChange(this)" {{if mcNm == null}}checked{{/if}} /> 지정안함
                </label>
                <label>
                    <input type="radio" name="appointMc\${schdSeq}" id="rdoMc2" onclick="fnMcRdoChange(this)"  {{if mcNm != null}}checked{{/if}} /> 직접 지정
                </label>
                <button class="btn-style01"  onclick="fnGetMc(this, '\${lectDay}', '\${lectStartTime}', '\${lectEndTime}')"><span>MC 찾기</span></button> <strong>\${mcNm}</strong>
                <input type="hidden" id="mcNo\${schdSeq}" name="mcNo" value="\${mcNo}">
                {{else}}
                    <strong>{{if mcNm == null}}지정안함{{else}}\${mcNm}{{/if}}</strong>
                {{/if}}
            </td>
        </tr>
    {{/each}}


</script>


<script type="text/javascript">

    $(document).ready(function() {

        $("#updateApplCnt").keyup(function() {
            $(this).val( $(this).val().replace(/[^0-9]/gi,"") );
        });

        $("#updateObsvCnt").keyup(function() {
            $(this).val( $(this).val().replace(/[^0-9]/gi,"") );
        });

        $("#closeUpdatePopup").click(function(){
            closeUpdatePop();
        });

        $("#cnclUpdatePopUp").click(function(){
            closeUpdatePop();
        });

        $("#doneUpdatePop").click(function(){
            updateMcStdo();
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closeUpdatePop();
            }
        });

    });

    function getTimsUpdateInfo(lectSer, lectTims){

        var timsDataSet = {
            params: {
                lectSer: lectSer,
                lectTims: lectTims,
            }
        };
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/mentor/status/ajax.view.do',
            data : $.param(timsDataSet.params, true),
            success: function(rtnData) {
                timsDataSet.data = rtnData;

                if(rtnData.lectStatCd != "101543" && rtnData.lectStatCd != "101548"){
                    $('#updateTimsBtn').hide();
                    $('#updateApplCnt').attr("readonly", true);
                    $('#updateObsvCnt').attr("readonly", true);
                }else{
                    $('#updateTimsBtn').show();
                    $('#updateApplCnt').attr("readonly", false);
                    $('#updateObsvCnt').attr("readonly", false);

                }


                $('#lectureCnt').val(rtnData.lectureCnt);
                $('#lectStatCd').val(rtnData.lectStatCd);

                $('#updateApplCnt').val(rtnData.maxApplCnt);
                $('#updateObsvCnt').val(rtnData.maxObsvCnt);

                //MC/스튜디오 수정팝업
                $('#lectApplCntMcStdoTbl').empty();
                $('#lectMcStdoInfo').tmpl(timsDataSet.data).appendTo('#lectApplCntMcStdoTbl');
                $("#lectSchdSeq").text('총' + timsDataSet.data.lectSchdInfo.length + '회차');

            }
        });
    }


    function fnStdoRdoChange(obj){
        if($(obj).parent().parent().find("#rdoStudio2").is(":checked")){
            $(obj).parent().parent().find("button").show();
        }else{
            $(obj).parent().parent().find("button").hide();
            $(obj).parent().parent().find("strong").text("");
            $(obj).parent().parent().find('input[name=stdoNo]').val("");
        }
    }

    function fnMcRdoChange(obj){
        if($(obj).parent().parent().find("#rdoMc2").is(":checked")){
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
            if($(this).find('#rdoStudio2').is(":checked") && $(this).find('input[name=stdoNo]').val() == ""){
                alert("스튜디오를 지정하세요.");
                returnFlag = false;
                return false;
            }
        });

        if(!returnFlag){
            return false;
        }
        $(".mcList").each(function() {
            if($(this).find('#rdoMc2').is(":checked") && $(this).find('input[name=mcNo]').val() == ""){
                alert("MC를 지정하세요.");
                returnFlag = false;
                return false;
            }
        });

        if(!returnFlag){
            return false;
        }

        if($('#updateApplCnt').val() == "" || $('#updateApplCnt').val() < 1)
        {
            alert("수업 신청 기기수를 입력해주세요");
            returnFlag = false;
            return false;
        }

        if($('#updateObsvCnt').val() == "" || $('#updateObsvCnt').val() < 0)
        {
            alert("참관 신청 기기수를 입력해주세요");
            returnFlag = false;
            return false;
        }

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

            stdoList += '<input type="text" name="lectSchdInfo[' + idx + '].stdoNo" value="' + stdoNo +'" >';
            stdoList += '<input type="text" name="lectSchdInfo[' + idx + '].lectSer" value="' + lectSer +'" >';
            stdoList += '<input type="text" name="lectSchdInfo[' + idx + '].lectTims" value="' + lectTims +'" >';
            stdoList += '<input type="text" name="lectSchdInfo[' + idx + '].schdSeq" value="' + schdSeq +'" >';

        });
        var maxApplCnt = $('#updateApplCnt').val();
        var maxObsvCnt = $('#updateObsvCnt').val();

        stdoList += '<input type="hidden" name="maxApplCnt" value="' + maxApplCnt +'" >';
        stdoList += '<input type="hidden" name="maxObsvCnt" value="' + maxObsvCnt +'" >';

        var mcList = "";
        $(".mcList").each(function(idx) {
            var mcNo = $(this).find('input:hidden[name=mcNo]').val();
            mcList = mcList + '<input text="hidden" name="lectSchdInfo[' + idx + '].mcNo" value="' + mcNo +'" >';
        });

        $("#mcStdofrm").append(stdoList);
        $("#mcStdofrm").append(mcList);

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/mentor/status/ajax.lectUpdateMcStdo.do',
            data : $("#mcStdofrm").serialize(),
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    closeUpdatePop();
                    loadTimsList();
                }else{
                    alert(rtnData.message);
                }
            }
        });
        $("#mcStdofrm").empty();
    }

    /** 취소/닫기 버튼 클릭 */
    function closeUpdatePop() {
        $('.popup-area').css({'display': 'none'});
         $('body').removeClass('dim');
    }

    function fnGetStdo(obj,lectDay, lectStartTime, lectEndTime){
        var stdoUrl = mentor.contextpath + "/windowPopup/popupStudioSearch.do?lectDay=" + lectDay + "&lectStartTime=" + lectStartTime + "&lectEndTime=" + lectEndTime + "&stdoNo="+$(obj).parent().find('input:hidden[name=stdoNo]').attr("id");
        var popobj = window.open(stdoUrl, 'popupStudioSearch', 'width=720, height=726, menubar=no, status=no, toolbar=no, scrollbars=no');
        popobj.focus();
    }

    function fnGetMc(obj, lectDay, lectStartTime, lectEndTime){
        var mcUrl = mentor.contextpath + "/windowPopup/popupMcSearch.do?lectDay=" + lectDay + "&lectStartTime=" + lectStartTime + "&lectEndTime=" + lectEndTime + "&mcNo="+$(obj).parent().find('input:hidden[name=mcNo]').attr("id");
        var popobj = window.open(mcUrl, 'popupMcSearch', 'width=720, height=726, menubar=no, status=no, toolbar=no, scrollbars=no');
        popobj.focus();
    }


</script>