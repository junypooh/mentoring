<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div id="footer">
    <div class="footer-cont">
        <div class="footer-info">
            <ul class="footer-menu">
                <li><a href="${pageContext.request.contextPath}/footer/usageRule.do">이용약관</a></li>
                <li><a href="${pageContext.request.contextPath}/footer/personalInformationRule.do">개인정보처리방침</a></li>
                <li><a href="${pageContext.request.contextPath}/footer/emailRefusal.do">이메일무단수집거부</a></li>
                <li><a href="https://mentoring.career.go.kr/mentor/" target="_blank" title="새창열림">산들바람 멘토</a></li>
                <%--<li><a href="${pageContext.request.contextPath}/footer/">변경동의</a></li> --%>
            </ul>
            <div class="footer-menu-organization">
                <a href="#" class="organization">관련사이트</a>
                <ul class="organization-ul">
                    <li><a href="http://www.career.go.kr/cnet/front/main/main.do" target="_blank" title="새창열림">커리어넷</a></li>
                    <li><a href="http://www.krivet.re.kr/ku/index.jsp" target="_blank" title="새창열림">한국직업능력개발원</a></li>
                    <li><a href="https://www.kofac.re.kr/" target="_blank" title="새창열림">한국과학창의재단</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-organization">
        	<a href="http://www.moe.go.kr/main.do" target="_blank" title="새창열림"><img src="${pageContext.request.contextPath}/images/main/img_footer_edu.png" alt="교육부"></a>
            <a href="http://krivet.re.kr/ku/index.jsp" target="_blank" title="새창열림"><img src="${pageContext.request.contextPath}/images/main/img_footer_krivet.png" alt="한국직업능력개발원"></a>
			<a href="http://www.webwatch.or.kr/Situation/WA_Situation.html?MenuCD=110" target="_blank" title="새창열림"><img src="${pageContext.request.contextPath}/images/main/img_footer_wa.png"  alt="미래창조과학부 WEB ACCESSIBILITY 마크(웹 접근성 품질인증 마크)" title="국가 공인 인증기관 : 웹와치"></a>
        </div>
        <div class="footer-science-menu">
            <div style="color:#999">이용문의 : 1600-9548, 이메일 : <a href="mailto:mentoringadm@gmail.com">mentoringadm@gmail.com</a></div>
			<address>세종특별자치시 시청대로 370 세종국책연구단지 사회정책동 한국직업능력개발원</address>
            <p class="footer-manage">운영: 한국직업능력개발원 자유학기·진로체험지원센터</p>
            <p class="footer-support">지원: 교육부</p>
            <p class="footer-copyright">COPYRIGHTS <em>&copy;</em> KRIVET ALL RIGHTS RESERVED.</p>
        </div>
    </div>
</div>