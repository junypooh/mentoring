<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react-tooltip.min.js"></script>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">마이페이지</span>
        <span>나의교실</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">승인관리</h2>
        <p class="tit-desc-txt">승인관리는 PC web에서 교실 승인, 교사, 학생, 대표교사관리를 할 수 있습니다. <br />모바일에서 확인만 가능합니다.	</p>
        </p>
        <div class="myclass-cont">
            <div class="tab-action">
                <ul class="tab-type1 tab03">
                    <li class="active"><a href="#" onclick="tabOpen('1');">교실승인관리</a></li>
                    <li><a href="#" id="lessonTab02" onclick="tabOpen('2');">교실관리</a></li>
                    <li><a href="#" id="lessonTab03" onclick="tabOpen('3');">대표교사관리</a></li>
                </ul>
                <div class="tab-action-cont">
                    <!-- 교실승인관리 -->
                    <div class="tab-cont active">
                        <div class="board-list-title">
                            <div class="fl">
                                <select id="selSch1" name="selSch" onchange="schoolInfo1(this)">

                                </select>
                            </div>
                            <div>
                                <strong>총 <em id="totalCnt1">0</em>건</strong>
                            </div>
                        </div>
                        <div class="board-list-type more">
                            <!-- 나의 교실 정보 -->
                            <div id="myClassRecognizeList">
                            </div>
                        </div>
                    </div>
                    <div class="tab-cont">
                        <div class="board-list-title">
                            <div class="fl">
                                <select id="selSch2" name="selSch" onchange="schoolInfo2(this)">

                                </select>
                            </div>
                            <div>
                                <strong>총 <em id="totalCnt2">0</em>건</strong>
                            </div>
                        </div>
                        <div class="board-list-type more">
                            <div id="myClassroomList"></div>
                        </div>
                    </div>
                    <div class="tab-cont">
                        <div class="board-list-title">
                            <div class="fl">
                                <select id="selSch3" name="selSch" onchange="schoolInfo3(this)">

                                </select>
                                <a href="#myClassPop3" class="btn-type1 hide-btn" onclick="tchrPop();">대표교사 추가</a>
                            </div>
                            <div>
                                <strong>총 <em id="totalCnt3">0</em>건</strong>
                            </div>
                        </div>
                        <div class="board-list-type more">
                            <div id="myTchrClassList"></div>
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
<div class="layer-pop-wrap my-class-reg" id="myClassPop2">
    <div class="layer-pop m-blind">
        <div class="layer-header">
            <strong class="title">나의 교실 등록</strong>
        </div>
        <div class="layer-cont" id="popupStep1">
            <div class="tbl-style3">
                <form:form id="classSearchForm">
                <table>
                    <caption>나의 교실 등록 - 학교선택, 학교명</caption>
                    <colgroup>
                        <col style="width:21%" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="schInfo.schClassCd">학교선택</label></th>
                            <td>
                                <div class="select-grp">
                                    <select name="schInfo.schClassCd" class="slt-style" title="학교선택">
                                        <option value="">전체</option>
                                    <c:forEach items="${code100494}" var="item">
                                        <option value="${item.cd}" >${item.cdNm }</option>
                                    </c:forEach>
                                    </select>
                                    <select name="schInfo.sidoNm" id="sidoNm" class="slt-style" title="지역선택(도/시)">
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
                            <th scope="row"><label for="schInfo.schNm">학교명</label></th>
                            <td><input type="text" name="schInfo.schNm" class="inp-style" title="학교명" /></td>
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
                <div class="tbl-style2  no-line" id="classList"></div>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 cancel">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep3">
            <div class="box-style">
                <strong class="title-style"><em>해당 교실을 등록</em>하시겠습니까?</strong>
                <div class="box-style2 class"><form:form id="insertClassroomForm">
                    <p><strong>학교 명:</strong> <span id="dispSchNm"></span><input name="schNm" id="targetSchNm" type="hidden"/><input name="schNo" id="targetSchNo" type="hidden"/></p>
                    <div class="class-opt" style="padding-left: 0px;text-align: center;">
                        <span>
                            <strong>선택</strong>
                            <label class="radio-skin checked" title="반">
                                <input type="radio" name="clasRoomTypeCd" value="101522"/>반
                            </label>
                            <label class="radio-skin" title="그룹">
                                <input type="radio" name="clasRoomTypeCd" value="101523"/>그룹
                            </label>
                            <label class="radio-skin" title="동아리">
                                <input type="radio" name="clasRoomTypeCd" value="101705"/>동아리
                            </label>
                        </span>
                        <span id="step3ClassName" style="width: 450px;">
                            <strong>교실명</strong>
                            <select class="slt-style" title="학년명" id="clasRoomNm1">
                                <option value="">선택</option>
                                <c:forEach begin="1" end="6" var="item"><option value="${item}">${item}</option></c:forEach>
                            </select><label title="학년">학년</label>
                            <select class="slt-style" title="교실명" id="clasRoomNm2">
                                <option value="">선택</option>
                                <c:forEach begin="1" end="15" var="item"><option value="${item}">${item}</option></c:forEach>
                            </select><label title="반">반</label>
                        </span>
                        <span style="display:none;width: 450px;" id="step3GroupName">
                            <strong>그룹명</strong>
                            <input type="text" id="clasRoomNm" name="clasRoomNm" title="그룹명" maxlength="30" />
                        </span>
                        <span style="display:none;width: 450px;" id="step3ClubName">
                            <strong>동아리명</strong>
                            <input type="text" id="clasRoomNm3" name="clasRoomNm3" title="동아리명" maxlength="30" />
                        </span>
                    </div>
                </form:form></div>
            </div>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup" onClick="registClass()">등록</a>
                <a href="javascript:void(0)" class="btn-type2 cancel">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep4">
            <div class="box-style">
                <strong class="title-style"><em>교실 등록이 완료 되었습니다.</em><br>교실 신청관리 현황 상태를 확인해주세요.</strong>
            </div>
            <span class="pass-point"><span>중요</span>신청된 교실은 학교 관리자 또는 대표교사 승인 후 나의 교실 정보에서 확인할 수 있습니다.</span>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup cancel" onclick="refreshMyClassroom()">확인</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep5">
            <div class="box-style">
                <strong class="title-style">이미 등록된 교실입니다.</strong>
            </div>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup cancel" onclick="refreshMyClassroom()">확인</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>



