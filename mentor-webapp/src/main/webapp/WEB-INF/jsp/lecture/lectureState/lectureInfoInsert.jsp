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
<script type="text/javascript">


<c:choose>
    <c:when test="${codeMsg != null}">
        alert('${codeMsg}');
    </c:when>
</c:choose>

$().ready(function() {


    $("#lectTitle").bind('change keydown keyup blur', function() {
        stringByteLength = $("#lectTitle").val().length;
        $(this).parent().find('span').html('<em>'+stringByteLength+'</em>/20자');
    });

    $("#lectOutlnInfo").bind('change keydown keyup blur', function() {
        stringByteLength = $("#lectOutlnInfo").val().length;
        $(this).parent().find('span').html('<em>'+stringByteLength+'</em>/40자');
    });

    $("#lectIntdcInfo").bind('change keydown keyup blur', function() {
        stringByteLength = $(this).val().length;
        $(this).parent().find('span').html('<em>'+stringByteLength+'</em>/200자');
    });

    $("#lectSustInfo").bind('change keydown keyup blur', function() {
        stringByteLength = $(this).val().length;
        $(this).parent().find('span').html('<em>'+stringByteLength+'</em>/200자');
    });

    //글자수세팅
    $("#lectTitle").trigger("change");
    $("#lectOutlnInfo").trigger("change");
    $("#lectIntdcInfo").trigger("change");
    $("#lectSustInfo").trigger("change");
});

function fnValidationLectInfo(){

    if($("#lectGrpNo").val() == ""){
        alert('배정사업을 선택해주세요.');
        return false;
    }

    if($("#lectTitle").val() == ""){
        alert("수업제목을 입력하세요");
        return false;
    }

    if($("#lectrMbrNo").val() == ""){
        alert("멘토를 선택하세요.");
        return false;
    }

    if($('input[name=lectTargtCheck]:checked').size() < 1){
        alert("수업대상을 선택하세요.");
        return false;
    }

    if($("#fileList").find("li").length == 0){
        alert("수업이미지를 1개이상 등록하세요.");
        return false;
    }

    if($("#lectIntdcInfo").val() == ""){
        alert("수업소개를 입력하세요");
        return false;
    }

     if(!validForm(Editor)){
        return false;
     }

    return true;
}

function lectureInfoSave(){
    if(!fnValidationLectInfo()){
        return false;
    }

    if(!confirm("저장 하시겠습니까?")) {
        return false;
    }
    //수업사진
    $("input[name=comFileInfo]").each(function(idx) {
        idx =idx+$("#fileList").find("input[type=hidden]").length;
        if($(this).val() == ""){
            $(this).remove();
        }
        $(this).attr("name", "listLectPicInfo[" +idx +"].comFileInfo.file");
    }).filter(':last').remove();

    //수업유형
    $("#lectTypeCd").val($('input:radio[name=lectTypeRadio]:checked').val());

    //수업대상
    var checkLectType = new Array;

    $("input:checkbox[name=lectTargtCheck]").each(function() {
        if($(this).parent().hasClass("checked")){
            var checkVal = $(this).val();
            checkLectType.push(checkVal);
        }
    });

    if(checkLectType.length == 2){
        if(!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101535_중학교']}")){ //초등,중학교
            $("#lectTargtCd").val("${code['CD101533_101537_초등_중학교'] }");
        }else if(!!~checkLectType.indexOf("${code['CD101533_101535_중학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")){ //중등,고등학교
            $("#lectTargtCd").val("${code['CD101533_101538_중_고등학교'] }");
        }else if(!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")){ //초등,고등학교
            $("#lectTargtCd").val("${code['CD101533_101539_초등_고등학교'] }");
        }
    }else if(checkLectType.length == 1){
        $("#lectTargtCd").val(checkLectType[0]);
    }else{
        $("#lectTargtCd").val("${code['CD101533_101540_초등_중_고등학교'] }");
    }

    $("input[name=lectTypeRadio]").attr("disabled",false);


    //Editor 저장
    saveContent();
    $("#frm").submit();
    $("#delFileSer").val("");
    $("#copyLectSer").val("");
}

var idCount = 0;

function fnFileSelect(obj){
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
    var fileClone = $("#comFileInfoFile"+idCount).clone();
    $("#comFileInfoFile"+idCount).hide();
    $('#fileList').append('<li>'+files[0].name + '<a href="#" id="comFileInfoFile'+idCount+'"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제" onclick="fileRemove(this, null)"></a></li>');
    idCount++;
    fileClone.attr("id","comFileInfoFile"+idCount );

    $('.input-file').append(fileClone);
}

