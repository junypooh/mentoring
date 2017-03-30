<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<div class="cont">
    <div class="title-bar">
        <h2>관리자관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>관리자관리</li>
        </ul>
    </div>
    <form id="frm">
    <input type="hidden" id="mbrNo" name="mbrNo" />
    <input style="display:none;"> <%-- 폼에 input text가 하나만 존재하면 엔터키로 무조건 submit을 막기위해 --%>
    <div class="search-area general-srch">
        <ul>
            <li>
                <strong>ID/이름</strong>
                <input type="text" name="idName" id="idName" class="text" value="${param.idName}" />
            </li>
        </ul>
        <ul>
            <li>
                <strong>조건검색</strong>
                <select id="mbrCualfType" name="mbrCualfType">
                    <option value="">유형선택</option>
                    <option value="0">운영관리자</option>
                    <option value="1">그룹관리자</option>
                    <option value="2">교육수행기관</option>
                </select>
                <select id="authCd" name="authCd">
                    <option value="">관리자권한선택</option>
                </select>
                <select id="loginPermYn" name="loginPermYn">
                    <option value="">상태</option>
                    <option value="Y" <c:if test="${'Y' eq param.loginPermYn}">selected='selected'</c:if>>활동</option>
                    <option value="N" <c:if test="${'N' eq param.loginPermYn}">selected='selected'</c:if>>미활동</option>
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
                <li><button type="button" class="btn-orange" onclick="location.href='view.do'"><span>관리자등록</span></button></li>
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

        enterFunc($("#idName"), goSearch);

        $('#mbrCualfType').change(function() {
            if($('#mbrCualfType').val() != '') {
                $.ajax({
                    url: "${pageContext.request.contextPath}/ajax.authCdList.do",
                    data : {authType: $('#mbrCualfType').val()},
                    async: false,
                    success: function(rtnData) {
                        $('#authCd').loadSelectOptions(rtnData,'','authCd','authNm',1);
                    }
                });
            } else {
                $('#authCd').loadSelectOptions({},'','authCd','authNm',1);
            }
        });

        <c:if test="${not empty param.mbrCualfType}">
        $('#mbrCualfType').val('${param.mbrCualfType}').change();
        </c:if>
        <c:if test="${not empty param.authCd}">
        $('#authCd').val('${param.authCd}').change();
        </c:if>

        loadData(1);
    });

    function goSearch(curPage) {
        searchFlag = 'search';
        loadData(curPage);
    }

    function goView(mbrNo) {
        $('#mbrNo').val(mbrNo);
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
        colModels.push({label:'유형', name:'authType', index:'authType', width:40, align:'center', sortable: false});
        colModels.push({label:'관리자권한', name:'authNm', index:'authNm', width:40, align:'center', sortable: false});
        colModels.push({label:'ID', name:'id', index:'id', width:70, align:'center', sortable: false});
        colModels.push({label:'관리자명', name:'username', index:'username', width:70, align:'center', sortable: false});
        colModels.push({label:'소속', name:'posCoNm', index:'posCoNm', width:70, align:'center', sortable: false});
        colModels.push({label:'상태', name:'loginPermYn', index:'loginPermYn', width:30, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'regMbrNm', index:'regMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'변경일', name:'chgDtm', index:'chgDtm', width:40, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'idName':$("#idName").val(),
                                    'mbrCualfType':$("#mbrCualfType").val(),
                                    'authCd':$("#authCd").val(),
                                    'loginPermYn':$("#loginPermYn").val()}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/manager/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    //item.username = "<a class='underline' href='view.do?mbrNo=" + item.mbrNo + "'>" + item.username + "</a>";
                    item.username = "<a class='underline' href='javascript:void(0)' onclick='goView(\"" + item.mbrNo + "\")'>" + item.username + "</a>";

                    if(item.authType == '0') {
                        item.authType = '운영관리자';
                    } else if(item.authType == '1') {
                        item.authType = '그룹관리자';
                    } else if(item.authType == '2') {
                        item.authType = '교육수행기관';
                    } else {
                        item.authType = '';
                    }

                    if(item.chgDtm != null) {
                        item.chgDtm = new Date(item.chgDtm).format('yyyy.MM.dd');
                    } else {
                        item.chgDtm = new Date(item.regDtm).format('yyyy.MM.dd');
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