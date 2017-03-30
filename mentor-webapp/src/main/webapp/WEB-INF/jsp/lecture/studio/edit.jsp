<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="posCoNm" property="principal.posCoNm" />
</security:authorize>

		<div id="container">
			<div class="location">
				<a href="#" class="home">메인으로 이동</a>
				<span>수업관리</span>
				<span>스튜디오관리</span>
			</div>
			<div class="content">
			    <form id="frm" name="frm">
			    <input type="hidden" id="stdoNo" name="stdoNo" value="${param.stdoNo}"/>
				<h2>스튜디오관리</h2>
				<div class="cont type3">
					<div class="board-title1">
						<span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
					</div>
					<div class="board-input-type all-view">
						<table>
							<caption>스튜디오관리 - 구분,스튜디오,주소,소속기관,담당자,전화번호,비고,사용유무,등록자,등록일</caption>
							<colgroup>
								<col style="width:154px;">
								<col style="width:75px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="compulsory">구분</th>
									<td colspan="2">
										<label class="radio-skin<c:if test="${stdoInfo.indrYn eq 'Y' or empty stdoInfo.indrYn}"> checked</c:if>"><input type="radio" name="indrYn" value="Y" class="radio-skin"<c:if test="${stdoInfo.indrYn eq 'Y' or empty stdoInfo.indrYn}"> checked="checked"</c:if>>내부</label>
										<label class="radio-skin<c:if test="${stdoInfo.indrYn eq 'N'}"> checked</c:if>"><input type="radio" name="indrYn" value="N" class="radio-skin"<c:if test="${stdoInfo.indrYn eq 'N'}"> checked="checked"</c:if>>외부</label>
									</td>
								</tr>
								<tr>
									<th scope="row" class="compulsory">스튜디오</th>
									<td colspan="2">
										<input type="text" class="inp-style1" style="width:200px;" id="stdoNm" name="stdoNm" value="${stdoInfo.stdoNm}">
									</td>
								</tr>
								<tr class="address">
									<th scope="row" class="compulsory" rowspan="2">주소</th>
									<td>기본주소</td>
									<td>
									    <input type="hidden" id="postCd" name="postCd" value="${stdoInfo.postCd}" />
                                        <input type="hidden" id="sidoNm" name="sidoNm" value="${stdoInfo.sidoNm}">
                                        <input type="hidden" id="sgguNm" name="sgguNm" value="${stdoInfo.sgguNm}">
                                        <input type="hidden" id="umdngNm" name="umdngNm" value="${stdoInfo.umdngNm}">
										<input type="text" class="inp-style1" style="width:270px;" id="locaAddr" name="locaAddr" value="${stdoInfo.locaAddr}" readonly>
										<a href="#addressLayer" class="btn-type5 layer-open">주소찾기</a>
									</td>
								</tr>
								<tr class="address">
									<td>상세주소</td>
									<td><input type="text" class="inp-style1" style="width:270px;" id="locaDetailAddr" name="locaDetailAddr" value="${stdoInfo.locaDetailAddr}"></td>
								</tr>
								<tr>
									<th scope="row">소속기관</th>
									<td colspan="2">
									    <c:choose>
									    <c:when test="${empty stdoInfo.posCoNm}">
									    ${posCoNm}
									    </c:when>
									    <c:otherwise>
									    ${stdoInfo.posCoNm}
									    <input type="hidden" id="posCoNo" name="posCoNo" value="${stdoInfo.posCoNo}">
									    </c:otherwise>
									    </c:choose>
									</td>
								</tr>
								<tr>
									<th scope="row">담당자</th>
									<td colspan="2"><input type="text" class="inp-style1" style="width:200px;" id="chrgrNm" name="chrgrNm" value="${stdoInfo.chrgrNm}"></td>
								</tr>
								<tr>
									<th scope="row">전화번호</th>
									<td colspan="2"><input type="text" class="inp-style1" style="width:200px;" id="repTel" name="repTel" value="${stdoInfo.repTel}"></td>
								</tr>
								<tr>
									<th scope="row">비고</th>
									<td colspan="2"><textarea id="florNm" name="florNm" rows="" class="textarea" cols="">${stdoInfo.florNm}</textarea></td>
								</tr>
								<tr>
									<th scope="row" class="compulsory">사용유무</th>
									<td colspan="2">
										<label class="radio-skin<c:if test="${stdoInfo.useYn eq 'Y' or empty stdoInfo.useYn}"> checked</c:if>"><input type="radio" name="useYn" value="Y" class="radio-skin"<c:if test="${stdoInfo.useYn eq 'Y' or empty stdoInfo.useYn}"> checked="checked"</c:if>>사용중</label>
										<label class="radio-skin<c:if test="${stdoInfo.useYn eq 'N'}"> checked</c:if>"><input type="radio" name="useYn" value="N" class="radio-skin"<c:if test="${stdoInfo.useYn eq 'N'}"> checked="checked"</c:if>>사용안함</label>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-area">
						<a href="javascript:void(0)" class="btn-type2" id="save">저장</a>
						<a href="javascript:void(0)" class="btn-type2 gray" onclick="history.back(-1)">취소</a>
					</div>
				</div>
				</form>
			</div>
			<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
<c:import url="/layer/layerAddressSearch.do">
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
		</div>
<script type="text/javascript">

    // 등록 및 수정
    $('#save').click(function(){
        if($.trim($('#stdoNm').val()) == ''){
            alert('스튜디오 이름을 입력하세요.');
            return;
        }

        if($('#locaAddr').val() == '' || $('#postCd').val() == ''){
            alert('주소를 입력하세요.');
            return;
        }

        if($('#locaDetailAddr').val() == ''){
            alert('상세주소를 입력하세요.');
            return;
        }

        if(confirm('저장하시겠습니까?')){
            $.ajax({
                url: "${pageContext.request.contextPath}/lecture/studio/ajax.saveStudioInfo.do",
                data : $('#frm').serialize(),
                cache: false,
                success: function(rtnData) {
                    if(rtnData == 'SUCCESS'){
                        alert('저장되었습니다.');
                        location.href='${pageContext.request.contextPath}/lecture/studio/list.do'
                    }else{
                        alert('저장에 실패하였습니다.');
                    }
                },
                error: function () {
                    alert('저장에 실패하였습니다.');
                }
            });
        }
    });

    function callbackSelected(obj) {
        $("#locaAddr").val(obj.ROADADDR);
        $("#postCd").val(obj.ZIPNO);
        var splitAddr = obj.JIBUNADDR.split(" ");
        $("#sidoNm").val(splitAddr[0]);
        $("#sgguNm").val(splitAddr[1]);
        $("#umdngNm").val(splitAddr[2]);
    }

    $('#florNm').on('keyup', function() {
        if($(this).val().length > 250) {
            $(this).val($(this).val().substring(0, 250));
            alert('250자만 입력가능합니다.');
        }
    });
</script>