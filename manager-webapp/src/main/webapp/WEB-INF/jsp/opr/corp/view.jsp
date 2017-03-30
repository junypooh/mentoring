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
        <h2>기관관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>기관관리</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="coNo" value="${param.coNo}" />
        <input type="hidden" name="regDtmBegin" value="${param.regDtmBegin}" />
        <input type="hidden" name="regDtmEnd" value="${param.regDtmEnd}" />
        <input type="hidden" name="coClassCd" value="${param.coClassCd}" />
        <input type="hidden" name="coNm" value="${param.coNm}" />
        <input type="hidden" name="useYn" value="${param.useYn}" />
    </form>
    <form:form modelAttribute="coInfo" id="updateCoInfo" action="editSubmit.do">
    <form:hidden path="tel" />
    <form:hidden path="fax" />
    <form:hidden path="coNo" />
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-none-search">
            <colgroup>
                <col style="width:130px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">구분 <span class="red-point">*</span></th>
                    <td>
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101659_업체구분코드'])" var="coClassCds" />
                        <spring:bind path="coClassCd">
                            <form:select path="coClassCd" id="coClassCdSelector" multiple="false" default="${status.value}">
                                <option value="">구분선택</option>
                                <c:forEach items="${coClassCds}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                                </c:forEach>
                            </form:select>
                        </spring:bind>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">기관/기업명 <span class="red-point">*</span></th>
                    <td>
                        <form:input path="coNm" class="text" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">담당자명 <span class="red-point">*</span></th>
                    <td>
                        <form:input path="mngrNm" class="text" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">연락처 <span class="red-point">*</span></th>
                    <td class="mobile">
                        <spring:eval expression="{'02','051','053','032','062','042','052','044','031','033','043','041','063','061','054','055','064','070','080','0130','0303','0502','0503','0504','0505','0506','0507','010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                        <select class="tel">
                            <c:forEach items="${dialingCode}" var="eachObj">
                                <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(coInfo.tel, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                            </c:forEach>
                        </select>
                        -
                        <input type="text" name="tel2" class="text tel" maxlength="4" value="${cnet:splitWithIndex(coInfo.tel, '-', 1)}" />
                        -
                        <input type="text" name="tel3" class="text tel" maxlength="4" value="${cnet:splitWithIndex(coInfo.tel, '-', 2)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">사업자등록번호</th>
                    <td>
                        <form:input path="bizno" class="text" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">팩스번호</th>
                    <td class="mobile">
                        <select class="fax">
                            <c:forEach items="${dialingCode}" var="eachObj">
                                <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(coInfo.fax, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                            </c:forEach>
                        </select>
                        -
                        <input type="text" name="fax2" class="text fax" maxlength="4" value="${cnet:splitWithIndex(coInfo.fax, '-', 1)}" />
                        -
                        <input type="text" name="fax3" class="text fax" maxlength="4" value="${cnet:splitWithIndex(coInfo.fax, '-', 2)}" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">주소</th>
                    <td class="address">
                        <p>
                            <form:input path="postCd" class="text" />
                            <button type="button" class="btn-style01" id="addressPopup"><span>우편번호찾기</span></button>
                        </p>
                        <p><form:input path="locaAddr" class="text" /></p>
                        <p><form:input path="locaDetailAddr" class="text" /></p>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">활동유무</th>
                    <td>
                        <label>
                            <input type="radio" name="useYn" id="useYn" value="Y" <c:if test="${empty coInfo.coNo or coInfo.useYn eq 'Y'}"> checked='checked'</c:if> /> 활동
                        </label>
                        <label>
                            <input type="radio" name="useYn" id="useYn" value="N" <c:if test="${coInfo.useYn eq 'N'}"> checked='checked'</c:if> /> 활동안함
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">등록자</th>
                    <td><c:if test="${not empty coInfo.regMbrNm}">${coInfo.regMbrNm} (${coInfo.regMbrId})</c:if></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">등록일</th>
                    <td><fmt:formatDate value="${coInfo.regDtm}" pattern="yyyy.MM.dd" /></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
            <c:choose>
            <c:when test="${not empty coInfo.coNo}">
                <li><button type="button" class="btn-orange" id="insertButton"><span>수정</span></button></li>
            </c:when>
            <c:otherwise>
                <li><button type="button" class="btn-orange" id="insertButton"><span>등록</span></button></li>
            </c:otherwise>
            </c:choose>
                <li><button type="button" class="btn-gray" onclick="goList()"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
    </form:form>
</div>
<c:import url="/popup/addressSearch.do">
  <c:param name="popupId" value="_addressPopup" />
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
<script type="text/javascript">

    // 우편번호 콜백 함수
    function callbackSelected(schInfos){
        $('[name="postCd"]').val(schInfos.ZIPNO);
        $('[name="locaAddr"]').val(schInfos.ROADADDR);
    }

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

    $(document).ready(function() {
        $('#coClassCdSelector').val($('#coClassCdSelector').attr('default'));

        // 우편번호 찾기
        $("#addressPopup").click(function(){
            $("#_addressPopup").css("display","block");
            getAddr(1);
        });

        // 저장 클릭
        $('#insertButton').click(function(e) {

            if(confirm('저장하시겠습니까?')) {
                $(this).closest('form').submit();
                return false;
            } else {
                return false;
            }
        });

        $('#updateCoInfo').submit(function() {

            if (
                    !!!$('[name="coClassCd"]', this).val() ||
                    !!!$('[name="coNm"]', this).val() ||
                    !!!$('[name="mngrNm"]', this).val() ||
                    !!!$('[name="tel2"]', this).val() ||
                    !!!$('[name="tel3"]', this).val()
               ) {
                alert('* 가 표시된 필수항목은 모두 기입해 주세요.');
                return false;
            }

            $('[name="tel"]', this).val($('.tel').map(function() { return this.value; }).get().join('-'));
            if(!!$('[name="fax2"]', this).val() && !!$('[name="fax3"]', this).val()) {
                $('[name="fax"]', this).val($('.fax').map(function() { return this.value; }).get().join('-'));
            }

            return;
        });
    });
</script>