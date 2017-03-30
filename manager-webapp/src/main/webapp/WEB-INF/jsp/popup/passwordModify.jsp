<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<div class="popup-area" id="passWordModifyLayer" style="height:215px;display:none;">
    <div class="pop-title-box">
        <p class="pop-title">비밀번호 변경</p>
    </div>
    <div class="pop-cont-box">
        <%--form:form method="post" id="frm"--%>
        <table class="tbl-style tbl-message">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">기존 비밀번호</th>
                    <td>
                        <input type="password" class="text" id="pw0" name="password" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">새 비밀번호</th>
                    <td>
                        <input type="password" class="text" id="pw1" name="new_password" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">새 비밀번호 확인</th>
                    <td>
                        <input type="password" class="text" id="pw2"> <span class="layer" id="chkPwdDisp" style="display: none;">비밀번호가 일치하지 않습니다.</span>
                    </td>
                </tr>
            </tbody>
        </table>
        <%--/form:form--%>
        <div class="btn-group-c">
            <button type="button" class="btn-orange" onclick="savePw()"><span>저장</span></button>
            <button type="button" class="btn-gray" onclick="hidePassWordModifyLayer()"><span>취소</span></button>
        </div>
    </div>
    <a href="javascript:void(0)" class="btn-close-pop" onclick="hidePassWordModifyLayer()">닫기</a>
</div>
<script type="text/javascript">
    $().ready(function() {
        // 비밀번호 비교
        $('#pw1, #pw2').bind('change', function (e) {
            $(this).bind('keyup', function() {
                    ($('#pw1').val() && $('#pw2').val() && $('#pw2').val() != $('#pw1').val())
                            ? $('#chkPwdDisp').show()
                            : $('#chkPwdDisp').hide();
                    return arguments.callee;
                }()).unbind('change');
        });
    });

    function savePw(){
        if($("#pw0").val() == ""){
            alert("현재 비밀번호를 입력하세요");
            return false;
        }
        if($("#pw1").val() == "" || $("#pw2").val() == "" || $("#pw1").val() != $("#pw2").val()){
            alert("새 비밀번호를 확인해주세요.");
            return false;
        }

        var SamePass_0 = 0; //ID와 3자이상 중복체크

        var chr_pass_0;
        var chr_pass_1;
        var chr_pass_2;

        var chr_id_0;
        var chr_id_1;
        var chr_id_2;

        for(var i=0; i < ($("#pw1").val().length-2); i++) {

            chr_pass_0 = $("#pw1").val().charAt(i);
            chr_pass_1 = $("#pw1").val().charAt(i+1);
            chr_pass_2 = $("#pw1").val().charAt(i+2);

            for(var j=0; j < ('<security:authentication property="principal.id" />'.length-2); j++) {
                chr_id_0 = '<security:authentication property="principal.id" />'.charAt(j);
                chr_id_1 = '<security:authentication property="principal.id" />'.charAt(j+1);
                chr_id_2 = '<security:authentication property="principal.id" />'.charAt(j+2);
                if(chr_pass_0 == chr_id_0 && chr_pass_1 == chr_id_1 && chr_pass_2 == chr_id_2){
                    SamePass_0=1;
                }
            }
        }
        if($("#pw1").val().search(/\s/) != -1){
            alert("비밀번호는 공백없이 입력해주세요.");
            return false;
        }

        if(SamePass_0 >0){
            alert("비밀번호가 ID와 3자이상 중복 되었습니다.");
            return false;
        }

        if(/(\w)\1\1/.test($("#pw1").val())) {
            alert('비밀번호에 같은 문자를 3번 이상 사용하실 수 없습니다.');
            return false;
        }

        var regex = /^.*(?=.{10,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/;
        if(!regex.test($("#pw1").val())){
            alert("비밀번호는 영문, 숫자 또는 특수문자를 포함한 10~20자리가 가능합니다.");
            return false;
        }

        $.ajax({
            url:"${pageContext.request.contextPath}/ajax.pwChange.do",
            data : {'password':$("[name='password']").val(),'new_password':$("[name='new_password']").val()},
            method:"post",
            success: function(rtnData) {
                if(rtnData.success == true){
                    alert("비밀번호가 변경되었습니다.");
                    $('.jqgrid-overlay').hide();
                    $('#passWordModifyLayer').css('display', 'none');
                }else{
                    alert(rtnData.message);

                }
            }
        });
    }

    function hidePassWordModifyLayer() {
        $('.jqgrid-overlay').hide();
        $('#passWordModifyLayer').css('display', 'none');
    }
</script>