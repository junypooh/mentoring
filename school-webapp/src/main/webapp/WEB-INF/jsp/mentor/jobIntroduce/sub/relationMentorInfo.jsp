<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!-- 관련멘토 -->
<ul class="slide_list">
<c:forEach items="${mentorList}" var="item" varStatus="idx"> 
	<li <c:if test="${idx.count == 1 }">class="current"</c:if>>
		<div>
			<a href="#">
				<div class="job-relation-info">
					<div class="info">
						<strong class="title">경쾌하고 익살스러운 그림 속 세상에서 살아 움직이는 친구들 방승조</strong>
						<p class="job">만화가 <span class="icon">재능기부</span></p>
					</div><div class="img"><img src="${pageContext.request.contextPath}/images/mentor/thumb_86x86_01.jpg" alt="멘토 이미지"></div>
				</div>
			</a>
		</div>
	</li>
</c:forEach>
</ul>

<ul class="navi slide-btn">
<c:forEach items="${mentorList}" var="item" varStatus="idx">
	<li class="active"><button type="button">관련 직업 1</button></li>
</c:forEach>
</ul>


