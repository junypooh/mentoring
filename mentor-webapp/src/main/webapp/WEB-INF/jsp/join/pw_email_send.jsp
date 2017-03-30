<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>아이디/비밀번호 찾기</span>
    </div>
    <div class="content">
        <h2>아이디/비밀번호 찾기</h2>
        <p class="tit-desc-txt">요청하신 아이디/비밀번호 찾기가 완료되었습니다.</p>
        <div class="cont">
            <div class="member-choice email-send">
                <h3>아이디/비밀번호 이메일 발송완료</h3>
                <div class="message">
                    <span>
                        입력하신 이메일 주소로
                        <em>아이디와 임시 비밀번호를</em>
                        발송하였습니다.
                    </span>
                </div>
                <p>이메일을 확인하신 후 로그인 해주세요.</p>
                <div class="btn-area">
                    <a href="#" class="btn-type2">로그인</a>
                    <a href="#" class="btn-type2 gray">재발송</a>
                </div>
            </div>
            
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>