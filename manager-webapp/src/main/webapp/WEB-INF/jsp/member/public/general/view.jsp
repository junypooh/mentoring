<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>일반회원</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>일반회원관리</li>
            <li>일반회원</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
    <form id="frm">
        <input type="hidden" name="mbrNo" value="${param.mbrNo}" />
        <input type="hidden" name="mbrCualfCds" value="${param.mbrCualfCds}" />
        <input type="hidden" name="id" value="${param.id}" />
        <input type="hidden" name="name" value="${param.name}" />
        <input type="hidden" name="school" value="${param.school}" />
        <input type="hidden" name="clas" value="${param.clas}" />
        <input type="hidden" name="loginPermYn" value="${param.loginPermYn}" />
        <input type="hidden" name="approveYn" value="${param.approveYn}" />
        <input type="hidden" name="regDtmBegin" value="${param.regDtmBegin}" />
        <input type="hidden" name="regDtmEnd" value="${param.regDtmEnd}" />
        <input type="hidden" name="rpsStudent" value="${param.rpsStudent}" />
    </form>
        <table class="tbl-style tbl-none-search">
            <colgroup>
                <col style="width:147px;" />
                <col />
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">회원유형</th>
                    <td colspan="3">${user.mbrCualfNm}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">아이디</th>
                    <td>${user.id}</td>
                    <th scope="col" class="ta-l">비밀번호</th>
                    <td>
                        <button type="button" class="btn-style01" onclick="pwdReset('EMS');"><span>초기화 메일 발송</span></button>
                        <button type="button" class="btn-style01" onclick="pwdReset('SMS');"><span>초기화 SMS 발송</span></button>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">이름</th>
                    <td>
                        ${user.username}
                        <c:if test="${user.genCd eq codeConstants['CD100322_100323_남자']}">(남)</c:if>
                        <c:if test="${user.genCd eq codeConstants['CD100322_100324_여자']}">(여)</c:if>
                    </td>
                    <th scope="col" class="ta-l">이메일</th>
                    <td>${user.emailAddr}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">생년월일</th>
                    <td><c:if test="${not empty user.birthday}">${cnet:stringToDatePattern(user.birthday, 'yyyy.MM.dd')} (<c:choose><c:when test="${user.lunarYn eq 'N'}">양력</c:when><c:otherwise>음력</c:otherwise></c:choose>)</c:if></td>
                    <th scope="col" class="ta-l">이메일 수신</th>
                    <td><c:choose><c:when test="${fn:contains(user.agrees, codeConstants['CD100939_100944_메일수집동의'])}">동의</c:when><c:otherwise>동의안함</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">휴대전화</th>
                    <td>${user.mobile}</td>
                    <th scope="col" class="ta-l">보호자 동의</th>
                    <td>${user.prtctrEmailAddr} / <c:choose><c:when test="${!fn:contains(user.agrees, codeConstants['CD100939_100971_미성년자가입부모동의'])}"><span>대상자 아님</span></c:when><c:when test="${user.mbrStatCd eq '100862'}"><span>동의완료</span></c:when><c:otherwise><span class="red-txt">동의안함</span></c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">가입일</th>
                    <td><fmt:formatDate value="${user.regDtm}" pattern="yyyy.MM.dd HH:mm" /> / 최근 로그인 : ${user.lastLoginDtm}</td>
                    <th scope="col" class="ta-l">사용유무</th>
                    <td><c:choose><c:when test="${user.loginPermYn eq 'Y'}">사용중</c:when><c:otherwise>미사용</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">재동의일자</th>
                    <td>
                        <c:choose>
                        <c:when test="${not empty reAgrees[0].regDtm}">
                        <fmt:formatDate value="${reAgrees[0].regDtm}" pattern="yyyy.MM.dd" />
                        </c:when>
                        <c:otherwise>
                        -
                        ${useRegDate}
                        </c:otherwise>
                        </c:choose>
                        / 재동의 예정일 :
                        <c:choose>
                        <c:when test="${not empty reAgrees[0].regDtm}">
                        <fmt:formatDate value="${cnet:calculateDate(reAgrees[0].regDtm, 'y', 2)}" pattern="yyyy.MM.dd" var="userRegDate" />
                        </c:when>
                        <c:otherwise>
                        <fmt:formatDate value="${cnet:calculateDate(user.regDtm, 'y', 2)}" pattern="yyyy.MM.dd" />
                        </c:otherwise>
                        </c:choose>
                    </td>
                    <th scope="col" class="ta-l">재동의여부</th>
                    <td>${empty reAgrees ? '-' : '재동의완료'}</td>
                </tr>
            </tbody>
        </table>
        <p class="search-btnbox">
            <button type="button" class="btn-orange" onclick="location.href='edit.do?mbrNo=${param.mbrNo}'"><span>수정</span></button>
            <button type="button" class="btn-style02" onclick="goList()"><span>목록</span></button>
        </p>
        <div class="tab-bar">
            <ul>
                <li class="on"><a href="javascript:void(0)" onclick="tabChg(0)">교실정보</a></li><!-- 활성화 시 on 클래스 추가 -->
                <li><a href="javascript:void(0)" onclick="tabChg(1)">수업현황</a></li>
            </ul>
        </div>
        <div class="tab-cont" id="boardArea"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function() {
        tabChg(0);
    });

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

    function tabChg(number) {
        $('.tab-bar > ul > li').each(function() {
            $(this).removeClass('on');
        });
        $('.tab-bar > ul > li').eq(number).addClass('on');

        switch (number) {
            case 0  :
                $('.tab-cont').load('${pageContext.request.contextPath}/member/public/general/tabClassInfo.do?reqMbrNo=${user.mbrNo}');
                break;
            case 1  :
                $('.tab-cont').load('${pageContext.request.contextPath}/member/public/general/tabLectureInfo.do?reqMbrNo=${user.mbrNo}');
                break;
        }
    }

    function pwdReset(sendType){
        $.ajax({
            url: "${pageContext.request.contextPath}/user/manager/changePwdAndSendMail.do",
            data : {'mbrNo':${param.mbrNo}, 'sendType':sendType},
            success: function(rtnData) {
                if(sendType == "EMS"){
                    alert("이메일이 발송되었습니다.");
                }else{
                    alert("SMS가 발송되었습니다.");
                }
            },
            error: function(xhr, status, err) {
                if(sendType == "EMS"){
                    alert("이메일이 발송이 실패하였습니다.");
                }else{
                    alert("SMS가 발송이 실패하였습니다.");
                }
            }
        });

    }
</script>
