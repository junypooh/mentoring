<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>학교관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>학교관리</li>
            <li>학교정보관리</li>
            <li>학교정보상세</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <form id="frm">
            <input type="hidden" name="schNo" value="${param.schNo}" />
            <input type="hidden" name="schClassCd" value="${param.schClassCd}" />
            <input type="hidden" name="useChck" value="${param.useChck}" />
            <input type="hidden" name="sidoNm" value="${param.sidoNm}" />
            <input type="hidden" name="sgguNm" value="${param.sgguNm}" />
            <input type="hidden" name="userId" value="${param.userId}" />
            <input type="hidden" name="schNm" value="${param.schNm}" />

            <input type="hidden" name="schCd" value="${param.schCd}" />
            <input type="hidden" name="clasStartDay" value="${param.clasStartDay}" />
            <input type="hidden" name="clasEndDay" value="${param.clasEndDay}" />
        </form>
        <table class="tbl-style tbl-none-search">
        <input type="hidden" id="schNo" name="schNo" value="${param.schNo}" />
        <input type="hidden" id="mbrNo" name="mbrNo" />

            <colgroup>
               <col style="width:15%" />
               <col style="width:35%" />
               <col style="width:15%" />
               <col style="width:35%" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">학교코드</th>
                    <td id="schcd"></td>
                    <th scope="col" class="ta-l">학교관리자 아이디</th>
                    <td id="userId"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">학교급</th>
                    <td id="schClassNm"></td>
                    <th scope="col" class="ta-l">비밀번호</th>
                    <td>
                        <button type="button" class="btn-style01" onclick="pwdReset('EMS');"><span>초기화 메일 발송</span></button>
                        <button type="button" class="btn-style01" onclick="pwdReset('SMS');"><span>초기화 SMS 발송</span></button>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">학교</th>
                    <td id="schNm"></td>
                    <th scope="col" class="ta-l">담당자</th>
                    <td id="username"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">연락처</th>
                    <td id="contTel"></td>
                    <th scope="col" class="ta-l">담당자 휴대전화</th>
                    <td id="tel"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">보유장비</th>
                    <td id="deviceType"></td>
                    <th scope="col" class="ta-l">담당자 이메일</th>
                    <td id="emailAddr"></td>
                </tr>
                 <tr>
                    <th scope="col" class="ta-l">참여구분</th>
                    <td id="joinClass"></td>
                    <th scope="col" class="ta-l">홈페이지</th>
                    <td id="siteUrl"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">주소</th>
                    <td id="address" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">분류유형</th>
                    <td id="schClsfChrstcNm" colspan="3"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">등록일</th>
                    <td id="foundDay"></td>
                    <th scope="col" class="ta-l">사용유무</th>
                    <td id="useYn"></td>
                </tr>
            </tbody>
        </table>
        <p class="search-btnbox">
            <button type="button" class="btn-orange" onclick="location.href='edit.do?schNo=${param.schNo}'"><span class="search" >수정</span></button>
            <button type="button" class="btn-style02" onclick="goList();"><span>목록</span></button>
        </p>
        <div class="tab-bar">
            <ul id="tab">
                <li class="on"><a href="#" onclick="tabmenu(0);">교사현황</a></li><!-- 활성화 시 on 클래스 추가 -->
                <li><a href="#" onclick="tabmenu(1);">학생현황</a></li>
                <li><a href="#" onclick="tabmenu(2);">교실정보</a></li>
                <li><a href="#" onclick="tabmenu(3);">교실등록이력</a></li>
                <li><a href="#" onclick="tabmenu(4);">반대표 현황</a></li>
                <li><a href="#" onclick="tabmenu(5);">학교 대표 교사</a></li>
                <li><a href="#" onclick="tabmenu(6);">배정 사업 현황</a></li>
                <li><a href="#" onclick="tabmenu(7);">수업 신청 정보</a></li>
            </ul>
        </div>
        <div id="tabList">
        </div>
    </div>
</div>

<script type="text/javascript">

