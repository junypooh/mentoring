<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<div id="container">
	<div class="content error">
		<div class="error-cont">
			<h2 class="error-500">웹 사이트에서 페이지를 표시할 수 없습니다.</h2>
			<p class="desc">가능성이 높은 원인: ${exception.message} </p>
			<ul class="browser-list error-404">
				<li>브라우저의 주소 표시줄에 입력한 웹사이트 주소의 철자와 형식이 정확한지 확인 하십시오.</li>
				<li>링크를 클릭하여 이 페이지에 연결한 경우, 웹사이트 관리자에게 링크가 잘못되었음을 알려 주십시오. </li>
				<li><a href="javascript:history.back();">뒤로</a> 단추를 클릭하여 다른 링크를 시도하십시오.</li>
			</ul>

			<p class="desc">다음을 시도하십시오.</p>
			<ul class="browser-list error-404">
				<li><a href="${pageContext.request.contextPath}/">홈으로 이동합니다.</a></li>
				<li><a href="javascript:location.reload();">페이지를 새로 고칩니다.</a></li>
				<li><a href="javascript:history.back();">이전 페이지로 돌아갑니다.</a></li>
			</ul>

			<span class="add-info"><a href="#">추가정보</a></span>
		</div>
	</div>
</div>