</div>
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
<div class="layer-pop-wrap my-class-reg" id="myClassPop3">

 <div class="layer-pop m-blind">
        <div class="layer-header">
            <strong class="title">대표교사 추가</strong>
        </div>
        <div class="layer-cont" style="display:none" id="popupStep6">
            <div class="tbl-style">
                <table>
                    <caption>대표교사 검색 - 교사명, 아이디</caption>
                    <colgroup>
                        <col style="width:21%">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="teacherNm">교사명</label></th>
                            <td>
                                <input type="text" id="teacherNm" class="inp-style" title="교사명">
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="teacherId">아이디</label></th>
                            <td>
                                <input type="text" id="teacherId" class="inp-style" title="아이디">
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="btn-area popup">
                    <a href="#" class="btn-type2 search" onclick="openTchrPopup();"><span>검색</span></a>
                </div>
            </div>
            <p class="search-result">검색 결과</p>
            <div class="layer-pop-scroll">
                <div class="tbl-style2 no-pl" id="tchrInfo">
                    <table>
                        <caption>대표 교사 검색결과 - 검색결과와 번호, 교사명, 아이디, 성별, 선택</caption>
                        <colgroup>
                            <col style="width:10%">
                            <col style="width:20%">
                            <col>
                            <col style="width:20%">
                            <col style="width:20%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">교사명</th>
                                <th scope="col">아이디</th>
                                <th scope="col">성별</th>
                                <th scope="col" class="none-line">선택</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 cancel" onclick="tchrPopClose();">닫기</a>
            </div>
            <a href="#" class="layer-close" onclick="tchrPopClose();">팝업 창 닫기</a>
        </div>
    </div>

