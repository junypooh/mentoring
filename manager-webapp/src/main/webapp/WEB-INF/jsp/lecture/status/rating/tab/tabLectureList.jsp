<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<table class="tbl-style">
    <colgroup>
        <col style="width:147px;" />
        <col />
        <col style="width:147px;" />
        <col />
    </colgroup>
    <tbody>
        <tr>
            <th scope="col" class="ta-l">수업유형</th>
            <td>
                <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD101512_101528_강의유형코드'])" var="list" />
                <label>
                    <input type="radio" name="lectTypeCd" value="" checked/> 전체
                </label>
                <c:forEach items="${list}" var="list" varStatus="vs">
                <label>
                    <input type="radio" name="lectTypeCd" value="${list.cd}"/> ${list.cdNm}
                </label>
                </c:forEach>
            </td>
            <th scope="col" class="ta-l">대상</th>
            <td>
                <input type="hidden" id="lectTargtCd" value=""/>
                <label class="mr5"><input type="checkbox" name="lectTargtCd" value="101534"/> 초</label>
                <label class="mr5"><input type="checkbox" name="lectTargtCd" value="101535"/> 중</label>
                <label class="mr5"><input type="checkbox" name="lectTargtCd" value="101536"/> 고</label>
                <label class="mr5"><input type="checkbox" name="schoolEtcGrd" value="101713"/> 기타</label>
            </td>
        </tr>
        <tr>
            <th scope="col" class="ta-l">수업명</th>
            <td>
                <input type="text" class="text" id="lectTitle" />
            </td>
            <th scope="col" class="ta-l">멘토</th>
            <td>
                <input type="text" class="text" id="lectrNm"/>
            </td>
        </tr>
        <tr>
            <th scope="col" class="ta-l">배정사업명</th>
            <td>
                <input type="text" class="text" id="grpNm" />
            </td>
            <th scope="col" class="ta-l">직업</th>
            <td>
                <input type="text" class="text" id="jobNm" />
            </td>
        </tr>
        <tr>
            <th scope="col" class="ta-l">평점</th>
            <td colspan="3">
                <select id="avgPoint" style="width:7%;">
                    <option value="">선택</option>
                    <option value="1">1점</option>
                    <option value="2">2점</option>
                    <option value="3">3점</option>
                    <option value="4">4점</option>
                    <option value="5">5점</option>
                </select>
            </td>
        </tr>
    </tbody>
</table>
<p class="search-btnbox">
    <button type="button" class="btn-style02" onClick="goSearch(1);"><span class="search">조회</span></button>
