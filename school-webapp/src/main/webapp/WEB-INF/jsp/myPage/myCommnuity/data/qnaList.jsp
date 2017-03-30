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
            <li class=" active">
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/qnaList.do">Q&amp;A<span>자세히보기</span></a>
                <div class="mypage-wrap">
                    <ul class="writing-list" id="qnaList"></ul>
                    <div class="paging" id="paging"></div>
                    <div class="btn">
                        <a href="javascript:void(0)" onClick="fn_popupOpen()" class="btn-border-type m-hide">등록</a>
                    </div>
                </div>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/workList.do">수업과제<span>자세히보기</span></a>
            </li>
        </ul>
        <div class="mypage-list-area">
            <fieldset class="list-search-area">
                <legend>검색</legend>
                <select title="검색어 기준" id="searchKey">
                    <option value="0">제목+내용</option>
                    <option value="1">제목</option>
                    <option value="2">작성자</option>
                </select><input type="search" id="searchWord" title="검색어 입력"><button type="button" class="btn-type2 search" onClick="fn_loadData()"><span>검색</span></button>
            </fieldset>
        </div>
    </div>
</div>
<div class="cont-quick double">
    <!--a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
    <a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>

<!-- 문의하기 등록 -->
<div class="layer-pop-wrap" id="qnaLayer">
    <div class="layer-pop bigger">
        <div class="layer-header">
            <strong class="title">문의하기 등록</strong>
        </div>
        <div class="layer-cont">
            <form id="frm" method="post" action="${pageContext.request.contextPath}/community/registArcl.do">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="boardId" value="lecQnA" />
            <input type="hidden" name="scrtArclYn" value="Y" />
            <input type="hidden" id="clasRoomSer" name="cntntsId" value="${clasRoomSer}" />
            <input type="hidden" name="redirectUrl" value="/myPage/myCommnuity/data/qnaList.do" />
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
                        <th scope="row"><span class="essent-inp">필수입력</span><label for="prefNo">분류</label></th>
                        <td>
                            <select class="slt-style" title="분류선택" id="prefNo" name="prefNo">
                                <option value="">선택</option>
                                <option value="qnaClass">수업</option>
                                <option value="qnaMentor">멘토</option>
                                <option value="qnaJob">직업</option>
                                <option value="qnaEtc">기타</option>
                            </select>
                            <span class="secret-text">
                            <!-- label class="chk-skin" title="비밀글">
                                <input type="checkbox" id="scrtArclYn" name="scrtArclYn" value="Y" title="비밀글" />비밀글
                            </label -->
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><span class="essent-inp">필수입력</span><label for="title">제목</label></th>
                        <td><input type="text" id="title" name="title" class="inp-style" title="제목" /></td>
                    </tr>
                    <tr>
                        <th scope="row"><span class="essent-inp">필수입력</span><label for="sust">내용</label></th>
                        <td>
                            <div class="editor-wrap popup">
                                <jsp:include page="/layer/editor.do" flush="true">
                                    <jsp:param name="wrapperId" value="sust"/>
                                    <jsp:param name="contentId" value="sust"/>
                                    <jsp:param name="formName" value="frm"/>
                                </jsp:include>
                                <textarea class="ta-style" id="sust" name="sust" style="display:none;" ></textarea>
                                <input type="hidden" id="arclSer" name="arclSer" />
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            </form>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup" onclick="saveArcl()" >확인</a>
                <a href="javascript:void(0)" class="btn-type2 cancel">취소</a>
            </div>
            <a href="javascript:void(0)" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>
<!-- // 문의하기 등록 -->

