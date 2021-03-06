<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>멘토자료</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>프론트관리</li>
            <li>커뮤니티관리</li>
            <li>멘토자료</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="dataSer" value="${param.dataSer}" />
        <input type="hidden" name="intdcDataYn" value="${param.intdcDataYn}" />
        <input type="hidden" name="schoolGrd" value="${param.schoolGrd}" />
        <input type="hidden" name="schoolEtcGrd" value="${param.schoolEtcGrd}" />
        <input type="hidden" name="searchKey" value="${param.searchKey}" />
        <input type="hidden" name="searchWord" value="${param.searchWord}" />
        <input type="hidden" name="currentPageNo" value="${param.currentPageNo}" />
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </form>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-manager-info">
            <colgroup>
                <col style="width:147px;" />
                <col />
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">멘토</th>
                    <td>
                        <button type="button" class="btn-style01" onClick="mentorPopUp()"><span>멘토찾기</span></button>
                        <input type="text" class="text" id="ownerMbrNm" readOnly/>
                        <input type="hidden" id="ownerMbrNo" name="ownerMbrNo" />
                    </td>
                    <th scope="row">직업명</th>
                    <td id="jobNm"></td>
                </tr>
                <tr>
                    <th scope="row">구분</th>
                    <td colspan="3">
                        <select id="intdcDataYn">
                            <option value="N">수업자료</option>
                            <option value="Y">멘토자료</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">자료대상</th>
                    <td colspan="3">
                        <input type="hidden" id="dataTargtClass" value=""/>
                        <label>
                            <input type="checkbox" name="dataTargt" value="101534"> 초등
                        </label>
                        <label>
                            <input type="checkbox" name="dataTargt" value="101535"> 중등
                        </label>
                        <label>
                            <input type="checkbox" name="dataTargt" value="101536"> 고등
                        </label>
                        <label>
                            <input type="checkbox" name="dataTargt" value="101713"> 기타
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="row">자료유형</th>
                    <td colspan="3">
                        <label>
                            <input type="radio" name="dataTypeCd" value="101759"> 문서
                        </label>
                        <label>
                            <input type="radio" name="dataTypeCd" value="101760"> 동영상
                        </label>
                        <label>
                            <input type="radio" name="dataTypeCd" value="101761"> 링크
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="row">자료명</th>
                    <td colspan="3">
                        <input type="text" name="dataNm" id="dataNm" class="text input-title" />
                    </td>
                </tr>
                <tr id="papers"><!-- 자료유형 - 문서 -->
                    <th scope="row">자료</th>
                    <td colspan="3">
                        <form id="papersFileForm" method="post" enctype="multipart/form-data">
                            <p class="attach-box">
                                <span class="btn-file-wrap"><input type="file" id="papersFile" name="upload_file" class="btn-file" /></span>
                                <span class="attach-ps">개별 파일 용량 50MB , 한 개의 파일만 등록이 가능합니다.</span>
                            </p>
                        </form>
                        <ul class="attach-list">
                            <!--
                            <li>
                                <a href="#">모집안내문.txt</a>
                                <button type="button" class="btn-attach-delete"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                            </li>
                            <li>
                                <a href="#">(붙임1) 2016년 대학알리미 활용 진로·진학 체험수기 공모전 안내.hwp</a>
                                <button type="button" class="btn-attach-delete"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                            </li>
                            <li>
                                <a href="#">(붙임2) 2016년 대학알리미 활용 진로·진학 체험수기 공모전 안내.hwp</a>
                                <button type="button" class="btn-attach-delete"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                            </li>
                            -->
                        </ul>
                    </td>
                </tr>
                <tr id="video" style="display:none;"><!-- 자료유형 - 동영상 -->
                    <th scope="row">자료</th>
                    <td colspan="3">
                        <input type="hidden" id="arclSer" name="arclSer" value="" />
                        <input type="hidden" id="cntntsId" name="cntntsId" value="" />
                        <input type="hidden" id="cntntsPlayTime" name="cntntsPlayTime" value="" />
                        <input type="hidden" id="cntntsThumbPath" name="cntntsThumbPath" value="" />
                        <input type="hidden" id="cntntsApiPath" name="cntntsApiPath" value="" />
                        <p class="attach-box">
                            <span class="video-tit-box"><em>동영상 제목</em><input type="text" id="fileTitle" class="text" /></span>
                            <button type="button" class="btn-style01" onClick="openUpload()"><span>동영상 업로드</span></button>
                            <button type="button" class="btn-style01" onClick="openView()" id="videoView" style="display: none;"><span>동영상 보기</span></button>
                            <span class="attach-ps">한 개의 파일만 등록이 가능합니다.</span>
                        </p>
                        <ul class="attach-list">
                        </ul>
                    </td>
                </tr>
                <tr id="link" style="display:none;"><!-- 자료유형 - 링크 -->
                    <th scope="row">자료</th>
                    <td colspan="3" class="data-box">
                        <p><span>링크제목</span> <input type="text" id="linkTitle" class="text" style="width:300px;" /></p>
                        <p><span>URL</span> <input type="text" id="dataUrl" class="text" style="width:300px;" /></p>
                    </td>
                </tr>
                <tr>
                    <th scope="row">최종수정자</th>
                    <td id="chgMbrNm"></td>
                    <th scope="row">최종수정일</th>
                    <td id="chgDtm"></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <!-- <ul>
                <li><button type="button" class="btn-orange"><span>등록</span></button></li>
                <li><button type="button" class="btn-gray"><span>취소</span></button></li>
            </ul>  write일 때 -->
            <ul>
                <li><button type="button" class="btn-gray" onClick="fn_deleteDataInfo()"><span>삭제</span></button></li>
                <li><button type="button" class="btn-orange" onClick="fn_save()"><span>수정</span></button></li>
                <li><button type="button" class="btn-gray" onClick="fn_goList()"><span>취소</span></button></li>
            </ul><!--  Edit/view일 때 -->
        </div>
    </div>
