<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>MC 현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업현황관리</li>
            <li>MC 현황</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="mcNm" value="${param.mcNm}" />
        <input type="hidden" name="useYn" value="${param.useYn}" />
        <input type="hidden" name="mngrPosNm" value="${param.mngrPosNm}" />
        <input type="hidden" name="genCd" value="${param.genCd}" />
        <input type="hidden" name="searchStDate" value="${param.searchStDate}" />
        <input type="hidden" name="searchEndDate" value="${param.searchEndDate}" />
    </form>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-none-search">
        <input type="hidden" id="stdoNo" value="<c:out value="${mcInfo.stdoNo}" />"/>
            <colgroup>
               <col style="width:15%" />
               <col style="width:35%" />
               <col style="width:15%" />
               <col style="width:35%" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">MC명</th>
                    <td colspan="3"><c:out value="${mcInfo.mcNm}" /></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">성별</th>
                    <td colspan="3"><c:if test="${mcInfo.genCd != null}"><c:out value="${mcInfo.genCd == '100324' ? '여':'남'}" /></c:if></td>
                </tr>
                <!--<tr>
                    <th scope="col" class="ta-l">휴대전화</th>
                    <td colspan="3"><c:out value="${mcInfo.contTel}" /></td>
                </tr>-->
                <tr>
                    <th scope="col" class="ta-l">소속기업</th>
                    <td colspan="3"><c:out value="${mcInfo.userDomain.mngrPosNm}" /></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">소속스튜디오</th>
                    <td colspan="3"><c:out value="${mcInfo.stdoInfoDomain.stdoNm}" /></td>
                </tr>
                <tr>
                   <th scope="col" class="ta-l">사용유무</th>
                   <td colspan="3"><c:out value="${mcInfo.useYn eq 'Y' ? '활동중':'활동안함'}" /></td>
                </tr>
                 <tr>
                    <th scope="col" class="ta-l">등록자</th>
                    <td><c:out value="${mcInfo.regMbrNm}" /></td>
                    <th scope="col" class="ta-l">등록일</th>
                    <td><fmt:formatDate value="${mcInfo.regDtm}" pattern="yyyy.MM.dd hh:mm"/></td>
                </tr>
            </tbody>
        </table>
        <p class="search-btnbox">
            <button type="button" class="btn-orange" onclick="location.href='edit.do?mcNo=${mcInfo.mcNo}'"><span class="search" >수정</span></button>
            <button type="button" class="btn-style02" onclick="goList();"><span>목록</span></button>
        </p>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function(){

});


function goList() {
    var qry = $('#frm').serialize();
    $(location).attr('href', mentor.contextpath+'/lecture/status/mc/list.do?' + qry);
}
</script>
