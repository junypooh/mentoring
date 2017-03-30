<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">로그인</span>
        <span>아이디/비밀번호찾기</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">아이디/비밀번호찾기</h2>
        <p class="tit-desc-txt">회원정보를 이용한 아이디/비밀번호 찾기 입니다. 원하시는 항목을 선택해주세요.</p>
        <div class="member-choice id-finish">
            <h3>아이디 찾기 완료</h3>
            <p>입력하신 정보와 일치하는 아이디 목록입니다.</p>
            <div class="message ${(fn:length(listUser) > 1)?"list":""}">
            <c:choose>
                <c:when test="${fn:length(listUser) > 1}">
                    <div class="board-type1">
                        <table>
                            <caption></caption>
                            <colgroup>
                                <col style="width:33.3%;" />
                                <col style="width:33.3%;" />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col">기업명</th>
                                    <th scope="col">아이디</th>
                                    <th scope="col">가입일</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${listUser}" var="user">
                                <tr>
                                    <td>${user.posCoNm}</td>
                                    <td>${user.id}</td>
                                    <td><fmt:formatDate value="${user.regDtm}" pattern="yyyy.MM.dd"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                <dl>
                    <dt>아이디</dt>
                    <dd>${user.id}</dd>
                    <dt>가입일</dt>
                    <dd><fmt:formatDate value="${user.regDtm}" pattern="yyyy.MM.dd"/></dd>
                </dl>
                </c:otherwise>
            </c:choose>
            </div>

            <div class="btn-area">
                <a href="${pageContext.request.contextPath}/login.do" class="btn-type2">로그인</a>
                <a href="${pageContext.request.contextPath}/join/idPwSearch.do" class="btn-type2 gray">비밀번호 찾기</a>
            </div>
        </div>
    </div>
</div>

<div class="cont-quick double">
    <!--a href=""><img src="../images/common/img_quick3.png" alt="리스트로 이동" /></a-->
    <a href="#"><img src="../images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