function fileRemove(obj, fileSer){
    $(obj).parent().parent().remove();

    if (typeof $(obj).parent().parent().find("input[type=hidden]").val() == "undefined") {
        $("input[type=file]:first").attr("id", $(obj).parent().attr("id")).remove();
    }
}

function fnResetForm(){
    if(!confirm("취소 하시겠습니까?")) {
        return false;
    }
    location.href="${pageContext.request.contextPath}/lecture/lectureState/mentorLectList.do";
}

</script>
    <div id="container">
        <div class="location">
            <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
            <span>수업관리</span>
            <span>수업개설</span>
        </div>
        <div class="content">
            <h2 class="fs24">수업개설</h2>
            <div class="cont type1">
                <div class="board-title1">
                    <h3 class="board-tit">기본정보</h3>
                    <span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
                </div>
                <div class="board-input-type lesson_setup">
                    <div class="cont20">
                        <form:form commandName="lectureInfo" action="${pageContext.request.contextPath}/lecture/lectureState/retrieveIectureInfoInsert.do?${_csrf.parameterName}=${_csrf.token}" method="post" id="frm" enctype="multipart/form-data">
                        <form:input type="hidden" path="lectrMbrNo" id="lectrMbrNo"/>
                        <form:input type="hidden" path="lectrJobNo" id="selectedJobNo"/>
                        <form:input type="hidden" path="lectReqSer" id="lectReqSer"/>
                        <form:input type="hidden" path="lectTypeCd" id="lectTypeCd"/>
                        <form:input type="hidden" path="lectTargtCd" id="lectTargtCd"/>

                        <table>
                            <caption>기본정보 - 수업명, 멘토명, 수업유형, 수업대상, 수업개요, 수업유형, 이미지, 수업소개, 수업내용</caption>
                            <colgroup>
                                <col style="width:136px;" />
                                <col />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row" class="compulsory">배정사업</th>
                                <td >
                                    <form:select path="lectGrpNo">
                                        <form:option value="">선택</form:option>
                                        <form:options items="${bizGrpInfo}" itemLabel="grpNm" itemValue="grpNo"/>
                                    </form:select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업명</th>
                                <td><div class="text-limit">
                                        <form:input type="text" path="lectTitle" cssClass="inp-style1" maxlength="20" cssStyle="width:630px"/>
                                        <span><em>0</em>/20자</span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">멘토명</th>
                                <td id="mentorNm"><a href="javascript:void(0)" class="btn-type5" id="aBelongMentor">검색</a><span></span></td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업유형</th>
                                <td>
                                    <label class="radio-skin checked"><input type="radio" name="lectTypeRadio" class="radio-skin" checked="checked" value="${code['CD101528_101529_단강']}"/>단강</label>
                                    <label class="radio-skin"><input type="radio" name="lectTypeRadio" class="radio-skin"  value="${code['CD101528_101532_블록']}"/>블록</label>
                                    <label class="radio-skin"><input type="radio" name="lectTypeRadio" class="radio-skin" value="${code['CD101528_101530_연강']}" />연강</label>
                                    <label class="radio-skin"><input type="radio" name="lectTypeRadio" class="radio-skin" value="${code['CD101528_101531_특강']}" />특강</label>
                                </td>
                            </tr>
                            <tr>

                                <th scope="row" class="compulsory">수업대상</th>
                                <td>
                                    <label class="chk-skin2"><input type="checkbox" name="lectTargtCheck" class="chk-skin" value="101534" />초등</label>
                                    <label class="chk-skin2"><input type="checkbox" name="lectTargtCheck" class="chk-skin" value="101535" />중등</label>
                                    <label class="chk-skin2"><input type="checkbox" name="lectTargtCheck" class="chk-skin" value="101536" />고등</label>
                                    <label class="chk-skin2"><input type="checkbox" name="lectTargtCheck" class="chk-skin" value="101713" />기타</label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">수업개요</th>
                                <td><div class="text-limit"><form:input type="text" path="lectOutlnInfo" cssClass="inp-style1"  cssStyle="width:630px" maxlength="40"/><span><em>0</em>/40자</span></div></td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">이미지</th>
                                <td>
                                    <div class="input-file">
                                        <input type="file" name="comFileInfo" id="comFileInfoFile0" onchange="fnFileSelect(this)" />
                                        <span class="max-num">* jpg및 png 지원 / 최적화 사이즈 245 x 245</span></div>
                                    <ul class="file-list-type01" id="fileList"></ul>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업소개</th>
                                <td><div class="text-limit area"><form:textarea path="lectIntdcInfo" rows="" cssStyle="height:63px;" cssClass="textarea bggray" maxlength="200"></form:textarea><span><em>0</em>/200자</span></div></td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">수업내용</th>
                                <td><div style="background:white">
                                    <div>
                                        <jsp:include page="/layer/editor.do" flush="true">
                                          <jsp:param name="wrapperId" value="content_area_id"/>
                                          <jsp:param name="contentId" value="content_area_id"/>
                                          <jsp:param name="formName" value="frm"/>
                                        </jsp:include>
                                    </div>
                                    <form:textarea path="lectSustInfo" id="content_area_id" rows="" cssStyle="height:63px;display:none;" cssClass="textarea bggray" maxlength="200"></form:textarea>
                                    <span style="display:none"><em>0</em>/200자</span></div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">요청수업</th>
                                <td>
                                    <a href="javascript:void(0)" class="btn-type5" id="aRequestLecture">선택</a>
                                    <span class="lesson-subject"></span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </form:form>
                    </div>
                    <div class="btn-area">
                        <a href="javascript:void(0)" class="btn-type2" onclick="lectureInfoSave()">저장</a>
                        <a href="javascript:void(0)" class="btn-type2 gray" onclick="fnResetForm()">취소</a>
                        <span class="right">
                            <a href="javascript:void(0)" class="btn-type5" id="aLectureInfoCopy">복사</a>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
    </div>

