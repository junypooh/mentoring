<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>
<security:authorize access="isAuthenticated()">
  <security:authentication var="id" property="principal.id" />
</security:authorize>
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();
}
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/community.css">

<div id="container">
  <div class="location">
    <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
    <span class="first">커뮤니티</span>
    <span>문의하기</span>
  </div>
  <div class="content sub">
    <h2 class="title">문의하기</h2>

    <div class="review-tbl-wrap">
      <div class="review-tbl">
        <table>
          <caption>직업소개 검색창 - 키워드,직업</caption>
          <colgroup>
            <col class="size-tbl1" />
            <col class="size-tbl2" />
            <col class="size-tbl1" />
            <col />
          </colgroup>
          <tbody>
            <tr>
              <th scope="row"><label for="schoolKeyword">키워드</label></th>
              <td>
                <div class="keyword-search">
                  <div class="selectbox-zindex-wrap"><!-- 2015-11-16 추가 -->
                      <select id="searchKey" class="keyword-slt" title="키워드 종류">
                        <option value="1" >전체</option>
                        <option value="2" >제목</option>
                        <option value="3" >내용</option>
                      </select>
                      <div class="selectbox-zindex-box">
                          <div></div>
                          <iframe scrolling="no" title="빈프레임" frameborder="0"></iframe>
                      </div>
                  </div>
                  <input type="text" class="keyword-inp" id="searchWord"  title="키워드입력란" />
                </div>
              </td>
              <!--
              <th scope="row">직업</th>
              <td>
                <a href="#jobSearch" title="직업선택 - 열기" class="btn-job layer-open m-none">직업선택</a>
              </td>
              -->
            </tr>
          </tbody>
        </table>
      </div>

      <div class="btn-area">
        <a href="javascript:search();" class="btn-search"><span>검색</span></a>
        <a href="javascript:clear()" class="btn-reload"><span>다시검색</span></a>
      </div>
    </div>

    <div id="boardQnaList"></div>


<div class="layer-pop-wrap" id="qnaPop">
    <div class="layer-pop bigger">
        <div class="layer-header">
            <strong class="title">문의하기 등록</strong>
        </div>
        <div class="layer-cont">
            <form id="frm" method="post" action="${pageContext.request.contextPath}/community/registArcl.do">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardId" value="lecQnA" />
            <input type="hidden" id="scrtArclYn" name="scrtArclYn" value="Y" />
            <input type="hidden" name="redirectUrl" value="/community/qna/qnaList.do" />
            <div class="tbl-style inquiry">
                <p><span class="essent-inp">필수입력 알림</span>필수입력</p>
                <table>
                    <caption>문의하기 등록 - 분류,제목,내용</caption>
                    <colgroup>
                    <col style="width:20%" />
                    <col />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row"><span class="essent-inp">필수입력</span><label for="prefNo">분류</label></th>
                        <td>
                            <select class="slt-style" title="분류선택" id="prefNo" name="prefNo">
                                <option value="">선택</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><span class="essent-inp">필수입력</span><label for="title">제목</label></th>
                        <td><input type="text" id="title" name="title" class="inp-style" title="제목" /></td>
                    </tr>
                    <tr>
                        <th scope="row"><span class="essent-inp">필수입력</span><label for="sust">내용</label></th>
                        <td>
                            <div class="editor-wrap popup">
                                <jsp:include page="/layer/editor.do" flush="true">
                                    <jsp:param name="wrapperId" value="sust"/>
                                    <jsp:param name="contentId" value="sust"/>
                                    <jsp:param name="formName" value="frm"/>
                                </jsp:include>
                                <textarea class="ta-style" id="sust" name="sust" style="display:none;" ></textarea>
                                <input type="hidden" id="arclSer" name="arclSer" />
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            </form>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup" onclick="saveArcl()" >확인</a>
                <a href="javascript:void(0)" class="btn-type2 cancel">취소</a>
            </div>
            <a href="javascript:void(0)" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>

  </div>
</div>

<%--
<jsp:include page="/WEB-INF/jsp/layer/layerJobSelector.jsp">
    <jsp:param name="callback" value="jobLayerConfirmCallback" />
</jsp:include>
--%>
<script type="text/javascript">

    var sJobNo = "";
    var sJobChrstcCds = "";

    $(document).ready(function(){
        enterFunc($("#searchWord"), search);

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $('body').removeClass('dim');
                $("#qnaPop").hide();
            }
        });
    });

    function jobLayerConfirmCallback(chrstcClsfCds, jobClsfCd) {
      sJobNo = jobClsfCd;
      sJobChrstcCds  = chrstcClsfCds;
    }

    function search() {
      var param = {'searchKey':$("#searchKey").val(), 'searchWord':$("#searchWord").val(), 'currentPageNo':1};
      mentor.QnaList.getList(param);
    }

    function clear() {
        $("#searchKey").val('1');
        $("#searchWord").val('');
        search();
    }

    function chkLength() {
      var thisLen = $("#textaInfo").val().length;
      if(thisLen > 400) {
        alert("입력 글자수를 초과하였습니다.");
        $("#textaInfo").val($("#textaInfo").val().substring(0, 400));
      }
      $("#contLen").text(  $("#textaInfo").val().length);
    }

    function loginCheck(){
      if(${empty id}){
        alert("로그인이 필요한 서비스입니다.");
        return false;
      }
      return true;
    }

    function saveArcl() {
        if($("#prefNo").val() === "") {
          alert("분류를 선택해 주세요.");
          return false;
        }
        if($("#title").val() === "") {
          alert("제목을 입력해 주세요.");
          return false;
        }
        if(!confirm("등록하시겠습니까?")) {
          return false;
        }

        //console.log($('#frm').serialize());

        saveContent();
    }

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/comunityQnaList.js"></script>
<script type="text/javascript">

var pageSize = 0;
if(${isMobile}){
    pageSize = 5;
}else{
    pageSize = 10;
}

mentor.QnaList = React.render(React.createElement(QnaList, {url:'${pageContext.request.contextPath}/community/ajax.arclList.do', context:'${pageContext.request.contextPath}', boardId:'lecQnA', mbrNo:'<%=user.getMbrNo()%>', selArclSer:'<c:out value="${param.arclSer}" />', pageSize:pageSize}),document.getElementById('boardQnaList'));
</script>