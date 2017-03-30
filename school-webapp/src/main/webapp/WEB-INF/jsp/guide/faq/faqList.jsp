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
    <span class="first">이용안내</span>
    <span>자주 찾는 질문</span>
  </div>
  <div class="content sub">
    <h2 class="txt-type">자주 찾는 질문</h2>
    <div class="userguide-qna-wrap">
      <strong>분류</strong>
      <ul class="userguide-ul" id="prefNo">
        <li><input id="rds01" type="radio" name="categorize" value="" checked="checked" /><label for="rds01" class="radio-skin checked" title="전체">전체</label></li>
      </ul>
      <div class="userguide-search-area">
        <div>
          <select class="slt-style" id="searchKey" title="검색분류">
            <option value="0">제목+내용</option>
            <option value="1">제목</option>
          </select>
          <input type="search" class="inp-style" id="searchWord"  title="검색어 입력" />
        </div>
        <a href="#" class="btn-type2 search" onClick="funcSearch();"><span>검색</span></a>
        <a href="#" class="btn-type2 reload" onClick="funcClear();"><span>다시검색</span></a>
      </div>
    </div>
    <div id="faqList"></div>
  </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
  getBoardPrefList();
  enterFunc($("#searchWord"), funcSearch);
});

function getBoardPrefList() {
  $.ajax({
    url: "${pageContext.request.contextPath}/community/ajax.getBoardPrefList.do",
    data : {boardId : 'mtFAQ'},
    contentType: "application/json",
    dataType: 'json',
    cache: false,
    success: function(rtnData) {
      var optStr = "";
      for(var i=0;i<rtnData.length;i++) {
        optStr += "<li><input type=\"radio\" title=\""+rtnData[i].prefNm+"\" id=\"rds00"+i+"\" name=\"categorize\" value=\""+rtnData[i].prefNo+"\"><label for=\"rds00"+i+"\" class=\"radio-skin\">"+rtnData[i].prefNm+"</label></li>";
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

function funcClear() {
  $("#searchKey").val('0');
  $("#searchWord").val('');
  $("input:radio[name='categorize']").eq(0).prop('checked', true);
  funcSearch();
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/guideFaqList.js"></script>
<script type="text/jsx;harmony=true">
var pageSize = 0;
if(${isMobile}){
    pageSize = 5;
}else{
    pageSize = 10;
}
/*
mentor.FaqList = React.render(
  <FaqList url='${pageContext.request.contextPath}/community/ajax.arclList.do' context='${pageContext.request.contextPath}' boardId='mtFAQ' pageSize=pageSize/>,document.getElementById('faqList')
);
*/
mentor.FaqList = React.render(
  React.createElement(FaqList, {url:'${pageContext.request.contextPath}/community/ajax.arclList.do', context:'${pageContext.request.contextPath}', boardId:'mtFAQ', pageSize:pageSize, selArclSer:'${param.arclSer}'}),document.getElementById('faqList')
);
</script>