</p>
<div class="board-top">
    <p class="total-num">총 <strong>00</strong> 건</p>
    <ul>
        <li>
            <button type="button" class="btn-style02" onClick="fn_excelDown();"><span>엑셀다운로드</span></button>
        </li>
    </ul>
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

    var searchFlag = 'load';

    mentor.pageNavi = React.render(
            React.createElement(PageNavi, {currentPageNo:1, pageFunc:loadData, totalRecordCount:0, recordCountPerPage:20,pageSize:10}),
            document.getElementById('paging')
    );

    $(document).ready(function(){

        enterFunc($("#jobNm"),goSearch);
        enterFunc($("#lectTitle"),goSearch);
        enterFunc($("#lectrNm"),goSearch);
        enterFunc($("#grpNm"),goSearch);

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
        colModels.push({label:'번호', name:'rn',index:'rn', width:20, align:'center'});
        colModels.push({label:'수업유형', name:'lectTypeNm',index:'lectTypeNm', width:20, align:'center'});
        colModels.push({label:'수업대상', name:'lectTargtNm',index:'lectTargtNm', width:50, align:'center'});
        colModels.push({label:'수업명',name:'lectTitle',index:'lectTitle', width:70});
        colModels.push({label:'멘토', name:'lectrNm',index:'lectrNm', width:50});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:50});
        colModels.push({label:'배정사업', name:'grpNm',index:'grpNm', width:50});
        colModels.push({label:'교사(명)', name:'teacherCnt',index:'teacherCnt', width:20, align:'center'});
        colModels.push({label:'교사평점', name:'techerPoint',index:'techerPoint', width:20, align:'center'});
        colModels.push({label:'학생(명)', name:'stuCnt',index:'stuCnt', width:20, align:'center'});
        colModels.push({label:'학생평점', name:'stuPoint',index:'stuPoint', width:20, align:'center'});

        initJqGridTable('boardTable', 'boardArea', 500, colModels, false);

        //jqGrid setting
        $('.jqgrid-overlay').show();
        $('.loading').show();

        // 수업대상 체크박스
        var checkLectType = new Array;
        $('input[name=lectTargtCd]:checked').each(function(index){
            checkLectType.push($(this).val());
        });

        if(checkLectType.length == 1){
            $("#lectTargtCd").val(checkLectType[0]);
        }else if(checkLectType.length == 2){
            if (!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101535_중학교']}")) { //초등,중학교
                $("#lectTargtCd").val("${code['CD101533_101537_초등_중학교'] }");
            } else if (!!~checkLectType.indexOf("${code['CD101533_101535_중학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")) { //중등,고등학교
                $("#lectTargtCd").val("${code['CD101533_101538_중_고등학교'] }");
            } else if (!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")) { //초등,고등학교
                $("#lectTargtCd").val("${code['CD101533_101539_초등_고등학교'] }");
            }
        }else if(checkLectType.length == 3){
            $("#lectTargtCd").val("${code['CD101533_101540_초등_중_고등학교'] }");
        }else{
            $("#lectTargtCd").val("");
        }


        var _param = jQuery.extend({
                    'lectTypeCd':$('input[name=lectTypeCd]:checked').val()
                  , 'schoolGrd': $("#lectTargtCd").val()
                  , 'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val()
                  , 'lectTitle':$('#lectTitle').val()
                  , 'lectrNm':$('#lectrNm').val()
                  , 'grpNm':$('#grpNm').val()
                  , 'jobNm':$('#jobNm').val()
                  , 'avgPoint':$('#avgPoint').val()
        }, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/rating/ajax.ratingByLecture.do",
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

                var data = rtnData.map(function(item, index){
                    item.rn = totalCount - item.rn + 1;

                    var lectTargtNm;
                    if(item.lectTargtCd == "${code['CD101533_101534_초등학교']}"){
                        lectTargtNm = '초';
                    }else if(item.lectTargtCd == "${code['CD101533_101535_중학교']}"){
                        lectTargtNm = '중';
                    }else if(item.lectTargtCd == "${code['CD101533_101536_고등학교']}"){
                        lectTargtNm = '고';
                    }else if(item.lectTargtCd == "${code['CD101533_101537_초등_중학교']}"){
                        lectTargtNm = '초중';
                    }else if(item.lectTargtCd == "${code['CD101533_101538_중_고등학교']}"){
                        lectTargtNm = '중고';
                    }else if(item.lectTargtCd == "${code['CD101533_101539_초등_고등학교']}"){
                        lectTargtNm = '초고';
                    }else if(item.lectTargtCd == "${code['CD101533_101540_초등_중_고등학교'] }"){
                        lectTargtNm = '초중고';
                    }
                    item.lectTargtNm = lectTargtNm;

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

    // 엑셀다운로드
    function fn_excelDown(){
        var url = "${pageContext.request.contextPath}/lecture/status/rating/excel.ratingByLecture.do";
        var paramData = $.param({
                    'lectTypeCd':$('input[name=lectTypeCd]:checked').val()
                  , 'schoolGrd': $("#lectTargtCd").val()
                  , 'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val()
                  , 'lectTitle':$('#lectTitle').val()
                  , 'lectrNm':$('#lectrNm').val()
                  , 'grpNm':$('#grpNm').val()
                  , 'jobNm':$('#jobNm').val()
                  , 'avgPoint':$('#avgPoint').val()
        }, true);

        var inputs = "";
        jQuery.each(paramData.split('&'), function(){
            var pair = this.split('=');
            if(pair[0] != 'lectTitle' && pair[0] != 'lectrNm' && pair[0] != 'grpNm' && pair[0] != 'jobNm') {
                inputs+="<input type='hidden' name='"+ pair[0] +"' value='"+ pair[1] +"' />";
            }
        });
        inputs+="<input type='hidden' name='lectTitle' value='" + $("#lectTitle").val() + "' />";
        inputs+="<input type='hidden' name='lectrNm' value='" + $("#lectrNm").val() + "' />";
        inputs+="<input type='hidden' name='grpNm' value='" + $("#grpNm").val() + "' />";
        inputs+="<input type='hidden' name='jobNm' value='" + $("#jobNm").val() + "' />";

        //debugger
        inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";

        var sForm = "<form action='"+ url +"' method='POST'>" + inputs + "</form>";
        jQuery(sForm).appendTo("body").submit().remove();
    }

</script>