<%--
  Created by IntelliJ IDEA.
  User: 김정훈
  Date: 2015-10-06
  Time: 오전 12:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<div id="container">
    <div class="location mobile-sb">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">마이페이지</span>
        <span>학교신청현황</span>
        </div>
        <div class="content sub">
        <h2 class="txt-type">학교신청현황</h2>
        <p class="tit-desc-txt">학교의 수업 신청 내용을 확인할 수 있습니다. </p>
        <div class="myclass-cont">
            <div class="tab-action">
                <ul class="tab-type1 tab02">
                    <li class="active"><a href="#" onclick="getSchAssignGroupList();">배정사업현황</a></li>
                    <li><a href="#" id="lessonTab03" onclick="getSchoolList();">수업신청내역</a></li>
                </ul>
                <div class="tab-action-cont">
                    <!-- 나의 관리 교실 -->
                    <div class="tab-cont active">
                        <div class="board-list-title">
                            <select class="slt-style" style="width:155px;" title="학교선택" id="selSch1" name="selSch1" >
                            <option value="">전체</option>
                            </select>
                            <div>
                                <strong>총<em id="singleSchArea">0</em>건</strong>
                            </div>
                        </div>
                        <div class="board-list-type more" id="schAssignGroupList">
                            <table>
                                <caption>나의 관리 교실 테이블정보 - 신청일, 지역, 학교, 유형, 교실명, 등록신청중, 학생 현황, 관리</caption>
                                <colgroup>
                                    <col>
                                    <col style="width:30%">
                                    <col style="width:20%">
                                    <col>
                                    <col>
                                    <col>
                                    <col>
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col" class="tbl-hide">번호</th>
                                        <th scope="col">배정사업</th>
                                        <th scope="col" class="tbl-hide">배정기간</th>
                                        <th scope="col">상태</th>
                                        <th scope="col">총배정횟수</th>
                                        <th scope="col" class="tbl-hide">사용횟수</th>
                                        <th scope="col">잔여횟수</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="tbl-hide"></td>
                                        <td colspan="4">등록된 배정사업이 없습니다. </td>
                                        <td class="tbl-hide"></td>
                                        <td class="tbl-hide"></td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                    </div>
                    <div class="tab-cont">
                        <div class="board-list-title">
                           <select class="slt-style" style="width:155px;" title="학교선택" id="selSch" name="selSch" ><option value="">전체</option></select>
                           <select class="slt-style" style="width:155px;" title="교욱청" id="biz">
                             <option value="">전체</option>
                           </select>
                            <div>
                            <p id="selItemInfo1"></p>
                            <!--<p class="day" id="selItemInfo2"></p>-->
                            </div>
                        </div>
                        <div class="board-list-type more" id="schoolLectList">

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="cont-quick">
  <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
<input type="hidden" id="hidebiz" name="hidebiz"/>
<input type="hidden" id="hidesch" name="hidesch"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/schoolLect.js"></script>
<script type="text/jsx;harmony=true">
mentor.schoolLectList = React.render(
  <SchoolLectList url='${pageContext.request.contextPath}/myPage/mySchool/ajax.listSchoolLect.do' />,
  document.getElementById('schoolLectList')
);
mentor.schAssignGroupList = React.render(
  <SchAssignGroupList url='${pageContext.request.contextPath}/myPage/mySchool/ajax.listSchAssignGroup.do' />,
  document.getElementById('schAssignGroupList')
);

</script>
<script type="text/javascript">
$(document).ready(function(){
    $("#selSch").change(function(){
        //학교 보유사업횟수 초기화
        $("#bizGrp,#biz").show();
        if($("#hidesch").val() != ""){
            $("#selSch").val($("#hidesch").val());
        }
        getBizGroup();
    });
    $("#selSch1").change(function(){
        mentor.schAssignGroupList.getList({'schNo':$("#selSch1").val(),'isMore':false});
    });


    getSchoolList();
    getSchAssignGroupList();


    $("#biz").change(function(){
        var selVal = $(this).find("option:selected").val();
        var clasStartDay,clasEndDay,clasPermCnt,clasCnt;
        if(selVal == ""){
            var tmp;
            if($("#bizGrp").val() == ""){
                tmp = mentor.rtnData;
            }else{
                tmp =mentor.biz[$("#bizGrp").val()];
            }
            //updateDisp(tmp);
            updateAllSchoolSet();
        }else{
            var selObj = mentor.rtnData[mentor.rtnData.map(function(e) { return e.bizGrpInfo.grpNo; }).indexOf(selVal)];
            updateDisp(selObj);
        }
        if($("#hidebiz").val() == ""){
            mentor.schoolLectList.getList({'lectApplCnt.schNo':$("#selSch").val(),'setTargtNo':'','setTargtCd':'101601', 'bizGrpInfo.grpNo':selVal,'isMore':false});
        }

    });


});

