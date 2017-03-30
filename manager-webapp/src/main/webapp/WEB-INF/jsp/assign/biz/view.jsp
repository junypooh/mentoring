<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="kr.or.career.mentor.domain.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
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
        <form id="frm">
            <input type="hidden" name="grpNm" value="${param.grpNm}" />
            <input type="hidden" name="grpState" value="${param.grpState}" />
            <input type="hidden" name="clasStartDay" value="${param.clasStartDay}" />
            <input type="hidden" name="clasEndDay" value="${param.clasEndDay}" />
            <input type="hidden" name="coNm" value="${param.coNm}" />
        </form>
        <table class="tbl-style tbl-mento-modify">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">배정사업</th>
                    <td id="grpNm">
                    </td>
                    <th scope="col" class="ta-l">상태</th>
                    <td id="grpYn">
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">주관기관</th>
                    <td id="coNm">
                    </td>
                    <th scope="col" class="ta-l">배정기간</th>
                    <td id="clasDay">
                    </td>
                </tr>

                <tr>
                    <th scope="col" class="ta-l">배정횟수</th>
                    <td id="clasApplCnt">
                    </td>
                    <th scope="col" class="ta-l">수업 신청 기기</th>
                    <td id="maxApplCnt">
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">학교수</th>
                    <td id="clasCnt">
                    </td>
                    <th scope="col" class="ta-l">참관 신청 기기</th>
                    <td id="maxObsvCnt">
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">등록일</th>
                    <td id="regDtm">
                    </td>
                    <th scope="col" class="ta-l">등록자</th>
                    <td id="regNm">
                    </td>
                </tr>
                <c:if test="${mbrCualfCd ne code['CD100204_101500_기관담당자'] }">
                <tr>
                    <th scope="col" class="ta-l">수정이력</th>
                    <td colspan="3" id="hist">
                    </td>
                </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <div class="board-area" id="boardArea">
        <div class="board-top">
            <p class="total-num"> 학교 목록</p>
            <ul>
                <!--<li><a href="javascript:void(0)" onclick="excelDownLoad()"><img src="${pageContext.request.contextPath}/images/btn_excel_down.gif" alt="엑셀 다운로드" /></a></li>-->
            </ul>
        </div>
        <table id="boardTable"></table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="location.href='update.do?setTargtNo=${param.setTargtNo}'"><span>수정</span></button></li>
                <li><button type="button" class="btn-gray" onclick="goList();"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
</div>


