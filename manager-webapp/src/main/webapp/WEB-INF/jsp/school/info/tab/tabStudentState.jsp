<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="tab-cont"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
    <table class="tbl-style">
        <colgroup>
            <col style="width:147px;" />
            <col />
            <col style="width:147px;" />
            <col />
        </colgroup>
        <tbody>
                    <tr>
                    <input type="hidden" id="schNo" name="schNo" />
                        <th scope="col" class="ta-l">아이디</th>
                        <td><input type="text" class="text" id="user_Id" name="user_Id" value="" /></td>
                        <th scope="col" class="ta-l">사용유무</th>
                        <td>
                            <label>
                                <input type="radio" name="useYn" checked="checked" value="" /> 전체
                            </label>
                            <label>
                                <input type="radio" name="useYn" value="Y" /> 사용중
                            </label>
                            <label>
                                <input type="radio" name="useYn" value="N" /> 사용안함
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">이름</th>
                        <td>
                            <input type="text" class="text" id="user_name" name="user_name"/>
                        </td>
                        <th scope="col" class="ta-l">교실명</th>
                        <td>
                            <input type="text" class="text" id="clasRoomNm" name="clasRoomNm"/>
                        </td>
                    </tr>
                </tbody>
    </table>
    <p class="search-btnbox">
        <button type="button" class="btn-style02" onclick="goSearch(1);"><span class="search">조회</span></button>
    </p>
    <div class="board-top">
        <p class="total-num">총 <strong>00</strong> 건</p>
    </div>
    <div id="boardArea">
    <table id="boardTable"></table>
    </div>
    <div id="studentPaging"></div>
</div>
<script type="text/javascript">
    var searchFlag = 'load';
    mentor.schoolTcherPageNavi = React.render(
        React.createElement(PageNavi, {pageFunc:goSearch, totalRecordCount:'0', recordCountPerPage:'10',pageSize:'10'}),
        document.getElementById('studentPaging')
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
    });

    function goSearch(curPage, recordCountPerPage){
    console.log(curPage);
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        var _param = jQuery.extend({'schNo': '${param.schNo}'
                              ,'mbrClassCd': '100858'
                              , 'useYn':$("input[name=useYn]:checked").val()
                              , 'clasRoomNm':$("#clasRoomNm").val()
                              , 'userId':$("#user_Id").val()
                              , 'username':$("#user_name").val()}, dataSet.params);

        $.ajax({
            url: mentor.contextpath +"/school/info/ajax.schoolTcherInfo.do",
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var colModels = [];
                colModels.push({label:'번호', name:'rn',index:'rn', width:25, align:'center', sortable: false});
                colModels.push({label:'회원유형', name:'mbrCualfNm',index:'mbrCualfNm', width:50, align:'center', sortable: false});
                colModels.push({label:'아이디', name:'userId',index:'userId', width:60, align:'center', sortable: false});
                colModels.push({label:'이름', name:'username',index:'username', width:60, align:'center', sortable: false});
                colModels.push({label:'교실명', name:'clasNm', index:'clasNm', width:60, sortable: false, cellattr: function(rowId, val, rawObject, cm, rdata) { return 'title="' + String(rawObject.clasRoomNm).replaceAll(',', '\r\n') +'"'} });
                colModels.push({label:'사용유무', name:'loginPermYn',index:'loginPermYn', width:45, align:'center', sortable: false, key: true});
                colModels.push({label:'신청/가입일', name:'reqDtm',index:'reqDtm', width:45, align:'center', sortable: false});
                colModels.push({label:'관리', name:'deleteForm',index:'deleteForm', width:45, align:'center', sortable: false});
                console.log(rtnData);
                initJqGridTable('boardTable', 'boardArea', 500, colModels, false);
                //initJqGridTable('boardTable', colModels, 10, false);
                //resizeJqGridWidth('boardTable', 'boardArea', 500);

                var schoolData = rtnData.map(function(item, index) {
                    // 교실명 설정
                    var classes = [];
                    if(item.clasRoomNm != null) {
                        classes = item.clasRoomNm.split(",");
                        if(classes.length > 1) {
                            item.clasNm = classes[0] + " > 외" + (classes.length-1);
                        } else {
                            item.clasNm = classes[0];
                        }
                    }
                    if(item.loginPermYn != null) {
                        if(item.loginPermYn == 'Y') {
                            item.loginPermYn = '사용중';
                        } else {
                            item.loginPermYn = '사용안함';
                        }
                    }

                    item.deleteForm = '<button type="button" class="btn-style01" onClick="clickDelete('+index+');"><span>삭제</span></button>';
                    item.deleteForm += '<input type="hidden" id="clasRoomSer'+index+'" value="'+item.clasRoomSer+'"/>';
                    item.deleteForm += '<input type="hidden" id="mbrNo'+index+'" value="'+item.mbrNo+'"/>';
                    return item;
                });

                if(searchFlag == 'load') {
                    emptyText = '등록된 학교 정보가 없습니다.';
                } else {
                    emptyText = '검색된 결과가 없습니다.';
                }
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

    function clickDelete(index){
        if(!confirm('삭제 하시겠습니까?')){
            return false;
        }
        //alert($("#clasRoomSer"+index).val());
        //alert($("#mbrNo"+index).val());
        var _param = jQuery.extend({'schNo': '${param.schNo}'
                              ,'clasRoomSers': $("#clasRoomSer"+index).val()
                              , 'mbrNo':$("#mbrNo"+index).val()}, dataSet.params);
        //return false;
            $.ajax({
                url: mentor.contextpath +"/school/info/ajax.deleteSchoolTcher.do",
                data : _param,
                contentType: "application/json",
                dataType: 'json',
                success: function(rtnData) {
                    if (rtnData.success) {
                    alert("삭제되었습니다");
                        tabmenu(1);
                    }
                }
            });


        }


</script>



