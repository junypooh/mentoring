<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<div class="cont">
    <div class="title-bar">
        <h2>권한관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>권한관리</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="authCd" name="authCd" />
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>관리자유형</strong>
                <select id="authType" name="authType">
                    <option value="">전체</option>
                    <option value="0" <c:if test="${'0' eq param.authType}">selected='selected'</c:if>>운영관리자</option>
                    <option value="1" <c:if test="${'1' eq param.authType}">selected='selected'</c:if>>그룹관리자</option>
                </select>
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
        </p>
    </div>
    </form>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>0</strong> 건</p>
            <ul>
                <li><button type="button" class="btn-orange" onclick="location.href='view.do'"><span>권한등록</span></button></li>
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

    $(document).ready(function() {

        $('#authType').change(function() {
            goSearch(1);
        });

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(authCd) {
        $('#authCd').val(authCd);
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
        colModels.push({label:'번호', name:'rn', index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'권한코드', name:'authCd', index:'authCd', width:40, align:'center', sortable: false});
        colModels.push({label:'관리자유형', name:'authType', index:'authType', width:40, align:'center', sortable: false});
        colModels.push({label:'관리자 권한명', name:'authNm', index:'authNm', width:70, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm', index:'regMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'변경일', name:'regDtm', index:'regDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'authType':$("#authType").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/auth/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    //item.authNm = "<a class='underline' href='view.do?authCd=" + item.authCd + "'>" + item.authNm + "</a>";
                    item.authNm = "<a class='underline' href='javascript:void(0)' onclick='goView(\""+ item.authCd +"\")'>" + item.authNm + "</a>";
                    item.regDtm = new Date(item.regDtm).format('yyyy.MM.dd');
                    if(item.authType == '0') {
                        item.authType = '운영관리자';
                    } else if(item.authType == '1') {
                        item.authType = '그룹관리자';
                    } else {
                        item.authType = '';
                    }

                    return item;
                });

                // grid data binding
                var emptyText = '등록된 데이터가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 1300, memberData, emptyText);
                // grid data binding

                if(rtnData != null && rtnData.length > 0) {
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.pageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

</script>