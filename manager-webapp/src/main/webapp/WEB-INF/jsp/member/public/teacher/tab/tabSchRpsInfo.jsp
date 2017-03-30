<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="board-top">
    <p class="total-num">총 <strong>0</strong> 건</p>
    <ul>
        <li><button type="button" class="btn-style02" id="addSchRpsBtn"><span>추가</span></button></li>
    </ul>
</div>
<table id="boardTable"></table>
<div id="paging"></div>
<form id='schRpsForm' method='POST'>
</form>
<!-- Popup -->
<c:import url="/popup/schoolSearch.do">
  <c:param name="callbackFunc" value="callbackSelected" />
</c:import>
<!-- Popup[E] -->

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

        $('#addSchRpsBtn').click(function(){
            $('body').addClass('dim');
            $('.popup-area').css({'display': 'block'});
            emptySchoolGridSet();
        });

    });

    mentor.PageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:loadData, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );

    // 대표 학교 조회
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
        colModels.push({label:'구분', name:'schMbrCualfNm', index:'schMbrCualfNm', width:50, align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm', index:'schNm', width:70, align:'center', sortable: false});
        colModels.push({label:'등록자', name:'authNm', index:'authNm', width:70, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'authDtm', index:'authDtm', width:60, align:'center', sortable: false});
        colModels.push({label:'관리', name:'managing', index:'manage', width:30, align:'center', sortable: false, cellattr: function(rowId, val, rawObject, cm, rdata) { return 'title=' }});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'mbrNo': ${param.reqMbrNo}
                                    ,'schMbrCualfCd': '101698'
                                    ,'cualfRegStatCd': '101702'}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/teacher/ajax.tabSchRpsList.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.gridRowId = item.schNo;

                    if(item.authDtm == null) {
                        item.authDtm = String(item.regDtm).toDay();
                    } else {
                        item.authDtm = String(item.authDtm).toDay();
                    }

                    item.managing =  "<button type='button' class='btn-style01' title='삭제' onclick='delMbrSchCualf(\"" + item.schMbrRollSer +"\")'><span>삭제</span></button>";

                    return item;
                });

                // grid data binding
                var emptyText = '등록된 대표 학교 정보가 없습니다.';
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

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    // 대표 학교 삭제
    function delMbrSchCualf(schMbrRollSer) {

        if(!confirm('대표교사 권한을 삭제 하시겠습니까?')) {
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/member/public/teacher/ajax.deleteSchCualf.do",
            data : {'schMbrRollSer': schMbrRollSer},
            success: function(rtnData) {
                alert('삭제 되었습니다.');
                loadData(dataSet.params.currentPageNo);
            }
        });
    }

    function callbackSelected(obj) {

        if(!confirm('대표교사 권한을 추가하시겠습니까?')) {
            return;
        }

        closePop();

        var send = false;
        var inputs = "";
        $.each(obj, function(idx){
            // 중복 제거
            var selSchool =  $('#boardTable').jqGrid('getRowData', obj[idx]);
            if(selSchool.schNm == null) {
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].schNo".format(idx) + "' value='"+ obj[idx] +"' />";
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].mbrNo".format(idx) + "' value='${param.reqMbrNo}' />";
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].schMbrCualfCd".format(idx) + "' value='101698' />";
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].cualfRegStatCd".format(idx) + "' value='101702' />";
                send = true;
            }
        });
        inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";

        $('#schRpsForm').empty().append(inputs);
        if(send) {
            $("#schRpsForm").ajaxForm({
                url : "${pageContext.request.contextPath}/member/public/teacher/ajax.insertSchCualf.do",
                dataType: 'text',
                success:function(data, status){
                    loadData(dataSet.params.currentPageNo);
                }
            }).submit();
        }

    }

</script>