<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
</security:authorize>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

		<div id="container">
			<div class="location">
				<a href="#" class="home">HOME</a>
				<span class="first">커뮤니티</span>
				<span>기타자료</span>
			</div>
			<div class="content sub">
				<h2>기타자료</h2>
				<div class="review-tbl-wrap mb-35">
					<div class="review-tbl">
						<table>
							<caption>직업소개 검색창 - 키워드,직업</caption>
							<colgroup>
								<col class="size-tbl1" />
								<col class="size-tbl2" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row"><label for="schoolKeyword">키워드</label></th>
									<td>
										<div class="keyword-search">
											<div class="selectbox-zindex-wrap"><!-- 2015-11-16 추가 -->
												<select id="searchKey" class="keyword-slt" title="키워드 종류">
													<option value="">전체</option>
													<option value="dataNm">제목</option>
													<option value="dataSust">내용</option>
												</select>
												<div class="selectbox-zindex-box">
													<div></div>
													<iframe scrolling="no" title="빈프레임" frameborder="0"></iframe>
												</div>
											</div>
											<input type="text" class="keyword-inp" id="searchWord" title="키워드입력란" />
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn-area">
						<a href="javascript:void(0)" onclick="fn_search()" class="btn-search"><span>검색</span></a>
						<a href="javascript:void(0)" onclick="fn_clearLoadData()" class="btn-reload"><span>다시검색</span></a>
					</div>
				</div>
				<ul class="lesson-data-list" id="dataList">
				</ul>
				<div id="paging"></div>
			</div>
		</div>

		<div class="cont-quick double">
			<a href="#"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
		</div>

<%-- Template ================================================================================ --%>
<script type="text/html" id="dataInfo">
    <li>
        <div class="title">
            <a href="javascript:void(0)">
                <em>
                    <span>\${dataNm}</span>
                </em>
                {{if dataTargtClass == '101534'}}
                    <span class="icon-rating elementary">초</span>
                {{else dataTargtClass == '101535'}}
                    <span class="icon-rating middle">중</span>
                {{else dataTargtClass == '101536'}}
                    <span class="icon-rating high">고</span>
                {{else dataTargtClass == '101537'}}
                    <span class="icon-rating elementary">초</span>
                    <span class="icon-rating middle">중</span>
                {{else dataTargtClass == '101538'}}
                    <span class="icon-rating middle">중</span>
                    <span class="icon-rating high">고</span>
                {{else dataTargtClass == '101539'}}
                    <span class="icon-rating elementary">초</span>
                    <span class="icon-rating high">고</span>
                {{else dataTargtClass == '101540'}}
                    <span class="icon-rating elementary">초</span>
                    <span class="icon-rating middle">중</span>
                    <span class="icon-rating high">고</span>
                {{else dataTargtClass == '101713'}}
                    <span class="icon-rating etc">기타</span>
                {{/if}}
                <div>
                    <span class="user null">\${chgMbrNm}</span>
                    <span class="file">
                        <span>\${dataTypeNm}</span>
                    </span>
                </div>
            </a>
        </div>
        <div class="file-list">
            <div class="script-cont">
                <p>{{html replaceLineBreakHtml(dataSust)}}</p>
            </div>
            <ul>
                {{if dataTypeCd == '101761'}}
                    <li>
                        <span class="file-type link">
                            <!-- span>\${linkTitle}</span><a href="\${dataUrl}" class="link-addr" target="_blank">\${dataUrl}</a -->
                            <span><a href="\${dataUrl}" class="link-addr" target="_blank">\${linkTitle}</a></span>
                        </span>
                    </li>
                {{else dataTypeCd == '101760'}}
                    <li>
                        <span class="file-type avi">
                            <a href="javascript:videoPlay(\${cntntsId});">\${fileTitle}</a>
                        </span>
                    </li>
                {{else dataTypeCd == '101759'}}
                    <li>
                        <span class="file-type jpg">
                            {{if '${id}' == '' || '${id}' == null}}
                            <a href="javascript:void(0)" onclick="alert('로그인 후 이용이 가능합니다.'); $(location).attr('href','${pageContext.request.contextPath}/login.do');">\${oriFileNm}</a>
                            {{else}}
                            <a href="${pageContext.request.contextPath}/fileDown.do?origin=true&fileSer=\${fileSer}">\${oriFileNm}</a>
                            {{/if}}
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
        <PageNavi  pageFunc={fn_loadData} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={dataSet.params.pageSize} />,
                 document.getElementById('paging')
             );
</script>

<script type="text/javascript">
    var searchType = 'load';
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
        fn_loadData();

        enterFunc($('#searchWord'), fn_loadData);
    });

    function fn_clearLoadData() {
        $('#searchKey').val('');
        $('#searchWord').val('');
        fn_search();
    }

    function fn_search() {
        searchType = 'search';
        fn_loadData();
    }

    function fn_loadData(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
            'searchKey' : $('#searchKey').val(),
            'searchWord' : $('#searchWord').val(),
            'dataType' : 'etcData'
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/community/ajax.lectureDataList.do',
            data : $.param(_param, true),
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                    $("#dataList").empty();
                    $("#dataInfo").tmpl(rtnData).appendTo("#dataList");
                }else{
                    $("#dataList").empty();
                    if(searchType == 'load') {
                        $("#dataList").append('<li class="no-lesson-txt">등록된 기타자료가 없습니다.</li>');
                    } else if(searchType == 'search') {
                        $("#dataList").append('<li class="no-lesson-txt">검색된 결과가 없습니다.</li>');
                    } else {
                        $("#dataList").append('<li class="no-lesson-txt">등록된 기타자료가 없습니다.</li>');
                    }
                }
                dataSet.params.totalRecordCount = totalCount;

                mentor.pageNavi.setData(dataSet.params);

                detailTab();

            }
        });
    }

    /* 동영상재생 */
    function videoPlay(cntntsId){
        window.open("http://movie.career.go.kr/test/player/index.asp?cID="+ cntntsId, "", "scrollbars=no, resizeable=no, width=672, height=590");
    }

</script>