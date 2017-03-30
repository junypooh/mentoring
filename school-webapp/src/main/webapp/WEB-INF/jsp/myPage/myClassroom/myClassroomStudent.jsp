<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">마이페이지</span>
        <span>나의교실</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">나의교실</h2>
        <p class="tit-desc-txt">나의 교실은 교실 가입 신청에서 등록할 수 있습니다.<br />
        					신청한 교실은 교실 담당자 승인 후 나의 교실 정보 목록에서 확인할 수 있습니다.
        </p>
        <div class="myclass-cont">
            <div class="tab-action">
            <ul class="tab-type1 tab02"> <!-- 탭메뉴 3개일 때 -->
                <li class="active"><a href="#" onclick="refreshMyClassroom1();">나의 교실 현황</a></li>
                <li><a href="#" id="lessonTab02" onclick="refreshMyClassroom3();" style="display:none" >나의 관리 교실</a></li>
                <li><a href="#" id="lessonTab03" onclick="refreshMyClassroom2();">교실 가입 신청</a></li>
            </ul>
            <div class="tab-action-cont">
                <!-- 나의 교실 정보 -->
                <div class="tab-cont active" id="tab1">
                    <div class="board-list-type more">
                        <div id="myClassroomInfoList"></div>
                    </div>
                </div>
                <div class="tab-cont" id="tab2">
                    <div class="board-list-type more">
                        <div id="myManagementClassroomList"></div>
                    </div>
                </div>
                <div class="tab-cont" id="tab3">
                    <div class="title-group">
                        <div class="btn">
                            <a href="#myClassPop" class="btn-border-type layer-open m-none hide-btn" onClick="initPopup()">교실 찾기</a>
                        </div>
                    </div>
                    <div class="board-list-type more">
                        <div id="myClassroomList"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="cont-quick">
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
<input type="hidden" id="clasRoomCualfCd" name="clasRoomCualfCd" value="${clasRoomCualfCd}"/>
<!-- 나의 교실 등록 -->
<div class="layer-pop-wrap my-class-reg" id="myClassPop">
    <div class="layer-pop m-blind">
        <div class="layer-header">
            <strong class="title">나의 교실 등록</strong>
        </div>
        <div class="layer-cont" id="popupStep1">
            <div class="tbl-style3 teacher">
                <form:form id="classSearchForm">
                <table>
                    <caption>나의 교실 등록 - 학교선택,학교명,교사명</caption>
                    <colgroup>
                        <col style="width:21%" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="schoolSelect2">학교선택</label></th>
                            <td>
                                <div class="select-grp">
                                    <select name="schInfo.schClassCd" class="slt-style" title="학교선택">
                                        <option value="">전체</option>
                                    <c:forEach items="${code100494}" var="item">
                                        <option value="${item.cd}" >${item.cdNm }</option>
                                    </c:forEach>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="schoolAddr">지역/시군구</label></th>
                            <td>
                                <div class="select-grp">
                                    <select name="schInfo.sidoNm" id="sidoNm" class="slt-style" title="지역선택">
                                        <option value="">지역선택(도/시)</option>
                                    <c:forEach items="${code100351}" var="item">
                                        <option value="${item.cdNm}" >${item.cdNm }</option>
                                    </c:forEach>
                                    </select>
                                    <select name="schInfo.sgguNm" id="sgguNm" class="slt-style" title="지역선택(구/군)">
                                        <option value="">지역선택(구/군)</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="schoolName2">학교명</label></th>
                            <td><input type="text" name="schInfo.schNm" class="inp-style" title="학교명" /></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="teacherName">교실 담당자</label></th>
                            <td><input type="text" name="tchrMbrNm" class="inp-style" title="교실 담당자" /></td>
                        </tr>
                    </tbody>
                </table>
                </form:form>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 search" id="searchClassBtn"><span>검색</span></a>
                <a href="#" class="btn-type2 cancel">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep2">
            <div class="layer-pop-scroll line">
                <div class="tbl-style2 complete no-line" id="classList"></div>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup" onclick="$('#popupStep2_close').click()">확인</a>
            </div>
            <a href="#" class="layer-close" id="popupStep2_close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep3">
            <div class="box-style">
                <strong class="title-style"><em>해당 교실을 등록</em>하시겠습니까?</strong>
                <div class="box-style2 src-class">
                    <p><strong class="long">학교명</strong><span id="popupStep3SchNm"></span></p>
                    <p><strong class="long">유형</strong><span id="popupStep3ClaType"></span></p>
                    <p><strong class="long">교실명</strong><span id="popupStep3ClaNm"></span></p>
                    <p><strong class="long">교실 담당자</strong><span id="popupStep3TchrNm"></span></p>
                </div>
            </div>
            <div class="btn-area popup"><form:form id="clasRoomReqForm"><input type="hidden" name="clasRoomSer" id="popupStep3ClasRoomSer"/>
                <a href="javascript:void(0)" class="btn-type2" onClick="insertClassroomReq()">등록</a>
                <a href="#" class="btn-type2 cancel">취소</a>
            </form:form></div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep4">
            <div class="box-style">
                <strong class="title-style"><em>교실 등록이 완료 되었습니다.</em><br>교실 가입 신청 탭에서 상태를 확인해주세요.</strong>
            </div>
            <span class="pass-point"><span>중요</span>신청된 교실은 학교 관리자 또는 대표교사 승인 후 나의 교실 정보에서 확인할 수 있습니다.</span>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup cancel" onclick="refreshMyClassroom()">확인</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<!-- // 나의 관리 교실 승인 -->
