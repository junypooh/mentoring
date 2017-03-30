<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="cont">
    <div class="title-bar">
        <h2>직업관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>직업관리</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="jobNo" name="jobNo" />
    <input style="display:none;"> <%-- 폼에 input text가 하나만 존재하면 엔터키로 무조건 submit을 막기위해 --%>
    <div class="search-area">
        <ul>
            <li>
                <strong>직업분류</strong>
                <select id="jobLv1Selector" name="jobLv1Selector" style="width:200px;">
                    <option value="">1차분류</option>
                </select>
                <select id="jobLv2Selector" name="jobLv2Selector" style="width:200px;">
                    <option value="">2차분류</option>
                </select>
                <select id="jobLv3Selector" name="jobLv3Selector" style="width:200px;">
                    <option value="">3차분류</option>
                </select>
            </li>
            <li>
                <strong>검색어</strong>
                <input type="text" class="text" id="searchWord" name="searchWord" value="${param.searchWord}" />
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onClick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
            <ul>
                <li><button type="button" class="btn-style02" onClick="goEdit();"><span>직업추가</span></button></li>
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
            pageSize: 10,
        }
    };

    var searchFlag = 'load';

    $(document).ready(function(){

        enterFunc($("#searchWord"), goSearch);

        // 1차 분류 코드 정보
        $.ajax({
            url: '${pageContext.request.contextPath}/jobClsfCd.do',
            data: { cdLv: 1 },
            success: function(rtnData) {
                $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });

        // 1차 분류 변경
        $('#jobLv1Selector').change(function() {
            $('#jobLv2Selector').find('option:not(:first)').remove().end().val('').change();
            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 2, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 2차 분류 변경
        $('#jobLv2Selector').change(function() {
            $('#jobLv3Selector').find('option:not(:first)').remove().end().val('').change();
            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 3, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        <c:if test="${not empty param.jobLv1Selector}">
        $('#jobLv1Selector').val('${param.jobLv1Selector}').change();
        </c:if>
        <c:if test="${not empty param.jobLv2Selector}">
        $('#jobLv2Selector').val('${param.jobLv2Selector}').change();
        </c:if>
        <c:if test="${not empty param.jobLv3Selector}">
        $('#jobLv3Selector').val('${param.jobLv3Selector}');
        </c:if>

        loadData(1);

    });

    function goSearch(curPage){
        searchFlag = 'search';
        loadData(curPage);

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
        colModels.push({label:'no', name:'rn',index:'rn', width:15, align:'center', sortable: false})
        colModels.push({label:'1차분류', name:'jobClsfNmLv1',index:'jobClsfLv1Nm', width:50, align:'center', sortable: false})
        colModels.push({label:'2차분류', name:'jobClsfNmLv2',index:'jobClsfLv2Nm', width:50, align:'center', sortable: false})
        colModels.push({label:'3차분류', name:'jobClsfNmLv3',index:'jobClsfLv3Nm', width:50, align:'center', sortable: false})
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:70, sortable: false})
        colModels.push({label:'등록자', name:'regMbrNm',index:'regMbrNm', width:30, align:'center', sortable: false})
        colModels.push({label:'등록일', name:'regDtm',index:'regDtm', width:40, align:'center', sortable: false})

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({
            'jobClsfCdLv1' : $('#jobLv1Selector').val()
          , 'jobClsfCdLv2' : $('#jobLv2Selector').val()
          , 'jobClsfCdLv3' : $('#jobLv3Selector').val()
          , 'searchWord' : $('#searchWord').val()
        }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/job/ajax.list.do",
            data : $.param(_param, true),
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                }else{
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                var data = rtnData.map(function(item, index){
                    item.rn = totalCount - item.rn + 1;
                    item.regDtm = (new Date(item.regDtm)).format('yyyy.MM.dd');
                    var strLinkUrl = mentor.contextpath + "/opr/job/view.do?jobNo=" + item.jobNo;
                    //item.jobNm = "<a href='" + strLinkUrl + "' class='underline'>" + item.jobNm + "</a>";
                    item.jobNm = "<a href='javascript:void(0)' class='underline' onclick='goView(\"" + item.jobNo + "\")'>" + item.jobNm + "</a>";
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

    function goView(jobNo) {
        $('#jobNo').val(jobNo);
        var qry = $('#frm').serialize();
        $(location).attr('href', 'view.do?' + qry);
    }

    function goEdit(){
        location.href = mentor.contextpath + "/opr/job/view.do";
    }
</script>