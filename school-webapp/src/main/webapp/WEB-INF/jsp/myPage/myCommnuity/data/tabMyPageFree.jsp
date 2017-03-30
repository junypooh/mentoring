<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
String teacherYn = "N";
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();

  if(user.getMbrClassCd().equals("100859")) {
    teacherYn = "Y";
  }
}

  String lectSer = request.getParameter("lectSer");
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage.css">

<div id="boardFreeList"></div>
<div class="mypage-list-area">
  <fieldset class="list-search-area">
    <legend>검색</legend>
    <select id="searchKey" title="검색어 기준">
      <option value="0">제목+내용</option>
      <option value="1">제목</option>
      <option value="2">작성자</option>
    </select><input type="search" id="searchWord" title="검색어 입력"><button type="button" class="btn-type2 search" onClick="search();"><span>검색</span></button>
  </fieldset>
</div>

<script type="text/javascript">

var sMbrNo = "<%=user.getMbrNo()!=null?user.getMbrNo():""%>";

$(document).ready(function() {

});

function myCommunity() {
  var myCom = $('.my-community-wrap');
  var thismyHeight = myCom.find('.active .mypage-wrap').height();
  myCom.css('padding-bottom', thismyHeight + 19 + 'px' )
}

function search() {
  var param = {'searchKey':$("#searchKey").val(), 'searchWord':$("#searchWord").val()};
  mentor.FreeList.getList(param);
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/myPageFreeList.js"></script>
<script type="text/jsx;harmony=true">
  mentor.FreeList  = React.render(React.createElement(FreeList , {url: "${pageContext.request.contextPath}/community/ajax.arclList.do", boardId: "lecFreeBoard", mbrNo: "<%=user.getMbrNo()%>"}),document.getElementById('boardFreeList'));
</script>