<a href="#approvePop" class="btn-border-type layer-open" title="등록 팝업 - 열기" style="display:none" id="approvePopBtn" >등록 신청중</a>
<div class="layer-pop-wrap" id="approvePop">
    <div class="layer-pop" >
        <div class="layer-header">
            <strong class="title">학생 승인 요청 현황</strong>
        </div>
        <style>

        </style>
        <div class="layer-cont" id="approvePopStep1">
            <form:form id="stduentApproveForm"><div class="tbl-style2 student" id="studentApproveList"></div></form:form>
            <div class="btn-area popup">
                    <a href="javascript:void(0)" class="btn-type2 blue" onClick="approve()">선택 승인</a>
                    <a href="javascript:void(0)" class="btn-type2 popup" onClick="approveAll()">전체 승인</a>
                    <a href="javascript:void(0)" class="btn-type2 cancel">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="approvePopStep2">
            <div class="box-style">
                <strong class="title-style"><em>해당 학생의 등록 신청을 반려</em>하시겠습니까?</strong>
                <div class="box-style2 src-class approval"><form:form id="rejectForm"><input type="hidden" name="reqSer" id="approvePopStep2ReqSer"/>
                    <p><strong>학교</strong><span id="approvePopStep2SchNm"></span></p>
                    <p><strong>교실명</strong><span id="approvePopStep2ClaNm"></span></p>
                    <p><strong>학생</strong><span id="approvePopStep2MbrNm"></span></p>
                    <p><strong>반려사유</strong><input name="rjctRsnSust" class="inp-approval" title="반려사유" maxlength="30"/></p>
                </form:form></div>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup" onClick="rejectReq()">반려</a>
                <a href="#" class="btn-type2" style="min-width:74px;background:#666;font-size:14px;" onClick="cancelRejectReq()">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="approvePopStep3">
            <form:form id="stduentApproveForm"><div class="tbl-style2 student" id="studentClassMemberList"></div></form:form>
            <div class="btn-area popup">
                    <a href="javascript:void(0)" class="btn-type2 cancel">확인</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<!-- // 나의 관리 교실 승인 -->
