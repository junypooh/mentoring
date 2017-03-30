<%@ page contentType="text/html; charset=UTF-8" %>

<script type="text/javascript">
var callback = '${not empty param.callback ? param.callback : "insertJobConfirm"}';

function initInsertJobLayer(cd, lv1Nm, lv2Nm, lv3Nm) {
    $('#saveJobForm input[name="jobClsfCd"]').val(cd);
    $('#jobLv3Show').text(lv1Nm);
    $('#jobLv2Show').text(lv2Nm);
    $('#jobLv1Show').text(lv3Nm);
}

$().ready(function() {

    $('#saveJobButton').click(function() {
        var $form = $('#saveJobForm');

        if (!$form.find('[name="jobNm"]').val()) {
            alert('직업명을 입력하세요.');
            return false;
        }
        if (!$form.find('[name="jobDefNm"]').val()) {
            alert('직업 한 줄 소개를 입력하세요.');
            return false;
        }
        if (!$form.find('[name="coreAblInfo"]').val()) {
            alert('핵심능력을 입력하세요.');
            return false;
        }
        if (!$form.find('[name="assoSchDeptInfo"]').val()) {
            alert('관련학과를 입력하세요.');
            return false;
        }
        if (!$form.find('[name="assoCualfInfo"]').val()) {
            alert('관련자격을 입력하세요.');
            return false;
        }
        if (!$form.find('[name="smlrJobNm"]').val()) {
            alert('유사직업을 입력하세요.');
            return false;
        }
        if (!$form.find('[name="jobIntdcInfo"]').val()) {
            alert('하는 일을 입력하세요.');
            return false;
        }

        $.ajax($('#saveJobForm')[0].action, {
            type: 'post',
            data: $('#saveJobForm').serialize(),
            success: function(jsonData) {
                if (!jsonData.success) {
                    return alert(jsonData.message);
                }

                if(jsonData.data != null && jsonData.data.length > 0){
                    alert('기존 등록된 직업명이 있습니다.\n 화면에서 기등록 직업선택하세요.');
                    if (callback) {
                        eval(callback).call(jsonData.data);
                    }
                    $('#saveJobForm')[0].reset();
                    $('#jobRegPop .pop-close').click();
                }else{
                    alert('등록되었습니다.');
                    if (callback) {
                        eval(callback).call(null);
                    }
                    $('#saveJobForm')[0].reset();
                    $('#jobRegPop .pop-close').click();
                }
            },
            async: false,
            cache: false,
        });

        return false;
    });
});
</script>

<!-- 직업등록 팝업 -->
<div class="layer-pop-wrap" id="jobRegPop">
    <div class="title">
        <strong>직업 등록</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>

    <form id="saveJobForm" action="${pageContext.request.contextPath}/ajax.saveJobInfo.do" method="post">
        <input type="hidden" name="jobClsfCd" />
        <div class="cont board">
            <div class="mentor-member-signin job-reg">
                <table>
                    <caption>멘토회원 등록 폼 - 아이디, 비밀번호, 비밀번호 확인, 이름, 이메일</caption>
                    <colgroup>
                        <col style="width:135px">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">직업분류</th>
                            <td class="job-group">
                                <span id="jobLv1Show">1차분류</span>
                                <span id="jobLv2Show">2차분류</span>
                                <span id="jobLv3Show">3차분류</span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">직업명</th>
                            <td><input type="text" style="width:200px;" class="inp-style1" maxlength="50" name="jobNm" /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">직업 한 줄 소개</th>
                            <td><input type="text" style="width:200px;" class="inp-style1" maxlength="2500" name="jobDefNm" /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">핵심능력</th>
                            <td><input type="text" style="width:200px;" class="inp-style1" maxlength="500" name="coreAblInfo" /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">관련학과</th>
                            <td><input type="text" style="width:200px;" class="inp-style1" maxlength="500" name="assoSchDeptInfo" /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">관련자격</th>
                            <td><input type="text" style="width:200px;" class="inp-style1" maxlength="500" name="assoCualfInfo" /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">유사직업</th>
                            <td><input type="text" style="width:200px;" class="inp-style1" maxlength="500" name="smlrJobNm" /></td>
                        </tr>
                        <tr>
                            <th scope="row" class="must">하는 일</th>
                            <td><textarea name="jobIntdcInfo" rows="" class="textarea" cols="" maxlength="500"></textarea></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="btn-area">
                <a href="#" class="btn-type2" id="saveJobButton">확인</a>
                <a href="#" class="btn-type2 gray">취소</a>
            </div>
        </div>
    </form>
</div>