</div>
<c:import url="/popup/layerPopupBelongMentor.do">
    <c:param name="popupId" value="_coInfoPopup" />
    <c:param name="callbackFunc" value="callbackCoSelected" />
</c:import>

<script type="text/javascript">

    var dataSer = '${param.dataSer}';
    $(document).ready(function(){
        // 수정일경우
        if(dataSer != ''){
            fn_init();
        }
    });

    /* 상세조회 */
    function fn_init(){
        $.ajax({
            url: "${pageContext.request.contextPath}/web/community/ajax.selectDataInfo.do",
            data : {'dataSer' : dataSer},
            success: function(rtnData) {
                $('#ownerMbrNm').val(rtnData[0].ownerMbrNm);
                $('#ownerMbrNo').val(rtnData[0].ownerMbrNo);
                $('#jobNm').append(rtnData[0].jobNm);
                $('#intdcDataYn').val(rtnData[0].intdcDataYn);

                // 자료대상 setting
                var arr = [];
                if(rtnData[0].dataTargtClass == '101537'){
                    arr.push('101534');
                    arr.push('101535');
                }else if(rtnData[0].dataTargtClass == '101538'){
                    arr.push('101535');
                    arr.push('101536');
                }else if(rtnData[0].dataTargtClass == '101539'){
                    arr.push('101534');
                    arr.push('101536');
                }else if(rtnData[0].dataTargtClass == '101540'){
                    arr.push('101534');
                    arr.push('101535');
                    arr.push('101536');
                }else{
                    arr.push(rtnData[0].dataTargtClass)
                }

                $('input[name=dataTargt]').each(function(){
                    currObj = $(this);
                    $.each(arr, function(index, value){
                        if(currObj.val() == value){
                            currObj.prop('checked', true);
                        }
                    });
                });

                $('input[name=dataTypeCd]').each(function(){
                    if(rtnData[0].dataTypeCd == $(this).val()){
                        if($(this).val() == '101759'){
                            getFileList();
                        }else if($(this).val() == '101760'){
                            $('#videoView').css('display', '');
                            $('#videoView').addClass('show');

                            $('#cntntsId').val(rtnData[0].cntntsId);
                            $('#arclSer').val(rtnData[0].arclSer);
                            $('#fileTitle').val(rtnData[0].fileTitle);
                        }
                        $(this).trigger('click');
                    }
                });

                $('#dataNm').val(rtnData[0].dataNm);
                $('#linkTitle').val(rtnData[0].linkTitle);
                $('#dataUrl').val(rtnData[0].dataUrl);
                $('#chgMbrNm').text(rtnData[0].chgMbrNm);
                $('#chgDtm').text(rtnData[0].chgDtm);

            }
        });

    }

    /* 상세 첨부파일 조회 */
    function getFileList() {
        $.ajax({
            url: '${pageContext.request.contextPath}/web/community/ajax.dataFileInfoList.do',
            data : {'dataSer' : dataSer},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var str = '';
                str += '<li id="'+rtnData[0].fileSer+'">';
                str += '    <a href="#">'+rtnData[0].comFileInfo.oriFileNm+ '(' + Math.ceil(rtnData[0].comFileInfo.fileSize/(1024)/(1024)) +'MB)</a>';
                str += '    <button type="button" class="btn-attach-delete" onClick="fn_fileDelete('+rtnData[0].fileSer+')"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>';
                str += '</li>';
                $('#papers .attach-list').empty().append(str);
            }
        });
    }

    /* 자료대상 radio change */
    $('input[name=dataTargt]').change(function(index){
        var currObj = $(this);
        var etcChk = false;

        // 두개 이상 선택 했을 경우
        if($('input[name=dataTargt]:checked').size() > 1){
            $('input[name=dataTargt]:checked').each(function(){
                // 기타를 선택했어??
                if($(this).val() == '101713') {
                    etcChk = true;
                }

                if(etcChk) {
                    alert('학교급과 기타는 동시에 설정할수 없습니다.');
                    currObj.prop('checked', false);
                }
            });
        }
    });

    /* 자료유형 radio change */
    $('input[name=dataTypeCd]').change(function(index){
        if($(this).val() == '101759'){
            $('#papers').css('display', '');
            $('#video').css('display', 'none');
            $('#link').css('display', 'none');
        }else if($(this).val() == '101760'){
            $('#papers').css('display', 'none');
            $('#video').css('display', '');
            $('#link').css('display', 'none');
        }else if($(this).val() == '101761'){
            $('#papers').css('display', 'none');
            $('#video').css('display', 'none');
            $('#link').css('display', '');
        }
    });

    /* 첨부파일 문서 등록 */
    $('#papersFile').change(function(){

        if($('#papers .attach-list li').length >= 1){
            alert('한 개의 파일만 등록이 가능합니다.');
            $('#papersFile').val('');
            return;
        }

        var ext = $('#papersFile').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['hwp', 'docx', 'txt', 'pptx', 'ppt', 'xlsx', 'xls', 'pdf', 'doc', 'jpg', 'jpeg', 'png', 'gif', 'zip', 'egg']) == -1){
            alert('등록 가능한 파일은 hwp ,docx ,txt ,pptx ,ppt ,xlsx ,xls ,pdf ,doc ,jpg ,jpeg ,png ,gif ,zip ,egg  입니다.');
            $('#papersFile').val('');
            return;
        }

        $("#papersFileForm").ajaxForm({
            url : "${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}",
            dataType: 'text',
            success:function(data, status){
                var response = JSON.parse(data);
                if(Math.ceil(response.fileSize/(1024)/(1024)) > 50 ){
                    alert('50MB 이하의 파일만 가능합니다.');
                    return;
                }

                var fileExt = response.fileExt.toLowerCase();
                if($.inArray(fileExt, ['hwp', 'docx', 'txt', 'pptx', 'ppt', 'xlsx', 'xls', 'pdf', 'doc', 'jpg', 'jpeg', 'png', 'gif', 'zip', 'egg']) == -1){
                    alert('등록 가능한 파일은 hwp ,docx ,txt ,pptx ,ppt ,xlsx ,xls ,pdf ,doc ,jpg ,jpeg ,png ,gif ,zip ,egg  입니다.');
                    return;
                }

                var str = '';
                str += '<li id='+response.fileSer+'>';
                str += '    <a href="#">'+response.oriFileNm+'('+Math.ceil(response.fileSize/(1024)/(1024))+'MB)</a>';
                str += '    <button type="button" class="btn-attach-delete" onClick="fn_fileDelete('+response.fileSer+')"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>';
                str += '</li>';

                $('#papers .attach-list').append(str);
            }
        }).submit();
    });

    /* 첨부파일 삭제 */
    function fn_fileDelete(fileSer){
        if(confirm('첨부파일을 정말 삭제하시겠습니까?')){
            $('#'+fileSer).remove();
            $('#papersFile').val('');
        }
    }

    /* 저장 및 수정 */
    function fn_save(){
        if($('#ownerMbrNm').val() == ''){
            alert('멘토를 선택해주세요.');
            return;
        }

        if(!($('input[name=dataTargt]').is(':checked'))){
            alert('자료대상을 선택해주세요');
            return;
        }

        if($.trim($('#dataNm').val()) == ''){
            alert('자료명을 입력해주세요.');
            return;
        }

        // 자료대상
        var checkDataType = new Array;
        $("input:checkbox[name=dataTargt]:checked").each(function() {
            checkDataType.push($(this).val());
        });

        if(checkDataType.length == 2){
            if(!!~checkDataType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkDataType.indexOf("${code['CD101533_101535_중학교']}")){ //초등,중학교
                $("#dataTargtClass").val("${code['CD101533_101537_초등_중학교'] }");
            }else if(!!~checkDataType.indexOf("${code['CD101533_101535_중학교']}") && !!~checkDataType.indexOf("${code['CD101533_101536_고등학교']}")){ //중등,고등학교
                $("#dataTargtClass").val("${code['CD101533_101538_중_고등학교'] }");
            }else if(!!~checkDataType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkDataType.indexOf("${code['CD101533_101536_고등학교']}")){ //초등,고등학교
                $("#dataTargtClass").val("${code['CD101533_101539_초등_고등학교'] }");
            }
        }else if(checkDataType.length == 1){
            $("#dataTargtClass").val(checkDataType[0]);
        }else{
            $("#dataTargtClass").val("${code['CD101533_101540_초등_중_고등학교'] }");
        }

        var _param = {
            'dataSer' : '${param.dataSer}'
          , 'ownerMbrNo' : $('#ownerMbrNo').val()
          , 'intdcDataYn' : $('#intdcDataYn').val()
          , 'dataTargtClass' : $('#dataTargtClass').val()
          , 'dataTypeCd' : $('input[name=dataTypeCd]:checked').val()
          , 'dataNm' : $('#dataNm').val()
          , 'useYn' : 'Y'
        };

        // 파일 Setting
        var fileSer = "";
        if($('input[name=dataTypeCd]:checked').val() == '101759'){
            _param.fileSer = $('#papers .attach-list li').attr('id');
            if(_param.fileSer == null){
                alert('자료를 등록해주세요.');
                return;
            }
        }else if($('input[name=dataTypeCd]:checked').val() == '101760'){
            checkDuration();
            if($("#cntntsId").val() == ''){
                alert('동영상을 업로드해주세요.');
                return;
            }
            var fileTitle = $('#fileTitle').val();
            if($.trim(fileTitle) == ''){
                alert('동영상제목을 입력해주세요');
                return;
            }
            _param.cntntsId = $("#cntntsId").val();
            _param.cntntsPlayTime = $("#cntntsPlayTime").val();
            _param.cntntsThumbPath = $("#cntntsThumbPath").val();
            _param.cntntsApiPath = $("#cntntsApiPath").val();
            _param.boardId = 'lecData';
            _param.fileTitle = fileTitle;
            _param.arclSer = $('#arclSer').val();
        }else{
            var dataUrl = $('#dataUrl').val();
            var linkTitle = $('#linkTitle').val();

            if($.trim(linkTitle) == ''){
                alert('링크제목을 입력해주세요');
                return;
            }

            if($.trim(dataUrl) == ''){
                alert('링크URL을 입력해주세요');
                return;
            }

            _param.dataUrl = dataUrl;
            _param.linkTitle = linkTitle;
        }

        if( confirm('수정하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/web/community/ajax.insertLectureData.do',
                data : _param,
                contentType: "application/json",
                dataType: 'text',
                type: 'GET',
                success: function(rtnData) {
                    if(rtnData == 'SUCCESS'){
                        alert('수정 되었습니다.');
                        location.href = '${pageContext.request.contextPath}/web/community/data/list.do';
                    }
                },
                error: function(xhr, status, err) {
                    alert(err);
                }
            });
        }
    }

    /* 자료등록 삭제 */
    function fn_deleteDataInfo(){
        if( confirm('삭제하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/web/community/ajax.deleteLectureData.do',
                data : {'dataSer' : '${param.dataSer}'},
                contentType: "application/json",
                dataType: 'text',
                type: 'GET',
                success: function(rtnData) {
                    if(rtnData == 'SUCCESS'){
                        alert('삭제 되었습니다.');
                        location.href = '${pageContext.request.contextPath}/web/community/data/list.do';
                    }else if(rtnData == 'ERROR'){
                        alert('해당 자료와 연결된 수업이 있습니다. 연결수업을 해제한 후 삭제해주세요');
                    }
                },
                error: function(xhr, status, err) {
                    alert(err);
                }
            });
        }
    }

    /* 동영상 레이어오픈 */
    function openUpload() {
        if($('#videoView').hasClass('show')){
            if(!confirm('기존의 동영상은 지워집니다. 등록하시겠습니까?')){
                return;
            }
        }
        window.open("${pageContext.request.contextPath}/ext/uploader/uploader.html", "uploader", "scrollbars=no, resizeable=no, width=580, height=280");
    }

    /* 동영상보기 레이어 오픈 */
    function openView() {
        window.open("http://movie.career.go.kr/test/player/index.asp?cID="+ $("#cntntsId").val(), "", "scrollbars=no, resizeable=no, width=672, height=590");
    }

    /* 동영상등록팝업 콜백함수 */
    function checkResult(cid, result, dur, vod, thumb) {
        $("#cntntsId").val(cid);
        $("#cntntsPlayTime").val(dur);
        $("#cntntsThumbPath").val(thumb);
        $("#cntntsApiPath").val(vod);
        $("#videoView").show();
        $("#videoView").addClass('show');
    }

    /* 동영상 플레이시간 Setting */
    function checkDuration() {
        if($("#cntntsId").val() != ""){
            $.ajax({
                url: "${pageContext.request.contextPath}/web/community/ajax.getVideoDuration.do",
                data : {cID : $("#cntntsId").val()},
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                async:false,
                success: function(rtnData) {
                    $("#cntntsPlayTime").val(transSecToTime(rtnData));
                },
                error: function(xhr, status, err) {
                  console.error('${pageContext.request.contextPath}/board/replay/ajax.getVideoDuration.do', status, err.toString());
                }
              });
        }
    }

    function fn_goList(){
        $('#frm').attr('action', '${pageContext.request.contextPath}/web/community/data/list.do');
        $('#frm').attr('method', 'post');
        $('#frm').submit();
    }

    // 소속기관 콜백 함수
    function callbackCoSelected(mentorInfo){
        $('#jobNm').html(mentorInfo.jobNm == 'null'? '' : mentorInfo.jobNm);
        $('#ownerMbrNm').val(mentorInfo.mbrNm);
        $('#ownerMbrNo').val(mentorInfo.mbrNo);
    }

    /* 멘토찾기 팝업 */
    function mentorPopUp(){
        $('body').addClass('dim');
        $("#_coInfoPopup").css("display","block");
        emptyCorpGridSet();
    }

</script>