function getSchoolList(){
    tabAction3();
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/mySchool/ajax.listMySchool.do",
        success: function(rtnData) {
            var totalCnt = 0;
            if(rtnData != null && rtnData.length > 0){
                if(rtnData.length == 1){
                    $("#singleSchArea").html('학교<em>{0}</em>'.format(rtnData[0].schNm));
                    $("#singleSchArea").show();
                }else{
                    $("#selSchArea").show();
                }
                //$("#selSch").loadSelectOptions(rtnData, rtnData[0].schNo, "schNo", "schNm", 0).change();
                var selectedSchNo = ${empty param.schNo} ? rtnData[0].schNo : "${param.schNo}";
                $("#selSch").loadSelectOptions(rtnData, selectedSchNo, "schNo", "schNm", 0).change();

            }else{
                $("#singleSchArea").html('학교<em>{0}</em>'.format("0"));
            }

        }
    });
}


function getSchAssignGroupList(){
tabAction3();
$("#hidebiz").val("");
$("#hidesch").val("");

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/mySchool/ajax.listMySchool.do",
        success: function(rtnData) {
            var totalCnt = 0;
            if(rtnData != null && rtnData.length > 0){
                var selectedSchNo = ${empty param.schNo} ? rtnData[0].schNo : "${param.schNo}";


                $("#selSch1").loadSelectOptions(rtnData, selectedSchNo, "schNo", "schNm", 0).change();
                 mentor.schAssignGroupList.getList({'lectApplCnt.schNo':$("#selSch1").val(),'isMore':false});
            }else{
                $("#singleSchArea").html('학교<em>{0}</em>'.format("0"));
            }
        }
    });
}


function updateSchoolSet(){
    //학교 자체 잔여횟수/배정횟수 조회
    $.ajax({
        url: "${pageContext.request.contextPath}/layer/ajax.listBizSetInfoBySchool.do",
        data: {"schNo":$("#selSch").val()},
        success: function(rtnData) {
            if(rtnData != null){
                updateDisp(rtnData);
                //$("#selItemInfo1").html('잔여횟수 <em>{0}</em>회 / 배정횟수 {1}회'.format(rtnData.lectApplCnt.clasPermCnt, rtnData.clasCnt));
                //$("#selItemInfo2").html('<span>배정기간</span>{0} ~ {1}'.format(mentor.parseDate(rtnData.clasStartDay).format("yyyy.MM.dd"), mentor.parseDate(rtnData.clasEndDay).format("yyyy.MM.dd")));
            }else{
                $("#selItemInfo1").html('잔여횟수 <em>{0}</em>회 / 배정횟수 {1}회'.format(0, 0));
                $("#selItemInfo2").html('');
                //mentor.schoolLectList.setState({data: [],'totalRecordCount':0});
            }
            //목록 갱신
            if($("#hidebiz").val() == ""){
                mentor.schoolLectList.getList({'lectApplCnt.schNo':$("#selSch").val(),'setTargtNo':'','setTargtCd':'101601', 'bizGrpInfo.grpCd':'','isMore':false});
            }
        },
        error: function(xhr, status, err){
            console.error(this.url, status, err.toString());
            $("#selItemInfo1").val("");
            $("#selItemInfo2").val("");
        }
    });
}

function updateAllSchoolSet(){
    //학교 자체 잔여횟수/배정횟수 조회
    $.ajax({
        url: "${pageContext.request.contextPath}/layer/ajax.listAllBizSetInfoBySchool.do",
        data: {"schNo":$("#selSch").val()},
        success: function(rtnData) {
            updateDisp(rtnData);
            if($("#hidebiz").val() == ""){
                mentor.schoolLectList.getList({'lectApplCnt.schNo':$("#selSch").val(),'setTargtNo':'','setTargtCd':'', 'bizGrpInfo.grpCd':'','isMore':false});
            }
        },
        error: function(xhr, status, err){
            console.error(this.url, status, err.toString());
            $("#selItemInfo1").val("");
            $("#selItemInfo2").val("");
        }
    });
}

