<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="tab-cont"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
    <div class="board-top">
        <p class="total-num">총 <strong>00</strong> 건</p>
        <ul>
        <li>
            <select class="slt-style" style="width:155px;" title="배정그룹" id="biz">
                <option value="">배정그룹 전체</option>
            </select>
            <select class="slt-style" style="width:155px;" title="교실" id="classRoom">
                <option value="">교실 전체</option>
            </select>
            <select id="applStatCd" name="applStatCd" title="신청">
                <option value="">전체</option>
                <option value="1">신청</option>
                <option value="2">취소</option>
            </select>
        </li>
        </ul>
    </div>
    <div id="boardArea">
    <table id="boardTable"></table>
    </div>
    <div id="tcherPaging"></div>
</div>

<script type="text/jsx;harmony=true">
/*
     mentor.schoolTcherPageNavi = React.render(
        React.createElement(PageNavi, {pageFunc:'goSearch', totalRecordCount:'0', recordCountPerPage:'10',pageSize:'10'}),
        document.getElementById('tcherPaging')
    );
*/
</script>

<script type="text/javascript">
    getBizGroup();
    getClassRoom();
     mentor.schoolTcherPageNavi = React.render(
        React.createElement(PageNavi, {pageFunc:goSearch, totalRecordCount:'0', recordCountPerPage:'10',pageSize:'10'}),
        document.getElementById('tcherPaging')
    );
    /*
    mentor.schoolTcherPageNavi = React.render(
        React.createElement(
            PageNavi,
                { pageFunc: goSearch, totalRecordCount: 0, currentPageNo: 1, recordCountPerPage: 10, pageSize :10 }
        )
        , document.getElementById('tcherPaging'));
*/
    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    $(document).ready(function() {
        goSearch(1);

        $("#biz").change(function(){
            goSearch(1);
        });
        $("#classRoom").change(function(){
            goSearch(1);
        });
        $("#applStatCd").change(function(){
            goSearch(1);
        });

    });


    function getBizGroup(){
        $.ajax({
            url: "${pageContext.request.contextPath}/school/info//ajax.listBizSetGrp.do",
            data: {  schNo : '${param.schNo}'},
            success: function(rtnData) {
                mentor.rtnData = rtnData;
                if(rtnData != null && rtnData.length > 0){
                    mentor.bizGrp = [];
                    mentor.biz = [];
                    for(var i=0; i<rtnData.length ; i++){
                        var obj = rtnData[i];
                        if(mentor.biz.map(function(e) { return e.grpNo; }).indexOf(obj.bizGrpInfo.grpNo)<0){
                            mentor.biz.push({'grpNo':obj.bizGrpInfo.grpNo,'grpNm':obj.bizGrpInfo.grpNm});

                        }

                    }
                    $("#biz").loadSelectOptions(mentor.biz, "", "grpNo", "grpNm", 1).change();
                }else{
                    goSearch(1);
                    $("#biz").hide().emptySelect(1);
                }
            }
        });
    }

    function getClassRoom(){
        $.ajax({
            url: "${pageContext.request.contextPath}/school/info/ajax.schoolClassRoom.do",
            data: {  schNo : '${param.schNo}'},
            success: function(rtnData) {
                mentor.rtnData = rtnData;
                if(rtnData != null && rtnData.length > 0){
                    mentor.classRoom = [];
                    for(var i=0; i<rtnData.length ; i++){
                        var obj = rtnData[i];

                        mentor.classRoom.push({'clasRoomSer':obj.clasRoomSer,'clasRoomNm':obj.clasRoomNm});

                    }
                    $("#classRoom").loadSelectOptions(mentor.classRoom, "", "clasRoomSer", "clasRoomNm", 1).change();
                }else{
                    goSearch(1);
                    $("#classRoom").hide().emptySelect(1);
                }
            }
        });
    }

    function goSearch(curPage, recordCountPerPage){
    console.log(curPage);
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }


        var _param = jQuery.extend({'lectApplCnt.schNo': '${param.schNo}',
                                'clasRoomSer':$("#classRoom").find("option:selected").val(),
                                'bizGrpInfo.grpNo':$("#biz").find("option:selected").val(),
                                'applStatCd':$("#applStatCd").find("option:selected").val()}
                      ,dataSet.params);

        $.ajax({
            url: mentor.contextpath +"/school/info/ajax.listSchoolLect.do",
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var colModels = [];
                colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
                colModels.push({label:'배정사업', name:'grpNm',index:'grpNm', width:50, sortable: false});
                colModels.push({label:'수업유형', name:'lectTypeNm', index:'lectTypeNm', align:'center',width:30, sortable: false});
                colModels.push({label:'수업명', name:'lectTitle', index:'lectTitle', width:100, sortable: false});
                colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', width:100, align:'center', sortable: false});
                colModels.push({label:'수업상태', name:'lectStatNm', index:'lectStatNm', width:40, align:'center', sortable: false});
                colModels.push({label:'신청자', name:'applMbrNm', index:'applMbrNm', width:40, align:'center', sortable: false});
                colModels.push({label:'교실정보', name:'clasRoomNm', index:'clasRoomNm', width:60, sortable: false});
                colModels.push({label:'신청유형', name:'applClassNm', index:'applClassNm', width:60, align:'center', sortable: false});
                colModels.push({label:'차감기준', name:'lectureCnt', index:'lectureCnt', width:60, align:'center', sortable: false});
                colModels.push({label:'신청상태', name:'applStatNm', index:'applStatNm', width:60, align:'center', sortable: false});

                console.log(rtnData);
                initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
                //initJqGridTable('boardTable', colModels, 10, false);
                //resizeJqGridWidth('boardTable', 'boardArea', 500);
                var timeInMs = Date.now(); // 현재 일자
                var clasCnt = 0;
                var clasEmpCnt = 0;
                var clasPermCnt = 0;
                var totalCount = 0;

                if(rtnData != null && rtnData.length > 0){
                    totalCount = rtnData[0].totalRecordCount;
                    var lessonData = rtnData.map(function(item, index) {
                        item.rn = totalCount - item.rn + 1;

                        var sTm = item.lectStartTime.match(/\d{2}/g);     // 2자리씩 추출 배열0->시 배열1->분
                        var eTm = item.lectEndTime.match(/\d{2}/g);     // 2자리씩 추출 배열0->시 배열1->분
                        var sTime = parseInt(sTm[0],10)*60 + parseInt(sTm[1]); // 분 데이타로 변환
                        var eTime = parseInt(eTm[0],10)*60 + parseInt(eTm[1]); // 분 데이타로 변환
                        var rTime = eTime-sTime;            // 차이 계산
                        item.lectDay = to_date_format(item.lectDay, ".") + "  " + to_time_format(item.lectStartTime, ":") + " (" +  rTime + "분)";

                        //item.lectDay = imentor.parseDate(item.lectDay).format('yyyy.MM.dd') + " " + item.lectStartTime.replace(/^(\d{2})(\d{2})$/,"$1:$2")+"~"+item.lectEndTime.replace(/^(\d{2})(\d{2})$/,"$1:$2");

                        if(item.applClassCd == '101715'){

                        }else{
                         item.lectureCnt = item.lectureCnt/2;
                        }
                        return item;
                    });
                }

                var emptyText = '등록된 사업이 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 500, rtnData, emptyText);
                if(rtnData != null && rtnData.length > 0) {
                    var totalCount = rtnData[0].totalRecordCount;
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.schoolTcherPageNavi.setData(dataSet.params);

            }
        });
    }


</script>



