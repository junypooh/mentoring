<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>관리자관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>관리자관리</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="mbrNo" value="${param.mbrNo}" />
        <input type="hidden" name="idName" value="${param.idName}" />
        <input type="hidden" name="mbrCualfType" value="${param.mbrCualfType}" />
        <input type="hidden" name="authCd" value="${param.authCd}" />
        <input type="hidden" name="loginPermYn" value="${param.loginPermYn}" />
    </form>
    <form:form modelAttribute="user" id="managerForm">
    <div class="board-area" id="boardArea">
    <input type="hidden" id="mbrNo" name="mbrNo" value="${user.mbrNo}" />
    <input type="hidden" id="posCoNo" name="posCoNo" value="${user.posCoNo}" />
    <input type="hidden" id="mobile" name="mobile" />
    <input type="hidden" id="emailAddr" name="emailAddr" />
        <table class="tbl-style tbl-none-search">
            <colgroup>
                <col style="width:130px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">유형 <span class="red-point">*</span></th>
                    <td>
                        <select id="mbrGradeCd" name="mbrGradeCd">
                            <option value="">유형선택</option>
                            <option value="0">운영관리자</option>
                            <option value="1">그룹관리자</option>
                            <option value="2">교육수행기관</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">관리자권한 <span class="red-point">*</span></th>
                    <td>
                        <select id="mbrCualfCd" name="mbrCualfCd">
                            <option value="">관리자권한선택</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">이름 <span class="red-point">*</span></th>
                    <td>
                        <input type="text" id="username" name="username" class="text" value="${user.username}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">아이디 <span class="red-point">*</span></th>
                    <td>
                        <input type="text" id="id" name="id" class="text" value="${user.id}" <c:if test="${not empty user.mbrNo}">readonly='readonly'</c:if> />
                        <c:if test="${empty user.mbrNo}"><button type="button" class="btn-style01" onclick="checkIdDupl()"><span>중복확인</span></button></c:if>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">비밀번호<c:if test="${empty user.mbrNo}"> <span class="red-point">*</span></c:if></th>
                    <td>
                        <input type="password" id="password" name="password" class="text" />
                        10자 이상의 영문, 숫자, 특수기호 조합
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">소속 <span class="red-point">*</span></th>
                    <td>
                        <input type="text" id="coNm" name="coNm" class="text" value="${user.posCoNm}" />
                        <button type="button" class="btn-style01" id="corpInfoSearch"><span>소속찾기</span></button>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">이메일 <span class="red-point">*</span></th>
                    <td>
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100423_100533_이메일'])" var="emailCodes" />
                        <input type="text" class="text email-address" value="${cnet:splitWithIndex(user.emailAddr, '@', 0)}" />
                        <span>@</span>
                        <select id="email-entry">
                            <option value="">직접입력</option>
                            <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cdNm}"
                                        <c:if test="${cnet:splitWithIndex(user.emailAddr, '@', 1) eq eachObj.cdNm}">selected="selected"</c:if>>${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                        <input type="text" class="text email-address" maxlength="50" value="${cnet:splitWithIndex(user.emailAddr, '@', 1)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">휴대전화</th>
                    <td class="mobile">
                        <spring:eval expression="{'010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                        <select class="mobile-number" title="번호앞자리 선택">
                            <c:forEach items="${dialingCode}" var="eachObj">
                                <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(user.mobile, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                            </c:forEach>
                        </select>
                        -
                        <input type="text" class="text mobile-number" style="width:100px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 1)}" />
                        -
                        <input type="text" class="text mobile-number" style="width:100px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 2)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">유선전화</th>
                    <td>
                        <input type="text" id="tel" name="tel" class="text" value="${user.tel}" />
                    </td>
                </tr>
                <c:if test="${not empty user.mbrNo}">
                <tr>
                    <th scope="col" class="ta-l">등록자</th>
                    <td>${user.regMbrNm}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">변경일</th>
                    <td><c:choose><c:when test="${not empty user.chgDtm}"><fmt:formatDate value="${user.chgDtm}" pattern="yyyy.MM.dd" /></c:when><c:otherwise><fmt:formatDate value="${user.regDtm}" pattern="yyyy.MM.dd" /></c:otherwise></c:choose></td>
                </tr>
                </c:if>
                <tr>
                    <th scope="col" class="ta-l">사용유무 <span class="red-point">*</span></th>
                    <td>
                        <label><input type="radio" name="loginPermYn" <c:if test="${user.loginPermYn eq 'Y'}">checked='checked'</c:if> value="Y" /> 사용중</label>
                        <label><input type="radio" name="loginPermYn" <c:if test="${user.loginPermYn eq 'N'}">checked='checked'</c:if> value="N" /> 사용안함</label>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <c:if test="${not empty user.mbrNo}">
                <li><button type="button" class="btn-orange" id="updateButton"><span>수정</span></button></li>
                </c:if>
                <c:if test="${empty user.mbrNo}">
                <li><button type="button" class="btn-orange" id="insertButton"><span>등록</span></button></li>
                </c:if>
                <li><button type="button" class="btn-gray" onclick="goList()"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
    </form:form>
</div>
<c:import url="/popup/coInfoSearch.do">
  <c:param name="popupId" value="_coInfoPopup" />
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
<script type="text/javascript">

    var pwdPattern = /^.*(?=^.{10,100}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
    var checkId = false;

    $(document).ready(function() {

        var emptyFilter = function() {
            return !this.value;
        };

        $('#mbrGradeCd').change(function() {
            if($('#mbrGradeCd').val() != '') {
                $.ajax({
                    url: "${pageContext.request.contextPath}/ajax.authCdList.do",
                    data : {authType: $('#mbrGradeCd').val()},
                    async: false,
                    success: function(rtnData) {
                        $('#mbrCualfCd').empty();
                        $.each(rtnData, function() {
                            $('#mbrCualfCd').append('<option value="' + this.authTargtId +'|' + this.mbrCualfCd + '">' + this.authNm + '</option>');
                        });
                        //$('#mbrCualfCd').loadSelectOptions(rtnData,'${user.mbrCualfCd}','mbrCualfCd','authNm',1);
                        <c:if test="${not empty user.mbrNo}">
                            $('#mbrCualfCd').val('${user.authTargtId}|${user.mbrCualfCd}');
                        </c:if>
                    }
                });
            } else {
                $('#mbrCualfCd').loadSelectOptions({},'','mbrCualfCd','authNm',1);
            }
        });

        $('#corpInfoSearch').click(function(){
            $('.popup-area').css({'display': 'block'});
            emptyCorpGridSet();
        });

        // 등록
        $('#insertButton').click(function() {

            if($.trim($('#mbrGradeCd').val()) == '') {
                alert('유형을 선택하세요.');
                return false;
            }
            if($.trim($('#mbrCualfCd').val()) == '') {
                alert('관리자권한을 선택하세요.');
                return false;
            }
            if($.trim($('#username').val()) == '') {
                alert('이름을 입력하세요.');
                return false;
            }
            if($.trim($('#id').val()) == '') {
                alert('아이디을 입력하세요.');
                return false;
            }
            if(!checkId) {
                alert('아이디 중복체크를 해주세요.');
                return false;
            }
            if($.trim($('#password').val()) == '') {
                alert('비밀번호를 입력하세요.');
                return false;
            }
            if(!pwdPattern.test($.trim($('#password').val()))) {
                alert('비밀번호는 10자 이상의 영문, 숫자, 특수기호 조합으로 입력하세요.');
                return false;
            }
            if($.trim($('#posCoNo').val()) == '') {
                alert('소속을 선택하세요.');
                return false;
            }
            if ($('.email-address').filter(emptyFilter).length) {
                alert('이메일을 입력하세요.');
                return false;
            }

            $('[name="mobile"]').val($('.mobile-number').map(function() { return this.value; }).get().join('-'));
            $('[name="emailAddr"]').val($('.email-address').map(function() { return this.value; }).get().join('@'));

            if(confirm('등록하시겠습니까?')) {
                $('#managerForm').attr('action', '${pageContext.request.contextPath}/opr/manager/saveManager.do');
                $('#managerForm').submit();
            }
        });

        // 수정
        $('#updateButton').click(function() {

            if($.trim($('#mbrGradeCd').val()) == '') {
                alert('유형을 선택하세요.');
                return false;
            }
            if($.trim($('#mbrCualfCd').val()) == '') {
                alert('관리자권한을 선택하세요.');
                return false;
            }
            if($.trim($('#username').val()) == '') {
                alert('이름을 입력하세요.');
                return false;
            }
            if($.trim($('#password').val()) != '' && !pwdPattern.test($.trim($('#password').val()))) {
                alert('비밀번호는 10자 이상의 영문, 숫자, 특수기호 조합으로 입력하세요.');
                return false;
            }
            if($.trim($('#posCoNo').val()) == '') {
                alert('소속을 선택하세요.');
                return false;
            }
            if ($('.email-address').filter(emptyFilter).length) {
                alert('이메일을 입력하세요.');
                return false;
            }

            $('[name="mobile"]').val($('.mobile-number').map(function() { return this.value; }).get().join('-'));
            $('[name="emailAddr"]').val($('.email-address').map(function() { return this.value; }).get().join('@'));

            if(confirm('수정하시겠습니까?')) {
                $('#managerForm').attr('action', '${pageContext.request.contextPath}/opr/manager/updateManager.do');
                $('#managerForm').submit();
            }
        });

        // 이메일 선택
        $('#email-entry').change(function() {
            $('.email-address:last').val(this.value).toggle(!this.value);
        });

        <c:if test="${not empty user.mbrNo}">
        $('#mbrGradeCd').val('${user.authType}').change();
        </c:if>
    });

    // 아이디 중복 확인
    function checkIdDupl() {

        if($('#id').val() == '') {
            alert('아이디를 입력해주세요.');
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/ajax.checkIdDupl.do",
            data : {id: $('#id').val()},
            success: function(rtnData) {
                if(rtnData.success == "false"){
                    alert(rtnData.message);
                    return false;
                } else {
                    if(confirm('사용가능한 ID 입니다. 사용하시겠습니까?')) {
                        $('#id').next().remove();
                        $('#id').attr('readonly', 'readonly');
                        checkId = true;
                    } else {
                        $('#id').val('');
                    }
                }
            }
        });
    }

    // 소속 선택
    function callbackSelected(coInfo) {
        $('#posCoNo').val(coInfo.coNo);
        $('#coNm').val(coInfo.coNm);
    }

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }
</script>