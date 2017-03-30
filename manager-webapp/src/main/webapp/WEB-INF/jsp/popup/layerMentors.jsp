<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
        <p class="pop-title">멘토보기</p>
    </div>
    <div class="pop-cont-box">
        <div id="popBoardArea" class="board-area">
            <div class="board-top">
                <p class="total-num fl-l" id="totalCount">총 <strong>0</strong> 건</p>
            </div>
            <table id="mentorList">

            </table>
            <div class="board-bot">
                <ul>
                    <li><button type="button" class="btn-style02" onclick="closePopup()"><span>닫기</span></button></li>
                </ul>
            </div>
        </div>
    </div>
    <a href="javascript:void(0)" id="closePopup" class="btn-close-pop">닫기</a>
</div>
<script type="text/javascript">

    var popup_dataSet = {
        params: {
        }
    };

    var popup_searchFlag = 'load';

    function initailizePopup(jobNo){
        $('body').addClass('dim');
        $(".popup-area").css("display","");
        $("#_mentorInfoPopup").css("display","block");

        var colModels = [];
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'mbrNm',index:'mbrNm', width:85, align:'center', sortable: false});
        colModels.push({label:'예정수업일', name:'expectLectDay',index:'expectLectDay', width:85, align:'center', sortable: false});
        colModels.push({label:'최근종료수업일', name:'recentLectDay',index:'recentLectDay', width:85, align:'center', sortable: false});

        $('.popup-area .board-top .total-num').html('총 <strong>0</strong> 건');


        initJqGridTable('mentorList', 'popBoardArea', 500, colModels, false, 420);
        //setDataJqGridTable('mentorList', 'popBoardArea', 500, data, '검색된 결과가 없습니다.',420);

        searchMentor(jobNo);
    }

    $(document).ready(function(){

        $("#closePopup").click(function(){
            closePopup();
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

            item.gridRowId = item.recomTargtNo;
            item.recentLectDay = item.recentLectDay ? item.recentLectDay.toDay() : '';
            item.expectLectDay = item.expectLectDay ? item.expectLectDay.toDay() : '';

            return item;
        });

        if(rtnData != null && rtnData.length > 0) {
            $('.popup-area .board-top .total-num').html('총 <strong>' + rtnData.length +'</strong> 건');
        } else {
            $('.popup-area .board-top .total-num').html('총 <strong>0</strong> 건');
        }

        // grid data binding
        var emptyText = '';
        if(popup_searchFlag == 'load') {
            emptyText = '등록된 데이터가 없습니다.';
        } else {
            emptyText = '검색된 결과가 없습니다.';
        }
        setDataJqGridTable('mentorList', 'popBoardArea', 500, data, emptyText, 420);

        $('.loading').hide();
        $('.jqgrid-overlay').hide();
    }

    function searchMentor(jobNo){
        popup_searchFlag = 'search';

        var _param = jQuery.extend({'jobNo':jobNo
        }, popup_dataSet.params);

        $('.loading').show();
        $('.jqgrid-overlay').show();

        $.ajax({
                    url: "${pageContext.request.contextPath}/web/front/ajax.listMentorByJobNo.do",
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
    }

</script>