function updateDisp(listInfo){
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1; //January is 0!

    var yyyy = today.getFullYear();
    if(dd<10){
        dd='0'+dd
    }
    if(mm<10){
        mm='0'+mm
    }
    var today = yyyy+mm+dd;
    var clasStartDay,clasEndDay,clasPermCnt,clasCnt;
    var clasDateType= "";
    if(listInfo != null && Array.isArray(listInfo) && listInfo.length > 0){
        clasStartDay = Math.min.apply(Math, listInfo.map(function(e) { return e.clasStartDay; }));
        clasEndDay = Math.max.apply(Math, listInfo.map(function(e) { return e.clasEndDay; }));
        if(today < clasStartDay){
           clasDateType = "예정";
        }else if(today > clasStartDay && today <= clasEndDay){
            clasDateType = "진행중";
        }else{
            clasDateType = "종료";
        }

        clasApplCnt = listInfo.map(function(e) { return e.lectApplCnt.clasApplCnt; }).reduce(function(a,b){return a+b});
        clasPermCnt = listInfo.map(function(e) { return e.lectApplCnt.clasPermCnt; }).reduce(function(a,b){return a+b});
        clasCnt = listInfo.map(function(e) { return e.clasCnt; }).reduce(function(a,b){return Number(a)+Number(b)});
        if(clasPermCnt > 0){
            clasCnt = clasApplCnt+clasPermCnt;
        }
        $("#selItemInfo1").html('<strong>배정횟수 {1}회 / 잔여횟수 <em>{0}</em>회</strong>'.format(clasPermCnt, clasCnt) + " ("+clasDateType+")");
        $("#selItemInfo2").html('<span>배정기간</span>{0} ~ {1}'.format(mentor.parseDate(clasStartDay).format("yyyy.MM.dd"), mentor.parseDate(clasEndDay).format("yyyy.MM.dd")));
    }else if(listInfo != null && listInfo.lectApplCnt != null){

        if(today < listInfo.clasStartDay){
           clasDateType = "예정";
        }else if(today > listInfo.clasStartDay && today <= listInfo.clasEndDay){
            clasDateType = "진행중";
        }else{
            clasDateType = "종료";
        }
        var clasCnt = 0;
        if(listInfo.lectApplCnt.clasPermCnt > 0){
            clasCnt = listInfo.lectApplCnt.clasPermCnt + listInfo.lectApplCnt.clasApplCnt;
        }else{
            clasCnt = listInfo.clasCnt;
        }

        $("#selItemInfo1").html('배정횟수 {1}회 / 잔여횟수 <em>{0}</em>회'.format(listInfo.lectApplCnt.clasPermCnt, clasCnt) + " ("+clasDateType+")");
        $("#selItemInfo2").html('<span>배정기간</span>{0} ~ {1}'.format(mentor.parseDate(listInfo.clasStartDay).format("yyyy.MM.dd"), mentor.parseDate(listInfo.clasEndDay).format("yyyy.MM.dd")));
    }else{
        //$("#selItemInfo1").html('배정횟수 {1}회 / 잔여횟수 <em>{0}</em>회 '.format(0, 0));
        $("#selItemInfo1").html('보유 횟수가 없습니다.');
        $("#selItemInfo2").html('');
    }
}

function initSelectToCode(supCd,target){
    //설정 대상 selectbox
    $.ajax({
        url: "${pageContext.request.contextPath}/code.do",
        data : {"supCd":supCd},
        contentType: "application/json",
        dataType: 'json',
        success: function(rtnData) {
            if(rtnData != null && rtnData.length > 0) {
                target.loadSelectOptions(rtnData, "", "cd", "cdNm", 0).change();
            }
        }
    });
}

function getBizGroup(){
    $.ajax({
        url: "${pageContext.request.contextPath}/layer/ajax.listBizSetGrp.do",
        data: {  schNo : $("#selSch").val()},
        success: function(rtnData) {
            mentor.rtnData = rtnData;
            if(rtnData != null && rtnData.length > 0){
                mentor.bizGrp = [];
                mentor.biz = [];
                for(var i=0; i<rtnData.length ; i++){
                    var obj = rtnData[i];
                    if(mentor.biz.map(function(e) { return e.grpNo; }).indexOf(obj.bizGrpInfo.grpNo)<0){
                        mentor.biz.push({'grpNo':obj.bizGrpInfo.grpNo,'grpNm':obj.bizGrpInfo.grpNm});

                    }

                }
                $("#biz").loadSelectOptions(mentor.biz, "", "grpNo", "grpNm", 1).change();

                if($("#hidebiz").val() != ""){
                    $("#biz").val($("#hidebiz").val());

                    var clasStartDay,clasEndDay,clasPermCnt,clasCnt;
                    setTimeout("schoolLect_time()", 300);
                }else{
                    updateAllSchoolSet();
                }

            }else{
                mentor.schoolLectList.setState({data: [],'totalRecordCount':0});
                $("#biz").hide().emptySelect(1);
            }
        }
    });
}

function goLectureView(lectSer, lectTims, schdSeq){
    var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq;
    $(location).attr('href', url);
}

function goMentorView(lectrMbrNo){
    var url = mentor.contextpath + "/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo="+lectrMbrNo;
    $(location).attr('href', url);
}
function goLectureInfo(clasData){
    $("#hidesch").val($("#selSch1").val());
    $("#hidebiz").val(clasData.bizGrpInfo.grpNo);
    $("#lessonTab03").click();


}
function schoolLect_time(){
var selVal = $("#hidebiz").val();
$("#hidebiz").val("");
$("#hidesch").val("");
var selObj = mentor.rtnData[mentor.rtnData.map(function(e) { return e.bizGrpInfo.grpNo; }).indexOf(selVal)];
updateDisp(selObj);
mentor.schoolLectList.getList({'lectApplCnt.schNo':$("#selSch").val(),'setTargtNo':'','setTargtCd':'101601', 'bizGrpInfo.grpNo':$("#biz").val(),'isMore':false});
}
</script>