<!-- //나의 교실 등록 -->
<script type="text/javascript">
var load = "Y";
$(document).ready(function(){
    $("input[name='schInfo.schNm'],input[name='tchrMbrNm']").keypress(function(e){
        if(e.keyCode==13){
            $("#searchClassBtn").click();
        }
    });
    $("#searchClassBtn").click(function(){
        if($("input[name='schInfo.schNm']").val().isEmpty() && $("input[name='tchrMbrNm']").val().isEmpty()){
            alert("학교명 또는 교사명을 입력 해 주세요.");
            return false;
        }else{
            $.ajax({
                url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.listClass.do",
                data : $("#classSearchForm").serialize(),
                success: function(rtnData) {
                    var totalCnt = 0;
                    if(rtnData != null){
                        totalCnt = rtnData.length;
                    }
                    mentor.ClassList.setState({data: rtnData,'totalRecordCount':totalCnt});
                }
            });
            $("#popupStep1").hide();
            $("#popupStep2").show();
            updatePosition();
        }
    });
    $("#classSearchForm").submit(function(){
        $("#searchClassBtn").click();
        return false;
    });


    // 지역시 변경
    $('#sidoNm').change(function() {

        $('#sgguNm').find('option:not(:first)').remove()
            .end().val('').change();

        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/myPage/myClassroom/ajax.sgguInfo.do', {
                data: { sidoNm: this.value },
                success: function(rtnData) {
                    $('#sgguNm').loadSelectOptions(rtnData,'','sgguNm','sgguNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    });
    if('${param.tabOpen}' != ''){
        tabAction3();
        $("#lessonTab02").click();
        refreshMyClassroom2();
    }
});
function initPopup(){

    $("div.layer-cont[id^='popupStep']").hide();
    $("div.layer-cont[id^='popupStep']").find("select").val("");
    $("div.layer-cont[id^='popupStep']").find("input[type='text']").val("");
    $("#popupStep1").show();
    $("#myClassPop").show();
    updatePosition();
}
function registClassroom(clasRoom){
    var classes = clasRoom.reqMbrNm.split(",");
    if(classes.length > 1) {
        clasRoom.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
    } else {
        clasRoom.reqMbrNmText = classes[0];
    }
    $("#popupStep3SchNm").text(clasRoom.schInfo.schNm);
    $("#popupStep3ClaNm").text(clasRoom.clasRoomNm);
    $("#popupStep3TchrNm").text(clasRoom.reqMbrNmText);
    $("#popupStep3ClasRoomSer").val(clasRoom.clasRoomSer);
    $("#popupStep3ClaType").text(clasRoom.clasRoomTypeNm);
    $("#popupStep2").hide();
    $("#popupStep3").show();
    updatePosition();
}
function insertClassroomReq(){
     $.ajax({
         url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.insertClassroomRegReqHist.do",
         data : $("#clasRoomReqForm").serialize(),
         success: function(rtnData) {
             $("#popupStep3").hide();
             $("#popupStep4").show();
             updatePosition();
         }
     });
}
function refreshMyClassroom2(){
    tabAction3();
    mentor.myClassroomList.getList({'isMore':false});
}

</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/myClassroomStudent.js"></script>
<script type="text/javascript">
mentor.myClassroomList = React.render(
  React.createElement(MyClassList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.myClassroomStudent.do', contextPath: mentor.contextpath}),
  document.getElementById('myClassroomList')
);
mentor.ClassList = React.render(
  React.createElement(ClassList),
  document.getElementById('classList')
);

</script>



<script type="text/javascript">
mentor.myClassroomInfoList = React.render(
  React.createElement(MyClassInfoList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.myClassroomStudent.do', contextPath: mentor.contextpath, regStatCd:'101526'}),
  document.getElementById('myClassroomInfoList')
);
function refreshMyClassroom1(){
tabAction3();
    mentor.myClassroomInfoList.getList({'isMore':false, 'regStatCd':'101526'});
}

// 대표교실 설정
function setRpsClas(classData) {
    var confirmMsg = '';
    if(classData.clasRoomInfo.rpsYn == 'Y') {
        rpsYn = 'N';
        confirmMsg = '대표교실 설정을 삭제 하시겠습니까?';
    } else {
        rpsYn = 'Y';
        confirmMsg = '대표교실로 설정 하시겠습니까?';
    }

    if(!confirm(confirmMsg)) {
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestRpsClass.do",
        data : {'reqSer':classData.reqSer, 'rpsYn':rpsYn},
        success: function(rtnData) {
            alert('저장 되었습니다.');
            refreshMyClassroom();
        }
    });
}

// 소속 교실 삭제
function delRpsClas(classData) {

    if(!confirm('삭제 하시겠습니까?')) {
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.removeClass.do",
        data : {'reqSer':classData.reqSer},
        success: function(rtnData) {
            alert('삭제 되었습니다.');
            refreshMyClassroom1();
        }
    });
}

function replaceAll(str, searchStr, replaceStr) {

    return str.split(searchStr).join(replaceStr);
}

</script>











<script type="text/javascript">
mentor.myManagementClassroomList = React.render(
  React.createElement(MyManagementClassList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.myClassroomTeacher.do', contextPath: mentor.contextpath}),
  document.getElementById('myManagementClassroomList')
);

function refreshMyClassroom3(){
tabAction3();
    mentor.myManagementClassroomList.componentDidMount({'isMore':false});
}

// 대표교실 설정
function setRpsClas(classData) {
    var confirmMsg = '';
    if(classData.clasRoomInfo.rpsYn == 'Y') {
        rpsYn = 'N';
        confirmMsg = '대표교실 설정을 삭제 하시겠습니까?';
    } else {
        rpsYn = 'Y';
        confirmMsg = '대표교실로 설정 하시겠습니까?';
    }

    if(!confirm(confirmMsg)) {
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestRpsClass.do",
        data : {'reqSer':classData.reqSer, 'rpsYn':rpsYn},
        success: function(rtnData) {
            alert('저장 되었습니다.');
            refreshMyClassroom1();
        }
    });
}


// 대표교실 설정
function setRpsClas2(classData) {
    var confirmMsg = '';
    if(classData.rpsYn == 'Y') {
        rpsYn = 'N';
        confirmMsg = '대표교실 설정을 삭제 하시겠습니까?';
    } else {
        rpsYn = 'Y';
        confirmMsg = '대표교실로 설정 하시겠습니까?';
    }

    if(!confirm(confirmMsg)) {
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestRpsClass.do",
        data : {'reqSer':classData.reqSer, 'rpsYn':rpsYn},
        success: function(rtnData) {
            alert('저장 되었습니다.');
            refreshMyClassroom3();
        }
    });
}

// 소속 교실 삭제
function delRpsClas2(classData) {

    if(!confirm('삭제 하시겠습니까?')) {
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.removeClass.do",
        data : {'reqSer':classData.reqSer},
        success: function(rtnData) {
            alert('삭제 되었습니다.');
            refreshMyClassroom3();
        }
    });
}

function replaceAll(str, searchStr, replaceStr) {

    return str.split(searchStr).join(replaceStr);
}


$(document).ready(function(){
    $("input[name='clasRoomTypeCd']").change(function(){
        if($(this).val() === "101522"){
            $("#step3ClassName").show();
            $("#step3GroupName").hide();
        }else{
            $("#step3ClassName").hide();
            $("#step3GroupName").show();
        }
    });
    $("#classSearchForm").submit(function(){
        $("#searchClassBtn").click();
        return false;
    });


    // 지역시 변경
    $('#sidoNm').change(function() {

        $('#sgguNm').find('option:not(:first)').remove()
            .end().val('').change();

        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/myPage/myClassroom/ajax.sgguInfo.do', {
                data: { sidoNm: this.value },
                success: function(rtnData) {
                    $('#sgguNm').loadSelectOptions(rtnData,'','sgguNm','sgguNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    });

    enterFunc($("input[name='clasRoomNm']"),registClass);
});

function rejectReq(){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestReject.do",
        data : $("#rejectForm").serialize(),
        success: function(rtnData) {
            $("#approvePop .layer-close").click();
            refreshMyClassroom();
        }
    });
}

function cancelRejectReq(){
    $("#approvePopStep2").hide();
    $("#approvePopStep3").hide();
    $("#approvePopStep1").show();
}

//선생님이 승인 요청한 학생들을 승인
function approve(){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestApprove.do",
        data : $("#stduentApproveForm").serialize(),
        success: function(rtnData) {
            var totalCnt = 0;
            if(rtnData != null){
                totalCnt = rtnData.length;
            }
            $("#approvePop .layer-close").click();
            refreshMyClassroom();
        }
    });
}

function approveAll(){
    $("#stduentApproveForm input:checkbox").each(function () {
       $(this).attr("checked","checked").parent().addClass("checked");
    });
    approve();
}

function approveSingle(reqSer){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestApprove.do",
        data : {'listClasRoomRegReqHist[0].reqSer':reqSer},
        success: function(rtnData) {
            alert("정상적으로 처리되었습니다.");
            $("#approvePop .layer-close").click();
            refreshMyClassroom();
        }
    });
}

