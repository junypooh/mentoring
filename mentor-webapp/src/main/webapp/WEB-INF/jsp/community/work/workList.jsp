<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrNo" property="principal.mbrNo" />
</security:authorize>

<div id="container">
    <div class="location">
        <a href="#" class="home">메인으로 이동</a>
        <span>커뮤니티관리</span>
        <span>수업과제</span>
    </div>
    <div class="content">
        <h2>수업과제</h2>
        <div class="cont">
            <div class="lesson-task">
                <span class="list-num">
                    <select id="perPage" style="width:70px;">
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="30">30</option>
                    </select>
                </span>
                <ul class="lesson-data-list" id="workList">
                </ul>
            </div>
            <div class="paging" id="paging"></div>
            <fieldset class="list-search-area">
            <legend>검색</legend>
                <select>
                    <option value="">전체</option>
                    <option value="">제목</option>
                    <option value="">내용</option>
                </select>
                <input type="search" class="inp-style1" />
                <a href="#" class="btn-search"><span>검색</span></a>
            </fieldset>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>
<!-- layerpopup -->
<div class="layer-pop-wrap" id="workLayer">
    <input type="hidden" id="arclSer" name="arclSer" value="" />
    <div class="title">
        <strong>수업과제 답글</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont type1">
        <div class="lesson-task-popup">
            <textarea id="cntntsSust" class="textarea-type1" onKeyup="fn_lengthChk()"></textarea>
            <span class="area-txt"><em>0</em>/200자</span>
        </div>
        <div class="btn-area">
            <a href="javascript:fn_updateWork();" class="btn-type2">확인</a>
            <a href="#" class="btn-type2 gray pop-close">취소</a>
        </div>
    </div>
</div>
<!-- //layerpopup -->

<%-- Template ================================================================================ --%>
<script type="text/html" id="listWorkInfo">
    <li {{if arclSer == '${param.arclSer}'}}class='active' {{/if}}>
        <div class="title">
            <a href="javascript:void(0);" onClick="fn_detail(this, \${arclSer})">
                <span class="num">\${fn_getNo(rn)}</span>
                <em class="title">\${title} <span class="reply-y">{{if ansYn != 'Y'}}미답변{{else}}답변완료{{/if}}</span></em>
                {{if regClassNm == 'teacher'}}
                    <span class="name teach">\${regMbrNm}</span>
                {{else}}
                    <span class="name">\${regMbrNm}</span>
                {{/if}}
                <span class="day">\${fn_date_to_string($data.regDtm)}</span>
            </a>
        </div>
        <div class="file-list">
            <ul class="task-info">
                <li><span>관련수업</span> : \${lectTitle}</li>
                <li><span>멘토</span> : \${lectrNm}</li>
                <li><span>직업</span> : \${jobNm}</li>
                <li class="lesson-time"><span>수업일시</span> : \${fn_date_to_string(lectDay)} \${to_time_format(lectStartTime, ':')} ~ \${to_time_format(lectEndTime, ':')}(\${lectRunTime}분)</li>
            </ul>
            <p class="task-cont">
                {{if sust != null}}
                    {{html sust.replaceAll('\n', '<br>')}}
                {{else}}
                    {{html sust}}
                {{/if}}
            </p>
            <div id="fileDiv"></div>
            {{if ansYn == 'N'}}
                <div class="btn-area">
                    <a href="javascript:fn_ansDetail(\${arclSer});" class="btn-type1 reply">답글</a>
                </div>
            {{/if}}
            {{if ansYn == 'Y'}}
                <div class="reply-area">
                    <a href="javascript:void(0);" onClick="fn_detailReview(this)">
                        <em>\${cntntsSust}</em>
                        <span class="name">\${ansRegMbrNm}</span>
                        <span class="day">\${fn_date_to_string($data.ansRegDtm)}</span>
                    </a>
                    <p class="full-answer">
                    {{html cntntsSust.replaceAll('\n', '<br>')}}
                    <a href="javascript:void(0);" onClick="fn_deleteWork(\${arclSer});" class="delete"><img src="${pageContext.request.contextPath}/images/community/btn_wastebasket.png" alt="삭제"></a>
                </p>
                </div>
            {{/if}}
        </div>
    </li>
</script>
<%-- Template ================================================================================ --%>