<script type="text/javascript">

    $(document).ready(function() {


        $.ajax({
            url: "${pageContext.request.contextPath}/assign/biz/ajax.listAssignGroup.do",
            data : {'setTargtNo':'${param.setTargtNo}'},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                if(rtnData != null && rtnData.length > 0){
                    $("#grpNm").text(rtnData[0].bizGrpInfo.grpNm);
                    $("#grpYn").text(rtnData[0].bizGrpInfo.grpYn);
                    $("#grpNo").val(rtnData[0].bizGrpInfo.grpNo);
                    $('#coNm').text(rtnData[0].coInfo.coNm == null ? '소속없음' : rtnData[0].coInfo.coNm);
                    $("#clasCnt").text(toCurrency(rtnData[0].lectApplCnt.clasApplCnt));
                    $("#clasApplCnt").text(toCurrency(rtnData[0].clasCnt));
                    $("#clasDay").text("{0} ~ {1}".format(mentor.parseDate(rtnData[0].clasStartDay).format('yyyy.MM.dd'),mentor.parseDate(rtnData[0].clasEndDay).format('yyyy.MM.dd')));
                    $('#totClasCnt').text(toCurrency(rtnData[0].lectApplCnt.clasApplCnt * rtnData[0].clasCnt) + ' (사용횟수: ' +  toCurrency(rtnData[0].clasEmpCnt) + ')');
                    $('#regNm').text(rtnData[0].nm + '(' + (rtnData[0].coInfo.coNm == null ? '소속없음' : rtnData[0].coInfo.coNm) + ')');
                    $('#regDtm').text(new Date(rtnData[0].regDtm).format('yyyy.MM.dd'));
                    $("#maxApplCnt").text(rtnData[0].bizGrpInfo.maxApplCnt);
                    $("#maxObsvCnt").text(rtnData[0].bizGrpInfo.maxObsvCnt);

                    $.ajax({
                        url: "${pageContext.request.contextPath}/assign/biz/ajax.listAssignGroupHist.do",
                        data : {'grpNo':'${param.setTargtNo}'},
                        contentType: "application/json",
                        dataType: 'json',
                        success: function(rtnData) {
                        var hist ="";
                            if(rtnData != null && rtnData.length > 0){
                                for(var i = 0;i<rtnData.length;i++){
                                    hist += new Date(rtnData[i].regDtm).format('yyyy.MM.dd hh:mm') + " / " +  rtnData[i].nm;
                                    if(i < rtnData.length){
                                        hist += "<br/>";
                                    }
                                }
                                $("#hist").html(hist);
                            }
                        }
                    });
                }else{
                    location.href = "assignGroup.do";
                }
            }
        });


        loadData();
    });



    function loadData(){
        //jqGrid setting
        var colModels = [];
        colModels.push({label:'번호', name:'rn', index:'rn', width:25, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassNm', index:'schClassNm', width:30, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm', index:'sidoNm', width:40, sortable: false});
        colModels.push({label:'시군구', name:'sgguNm', index:'sgguNm', width:40, sortable: false});
        colModels.push({label:'학교', name:'schNm', index:'schNm', width:70, sortable: false});
        colModels.push({label:'사용횟수', name:'clasApplCnt', index:'clasApplCnt', width:30, align:'center',sortable: false});
        colModels.push({label:'잔여횟수', name:'clasPermCnt', index:'clasPermCnt', width:30, align:'center', sortable: false});


        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false, "", {footerrow:true,userDataOnFooter:true});
        //jqGrid setting
        $('.jqgrid-overlay').show();
        $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/assign/biz/ajax.listAssignSchool.do",
            data : {'grpNo':'${param.setTargtNo}'},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {

                var totalCnt = 0;
                var clasTotalCnt = 0;
                var clasApplTotalCnt = 0;
                var clasPermTotalCnt = 0;
                var assignData = rtnData.map(function(item, index) {
                    totalCount = rtnData[0].totalRecordCount;

                    item.rn = rtnData.length - item.rn + 1;

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

                    return item;
                });
                // grid data binding

                var applSum =  $("#boardTable").jqGrid('getCol','clasApplCnt',false,'sum');
                var permSum =  $("#boardTable").jqGrid('getCol','clasPermCnt',false,'sum');

                clasTotalCnt = clasApplTotalCnt + clasPermTotalCnt;




                var emptyText = '추가된 학교목록이 없습니다.';

                setDataJqGridTable('boardTable', 'boardArea', 1300, assignData, emptyText);

                var selSchool =  $('#boardTable').jqGrid('getDataIDs');
                if(selSchool.length > 20){
                    $("#boardTable").jqGrid('setGridHeight','649');
                    resizeJqGridWidth('boardTable', 'boardArea', 500);
                }

                $("#boardTable").jqGrid('footerData','set',{schNm:'<p style="text-align:center">총 배정횟수(<span class="red-txt">'+clasTotalCnt+'</span>)</p>',clasApplCnt: clasApplTotalCnt, clasPermCnt:clasPermTotalCnt});

                footerColspan();
                $('.jqgrid-overlay').hide();
                $('.loading').hide();
            }
        });
    }

    function footerColspan(){
        var $footRow = $("#boardTable").closest(".ui-jqgrid-bdiv").next(".ui-jqgrid-sdiv").find(".footrow");

        var $name = $footRow.find('>td[aria-describedby="boardTable_rn"]'),
        $invdate = $footRow.find('>td[aria-describedby="list_invdate"]'),
        width2 = $name.width() + $invdate.outerWidth();
        $invdate.css("display", "none");

        $footRow.find('>td[aria-describedby="boardTable_rn"]').css("border-right-color", "transparent");
        $footRow.find('>td[aria-describedby="boardTable_sidoNm"]').css("border-right-color", "transparent");
        $footRow.find('>td[aria-describedby="boardTable_schClassNm"]').css("border-right-color", "transparent");
        $footRow.find('>td[aria-describedby="boardTable_sgguNm"]').css("border-right-color", "transparent");

    }

function goList() {
    var qry = $('#frm').serialize();
    $(location).attr('href', mentor.contextpath+'/assign/biz/list.do?' + qry);
}
</script>
