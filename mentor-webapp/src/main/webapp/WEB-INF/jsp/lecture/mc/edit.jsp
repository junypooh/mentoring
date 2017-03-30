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
				<span>MC관리</span>
			</div>
			<div class="content">
			<form:form commandName="mcInfo" action="saveMcInfo.do" method="post" id="frm">
			<form:hidden path="mcNo" />
			<form:hidden path="contTel" />
				<h2>MC관리</h2>
				<div class="cont type3">
					<div class="board-title1">
						<span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
					</div>
					<div class="board-input-type all-view">
						<table>
							<caption>MC관리 - 구분,스튜디오,주소,소속기관,담당자,전화번호,비고,사용유무,등록자,등록일</caption>
							<colgroup>
								<col style="width:154px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="compulsory">MC명</th>
									<td>
									    <form:input class="inp-style1" style="width:200px;" path="mcNm" />
									</td>
								</tr>
								<tr>
									<th scope="row" class="compulsory">성별</th>
									<td>
                                        <label class="radio-skin"><form:radiobutton path="genCd" value="100323"/> 남자</label>
                                        <label class="radio-skin"><form:radiobutton path="genCd" value="100324"/> 여자</label>
									</td>
								</tr>
								<tr>
									<th scope="row">소속기관</th>
									<td>
									    <c:choose>
									    <c:when test="${empty userDomain.mngrPosNm}">
									    ${posCoNm}
									    </c:when>
									    <c:otherwise>
									    ${mcInfo.userDomain.mngrPosNm}
									    </c:otherwise>
									    </c:choose>
									    <form:hidden path="posCoNo" />
									</td>
								</tr>
								<tr>
									<th scope="row">스튜디오</th>
									<td>
									    <form:hidden path="stdoNo" id="stdoNo"/>
									    <form:input class="inp-style1" style="width:200px;" path="stdoInfoDomain.stdoNm" id="stdoNm" />
										<a href="#stdoLayer" class="btn-type5 layer-open">찾기</a>
									</td>
								</tr>
								<tr>
									<th scope="row" class="compulsory">사용유무</th>
									<td>
                                        <label class="radio-skin"><form:radiobutton path="useYn" value="Y"/> 사용중</label>
                                        <label class="radio-skin"><form:radiobutton path="useYn" value="N"/> 사용안함</label>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-area">
						<a href="javascript:void(0)" class="btn-type2" onclick="$('#frm').submit()">저장</a>
						<a href="javascript:void(0)" class="btn-type2 gray" onclick="history.back(-1)">취소</a>
					</div>
				</div>
			</form:form>
			</div>
			<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
<c:import url="/layer/layerStudioSearch.do">
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
		</div>
<script type="text/javascript">

    $(document).ready(function() {
        $('.radio-skin:has(:checked)').addClass('checked');

        $("#frm").submit(function(){
            if($("#mcNm").val() == ""){
                alert("MC 이름을 입력하세요");
                return false;
            }
            return confirm("저장하시겠습니까?");
        });
    });

    function callbackSelected(obj) {
        $('#stdoNo').val(obj.stdoNo);
        $('#stdoNm').val(obj.stdoNm);
    }
</script>