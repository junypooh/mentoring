<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id"/>
    <security:authentication var="mbrNo" property="principal.mbrNo"/>
    <security:authentication var="username" property="principal.username"/>
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd"/>
</security:authorize>
<script type="text/javascript">

    $().ready(function () {
        //수정모드시 선택박스 체크

        $("#lectTitle").bind('change keydown keyup blur', function () {
            stringByteLength = $("#lectTitle").val().length;
            $(this).parent().find('span').html('<em>' + stringByteLength + '</em>/20자');
        });

        $("#lectOutlnInfo").bind('change keydown keyup blur', function () {
            stringByteLength = $("#lectOutlnInfo").val().length;
            $(this).parent().find('span').html('<em>' + stringByteLength + '</em>/40자');
        });

        $("#lectIntdcInfo").bind('change keydown keyup blur', function () {
            stringByteLength = $(this).val().length;
            $(this).parent().find('span').html('<em>' + stringByteLength + '</em>/200자');
        });

        $("#lectSustInfo").bind('change keydown keyup blur', function () {
            stringByteLength = $(this).val().length;
            $(this).parent().find('span').html('<em>' + stringByteLength + '</em>/200자');
        });

        //글자수세팅
        $("#lectTitle").trigger("change");
        $("#lectOutlnInfo").trigger("change");
        $("#lectIntdcInfo").trigger("change");
        $("#lectSustInfo").trigger("change");
    });

    function fnValidationLectInfo() {
        if ($("#lectTitle").val() == "") {
            alert("수업제목을 입력하세요");
            return false;
        }

        if ($("#fileList").find("li").length == 0) {
            alert("수업이미지를 1개이상 등록하세요.");
            return false;
        }

        if ($("#lectIntdcInfo").val() == "") {
            alert("수업소개를 입력하세요");
            return false;
        }

        if(!validForm(Editor)){
           return false;
        }
        return true;
    }


    function lectureInfoSave() {
        if (!fnValidationLectInfo()) {
            return false;
        }

        if (!confirm("저장 하시겠습니까?")) {
            return false;
        }

        //수업사진
        $("input[name=comFileInfo]").each(function (idx) {
            idx = idx + $("#fileList").find("input[type=hidden]").length;
            if ($(this).val() == "") {
                $(this).remove();
            }
            $(this).attr("name", "listLectPicInfo[" + idx + "].comFileInfo.file");
        });

        saveContent();
        $("#frm").submit();
        $("#delFileSer").val("");
    }

    var idCount = 0;

    function fnFileSelect(obj) {

        var files = obj.files;
        if (!files) {
            // workaround for IE9
            files = [];
            files.push({
                name: obj.value.substring(obj.value.lastIndexOf("\\")+1),
                size: 0,  // it's not possible to get file size w/o flash or so
                type: obj.value.substring(obj.value.lastIndexOf(".")+1)
            });
        }
        var fileClone = $("#comFileInfoFile" + idCount).clone();
        $("#comFileInfoFile" + idCount).hide();
        idCount++;
        fileClone.attr("id", "comFileInfoFile" + idCount);

        $('.input-file').append(fileClone);
        $('#fileList').append('<li>' + files[0].name + '<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제" onclick="fileRemove(this, null,'+idCount+')"></a></li>');

    }

    function fileRemove(obj, fileSer,inx) {
        $(obj).parent().parent().remove();

        if ($("#delFileSer").val() != "") {
            if(inx > 0){
                $("#comFileInfoFile"+inx).remove();
            }else{
                $("#delFileSer").val($("#delFileSer").val() + "," + fileSer);
            }
        } else {
            $("#delFileSer").val(fileSer);
        }
    }

    function fnResetForm() {
        if (!confirm("취소 하시겠습니까?")) {
            return false;
        }
        history.back();
    }

