<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="kr.or.career.mentor.domain.User"%>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();
}
%>
<!-- //header -->
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">수업</span>
        <span>수업다시보기</span>
    </div>
    <div class="content sub">
        <h2>수업다시보기</h2>
        <div class="review-tbl-wrap">
            <div class="review-tbl">
                <table>
                    <caption>수업 다시보기 검색창 - 날짜,학교,시간,수업유형,키워드,직업</caption>
                    <colgroup>
                        <col class="size-tbl1" />
                        <col class="size-tbl2" />
                        <col class="size-tbl1" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="reviewDate">날짜</label></th>
                            <td class="review-cardat">
                                <input type="text" id="clasStartDay" title="시작일 선택 달력" style="width: 100px;"/>
                                <span class="calendar-hyphen">~</span>
                                <input type="text" id="clasEndDay" title="마지막 선택 달력" style="width: 100px;"/>
                            </td>
                            <th scope="row"><label for="lectTargtCd">학교급</label></th>
                            <td>
                                 <select id="lectTargtCd" title="학교급">
                                    <option value="">전체</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lectTime">시간</label></th>
                            <td>
                                <select id="lectTime" title="시간 - 1시간 단위">
                                    <option value="0800" selected="selected">08:00</option>
                                    <option value="0900">09:00</option>
                                    <option value="1000">10:00</option>
                                    <option value="1100">11:00</option>
                                    <option value="1200">12:00</option>
                                    <option value="1300">13:00</option>
                                    <option value="1400">14:00</option>
                                    <option value="1500">15:00</option>
                                    <option value="1600">16:00</option>
                                </select>
                            </td>
                            <th scope="row"><label for="lectTypeCd">수업유형</label></th>
                            <td>
                                <select id="lectTypeCd" title="수업유형">
                                    <option value="">전체</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="searchKey">키워드</label></th>
                            <td>
                                <div class="keyword-search">
                                    <select id="searchKey" class="keyword-slt" title="키워드">
                                        <option value="ALL">전체</option>
                                        <option value="LTITLE">수업</option>
                                        <option value="MENTOR">멘토</option>
                                        <option value="TAG">태그</option>
                                        <option value="JOB">직업</option>
                                    </select>
                                    <input type="text" id="searchWord" class="keyword-inp" title="키워드입력란" />
                                </div>
                            </td>
                            <th scope="row">직업</th>
                            <td>
                                <a href="#jobSearch" title="직업선택 팝업 - 열기" class="btn-job layer-open m-none">직업선택</a>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area">
                <a href="#" class="btn-search" onclick="searchList();"><span>검색</span></a>
            </div>
        </div>
        <div id="replayList"></div>
    </div>
</div>

<jsp:include page="/WEB-INF/jsp/layer/layerJobSelector.jsp">
    <jsp:param name="callback" value="jobLayerConfirmCallback" />
</jsp:include>

<script type="text/javascript">

$(document).ready(function() {
    _applyDatepicker($("#clasStartDay"), '시작일 선택 달력');
    _applyDatepicker($("#clasEndDay"), '마지막 선택 달력');

    $('#searchWord').keydown(function(e) {
        if (e.which == 13) {/* 13 == enter key@ascii */
            searchList();
        }
    });

    $('#clasStartDay').datepicker("option", "onClose", function ( selectedDate ) {
        $("#clasEndDay").datepicker( "option", "minDate", selectedDate );
    });

    $('#clasEndDay').datepicker("option", "onClose", function ( selectedDate ) {
        $("#clasStartDay").datepicker( "option", "maxDate", selectedDate );
    });
    getTargetCode();
    getClassType();

    $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");

    $('.hasDatepicker').keyup(function(e) {

        var dateExp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

        if($(this).val().length >= 10) {
            $(this).val($(this).val().substring(0, 10));

            if(!dateExp.test($(this).val())) {
                alert('날짜 형식에 맞지 않습니다. ex) 2015-10-26');
                $(this).val('');
            }
            return;
        } else {
            if($(this).val().length == 4) {
                $(this).val($(this).val() + "-");
            }
            if($(this).val().length == 7) {
                $(this).val($(this).val() + "-");
            }
        }
    });
});

var sJobNo = "";
var sJobChrstcCds = "";

function jobLayerConfirmCallback(chrstcClsfCds, jobClsfCd) {
  sJobNo = jobClsfCd;
  sJobChrstcCds  = chrstcClsfCds;
}

function searchList() {
  var param = {
          'clasStartDay':$("#clasStartDay").val(),
          'clasEndDay':$("#clasEndDay").val(),
          'lectTargtCd':$("#lectTargtCd").val(),
          'lectTime':$("#lectTime").val(),
          'lectTypeCd':$("#lectTypeCd").val(),
          'searchKey':$("#searchKey").val(),
          'searchWord':$("#searchWord").val(),
          'sJobChrstcCds' : sJobChrstcCds,
          'sJobNo' : sJobNo
          };
  mentor.ReplayList.getList(param);
}

function getTargetCode() {
    $.ajax({
        url: '${pageContext.request.contextPath}/code.do',
        data : {'supCd':'${code["CD101512_101533_강의대상코드"]}'},
        success: function(rtnData) {
            $('#lectTargtCd').loadSelectOptions(rtnData,'','cd','cdNm',1);
        }
    });
}

function getClassType() {
    $.ajax({
        url: '${pageContext.request.contextPath}/code.do',
        data : {'supCd':'${code["CD101512_101528_강의유형코드"]}'},
        success: function(rtnData) {
            $('#lectTypeCd').loadSelectOptions(rtnData,'','cd','cdNm',1);
        }
    });
}

function goPage(curPage){
    mentor.ReplayList.getList({'currentPageNo':curPage});
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/replayList.js" class="${param.arclSer}"></script>