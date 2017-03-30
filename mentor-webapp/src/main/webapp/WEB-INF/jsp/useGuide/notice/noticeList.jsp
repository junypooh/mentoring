<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>

<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();
}
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/userguide.css">

<div id="container">
  <div class="location">
    <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
    <span>이용안내</span>
    <span>공지사항</span>
  </div>
  <div class="content">
    <h2>공지사항</h2>
    <div class="cont" id="boardNoticeList"></div>
    <fieldset class="list-search-area">
      <legend>검색</legend>
      <select id="searchKey" title="공지사항 검색">
        <option value="0">전체</option>
        <option value="1">제목</option>
        <option value="2">내용</option>
      </select>
      <input type="search" id="searchWord" class="inp-style1" title="공지사항 검색">
      <a href="#" class="btn-search" onClick="search();"><span>검색</span></a>
    </fieldset>
  </div>
</div>

<script type="text/javascript">

function search() {
  var param = {'searchKey':$("#searchKey").val(), 'searchWord':$("#searchWord").val()};
  mentor.NoticeList.getList(param);
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/guideNoticeList.js" class="<c:out value="${param.arclSer}"/>"></script>