</script>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>수업관리</span>
        <span>수업현황</span>
    </div>
    <div class="content">
        <h2 class="fs24">수업수정</h2>

        <div class="cont type1">
            <div class="board-title1">
                <h3 class="board-tit">기본정보</h3>
                <span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
            </div>
            <div class="board-input-type lesson_setup">
                <div class="cont20">
                    <form:form commandName="lectureInfo"
                               action="${pageContext.request.contextPath}/lecture/lectureState/ajax.edit.do?${_csrf.parameterName}=${_csrf.token}"
                               method="post" id="frm" enctype="multipart/form-data">
                        <form:input type="hidden" path="lectSer" id="lectSer"/>
                        <form:input type="hidden" path="lectTims" id="lectTims"/>
                        <form:input type="hidden" path="schdSeq" id="schdSeq"/>
                        <form:input type="hidden" path="lectStatCd" id="lectStatCd"/>
                        <form:input type="hidden" path="lectTypeCd" id="lectTypeCd"/>
                        <input type="hidden" id="delFileSer" name="delFileSer"/>
                        <input type="hidden" id="lectTargtCd" name="lectTargtCd"/>
                        <table>
                            <caption>기본정보 - 수업명, 멘토명, 수업유형, 수업대상, 수업개요, 수업유형, 이미지, 수업소개, 수업내용</caption>
                            <colgroup>
                                <col style="width:136px;"/>
                                <col/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row" >배정사업</th>
                                <td>${lectureInfo.grpNm}</td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업명</th>
                                <td>
                                    <div class="text-limit"><form:input type="text" path="lectTitle" cssClass="inp-style1"
                                                                        maxlength="20" cssStyle="width:630px"/><span><em>0</em>/20자</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">멘토명</th>
                                <input type="hidden" id="lectrMbrNo" name="lectrMbrNo" value="${lectureInfo.lectrMbrNo}"/>
                                <td>${lectureInfo.lectrNm}</td>
                            </tr>
                            <tr>
                                <th scope="row">직업명</th>
                                <td>${lectureInfo.lectrJobNm}</td>
                            </tr>
                            <tr>
                                <th scope="row" >수업대상</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101534'}"> 초 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101535'}"> 중 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101536'}"> 고 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101537'}"> 초, 중 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101538'}"> 중, 고 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101539'}"> 초, 고 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101540'}"> 초, 중, 고 </c:when>
                                        <c:when test="${lectureInfo.lectTargtCd eq '101713'}"> 기타 </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">수업유형</th>
                                <td>${lectureInfo.lectTypeCdNm}</td>
                            </tr>
                            <tr>
                                <th scope="row">수업개요</th>
                                <td>
                                    <div class="text-limit"><form:input type="text" path="lectOutlnInfo" cssClass="inp-style1"
                                                                        cssStyle="width:630px" maxlength="40"/><span><em>0</em>/40자</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">이미지</th>
                                <td>
                                    <div class="input-file">
                                        <input type="file" name="comFileInfo" id="comFileInfoFile0" onchange="fnFileSelect(this)"/>
                                        <span class="max-num">* jpg및 png 지원 / 최적화 사이즈 245 x 245</span>
                                    </div>
                                    <ul class="file-list-type01" id="fileList">
                                        <c:if test="${lectureInfo.lectSer !=null}">
                                            <c:forEach items="${lectureInfo.listLectPicInfo}" var="each" varStatus="status">
                                                <li>${each.comFileInfo.oriFileNm}
                                                    <a href="#">
                                                        <img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제" onclick="fileRemove(this, ${each.comFileInfo.fileSer})">
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </c:if>
                                    </ul>

                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업소개</th>
                                <td>
                                    <div class="text-limit area"><form:textarea path="lectIntdcInfo" rows=""
                                                                                cssStyle="height:63px;" cssClass="textarea bggray"
                                                                                maxlength="200"></form:textarea><span><em>0</em>/200자</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업내용</th>
                                <td>
                                    <div class="" style="background:white">
                                        <div>
                                            <jsp:include page="/layer/editor.do" flush="true">
                                                <jsp:param name="wrapperId" value="content_area_id"/>
                                                <jsp:param name="contentId" value="content_area_id"/>
                                                <jsp:param name="formName" value="frm"/>
                                            </jsp:include>
                                        </div>
                                        <form:textarea path="lectSustInfo" id="content_area_id" rows=""
                                                       cssStyle="height:63px;display:none;" cssClass="textarea bggray"
                                                       maxlength="200"></form:textarea>
                                        <span style="display:none"><em>0</em>/200자</span>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </form:form>
                </div>
                <div class="btn-area">
                    <a href="javascript:void(0)" class="btn-type2" onclick="lectureInfoSave()">저장</a>
                    <a href="javascript:void(0)" class="btn-type2 gray" onclick="fnResetForm()">취소</a>
                </div>
            </div>
            <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png"
                                                           alt="상단으로 이동"/></a></div>
        </div>
    </div>
</div>
<!-- layer-popup-->
<a href="#layer1" class="layer-open" id="layerOpen"></a>

<div id="layerPopupDiv">

</div>
<script type="text/javascript">

    $(document).ready(function () {
        //소속멘토찾기
        $("#aBelongMentor").click(function () {
            $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupBelongMentor.do", {"callbackFunc": "callbackBelongMentor"}, function () {
                $("#layerOpen").trigger("click");
            });
        });
    });

    //소속멘토찾기 콜백
    function callbackBelongMentor(sMbrNo, sNm) {
        $("#lectrMbrNo").val(sMbrNo);
        $("#mentorNm").html($("#mentorNm").html() + "   " + sNm);
    }
</script>