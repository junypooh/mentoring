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
		            <td>${username}(${posCoNm})</td>
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

    var cnclDataSet = {
        params: {
            lectSer: $("#lectSer").val(),
            lectTims: '',
            lectureCnt: '',
            lectCnclRsnSust : ''
        }
    };

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


/*
        var $input = $("#lectCnclRsnSust");
        var $count = $('#result', this);

        var maximumByte = 200;
        // update 함수는 keyup, paste, input 이벤트에서 호출한다.
        var update = function () {
            var str_len = $input.val().length;
            var cbyte = 0;
            var li_len = 0;
            for (i = 0; i < str_len; i++) {
                var ls_one_char = $input.val().charAt(i);
                if (escape(ls_one_char).length > 4) {
                    cbyte += 2; //한글이면 2를 더한다
                } else {
                    cbyte++; //한글아니면 1을 다한다
                }
                if (cbyte <= maximumByte) {
                    li_len = i + 1;
                }
            }
            // 사용자가 입력한 값이 제한 값을 초과하는지를 검사한다.
            if (parseInt(cbyte) > parseInt(maximumByte)) {
                alert('허용된 글자수가 초과되었습니다.\r\n\n초과된 부분은 자동으로 삭제됩니다.');
                var str = $input.val();
                var str2 = $input.val().substr(0, li_len);
                $input.val(str2);
                var cbyte = 0;
                for (i = 0; i < $input.val().length; i++) {
                    var ls_one_char = $input.val().charAt(i);
                    if (escape(ls_one_char).length > 4) {
                        cbyte += 2; //한글이면 2를 더한다
                    } else {
                        cbyte++; //한글아니면 1을 다한다
                    }
                }
            }
            $count.text(cbyte);
        };
        // input, keyup, paste 이벤트와 update 함수를 바인드한다
        $input.bind('input keyup keydown paste change', function () {
            setTimeout(update, 0)
        });
        update();
*/

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
        cnclDataSet.params.lectCnclRsnSust = $("#lectCnclRsnSust").val();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.cnclLect.do",
            data : $.param(cnclDataSet.params, true),
            method:"post",
            success: function(rtnData) {
            console.log(rtnData);
                if(rtnData.success == true){
                    alert(rtnData.data);

                    loadTimsList();
                    closePop();

                }else{
                    alert(rtnData.message);

                }
            }
        });
    }

    function cnclLectInit(lectTims, lectureCnt){
        $("#lectCnclRsnSust").val("");
        $("#result").text("0");
        cnclDataSet.params.lectTims = lectTims;
        cnclDataSet.params.lectureCnt = lectureCnt;
    }

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('.popup-area').css({'display': 'none'});
         $('body').removeClass('dim');
    }


</script>