</div>
<div class="layer-pop-wrap my-class-reg" id="myClassPop4">
    <div class="layer-pop class m-blind">
        <div class="layer-header">
            <strong class="title" id="approveTitle">승인 이력 확인</strong>
        </div>
        <div class="layer-cont">
            <div class="tbl-style3">
                <table>
                    <caption>승인 이력 확인 - 승인일, 승인자, 사유</caption>
                    <colgroup>
                        <col style="width:25%">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" id="approveType">승인일</th>
                            <td id="approveDate"></td>
                        </tr>
                        <tr>
                            <th scope="row">승인자</th>
                            <td id="approveName"></td>
                        </tr>
                        <tr id="approveYn">
                            <th scope="row">사유</th>
                            <td id="approveDesc"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup" onclick="popClose();">확인</a>
            </div>
            <a href="#" class="layer-close" onclick="popClose();">팝업 창 닫기</a>
        </div>
    </div>
</div>
<div class="layer-pop-wrap my-class-reg" id="myClassPop5" >
    <div class="layer-pop class m-blind">
        <div class="layer-header">
            <strong class="title">반려사유</strong>
        </div>
        <div class="layer-cont">
            <div class="box-style none-border2">
                <strong class="title-style">반려 사유를 입력해주세요</strong>
                <form:form id="rejectRoomReq"><input type="hidden" name="reqSer" id="reqSer"/>
                <div class="box-style2 border">
                    <strong><label for="reason">반려사유</label></strong>
                    <input type="text" name="rjctRsnSust" id="rjctRoomRsnSust" title="반려사유 입력란">
                </div>
                </form:form>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup" onclick="rejectRoomReq();">확인</a>
            </div>
            <a href="#" class="layer-close" onclick="popRejectClose();">팝업 창 닫기</a>
        </div>
    </div>
</div>
<form id='schRpsForm' method='POST'>
</form>
<script type="text/javascript">
function tabOpen(num){
    tabAction3();
    getSchoolList(num);
}
getSchoolList(1);
function getSchoolList(num){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/mySchool/ajax.listMyRecSchool.do",
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
                $("#selSch"+num).loadSelectOptions(rtnData, selectedSchNo, "schNo", "schNm", 0).change();
            }else{
                $("#singleSchArea").html('학교<em>{0}</em>'.format("등록된 학교가 없습니다."));
            }
        }
    });
}
function schoolInfo1(schInfo){

    mentor.myClassRecognizeList.getList({'currentPageNo':1,'isMore':false,'schNo':schInfo.value});
    //mentor.myClassroomList.getList({'isMore':false,'schNo':schInfo.value});

}
function schoolInfo2(schInfo){
    //mentor.myClassRecognizeList.getList({'isMore':false,'schNo':schInfo.value});
    mentor.myClassroomList.getList({'currentPageNo':1,'isMore':false,'schNo':schInfo.value});

}

function schoolInfo3(schInfo){
    //mentor.myClassRecognizeList.getList({'isMore':false,'schNo':schInfo.value});
    mentor.myTchrClassList.getList({'currentPageNo':1,'isMore':false,'schNo':schInfo.value});

}

function goPage(curPage){
    mentor.myClassRecognizeList.getList({'currentPageNo':curPage,'schNo':$("#selSch1").find("option:selected").val()});
}

function goPage2(curPage){
    mentor.myClassroomList.getList({'currentPageNo':curPage,'schNo':$("#selSch2").find("option:selected").val()});
}

function goPage3(curPage){
    mentor.myTchrClassList.getList({'currentPageNo':curPage,'schNo':$("#selSch3").find("option:selected").val()});
}

</script>


<script type="text/javascript">
$(document).ready(function(){
    $("input[name='clasRoomTypeCd']").change(function(){
        if($(this).val() == "101522"){
            $("#step3ClassName").show();
            $("#step3GroupName").hide();
            $("#step3ClubName").hide();
        }else if($(this).val() == "101523"){
            $("#step3ClassName").hide();
            $("#step3GroupName").show();
            $("#step3ClubName").hide();
        }else{
            $("#step3ClassName").hide();
            $("#step3GroupName").hide();
            $("#step3ClubName").show();
        }
    });
    $("#classSearchForm").submit(function(){
        $("#searchClassBtn").click();
        return false;
    });
    $("#searchClassBtn").click(function(){
        if($("input[name='schInfo.schNm']").val().isEmpty()){
            alert("학교명을 입력해 주세요");
            return;
        }
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

    if('${param.tabOpen}' != ''){
        $("#lessonTab02").click();
        goPage2(1);
    }
});

function rejectReq(){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestReject.do",
        data : $("#rejectForm").serialize(),
        success: function(rtnData) {
            goPage2(1);
        }
    });
}

