<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />

<script type="text/javascript">
var callback = '${not empty param.callback ? param.callback : "insertMentorConfirm"}';

$().ready(function() {

    $('a.pop-open').click(function(e) {
        window.open(this.href, 'popupIdDuplChk', 'width=640, height=368, menubar=no, status=no, toolbar=no');
        return false;
    });


    $('[name="id"]').click(function() {
        $(this).next('a').click();
    });


    $('#domain-choice').change(function(e) {
        !(this.value) ? $('#email-domain').show()
                : $('#email-domain').hide();
        $('#email-domain').val(this.value);
    }).change();


    // 비밀번호 비교
    $('#chkPwd').change(function (e) {
        $(this).bind('keyup', function() {
                ($('input[name="password"]').val() && $('#chkPwd').val() != $('input[name="password"]').val())
                        ? $('#chkPwdDisp').show()
                        : $('#chkPwdDisp').hide();
                return arguments.callee;
            }()).unbind('change');
    });



    $('#insert-confirm, #insert-add-confirm').click(function() {
        if (!$('input[name="id"]').val()) {
            alert('아이디 종복 확인 하세요.');
            return false;
        }
        if (!$('input[name="password"]').val()) {
            alert('비밀번호를 입력하세요');
            return false;
        }
        if ($('input[name="password"]').val() !== $('#chkPwd').val()) {
            alert('비밀번호를 확인하세요');
            return false;
        }
        if (!$('input[name="username"]').val()) {
            alert('이름을 입력하세요.');
            return false;
        }
        if (!$('#email-id').val() || !$('#email-domain').val()) {
            alert('이메일을 입력하세요.');
            return false;
        }
        $('#email-addr').val($.map($('#email-id, #email-domain'), function(o) { return o.value; }).join('@'));

        var target = this;
        $.ajax($('#belongMentorInsertForm').attr('action'), {
            type: 'post',
            data: $('#belongMentorInsertForm').serialize(),
            success: function(jsonData) {
                if (!!!jsonData.success) {
                    alert(jsonData.message);
                    return;
                }

                alert(jsonData.data);
                if (callback) {
                    eval(callback).call(null);
                }

                $('#belongMentorInsertForm')[0].reset();
                $('#domain-choice').change();
                $("span.mgl-15 label.radio-skin").eq(0).addClass("checked")
                $("span.mgl-15 label.radio-skin").eq(1).removeClass("checked")
                if (target.id === 'insert-confirm') {
                    $('#insertMentorLayer .pop-close').click();
                }
                else {
                    alert('회원 등록이 완료되었습니다.\n회원을  추가로 등록하시겠습니까?');
                }
            },
            cache:false,
            async: false,
        });
    });
});
</script>

<!-- 멘토 회원등록 레이어 -->
<div class="layer-pop-wrap w720" id="insertMentorLayer">
    <div class="title">
        <strong>멘토회원 등록</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont board">
        <form id="belongMentorInsertForm" action="${pageContext.request.contextPath}/mentor/belongMentor/ajax.belongMentorInsert.do">
            <div class="mentor-mem-reg">
                <div class="board-input-type all-view">
                    <table>
                        <caption>가입정보 입력 - 아이디, 비밀번호, 비밀번호 확인, 비밀번호찾기 질문, 이름, 생년월일, 이메일 주소, 이메일수신</caption>
                        <colgroup>
                            <col style="width:135px;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="compulsory">아이디</th>
                                <td>
                                    <input type="text" class="inp-style1" style="width:120px;" name="id" readonly="readonly" maxlength="12" />
                                    <a href="${pageContext.request.contextPath}/layer/popupIdDuplChk.do" class="btn-type1 pop-open">아이디 중복확인</a>
                                    <span class="refer">* 5자리 ~ 12자리 영문, 숫자 및 기호 '_', '-' 만 가능합니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">비밀번호</th>
                                <td>
                                    <input type="password" class="inp-style1" style="width:120px;" name="password" maxlength="20" />
                                    <span class="refer">* 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">비밀번호 확인</th>
                                <td>
                                    <input type="password" class="inp-style1" style="width:120px;" id="chkPwd" maxlength="20" />
                                    <span class="layer" id="chkPwdDisp" style="display: none;">비밀번호가 일치하지 않습니다.</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">이름</th>
                                <td>
                                    <input type="text" class="inp-style1" style="width:120px;" name="username" maxlength="10" />
                                    <span class="mgl-15">
                                        <label class="radio-skin checked"><input type="radio" name="genCd" value="${code['CD100322_100323_남자']}" class="radio-skin" checked="checked" />남자</label>
                                        <label class="radio-skin"><input type="radio" name="genCd" value="${code['CD100322_100324_여자']}" class="radio-skin" />여자</label>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">이메일</th>
                                <td>
                                    <input type="hidden" name="emailAddr" id="email-addr" />
                                    <input type="text" class="inp-style1" style="width:120px;" maxlength="50" id="email-id" />
                                    @
                                    <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD100423_100533_이메일'])" var="emailCodes" />
                                    <select style="width:160px;" id="domain-choice">
                                        <option value="">직접입력</option>
                                        <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                            <option value="${eachObj.cdNm}">${eachObj.cdNm}</option>
                                        </c:forEach>
                                    </select>
                                    <input type="text" title="이메일 도메인 직접 입력" class="inp-style2" style="width:180px;" id="email-domain" maxlength="50" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="btn-area">
                    <a href="#" class="btn-type2" id="insert-confirm">확인</a>
                    <a href="#" class="btn-type2 gray">취소</a>
                    <span class="right"><a href="#" class="btn-type1" id="insert-add-confirm">멘토등록추가</a></span>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- //멘토 회원등록 -->

