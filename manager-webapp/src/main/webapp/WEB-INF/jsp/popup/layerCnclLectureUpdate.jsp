<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<security:authorize access="isAuthenticated()">
	<security:authentication var="id" property="principal.id" />
	<security:authentication var="username" property="principal.username" />
	<security:authentication var="posCoNm" property="principal.posCoNm" />
</security:authorize>

<!-- Popup -->
<div class="popup-area lesson-cancel" id="_cnclLecturePopup" style="display:none;">
	<div class="pop-title-box">
		<p class="pop-title">수업 수동 취소</p>
	</div>
	<div class="pop-cont-box">
		<table class="tbl-style">
			<colgroup>
				<col style="width:100px;">
			</colgroup>
			<tbody id="lectCnclLectInfoTable">
                <tr>
                    <th scope="col" class="ta-l">취소자</th>
                    <td id="cnclMbrNm"></td>
                </tr>
                <tr id="cnclDtmTr">
                        <th scope="col" class="ta-l">수동취소일</th>
                        <td id="cnclDtmTd"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">사유</th>
                    <td class="textarea-wrap">
                        <textarea cols="30" rows="10" class="textarea" id="lectCnclRsnSust" placeholder="* 취소 사유를 자세하게 입력하세요."></textarea>
                        <p class="over-hidden"><span class="fl-r"><strong id="result" class="red-txt">0</strong> / 200자</span></p>
                    </td>
                </tr>
			</tbody>
		</table>
		<div class="btn-group-c">
			<button type="button" class="btn-orange" onclick="on_submit();"><span class="search">저장</span></button>
			<button type="button" class="btn-gray" id="cnclStatusPopUp"><span class="search">취소</span></button>
		</div>
	</div>
    <a href="javascript:void(0)" id="closeCnclPopup" class="btn-close-pop">닫기</a>
</div>


<script type="text/javascript">

    $(document).ready(function() {

        $("#closeCnclPopup").click(function(){
            closePop();
        });

        $("#cnclStatusPopUp").click(function(){
            closePop();
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closePop();
            }
        });

        $("#lectCnclRsnSust").bind('change keydown keyup blur', function() {
            var maximumLength = 200;
            var $input = $("#lectCnclRsnSust");

            fnMaxLengthChk($input, maximumLength);
        });


    });

   function fnMaxLengthChk($input, maximumLength){
        if($input.val().length > maximumLength){
            alert('허용된 글자수가 초과되었습니다.\r\n\n초과된 부분은 자동으로 삭제됩니다.');
            var str = $input.val().substr(0, maximumLength);
            $input.val(str);
        }
        stringByteLength = $input.val().length;
        $input.parent().find('span').find('strong').text(stringByteLength);
    }

    /** 확인 버튼 클릭 */
    function on_submit() {
        if($("#lectCnclRsnSust").val() == '') {
            alert('취소사유를 입력해주세요');
            return;
        }

        if(!confirm("수정 하시겠습니까?")) {
            return false;
        }

        var cnclDataSet = {
            params: {
                lectSer: $("#lectSer").val(),
                lectTims: $("#lectTims").val(),
                lectureCnt: $("#lectureCnt").val(),
                lectCnclRsnSust : $("#lectCnclRsnSust").val()
            }
        };

        var updateUrl = "ajax.cnclLect.do"

        if($('#lectStatCd').val() == '101547'){
            updateUrl = "ajax.cnclRsnUpdate.do";
        }

        $.ajax({
            url: updateUrl,
            data : $.param(cnclDataSet.params, true),
            method:"post",
            success: function(rtnData) {
            console.log(rtnData);
                if(rtnData.success == true){
                    alert(rtnData.data);
                    $('#applReqBtn').attr("class", "btn-style01 default fl-r");
                    $('#obsvReqBtn').attr("class", "btn-style01 default fl-r");
                    getTimsSchdInfo();
                    loadApplList("101715");
                    loadApplList("101716");
                    closePop();

                }else{
                    alert(rtnData.message);

                }
            }
        });
    }

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('.popup-area').css({'display': 'none'});
         $('body').removeClass('dim');
    }


</script>