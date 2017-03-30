<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

		<div id="container">
			<div class="location">
				<a href="#" class="home">메인으로 이동</a>
				<span>수업관리</span>
				<span>MC관리</span>
			</div>
			<form id="frm">
			    <input type="hidden" id="mcNo" name="mcNo" value="${param.mcNo}" />
			    <input type="hidden" id="searchStDate" name="searchStDate" value="${param.searchStDate}" />
			    <input type="hidden" id="searchEndDate" name="searchEndDate" value="${param.searchEndDate}" />
			    <input type="hidden" id="genCd" name="genCd" value="${param.genCd}" />
			    <input type="hidden" id="useYn" name="useYn" value="${param.useYn}" />
			    <input type="hidden" id="mcNm" name="mcNm" value="${param.mcNm}" />
			    <input type="hidden" id="recordCountPerPage" name="recordCountPerPage" value="${param.recordCountPerPage}" />
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
			<div class="content">
				<h2>MC관리</h2>
				<div class="cont type3">
					<div class="board-type2 default">
						<table>
							<caption>MC관리 - MC명,성별,소속기관,스튜디오,사용유무,등록자,등록일</caption>
							<colgroup>
								<col style="width:154px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">MC명</th>
									<td><c:out value="${mcInfo.mcNm}" /></td>
								</tr>
								<tr>
									<th scope="row">성별</th>
									<td><c:if test="${mcInfo.genCd != null}"><c:out value="${mcInfo.genCd == '100323' ? '남':'여'}" /></c:if></td>
								</tr>
								<tr>
									<th scope="row">소속기관</th>
									<td><c:out value="${mcInfo.userDomain.mngrPosNm}" /></td>
								</tr>
								<tr>
									<th scope="row">스튜디오</th>
									<td><c:out value="${mcInfo.stdoInfoDomain.stdoNm}" /></td>
								</tr>
								<tr>
									<th scope="row">사용유무</th>
									<td><c:out value="${mcInfo.useYn eq 'Y' ? '활동중':'활동안함'}" /></td>
								</tr>
								<tr>
									<th scope="row">등록자</th>
									<td><c:out value="${mcInfo.regMbrNm}" /><c:if test="${not empty mcInfo.regMbrCoNm}">(<c:out value="${mcInfo.regMbrCoNm}" />)</c:if></td>
								</tr>
								<tr class="last">
									<th scope="row">등록일</th>
									<td><fmt:formatDate value="${mcInfo.regDtm}" pattern="yyyy.MM.dd hh:mm"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-area">
						<a href="edit.do?mcNo=${param.mcNo}" class="btn-type2">수정</a>
						<a href="javascript:void(0)" class="btn-type2 gray" onclick="goList()">목록</a>
					</div>
				</div>
			</div>
			<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
		</div>
<script type="text/javascript">
    function goList() {
        $('#frm').attr('action', '${pageContext.request.contextPath}/lecture/mc/list.do');
        $('#frm').attr('method', 'post');
        $('#frm').submit();
    }
</script>