<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
                 document.getElementById('paging')
             );
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function(){
        fn_search();
    });

    function fn_search(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'searchKey' : $("#searchValue").val()
              , 'searchWord' : $("#searchWord").val()
              , 'boardId' : 'lecWork'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.mentorArclInfoList.do',
            data : $.param(_param, true),
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                $("#workList").empty();
                $("#listWorkInfo").tmpl(rtnData).appendTo("#workList");

                mentor.pageNavi.setData(dataSet.params);
            },
            error: function(request,status,error){
                 alert("error:"+error);
            }
        });

    }

    // 번호 정렬
    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }

    // 상세 펼치기
    function fn_detail(obj, arclSer){
		if(!$(obj).parent().parent().hasClass('active')){
			$('.lesson-data-list li').removeClass('active');
			$(obj).parent().parent().addClass('active');
			getFileList(obj, arclSer);
		}else{
			$(obj).parent().parent().removeClass('active');
		}
    }

    // 답변 상세 펼기치
    function fn_detailReview(obj){
		if(!$(obj).hasClass('active')){
			$('.lesson-task .lesson-data-list li .reply-area a').removeClass('active');
			$(obj).addClass('active');

		}else{
			$(obj).removeClass('active');
		}
    }

    // 상세 첨부파일 조회
    function getFileList(obj, arclSer) {
        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.getFileInfoList.do',
            data : {'arclSer' : arclSer},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var str = "";
                if(rtnData.length > 0){
                    str += '<ul>';
                    for(var i=0;i<rtnData.length;i++) {
                        str += '<li>';
                        str += '    <span class="file-type jpg">';
                        str += '        <a href="${pageContext.request.contextPath}/fileDown.do?origin=true&fileSer='+ rtnData[i].fileSer +'">' + rtnData[i].comFileInfo.oriFileNm + '</a>';
                        str += '    </span>';
                        str += '    <span class="file-size">'+Math.ceil(rtnData[i].comFileInfo.fileSize/(1024)/(1024))+'MB</span>';
                        str += '</li>';
                    }
                    str += '</ul>';
                }
                $(obj).parent().next().children('#fileDiv').html(str);
            }
        });
    }

    // 답변 글자수 setting
    function fn_lengthChk(){
        ansLength = $('#cntntsSust').val().length;
        if(ansLength > 100){
            alert("입력 글자 수를 초과하였습니다.");
            $('#cntntsSust').val($('#cntntsSust').val().substr(0,100));
            $('#workLayer .area-txt em').text($('#cntntsSust').val().length);
            return;
        }
        $('#workLayer .area-txt em').text(ansLength);
    }

    // 답글 레이어팝업
    function fn_ansDetail(arclSer){
        $('#arclSer').val(arclSer);
        layerOpen();
    }

    // 레이어팝업 열기
    function layerOpen(){
        $('body').addClass('dim');
        $('.selectbox-zindex-box').css('display', 'block');
        $('#workLayer').attr('tabindex',0).show().focus();
    }

    // 레이어 팝업 닫기
    $('.pop-close').click(function(){
        //작성된 데이터 삭제
        $('#cntntsSust').val("");
        $('#arclSer').val("");
        $('#workLayer .area-txt em').text(0);

        $('#workLayer').hide();
        $('.selectbox-zindex-box').css('display', 'none');
        $('body').removeClass('dim');
    });

    // 답변등록 및 수정
    function fn_updateWork(){
        var _param = {
            'arclSer' : $('#arclSer').val()
          , 'boardId' : 'lecWork'
          , 'cntntsSust' : $('#cntntsSust').val()
          , 'ansRegMbrNo' : ${mbrNo}
        };

        if( confirm('저장하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/community/ajax.registArcl.do',
                data : JSON.stringify(_param),
                contentType: "application/json",
                dataType: 'JSON',
                type: 'POST',
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('저장되었습니다.');
                        location.reload();
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

    // 답변삭제
    function fn_deleteWork(arclSer){
        var _param = {
                'arclSer' : arclSer
              , 'boardId' : 'lecWork'
              , 'cntntsSust' : ''
              , 'ansChgMbrNo' : ${mbrNo}
        };
        if( confirm('삭제하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/community/ajax.deleteArclReply.do',
                data : JSON.stringify(_param),
                contentType: "application/json",
                dataType: 'json',
                type: 'post',
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert('삭제되었습니다.');
                        location.reload();
                    }
                },
                error: function(request,status,error){
                     alert("error:"+error);
                }
            });
        }
    }

    $('#perPage').change(function(){
        dataSet.params.recordCountPerPage = $('#perPage').val();
        fn_search(1);
    });

</script>