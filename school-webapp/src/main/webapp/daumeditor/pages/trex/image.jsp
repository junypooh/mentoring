<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/daumeditor/js/popup.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/daumeditor/css/popup.css" type="text/css"  charset="utf-8"/>

<div class="wrapper">
    <div class="header">
        <h1>사진 첨부</h1>
    </div>
    <div class="body">
        <dl class="alert">
            <dt>사진 첨부 확인</dt>
            <dd>
            <form id="frm" action="${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
              <input type="file" name="upload_file" />
            </form>
            </dd>
        </dl>
    </div>
    <div class="footer">
        <p><a href="#" onclick="closeWindow();" title="닫기" class="close">닫기</a></p>
        <ul>
            <li class="submit"><a href="#" id="saveBtn" title="등록" class="btnlink">등록</a> </li>
            <li class="cancel"><a href="#" onclick="closeWindow();" title="취소" class="btnlink">취소</a></li>
        </ul>
    </div>
</div>
<script type="text/javascript">
// <![CDATA[
$(function(){
    $("#saveBtn").click(function(){
        $("#frm").submit();
    });

    $.ajaxSetup({
        headers: { 'X-CSRF-TOKEN': '${_csrf.token}' }
    });

    $("#frm").ajaxForm({
        beforeSubmit : function(data,form,option){
            return true;
        },
        success:function(response,status){
            done(response)
        },
        error:function(){

        }
    });

    //function initUploader()
    {
        var _opener = PopupUtil.getOpener();
        if (!_opener) {
            alert('잘못된 경로로 접근하셨습니다.');
            return;
        }

        var _attacher = getAttacher('image', _opener);
        registerAction(_attacher);
    }

});
function done(response) {
    if (typeof(execAttach) == 'undefined') { //Virtual Function
        return;
    }
    response = JSON.parse(response);

    var protocol = document.location.protocol;
    var host = document.location.host;

     var _mockdata = {
        'imageurl': protocol+'//'+host+'${pageContext.request.contextPath}/fileDown.do?origin=true&fileSer='+response.fileSer,
        'filename': response.oriFileNm,
        'filesize': response.fileSize,
        'imagealign': 'C',
        'originalurl': protocol+'//'+host+'${pageContext.request.contextPath}/fileDown.do?origin=true&fileSer='+response.fileSer,
        'thumburl': protocol+'//'+host+'${pageContext.request.contextPath}/fileDown.do?origin=true&fileSer='+response.fileSer
    };
/*
     var _mockdata = {
        'imageurl': '${pageContext.request.contextPath}/fileDown.do?fileSer='+response.fileSer,
        'filename': response.oriFileNm,
        'filesize': response.fileSize,
        'imagealign': 'C',
        'originalurl': '${pageContext.request.contextPath}/fileDown.do?fileSer='+response.fileSer,
        'thumburl': '${pageContext.request.contextPath}/fileDown.do?fileSer='+response.fileSer
    };
*/
    execAttach(_mockdata);
    closeWindow();
}

// ]]>
</script>