<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
        <p class="pop-title">수업찾기</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
            <p class="bullet-gray">수업선택</p>
            <table class="tbl-style tbl-message">
                <colgroup>
                    <col style="width:145px;">
                    <col>
                    <col style="width:145px;">
                    <col>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="col">학교급</th>
                    <td>
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101533_강의대상코드'])" var="schoolGrds" />
                        <select id="schoolGrd" style="width:162px;">
                            <option value="">전체</option>
                            <c:forEach items="${schoolGrds}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th scope="col">수업상태</th>
                    <td>
                        <%--<spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101541_강의상태코드'])" var="lectStatCds" />--%>
                        <select id="lectStatCd" style="width:162px;">
                            <%--<option value="">전체</option>
                            <c:forEach items="${lectStatCds}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                            </c:forEach>--%>
                            <option value="101543" selected>수강모집</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col">수업유형</th>
                    <td>
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101528_강의유형코드'])" var="lectTypeCds" />
                        <select id="lectType" style="width:162px;">
                            <option value="">전체</option>
                            <c:forEach items="${lectTypeCds}" var="eachObj" varStatus="vs">
                                <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <th scope="col">검색어</th>
                    <td>
                        <input type="text" id="keyword" name="keyword" value="" class="text"/>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="btn-group-c">
                <a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색"  onclick="searchLecture(1);" /></a>
            </div>
            <div id="popBoardArea" class="board-area">
                <div class="board-bot">
                    <p class="total-num fl-l" id="totalCount">총 <strong>0</strong> 건</p>
                    <ul>
                        <li><button type="button" class="btn-orange" onclick="addLectureInfo()"><span>선택</span></button></li>
                        <li><button type="button" class="btn-gray" onclick="closePopup()"><span>취소</span></button></li>
                    </ul>
                </div>
                <table id="lectureList">

                </table>
            </div>

        </form>
    </div>
    <a href="javascript:void(0)" id="closePopup" class="btn-close-pop">닫기</a>
</div>
<script type="text/javascript">

    var popup_dataSet = {
        params: {
        }
    };

    var popup_searchFlag = 'load';

    function initailizePopup(){

        $('body').addClass('dim');
        $(".popup-area").css("display","");
        $("#_lectTimsInfoPopup").css("display","block");

        var colModels = [];
        colModels.push({label:'recomTargtNo', name:'recomTargtNo',index:'recomTargtNo', width:25, align:'center', sortable: false, hidden: true});
        colModels.push({label:'lectTims', name:'lectTims',index:'lectTims', width:25, align:'center', sortable: false, hidden: true});
        colModels.push({label:'학교급', name:'lectTargtNm',index:'lectTargtNm', width:60, align:'center', sortable: false});
        colModels.push({label:'유형', name:'lectTypeNm',index:'lectTypeNm', width:45, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:60, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle',index:'lectTitle',  align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'lectrMbrNm',index:'lectrMbrNm', align:'center', width:50, sortable: false});
        colModels.push({label:'수업상태', name:'lectStatNm',index:'lectStatNm', align:'center', width:60, sortable: false});
        colModels.push({label:'수업일', name:'lectDay',index:'lectDay', align:'center', width:60, sortable: false});

        var data = [];

        $('.popup-area .board-bot .total-num').html('총 <strong>0</strong> 건');

        initJqGridTable('lectureList', 'popBoardArea', 500, colModels, true, 320);
        setDataJqGridTable('lectureList', 'popBoardArea', 500, data, '검색된 결과가 없습니다.',320);
    }

    $(document).ready(function(){

        $("#closePopup").click(function(){
            closePopup();
        });

        $("input[name='keyword']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                searchLecture(1);
            }
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closePopup();
            }
        });

    });

    function renderResult(rtnData){
        var data = rtnData.map(function(item, index) {

            item.gridRowId = item.recomTargtNo + "" + item.lectTims;
            item.lectDay = item.lectDay.toDay();

            return item;
        });

        if(rtnData != null && rtnData.length > 0) {
            $('.popup-area .board-bot .total-num').html('총 <strong>' + rtnData.length +'</strong> 건');
        } else {
            $('.popup-area .board-bot .total-num').html('총 <strong>0</strong> 건');
        }

        // grid data binding
        var emptyText = '';
        if(popup_searchFlag == 'load') {
            emptyText = '등록된 데이터가 없습니다.';
        } else {
            emptyText = '검색된 결과가 없습니다.';
        }
        setDataJqGridTable('lectureList', 'popBoardArea', 500, data, emptyText, 320);


        $('.loading').hide();
        $('.jqgrid-overlay').hide();
    }

    function searchLecture(curPage, recordCountPerPage){
        popup_searchFlag = 'search';

        var _param = jQuery.extend({'schoolGrd':$("#schoolGrd").val()
            ,'lectStatCd':$("#lectStatCd").val()
            ,'lectType':$("#lectType").val()
            ,'searchKey':$('#keyword').val()
        }, popup_dataSet.params);

        $('.loading').show();
        $('.jqgrid-overlay').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/web/front/ajax.searchLectTimesInfoList.do",
            data : JSON.stringify(_param),
            contentType: "application/json",
            dataType : "json",
            method:"post",
            success: renderResult
            }
        );
    }



    function closePopup(){
        $(".popup-area").css("display","none");
        $('body').removeClass('dim');
        $( "#lectureList" ).jqGrid('GridUnload');
        $("form").each(function() {
            this.reset();
        });
    }

    function addLectureInfo(){
        var gridObject = $( "#lectureList" );
        var data = gridObject.jqGrid('getGridParam', 'selarrrow');

        if(data.length == 0){
            alert('추가하고자 하는 수업을 선택하세요.');
            return false;
        }
        var selectedLectures = [];

        data.forEach(function(val,index){
            var lecture = new Object();
            lecture.recomTargtNo = gridObject.jqGrid('getCell', val, 'recomTargtNo');
            lecture.lectTims = gridObject.jqGrid('getCell', val, 'lectTims');
            lecture.recomTargtCd = '101643';
            selectedLectures.push(lecture);
        });

        ${param.callbackFunc}(selectedLectures);
        closePopup();
    }

</script>