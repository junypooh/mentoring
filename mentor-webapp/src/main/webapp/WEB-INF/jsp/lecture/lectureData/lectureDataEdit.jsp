<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>

<div id="container">
    <div class="location">
        <a href="#" class="home">메인으로 이동</a>
        <span>수업관리</span>
        <span>자료등록</span>
    </div>
    <div class="content">
        <h2 class="fs24">자료등록</h2>
        <div class="cont type1">
            <div class="board-title1">
                <h3 class="board-tit">기본정보</h3>
                <span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
            </div>
            <div class="board-input-type all-view">
                <table>
                    <caption>자료등록 - 멘토, 직업명, 구분, 자료대상, 자료유형, 자료명, 자료, 등록자, 등록일, 연결수업</caption>
                    <colgroup>
                        <col style="width:100px" />
                        <col />
                        <col style="width:100px" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" class="compulsory">멘토</th>
                            <td>
                                <a href="#layer1" class="btn-type5 layer-open">멘토찾기</a>
                                <input type="text" class="inp-style1" style="width:150px;" id="ownerMbrNm" readOnly>
                                <input type="hidden" id="ownerMbrNo" name="ownerMbrNo" />
                            </td>
                            <th scope="row">직업명</th>
                            <td id="jobNm"></td>
                        </tr>
                        <tr>
                            <th scope="row" class="compulsory">구분</th>
                            <td colspan="3">
                                <select id="intdcDataYn">
                                    <option value="N">수업자료</option>
                                    <option value="Y">멘토자료</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="compulsory">자료대상</th>
                            <td colspan="3">
                                <input type="hidden" id="dataTargtClass" value=""/>
                                <label class="chk-skin2"><input type="checkbox" name="dataTargt" class="chk-skin" value="101534" />초등</label>
                                <label class="chk-skin2"><input type="checkbox" name="dataTargt" class="chk-skin" value="101535" />중등</label>
                                <label class="chk-skin2"><input type="checkbox" name="dataTargt" class="chk-skin" value="101536" />고등</label>
                                <label class="chk-skin2"><input type="checkbox" name="dataTargt" class="chk-skin" value="101713" />기타</label>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="compulsory">자료유형</th>
                            <td colspan="3">
                                <label class="radio-skin"><input type="radio" name="dataTypeCd" value="101759" class="radio-skin">문서</label>
                                <label class="radio-skin"><input type="radio" name="dataTypeCd" value="101760" class="radio-skin">동영상</label>
                                <label class="radio-skin"><input type="radio" name="dataTypeCd" value="101761" class="radio-skin">링크</label>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row" class="compulsory">자료명</th>
                            <td colspan="3"><input type="text" class="inp-style1" style="width:630px;" id="dataNm" /></td>
                        </tr>
                        <tr id="papers"><!-- 자료유형 - 문서 -->
                            <th scope="row" class="compulsory">자료</th>
                            <td colspan="3">
                                <form id="papersFileForm" method="post" enctype="multipart/form-data">
                                    <div class="input-file">
                                        <input type="file" id="papersFile" name="upload_file">
                                        <span class="max-num">개별 파일 용량 50MB , 한 개의 파일만 등록이 가능합니다. </span>
                                    </div>
                                </form>
                                <!-- ul class="file-list-type01">
                                    <li>가나다라마바사아자차카타파하.pptx(13KB)<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제"></a></li>
                                    <li>가나다라마바사아자차카타파하.avi(19MB)<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제"></a></li>
                                </ul -->
                            </td>
                        </tr>
                        <tr id="video" style="display:none;"><!-- 자료유형 - 동영상 -->
                            <th scope="row" class="compulsory">자료</th>
                            <td colspan="3">
                                <input type="hidden" id="arclSer" name="arclSer" value="" />
                                <input type="hidden" id="cntntsId" name="cntntsId" value="" />
                                <input type="hidden" id="cntntsPlayTime" name="cntntsPlayTime" value="" />
                                <input type="hidden" id="cntntsThumbPath" name="cntntsThumbPath" value="" />
                                <input type="hidden" id="cntntsApiPath" name="cntntsApiPath" value="" />
                                <p class="mgb-10"><span>동영상 제목</span><input type="text" id="fileTitle" class="text mgl-15" style="width:270px;" /></p>
                                <div>
                                    <a href="javascript:openUpload();" class="btn-type5">동영상 업로드</a>
                                    <a href="javascript:openView();" class="btn-type5" id="videoView" style="display: none;">동영상 보기</a>
                                    <span class="max-num">한 개의 파일만 등록이 가능합니다. </span>
                                </div>
                            </td>
                        </tr>
                        <tr id="link" style="display:none;"><!-- 자료유형 - 링크 -->
                            <th scope="row" class="compulsory">자료</th>
                            <td colspan="3" class="td-data-video">
                                <p><label><span>링크 제목</span><input type="text" id="linkTitle" class="inp-style1 h30" style="width:485px;"></label></p>
                                <p><label><span>URL</span><input type="text" id="dataUrl" class="inp-style1 h30" style="width:485px;"></label></p>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">등록자</th>
                            <td id="regMbrNm"></td>
                            <th scope="row">등록일</th>
                            <td id="regDtm"></td>
                        </tr>
                        <tr>
                            <th scope="row">연결수업</th>
                            <td id="connectLect" colspan="3">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <c:choose>
                <c:when test="${param.dataSer != null}">
                    <div class="btn-area">
                        <a href="javascript:fn_deleteDataInfo();" class="btn-type2">삭제</a>
                        <a href="javascript:fn_save();" class="btn-type2 gray" id="updateBtn">수정</a>
                        <a href="lectureDataList.do" class="btn-type2 gray">목록</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="btn-area">
                        <a href="javascript:fn_save();" class="btn-type2" id="saveBtn">등록</a>
                        <a href="javascript:location.href='${pageContext.request.contextPath}/lecture/lectureData/lectureDataList.do'" class="btn-type2 gray">취소</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>

