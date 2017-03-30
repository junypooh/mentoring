<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<script type="text/javascript">
$().ready(function() {

    $('#checkIdDuplForm').submit(function() {
        $('#checkIdDupl').click();
        return false;
    });

    $('#checkIdDupl').click(function(e) {
        e.preventDefault();

        if (!$('#checkIdDuplValue').val()) {
            alert('중복검사 할 아이디를 입력해주세요.');
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/join/ajax.checkIdDupl.do',
            data : {'id':$('#checkIdDuplValue').val()},
            contentType: 'application/json',
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                if (rtnData.success === 'true') {
                    $('input[name="id"]').val($('#checkIdDuplValue').val());
                    $('#checkIdDuplForm')[0].reset();
                    $('#layPopupIdDuplChk .pop-close').click();
                }
                else {
                    alert(rtnData.message);
                }
            }.bind(this),
            error: function(xhr, status, err) {
            }.bind(this)
        });
    });
});
</script>

<!-- 아이디 중복 검사 레이어 -->
<div class="layer-pop-wrap" id="layPopupIdDuplChk">
    <div class="layer-pop class">
        <div class="title">
            <strong>아이디 중복확인</strong>
            <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
        </div>
        <form id="checkIdDuplForm" action="${pageContext.request.contextPath}/join/ajax.checkIdDupl.do" onsubmit="return false;">
            <div class="cont">
                <div class="id-overlap">
                    <input type="text" class="inp-style1" style="width:249px;" id="checkIdDuplValue" placeholder="아이디를 입력해주세요." title="아이디" maxlength="12"/>
                    <a href="#"  class="btn-type1 search" id="checkIdDupl">아이디 중복확인</a>
                </div>
                <p class="id-overlap-txt">* 5자리 ~ 12자리 영문, 숫자만 가능합니다.</p>
                <div class="btn-area">
                    <a href="#" class="btn-type2 pop-close layer-close" id="checkIdDupl">확인</a>
                </div>
            </div>
        </form>
    </div>
</div>