function approvePopInit(){
    $("#approvePopStep1").show();
    $("#approvePopStep2").hide();
    $("#approvePopStep3").hide();
}

function reject(classData){
    $("#approvePopStep2SchNm").text(classData.clasRoomInfo.schInfo.schNm);
    $("#approvePopStep2ClaNm").text(classData.clasRoomInfo.clasRoomNm);
    $("#approvePopStep2MbrNm").text(classData.reqMbrNm);
    $("#approvePopStep2ReqSer").val(classData.reqSer);

    $("#approvePopStep1").hide();
    $("#approvePopStep3").hide();
    $("input[name='rjctRsnSust']").val("");
    $("#approvePopStep2").show();
}
function refreshMyClassroom(){
    mentor.myClassroomList.getList({'isMore':false});
}

function inputClass(schInfo){
    $("#dispSchNm").text(schInfo.schNm);
    $("#targetSchNm").val(schInfo.schNm);
    $("#targetSchNo").val(schInfo.schNo);

    if(schInfo.schClassCd == "${code['CD100494_100496_중학교']}" || schInfo.schClassCd == "${code['CD100494_100497_고등학교']}"){
        $("#clasRoomNm1").loadSelectOptions([{'val':'1'},{'val':'2'},{'val':'3'}],"","val","val",1);
    }else{
        $("#clasRoomNm1").loadSelectOptions([{'val':'1'},{'val':'2'},{'val':'3'},{'val':'4'},{'val':'5'},{'val':'6'}],"","val","val",1);
    }
    $("#clasRoomNm2").val("");
    $("#clasRoomNm").val("");
    $("#popupStep2").hide();
    $("#popupStep3").show();
    updatePosition();
}

