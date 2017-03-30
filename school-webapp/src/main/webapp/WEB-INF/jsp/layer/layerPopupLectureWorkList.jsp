<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="layer-pop-wrap" id="layer1">
    <div class="layer-pop m-blind">
		<div class="layer-header">
			<strong class="title">과제 보기</strong>
		</div>
		<div class="layer-cont pop-hw-list">
			<p class="hw-title">${lectSchdInfo.lectTitle} (${lectSchdInfo.lectrNm}/${lectSchdInfo.jobNm})</p>
            <ul class="hw-info">
                <li><strong>수업일</strong><em>${lectSchdInfo.lectDay} ${lectSchdInfo.lectStartTime} ~ ${lectSchdInfo.lectEndTime}</em></li>
			 	<li><strong>${lectSchdInfo.tchrNm}</strong><em>${lectSchdInfo.schNm} ${lectSchdInfo.clasRoomNm}</em></li>
			</ul>
            <div class="layer-pop-scroll">
				<div class="mypage-wrap">
					<ul class="community-data-list hw-list">
<c:choose>
    <c:when test="${fn:length(arclList) > 0}">
        <c:forEach items="${arclList}" var="eachObj">

						<li>
							<div class="title">
								<a href="#" onClick="fnArticDetail(this)">
									<em>${eachObj.title}</em>
									<div>
										<span class="user ${eachObj.mbrClassNm}">${eachObj.regMbrNm}</span>
										<span class="school-info">${lectSchdInfo.schNm} ${lectSchdInfo.clasRoomNm}</span>
										<span class="file">${fn:length(eachObj.listArclFileInfo)}개 (${eachObj.fileTotalSize}MB)</span>
									</div>
								</a>
							</div>
							<div class="file-list">
								<div class="writing-btn homework-btn-group">
									<a href="#homeworkPop2" class="btn-edit layer-open">수정</a>
									<a href="#" onClick="fnDelWorkInfo('${eachObj.arclSer}', '${eachObj.boardId}')"class="btn-del">삭제</a>
								</div>
            <c:if test="${eachObj.cntntsSust != null}">
								<div class="download-brd">
									<a href="#" class="reply">답변</a>
									<ul>
										<li>
											<div style="padding-left:39px;">
											<spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(eachObj.cntntsSust)"></spring:eval>
											</div>
										</li>
									</ul>
								</div>
            </c:if>
								<div class="download-brd">
									<a href="${pageContext.request.contextPath}/fileDownAll.do?arclSer=${eachObj.arclSer}&boardId=${eachObj.boardId}" class="all-down">전체파일 다운로드</a>
								</div>
								<ul>
            <c:forEach items="${eachObj.listArclFileInfo}" var="fileObj">
                <c:choose>
                    <c:when test="${fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'zip' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == '7z' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'rar'}">
                        <c:set var="classStr" value="file-type zip"/>
                    </c:when>
                    <c:when test="${fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'mp3' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'wav' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'wma'}">
                        <c:set var="classStr" value="file-type mp4"/>
                    </c:when>
                    <c:when test="${fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'mp4' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'mov' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'avi'}">
                        <c:set var="classStr" value="file-type avi"/>
                    </c:when>
                    <c:when test="${fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'jpg' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'jpeg' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'png' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'gif'}">
                        <c:set var="classStr" value="file-type jpg"/>
                    </c:when>
                    <c:when test="${fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'hwp' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'pdf' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'txt' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'pptx'}">
                        <c:set var="classStr" value="file-type pptx"/>
                    </c:when>
                    <c:when test="${fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'ppt' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'xlsx' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'xls' || fn:toLowerCase(fileObj.comFileInfo.fileExt) == 'docx'}">
                        <c:set var="classStr" value="file-type pptx"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="classStr" value="file-type etc"/>
                    </c:otherwise>
                </c:choose>
									<li>
										<span class="${classStr}" >
											<a href="${pageContext.request.contextPath}/fileDown.do?fileSer=${fileObj.comFileInfo.fileSer}">${fileObj.comFileInfo.oriFileNm}</a>
										</span>
										<span class="file-size">${fileObj.comFileInfo.fileSize}MB</span>
									</li>
            </c:forEach>
								</ul>
							</div>
						</li>
        </c:forEach>
    </c:when>
    <c:otherwise>
						<li>
							<div class="title">
								<a href="#">
									<em style="width:100%;text-align:center;">등록된 데이터가 없습니다.</em>
								</a>
							</div>
						</li>
    </c:otherwise>
</c:choose>
					</ul>
				</div>
			</div>
			<div class="btn-area popup">
				<a href="#" id="btnClose" class="btn-type2 cancel">닫기</a>
			</div>
			<a href="#" class="layer-close">팝업 창 닫기</a>
		</div>
	</div>
</div>



<script type="text/javascript">
    $(document).ready(function(){
        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $("#btnClose").trigger("click");
            }
        });

        position_cm();

    });

    function fnArticDetail(obj){

                if(!$(obj).parent().hasClass('active')){
                    $('.community-data-list .title').removeClass('active');
                    $(obj).parent().addClass('active');

                }else{
                    $(obj).parent().removeClass('active');
                }
    }

    function fnDelWorkInfo(arclSer, boardId){
        if(!confirm("삭제하시겠습니까?")) {
          return false;
        }
        var data =    {arclSer : arclSer,
                            boardId : boardId };
        $.ajax({
          url: "${pageContext.request.contextPath}/community/ajax.deleteArcl.do",
          data : JSON.stringify(data),
          contentType: "application/json",
          dataType: 'json',
          type: 'post',
          cache: false,
          success: function(rtnData) {
            alert("삭제했습니다.");
            $("#btnClose").trigger("click");
          },
          error: function(xhr, status, err) {
            console.error("ajax.deleteArcl.do", status, err.toString());
          }
        });
    }

</script>