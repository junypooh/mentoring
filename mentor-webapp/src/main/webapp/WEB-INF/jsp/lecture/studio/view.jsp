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
				<span>스튜디오관리</span>
			</div>
			<form id="frm">
			    <input type="hidden" id="stdoNo" name="stdoNo" value="${param.stdoNo}" />
			    <input type="hidden" id="searchStDate" name="searchStDate" value="${param.searchStDate}" />
			    <input type="hidden" id="searchEndDate" name="searchEndDate" value="${param.searchEndDate}" />
			    <input type="hidden" id="useYn" name="useYn" value="${param.useYn}" />
			    <input type="hidden" id="stdoNm" name="stdoNm" value="${param.stdoNm}" />
			    <input type="hidden" id="recordCountPerPage" name="recordCountPerPage" value="${param.recordCountPerPage}" />
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
			<div class="content">
				<h2>스튜디오관리</h2>
				<div class="cont type3">
					<div class="board-type2 default">
						<table>
							<caption>스튜디오관리 - 구분,스튜디오,주소,소속기관,담당자,전화번호,비고,사용유무,등록자,등록일</caption>
							<colgroup>
								<col style="width:154px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">구분</th>
									<td>${stdoInfo.indrYnNm}</td>
								</tr>
								<tr>
									<th scope="row">스튜디오</th>
									<td>${stdoInfo.stdoNm}</td>
								</tr>
								<tr>
									<th scope="row">주소</th>
									<td>${stdoInfo.locaAddr} ${stdoInfo.locaDetailAddr}</td>
								</tr>
								<tr>
									<th scope="row">소속기관</th>
									<td>${stdoInfo.posCoNm}</td>
								</tr>
								<tr>
									<th scope="row">담당자</th>
									<td>${stdoInfo.chrgrNm}</td>
								</tr>
								<tr>
									<th scope="row">전화번호</th>
									<td>${stdoInfo.repTel}</td>
								</tr>
								<tr>
									<th scope="row">비고</th>
									<td><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(stdoInfo.florNm)"></spring:eval></td>
								</tr>
								<tr>
									<th scope="row">사용유무</th>
									<td>${stdoInfo.useYnNm}</td>
								</tr>
								<tr>
									<th scope="row">등록자</th>
									<td>${stdoInfo.regMbrNm}(${stdoInfo.regMbrCoNm})</td>
								</tr>
								<tr class="last">
									<th scope="row">등록일</th>
									<td><fmt:formatDate value="${stdoInfo.regDtm}" pattern="yyyy.MM.dd HH:mm" /></td>

								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-area">
						<a href="edit.do?stdoNo=${param.stdoNo}" class="btn-type2">수정</a>
						<%--a href="list.do" class="btn-type2 gray">목록</a--%>
						<a href="javascript:void(0)" class="btn-type2 gray" onclick="goList()">목록</a>
					</div>
				</div>
			</div>
			<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
		</div>
<script type="text/javascript">
    function goList() {
        $('#frm').attr('action', '${pageContext.request.contextPath}/lecture/studio/list.do');
        $('#frm').attr('method', 'post');
        $('#frm').submit();
    }
</script>