<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/community.css">

<div id="container">
  <div class="location">
    <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
    <span class="first">커뮤니티</span>
    <span>자유게시판</span>
  </div>
  <div class="content sub">
    <div class="title-group">
      <h2 class="title">자유게시판</h2>
      <div class="btn">
        <a href="#" class="btn-border-type" onclick="clearLayer();">등록</a>
        <a href="#freeBoardPop" class="btn-border-type layer-open" title="등록팝업 - 열기" style="display:none" id="btnFreeBoardPop">등록</a>
      </div>
    </div>
    <div id="boardFreeList"></div>
    <fieldset class="list-search-area">
      <legend>검색</legend>
      <select id="searchKey" title="저유게시판 검색">
        <option value="0">제목+내용</option>
        <option value="1">제목</option>
        <option value="2">내용</option>
      </select>
      <input type="search" id="searchWord" title="자유게시판 검색"><button type="button" class="btn-type search" onClick="search();"><span>검색</span></button>
    </fieldset>
  </div>
  <div class="cont-quick">
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
  </div>
</div>

<!-- 게시글 등록 -->
<div class="layer-pop-wrap" id="freeBoardPop">
  <div class="layer-pop">
    <div class="layer-header">
      <strong class="title">게시글 등록/수정</strong>
    </div>
    <div class="layer-cont">
      <div class="tbl-style">
        <p><span class="essent-inp">필수입력 알림</span>필수입력</p>
        <table>
          <caption>게시글 등록/수정 입력창 - 제목,내용</caption>
          <colgroup>
            <col style="width:20%" />
            <col />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><span class="essent-inp">필수입력</span><label for="essentTitle">제목</label></th>
              <td><input type="text" id="essentTitle" class="inp-style" name="제목" /></td>
            </tr>
            <tr>
              <th scope="row"><span class="essent-inp">필수입력</span><label for="textaInfo">내용</label></th>
              <td>
                <div class="text-area popup">
                  <textarea id="textaInfo" class="ta-style" name="text" onkeyup="chkLength();"></textarea><span class="text-limit"><strong id="contLen">0</strong> / 400자</span>
                  <input type="hidden" id="arclSer" />
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="btn-area popup">
        <a href="#" class="btn-type2 popup" onclick="registArcl();">확인</a>
        <a href="#" class="btn-type2 cancel">취소</a>
      </div>
      <a href="#" class="layer-close">팝업 창 닫기</a>
    </div>
  </div>
</div>
<!-- //게시글 등록 -->

<script type="text/javascript">

var arclSer = "<c:out value="${param.arclSer}" />";
var sMbrNo = "${mbrNo}";

function clearLayer() {
    if(sMbrNo == "") {
        alert("로그인이 필요한 서비스 입니다.");
        location.href = "${pageContext.request.contextPath}/login.do";
        return;
    }
    $("#arclSer").val("0");
    $("#essentTitle").val("");
    $("#textaInfo").val("");
    $("#btnFreeBoardPop").click();
}

function registArcl() {
    if($("#essentTitle").val() ==""){
        alert("제목을 입력하세요.");
        return false;
    }
    if($("#textaInfo").val() ==""){
        alert("내용을 입력하세요.");
        return false;
    }
  if(!confirm("등록하시겠습니까?")) {
    return false;
  }
  var data = {title : $("#essentTitle").val(),
                   boardId:'lecFreeBoard',
                   sust : $("#textaInfo").val(),
                   arclSer : $("#arclSer").val() };
  $.ajax({
    url: "${pageContext.request.contextPath}/community/ajax.registArcl.do",
    data : JSON.stringify(data),
    contentType: "application/json",
    dataType: 'json',
    type: 'post',
    cache: false,
    success: function(rtnData) {
      $(".subject-detail").hide("fast");
      $(".writing-list li").removeClass("active");
      alert(" 등록했습니다.");
      mentor.FreeList.getList();
      $('body').removeClass('dim');
      $("#freeBoardPop").hide();
    },
    error: function(xhr, status, err) {
      console.error(this.props.url, status, err.toString());
    }
  });
}

function search() {
  var param = {'searchKey':$("#searchKey").val(), 'searchWord':$("#searchWord").val()};
  mentor.FreeList.getList(param);
}

function chkLength() {
  var thisLen = $("#textaInfo").val().length;
  if(thisLen > 400) {
    alert("입력 글자수를 초과하였습니다.");
    $("#textaInfo").val($("#textaInfo").val().substring(0, 400));
  }
  $("#contLen").text(  $("#textaInfo").val().length);
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/comunityFreeList.js"></script>