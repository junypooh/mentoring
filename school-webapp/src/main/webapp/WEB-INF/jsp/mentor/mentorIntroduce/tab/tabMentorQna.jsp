<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
  <security:authentication var="mbrNo" property="principal.mbrNo" />
</security:authorize>

<!-- 문의하기 -->
<div class="mentor-inquiry navi-content tab-cont active">
    <h3>문의하기</h3>
    <a href="javascript:fn_insertArcl();" class="btn-inquiry m-hide">등록</a>
    <ul class="writing-list" id="qnaList"></ul>
    <div class="paging" id="paging"></div>
    <!-- div class="btn-more-view">
        <a href="#">더보기 <span>00</span></a>
    </div -->
</div>
<!-- //문의하기 -->

<!-- layerpopup -->
<div class="layer-pop-wrap" id="qnaLayer">
    <input type="hidden" id="arclSer" name="arclSer" value="" />
    <div class="layer-pop">
        <div class="layer-header">
            <strong class="title">문의하기 등록</strong>
        </div>
        <div class="layer-cont">
            <div class="tbl-style inquiry">
                <p><span class="essent-inp">필수입력 알림</span>필수입력</p>
                <table>
                    <caption>문의하기 등록 - 분류,제목,내용</caption>
                    <colgroup>
                        <col style="width:20%" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><span class="essent-inp">필수입력</span><label for="classifiCation">분류</label></th>
                            <td>멘토
                                <span class="secret-text">
                                    <label class="chk-skin">
                                        <input type="checkbox" title="비밀글" id= "scrtArclYn" name="scrtArclYn" value="Y"/><span class="secret-check">비밀글</span>
                                    </label>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="essent-inp">필수입력</span><label for="essentTitle2">제목</label></th>
                            <td><input type="text" id="title" class="inp-style" title="제목" /></td>
                        </tr>
                        <tr>
                            <th scope="row"><span class="essent-inp">필수입력</span><label for="textaInfo2">내용</label></th>
                            <td>
                                <div class="text-area popup">
                                    <textarea id="sust" class="ta-style" name="sust" onKeyup="fn_lengthChk()"></textarea><span class="text-limit"><strong>0</strong> / 400자</span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area popup">
                <a href="javascript:fn_updateArcl();" class="btn-type2 popup">확인</a>
                <a href="javascript:layerClose();" class="btn-type2 cancel">취소</a>
            </div>
            <a href="javascript:layerClose();" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<!-- //layerpopup -->

<%-- Template ================================================================================ --%>
<script type="text/html" id="listQnaInfo">
    <li>
        <div class="subject-info {{if scrtArclYn == 'Y'}}secret{{/if}}">
            <a href="#" class="subject">\${title}</a>
            <span class="user {{if regClassNm == 'student'}}student{{/if}}">\${regMbrNm}</span>
            <span class="school-info">\${schNm} \${clasRoomNm}</span>
            <span class="date">\${fn_date_to_string(regDtm)}</span>
        </div>
        {{if scrtArclYn == 'N' || regMbrNo == '${mbrNo}'}}
            <div class="subject-detail">
            <div class="relation-lesson">
                {{if lectTitle != null}}
                    <span><strong>관련수업 </strong><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${lectSer}&lectTims=1&schdSeq=1">\${lectTitle}</a></span>
                {{/if}}
            </div>
                <div class="question-detail">
                    <div class="question">
                        <span class="title">질문</span>
                        <p class="info">{{html sust.replaceAll('\n', '<br>')}}</p>
                    </div>
                    {{if ansYn == 'Y'}}
                        <div class="answer">
                            <span class="title">답변</span>
                            <p class="info">{{html cntntsSust.replaceAll('\n', '<br>')}}</p>
                        </div>
                    {{/if}}
                    {{if regMbrNo == '${mbrNo}' && ansYn == 'N'}}
                        <div class="writing-btn">
                            <a href="javascript:void(0);" onClick="fn_qnaDetail(\${arclSer})" class="btn-modi">수정</a>
                            <a href="javascript:void(0);" onClick="fn_deleteArcl(\${arclSer});" class="btn-del">삭제</a>
                        </div>
                    {{/if}}
                </div>
            </div>
        {{/if}}
    </li>
</script>
<%-- Template ================================================================================ --%>


<%-- Template ================================================================================ --%>
<script type="text/html" id="emptyQna">
    <li>
        <div class="subject-info" >
            <p><center>등록된 문의글이 없습니다.</center></p>
        </div>
    </li>
</script>
<%-- Template ================================================================================ --%>