function rejectRoomPop(classData){
    $("#reqSer").val(classData.reqSer);
    $("#rjctRoomRsnSust").val("");
    $("#myClassPop5").show();
    updatePosition();
    $('body').addClass('dim');
}
function rejectRoomPopClose(){
    $("#rjctRoomRsnSust").val("");
    $("#myClassPop5").hide();
    $('body').removeClass('dim');
}

// 교실승인관리 반려
function rejectRoomReq(){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestReject.do",
        data : $("#rejectRoomReq").serialize(),
        success: function(rtnData) {
            $("#myClassPop5").hide();
            $('body').removeClass('dim');
            goPage(1);
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
            goPage2(1);
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
            goPage2(1);
        }
    });
}

function approveRoomSingle(classData){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestApprove.do",
        data : {'listClasRoomRegReqHist[0].reqSer':classData.reqSer,'listClasRoomRegReqHist[0].clasRoomSer':classData.clasRoomSer},
        success: function(rtnData) {
            alert("정상적으로 처리되었습니다.");
            goPage(1);
        }
    });
}

function approvePopInit(){
    $("#approvePopStep1").show();
    $("#approvePopStep2").hide();
    $("#approvePopStep3").hide();
}

function reject(classData){
    $("#approvePopStep2SchNm").text(classData.schInfo.schNm);
    $("#approvePopStep2ClaNm").text(classData.clasRoomNm);
    $("#approvePopStep2MbrNm").text(classData.reqMbrNm);
    $("#approvePopStep2ReqSer").val(classData.reqSer);

    $("#approvePopStep1").hide();
    $("#approvePopStep3").hide();
    $("input[name='rjctRsnSust']").val("");
    $("#approvePopStep2").show();
}