function addClass(){
    $("#popupStep2").hide();
    $("#popupStep4").show();
    updatePosition();
}

function registClass(){
    if(confirm("나의 교실로 등록 하시겠습니까?")){
        switch($("input[name='clasRoomTypeCd']:checked").val()){
        case "101522":
            if($("#clasRoomNm1").val().isEmpty() || $("#clasRoomNm2").val().isEmpty()){
                alert("학년 반을 선택 하세요");
                return;
            }
            $("input[name='clasRoomNm']").val("{0}학년{1}반".format($("#clasRoomNm1").val(),$("#clasRoomNm2").val()));
            break;
        case "101523":
            if($("input[name='clasRoomNm']").val().isEmpty()){
                alert("그룹명을 입력하세요");
                return;
            }
            break;
        }
        $.ajax({
            url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.insertClassroom.do",
            data : $("#insertClassroomForm").serialize(),
            success: function(rtnData) {
                if(rtnData == '-1'){
                    alert('이미 등록된 교실입니다.');
                }else if(rtnData == '-999'){
                    alert('교실등록에 실패했습니다.[TOMMS연동]');
                }else{
                    $("#popupStep3").hide();
                    $("#popupStep4").show();
                    updatePosition();
                }
            }
        });
    }
}
/*
function removeClassRoom(classRoomSer,applyCnt,registCnt){

    if(confirm("선택한 교실을 삭제 하시겠습니까?")){
        $.ajax({
                    url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.removeClassroom.do",
                    data : {'clasRoomSer':classRoomSer},
                    success: function(rtnData) {
                        if(rtnData > 0){
                            alert('삭제되었습니다.');
                            refreshMyClassroom();
                        }else{
                            alert('신청된 수업정보가 존재하여 삭제가 불가합니다.');
                        }
                    }
                });
    }

}*/
/*
function registClassroom(clasRoom){
    if(clasRoom.clasRoomSer == null){
        clasRoom.schInfo.schNo = clasRoom.schNo;
        inputClass(clasRoom.schInfo);
    }else if(clasRoom.isRegistedRoom == "Y"){
        alert("이미 등록한 교실 입니다.");return;
    }else if(confirm("{0}을 나의 교실로 등록 하시겠습니까?".format(clasRoom.clasRoomNm))){
        $.ajax({
            url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.insertClassroomRegReqHist.do",
            data : {'clasRoomSer':clasRoom.clasRoomSer,'clasRoomInfo.schInfo.schNm':clasRoom.schInfo.schNm,'clasRoomInfo.clasRoomNm':clasRoom.clasRoomNm},
            success: function(rtnData) {
                addClass();
            }
        });
    }
}
*/
function openApprovePopup(clasRoomSer, cnt){
    if(cnt > 0){
        $("#approvePopStep1").show();
        $("#approvePopStep2").hide();
        $("#approvePopStep3").hide();
        $.ajax({
            url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.listApplyStudent.do",
            data : {'clasRoomSer':clasRoomSer,'regStatCd':'101525'},
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null){
                    totalCnt = rtnData.length;
                }
                mentor.StudentApproveList.setState({data: rtnData,'totalRecordCount':totalCnt});
                $("#approvePopBtn").click();
            }
        });
    }
}

