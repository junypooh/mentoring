<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="layer-pop-wrap" id="layer5">
    <div class="title">
        <strong>
            <c:choose><c:when test="${applClassCd eq '101715'}">수업신청 정보</c:when><c:when test="${applClassCd eq '101716'}">참관신청 정보</c:when></c:choose>
        </strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont type3">
        <div class="request-info">
            <p class="search-result">
                <c:choose><c:when test="${applClassCd eq '101715'}">- 신청 기기수 </c:when><c:when test="${applClassCd eq '101716'}">- 참관 기기수 </c:when></c:choose>
             <em>${applCnt}</em> / ${maxApplCnt}</p>
        </div>
        <div class="mc-search-list box-scroll-wrap">
            <table>
                <caption>수업신청 정보 - 번호, 학교, 학급/그룹, 교사</caption>
                <colgroup>
                    <col style="width:65px" />
                    <col style="width:256px"/>
                    <col style="width:144px" />
                    <col style="width:138px" />
                </colgroup>
                <thead>
                <tr>
                    <th scope="col">번호</th>
                    <th scope="col">학교</th>
                    <th scope="col">학급/그룹</th>
                    <th scope="col">교사</th>
                </tr>
                </thead>
                <tbody>
                    <c:forEach items="${applDvcList}" var="applDvcList">
                        <tr>
                            <td>${applDvcList.rn}</td>
                            <td class="request-school">${applDvcList.schNm}</td>
                            <td class="request-group">${applDvcList.clasRoomNm} <em>(${applDvcList.stdntCnt})</em></td>
                            <td>${applDvcList.tchrNm}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type2 blue" id="aConfirm">확인</a>
            <%--<a href="#" class="btn-type2 gray">취소</a>--%>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(document).ready(function() {
        position_cm();

        $("#aConfirm").click(function(){
            $(".pop-close").click();
        });
    });
</script>