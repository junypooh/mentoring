<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

	<!-- 관련수업 -->
	<div id="tabRelationLectureList">

	</div>

<input type="hidden" id="lectSer" value="${param.lectSer}"/>
<input type="hidden" id="lectTims" value="${param.lectTims}"/>
<input type="hidden" id="schdSeq" value="${param.schdSeq}"/>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/tabRelationLecture.js"></script>

<script type="text/javascript">
	mentor.tabRelationLectureList = React.render(
			                                     React.createElement(
					                                                   TabRelationLectureListView
					                                                 , {url: '${pageContext.request.contextPath}/lecture/lectureTotal/ajax.listTabRelationLecture.do'}
			                                                         )
			                                     , document.getElementById('tabRelationLectureList')
	                                             );
</script>

