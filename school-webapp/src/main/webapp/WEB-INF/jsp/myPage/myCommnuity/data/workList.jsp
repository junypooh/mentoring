<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="clasRoomSer" property="principal.clasRoomSer" />
</security:authorize>

<div id="container">
    <div class="location mobile-sb">
        <a href="#" class="home">HOME</a>
        <span class="first">마이페이지</span>
        <span>나의커뮤니티</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type">나의커뮤니티</h2>
        <p class="tit-desc-txt">나의 커뮤니티 등록 내용을 확인할 수 있습니다.</p>
        <ul class="tab-type2 my-community-wrap" style="padding-bottom: 70px;">
            <li class="mypage-data-li">
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/dataList.do">수업자료실<span>자세히보기</span></a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/qnaList.do">Q&amp;A<span>자세히보기</span></a>
            </li>
            <li class="active">
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/workList.do">수업과제<span>자세히보기</span></a>
                <div class="mypage-wrap">
                    <ul class="community-data-list hw-list" id="workList"></ul>
                    <div class="paging" id="paging"></div>
                    <div class="btn">
                        <a href="javascript:void(0)" onClick="fn_popupOpen()" class="btn-border-type m-hide">등록</a>
                    </div>
                </div>
            </li>
        </ul>
        <div class="mypage-list-area">
            <fieldset class="list-search-area">
                <legend>검색</legend>
                <select title="검색어 기준" id="searchKey">
                    <option value="">제목+내용</option>
                    <option value="title">제목</option>
                    <option value="regMbrNm">작성자</option>
                </select><input type="search" id="searchWord" title="검색어 입력"><button type="button" class="btn-type2 search"><span>검색</span></button>
            </fieldset>
        </div>
    </div>
</div>
<div class="cont-quick double">
    <!--a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
    <a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>

<!-- 수업과제 등록 -->
<div class="layer-pop-wrap" id="workLayer">
    <input type="hidden" id="arclSer" name="arclSer" />
    <input type="hidden" id="lectTims" name="lectTims" />
    <input type="hidden" id="clasRoomSer" name="clasRoomSer" />
    <div class="layer-pop">
        <div class="layer-header">
            <strong class="title">수업과제 등록</strong>
        </div>
        <div class="layer-cont">
            <div class="tbl-style homework">
                <table>
                    <caption>수업과제 등록 입력창 - 관련수업, 제목,내용, 분류</caption>
                    <colgroup>
                        <col style="width:20%" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="relationLesson">관련수업</label></th>
                            <td>
                                <select class="slt-style" id="lectSer" title="관련수업">
                                    <option>꽃을 창조하는 직업, 플로리스트</option>
                                    <option>꽃을 창조하는 직업, 플로리스트</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="essentTitle">제목</label></th>
                            <td><input type="text" id="title" class="inp-style" title="제목" /></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="textaInfo">내용</label></th>
                            <td>
                                <div class="text-area popup">
                                    <textarea id="sust" class="ta-style" name="text"></textarea><span class="text-limit"><strong>0</strong> / 100자</span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">첨부파일</th>
                            <td class="add-style">
                                <form id="fileForm" method="post" enctype="multipart/form-data">
                                    <span class="select-file">개별 파일 용량은 20MB 및 최대 5개까지 지원</span>
                                    <div class="search-file">
                                        <input type="file" title="파일찾기" id="uploadFile" name="upload_file" />
                                    </div>
                                </form>
                                <ul class="add-file">
                                    <!-- li><span class="file">가나다라마바사아자차카타파하.pptx(13KB)</span><span>선택취소</span></li>
                                    <li><span class="file">가나다라마바사아자차카타파하.aiv(19MB)</span><span>선택취소</span></li -->
                                </ul>

                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area popup">
                <a href="javascript:void(0)" onClick="fn_registArcl()" class="btn-type2 popup">확인</a>
                <a href="javascript:void(0)" onClick="layerClose()" class="btn-type2 cancel">취소</a>
            </div>
            <a href="javascript:void(0)" onClick="layerClose()" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<!-- // 수업과제 등록 -->

