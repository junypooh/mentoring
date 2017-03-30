<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<div class="popup-area" id="${param.popupId}" style="display:;">
    <div class="pop-title-box">
    <p class="pop-title">스튜디오 찾기</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
                    <input type="hidden" name="currentPage" value="1"/>
                    <input type="hidden" name="countPerPage" value="10"/>
                    <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>
        <p class="bullet-gray">스튜디오목록</p>
        <table class="tbl-style tbl-message">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">검색어</th>
                    <td>
                        <input type="text" id="stdoNm" name="stdoNm" value="" class="text"/>
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
            <table id="resultStudio" >

            </table>
        </div>
    </div>
    <a href="#" class="btn-close-pop">확인</a>
    <a href="#" class="btn-close-pop">취소</a>
</div>
<script type="text/jsx;harmony=true">
    mentor.addrPageNavi = React.render(
        <PageNavi  pageFunc={goPage} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
        document.getElementById('addrSearchPaging')
    );
</script>
<script type="text/javascript">

    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    $(document).ready(function(){

        $("input[name='keyword']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                goPage(1);
            }
        });

        //jqGrid
        var colModels = [];
        colModels.push({label:'스튜디오', name:'stdoNm',index:'stdoNm', width:'25%', align:'center', sortable: false});
        colModels.push({label:'부가정보', name:'florNm',index:'florNm', width:'25%', align:'center', sortable: false, key: false});
        colModels.push({label:'주소', name:'locaAddr',index:'locaAddr', width:'25%', align:'center', sortable: false});
        colModels.push({label:'내부', name:'indrYnNm',index:'indrYnNm', width:'10%', align:'center', sortable: false});
        colModels.push({label:'선택', name:'stdoNo',index:'stdoNo', width:'10%', align:'center', sortable: false});

        initJqGridTable('resultStudio', colModels, 5, false);
        resizeJqGridWidth('resultStudio', 'popBoardArea', '560px');

        var wHeight = 330;
        var wWidth = 590;
        $("#resultStudio").jqGrid('setGridWidth',wWidth);
        $("#resultStudio").jqGrid('setGridHeight',wHeight);

    });

    function clickOk(obj){
        var element = {};
        element.ROADADDR =  $("#lectureList tr[id="+obj+"] >td:eq(1)").text();
        element.JIBUNADDR = $("#lectureList tr[id="+obj+"] >td:eq(2)").text();
        element.ZIPNO = $("#lectureList tr[id="+obj+"] >td:eq(3)").text();

        ${param.callbackFunc}(element);
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
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listStudio.do",
                data : $.param({"sidoCd":$("#sidoCd option:selected").val(), "stdoNm":$("#stdoNm").val()}, true),
                success: function(rtnData) {
                    //$(".search-result.total").find(".result").empty();
                    //$("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo($(".search-result.total").find(".result"));

                    //$("#resultStudio").empty();
                    //$("#studioList").tmpl(rtnData).appendTo("#resultStudio");
                    var rtnData = rtnData.map(function(item, index) {
                        var stdoNo = '<button type="button" onClick="clickOk('+item.stdoNo+');">선택</button>';
                        item.stdoNo = stdoNo;
                        return item;
                    });
                    setDataJqGridTable('resultStudio', rtnData);



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

        //취소버튼 클릭
        $("#aCancel").click(function(){
            window.close();
        });

        $("#aSearch").click();
    });
</script>