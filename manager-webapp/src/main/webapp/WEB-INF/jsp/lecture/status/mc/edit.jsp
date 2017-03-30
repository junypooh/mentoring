<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
       <form:form commandName="mcInfo" action="saveMcInfo.do" method="post" id="frm">
       <form:hidden path="mcNo" />
        <div class="title-bar">
            <h2>MC 현황</h2>
            <ul class="location">
                <li class="home">Home</li>
                <li>수업관리</li>
                <li>수업현황관리</li>
                <li>MC 현황</li>
            </ul>
        </div>
        <div class="board-area" id="boardArea">
            <table class="tbl-style tbl-mento-modify">
                <colgroup>
                    <col style="width:147px;" />
                    <col />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="col">MC명 <span class="red-point">*</span></th>
                        <td><form:input path="mcNm" /><form:errors path="mcNm" cssClass="errors"/></td>
                    </tr>
                    <tr>
                        <th scope="col">성별 <span class="red-point">*</span></th>
                        <td>
                            <label class="radio-skin"><form:radiobutton path="genCd" value="100323"/> 남</label>
                            <label class="radio-skin"><form:radiobutton path="genCd" value="100324"/> 여</label>
                        </td>
                    </tr>
                    <!--<tr>
                        <th scope="col">휴대전화 <span class="red-point">*</span></th>
                        <td><form:input path="contTel" /></td>
                    </tr>-->
                    <tr>
                        <th scope="col">소속기업</th>
                        <td>
                            <form:input path="userDomain.mngrPosNm" id="mngrPosNm"/>
                            <form:hidden path="posCoNo"  id="posCoNo"/>
                            <button type="button" id="mentorCorpoPopup" class="btn-style01"><span>찾기</span></button>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">스튜디오</th>
                        <td>
                            <form:hidden path="stdoNo" id="stdoNo"/>
                            <form:input path="stdoInfoDomain.stdoNm" id="stdoNm"/>
                            <button type="button" id="studioPopup" class="btn-style01"><span>찾기</span></button>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col">사용유무</th>
                        <td>
                            <label class="radio-skin"><form:radiobutton path="useYn" value="Y" /> 사용</label>
                            <label class="radio-skin"><form:radiobutton path="useYn" value="N" /> 사용불가</label>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="board-bot">
                <ul>
                    <li><button type="button" class="btn-orange" onclick="$('#frm').submit()"><span>저장</span></button></li>
                    <c:choose>
                    <c:when test="${schInfo.schNo ne null}">
                    <li><button type="button" class="btn-gray" onclick="location.href='view.do?schNo=${schInfo.schNo}'"><span>취소</span></button></li>
                    </c:when>
                    <c:otherwise>
                    <li><button type="button" class="btn-gray" onclick="location.href='list.do'"><span>취소</span></button></li>
                    </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </form:form>
</div>
<c:import url="/popup/mentorCorpoSearch.do">
  <c:param name="popupId" value="_mentorCorpoPopup" />
  <c:param name="callbackFunc" value="callbackSelected" />
  <c:param name="coClassCd" value="101661" />
</c:import>
<c:import url="/popup/studioSearch.do">
  <c:param name="popupId" value="_studioPopup" />
  <c:param name="callbackFunc" value="callbackStudioSelected" />
</c:import>
<script type="text/javascript">
function callbackSelected(mentors){
    $("#mngrPosNm").val(mentors.coNm);
    $("#posCoNo").val(mentors.coNo);
    closeCorpoPop();
}
function callbackStudioSelected(studio){
    $("#stdoNm").val(studio.stdoNm);
    $("#stdoNo").val(studio.stdoNo);
    closeStudioPop();
}
$(document).ready(function(){
    $("#frm").submit(function(){
        if($("#mcNm").val() == ""){
            alert("MC 이름을 입력하세요");return false;
        }
        var genCd = $("input:radio:checked[name='genCd']");
        if(genCd.length < 1){
            alert("성별을 선택해주세요");return false;
        }
        /*if($("#contTel").val() == ""){
            alert("휴대전화번호를 입력하세요");return false;
        }*/
        return confirm("저장하시겠습니까?");
    });

    $("#mentorCorpoPopup").click(function(){
         $('body').addClass('dim');
        $("#corpoPop").css("display","block");
        $("#aSearch").click();

    });

    $("#studioPopup").click(function(){
        $('body').addClass('dim');
        $("#studioPop").css("display","block");
        $("#studioSearch").click();
    });

});
</script>