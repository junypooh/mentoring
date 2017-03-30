<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="board-top">
    <p class="total-num">총 <strong>0</strong> 건</p>
</div>
<table id="boardTable"></table>
<div id="paging"></div>

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

        loadData(1);
    });

    mentor.PageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:loadData, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );

    // 교실 등록 이력 조회
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
        colModels.push({label:'구분', name:'clasRoomTypeNm', index:'clasRoomTypeNm', width:30, align:'center', sortable: false});
        colModels.push({label:'학교', name:'schInfo.schNm', index:'schInfo.schNm', width:90, sortable: false});
        colModels.push({label:'교실명', name:'clasRoomNm', index:'clasRoomNm', width:90, sortable: false});
        colModels.push({label:'개설자', name:'tchrMbrNm', index:'tchrMbrNm', width:90, align:'center', sortable: false});
        colModels.push({label:'신청일', name:'regDtm', index:'regDtm', width:40, align:'center', sortable: false});
        colModels.push({label:'상태', name:'regStatNm', index:'regStatNm', width:40, align:'center', sortable: false});
        colModels.push({label:'승인일', name:'authDtm', index:'authDtm', width:40, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'reqMbrNo': ${param.reqMbrNo}, 'type': 'setup'}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/teacher/ajax.tabClassList.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.authDtm = new Date(item.authDtm).format('yyyy.MM.dd');
                    item.regDtm = new Date(item.regDtm).format('yyyy.MM.dd');
                    item.tchrMbrNm = item.tchrMbrNm + " (" + item.tchrMbrClassNm + ")";

                    return item;
                });

                // grid data binding
                var emptyText = '등록된 교실정보가 없습니다.';
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
                mentor.PageNavi.setData(dataSet.params);

                // 반대표 리스트
                var clasData = rtnData.filter(function(item) {
                    if(item.regStatCd == '101526' /*수락(승인)*/ && item.clasRoomCualfCd == '101691' /*반대표*/) {
                        return true;
                    } else {
                        return false;
                    }
                });

                if(clasData != null && clasData.length > 0) {
                    $("#listBodyRpsClass").empty();
                    $("#classRpsInfo").tmpl(clasData).appendTo("#listBodyRpsClass");
                } else {
                    $("#classRpsEmptyInfo").css({'display':'table-row'});
                }
                // 반대표 리스트

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    // 대표교실 설정
    function setRpsClas(flag, reqSer) {
        var confirmMsg = '';
        if(flag == 'Y') {
            rpsYn = 'N';
            confirmMsg = '대표교실 설정을 삭제 하시겠습니까?';
        } else {
            rpsYn = 'Y';
            confirmMsg = '대표교실로 설정 하시겠습니까?';
        }

        if(!confirm(confirmMsg)) {
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/general/ajax.requestRpsClass.do",
            data : {'reqSer':reqSer, 'rpsYn':rpsYn, 'tchrMbrNo':${param.reqMbrNo}},
            success: function(rtnData) {
                alert('저장 되었습니다.');
                loadData(dataSet.params.currentPageNo);
            }
        });
    }

    // 소속 교실 삭제
    function delRpsClas(reqSer) {

        if(!confirm('삭제 하시겠습니까?')) {
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/general/ajax.removeClass.do",
            data : {'reqSer':reqSer},
            success: function(rtnData) {
                alert('삭제 되었습니다.');
                loadData(dataSet.params.currentPageNo);
            }
        });
    }

</script>