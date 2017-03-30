<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
        <p class="pop-title">멘토찾기</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
            <p class="bullet-gray">멘토선택</p>
            <table class="tbl-style tbl-message">
                <colgroup>
                    <col style="width:145px;">
                    <col>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="col">검색</th>
                    <td>
                        <select id="searchType" style="width:162px;">
                            <option value="">전체</option>
                            <option value="mentor">멘토명</option>
                            <option value="job">직업명</option>
                            <option value="tag">태그</option>
                        </select>
                        <input type="text" id="searchKey" name="searchKey" value="" class="text"/>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="btn-group-c">
                <a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색"  onclick="searchMentor(1);" /></a>
            </div>
            <div id="popBoardArea" class="board-area">
                <div class="board-bot">
                    <p class="total-num fl-l" id="totalCount">총 <strong>0</strong> 건</p>
                    <ul>
                        <li><button type="button" class="btn-orange" onclick="addMentorInfo()"><span>선택</span></button></li>
                        <li><button type="button" class="btn-gray" onclick="closePopup()"><span>취소</span></button></li>
                    </ul>
                </div>
                <table id="mentorList">

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
        $("#_mentorInfoPopup").css("display","block");

        var colModels = [];
        colModels.push({label:'recomTargtNo', name:'recomTargtNo',index:'recomTargtNo', width:25, align:'center', sortable: false, hidden: true});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:50, align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'mbrNm',index:'mbrNm', width:50, align:'center', sortable: false});
        colModels.push({label:'예정수업일', name:'expectLectDay',index:'expectLectDay', width:85, align:'center', sortable: false});
        colModels.push({label:'최근종료수업일', name:'recentLectDay',index:'recentLectDay', align:'center', sortable: false});

        var data = [];

        $('.popup-area .board-bot .total-num').html('총 <strong>0</strong> 건');

        initJqGridTable('mentorList', 'popBoardArea', 500, colModels, true, 330);
        setDataJqGridTable('mentorList', 'popBoardArea', 500, data, '검색된 결과가 없습니다.',330);
    }

    $(document).ready(function(){

        $("#closePopup").click(function(){
            closePopup();
        });

        $("input[name='searchKey']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                searchMentor(1);
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
        debugger
        var data = rtnData.map(function(item, index) {

            item.gridRowId = item.recomTargtNo;
            item.recentLectDay = item.recentLectDay ? item.recentLectDay.toDay() : '';
            item.expectLectDay = item.expectLectDay ? item.expectLectDay.toDay() : '';

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
        setDataJqGridTable('mentorList', 'popBoardArea', 500, data, emptyText, 330);

        $('.loading').hide();
        $('.jqgrid-overlay').hide();
    }

    function searchMentor(curPage, recordCountPerPage){
        popup_searchFlag = 'search';

        var _param = jQuery.extend({'searchType':$("#searchType").val()
            ,'searchKey':$('#searchKey').val()
            ,'targtCd': recomTargtCd
        }, popup_dataSet.params);

        $('.loading').show();
        $('.jqgrid-overlay').show();

        $.ajax({
                    url: "${pageContext.request.contextPath}/web/front/ajax.searchMentorInfoList.do",
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
        $( "#mentorList" ).jqGrid('GridUnload');
        $("form").each(function() {
            this.reset();
        });
    }

    function addMentorInfo(){
        var gridObject = $( "#mentorList" );
        var data = gridObject.jqGrid('getGridParam', 'selarrrow');

        if(data.length == 0){
            alert('추가하고자 하는 멘토를 선택하세요.');
            return false;
        }
        var selectedMentors = [];

        data.forEach(function(val,index){
            var mentor = new Object();
            mentor.recomTargtNo = gridObject.jqGrid('getCell', val, 'recomTargtNo');
            mentor.recomTargtCd = recomTargtCd;
            selectedMentors.push(mentor);
        });

        ${param.callbackFunc}(selectedMentors);
        closePopup();
    }

</script>