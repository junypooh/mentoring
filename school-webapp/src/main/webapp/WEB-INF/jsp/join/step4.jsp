<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span>회원가입</span>
    </div>
    <div class="content sub">
        <h2>회원가입</h2>
        <span class="join-step-img"><img src="../images/utility/img_join_step4.gif" alt="step1.회원분류 선택, step2.약관동의, step.3 가입정보 입력, step4.접수완료 중 step4.접수완료" /></span>

        <div class="member-choice id-finish finish">
                <h3>양방향 실시간, 원격영상 멘토링 서비스</h3>
                <div class="message">
                    <dl>
                        <dt>회원 아이디</dt>
                        <dd>${user.id}</dd>
                    </dl>
                </div>
                <div class="join_finish-txt">
                    <p>회원님의 가입 정보는 <strong>마이페이지 > 나의 정보</strong>에서 확인하실 수 있으며,<br/>회원가입 시 입력하신 정보는 입력하신 이메일 주소로 발송해 드리고 있습니다.</p>
                    <p>
                        <em>14세 미만 회원인 경우에는 보호자 이메일로 발송된 가입 동의 메일을 통해 가입 동의를 완료해주세요.</em>
                        보호자의 가입 동의가 확인된 이후 원격영상 멘토링 서비스 이용이 가능합니다.
                    </p>
                </div>
                <div class="btn-area">
                    <a href="${pageContext.request.contextPath}/login.do" class="btn-type2">로그인</a>
                </div>
            </div>
    </div>
</div>