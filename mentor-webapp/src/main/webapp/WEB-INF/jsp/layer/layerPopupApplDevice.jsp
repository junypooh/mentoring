<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="layer-pop-wrap" id="layer1">
    <div class="title">
        <strong>신청 디바이스</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
    </div>
    <div class="cont board">
        <div class="device-request">
            <div class="board-type2">
                <table>
                    <caption>신청 디바이스 - 수업, 멘토, 상태, 일시</caption>
                    <colgroup>
                        <col style="width:114px;"/>
                        <col/>
                        <col style="width:114px;"/>
                        <col/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row" class="compulsory">수업</th>
                        <td colspan="3"><c:if test="${lectSchdInfo.lectTimsInfo.lectInfo.lectTypeCd ne '101529'}">[${lectSchdInfo.lectTimsInfo.lectInfo.lectTypeCdNm}]</c:if> ${lectSchdInfo.lectTimsInfo.lectInfo.lectTitle}</td>
                    </tr>
                    <tr>
                        <th scope="row" class="compulsory">멘토</th>
                        <td>${lectSchdInfo.lectTimsInfo.lectInfo.lectrNm}</td>
                        <th scope="row" class="compulsory">상태</th>
                        <td>${lectSchdInfo.lectStatCdNm}</td>
                    </tr>
                    <tr>
                        <th scope="row" class="compulsory">일시</th>
                        <fmt:parseDate value="${lectSchdInfo.lectDay}" var="lectDay" pattern="yyyyMMdd"/>
                        <fmt:parseDate value="${lectSchdInfo.lectStartTime}" var="lectStartTime" pattern="HHmm"/>
                        <fmt:parseDate value="${lectSchdInfo.lectEndTime}" var="lectEndTime" pattern="HHmm"/>
                        <td colspan="3"><fmt:formatDate value="${lectDay}" pattern="yyyy.MM.dd"/> <fmt:formatDate value="${lectStartTime}" pattern="HH:mm"/> ~ <fmt:formatDate value="${lectEndTime}" pattern="HH:mm"/></td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="pop-board-scroll">
                <div class="board-type1">
                    <table>
                        <caption>정산관리 - 번호, 학교, 학급/그룹</caption>
                        <colgroup>
                            <col style="width:15%;"/>
                            <col/>
                            <col style="width:20%;"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">학교</th>
                            <th scope="col">학급/그룹</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="lectApplInfo" items="${lectApplInfoList}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td class="al-left">${lectApplInfo.schNm}</td>
                                <td>${lectApplInfo.clasRoomNm}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type2 pop-close" id="">확인</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        position_cm();
    })
</script>