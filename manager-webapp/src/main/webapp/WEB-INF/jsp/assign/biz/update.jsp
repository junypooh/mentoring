<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="kr.or.career.mentor.domain.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="schNm" property="principal.schNm" />
    <security:authentication var="clasNm" property="principal.clasNm" />
    <security:authentication var="mbrClassNm" property="principal.mbrClassNm" />
    <security:authentication var="mbrpropicInfos" property="principal.mbrpropicInfos" />
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />

</security:authorize>
<%
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
User user = new User();
if(authentication.getPrincipal() instanceof User) {
  user = (User) authentication.getPrincipal();
}
%>
<div class="cont">
    <div class="title-bar">
        <h2>배정사업관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>배정관리</li>
            <li>배정사업관리</li>
        </ul>
    </div>

    <div class="board-area">
        <table class="tbl-style tbl-mento-modify">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">배정사업${mbrCualfCd}</th>
                    <td id="grpNm">
                    </td>

                </tr>
                <tr>
                    <th scope="col" class="ta-l">주관기관</th>
                    <td id="coNm">
                    </td>
                </tr>

                <tr>
                    <th scope="col" class="ta-l">배정기간</th>
                    <td id="clasDay">
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">배정횟수</th>
                    <td id="clasApplCnt">
                    </td>
                </tr>
                <c:choose>
                <c:when test="${mbrCualfCd ne code['CD100204_101500_기관담당자'] }">
                <tr>
                    <th scope="col" class="ta-l">수업 신청 기기</th>
                    <td><input id="maxApplCnt" name="maxApplCnt" class="numberOnly" maxlength="3" style="text-align:right;width:50px;"/> 대</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">참관 신청 기기</th>
                    <td><input id="maxObsvCnt" name="maxObsvCnt" class="numberOnly" maxlength="3" style="text-align:right;width:50px;"/> 대</td>
                </tr>
                </c:when>
                <c:otherwise>
                <input type="hidden" id="maxApplCnt" name="maxApplCnt" />
                <input type="hidden" id="maxObsvCnt" name="maxObsvCnt" />
                 <tr>
                    <th scope="col" class="ta-l">수업 신청 기기</th>
                    <td id="maxApplCntText">
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">참관 신청 기기</th>
                    <td id="maxObsvCntText">
                    </td>
                </tr>
                </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num">총 <strong>00</strong> 건</p>
            <ul>
                <li>
                     <button type="button" class="btn-orange" id="schoolPopup"><span>추가</span></button>
                </li>
                <li>
                     <button type="button" class="btn-gray" onclick="delRow();"><span>삭제</span></button>
                </li>
            </ul>
        </div>


        <table id="boardTable2"></table>
        <form id="assignSubmit" name="assignSubmit" method="post">
        <input type="hidden" id="grpNo" name="grpNo" value="${param.setTargtNo}" />
        <input type="hidden" id="setSer" name="setSer" />
        <input type="hidden" name="schChgClassCd" value="101712"/>
        </form>
        <div id="paging"></div>
		<div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" id="assignSubmitButton"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" onclick="location.href='view.do?setTargtNo=${param.setTargtNo}'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>


<div class="page-loader" style="display:none;z-index:9999">
    <img src="${pageContext.request.contextPath}/images/img_page_loader.gif" alt="페이지 로딩 이미지">
</div>

<form id='schRpsForm' method='POST'>
</form>
<form id='frm' method='POST'>
</form>
<c:import url="/popup/schoolSearch.do">
  <c:param name="popupId" value="_schoolPopup" />
  <c:param name="callbackFunc" value="callbackSelected" />
  <c:param name="grpNo" value="${param.setTargtNo}" />
</c:import>

