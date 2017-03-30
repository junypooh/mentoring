<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>
<style type="text/css">
/* div.tx-toolbar a>span {display:none !important} */
</style>

<div id="container">
    <div class="location">
		<a href="#" class="home">메인으로 이동</a>
		<span>수업관리</span>
		<span>수업개설신청</span>
	</div>
	<div class="content">
		<h2>수업개설신청</h2>
		<p class="tit-desc-txt">수업계획서를 작성하여 수업개설을 신청하여 주시면 확인 후 수업을 개설합니다. </p>
		<div class="cont type3">
			<div class="board-title1">
				<span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
			</div>
			<div class="board-input-type all-view">
				<table>
					<caption>수업개설신청 - 제목, 내용, 수업계획서</caption>
					<colgroup>
						<col style="width:154px;">
						<col>
						</colgroup>
					<tbody>
						<tr>
							<th scope="row" class="compulsory">제목</th>
							<td><input type="text" class="inp-style1" style="width:682px;" id="lectTitle" placeholder="제목을 입력해주세요" maxlength="50" /></td>
						</tr>
						<tr>
							<th scope="row" class="compulsory">내용</th>
							<td>
								<textarea id="lectSust" rows="" maxlength="200" class="textarea" cols="" placeholder=" 예시)&#13;&#10; - 희망하는수업일&#13;&#10; - 수업주제&#13;&#10; - 수업목적&#13;&#10; 등 자유롭게 입력하여주세요."></textarea>
							</td>
						</tr>
						<tr id="papers">
							<th scope="row" class="compulsory">수업계획서</th>
							<td>
							    <form id="papersFileForm" method="post" enctype="multipart/form-data">
								    <div class="input-file">
								        <input type="file" id="papersFile" name="upload_file">
								        <span class="max-num">개별 파일 용량 20MB , 1개만 첨부 가능합니다.</span>
								    </div>
								</form>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-area">
				<a href="#" class="btn-type2" onclick="fn_save()">개설신청</a>
				<a href="#" class="btn-type2 gray" onclick="fn_cncl()">취소</a>
			</div>
		</div>
	</div>
	<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>



<script type="text/javascript">

    $(document).ready(function() {


    });

    /* 첨부파일 문서 등록 */
    $('#papersFile').change(function(){

        if($('#papers .file-list-type01 li').length >= 1){
            alert('한 개의 파일만 등록이 가능합니다.');
            $('#papersFile').val('');
            return;
        }

        $("#papersFileForm").ajaxForm({
            url : "${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}",
            dataType: 'text',
            success:function(data, status){
                var response = JSON.parse(data);
                if(Math.ceil(response.fileSize/(1024)/(1024)) > 20 ){
                    alert('20MB 이하의 파일만 가능합니다.');
                    return;
                }
                var str = '';
                str += '<ul class="file-list-type01" id='+response.fileSer+'>';
                str += '    <li>'+response.oriFileNm+'('+Math.ceil(response.fileSize/(1024)/(1024))+'MB)<a href="javascript:fn_fileDelete('+response.fileSer+')"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제"></a></li>';
                str += '</ul>';
                $('#papers > td').append(str);
            }
        }).submit();
    });

    /* 첨부파일 삭제 */
    function fn_fileDelete(fileSer){
        if(confirm('첨부파일을 정말 삭제하시겠습니까?')){
            $('#'+fileSer).remove();
        }
    }

    /* 저장 및 수정 */
    function fn_save(){
        if($('#lectTitle').val() == ''){
            alert('제목을 입력해주세요.');
            return;
        }

        if($.trim($('#lectSust').val()) == ''){
            alert('내용을 입력해주세요.');
            return;
        }

        if($('#papers .file-list-type01').attr('id') == null){
            alert('자료를 등록해주세요.');
            return;
        }

        var _param = {
            'lectTitle' : $('#lectTitle').val()
          , 'lectSust' : $('#lectSust').val()
          , 'fileSer' : $('#papers .file-list-type01').attr('id')
        };

        if( confirm('저장하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/lecture/lectureOpenReq/ajax.save.do',
                data : _param,
                contentType: "application/json",
                dataType: 'text',
                type: 'GET',
                success: function(rtnData) {
                        alert("저장되었습니다.");
                        location.href = '${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqList.do';
                },
                error: function(xhr, status, err) {
                    alert(err);
                }
            });
        }
    }

    function fn_cncl(){
        if(!confirm("취소 하시겠습니까?")) {
            return false;
        }
        location.href="${pageContext.request.contextPath}/lecture/lectureOpenReq/lectureOpenReqList.do";
    }
</script>
