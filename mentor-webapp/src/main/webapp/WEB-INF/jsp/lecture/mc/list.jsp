<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

		<div id="container">
			<div class="location">
				<a href="#" class="home">메인으로 이동</a>
				<span>수업관리</span>
				<span>MC관리</span>
			</div>
			<div class="content">
				<h2>MC관리</h2>
				<div class="cont type3">
				    <form id="frm">
				    <input type="hidden" id="mcNo" name="mcNo" />
				    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<div class="calculate-management lists">
						<div class="search-box">
							<dl>
								<dt>기간</dt>
								<dd>
									<span class="calendar">
										<input type="text" class="inp-style1" style="width:110px;" id="searchStDate" name="searchStDate" value="${param.searchStDate}" />
										~
										<input type="text" class="inp-style1" style="width:110px;" id="searchEndDate" name="searchEndDate" value="${param.searchEndDate}" />
									</span>
									<span class="btn">
										<em class="school">성별</em>
										<span style="padding-right:30px">
											<select name="genCd" id="genCd">
												<option value="" <c:if test="${empty param.genCd}">selected='selected'</c:if>>전체</option>
												<option value="100323" <c:if test="${param.genCd eq '100323'}">selected='selected'</c:if>>남</option>
												<option value="100324" <c:if test="${param.genCd eq '100324'}">selected='selected'</c:if>>여</option>
											</select>
										</span>
										<em class="school">상태</em>
										<span>
											<select name="useYn" id="useYn">
												<option value="" <c:if test="${empty param.useYn}">selected='selected'</c:if>>전체</option>
												<option value="Y" <c:if test="${param.useYn eq 'Y'}">selected='selected'</c:if>>사용중</option>
												<option value="N" <c:if test="${param.useYn eq 'N'}">selected='selected'</c:if>>사용안함</option>
											</select>
										</span>
									</span>
								</dd>
								<dt>MC명</dt>
								<dd>
									<input type="text" class="inp-style1" style="width:290px;" name="mcNm" id="mcNm" value="${param.mcNm}">
								</dd>
							</dl>
							<div class="btn-area">
								<a href="javascript:void(0)" onclick="goSearch(1)" class="btn-search"><span>검색</span></a>
							</div>
						</div>
					</div>
					<div class="lesson-task">
						<span class="list-num">
							<select id="recordCountPerPage" name="recordCountPerPage" style="width:70px;">
								<option <c:if test="${param.recordCountPerPage eq '10'}">selected='selected'</c:if>>10</option>
								<option <c:if test="${param.recordCountPerPage eq '20'}">selected='selected'</c:if>>20</option>
								<option <c:if test="${param.recordCountPerPage eq '30'}">selected='selected'</c:if>>30</option>
							</select>
						</span>
					</div>
					</form>
					<div class="board-type1 schedule">
						<table>
							<caption>MC관리 - 번호, MC명, 상태, 등록일</caption>
							<colgroup>
								<col style="width:65px;">
								<col>
								<col style="width:100px;">
								<col style="width:120px;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">MC명</th>
									<th scope="col">상태</th>
									<th scope="col">등록일</th>
								</tr>
							</thead>
							<tbody id="mcList">
							</tbody>
						</table>
					</div>
					<div class="paging-btn">
						<div id="paging"></div>
						<span class="r-btn"><a href="edit.do" class="btn-type1">등록</a></span>
					</div>
				</div>
			</div>
			<div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
		</div>
<%-- Template ================================================================================ --%>
<script type="text/html" id="listMc">
    <tr>
        <td>\${fn_getNo(rn)}</td>
        <%--td class="al-left"><a href="view.do?mcNo=\${mcNo}">\${mcNm}</a></td--%>
        <td class="al-left"><a href="javascript:void(0)" onclick="goView('\${mcNo}')">\${mcNm}</a></td>
        {{if useYn == 'Y' }}
        <td>사용중</td>
        {{else}}
        <td>사용안함</td>
        {{/if}}
        <td>\${fn_date_to_string(regDtm)}</td>
    </tr>
</script>
<%-- Template ================================================================================ --%>
<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={goSearch} totalRecordCount={0} currentPageNo={1} recordCountPerPage={$('#recordCountPerPage').val()} pageSize={10} />,
                 document.getElementById('paging')
    );
</script>
<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: $('#recordCountPerPage').val(),
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    var searchFlag = 'load';

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(mcNo) {
        $('#mcNo').val(mcNo);
        $('#frm').attr('action', '${pageContext.request.contextPath}/lecture/mc/view.do');
        $('#frm').attr('method', 'post');
        $('#frm').submit();
    }

    function loadData(curPage, recordCountPerPage){

        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        var _param = jQuery.extend({
                      'searchStDate' : $('#searchStDate').val()
                      ,'searchEndDate' : $('#searchEndDate').val()
                      ,'useYn':$('#useYn').val()
                      ,'genCd':$('#genCd').val()
                      ,'mcNm':$('#mcNm').val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mc/ajax.list.do",
            data : $.param(_param, true),
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                $("#mcList").empty();
                $("#listMc").tmpl(rtnData).appendTo("#mcList");

                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }

                if(rtnData == null || rtnData.length < 1) {
                    $("#mcList").empty().append("<tr><td colspan='4'>" + emptyText + "</td></tr>");
                }

                mentor.pageNavi.setData(dataSet.params);
            }
        });

    }

    $(document).ready(function() {

        enterFunc($("#mcNm"), goSearch);

        _applyDatepicker($("#searchStDate"));
        _applyDatepicker($("#searchEndDate"));

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

        $('#recordCountPerPage').change(function(){
            dataSet.params.recordCountPerPage = $(this).val();
            loadData(1);
        });

        loadData(1);
    });

    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }
</script>