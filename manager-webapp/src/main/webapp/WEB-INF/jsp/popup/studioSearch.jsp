<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="popup-area" id="studioPop" style="display:none;">
    <div class="pop-title-box">
    <p class="pop-title">소속 스튜디오</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
                    <input type="hidden" name="currentPage" value="1"/>
                    <input type="hidden" name="countPerPage" value="10"/>
                    <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>
                    <input type="hidden" name="coClassCd" value="${param.coClassCd}" />
        <p class="bullet-gray">스튜디오 검색</p>
        <table class="tbl-style tbl-message">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">소속기관</th>
                    <td>
                        <input type="text" name="posCoNm" id="posCoNm" value="${pearm.coClassCd}" class="text"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col">스튜디오</th>
                    <td>
                        <input type="text" name="stdoName" id="stdoName" value="" class="text"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="btn-group-c">
            <a href="#"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색" id="studioSearch"/></a>
        </div>
        <div id="popStudioBoardArea" class="board-area" >
            <div class="board-bot">
                <p class="bullet-gray fl-l">검색결과</p>
            </div>
            <table id="resultStudio" >

            </table>
        </div>
    </div>
    <a href="#" class="btn-close-pop">확인</a>
    <a href="#" onclick="closeStudioPop();" class="btn-close-pop">취소</a>
</div>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 20,
        }
    };
    $(document).ready(function(){
        $("input[name='keyword']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                goPage(1);
            }
        });
    });

    function clickOk2(obj){
        var element = {};
        element.stdoNo = $("input[name=stdoCd]:eq("+obj+")").val();
        element.stdoNm = $("#resultStudio tr[id="+obj+"] >td:eq(0)").text();
        ${param.callbackFunc}(element);

        /*
         받는부분
        function callbackSelected(mentors){
            $("#stdoNm").val(studio.stdoNm);
            $("#stdoNo").val(studio.stdoNo);
        }
        */
    }

    function goPage(curPage){
        $("input[name='currentPage']").val(curPage);
        getAddr(curPage);
    }
</script>
<script type="text/jsx;harmony=true">
    function makeData(xmlStr){
        var data = [];
        $(xmlStr).find("juso").each(function(){
            var item = {};

            $(this).children().each(function(){
                item[$(this).prop("tagName")] = $(this).text();
            });
            data.push(item);
        });
        return data;
    }

    function popupShow(){
        $(".popup-area").show();
    }
    function popupHide(){
        $(".popup-area").hide();
    }
</script>

<script type="text/javascript">
    $(document).ready(function() {

        //검색버튼 클릭
        $("#studioSearch").click(function(e){
             //jqGrid
            var colModels = [];
            colModels.push({label:'스튜디오', name:'stdoNm',index:'stdoNm', width:'157', align:'center', sortable: false});
            colModels.push({label:'주소', name:'locaAddr',index:'locaAddr', width:'189', align:'center', sortable: false});
            colModels.push({label:'소속기관', name:'posCoNm',index:'posCoNm', width:'137', align:'center', sortable: false});
            colModels.push({label:'선택', name:'stdoNo',index:'stdoNo', width:'68', align:'center', sortable: false});


            initJqGridTable('resultStudio', 'popStudioBoardArea', 589, colModels, false, 310);
           //resizeJqGridWidth('boardTable', 'boardArea', 500, 330);

           // var wHeight = 330;
           //var wWidth = 590;
           // $("#resultStudio").jqGrid('setGridWidth',wWidth);
           // $("#resultStudio").jqGrid('setGridHeight',wHeight);
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/ajax.listStudio.do",
                data : $.param({"posCoNm":$("#posCoNm").val(),
                "coClassCd":$("#coClassCd").val(),
                "stdoNm":$("#stdoName").val()}, true),
                contentType: "application/json",
                dataType: 'json',
                success: function(rtnData) {
                    //$(".search-result.total").find(".result").empty();
                    //$("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo($(".search-result.total").find(".result"));

                    //$("#resultStudio").empty();
                    //$("#studioList").tmpl(rtnData).appendTo("#resultStudio");
                    var rtnData = rtnData.map(function(item, index) {
                        var stdoNo = '<button type="button" class="btn-style01" onClick="clickOk2('+index+');"><span>선택</span></button>';
                        stdoNo += '<input type="hidden" name="stdoNm" value="'+item.stdoNm+'"/>';
                        stdoNo += '<input type="hidden" name="stdoCd" value="'+item.stdoNo+'"/>';
                        item.stdoNo = stdoNo;
                        return item;
                    });
                    var emptyText = '검색된 결과가 없습니다.';
                    setDataJqGridTable('resultStudio', 'popStudioBoardArea', 1300, rtnData, emptyText);

                }
            });


        });


    });
    /** 취소/닫기 버튼 클릭 */
    function closeStudioPop() {
        $('body').removeClass('dim');
        $('.popup-area').css({'display': 'none'});
    }
</script>