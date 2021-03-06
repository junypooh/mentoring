<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>기타자료실</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>커뮤니티관리</li>
            <li>기타자료실</li>
        </ul>
    </div>
    <div class="search-area">
        <ul>
            <li>
                <strong>유형</strong>
                <label class="mr5"><input type="radio" name="dataTypeCd" value="" checked/> 전체</label>
                <label class="mr5"><input type="radio" name="dataTypeCd" value="101759" /> 문서</label>
                <label class="mr5"><input type="radio" name="dataTypeCd" value="101760" /> 동영상</label>
                <label class="mr5"><input type="radio" name="dataTypeCd" value="101761" /> 링크</label>
            </li>
            <li>
                <strong>대상</strong>
                <input type="hidden" id="dataTargtClass" value=""/>
                <label class="mr5"><input type="checkbox" name="schoolGrd" value="101534" <c:if test="${param.schoolGrd eq '101534' or param.schoolGrd eq '101537' or param.schoolGrd eq '101539' or param.schoolGrd eq '101540'}">checked</c:if>/> 초</label>
                <label class="mr5"><input type="checkbox" name="schoolGrd" value="101535" <c:if test="${param.schoolGrd eq '101535' or param.schoolGrd eq '101537' or param.schoolGrd eq '101538' or param.schoolGrd eq '101540'}">checked</c:if>/> 중</label>
                <label class="mr5"><input type="checkbox" name="schoolGrd" value="101536" <c:if test="${param.schoolGrd eq '101536' or param.schoolGrd eq '101538' or param.schoolGrd eq '101539' or param.schoolGrd eq '101540'}">checked</c:if>/> 고</label>
                <label class="mr5"><input type="checkbox" name="schoolEtcGrd" value="101713" <c:if test="${param.schoolEtcGrd eq '101713'}">checked</c:if>/> 기타</label>
            </li>
            <li class="condition-big">
                <strong>검색조건</strong>
                <select id="searchKey">
                    <option value="">전체</option>
                    <option value="dataNm" <c:if test="${param.searchKey eq 'dataNm'}">selected</c:if>>제목</option>
                    <option value="dataSust" <c:if test="${param.searchKey eq 'dataSust'}">selected</c:if>>내용</option>
                </select>
                <input type="text" id="searchWord" value="${param.searchWord}">
            </li>
        </ul>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onClick="javascript:goSearch(1);"><span class="search">검색</span></button>
        </p>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
        </div>
        <table id="boardTable"></table>
        <div id="paging"></div>
        <div class="board-bot">
            <ul>
                <li><a href="edit.do"><img src="${pageContext.request.contextPath}/images/btn_regist.gif" alt="등록" /></a></li>
                <li><button type="button" class="btn-gray"><span>삭제</span></button></li>
            </ul>
        </div>
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
        },
        data: {}
    };
    mentor.mentorDataSet = dataSet;

    var searchFlag = 'load';

    $(document).ready(function(){

        enterFunc($("#searchWord"),goSearch);

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
        colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'유형', name:'dataTypeNm',index:'dataTypeNm', width:40, align:'center', sortable: false});
        colModels.push({label:'대상', name:'dataTargtClassNm',index:'dataTargtClassNm', width:40, align:'center', sortable: false});
        colModels.push({label:'자료명', name:'dataNm',index:'dataNm', width:90, sortable: false});
        colModels.push({label:'등록자', name:'chgMbrNm',index:'chgMbrNm', width:40, align:'center', sortable: false});
        colModels.push({label:'등록일', name:'chgDtm',index:'chgDtm',width:60 ,align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, true);
        //jqGrid setting

        //자료대상 체크박스
        //dataTargtClass
        var checkDataTargt = new Array;
        $('input[name=schoolGrd]:checked').each(function(index){
            checkDataTargt.push($(this).val());
        });

        if(checkDataTargt.length == 1){
            $("#dataTargtClass").val(checkDataTargt[0]);
        }else if(checkDataTargt.length == 2){
            if (!!~checkDataTargt.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkDataTargt.indexOf("${code['CD101533_101535_중학교']}")) { //초등,중학교
                $("#dataTargtClass").val("${code['CD101533_101537_초등_중학교'] }");
            } else if (!!~checkDataTargt.indexOf("${code['CD101533_101535_중학교']}") && !!~checkDataTargt.indexOf("${code['CD101533_101536_고등학교']}")) { //중등,고등학교
                $("#dataTargtClass").val("${code['CD101533_101538_중_고등학교'] }");
            } else if (!!~checkDataTargt.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkDataTargt.indexOf("${code['CD101533_101536_고등학교']}")) { //초등,고등학교
                $("#dataTargtClass").val("${code['CD101533_101539_초등_고등학교'] }");
            }
        }else if(checkDataTargt.length == 3){
            $("#dataTargtClass").val("${code['CD101533_101540_초등_중_고등학교'] }");
        }else{
            $("#dataTargtClass").val("");
        }

        var _param = jQuery.extend({
                        'searchKey':$("#searchKey").val()
                      , 'searchWord':$("#searchWord").val()
                      , 'adminYn' : 'Y'
                      , 'dataType' : 'etcData'
                      , 'dataTypeCd' : $('input[name="dataTypeCd"]:checked').val()
                      , 'schoolGrd' : $("#dataTargtClass").val()
                      , 'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val()
        }, dataSet.params);
        dataSet.data = _param;

        $.ajax({
            url: "${pageContext.request.contextPath}/web/community/ajax.selectDataInfo.do",
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
                    item.gridRowId = item.dataSer;
                    item.rn = totalCount - item.rn + 1;
                    item.dataNm = '<a href="javascript:void(0)" onClick="fn_goDetail('+item.dataSer+')" class="underline">'+item.dataNm+'</a>';
                    item.chgDtm = (new Date(item.chgDtm)).format('yyyy-MM-dd');
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
            }
        });
    }

    // 삭제버튼 클릭
    $('.btn-gray').click(function(){

        var dataInfos =  $('#boardTable').jqGrid('getGridParam','selarrrow');

        var dataSers = new Array();
        var connectTotCnt = 0;

        $.each(dataInfos, function(index, value){
            var dataInfo = value.split('||')
            var dataSer = dataInfo[0];
            var connectCnt = dataInfo[1];

            dataSers.push(dataSer);
            connectTotCnt += Number(connectCnt);
        });

        if(connectTotCnt > 0){
            alert('해당 자료와 연결된 수업이 있습니다. 연결수업을 해제한 후 삭제해주세요');
            return;
        }

        if(confirm("삭제하시겠습니까?")){
            $.ajax({
                url: "${pageContext.request.contextPath}/web/community/ajax.deleteDataInfo.do",
                data : {'dataSers':dataSers},
                contentType: "application/json",
                dataType: 'json',
                type: 'GET',
                traditional: true,
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert(rtnData.data);
                        location.reload();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.deleteDataInfo.do", status, err.toString());
                }
            });
        }
    });

    /* 기타자료 상세 이동 */
    function fn_goDetail(dataSer){
        location.href = '${pageContext.request.contextPath}/web/community/etcData/edit.do?dataSer='+dataSer;
    }

</script>
