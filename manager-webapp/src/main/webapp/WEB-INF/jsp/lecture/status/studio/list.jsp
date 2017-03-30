<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>

<div class="cont">
    <div class="title-bar">
        <h2>스튜디오현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업정보관리</li>
            <li>스튜디오현황</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="stdoNo" name="stdoNo" />
    <div class="search-area leeson-state-srch">
        <ul>
            <li class="condition-big">
                <p><strong>구분</strong></p>
                <ul class="detail-condition">
                    <li>
                        <label><input type="radio" name="indrYn" value="" <c:if test="${empty param.indrYn}">checked='checked'</c:if> /> 전체</label>
                    </li>
                    <li>
                        <label><input type="radio" name="indrYn" value="Y" <c:if test="${param.indrYn eq 'Y'}">checked='checked'</c:if> /> 내부</label>
                    </li>
                    <li>
                        <label><input type="radio" name="indrYn" value="N" <c:if test="${param.indrYn eq 'N'}">checked='checked'</c:if> /> 외부</label>
                    </li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>사용유무</strong></p>
                <ul class="detail-condition">
					<li>
						<label><input type="radio" name="useYn" value="" <c:if test="${empty param.useYn}">checked='checked'</c:if> /> 전체</label>
					</li>
					<li>
						<label><input type="radio" name="useYn" value="Y" <c:if test="${param.useYn eq 'Y'}">checked='checked'</c:if> /> 사용중</label>
					</li>
					<li>
						<label><input type="radio" name="useYn" value="N" <c:if test="${param.useYn eq 'N'}">checked='checked'</c:if> /> 사용안함</label>
					</li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big lesson-name">
                <p><strong>지역/시군구</strong></p>
                <ul class="detail-condition">
                    <li>
                        <spring:eval expression="@studioService.getStudioSido()" var="list" />
                        <select id="sidoNm" name="sidoNm">
                            <option value="">지역선택</option>
                            <c:forEach items="${list}" var="list" varStatus="vs">
                                <option value="${list.sidoNm}">${list.sidoNm}</option>
                            </c:forEach>
                        </select>
                        /
                        <select id="sgguNm" name="sgguNm">
                            <option value="">시군구</option>
                        </select>
                    </li>
                 </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>소속기관</strong></p>
                <ul class="detail-condition">
					<li>
						<input type="text" name="posCoNm" id="posCoNm" class="text" value="${param.posCoNm}" />
					</li>
                </ul>
            </li>
        </ul>
        <ul>
            <li class="condition-big">
                <p><strong>스튜디오</strong></p>
                <ul class="detail-condition">
                    <li>
                        <input type="text" name="stdoNm" id="stdoNm" class="text" value="${param.stdoNm}" />
                    </li>
                </ul>
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
            <ul>
                <li><button type="button" class="btn-style02" onClick="goEdit();"><span>등록</span></button></li>
            </ul>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
    </div>
</div>

<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={loadData} totalRecordCount={0} currentPageNo={1} recordCountPerPage={20} pageSize={10} />,
        document.getElementById('paging')
    );
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10
        }
    };
    var searchFlag = 'load';

    $(document).ready(function(){

        enterFunc($("#posCoNm"),goSearch);
        enterFunc($("#stdoNm"),goSearch);

        <c:if test="${not empty param.sidoNm}">
        $('#sidoNm').val('${param.sidoNm}').change();
        </c:if>
        <c:if test="${not empty param.sgguNm}">
        $('#sgguNm').val('${param.sgguNm}');
        </c:if>

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(stdoNo) {
        $('#stdoNo').val(stdoNo);
        var qry = $('#frm').serialize();
        $(location).attr('href', 'view.do?' + qry);
    }

    function loadData(curPage, recordCountPerPage){

        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'번호', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'구분', name:'indrYnNm', index:'indrYnNm', width:20, align:'center', sortable: false});
        colModels.push({label:'스튜디오', name:'stdoNm', index:'stdoNm', width:50, sortable: false});
        colModels.push({label:'주소', name:'locaAddr', index:'locaAddr', width:80, sortable: false});
        colModels.push({label:'소속기관', name:'posCoNm', index:'posCoNm', width:40, align:'center', sortable: false});
        colModels.push({label:'사용유무', name:'useYnNm', index:'useYnNm', width:30, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm', index:'regMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'regDtm', index:'regDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({
                       'indrYn' : $('input[name=indrYn]:checked').val()
                      ,'useYn': $('input[name=useYn]:checked').val()
                      ,'sidoNm' : $('#sidoNm').val()
                      ,'sgguNm' : $('#sgguNm').val()
                      ,'posCoNm':$('#posCoNm').val()
                      ,'stdoNm':$('#stdoNm').val()
        }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/studio/ajax.list.do",
            data : $.param(_param, true),
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                var data = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    var strLinkUrl = mentor.contextpath + "/lecture/status/studio/view.do?stdoNo=" + item.stdoNo;
                    //item.stdoNm = "<a href='" + strLinkUrl + "' class='underline'>" + item.stdoNm + "</a>";
                    item.stdoNm = "<a href='javascript:void(0)' class='underline' onclick='goView(\"" + item.stdoNo + "\")'>" + item.stdoNm + "</a>";
                    item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');
                    return item;
                });

                // grid data binding
                var emptyText = '';
                if(searchFlag == 'load') {
                    emptyText = '등록된 데이터가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
                setDataJqGridTable('boardTable', 'boardArea', 500, data, emptyText);
                // grid data binding


                mentor.pageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });

    }

    // 지역선택
    $('#sidoNm').change(function(){
        $('#sgguNm').find('option:not(:first)').remove().end().val('').change();
        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/studio/ajax.studioSggu.do",
            data : {'sidoNm' : $('#sidoNm').val()},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                $('#sgguNm').loadSelectOptions(rtnData,'','sgguNm','sgguNm',1);
            }
        });
    });

    // 등록버튼 클릭
    function goEdit(){
        location.href = mentor.contextpath + "/lecture/status/studio/edit.do";
    }

</script>



