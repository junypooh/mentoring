<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="popup-area" id="corpoPop" style="display:none;">
    <div class="pop-title-box">
    <p class="pop-title">소속기관</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
                    <input type="hidden" name="currentPage" value="1"/>
                    <input type="hidden" name="countPerPage" value="10"/>
                    <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>
                    <input type="hidden" name="coClassCd" value="${param.coClassCd}" />
        <p class="bullet-gray">소속기관 검색</p>
        <table class="tbl-style tbl-message">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">법인/상호명</th>
                    <td>
                        <input type="text" name="coNm" id="_coNm" value="${pearm.coClassCd}" class="text"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col">사업자등록번호</th>
                    <td>
                        <input type="text" name="bizno" id="bizno" value="${pearm.coClassCd}" class="text"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="btn-group-c">
            <a href="#"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색" id="aSearch"/></a>
        </div>
        <div id="popBoardArea" class="board-area" >
            <div class="board-bot">
                <p class="bullet-gray fl-l">검색결과</p>
            </div>
            <table id="resultCorpo" >

            </table>
        </div>
    </div>
    <a href="#" class="btn-close-pop">확인</a>
    <a href="#" onclick="closeCorpoPop();" class="btn-close-pop">취소</a>
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

    function clickOk(obj){
        var element = {};
        element.coNo = $("input[name=coNo]:eq("+obj+")").val();
        element.coNm = $("#resultCorpo tr[id="+obj+"] >td:eq(0)").text();
        ${param.callbackFunc}(element);

        /*
         받는부분
        function callbackSelected(mentors){
            $("#posCoNm").val(mentors.coNm);
            $("#posCoNo").val(mentors.coMbrNo);
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
        $("#aSearch").click(function(e){
             //jqGrid
            var colModels = [];
            colModels.push({label:'법인/상호명', name:'coNm',index:'coNm', width:'167', align:'center', sortable: false});
            colModels.push({label:'담당자이름', name:'coMbrNm',index:'coMbrNm', width:'149', align:'center', sortable: false});
            colModels.push({label:'사업자 등록번호', name:'bizno',index:'bizno', width:'167', align:'center', sortable: false});
            colModels.push({label:'선택', name:'coNo',index:'coNo', width:'68', align:'center', sortable: false});


            initJqGridTable('resultCorpo', 'popBoardArea', 589, colModels, false, 310);
           //resizeJqGridWidth('boardTable', 'boardArea', 500, 330);

           // var wHeight = 330;
           //var wWidth = 590;
           // $("#resultCorpo").jqGrid('setGridWidth',wWidth);
           // $("#resultCorpo").jqGrid('setGridHeight',wHeight);

            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/ajax.listCorpo.do",
                data : $.param({"coNm":$("#_coNm").val(),
                "coClassCd":$("#coClassCd").val(),
                "bizno":$("#bizno").val()}, true),
                contentType: "application/json",
                dataType: 'json',
                success: function(rtnData) {
                    //$(".search-result.total").find(".result").empty();
                    //$("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo($(".search-result.total").find(".result"));

                    //$("#resultCorpo").empty();
                    //$("#studioList").tmpl(rtnData).appendTo("#resultCorpo");
                    var rtnData = rtnData.map(function(item, index) {
                        var coNo = '<button type="button" class="btn-style01" onClick="clickOk('+index+');"><span>선택</span></button>';
                        coNo += '<input type="hidden" name="coNm" value="'+item.coNm+'"/>';
                        coNo += '<input type="hidden" name="coNo" value="'+item.coNo+'"/>';
                        item.coNo = coNo;
                        return item;
                    });
                    var emptyText = '검색된 결과가 없습니다.';
                    setDataJqGridTable('resultCorpo', 'popBoardArea', 1300, rtnData, emptyText);

                }
            });
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();
            var labelSelector = $("input:radio:checked[name='stdoRadio']");

            if(labelSelector.length < 1){
                alert("선택된 스튜디오가 없습니다.");
                return false;
            }else{

            }
        });
        $("#aSearch").click();
    });
    /** 취소/닫기 버튼 클릭 */
    function closeCorpoPop() {
        $('body').removeClass('dim');
        $('.popup-area').css({'display': 'none'});
    }
</script>