<script type="text/javascript">
    var index = 0; // 변경되는 잔여횟수 카운트
    var schOrdNo = [];
    var elements = [];
    var totalCnt = 0;
    var searchFlag = 'load';
    var totalCnt = 0;
    var clasTotalCnt = 0; // 총 배정 횟수
    var clasApplTotalCnt = 0; // 총 사용 횟수
    var clasPermTotalCnt = 0; // 총 잔여 횟수

     $(document).ready(function() {
        $.ajax({
            url: "${pageContext.request.contextPath}/assign/biz/ajax.listAssignGroup.do",
            data : {'setTargtNo':'${param.setTargtNo}'},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                if(rtnData != null && rtnData.length > 0){
                    $("#grpNm").text(rtnData[0].bizGrpInfo.grpNm);
                    $("#grpNo").val(rtnData[0].bizGrpInfo.grpNo);
                    $('#coNm').text(rtnData[0].coInfo.coNm == null ? '소속없음' : rtnData[0].coInfo.coNm);
                    $("#clasCnt").text(toCurrency(rtnData[0].lectApplCnt.clasApplCnt));
                    $("#clasApplCnt").text(toCurrency(rtnData[0].clasCnt));
                    $("#clasDay").text("{0} ~ {1}".format(mentor.parseDate(rtnData[0].clasStartDay).format('yyyy.MM.dd'),mentor.parseDate(rtnData[0].clasEndDay).format('yyyy.MM.dd')));
                    $("#setSer").val(rtnData[0].bizGrpInfo.setSer);
                    $("#maxApplCnt").val(rtnData[0].bizGrpInfo.maxApplCnt);
                    $("#maxObsvCnt").val(rtnData[0].bizGrpInfo.maxObsvCnt);
                    $("#maxApplCntText").text(rtnData[0].bizGrpInfo.maxApplCnt);
                    $("#maxObsvCntText").text(rtnData[0].bizGrpInfo.maxObsvCnt);


                }else{
                    location.href = "assignGroup.do";
                }
            }
        });




    });

    $(document).ready(function() {

         $('#assignSubmitButton').click(function(e) {

            $("body").addClass("dim");
            $(".page-loader").show();

            var input = new Array();
            var selSchool =  $('#boardTable2').jqGrid('getDataIDs');

            var inputs = "";
            var maxApplCnt = $("#maxApplCnt").val();
            var maxObsvCnt = $("#maxObsvCnt").val();
            inputs+="<input type='hidden' name='maxApplCnt' value='"+ maxApplCnt +"' />";
            inputs+="<input type='hidden' name='maxObsvCnt' value='"+ maxObsvCnt +"' />";
            $('#assignSubmit').append(inputs);




           /* selSchool.map(function(item, index) {
                input[index] = document.createElement("input");
                $(input[index]).attr("type","hidden");
                $(input[index]).attr('name',"listSchInfo["+index+"].schNo");
                $(input[index]).attr("value",item);
                $('#assignSubmit').append(input[index]);
            });
            */


            $.ajax({
                url: "${pageContext.request.contextPath}/assign/biz/ajax.saveAssignLectAppl.do",
                data : $("#assignSubmit").serialize(),
                dataType: 'json',
                method:"post",
                success: function(rtnData) {
                    alert("저장되었습니다.");
                    $("body").removeClass("dim");
                    $(".page-loader").hide();
                    location.href = "view.do?setTargtNo=${param.setTargtNo}";

                }
            });
        });

        loadData();

        $("#schoolPopup").click(function(){
            $('body').addClass('dim');
            $('.popup-area').css({'display': 'block'});
            $("#aSearch").click();
            emptySchoolGridSet();
        });
    });

    function loadData(){
        //jqGrid setting
        var colModels = [];
        colModels.push({label:'학교급', name:'schClassNm', index:'schClassNm', width:30, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm', index:'sidoNm', width:40, sortable: false});
        colModels.push({label:'시군구', name:'sgguNm', index:'sgguNm', width:40, sortable: false});
        colModels.push({label:'학교', name:'schNm', index:'schNm', width:70, sortable: false});
        colModels.push({label:'사용횟수', name:'clasApplCnt', index:'clasApplCnt', width:30, align:'center',sortable: false});
        colModels.push({label:'잔여횟수', name:'clasPermCnt', index:'clasPermCnt', width:30, align:'center', sortable: false});


        initJqGridTable('boardTable2', 'boardArea', 1300, colModels, true, "", {footerrow:true,userDataOnFooter:true});
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/assign/biz/ajax.listAssignSchool.do",
            data : {'grpNo':'${param.setTargtNo}'},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                    totalCnt = 0;
                    clasTotalCnt = 0;
                    clasApplTotalCnt = 0;
                    clasPermTotalCnt = 0;
                    assignData = rtnData.map(function(item, index) {
                    item.gridRowId = item.schNo;
                    schOrdNo.push(item.schNo); // 기존 배정사업 학교 목록
                    // 회원유형 설정
                    var schClassNm = '';
                    if(item.schClassCd == '${codeConstants["CD100494_100495_초등학교"]}') {
                        schClassNm = '초';
                    } else if(item.schClassCd == '${codeConstants["CD100494_100496_중학교"]}') {
                        schClassNm = '중';
                    } else if(item.schClassCd == '${codeConstants["CD100494_100497_고등학교"]}') {
                        schClassNm = '고';
                    } else if(item.schClassCd == '${codeConstants["CD100494_101736_기타"]}') {
                        schClassNm = '기타';
                    }
                    item.schClassNm = schClassNm;

                    if(item.clasApplCnt == 0 && item.clasPermCnt == 0 && item.clasCnt != 0){
                        item.clasPermCnt =  item.clasCnt;
                    }

                    clasApplTotalCnt += Number(item.clasApplCnt);
                    clasPermTotalCnt += Number(item.clasPermCnt);

                    item.clasPermCnt = '<input type="text" id="clasPermCnt" name="listSchInfo['+index+'].clasPermCnt" maxlength="3" onkeydown="return showKeyCode(event)" class="text" onchange="myFunction(this)"  value="'+item.clasPermCnt+'">';

                    return item;
                });
                // grid data binding

                var applSum =  $("#boardTable2").jqGrid('getCol','clasApplCnt',false,'sum');
                var permSum =  $("#boardTable2").jqGrid('getCol','clasPermCnt',false,'sum');
                clasTotalCnt = clasApplTotalCnt + clasPermTotalCnt;

                var emptyText = '추가된 학교목록이 없습니다.';

                setDataJqGridTable('boardTable2', 'boardArea', 1300, assignData, emptyText);

                var selSchool =  $('#boardTable2').jqGrid('getDataIDs');
                if(selSchool.length > 20){
                    $("#boardTable2").jqGrid('setGridHeight','649');
                    resizeJqGridWidth('boardTable2', 'boardArea', 500);
                }

                $("#boardTable2").jqGrid('footerData','set',{schNm:'<p style="text-align:center">총 배정횟수(<span class="red-txt" id="clasTotalCnt">'+clasTotalCnt+'</span>)</p>',clasApplCnt: clasApplTotalCnt, clasPermCnt:'<span class="red-txt" id="clasPermTotalCnt">'+clasPermTotalCnt+'</span>'});

                footerColspan();
                totalCntTxt();

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    function callbackSelected(schInfos){
        closePop();

        var send = false;
        var inputs = "";
        var schCnt = 0;
        $.each(schInfos, function(idx){
            // 중복 제거
            var selSchool =  $('#boardTable2').jqGrid('getRowData', schInfos[idx]);
            if(selSchool.schNm == null) {
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].schNo".format(schCnt) + "' value='"+ schInfos[idx] +"' />";
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].schMbrCualfCd".format(schCnt) + "' value='101699' />";
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].cualfRegStatCd".format(schCnt) + "' value='101702' />";
                inputs+="<input type='hidden' name='" + "listSchInfo[{0}].cualfRegStatCd".format(schCnt) + "' value='101702' />";
                send = true;
                schCnt++;
            }
        });
        inputs +="<input type='hidden' name='grpNo' value='${param.setTargtNo}' />";
        inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";
        inputs +="<input type='hidden' name='setSer' value='"+$("#setSer").val()+"'/>";
        inputs +="<input type='hidden' name='schChgClassCd' value='101710'/>";
        inputs +="<input type='hidden' name='clasPermCnt' value='"+$("#clasApplCnt").text()+"'/>";

        $('#schRpsForm').empty().append(inputs);
        if(send) {
            $("#schRpsForm").ajaxForm({
                url : "${pageContext.request.contextPath}/assign/biz/ajax.insertAssignSchool.do",
                dataType: 'text',
                success:function(data, status){
                    loadData();
                }
            }).submit();
        }


    }

    function footerColspan(){
        var $footRow = $("#boardTable2").closest(".ui-jqgrid-bdiv").next(".ui-jqgrid-sdiv").find(".footrow");

        var $name = $footRow.find('>td[aria-describedby="boardTable_rn"]'),
        $invdate = $footRow.find('>td[aria-describedby="list_invdate"]'),
        width2 = $name.width() + $invdate.outerWidth();
        $invdate.css("display", "none");

        $footRow.find('>td[aria-describedby="boardTable2_cb"]').css("border-right-color", "transparent");
        $footRow.find('>td[aria-describedby="boardTable2_schClassNm"]').css("border-right-color", "transparent");
        $footRow.find('>td[aria-describedby="boardTable2_sidoNm"]').css("border-right-color", "transparent");
        $footRow.find('>td[aria-describedby="boardTable2_sgguNm"]').css("border-right-color", "transparent");

    }

    function totalCntTxt(){
        var selSchool =  $('#boardTable2').jqGrid('getDataIDs');
        $('.board-top .total-num').html('총 <strong>' + selSchool.length +'</strong> 건');
    }

    function delRow(){
        var delChk = true;
        var inputs = "";
        var selSchool =  $('#boardTable2').jqGrid('getGridParam','selarrrow');

        if(selSchool.length == 0 ){
            alert("선택된 학교가 없습니다.");
            return;
        }

        $.each(selSchool, function(idx){
            var rowData = $("#boardTable2").getRowData(selSchool[idx]);
            if(rowData.clasApplCnt > 0){
                delChk = false;
            }
            inputs+="<input type='hidden' name='" + "bizGrpInfo.listSchInfo[{0}].schNo".format(idx) + "' value='"+ selSchool[idx] +"' />";
        });

        if(delChk == false){
            alert('사용 이력이 있으므로 삭제할 수 없습니다.');
            return false;
        }


        inputs +="<input type='hidden' name='bizGrpInfo.grpNo' value='${param.setTargtNo}' />";
        inputs +="<input type='hidden' name='_csrf' value='${_csrf.token}'/>";
        inputs +="<input type='hidden' name='bizGrpInfo.setSer' value='"+$("#setSer").val()+"'/>";
        inputs +="<input type='hidden' name='bizGrpInfo.schChgClassCd' value='101711'/>";
        inputs +="<input type='hidden' name='bizGrpInfo.clasPermCnt' value='"+$("#clasApplCnt").text()+"'/>";

        $('#frm').empty().append(inputs);

        $("#frm").ajaxForm({
            url: "${pageContext.request.contextPath}/assign/biz/ajax.deleteAssignSchool.do",
            dataType: 'text',
            success:function(data, status){
                alert("삭제 되었습니다.");
                loadData();
            }
        }).submit();
    }

    function myFunction(num){
        var inputs = "";
        var schNo = $("input[name='"+num.name+"']").parent().parent().attr("id");
        inputs+="<input type='hidden' name='listSchInfo["+index+"].clasPermCnt' value='"+ num.value +"' />";
        inputs+="<input type='hidden' name='listSchInfo["+index+"].schNo' value='"+ schNo +"' />";
        $('#assignSubmit').append(inputs);
        index++;

        var clasPermCnt = 0;
        $("input[class=text]").each(function (obj) {
            if($(this).val() != ""){
                clasPermCnt += Number($(this).val());
            }
        });

        clasTotalCnt = clasPermCnt + clasApplTotalCnt;
        $("#clasTotalCnt").text(clasTotalCnt);
        $("#clasPermTotalCnt").text(clasPermCnt);


    }


    function getModifiedRows() {
        debugger;
        var temp= $("#boardTable2").getChangedCells('all') // Return Rows
        var myGrid = $('#boardTable2'),
            selRowId = myGrid.jqGrid ('getGridParam', 'selrow'),
            celValue = myGrid.jqGrid ('getCell', selRowId, 'columnName');
        var allRowsInGrid = $('#boardTable2').jqGrid('getRowData');

        for(j=0; j< allRowsInGrid.length;j++)
        {
            if( allRowsInGrid[j]['unitStatus'] == 'Draft')
            {
                var rowId = allRowsInGrid[j]['gridRowId'];
                $('#boardTable2').addClass("dirty-cell");
                $("#boardTable2").jqGrid("setCell", rowId ,'pricePSF' ,'', "dirty-cell");
            }
        }

        var retRows = $('#boardTable2').getChangedCells('all');
        var retCol = $('#boardTable2').getChangedCells('dirty');
        var retCol = $('#boardTable2').getChangedCells('all');
        var savedrow  = $("#mygrid").getGridParam('savedRow');
        var entireGrid = $("#boardTable2").jqGrid('getGridParam','colNames');

        if(retCol != '' && retRows != '')
        {
            alert(retCol);
            for(i=0; i< retCol.length;i++)
            {
                var obj = retCol[i];
                obj['row_Index']= retRows[i]['row_Index'];
                obj['unitStatus']= retRows[i]['unitStatus'];
                obj['pricePSF']= retRows[i]['pricePSF'];
                alert(retRows[i]['unitStatus']);
                if(retRows[i]['unitStatus'] == 'New')
                {
                    retCol[i] = retRows[i];
                }
            }
            var modColData = JSON.stringify(retCol);
            var modRows = JSON.stringify(retRows);
            document.getElementById("getGridData").value = modRows;
            document.getElementById("getModColData").value = modColData;
        }
    }

    function showKeyCode(event) {
        event = event || window.event;
        var keyID = (event.which) ? event.which : event.keyCode;
        if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) )
        {
            return;
        }
        else
        {
            return false;
        }
    }
</script>