function goPage(curPage){
    mentor.AssignGroupListBySchool.getList({'currentPageNo':curPage,'recordCountPerPage':$("#recordCountPerPage").val()});
}
$(document).ready(function(){
    tabmenu(0);

    $.ajax({
        url: mentor.contextpath +"/school/info/ajax.retrieveSchInfoDetail.do",
        data : {'schNo':'${param.schNo}'
                ,'schMbrCualfCd':'101699'},
        contentType: "application/json",
        dataType: 'json',
        success: function(rtnData) {
            if(rtnData != null){
                $("#schcd").text(_nvl(rtnData.schNo));
                $("#userId").text(_nvl(rtnData.userId));
                $("#schClassNm").text(_nvl(rtnData.schClassNm));
                $("#schNm").text(_nvl(rtnData.schNm));
                $("#username").text(_nvl(rtnData.username));
                $("#tel").text(_nvl(rtnData.tel));
                $("#contTel").text(_nvl(rtnData.contTel));
                $("#classCnt").text(_nvl(rtnData.classCnt));
                $("#studentCnt").text(_nvl(rtnData.studentCnt));
                $("#teacherCnt").text(_nvl(rtnData.teacherCnt));
                $("#siteUrl").text(_nvl(rtnData.siteUrl));
                $("#address").text("{0} {1}".format(_nvl(rtnData.locaAddr),_nvl(rtnData.locaDetailAddr)));
                $("#emailAddr").text(_nvl(rtnData.emailAddr));
                $("#mbrNo").val(_nvl(rtnData.mbrNo));
                if(rtnData.regDtm != null){
                    $("#foundDay").text(rtnData.regDtm);
                }
                if(rtnData.schClsfChrstcNm != null){
                    $("#schClsfChrstcNm").text(rtnData.schClsfChrstcNm);
                }
                if(rtnData.deviceTypeCdNm != null){
                    if(rtnData.deviceTypeHold != null){
                        rtnData.deviceTypeCdNm = rtnData.deviceTypeHold  + " (사용장비 : " + rtnData.deviceTypeCdNm + ")"
                    }else{
                        rtnData.deviceTypeCdNm = "(사용장비 : " + rtnData.deviceTypeCdNm + ")"
                    }
                    $("#deviceType").text(rtnData.deviceTypeCdNm)
                }
                if(rtnData.joinClassCdNm != null){
                    $("#joinClass").text(rtnData.joinClassCdNm)
                }
                if(_nvl(rtnData.useYn) == 'Y'){
                    $("#useYn").text("사용중");
                }else{
                    $("#useYn").text("사용안함");
                }

            }else{
                location.href = "schoolInfo.do";
            }
        }
    });
});
function tabmenu(number){
    $("#tab > li").attr('class','');
    $("#tab > li:eq("+number+")").attr('class','on');
    $("#tabList").html("");
    switch (number) {
        case 0  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabTcherState.do?schNo="+$("#schNo").val(), function(){
                   $("#layerOpen").trigger("click");
                   $("schNo").val('${param.schNo}');
                });
                break;
        case 1  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabStudentState.do?schNo="+$("#schNo").val(), function(){
                     $("#layerOpen").trigger("click");
                     $("schNo").val('${param.schNo}');
                 });
                 break;
        case 2  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabRoomInfo.do?schNo="+$("#schNo").val(), function(){
                    $("#layerOpen").trigger("click");
                    $("schNo").val('${param.schNo}');
                });
                break;
        case 3  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabRoomHistory.do?schNo="+$("#schNo").val(), function(){
                    $("#layerOpen").trigger("click");
                    $("schNo").val('${param.schNo}');
                });
                 break;
        case 4  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabRoomRepresent.do?schNo="+$("#schNo").val(), function(){
                    $("#layerOpen").trigger("click");
                    $("schNo").val('${param.schNo}');
                });
                 break;
        case 5  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabTcherRepresent.do?schNo="+$("#schNo").val(), function(){
                  $("#layerOpen").trigger("click");
                  $("schNo").val('${param.schNo}');
                });
                 break;
        case 6  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabAssignGroupState.do?schNo="+$("#schNo").val(), function(){
                    $("#layerOpen").trigger("click");
                    $("schNo").val('${param.schNo}');
                });
                break;
        case 7  :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabLessonInfo.do?schNo="+$("#schNo").val(), function(){
                    $("#layerOpen").trigger("click");
                    $("schNo").val('${param.schNo}');
                });
                break;
      default   :
                $("#tabList").load(mentor.contextpath +"/school/info/tab/tabTcherState.do?schNo="+$("#schNo").val(), function(){
                $("#layerOpen").trigger("click");
                $("schNo").val('${param.schNo}');
                });
                break;
          break;
    }
}
function pwdReset(sendType){
    if(sendType == 'EMS'){
        if(!isValidEmailAddress($("#emailAddr").text()) || $("#emailAddr").text() == ""){
            alert("담당자 이메일을 확인해주세요.");
            return false;
        }
    }else{
        var tel = $("#tel").text();
        if(tel.replace(/-/gi, "").length != 11){
            alert("담당자 휴대전화를 확인해주세요.");
            return false;
        }
    }
    $.ajax({
        url: "${pageContext.request.contextPath}/user/manager/changePwdAndSendMail.do",
        data : {'mbrNo':$("#mbrNo").val(),
        'sendType':sendType},
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

function goList() {
    var qry = $('#frm').serialize();
    $(location).attr('href', mentor.contextpath+'/school/info/list.do?' + qry);
}

function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/);
        return pattern.test(emailAddress);
    }
</script>
