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
        <p class="tit-desc-txt">나의 교실은 교실 신청 관리에서 등록할 수 있습니다.  <br/>
                                신청한 교실은 교실 담당자 승인 후 나의 교실 정보 목록에서 확인할 수 있습니다.</p>
        <div class="board-list-type more">
            <div id="myClassroomInfoList"></div>
        </div>
    </div>
</div>
<div class="cont-quick">
    <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>

<script type="text/javascript">
$(document).ready(function(){

});
</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/myClassroomStudent.js"></script>
<script type="text/javascript">
mentor.myClassroomInfoList = React.render(
  React.createElement(MyClassInfoList, {url:'${pageContext.request.contextPath}/myPage/myClassroom/ajax.myClassroomStudent.do', contextPath: mentor.contextpath}),
  document.getElementById('myClassroomInfoList')
);
function refreshMyClassroom(){
    mentor.myClassroomInfoList.getList({'isMore':false});
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
            refreshMyClassroom();
        }
    });
}

function replaceAll(str, searchStr, replaceStr) {

    return str.split(searchStr).join(replaceStr);
}

</script>