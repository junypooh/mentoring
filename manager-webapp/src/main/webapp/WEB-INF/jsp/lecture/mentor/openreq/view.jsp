<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>수업개설신청</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업개설관리</li>
            <li>수업개설신청</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-manager-info">
            <colgroup>
                <col style="width:147px;" />
                <col />
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <input type="hidden" id="reqSer" value="${lectOpenReqInfo.reqSer}" />
                <tr>
                    <th scope="col">제목</th>
                    <td colspan="3">${lectOpenReqInfo.lectTitle}</td>
                </tr>
                <tr>
                    <th scope="col">내용</th>
                    <td colspan="3">
                        <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectOpenReqInfo.lectSust)"></spring:eval>
                    </td>
                </tr>
                <tr>
                    <th scope="col">수행계획서</th>
                    <td colspan="4">
                        <a href="${pageContext.request.contextPath}/fileDown.do?fileSer=${lectOpenReqInfo.fileSer}" class="underline">
                            ${lectOpenReqInfo.oriFileNm} (<fmt:formatNumber value=" ${lectOpenReqInfo.fileSize/(1024)/(1024)+(1-(lectOpenReqInfo.fileSize/(1024)/(1024)%1))%1}" type="number"/> MB)
                        </a>
                    </td>
                </tr>
                <tr>
                    <th scope="col">등록자(멘토)</th>
                    <td>${lectOpenReqInfo.targtMbrNm}</td>
                    <th scope="col">직업</th>
                    <td>${lectOpenReqInfo.targtJobNm}</td>
                </tr>
                <tr>
                    <th scope="col">등록일</th>
                    <td><fmt:formatDate value="${lectOpenReqInfo.reqDtm}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <th>조회수</th>
                    <td>${lectOpenReqInfo.vcnt}</td>
                </tr>
                <tr>
                    <th scope="col">승인상태</th>
                    <td>${lectOpenReqInfo.authStatCdNm}</td>
                    <th scope="col">오픈유무</th>
                    <td>
							        <c:choose>
							            <c:when test="${lectOpenReqInfo.openYn == 'N'}">오픈안함</c:when>
							            <c:otherwise>오픈중</c:otherwise>
							        </c:choose>
                    </td>
                </tr>
            <c:if test="${lectOpenReqInfo.authStatCd == '101027' or lectOpenReqInfo.authStatCd == '101028'}">
                <tr>
                    <th scope="col">처리자</th>
                    <td><c:if test="${lectOpenReqInfo.procMbrNm != null}" >${lectOpenReqInfo.procMbrNm}(${lectOpenReqInfo.procCoNm})</c:if></td>
                    <th>처리일</th>
                    <td><fmt:formatDate value="${lectOpenReqInfo.procDtm}" pattern="yyyy.MM.dd HH:mm" /></td>
                </tr>
                <tr height="100px">
                    <th scope="col">처리내용</th>
                    <td colspan="3">
                            <c:choose>
							    <c:when test="${lectOpenReqInfo.authStatCd == '101028'}">
							        <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectOpenReqInfo.procSust)"></spring:eval>
							    </c:when>
							    <c:when test="${lectOpenReqInfo.authStatCd == '101027'}">
							        수업계획서가 승인되었습니다.
							    </c:when>
                            </c:choose>
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <div class="board-bot">
             <c:if test="${lectOpenReqInfo.authStatCd == '101027'}">
             <p class="total-num"><strong>※ 오픈여부가 “오픈”으로 변경이 되야지만 교육수행기관에서 확인할수 있습니다.</strong> </p>
             </c:if>
            <ul>
                <c:choose>
                    <c:when test="${lectOpenReqInfo.authStatCd == '101026'}">
                        <li><button type="button" class="btn-orange" onClick="fn_acceptLect();"><span>승인</span></button></li>
                        <li><button type="button" class="btn-orange" onClick="getRejctPopUp();"><span>반려</span></button></li>
                    </c:when>
                    <c:when test="${lectOpenReqInfo.authStatCd == '101027'}">
                        <li><button type='button' class='btn-orange' onClick="fn_openLect('${lectOpenReqInfo.openYn == 'Y' ? 'N'  : 'Y'}')">
                                <span>
                                    <c:choose>
							            <c:when test="${lectOpenReqInfo.openYn == 'Y'}">오픈안함</c:when>
							            <c:otherwise>오픈</c:otherwise>
							        </c:choose>
                                </span>
                            </button></li>
                    </c:when>
                </c:choose>
                <li><button type="button" class="btn-gray" onClick="javascript:location.href='${pageContext.request.contextPath}/lecture/mentor/openreq/list.do'"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
</div>


<c:import url="/popup/layerRejectOpenReqLecture.do">
  <c:param name="popupId" value="_rejectOpenReqLecturePopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>

<script type="text/javascript">


    $(document).ready(function(){

    });


    // 수업개설신청 승인
    function fn_acceptLect(){

        var _param = {
            reqSer : $('#reqSer').val(),
            authStatCd : '101027'
        };

        if( confirm('승인하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/lecture/mentor/openreq/ajax.edit.do',
                data : $.param(_param, true),
                contentType: "application/json",
                dataType: 'json',
                type: 'get',
                success: function(rtnData) {
                    if(rtnData.success){
                        alert(rtnData.data);
                        location.href = '${pageContext.request.contextPath}/lecture/mentor/openreq/view.do?reqSer=' +  $('#reqSer').val();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.edit.do", status, err.toString());
                }
            });
        }
    }


    // 오픈/미오픈 처리
    function fn_openLect(openYn){

        var _param = {
            reqSer : $('#reqSer').val(),
            openYn : openYn
        };

        if( confirm('수정 하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/lecture/mentor/openreq/ajax.edit.do',
                data : _param,
                contentType: "application/json",
                dataType: 'json',
                type: 'get',
                success: function(rtnData) {
                    if(rtnData.success){
                        alert(rtnData.data);
                        location.href = '${pageContext.request.contextPath}/lecture/mentor/openreq/view.do?reqSer=' +  $('#reqSer').val();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.edit.do", status, err.toString());
                }
            });
        }
    }

    function getRejctPopUp(){
        $('#procSust').val('');
        $('body').addClass('dim');
        $("#_rejectOpenReqLecturePopup").css("display","block");
    }

</script>