<!-- layer-popup-->
<a href="#layer1" class="layer-open" id="layerOpen"></a>

<div id="layerPopupDiv">

</div>
<!-- // layer-popup-->


<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            lectSer:$("#lectSer").val()
        },
        data: {}
    };
    mentor.mentorDataSet = dataSet;

    $(document).ready(function() {

        //소속멘토찾기
        $("#aBelongMentor").click(function(){
            $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupBelongMentor.do", {"callbackFunc":"callbackBelongMentor"}, function(){ $("#layerOpen").trigger("click"); });
        });

        //요청수업선택
        $("#aRequestLecture").click(function(){
            //수업대상
            var schClassCds = "";

            $("input:checkbox[name=lectTargtCheck]").each(function() {
                if($(this).parent().hasClass("checked")){
                    var checkVal = $(this).val();
                    schClassCds += (checkVal+",");
                }
            });

            $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupRequestLecture.do", {"callbackFunc":"callbackRequestLecture","schClassCds":schClassCds.substring(0,schClassCds.length-1),"jobNo": $('#selectedJobNo').val()}, function(){ $("#layerOpen").trigger("click"); });
        });

        //수업정보복사
        $("#aLectureInfoCopy").click(function(){
            $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupLectureInfoCopy.do", {"callbackFunc":"callbackLectureInfoCopy"}, function(){ $("#layerOpen").trigger("click"); });
        });

        //요청수업 화면에서 개설 버튼 클릭하여 화면이 열렸을 경우
        var requestReqSer = "${param.requestReqSer}";
        var requestLectTitle = "${param.requestLectTitle}";
        if(requestReqSer != null && requestReqSer != ""){
            callbackRequestLecture(requestReqSer, requestLectTitle);
        }

    });


    /* 수업대상 radio change */
    $('input[name=lectTargtCheck]').change(function(index){
        var currObj = $(this);
        var etcChk = false;

        if(currObj.parent().hasClass('checked')) {
            currObj.parent().removeClass('checked')
        } else {
            currObj.parent().addClass('checked');
        }

        // 두개 이상 선택 했을 경우
        if($('input[name=lectTargtCheck]:checked').size() > 1){
            $('input[name=lectTargtCheck]:checked').each(function(){
                // 기타를 선택했어??
                if($(this).val() == '101713') {
                    etcChk = true;
                }

                if(etcChk) {
                    alert('학교와 기타는 동시에 설정할수 없습니다.');
                    currObj.prop('checked', false);
                    currObj.parent().removeClass('checked');
                }
            });
         }
    });

    //소속멘토찾기 콜백
    function callbackBelongMentor(sMbrNo, sNm, jobNo){
        $("#lectrMbrNo").val(sMbrNo);
        $('#selectedJobNo').val(jobNo);
        $("#mentorNm").find("span").text(sNm);
    }

    //요청수업선택 콜백
    function callbackRequestLecture(sReqSer, sLectTitle){
        $("#lectReqSer").val(sReqSer);
        $(".lesson-subject").text(sLectTitle);
    }

    //수업정보복사 콜백
    function callbackLectureInfoCopy(sLectSer, lectGrpNo, lectTitle, lectrMbrNo, lectrJobNo, lectrNm, lectTypeCd, lectTargtCd, lectOutlnInfo, lectIntdcInfo, lectSustInfo){
        $("#lectGrpNo").val(lectGrpNo);
        $("#lectTitle").val(lectTitle);

        var lectTitleLength = $("#lectTitle").val().length;
        $("#lectTitle").parent().find('span').html('<em>'+lectTitleLength+'</em>/20자');


        $("#lectrMbrNo").val(lectrMbrNo);
        $("#lectrJobNo").val(lectrJobNo);
        $("#mentorNm").find("span").text(lectrNm);


        $("#lectOutlnInfo").val(lectOutlnInfo);
        var lectOutlnInfoLength = $("#lectOutlnInfo").val().length;
        $("#lectOutlnInfo").parent().find('span').html('<em>'+lectOutlnInfoLength+'</em>/40자');

        $("#lectIntdcInfo").val(lectIntdcInfo);
        var lectIntdcInfoLength = $("#lectIntdcInfo").val().length;
        $("#lectIntdcInfo").parent().find('span').html('<em>'+lectIntdcInfoLength+'</em>/200자');


        Editor.modify({'content':lectSustInfo});

        $("input:radio[name='lectTypeRadio']").parent().attr("class", "radio-skin");
        $("input:radio[name='lectTypeRadio']").attr("checked",false);

        if(lectTypeCd == "101529"){
            $("input:radio[name='lectTypeRadio']:radio[value='101529']").attr("checked",true);
            $("input:radio[name='lectTypeRadio']:checked").parent().attr("class", "radio-skin checked");
        }else if(lectTypeCd == "101532"){
            $("input:radio[name='lectTypeRadio']:radio[value='101532']").attr("checked",true);
            $("input:radio[name='lectTypeRadio']:checked").parent().attr("class", "radio-skin checked");
        }else if(lectTypeCd == "101530"){
            $("input:radio[name='lectTypeRadio']:radio[value='101530']").attr("checked",true);
            $("input:radio[name='lectTypeRadio']:checked").parent().attr("class", "radio-skin checked");
        }else if(lectTypeCd == "101531"){
            $("input:radio[name='lectTypeRadio']:radio[value='101531']").attr("checked",true);
            $("input:radio[name='lectTypeRadio']:checked").parent().attr("class", "radio-skin checked");
        }

        $("input:checkBox[name='lectTargtCheck']").parent().attr("class", "chk-skin");
        $("input:checkBox[name='lectTargtCheck']").attr("checked",false);

        if(lectTargtCd == '101534' || lectTargtCd == '101537'  || lectTargtCd == '101539' || lectTargtCd == '101540'){
            $("input:checkBox[name='lectTargtCheck']:checkBox[value='101534']").attr("checked",true);
            $("input:checkBox[name='lectTargtCheck']:checked").parent().attr("class", "chk-skin checked");
        }
        if(lectTargtCd == '101535' || lectTargtCd == '101537'  || lectTargtCd == '101538' || lectTargtCd == '101540'){
            $("input:checkBox[name='lectTargtCheck']:checkBox[value='101535']").attr("checked",true);
            $("input:checkBox[name='lectTargtCheck']:checked").parent().attr("class", "chk-skin checked");
        }

        if(lectTargtCd == '101536' || lectTargtCd == '101538'  || lectTargtCd == '101539' || lectTargtCd == '101540'){
            $("input:checkBox[name='lectTargtCheck']:checkBox[value='101536']").attr("checked",true);
            $("input:checkBox[name='lectTargtCheck']:checked").parent().attr("class", "chk-skin checked");
        }

        if(lectTargtCd == '101713'){
            $("input:checkBox[name='lectTargtCheck']:checkBox[value='101713']").attr("checked",true);
            $("input:checkBox[name='lectTargtCheck']:checked").parent().attr("class", "chk-skin checked");
        }
    }



    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }


</script>