<%-- Template ================================================================================ --%>
<script type="text/html" id="qnaInfo">
<li>
    <div class="subject-info">
        <a href="javascript:void(0);" onClick="dataDetailShow(this);" class="subject">[\${prefNm}] \${title}
                <!-- span class="secret">비밀글</span -->
            {{if cntntsSust != null}}
                <span class="reply-y">답변완료</span>
            {{else}}
                <span class="reply-n">미답변</span></a>
            {{/if}}
        </a>
        <span class="user {{if mbrClassNm == 'student'}}student{{/if}}">\${regMbrNm}</span>
        <span class="date">\${fn_date_to_string(regDtm)}</span>
    </div>
    <div class="subject-detail">
        {{if prefNo == 'qnaClass' && lectTitle != null}}
            <p class="relation-lesson">
                <strong>관련수업</strong><em><a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=\${cntntsTargtNo}&lectTims=\${cntntsTargtTims}&schdSeq=\${cntntsTargtSeq}">\${lectTitle}</a></em>
                <strong>멘토</strong><em><a href="${pageContext.request.contextPath}/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo=\${cntntsTargtId}">\${lectrNm}</a></em>
                <strong>직업</strong><em><a href="#">\${jobNm}</a></em>
            </p>
        {{/if}}
        <div class="question-detail">
            <div class="question">
                <span class="title">질문</span>
                <div class="info">{{html replaceLineBreakHtml(sust)}}</div>
            </div>
            {{if cntntsSust != null}}
                <div class="answer">
                    <span class="title">답변</span>
                    <div class="answer-mentor-info">
                        <span class="user mentor">\${ansRegMbrNm}</span>
                        <span class="date">\${fn_date_to_string(ansRegDtm)}</span>
                    </div>
                    <div class="info">{{html replaceLineBreakHtml(cntntsSust)}}</div>
                </div>
            {{/if}}
            <div class="writing-btn">
                <a href="javascript:void(0)" onClick="fn_popupOpen(\${arclSer})" class="btn-modi layer-open">수정</a><a href="javascript:void(0)" onClick="deleteArcl(\${arclSer})" class="btn-del">삭제</a>
            </div>
        </div>
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
                $("#qnaLayer").hide();
            }
        });

        myCommunity();
        fn_loadData();
    });

    function fn_loadData(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'boardId' : 'lecQnA'
              , 'siteGbn' : 'sMyComm'
              , 'dispNotice' : false
              , 'srchMbrNo' : '${mbrNo}'
              , 'searchKey': $('#searchKey').val()
              , 'searchWord': $('#searchWord').val()
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.arclList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                data = rtnData;

                $("#qnaList").empty();
                if(totalCount > 0) {
                    $("#qnaInfo").tmpl(rtnData).appendTo("#qnaList");
                } else {
                    $("#qnaList").append('<li><div class="title-blank">등록된 Q&amp;A가 없습니다.</div></li>');
                }

                mentor.pageNavi.setData(dataSet.params);

                myCommunity();

            }
        });
    }

    /* 상세 펼치기 */
    function dataDetailShow(obj){
        var _this = $(obj);
        if(_this.parent().parent().hasClass('active')){
            _this.parent().parent().removeClass('active');
        }else{
            _this.parent().parent().addClass('active').siblings().removeClass('active');
        }
        myCommunity();
    }

    /* 팝업 셋팅 */
    function fn_popupOpen(arclSer){
        if(arclSer != null){
            $('.layer-header .title').text('문의하기 수정');
            $.each(data, function(){
                if(arclSer == this.arclSer){
                    $('#arclSer').val(this.arclSer);
                    $('#title').val(this.title);
                    $('#prefNo').val(this.prefNo);
                    $('#sust').val(this.sust);
                    loadContent();

                    if(this.scrtArclYn == 'Y'){
                        $('#scrtArclYn').attr('checked', true);
                        $('#scrtArclYn').parent().addClass('checked');
                    }
                }
            });
        }else{
            $('.layer-header .title').text('문의하기 등록');
        }
        layerOpen();
        position_cm();
    }

    /* 레이어팝업 열기 */
    function layerOpen(){
        $('body').addClass('dim');
        $('.selectbox-zindex-box').css('display', 'block');
        $('#qnaLayer').attr('tabindex',0).show().focus();
    }

    /* 레이어 팝업 닫기 */
    $('.layer-close, .cancel').click(function(){
        //작성된 데이터 삭제
        $('#arclSer').val('');
        $('#title').val('');
        $('#prefNo').val('');
        $('#sust').val(' '); // 공백을 넣어주어야 에디터창이 초기화 된다.
        loadContent();
        $('#scrtArclYn').attr('checked', false);
        $('#scrtArclYn').parent().removeClass('checked');

        $('#qnaLayer').hide();
        $('.selectbox-zindex-box').css('display', 'none');
        $('body').removeClass('dim');
    });

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

    function saveArcl(){
        if($("#prefNo").val() === "") {
          alert("분류를 선택해 주세요.");
          return false;
        }
        if($("#title").val() === "") {
          alert("제목을 입력해 주세요.");
          return false;
        }

        if(!confirm("등록하시겠습니까?")) {
          return false;
        }

/*
        if($('.chk-skin').hasClass('checked')) {
            $('#scrtArclYn').val('Y');
        } else {
            $('#scrtArclYn').val('N');
        }
*/
        saveContent();

    }

    /* 삭제하기 */
    function deleteArcl(arclSer){

        if(!confirm("삭제하시겠습니까?")) {
          return false;
        }

        var _param = {
                'arclSer' : arclSer
              , 'boardId' : 'lecQnA'
        };

        $.ajax({
            url: mentor.contextpath+"/community/ajax.deleteArcl.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType: 'json',
            type: 'post',
            cache: false,
            success: function(rtnData) {
                if(rtnData.success){
                    alert('삭제되었습니다.');
                    location.reload();
                }
            },
            error: function(xhr, status, err) {
                console.error("ajax.deleteArcl.do", status, err.toString());
            }
        });

    }

</script>