<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 5,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10
        }
    };

    if(${isMobile}){
        dataSet.params.pageSize = 5;
    }

    mentor.pageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:fn_mentorQnA, totalRecordCount:0, recordCountPerPage:5, pageSize:dataSet.params.pageSize}),
            document.getElementById('paging')
    );


    $(document).ready(function(){
        fn_mentorQnA();
    });

    function fn_mentorQnA(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
            'boardId' : 'lecQnA',
            'srchMbrNo' : '${param.mbrNo}'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.getMentorArclInfoList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                    $("#qnaList").empty();
                    $("#listQnaInfo").tmpl(rtnData).appendTo("#qnaList");
                }else{
                    $("#qnaList").empty();
                    $("#emptyQna").tmpl(1).appendTo("#qnaList");
                }
                dataSet.params.totalRecordCount = totalCount;


                mentor.pageNavi.setData(dataSet.params);

                // script bind
                accordionList();

            }
        });
    };

    // 레이어팝업 열기
    function layerOpen(){
        $('body').addClass('dim');
        $('.selectbox-zindex-box').css('display', 'block');
        $('#qnaLayer').attr('tabindex',0).show().focus();
        position_cm();
    }

    // 레이어 팝업 닫기
    function layerClose(){
        //작성된 데이터 삭제
        $('#title').val('');
        $('#sust').val('');
        $('#qnaLayer .text-limit strong').text(0);
        $('#scrtArclYn').attr('checked', false);
        $('#scrtArclYn').parent().removeClass('checked');
        $('#arclSer').val('');

        $('#qnaLayer').hide();
        $('.selectbox-zindex-box').css('display', 'none');
        $('body').removeClass('dim');
    }

    // 등록 버튼 클릭
    function fn_insertArcl(){
        if('${mbrNo}' == ''){
            alert('로그인이 필요한 서비스 입니다.');
            location.href = mentor.contextpath+'/login.do';
            return;
        }
        $('.layer-header strong').text('문의하기 등록');
        layerOpen();
    }

    // 등록 및 수정
    function fn_updateArcl(){
        if($.trim($('#title').val()) == ''){
            alert('제목을 입력해 주세요.');
            return;
        }
        if($.trim($('#sust').val()) == ''){
            alert('내용을 입력해 주세요');
            return;
        }

        var scrtArclYn = 'N';
        if($('#scrtArclYn:checked').is(':checked')){
            scrtArclYn = 'Y';
        }

        var _param = {
            'boardId' : 'lecQnA'
          , 'title' : $('#title').val()
          , 'prefNo' : 'qnaMentor'
          , 'cntntsTargtId' : '${param.mbrNo}'
          , 'sust' : $('#sust').val()
          , 'scrtArclYn' : scrtArclYn
          , 'arclSer' : $('#arclSer').val()
        };

        var msg = '등록';
        if($('#arclSer').val() != ''){
            msg = '수정';
        }

        if( confirm(msg + '하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/community/ajax.registArcl.do',
                data : JSON.stringify(_param),
                contentType: "application/json",
                dataType: 'JSON',
                type: 'POST',
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert(msg+'되었습니다.');
                        layerClose();
                        fn_mentorQnA(1);
                    }else {
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    alert(err);
                }
            });
        }
    }

    // 문의 상세 조회
    function fn_qnaDetail(arclSer){

        $('#arclSer').val(arclSer);

        var _param = jQuery.extend({
                'arclSer' : arclSer
              , 'boardId' : 'lecQnA'
              , 'srchMbrNo' : '${param.mbrNo}'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.getMentorArclInfoList.do',
            data : $.param(_param, true),
            success: function(rtnData) {
                $('#title').val(rtnData[0].title);
                $('#sust').val(rtnData[0].sust);
                $('#qnaLayer .text-limit strong').text(rtnData[0].sust.length);
                if(rtnData[0].scrtArclYn == 'Y'){
                    $('#scrtArclYn').attr('checked', true);
                    $('#scrtArclYn').parent().addClass('checked');
                }
            },
            error: function(request,status,error){
                 alert("error:"+error);
            }
        });
        $('.layer-header strong').text('문의하기 수정');
        layerOpen();
    }

    // 답변 글자수 setting
    function fn_lengthChk(){
        sustLength = $('#sust').val().length;
        if(sustLength > 400){
            alert("입력 글자 수를 초과하였습니다.");
            $('#sust').val($('#sust').val().substr(0,400));
            $('#qnaLayer .text-limit strong').text($('#sust').val().length);
            return;
        }
        $('#qnaLayer .text-limit strong').text(sustLength);
    }

    // 질문삭제
    function fn_deleteArcl(arclSer){
        var _param = {
                'arclSer' : arclSer
              , 'boardId' : 'lecQnA'
        };
        if( confirm('삭제하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/community/ajax.deleteArcl.do',
                data : JSON.stringify(_param),
                contentType: "application/json",
                dataType: 'json',
                type: 'post',
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('삭제되었습니다.');
                        fn_mentorQnA(1);
                    }
                },
                error: function(request,status,error){
                     alert("error:"+error);
                }
            });
        }
    }
</script>