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
        <h2 class="txt-type">나의교실 상세정보</h2>
        <p class="tit-desc-txt">나의 교실 상세 정보입니다. <br />반대표로 설정된 학생은 교실 담당자로 지정되어 해당 반 학생 승인/반려 및 수업 신청을 할 수 있습니다.</p>
        <div class="myclass-cont">
            <div id="memberList"></div>
        </div>
    </div>
</div>
<a href="#approvePop" class="btn-border-type layer-open" title="등록 팝업 - 열기" style="display:none" id="approvePopBtn" >등록 신청중</a>
<div class="layer-pop-wrap" id="approvePop">
    <div class="layer-pop" >
        <div class="layer-header">
            <strong class="title">승인 반려</strong>
        </div>
        <div class="layer-cont" id="approvePopStep2">
            <div class="box-style">
                <strong class="title-style"><em>해당 학생의 등록 신청을 반려</em>하시겠습니까?</strong>
                <div class="box-style2 src-class"><form:form id="rejectForm"><input type="hidden" name="reqSer" id="approvePopStep2ReqSer"/>
                    <p><strong>학교 명</strong><span id="approvePopStep2SchNm">대전 둔원 고등학교</span></p>
                    <p><strong>반 명</strong><span id="approvePopStep2ClaNm">1-6</span></p>
                    <p><strong>학생 명</strong><span id="approvePopStep2MbrNm">홍길동</span></p>
                    <p><strong>반려사유</strong><input name="rjctRsnSust" class="inp-style" title="반려사유" maxlength="30"/></p>
                </form:form></div>
            </div>
            <div class="btn-area popup">
                <a href="#" class="btn-type2 popup" onClick="rejectReq()">반려</a>
                <a href="#" class="btn-type2 layer-close" >취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<input type="hidden" id="mbrClassCd" name="mbrClassCd" value="${param.mbrClassCd}"/>
<script type="text/javascript">
function refreshMyClassroom(){
    mentor.memberList.getList({'isMore':false,'clasRoomSer':mentor.memberList.props.clasRoomSer,'schNm':mentor.memberList.props.schNm, 'mbrClassCd':mentor.memberList.props.mbrClassCd, 'clasRoomNm':mentor.memberList.props.clasRoomNm});
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

function reject(classData){
    $("#approvePopBtn").click();
    $("#approvePopStep2SchNm").text(classData.clasRoomInfo.schInfo.schNm);
    $("#approvePopStep2ClaNm").text(classData.clasRoomInfo.clasRoomNm);
    $("#approvePopStep2MbrNm").text(classData.reqMbrNm);
    $("#approvePopStep2ReqSer").val(classData.reqSer);

}


function removeClassRoomStudent(classData){
    if(confirm("선택한 학생을 삭제 하시겠습니까?")){
        $.ajax({
                url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.removeClassroom.do",
                data : {"tchrMbrNo":classData.reqMbrNo,"clasRoomSer": classData.clasRoomSer},
                success: function(rtnData) {
                    alert('삭제되었습니다.');
                    $("#approvePop .layer-close").click();
                    refreshMyClassroom();
                }
            });
    }
}

function rejectReq(classData){
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.requestReject.do",
        data : $("#rejectForm").serialize(),
        success: function(rtnData) {
            $("#approvePop .layer-close").click();
            refreshMyClassroom();
        }
    });
}

// 반대표 설정
function setClasRps(classData) {
    var confirmMsg = '';

    if(classData.clasRoomCualfCd != "101691") {
        clasRoomCualfCd = '101691';
        confirmMsg = '선택한 학생에게 반대표 권한을 부여하시겠습니까?';
    } else {
        clasRoomCualfCd = '101690';
        confirmMsg = '선택한 학생의 반대표 권환을 해지 하시겠습니까?';
    }

    if(!confirm(confirmMsg)) {
        return;
    }
    $.ajax({
        url: "${pageContext.request.contextPath}/myPage/myClassroom/ajax.rpsClass.do",
        data : {'reqSer':classData.reqSer, 'clasRoomCualfCd':clasRoomCualfCd, 'clasRoomSer':'${param.clasRoomSer}'},
        success: function(rtnData) {
            if(clasRoomCualfCd == '101691'){
                alert('권한이 설정되었습니다.');
            }else{
                alert('권한이 해지되었습니다.');
            }
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
            refreshMyClassroom();
        }
    });
}
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/myClassroom.js"></script>
<script type="text/jsx;harmony=true">

mentor.memberList = React.render(
  <MemberList url='${pageContext.request.contextPath}/myPage/myClassroom/ajax.listApplyStudent.do' clasRoomSer="<c:out value="${param.clasRoomSer}" />" myClass="<c:out value="${param.schNm}" />" clasRoomNm="<c:out value="${param.clasRoomNm}" />" mbrClassCd="<c:out value="${param.mbrClassCd}" />" />,
  document.getElementById('memberList')
);
</script>