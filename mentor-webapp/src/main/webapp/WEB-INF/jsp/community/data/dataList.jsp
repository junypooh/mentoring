<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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

<div id="container">
  <div class="location">
    <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
    <span>커뮤니티관리</span>
    <span>수업자료</span>
  </div>
  <div class="content">
    <h2>수업자료</h2>
    <div class="cont" id="boardDataList"></div>
  </div>
  <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>

</div>
<script type="text/javascript">

var sMbrNo = "<%=user.getMbrNo()==null?"":user.getMbrNo()%>";
var selArclSer = "${param.arclSer}";

$(document).ready(function () {
  $('input[type=text].inp-style1').keydown(function (e) {
    if (e.which == 13) {/* 13 == enter key@ascii */
      search();
    }
  });
  <%--if('<%=lectSer%>' !='null'){--%>
  <%--debugger;--%>
  <%--dataSet.params.tabValue = 'work';--%>

  <%--$(".tab-type2 li").removeClass("mypage-data-li active");--%>
  <%--$("#homeWorkList").parent().addClass("mypage-data-li active");--%>
  <%--$('.mypage-wrap').hide();--%>
  <%--$($("#homeWorkList").attr('href')).show();--%>
  <%--myCommunity();--%>

  <%--workList.getList();--%>
  <%--}--%>
});

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/comunityDataList.js"></script>