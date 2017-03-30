<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <table class="tbl-style tbl-none-search">
        <input type="hidden" id="stdoNo" value="<c:out value="${mcInfo.stdoNo}" />"/>
            <colgroup>
               <col style="width:200px" />
               <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">수업 신청 기기</th>
                    <td>${clasSetHist.maxApplCnt} 대</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">참관 신청 기기</th>
                    <td>${clasSetHist.maxObsvCnt} 대</td>
                </tr>
            </tbody>
        </table>
        <p class="search-btnbox">
            <button type="button" class="btn-orange" onclick="location.href='edit.do'"><span class="search" >수정</span></button>
        </p>
    </div>
</div>