<%-- Template ================================================================================ --%>
<script type="text/html" id="workInfo">
<li>
    <div class="title">
        <a href="javascript:void(0)" onClick="fn_fileList(\${arclSer}, this)">
            <em>\${title}</em>
            <div>
                <span class="user student">\${regMbrNm}</span>
                <span class="school-info">\${schNm} \${clasRoomNm}</span>
                <span class="file">\${fileCnt}개 (\${fileTotalSize}MB)</span>
            </div>
        </a>
    </div>
    <div class="file-list">
        <p class="relation-lesson">
            <strong>관련수업</strong><em><a href="javascript:location.href='${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectSer}&lectTims=\${cntntsTargtTims}&schdSeq=1'">\${lectTitle}</a></em>
            <strong>멘토</strong><em>\${lectrNm}</em>
            <strong>직업</strong><em>\${jobNm}</em>
            <br /><strong>수업일시</strong><em>\${to_date_format(lectDay, ".")} \${to_time_format(lectStartTime, ":")} ~ \${to_time_format(lectEndTime, ":")} (\${to_time_space(lectStartTime,lectEndTime)}분)</em>
        </p>

        <div class="writing-btn homework-btn-group">
            <a href="javascript:void(0)" onClick="fn_popupOpen(\${arclSer}, \${lectSer})" class="btn-edit">수정</a>
            <a href="javascript:void(0)" onClick="fn_deleteArcl(\${arclSer})" class="btn-del">삭제</a>
        </div>
        <div class="script-cont">
            <p>{{html replaceLineBreakHtml(sust)}}</p>
        </div>
        {{if ansYn == 'Y'}}
            <div class="download-brd">
                <a href="#" class="reply">답변</a>
                <ul>
                    <li>
                        <div style="padding-left:39px;">{{html replaceLineBreakHtml(cntntsSust)}}</div>
                    </li>
                </ul>
            </div>
        {{/if}}
        <div class="download-brd">
        </div>
            <a href="javascript:void(0)" class="fn_fileAllDown(\${arclSer})">전체파일 다운로드</a>
        <ul class="fileSet"></ul>
    </div>
</li>
</script>
<%-- Template ================================================================================ --%>

