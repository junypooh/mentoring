<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
            <li class="mypage-data-li active">
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/dataList.do">수업자료실<span>자세히보기</span></a>
                <div class="mypage-wrap">
                    <ul class="community-data-list" id="lectureDataList"></ul>
                    <div class="paging" id="paging"></div>
                    <div class="btn">
                        <a href="#dataListPop" class="btn-border-type layer-open">등록</a>
                    </div>
                </div>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/qnaList.do">Q&amp;A<span>자세히보기</span></a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/myPage/myCommnuity/data/workList.do" onClick="tabChg(2)">수업과제<span>자세히보기</span></a>
            </li>
        </ul>
        <div class="mypage-list-area">
            <fieldset class="list-search-area">
                <legend>검색</legend>
                <select title="검색어 기준" id="searchKey">
                    <option value="">제목+내용</option>
                    <option value="title">제목</option>
                    <option value="regMbrNm">작성자</option>
                </select><input type="search" id="searchWord" title="검색어 입력"><button type="button" class="btn-type2 search" onClick="fn_loadData()"><span>검색</span></button>
            </fieldset>
        </div>
    </div>
</div>
<div class="cont-quick double">
    <!--a href=""><img src="${pageContext.request.contextPath}/images/common/img_quick3.png" alt="리스트로 이동" /></a-->
    <a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
</div>
<%-- Template ================================================================================ --%>
<script type="text/html" id="lectureDataEmpty">
<li>
    <div>
        <span>등록 된 자료가 없습니다.</span>
    </div>
</li>
</script>
<%-- Template ================================================================================ --%>

<%-- Template ================================================================================ --%>
<script type="text/html" id="lectureDataInfo">
<li>
    <div class="title">
        <a href="javascript:void(0);" onClick="dataDetailShow(this);">
            <em>\${dataNm}</em>
            <div>
                <span class="user student">\${regMbrNm}</span>
                {{if dataTypeCd == '101759'}}
                <span class="file">1개 (\${Math.ceil(fileSize/1024/1024)}MB)</span>
                {{/if}}
            </div>
        </a>
    </div>
    <div class="file-list">
        <p class="relation-lesson">
            <strong>관련수업</strong><em><a href="#">\${lectTitle}</a></em>
            <strong>멘토</strong><em><a href="#">\${lectrNm}</a></em>
            <strong>직업</strong><em><a href="#">\${jobNm}</a></em>
        </p>
        <div class="download-brd">
        </div>
        <ul>
            {{if dataTypeCd == '101761'}}
                <li>
                    <span class="file-type link">
                        <span>\${linkTitle}</span><a href="\${dataUrl}" class="link-addr" target="_blank">\${dataUrl}</a>
                    </span>
                </li>

            {{else dataTypeCd == '101760'}}
                <li>
                    <span class="file-type avi">
                        <a href="javascript:videoPlay(\${cntntsId})">videoPlay</a>
                    </span>
                </li>
            {{else dataTypeCd == '101759'}}
                <li><span class="file-type \${String(fileExt).toLowerCase()}">
                        <a href="${pageContext.request.contextPath}/fileDown.do?fileSer=\${fileSer}">\${oriFileNm}</a>
                    </span>
                    <span class="file-size">\${Math.ceil(fileSize/1024/1024)}MB</span>
                </li>
            {{/if}}
        </ul>
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

    if(${isMobile}){
        dataSet.params.pageSize = 5;
    }

    $(document).ready(function(){
        enterFunc($("#searchWord"), fn_loadData);
        myCommunity();
        detailTab2();
        fn_loadData();
    });

    function fn_loadData(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'searchKey': $('#searchKey').val()
              , 'searchWord': $('#searchWord').val()
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/myPage/myCommunity/ajax.lectDataList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                $("#lectureDataList").empty();
                if(totalCount > 0){
                    $("#lectureDataInfo").tmpl(rtnData).appendTo("#lectureDataList");
                }else{
                    $("#lectureDataList").append('<li><div class="title title-blank">등록된 수업자료가 없습니다.</div></li>');
                }

                mentor.pageNavi.setData(dataSet.params);

                myCommunity();

            }
        });
    }

    /* 동영상재생 */
    function videoPlay(cntntsId){
        window.open("http://movie.career.go.kr/test/player/index.asp?cID="+ cntntsId, "", "scrollbars=no, resizeable=no, width=672, height=590");
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

</script>