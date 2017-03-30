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
    <span class="first">서비스소개</span>
    <span>자주 찾는 질문</span>
  </div>
  <div class="content sub">
    <h2 class="txt-type">자주 찾는 질문</h2>
    <div class="userguide-qna-wrap">
      <strong>분류</strong>
      <ul class="userguide-ul" id="prefNo">
        <li><label class="radio-skin checked">전체<input type="radio" title="전체" name="categorize" value="" checked="checked" /></label></li>
      </ul>
      <div class="userguide-search-area">
        <div>
          <select class="slt-style" id="searchKey" title="검색분류">
            <option value="0">제목+내용</option>
            <option value="1">제목</option>
          </select>
          <input type="search" class="inp-style1" id="searchWord"  title="검색어 입력" />
        </div>
        <a href="#" class="btn-search" onClick="funcSearch();"><span>검색</span></a>
      </div>
    </div>
    <div id="faqList"></div>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    $("input[name='categorize']")[0].click();
    getBoardPrefList();
    enterFunc($("#searchWord"), funcSearch);
});

function getBoardPrefList() {
  $.ajax({
    url: "${pageContext.request.contextPath}/useGuide/ajax.getBoardPrefList.do",
    data : {boardId : 'mtFAQ'},
    contentType: "application/json",
    dataType: 'json',
    cache: false,
    success: function(rtnData) {
      var optStr = "";
      for(var i=0;i<rtnData.length;i++) {
        optStr += "<li><label class=\"radio-skin\">"+rtnData[i].prefNm+"<input type=\"radio\" title=\""+rtnData[i].prefNm+"\" name=\"categorize\" value=\""+rtnData[i].prefNo+"\"></label></li>";
      }
      $("#prefNo").append(optStr);
    },
    error: function(xhr, status, err) {
      console.error(this.props.url, status, err.toString());
    }
  });
}

function funcSearch() {
  var param = {'searchKey':$("#searchKey").val(), 'searchWord':$("#searchWord").val(), 'prefNo': $("input:radio[name='categorize']:checked").val()};
  mentor.FaqList.getList(param);
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/guideFaqList.js"></script>