function openClassMemberPopup(clasRoomSer, cnt){
    if(cnt > 0){
        $("#approvePopStep1").hide();
        $("#approvePopStep2").hide();
        $("#approvePopStep3").show();
        $.ajax({
            url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.listApplyStudent.do",
            data : {'clasRoomSer':clasRoomSer,'regStatCd':'101526'},
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null){
                    totalCnt = rtnData.length;
                }
                mentor.StudentClassMemberList.setState({data: rtnData,'totalRecordCount':totalCnt});
                $("#approvePopBtn").click();
            }
        });
    }
}

function goMySchool(schNo){
    var url = mentor.contextpath + "/myPage/mySchool/mySchool.do?schNo=" + schNo;
    $(location).attr('href', url);
}
function checkAll(obj){
    var checked = $(obj.target).prop("checked");
    $(obj.target).closest("table").find("tbody input:checkbox").each(function(){
        $(this).prop("checked",checked);
        if(checked){
            $(this).parent().addClass("checked");
        }else{
            $(this).parent().removeClass("checked");
        }
    });
}

function setRpsClassroom(flag, reqSer) {

    var confirmMsg = '';
    if(flag == 'Y') {
        rpsYn = 'N';
        confirmMsg = '대표학교로 설정을 취소 하시겠습니까?';
    } else {
        rpsYn = 'Y';
        confirmMsg = '대표학교로 설정 하시겠습니까?';
    }

    if(!confirm(confirmMsg)) {
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestRpsClassroom.do",
        data : {'reqSer':reqSer, 'rpsYn':rpsYn},
        success: function(rtnData) {
            alert('저장 되었습니다.');
            refreshMyClassroom();
        }
    });
}

function goPage(curPage){
    mentor.myClassroomList.getList({'currentPageNo':curPage});
}



mentor.StudentApproveList = React.render(
  React.createElement(StudentApproveList),
  document.getElementById('studentApproveList')
);

mentor.StudentClassMemberList = React.render(
  React.createElement(StudentClassMemberList),
  document.getElementById('studentClassMemberList')
);
</script>