function initPopup(){
    $("div.layer-cont[id^='popupStep']").hide();
    $("div.layer-cont[id^='popupStep']").find("select").val("");
    $("div.layer-cont[id^='popupStep']").find("input[type='text']").val("");
    $("input[name='clasRoomTypeCd'][value='101522']").prop("checked", true).change();

    $("#popupStep1").show();
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

function tchrPop(){

    $("#myClassPop3").show();
    $("#popupStep6").show();
    updatePosition();
    $('body').addClass('dim');

}

function tchrPopClose(){
    $("#myClassPop3").hide();
    $("#popupStep6").hide();
    $('body').removeClass('dim');
}

function approvePop(classData){
    var approveType = "";
    if(classData.regStatCd == '101526'){
        approveType = "승인";
        $("#approveTitle").text("승인 이력 확인");
        $("#approveYn").hide();
    }else{
        approveType = "반려";
        $("#approveTitle").text("반려 이력 확인");
        $("#approveYn").show();
    }
    $("#approveDate").text((new Date(classData.authDtm)).format("yyyy.MM.dd HH:mm")+" ("+approveType+")");
    if(classData.authMbrNm != null){
        $("#approveName").text(classData.authMbrNm);
    }
    if(classData.rjctRsnSust != null){
        $("#approveDesc").text(classData.rjctRsnSust);
    }

    $("#myClassPop4").show();
    $("#popupStep7").show();
    updatePosition();
    $('body').addClass('dim');


}

function popClose(){
    $("#myClassPop4").hide();
    $("#popupStep7").hide();
    $('body').removeClass('dim');
}

function popRejectClose(){
    $("#myClassPop5").hide();
    $('body').removeClass('dim');
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
        case "101705":
                    if($("input[name='clasRoomNm3']").val().isEmpty()){
                        alert("동아리명을 입력하세요");
                        return;
                    }
                    $("input[name='clasRoomNm']").val($("input[name='clasRoomNm3']").val());
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

function removeClassRoom(classRoomSer,applyCnt,registCnt){

    if(confirm("선택한 교실을 삭제 하시겠습니까?")){
        $.ajax({
                    url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.removeClassRoomInfo.do",
                    data : {'clasRoomSer':classRoomSer},
                    success: function(rtnData) {
                        if(rtnData > 0){
                            alert('삭제되었습니다.');
                            goPage2();
                        }else{
                            alert('신청된 수업정보가 존재하여 삭제가 불가합니다.');
                        }
                    }
                });
    }

}

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

function openApprovePopup(clasRoomSer, cnt){
    if(cnt > 0){
        $("#approvePopStep1").show();
        $("#approvePopStep2").hide();
        $("#approvePopStep3").hide();
        $.ajax({
            url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.listApplyStudentSchInfo.do",
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
            url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.listApplyStudentSchInfo.do",
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



</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/myClassroomRecognition.js"></script>
<script type="text/javascript">

var selVal = $(this).find("option:selected").val();
mentor.myClassroomList = React.render(
  React.createElement(MyClassList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.myClassroomTeacher.do', schNo:$("#selSch2").find("option:selected").val()}),
  document.getElementById('myClassroomList')
);



mentor.myClassRecognizeList = React.render(
  React.createElement(MyClassRecognizeList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.listClassroomRecognize.do', contextPath: mentor.contextpath, schNo:$("#selSch1").find("option:selected").val()}),
  document.getElementById('myClassRecognizeList')
);

mentor.ClassList = React.render(
  React.createElement(ClassList),
  document.getElementById('classList')
);

mentor.StudentApproveList = React.render(
  React.createElement(StudentApproveList),
  document.getElementById('studentApproveList')
);

mentor.StudentClassMemberList = React.render(
  React.createElement(StudentClassMemberList),
  document.getElementById('studentClassMemberList')
);

mentor.myTchrClassList = React.render(
  React.createElement(MyTchrClassList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.listSchRpsTchrInfo.do', contextPath: mentor.contextpath, schNo:$("#selSch3").find("option:selected").val()}),
  document.getElementById('myTchrClassList')
);


function openTchrPopup(){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.listTchrInfo.do",
        data : {'schInfo.username':$("#teacherNm").val(), 'schInfo.userId':$("#teacherId").val(),'schInfo.schNo':$("#selSch3").find("option:selected").val()},
        success: function(rtnData) {
            var totalCnt = 0;
            if(rtnData != null){
                totalCnt = rtnData.length;
            }
            //mentor.tchrInfo.setState({data: rtnData,'totalRecordCount':totalCnt});
            mentor.tchrInfo.setState({data: rtnData,'totalRecordCount':totalCnt});
        }
    });

}



function goMyTchr(mbrNo){
    var inputs = "";
    inputs+="<input type='hidden' name='listSchInfo[0].schNo' value='"+ $("#selSch3").find("option:selected").val() +"' />";
    inputs+="<input type='hidden' name='listSchInfo[0].mbrNo' value='"+mbrNo+"' />";
    inputs+="<input type='hidden' name='listSchInfo[0].schMbrCualfCd' value='101698' />";
    inputs+="<input type='hidden' name='listSchInfo[0].cualfRegStatCd' value='101702' />";

    $('#schRpsForm').empty().append(inputs);

    $("#schRpsForm").ajaxForm({
        url : "${pageContext.request.contextPath}/myPage/myClassroom/ajax.insertSchCualf.do",
        dataType: 'text',
        success:function(data, status){
            alert("저장 되었습니다.");
            goPage3(1);
            tchrPopClose();
        }
    }).submit();

}


mentor.tchrInfo = React.render(
  React.createElement(tchrInfo),
  document.getElementById('tchrInfo')
);


function tchrRpsDel(schMbrRollSer){
    if(!confirm('대표교사 권한을 삭제 하시겠습니까?')) {
        return;
    }
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.delTchrRps.do",
        data : {'schMbrRollSer':schMbrRollSer},
        success: function(rtnData) {
            alert("삭제되었습니다.");
            goPage3(1);
        }
    });
}

</script>