<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={fn_loadData} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
                 document.getElementById('paging')
             );
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10
        }
    };

    var data = null;

    if(${isMobile}){
        dataSet.params.pageSize = 5;
    }

    $(document).ready(function(){
        enterFunc($("#searchWord"), fn_loadData);

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $('body').removeClass('dim');
                $("#workLayer").hide();
            }
        });

        fn_loadData();
    });

    function fn_loadData(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'boardId' : 'lecWork'
              , 'siteGbn' : 'sMyComm'
              , 'srchMbrNo' : '${mbrNo}'
              , 'searchKey': $('#searchKey').val()
              , 'searchWord': $('#searchWord').val()
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.mentorArclInfoList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                data = rtnData;

                $("#workList").empty();
                if(totalCount > 0) {
                    $("#workInfo").tmpl(rtnData).appendTo("#workList");
                } else {
                    $("#workList").append('<li><div class="title title-blank">등록된 수업과제가 없습니다.</div></li>');
                }

                mentor.pageNavi.setData(dataSet.params);

                myCommunity();

            }
        });
    }

    /* Tab 이동 */
    function tabChg(number){
        switch (number) {
            case 0 :
                location.href = '${pageContext.request.contextPath}/myPage/myCommnuity/data/dataList.do';
                break;
            case 1  :
                location.href = '${pageContext.request.contextPath}/myPage/myCommnuity/data/qnaList.do';
                break;
            case 2  :
                location.href = '${pageContext.request.contextPath}/myPage/myCommnuity/data/workList.do';
                break;
        }
    }

    /* 상세 파일 조회 */
    function fn_fileList(arclSer, obj){
        var _param = jQuery.extend({
                'boardId' : 'lecWork'
              , 'arclSer' : arclSer
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.listArclFileInfo.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var str = '';
                $(rtnData).each(function(i){
                    str += '<li id="'+arclSer+'">';
                    str += '    <span class="file-type '+rtnData[i].fileInfo.fileExt.toLowerCase()+'">';
                    str += '        <a href="${pageContext.request.contextPath}/fileDown.do?fileSer='+rtnData[i].fileInfo.fileSer+'">'+rtnData[i].fileInfo.oriFileNm+'</a>';
                    str += '    </span>';
                    str += '    <span class="file-size">'+Math.ceil(rtnData[i].fileInfo.fileSize/(1024)/(1024))+'MB</span>';
                    str += '</li>';
                });

                $(obj).parent().parent().find('ul.fileSet').empty().append(str);

                dataDetailShow(obj);
            }
        });
    }

    /* 상세 펼치기 */
    function dataDetailShow(obj){
        if(!$(obj).parent().hasClass('active')){
            $('.community-data-list .title').removeClass('active');
            $(obj).parent().addClass('active');

        }else{
            $(obj).parent().removeClass('active');
        }
        myCommunity();
    }

    /* 수업런타임 */
    function to_time_space(start, end){
        var startTime = to_time_format(start, ":");
        var startDate = new Date("8/24/2009 " + startTime);
        var endTime = to_time_format(end, ":");
        var endDate  = new Date("8/24/2009 " + endTime);
        var tmp = (endDate.getTime() - startDate.getTime()) / 60000;
        return tmp;
    }

    /* 레이어팝업 열기 */
    function layerOpen(){
        $('body').addClass('dim');
        $('.selectbox-zindex-box').css('display', 'block');
        $('#workLayer').attr('tabindex',0).show().focus();
    }

    /* 레이어 팝업 닫기 */
    function layerClose(){
        //작성된 데이터 삭제
        $('#arclSer').val('');
        $('#title').val('');
        $('#sust').val('');

        $('#workLayer').hide();
        $('.selectbox-zindex-box').css('display', 'none');
        $('body').removeClass('dim');
    }

    /* 레이어팝업 상세 */
    function fn_popupOpen(arclSer, lectSer){
        if(!(fn_getLectList(lectSer))){
            return;
        }

        if(arclSer != null){
            $('.layer-header .title').text('수업과제 수정');
            fn_layerFileList(arclSer);

            $.each(data, function(){
                if(arclSer == this.arclSer){
                    $('#arclSer').val(this.arclSer);
                    $('#title').val(this.title);
                    $('#sust').val(this.sust);
                    $('#workLayer .text-limit strong').text(this.sust.length);
                }
            });
        }else{
            $('.layer-header .title').text('수업과제 등록');
        }

        layerOpen();

    }

    /* 레이어 수업리스트 조회 */
    function fn_getLectList(lectSer){
        var rtnStatus = null;
        $.ajax({
            url: mentor.contextpath+"/community/ajax.getLastLectList.do",
            data : {mbrNo : '${mbrNo}'},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            async:false,
            success: function(rtnData) {

                if(rtnData.length > 0){
                    console.log('a');
                    var arr = new Array();

                    $(rtnData).each(function(i){
                        var lectData = {};
                        var lectInfo = rtnData[i].LECT_TIMS + '||' + rtnData[i].CLAS_ROOM_SER;
                        lectData.lectInfo = lectInfo;
                        lectData.lectSer = rtnData[i].LECT_SER;
                        lectData.lectTitle = rtnData[i].LECT_TITLE;

                        arr.push(lectData);
                    });

                    $('#lectSer').loadSelectOptionsEtc(arr, lectSer,'lectSer','lectTitle',0, 'lectInfo').change();
                    rtnStatus = true;
                }else{
                    alert('과제를 등록할 수업이 없습니다.');
                    rtnStatus = false;
                }

            }
        });

        return rtnStatus;
    }

    /* 레이어 파일 조회 */
    function fn_layerFileList(arclSer){
        var _param = jQuery.extend({
                'boardId' : 'lecWork'
              , 'arclSer' : arclSer
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.listArclFileInfo.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var str = '';
                $(rtnData).each(function(i){

                    str += '<li id="'+rtnData[i].fileSer+'">';
                    str += '    <span class="file">'+rtnData[i].fileInfo.oriFileNm+'('+Math.ceil(rtnData[i].fileInfo.fileSize/(1024)/(1024))+'MB)</span>';
                    str += '    <span onClick="fn_fileDelete('+rtnData[i].fileSer+')">선택취소</span>';
                    str += '</li>';
                });

                $('.add-file').empty().append(str);
            }
        });
    }

    /* 첨부파일 삭제 */
    function fn_fileDelete(fileSer){
        if(confirm('첨부파일을 정말 삭제하시겠습니까?')){
            $('#'+fileSer).remove();
        }
    }

    /* 첨부파일 추가 */
    $('#uploadFile').change(function(){
        if($('.add-file li').length >= 5){
            alert('최대 5개의 파일을 등록할 수 있습니다.');
            $('#uploadFile').val('');
            return;
        }

        var ext = $('#uploadFile').val().split('.').pop().toLowerCase();
        if($.inArray(ext, ['hwp', 'docx', 'txt', 'pptx', 'ppt', 'xlsx', 'xls', 'pdf', 'doc', 'jpg', 'jpeg', 'png', 'gif', 'zip', 'egg']) == -1){
            alert('등록 가능한 파일은 hwp ,docx ,txt ,pptx ,ppt ,xlsx ,xls ,pdf ,doc ,jpg ,jpeg ,png ,gif ,zip ,egg  입니다.');
            $('#uploadFile').val('');
            return;
        }

        $("#fileForm").ajaxForm({
            url : "${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}",
            dataType: 'text',
            success:function(data, status){
                var response = JSON.parse(data);

                if( !((Math.ceil(response.fileSize/(1024)/(1024))) <= 20) ){
                    alert('개별 파일 용량은 20MB 까지 지원합니다.');
                    return;
                }

                var fileExt = response.fileExt.toLowerCase();
                if($.inArray(fileExt, ['hwp', 'docx', 'txt', 'pptx', 'ppt', 'xlsx', 'xls', 'pdf', 'doc', 'jpg', 'jpeg', 'png', 'gif', 'zip', 'egg']) == -1){
                    alert('등록 가능한 파일은 hwp ,docx ,txt ,pptx ,ppt ,xlsx ,xls ,pdf ,doc ,jpg ,jpeg ,png ,gif ,zip ,egg  입니다.');
                    return;
                }

                var str = '';
                str += '<li id="'+response.fileSer+'">';
                str += '    <span class="file">'+response.oriFileNm+'('+Math.ceil(response.fileSize/(1024)/(1024))+'MB)</span>';
                str += '<span onClick="fn_fileDelete('+response.fileSer+')">선택취소</span>';
                str += '</li>';

                $('#uploadFile').val("");
                $('.add-file').append(str);
            }
        }).submit();
    });

    /* 팝업 내용 글자수 setting */
    $('#sust').on('keyup', function() {
        if($(this).val().length > 100) {
            $(this).val($(this).val().substring(0, 100));
            alert('100자만 입력가능합니다.');
        }
        $('#workLayer .text-limit strong').text($(this).val().length);
    });

    /* 레이어 확인 버튼 클릭 (등록 및 수정) */
    function fn_registArcl(){

        if($.trim($('#title').val()) == ''){
            alert('제목을 입력하세요.');
            return;
        }

        var fileSers = "";
        $('.add-file').children().each(function(){
            fileSers += $(this).attr('id') + ',';
        });
        var lectInfo = $("#lectSer option:selected").attr('data').split('||');
        if(lectInfo.length > 0){
            var lectTims = lectInfo[0];
            var clasRoomSer = lectInfo[1];
        }

        var _param = {
            'boardId' : 'lecWork',
            'title' : $('#title').val(),
            'sust' : $('#sust').val(),
            'arclSer' : $('#arclSer').val(),
            'cntntsTargtCd' : '101510',
            'cntntsTargtNo' : $("#lectSer option:selected").val(),
            'cntntsTargtTims' : lectTims,
            'cntntsTargtNm' : $("#lastLect option:selected").text(),
            'fileSers' : fileSers,
            'cntntsId' : clasRoomSer
        };

        var msg = '';
        if($('#arclSer').val() != ''){
            msg = '수정';
        }else{
            msg = '등록';
        }

        if(confirm(msg + "하시겠습니까?")){
            $.ajax({
                url: '${pageContext.request.contextPath}/community/ajax.registArcl.do',
                data : JSON.stringify(_param),
                contentType: "application/json",
                dataType: 'json',
                type: 'POST',
                success: function(rtnData) {
                    if(rtnData.success){
                        alert(rtnData.data);
                        layerClose();
                        fn_loadData();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.registArcl.do", status, err.toString());
                }
            });
        }
    }

    /* 수업과제 삭제 */
    function fn_deleteArcl(arclSer){
        if(!confirm("삭제하시겠습니까?")) {
          return false;
        }
        var _param = {
            'boardId' : 'lecWork',
            'arclSer' : arclSer
        };
        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.deleteArcl.do',
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType: 'json',
            type: 'post',
            cache: false,
            success: function(rtnData) {
                if(rtnData.success){
                    alert("삭제되었습니다.");
                        layerClose();
                        fn_loadData();
                }
            },
            error: function(xhr, status, err) {
                console.error("ajax.deleteArcl.do", status, err.toString());
            }
        });
    }

    /* 전체파일 다운로드 */
    function fn_fileAllDown(arclSer){
        console.log('a');
        if($('.add-file li').length > 0){
            location.href = '${pageContext.request.contextPath}/fileDownAll.do?arclSer='+arclSer+'&boardId=lecWork';
        }

    }
</script>