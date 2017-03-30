<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />


<div id="container">
	<div class="location">
		<a href="#" class="home">메인으로 이동</a>
		<span>수업관리</span>
		<span>수업개설신청</span>
	</div>
	<div class="content">
		<h2>수업개설신청</h2>
		<p class="tit-desc-txt">수업계획서를 작성하여 수업개설을 신청하여 주시면 확인 후 수업을 개설합니다. </p>
		<div class="cont type3">
			<div class="board-type2 default">
				<table>
					<caption>스튜디오관리 - 구분,스튜디오,주소,소속기관,담당자,전화번호,비고,사용유무,등록자,등록일</caption>
					<colgroup>
						<col style="width:154px;">
						<col>
						<col style="width:154px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">${lectOpenReqInfo.lectTitle}</td>
						</tr>
						<tr>
							<th scope="row">내용</th>
							<td colspan="3">
							    <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectOpenReqInfo.lectSust)"></spring:eval>
							</td>
						</tr>
						<tr>
							<th scope="row">수업계획서</th>
							<td colspan="3">
								<ul>
									<li>
									    <a href="${pageContext.request.contextPath}/fileDown.do?fileSer=${lectOpenReqInfo.fileSer}">
									     1.  ${lectOpenReqInfo.oriFileNm} (<fmt:formatNumber value=" ${lectOpenReqInfo.fileSize/(1024)/(1024)+(1-(lectOpenReqInfo.fileSize/(1024)/(1024)%1))%1}" type="number"/> MB)
									    </a>
                                    </li>
								</ul>
							</td>
						</tr>
						<tr>
							<th scope="row">상태</th>
							<td>${lectOpenReqInfo.authStatCdNm}</td>
							<th scope="row">오픈여부</th>
							<td>
							        <c:choose>
							            <c:when test="${lectOpenReqInfo.openYn == 'N'}">미오픈</c:when>
							            <c:otherwise>오픈</c:otherwise>
							        </c:choose>
					        </td>
						</tr>
						<tr>
							<th scope="row">등록일</th>
							<td><fmt:formatDate value="${lectOpenReqInfo.reqDtm}" pattern="yyyy.MM.dd" /></td>
							<th scope="row">승인/반려일</th>
							<td><fmt:formatDate value="${lectOpenReqInfo.procDtm}" pattern="yyyy.MM.dd" /></td>
						</tr>
						<tr>
							<th scope="row">처리내용</th>
							<td colspan="3">
							<c:choose>
							    <c:when test="${lectOpenReqInfo.authStatCd == '101028'}">
							        <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectOpenReqInfo.procSust)"></spring:eval>
							    </c:when>
							    <c:when test="${lectOpenReqInfo.authStatCd == '101027'}">
							        수업계획서가 승인되었습니다. <br/>오픈여부가 “오픈”으로 변경이 되면 수업이 개설 완료됩니다.
							    </c:when>
							    <c:otherwise>
                                    관리자가 수업계획서를 검토중에 있습니다.  <br/>검토완료 후 승인여부를 확인하실 수 있습니다.
                                </c:otherwise>
                            </c:choose>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-area">
			<!--
			<c:if test="${lectOpenReqInfo.authStatCd == '101026'}">
				<a href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqEdit.do?reqSer=${lectOpenReqInfo.reqSer}" class="btn-type2">수정</a>
			</c:if>
			-->
				<a href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqList.do" class="btn-type2 gray">목록</a>
			</div>
		</div>
	</div>
	<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>
