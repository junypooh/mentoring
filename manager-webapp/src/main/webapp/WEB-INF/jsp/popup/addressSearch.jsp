<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
    <p class="pop-title">주소검색</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
                    <input type="hidden" name="currentPage" value="1"/>
                    <input type="hidden" name="countPerPage" value="20"/>
                    <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>
        <p class="bullet-gray">주소목록</p>
        <table class="tbl-style tbl-message">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">검색어</th>
                    <td>
                        <input type="text" name="keyword" value="" class="text"/>
                    </td>
                </tr>
            </tbody>
        </table>
       <p class="pt5">※ 도로명, 건물명, 지번에 대한 통합 검색이 가능합니다. (예, 반포대로 58, 국립중앙박물관, 삼성동 25)</p>
        <div class="btn-group-c">
            <a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색"  onclick="goPage(1);" /></a>
        </div>
        <div id="popBoardArea" class="board-area">
            <div class="board-bot">
                <p class="bullet-gray fl-l">검색결과</p>
            </div>
            <table id="lectureList">

            </table>
        </div>
        <div id="addrSearchPaging" class="board-area"></div>
    </div>
    <a href="javascript:void(0)" id="closePopup" class="btn-close-pop">닫기</a>
</div>
<script type="text/jsx;harmony=true">
    mentor.addrPageNavi = React.render(
        <PageNavi  pageFunc={getAddr} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
        document.getElementById('addrSearchPaging')
    );
</script>
<script type="text/javascript">

    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    $(document).ready(function(){

        $("#closePopup").click(function(){
            $(".popup-area").css("display","none");
            $('body').removeClass('dim');
            $("input[name=countPerPage]").val("20");
        });

        $("input[name='keyword']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                goPage(1);
            }
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".popup-area").css("display","none");
                $('body').removeClass('dim');
            }
        });
    });


    function clickOk(obj){
        var element = {};
        element.ROADADDR =  $("#lectureList tr[id="+obj+"] >td:eq(1)").text();
        element.JIBUNADDR = $("#lectureList tr[id="+obj+"] >td:eq(2)").text();
        element.ZIPNO = $("#lectureList tr[id="+obj+"] >td:eq(0)").text();

        ${param.callbackFunc}(element);
        $("#closePopup").click();
    }

    function getAddr(curPage, recordCountPerPage){
        //jqGrid
        var colModels = [];
        colModels.push({label:'우편번호', name:'ZIPNO',index:'ZIPNO', width:80, align:'center', sortable: false});
        colModels.push({label:'도로명주소', name:'ROADADDR',index:'ROADADDR', width:190, align:'center', sortable: false, key: true});
        colModels.push({label:'지번주소', name:'JIBUNADDR',index:'JIBUNADDR', width:190, align:'center', sortable: false});
        colModels.push({label:'선택', name:'lectureList',index:'lectureList', width:80, align:'center', sortable: false});
        initJqGridTable('lectureList', 'popBoardArea', 1300, colModels,  false, 310);
        //resizeJqGridWidth('lectureList', 'popBoardArea', 570);

        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
            $("input[name=countPerPage]").val(recordCountPerPage);
        }


        $.ajax({
             url :"https://www.juso.go.kr/addrlink/addrLinkApiJsonp.do"
            ,type:"post"
            ,data:$("#form").serialize()
            ,dataType:"jsonp"
            ,crossDomain:true
            ,success:function(xmlStr){
             if(xmlStr != null){
                var xmlData = xmlStr.returnXml;

                var common = $(xmlData).find("common");
                var totalcount = common.find("totalcount").text();
                var currentpage = common.find("currentpage").text();
                var countperpage = common.find("countperpage").text();

                var errCode = $(xmlData).find("errorCode").text();
                var errDesc = $(xmlData).find("errorMessage").text();
                if(errCode != "0"){
                    //alert(errCode+"="+errDesc);
                    emptyText = errDesc;
                    xmlData = "";
                    setDataJqGridTable('lectureList', 'popBoardArea', 1300, xmlData, emptyText, 310);
                }else{
                    data = makeData(xmlData);

                    var xmlData = data.map(function(item, index) {
                        var addrStr = '<button type="button" class="btn-style01" onClick="clickOk('+index+');"><span>선택</span></button>';
                        item.lectureList = addrStr;
                        return item;
                    });

                    emptyText = '검색된 결과가 없습니다.';

                    setDataJqGridTable('lectureList', 'popBoardArea', 1300, xmlData, emptyText, 310);

                    dataSet.params.totalRecordCount = totalcount;
                    mentor.addrPageNavi.setData(dataSet.params);
                    //mentor.addrPageNavi.setData({'totalRecordCount':totalcount,'currentPageNo':currentpage,'recordCountPerPage':countperpage,'pageSize':10});

                    }

                }
            }
        });
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