<jsp:include page="/WEB-INF/jsp/layer/layerPopupBelongMentor.jsp">
    <jsp:param value="callbackFunc" name="callbackFunc"/>
</jsp:include>

<script type="text/javascript">
    var dataSer = '${param.dataSer}';


    $(document).ready(function(){
        // 교육수행기관이 아니면 직업명 비노출
        if('${mbrCualfCd}' != '101501'){
            $('tbody > tr').eq(0).children('td').children().eq(0).css('display', "none");
            $('tbody > tr').eq(0).children('td').attr('colspan', '3');
            $('tbody > tr').eq(0).children().eq(2).css('display', "none");
            $('tbody > tr').eq(0).children().eq(3).css('display', "none");

            $('#ownerMbrNo').val('${mbrNo}');
            $('#ownerMbrNm').val('${username}');
        }

        // 등록일경우
        if(dataSer == ''){
            $('#regMbrNm').text('${username}');
            $('#regDtm').text(to_date_format(getToday(), '.'));
            // 연결수업 비노출
            $('tbody').children(':last').css('display', "none");

            $('input[name=dataTargt]').eq(0).prop('checked', true);
            $('input[name=dataTargt]').eq(0).parent().addClass('checked');

            $('input[name=dataTypeCd]').eq(0).prop('checked', true);
            $('input[name=dataTypeCd]').eq(0).parent().addClass('checked');
        }else{
            fn_init();
        }
    });

    /* 상세조회 */
    function fn_init(){
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.lectureDataList.do',
            data : {'dataSer' : dataSer},
            success: function(rtnData) {
                $('#ownerMbrNm').val(rtnData[0].ownerMbrNm);
                $('#ownerMbrNo').val(rtnData[0].ownerMbrNo);
                $('#intdcDataYn').val(rtnData[0].intdcDataYn);
                $('#jobNm').text(rtnData[0].jobNm != null ? rtnData[0].jobNm : '');

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
                            currObj.parent().addClass('checked');
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
                $('#regMbrNm').text(rtnData[0].regMbrNm);
                $('#regDtm').text(rtnData[0].regDtm);

                // 연결수업 조회
                getConnectLect();


                // 연결수업이 있을시 구분 변경 불가
                if($('#connectLect > p').length > 0){
                    $('tbody > tr').eq(1).find('td').text(rtnData[0].intdcDataYn = 'Y' ? '멘토자료' : '수업자료');
                }

            }
        });
    }

    /* 상세 첨부파일 조회 */
    function getFileList() {
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.dataFileInfoList.do',
            data : {'dataSer' : dataSer},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var str = '';
                str += '<ul class="file-list-type01" id='+rtnData[0].fileSer+'>';
                str += '    <li>'+rtnData[0].comFileInfo.oriFileNm+'('+Math.ceil(rtnData[0].comFileInfo.fileSize/(1024)/(1024))+'MB)<a href="javascript:fn_fileDelete('+rtnData[0].fileSer+')"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제"></a></li>';
                str += '</ul>';
                $('#papers > td').append(str);
            }
        });
    }

    /* 멘토찾기 팝업 콜백 함수 */
    function callbackFunc(mbrNo, mbrNm, jobNo, jobNm){
        $('#ownerMbrNm').val(mbrNm);
        $('#ownerMbrNo').val(mbrNo);
        $('#jobNm').append(jobNm);
    }

    /* 자료대상 radio change */
    $('input[name=dataTargt]').change(function(index){
        var currObj = $(this);
        var etcChk = false;
        if(currObj.parent().hasClass('checked')) {
            currObj.parent().removeClass('checked')
        } else {
            currObj.parent().addClass('checked');
        }

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
                    currObj.parent().removeClass('checked');
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

        if($('#papers .file-list-type01 li').length >= 1){
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
                str += '<ul class="file-list-type01" id='+response.fileSer+'>';
                //str += '    <li>'+response.oriFileNm+'(13KB)<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제"></a></li>';
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
            $('#papersFile').val('');
        }
    }

    /* 저장 및 수정 */
    var loading = false;
    function fn_save(){
        if(loading == true){
            return;
        }

        if(!confirm('저장하시겠습니까?')){
            return;
        }

        if($('#ownerMbrNm').val() == ''){
            alert('멘토를 선택해주세요.');
            return;
        }

        if(!$('.chk-skin2').hasClass('checked')){
            alert('자료대상을 선택해주세요');
            return;
        }

        if($.trim($('#dataNm').val()) == ''){
            alert('자료명을 입력해주세요.');
            return;
        }

        // 자료대상
        var checkDataType = new Array;
        $("input:checkbox[name=dataTargt]").each(function() {
            if($(this).parent().hasClass("checked")){
                var checkVal = $(this).val();
                checkDataType.push(checkVal);
            }
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
            _param.fileSer = $('#papers .file-list-type01').attr('id');
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
            if($("#fileTitle").val() == ''){
                alert('동영상제목을 입력해주세요.');
                return;
            }
            _param.cntntsId = $("#cntntsId").val();
            _param.cntntsPlayTime = $("#cntntsPlayTime").val();
            _param.cntntsThumbPath = $("#cntntsThumbPath").val();
            _param.cntntsApiPath = $("#cntntsApiPath").val();
            _param.boardId = 'lecData';
            _param.fileTitle = $("#fileTitle").val();
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

        // 연결수업있을시 text로 바꿔주기때문에 값 set
        if(typeof(_param.intdcDataYn) == 'undefined'){
            if($('tbody > tr').eq(1).find('td').text() == '멘토자료'){
                _param.intdcDataYn = 'Y'
            }else{
                _param.intdcDataYn = 'Y'
            }
        }
        loading = true;
        $('#saveBtn').text('처리중');
        $('#updateBtn').text('처리중');
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.insertLectureData.do',
            data : _param,
            contentType: "application/json",
            dataType: 'text',
            type: 'GET',
            success: function(rtnData) {
                if(rtnData == 'SUCCESS'){
                    alert('저장 되었습니다.');
                    location.href = '${pageContext.request.contextPath}/lecture/lectureData/lectureDataList.do';
                }else{
                    loading = false;
                    $('#saveBtn').text('등록');
                    $('#updateBtn').text('수정');
                }
            },
            error: function(xhr, status, err) {
                loading = false;
                $('#saveBtn').text('등록');
                $('#updateBtn').text('수정');
                alert(err);
            }
        });
    }

    /* 연결수업 조회 */
    function getConnectLect(){
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.connectLectList.do',
            data : {'dataSer' : dataSer},
            async: false,
            success: function(rtnData) {
                var str = '';
                for(var i=0; i<rtnData.length; i++){
                    str += '<p>'+to_date_format2(rtnData[i].lectDay) +' / '+ to_time_format(rtnData[i].lectStartTime, ':') + ' ~ ' + to_time_format(rtnData[i].lectEndTime, ':') + ' / '+ rtnData[i].lectTitle +'</p>';
                }
                $('#connectLect').empty().append(str);
            }
        });
    }

    /* 자료등록 삭제 */
    function fn_deleteDataInfo(){
        if($('#connectLect').children('p').size() > 0){
            alert('해당 자료와 연결된 수업이 있습니다. 연결수업을 해제한 후 삭제해주세요');
            return;
        }
        if( confirm('삭제하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.deleteLectureData.do',
                data : {'dataSer' : '${param.dataSer}'},
                contentType: "application/json",
                dataType: 'text',
                type: 'GET',
                success: function(rtnData) {
                    if(rtnData == 'SUCCESS'){
                        alert('삭제 되었습니다.');
                        location.href = '${pageContext.request.contextPath}/lecture/lectureData/lectureDataList.do';
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
                url: "${pageContext.request.contextPath}/lecture/lectureData/ajax.getVideoDuration.do",
                data : {cID : $("#cntntsId").val()},
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                async:false,
                success: function(rtnData) {
                    $("#cntntsPlayTime").val(transSecToTime(rtnData));
                },
                error: function(xhr, status, err) {
                  console.error('${pageContext.request.contextPath}/lecture/lectureData/ajax.getVideoDuration.do', status, err.toString());
                }
              });
        }
    }

</script>