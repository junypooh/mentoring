<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2><c:if test="${bnrInfo.bnrTypeCd eq '101640'}">멘토배너관리</c:if><c:if test="${bnrInfo.bnrTypeCd eq '101639'}">학교배너관리</c:if></h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>프론트관리</li>
            <li><c:if test="${bnrInfo.bnrTypeCd eq '101640'}">멘토배너관리</c:if><c:if test="${bnrInfo.bnrTypeCd eq '101639'}">학교배너관리</c:if></li>
        </ul>
    </div>

    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-mento-modify">
            <colgroup>
                <col style="width:147px;" />
                <col style="width:100px;" />
                <col />
            </colgroup>
            <tbody>
            <form name="frm" id="frm" action="${pageContext.request.contextPath}/web/front/banner/save.do" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="bnrSer" id="bnrSer" value="${bnrInfo.bnrSer}" />
                <input type="hidden" name="bnrImgUrl" id="bnrImgUrl"  value="${bnrInfo.bnrImgUrl}" />
                <input type="hidden" id="bnrLinkUrl" name="bnrLinkUrl" value="${bnrInfo.bnrLinkUrl}"/>
                <input type="hidden" id="bnrZoneCd" name="bnrZoneCd" value="<c:if test="${bnrInfo.bnrTypeCd eq '101640'}">101636</c:if><c:if test="${bnrInfo.bnrTypeCd eq '101639'}">101635</c:if>"/>

                <input type="hidden" id="useYn" name="useYn" value="${bnrInfo.useYn}"/>
<%--                <tr>
                    <th scope="col">구분</th>
                    <td colspan="2">
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101633_배너구역코드'])" var="bnrZoneCds" />
                        <select id="bnrZoneCd" name="bnrZoneCd">
                            <c:forEach items="${bnrZoneCds}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>--%>
                <tr>
                    <th scope="col">배너위치</th>
                    <td colspan="2">
                        <select id="bnrTypeCd" name="bnrTypeCd">
                            <option value="${bnrInfo.bnrTypeCd}">
                                <c:if test="${bnrInfo.bnrTypeCd eq '101640'}">홍보배너</c:if>
                                <c:if test="${bnrInfo.bnrTypeCd eq '101639'}">메인배너</c:if>
                            </option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col">배너명</th>
                    <td colspan="2">
                        <input type="text" name="bnrNm" id="bnrNm"
                               style="width: 350px;"
                               maxlength="25"
                               class="text" value="${bnrInfo.bnrNm}"
                               placeholder="구분을 위한 배너명입니다.배너명이 프론트에 노출되지 않습니다."/>
                    </td>
                </tr>
<%--                <tr id="bannerDesc">
                    <th scope="col">배너내용</th>
                    <td colspan="2">
                        <input type="text" class="text" id="bnrDesc"
                               style="width: 700px;"
                               name="bnrDesc" maxlength="150" value="${bnrInfo.bnrDesc}"/>
                    </td>
                </tr>--%>
            </form>
            <c:if test="${bnrInfo.bnrTypeCd ne '101638'}">
            <tr id="bannerImage">
                <th scope="col">이미지등록</th>
                <td colspan="2">
                    <p class="attach-box">
                    <form id="fileForm" method="post" enctype="multipart/form-data">
                        <input type="text" class="text" />
                        <span class="btn-file-wrap">
                            <input type="file" id="uploadFile" name="upload_file" class="btn-file" />
                        </span>
                        <span class="attach-ps">
                            <c:if test="${bnrInfo.bnrTypeCd eq '101640'}">(680 X 268,png,jpg)</c:if>
                            <c:if test="${bnrInfo.bnrTypeCd eq '101639'}">(686 X 299,png,jpg)</c:if>
                        </span>
                    </form>
                    </p>
                    <ul id="attach-list">
                        <c:if test="${not empty bnrInfo.bnrImgUrl}">
                            <li id="${item.fileSer}">
                                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${bnrInfo.bnrImgUrl}&origin=true" class="typeB" style="width:680px;">
                            </li>
                        </c:if>
                    </ul>
                </td>
            </tr>
            </c:if>
            <tr>
                <th scope="col">연결링크</th>
                <td colspan="2">
                    <label><input type="radio" name="bnrLinkYn" value="Y" /> URL</label>
                    <input type="text" name="bnrLinkUrlStr" class="text" value="${bnrInfo.bnrLinkUrl}" style="width: 350px;"/>
                    <label> </label>
                    <label><input type="radio" name="bnrLinkYn" value="N" /> 링크없음</label>
                </td>
            </tr>
            <%--<tr>
                <th scope="col">노출여부</th>
                <td colspan="2">
                    <label><input type="radio" name="useYnVal" value="Y" /> 노출</label>
                    <label><input type="radio" name="useYnVal" value="N" /> 노출안함</label>
                </td>
            </tr>--%>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="on_submit();">
                    <c:if test="${empty bnrInfo.bnrSer}">
                        <span>등록</span>
                    </c:if>
                    <c:if test="${not empty bnrInfo.bnrSer}">
                        <span>수정</span>
                    </c:if>
                </button>
                </li>
                <li><button type="button" class="btn-gray" onclick="location.href='${pageContext.request.contextPath}<c:if test="${bnrInfo.bnrTypeCd eq '101640'}">/web/front/mentorBanner/list.do?bannerType=101640</c:if><c:if test="${bnrInfo.bnrTypeCd eq '101639'}">/web/front/mainBanner/list.do?bannerType=101639</c:if>'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">

    $(function() {

        $("input[name='bnrLinkUrlStr']").blur(
                function(){
                    $('#bnrLinkUrl').val(this.value);
                }
        );

        var bnrLinkYns = $( "input[name='bnrLinkYn']");

        if('${bnrInfo.bnrLinkUrl}' != ''){
            bnrLinkYns.filter('[value="Y"]').attr('checked', true);
        }else{
            bnrLinkYns.filter('[value="N"]').attr('checked', true);
        }
        if(!bnrLinkYns.is(':checked')){
            bnrLinkYns.filter('[value="Y"]').attr('checked', true);
        }

    });

    // 첨부파일 삭제
    function fn_fileDelete(fileSer){
        if(confirm('첨부파일을 정말 삭제하시겠습니까?')){
            $('#'+fileSer).remove();
        }
    }
    // 첨부파일 추가
    $('#uploadFile').change(function(){
        $("#fileForm").ajaxForm({
            url : "${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}",
            dataType: 'text',
            success:function(data, status){
                var response = JSON.parse(data);
                var str = '';
                str += '<li id="'+response.fileSer+'">';
                str += '    <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=' + response.fileSer + '&origin=true" class="typeB" style="width:680px;">';
                str += '    <button type="button" class="btn-attach-delete" onClick="fn_fileDelete('+ response.fileSer +');"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>'
                str += '</li>';
                $('#uploadFile').val("");
                if($('#attach-list li').length >= 1){
                    $('#attach-list li').remove();
                }
                $('#attach-list').append(str);
                $('#bnrImgUrl').val(response.fileSer);
            }
        }).submit();
    });

    function on_submit(){
        //var bnrTypeCd = $("select[name='bnrTypeCd'] :selected").val();
        var bnrLinkYn = $("input[name='bnrLinkYn']").filter(':checked').val();
        if( $("input[name='bnrNm']").val() == ""){
            alert("배너명을 입력하세요.");
            return false;
        }
        if(bnrLinkYn == 'Y' && $("#bnrLinkUrl").val() == ""){
            alert("링크를 입력하세요.");
            return false;
        }

        $('#useYn').val('Y');

        $('#frm').submit();
    }
</script>