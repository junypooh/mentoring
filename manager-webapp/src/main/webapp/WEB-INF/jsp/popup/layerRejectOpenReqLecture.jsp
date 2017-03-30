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
<div class="popup-area lesson-cancel" id="_rejectOpenReqLecturePopup" style="display:none;">
	<div class="pop-title-box">
		<p class="pop-title">수업개설신청 처리</p>
	</div>
	<div class="pop-cont-box">
		<table class="tbl-style">
			<colgroup>
				<col style="width:100px;">
			</colgroup>
			<tbody>
                <tr>
                    <th scope="col" class="ta-l">승인상태</th>
                    <td >반려</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">처리자</th>
                    <td>${username}(${posCoNm})</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">사유</th>
                    <td class="textarea-wrap">
                        <textarea cols="30" rows="10" class="textarea" id="procSust" placeholder="* 반려 사유를 자세하게 입력하세요."></textarea>
                        <p class="over-hidden"><span class="fl-r"><strong id="result" class="red-txt">0</strong> / 200자</span></p>
                    </td>
                </tr>
			</tbody>
		</table>
		<div class="btn-group-c">
			<button type="button" class="btn-orange" onclick="fn_rejectLect();"><span class="search">저장</span></button>
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

        $("#procSust").bind('change keydown keyup blur', function() {
            var maximumLength = 200;
            var $input = $("#procSust");

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

    // 수업개설신청 반려
    function fn_rejectLect() {
        if($("#procSust").val() == '') {
            alert('반려사유를 입력해주세요');
            return;
        }

        if(!confirm("반려 하시겠습니까?")) {
            return false;
        }

        var rejectDataSet = {
            params: {
                reqSer: $("#reqSer").val(),
                authStatCd : '101028',
                procSust : $("#procSust").val()
            }
        };

        $.ajax({
            url: "ajax.edit.do",
            data : $.param(rejectDataSet.params, true),
            method:"post",
            success: function(rtnData) {
            console.log(rtnData);
                if(rtnData.success == true){
                    alert(rtnData.data);
                    closePop();
                    location.href = '${pageContext.request.contextPath}/lecture/mentor/openreq/view.do?reqSer=' +  $('#reqSer').val();
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