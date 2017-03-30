<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<style type="text/css">
input[type=text].warning {
    box-shadow: 0 0 5px red;
}
</style>

<script type="text/javascript">
$().ready(function() {

    var useable = false;

    $('#checkIdDuplForm').submit(function() {
        $('#checkIdDupl').click();
        return false;
    });


    $('#checkIdDuplConfirm').click(function() {
        if (!useable) {
            alert('아이디 중복확인하세요.');
            return false;
        }
        opener && opener.$('input[name="id"]').val($('#checkIdDuplValue').val());
        self.close();
    });


    $('.pop-close').click(function(e) {
        self.close();
    });


    $('#checkIdDuplValue').change(function() {
        useable = false;
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
                    $('#checkIdDuplValue').toggleClass('warning', !(useable = true));
                    alert('사용가능한 아이디 입니다.');
                }
                else {
                    $('#checkIdDuplValue').toggleClass('warning', !(useable = false));
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
<div class="layer-pop-wrap" id="layPopupIdDuplChk" style="display: block;">
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
                    <a href="#" class="btn-type2" id="checkIdDuplConfirm">확인</a>
                </div>
            </div>
        </form>
    </div>
</div>