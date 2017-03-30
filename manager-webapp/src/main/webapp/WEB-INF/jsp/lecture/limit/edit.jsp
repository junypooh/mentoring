<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>기기재한설정</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>기기제한설정</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <form:form action="saveMachineLimit.do" method="post" commandName="clasSetHist" id="frm">
        <table class="tbl-style tbl-none-search">
            <colgroup>
               <col style="width:200px" />
               <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">수업 신청 기기</th>
                    <td><form:input path="maxApplCnt" cssClass="numberOnly" maxlength="3" style="text-align:right;width:50px;"/> 대</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">참관 신청 기기</th>
                    <td><form:input path="maxObsvCnt" cssClass="numberOnly" maxlength="3" style="text-align:right;width:50px;"/> 대</td>
                </tr>
            </tbody>
        </table>
        </form:form>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="submit()"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" onclick="location.href='list.do'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
$(document).ready(function(){
    $("#frm").submit(function(){

        return confirm("저장하시겠습니까?");
    });
});
function submit(){
    $("#frm").submit();
}
</script>
