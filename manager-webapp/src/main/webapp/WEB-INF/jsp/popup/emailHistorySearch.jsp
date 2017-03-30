<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
    <p class="pop-title">메일 수신인 목록</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
                    <input type="hidden" name="currentPage" value="1"/>
                    <input type="hidden" name="countPerPage" value="10"/>
                    <input type="hidden" id="subMsgSer" name="subMsgSer"/>
                    <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>


        <div id="popBoardArea" class="board-area">
            <div id="popBoardArea" class="pop-board-area">
                <div class="board-bot">
                    <p class="bullet-gray fl-l">검색결과</p>
                    <ul>
                        <li><button type="button" class="btn-gray" onclick="closePopup()"><span>닫기</span></button></li>
                    </ul>
                </div>
                <table id="userList">
                </table>
            </div>

        </div>
        <div id="addrSearchPaging" class="board-area"></div>
    </div>
    <a href="javascript:void(0)"  onclick="closePopup()" class="btn-close-pop">닫기</a>
</div>

<script type="text/javascript">

    function goPage(msgSer){
        //jqGrid
        var colModels = [];
        colModels.push({label:'no', name:'rn',index:'rn', width:50, align:'center', sortable: false});
        colModels.push({label:'회원유형', name:'mbrCualfNm',index:'mbrCualfNm', width:90, align:'center', sortable: false, key: true});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:90, align:'center', sortable: false});
        colModels.push({label:'소속', name:'posCoNm',index:'posCoNm', width:80, align:'center', sortable: false});
        colModels.push({label:'이름', name:'username',index:'username', width:80, align:'center', sortable: false});
        colModels.push({label:'이메일', name:'mobile',index:'mobile', width:110, align:'center', sortable: false});
        initJqGridTable('userList', 'popBoardArea', 1300, colModels,  false, 310);

        var userSearch = {};
        userSearch.msgSer = msgSer;
        $("#subMsgSer").val(msgSer);
        $.ajax({
            url: '${pageContext.request.contextPath}/user/manager/ajax.searchHistoryUser.do',
            data : JSON.stringify(userSearch),
            contentType: "application/json",
            dataType: 'json',
            method:"post",
            cache: false,
            success: function(data) {
            var rowCnt = 0;

                var emptyText = "조건에 맞는 회원이 존재하지 않습니다.";

                var data2 = new Array();
                var smsData = data.map(function(item, index) {
                    if(item.mbrNo != null){
                        item.gridRowId = item.mbrNo;
                        item.mobile = item.sendTargtInfo;
                        item.rn = rowCnt+1;
                        data2[rowCnt] = item;
                        rowCnt++;
                    }else{
                        item.gridRowId = item.sendTargtMbrNo;
                        item.mobile = item.sendTargtInfo;
                        item.rn = rowCnt+1;
                        item.mbrCualfNm = "직접입력";
                        item.sidoNm = "직접입력";
                        item.posCoNm = "직접입력";
                        item.username = "직접입력";
                        data2[rowCnt] = item;
                        rowCnt++;
                    }
                    return item;

                });


                setDataJqGridTable('userList', 'popBoardArea', 1300, data2, emptyText, 310);

                var idArry = $("#userList").jqGrid('getDataIDs'); //grid의 id 값을 배열로 가져옴


                for(var i=0 ; i < idArry.length; i++){
                    var ret =  $("#userList").getRowData(idArry[i]); // 해당 id의 row 데이터를 가져옴

                    if("1" != ret.column1){ //해당 row의 특정 컬럼 값이 1이 아니면 multiselect checkbox disabled 처리
                      //해당 row의 checkbox disabled 처리 "jqg_list_" 이 부분은 grid에서 자동 생성
                      $("#jqg_list_"+idArry[i]).attr("disabled", true);
                    }
                }

            }
        });
    }
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    $(document).ready(function(){

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".popup-area").css("display","none");
                $('body').removeClass('dim');
            }
        });
 });

function closePopup(){
     $(".popup-area").css("display","none");
     $('body').removeClass('dim');
 }


function donePop(){
    var selUser =  $('#userList').jqGrid('getGridParam','selarrrow');
    if(selUser.length < 1){
        alert("발송할 수신자를 선택해주세요.");
        return false;
    }
    inputs = "";
    if(selUser.length > 0){
        for(var i=0;i<selUser.length;i++){
            inputs+="<input type='hidden' name='sendTargtSers' value='"+ selUser[i] +"' />";
        }
    }
    var subMsgSer = $("#subMsgSer").val();
    inputs+="<input type='hidden' name='msgSer' value='"+ subMsgSer +"' />"
    inputs+="<input type='hidden' name='_csrf' value='" + mentor.csrf + "' />";
    $('#frm').empty().append(inputs);
    $("#frm").submit();
}

</script>
