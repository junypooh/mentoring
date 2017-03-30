<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="schNm" property="principal.schNm" />
    <security:authentication var="clasNm" property="principal.clasNm" />
    <security:authentication var="mbrClassNm" property="principal.mbrClassNm" />
    <security:authentication var="mbrpropicInfos" property="principal.mbrpropicInfos" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span>마이페이지</span>
        <span>나의정보</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">나의정보</h2>
        <p class="tit-desc-txt">나의 정보를 수정할 수 있습니다. 교실 정보 관리는 나의 교실 메뉴에서 할 수 있습니다.</p>

        <div class="join-info-write myinfo view">
            <h3 class="board-tit">프로필 정보</h3>
            <div class="myinfo-desc">
                <div class="my-desc-profile">
                    <span class="img-area" id="img_area"><c:choose><c:when test="${empty mbrpropicInfos or empty mbrpropicInfos[fn:length(mbrpropicInfos)-1].fileSer}">이미지 영역</c:when>
                    <c:otherwise><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${mbrpropicInfos[fn:length(mbrpropicInfos)-1].fileSer}" /></c:otherwise>
                    </c:choose></span>
                    <div>
                        <a href="javascript:void(0)" class="btn-type2" onclick="openFileDlg()"><span>등록</span>사진등록</a>
                        <form id="frm" action="uploadFile.do?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
                        <input type="file" name="upload_file" id="pic" style="display:none" onchange="uploadFile()" accept="image/*"/>
                        </form>
                        <a href="javascript:void(0)" class="btn-type2 gray" onclick="deletePropPic()"><span>삭제</span>사진삭제</a>
                    </div>
                </div>
                <c:if test="${  code['CD100204_100208_대학생'] ne mbrCualfCd and
                                code['CD100204_100209_일반'] ne mbrCualfCd and
                                code['CD100204_100210_일반_학부모_'] ne mbrCualfCd  }">
                <div class="my-desc-info">
                    <strong>
                        <em><c:choose><c:when test="${empty schNm}">등록된 학교 정보가 없습니다.</c:when><c:otherwise>${schNm}</c:otherwise></c:choose></em>
                        <span><c:choose><c:when test="${empty clasNm}">등록된 학년반 정보가 없습니다.</c:when><c:otherwise>${clasNm}</c:otherwise></c:choose></span>
                        <a href="${pageContext.request.contextPath}/myPage/myClassroom/myClassroom.do" class="btn-type2">학교정보수정</a>
                    </strong>
                </div>
                </c:if>
            </div>

            <h3 class="board-tit">필수 정보</h3>
            <div class="board-input-type">
                <table>
                    <caption>가입정보 입력 - 아이디, 비밀번호, 비밀번호 확인, 비밀번호찾기 질문, 이름, 생년월일, 이메일 주소, 이메일수신</caption>
                    <colgroup>
                        <col style="width:136px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="id-form">회원구분</label></th>
                            <td><em><security:authentication property="principal.mbrClassNm" /></em></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="pw-form">아이디</label></th>
                            <td><em><security:authentication property="principal.id" /></em></td>
                        </tr>
                        <tr>
                            <th scope="row" class="pw-qna">비밀번호찾기 질문</th>
                            <td>
                                <strong><c:out value="${user.pwdQuestNm}" /><em><c:out value="${user.pwdAnsSust}" /></em></strong>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="name-form">이름</label></th>
                            <td>
                                <span class="mgl-text"><security:authentication property="principal.username" /></span>
                                <span class="mgl-15">
                                <c:choose>
                                <c:when test="${user.genCd eq '100323' or empty user.genCd}">
                                    <em class="mgl-15">남자</em>
                                </c:when>
                                <c:when test="${user.genCd eq '100324'}">
                                    <em class="mgl-15">여자</em>
                                </c:when>
                                </c:choose>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="birthday">생년월일</label></th>
                            <td>
                                <span class="mgl-text"><fmt:parseDate value="${user.birthday}" var="birthday" pattern="yyyyMMdd"/><fmt:formatDate value="${birthday}" pattern="yyyy.MM.dd"/> </span>
                                <%--span class="mgl-15">
                                <c:choose>
                                <c:when test="${user.lunarYn eq 'N' or empty user.lunarYn}">
                                    <em class="mgl-15">양력</em>
                                </c:when>
                                <c:when test="${user.lunarYn eq 'Y'}">
                                    <em class="mgl-15">음력</em>
                                </c:when>
                                </c:choose>
                                </span--%>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="email-adrs">이메일</label></th>
                            <td>
                                <span><security:authentication property="principal.emailAddr" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">이메일 수신</th>
                            <td><c:set var="contains" value="false" />
<c:forEach var="item" items="${user.agrees}">
  <c:if test="${item eq '100944'}">
    <c:set var="contains" value="true" />
  </c:if>
</c:forEach>
                                <span><c:choose>
                                <c:when test="${!empty user.agrees[2].agrClassCd }">예</c:when>
                                <c:otherwise>아니오</c:otherwise>
                                </c:choose></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h3 class="board-tit">선택 정보</h3>
            <div class="board-input-type">
                <table>
                    <caption>추가정보 항목 - 연락처</caption>
                    <colgroup>
                        <col style="width:157px;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="dialing-code">연락처</label></th>
                            <td>
                                <span>${user.mobile}</span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area">
                <a href="myInfoEdit.do" class="btn-type2">회원 정보 수정</a>
                <a href="secession.do" class="btn-out">회원탈퇴신청</a>
            </div>
        </div>
    </div>
</div>
<script >
$(function(){
    $("#frm").ajaxForm({
        beforeSubmit : function(data,form,option){
            return true;
        },
        dataType: 'text',
        success:function(data,status){
            var response = JSON.parse(data);
            if(response.fileSer > 0){
                $("#img_area").html('<img src="${pageContext.request.contextPath}/fileDown.do?fileSer='+response.fileSer+'" />');
            }else{
                $("#img_area").html("");
                alert("이미지 파일이 아니거나 용량을 초과(5Mb)했습니다.");
            }
        },
        error:function(){
        }
    });
});
    function openFileDlg(){
        $("#pic").click();
    }

    function uploadFile(){
        $("#frm").submit();
    }

    function deletePropPic(){
        $.ajax({
            url: "ajax.deletePropPic.do",
            data : {'picSer':'${mbrpropicInfos[fn:length(mbrpropicInfos)-1].picSer}'},
            success: function(rtnData) {
                $("#img_area").html('');
            }
        });
    }
</script>