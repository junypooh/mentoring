<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrCualfCd" property="principal.mbrCualfCd" />
</security:authorize>
<%
    String lectSer = request.getParameter("lectSer");
    String lectrMbrNo = request.getParameter("lectrMbrNo");
    String lectTypeCd = request.getParameter("lectTypeCd");
    String lectStatCd = request.getParameter("lectStatCd");
    String lectTitle = request.getParameter("lectTitle");
    String lectTargtCd = request.getParameter("lectTargtCd");
    String lectTims = request.getParameter("lectTims");
%>

<input type="hidden" name="lectSer" id="lectSer" value="<%=lectSer%>"/>
<input type="hidden" name="lectTims" id="lectTims" value="<%=lectTims%>"/>
<input type="hidden" name="lectrMbrNo" id="lectrMbrNo" value="<%=lectrMbrNo%>"/>
<input type="hidden" name="lectTypeCd" id="lectTypeCd" value="<%=lectTypeCd%>"/>
<input type="hidden" name="lectTitle" id="lectTitle" value="<%=lectTitle%>"/>
<div class="tab-cont active">
    <div class="tit-wrap">
        <h4 class="tit">수업일시</h4>
            <span class="right">
                <select style="width:68px;" name="" id="recordCountPerPage">
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                </select>
            </span>
    </div>
    <div class="lesson-date-tbl">
        <table>
            <caption>수업일시 테이블 정보 - 번호, 수업일시, 수업상태, MC 및 스튜디오, 입장/취소</caption>
            <colgroup>
                <col style="width:50px"/>
                <col style="width:224px"/>
                <col style="width:116px"/>
                <col/>
                <col style="width:113px"/>
                <col style="width:82px"/>
            </colgroup>
            <thead>
            <tr>
                <th scope="col">번호</th>
                <th scope="col">수업일시</th>
                <th scope="col">수업상태</th>
                <th scope="col">MC 및 스튜디오</th>
                <th scope="col">입장/취소</th>
                <th scope="col">노출여부</th>
            </tr>
            </thead>
            <tbody id="listLectShcdInfoTable">
            </tbody>
        </table>
    </div>
    <div class="paging-btn">
        <div class="paging" id="divPaging"></div>
        <span class="r-btn"><a href="javascript:void(0)" class="btn-type1 layer-open" id="aLectureScheduleAdd">추가</a></span>
    </div>
</div>
<!-- layer-popup-->
<a href="#layer1" class="layer-open" id="layerOpen"></a>

<div id="layerPopupDiv"></div>

<script type="text/javascript">
    function fn_search(pageNum){
        dataSet.params.currentPageNo = pageNum;
        dataSet.params.recordCountPerPage = $("#recordCountPerPage").val();

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureState/listLectSchdInfo.do',
            data : $.param(dataSet.params, true),
            success: function(rtnData) {

                dataSet.data = rtnData;
                if(rtnData != null && rtnData.length > 0){
                    dataSet.params.totalRecordCount = rtnData[0].totalRecordCount;
                }else{
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                $('#listLectShcdInfoTable').empty();
                mentor.PageNavi.setData(dataSet.params);
                if(rtnData.length >0){

                    $("#divPaging").show();
                    $('#lectSchdInfo').tmpl(dataSet.data).appendTo('#listLectShcdInfoTable');
                }else{
                    $('#listLectShcdInfoTable').append(
                            '<tr><td colspan="6" class="board-no-data">수업 일시, MC 및 스튜디오 정보를 추가하세요.</td></tr>'
                    );
                }
            }
        });
    }

    mentor.PageNavi = React.render(React.createElement(PageNavi, { url: mentor.contextpath + "/lecture/lectureState/listLectSchdInfo.do", pageFunc: fn_search, totalRecordCount: 0, currentPageNo: 1, recordCountPerPage: $("#recordCountPerPage").val(), contextPath: '${pageContext.request.contextPath}' }), document.getElementById('divPaging'));
</script>

<!-- 수업일시정보 정보 -->
<script type="text/html" id="lectSchdInfo">
    <tr>
        <td>\${lectTims}</td>
        <td><ul>
        {{each lectSchdInfo}}
            <li>\${to_date_format(lectDay, "-")} \${to_time_format(lectStartTime, ":")}~\${to_time_format(lectEndTime, ":")}</li>
        {{/each}}
        </ul></td>
        <td><ul>
        {{each lectSchdInfo}}
            <li>\${lectStatCdNm}</li>
        {{/each}}
        </ul></td>
        <td class="studio-info"><ul>
        {{each lectSchdInfo}}
            <li>
                <span>{{if mcNm == null}}지정안함{{else}}\${mcNm}{{/if}} / {{if stdoNm == null}}지정안함{{else}}\${stdoNm}{{/if}}</span>
                {{if lectStatCd == '101543' || lectStatCd == '101548'}}
                <a href="javascript:void(0)" class="layer-open" onclick="fnUpdMcSpdo('\${lectSer}', '\${lectTims}', '\${schdSeq}')">수정</a>
                {{/if}}
            </li>
        {{/each}}
        </ul></td>
        {{if fn_lectStat(lectSchdInfo) }}
            <td>
            {{each lectSchdInfo}}
                {{if lectStatCd == '101549' || lectStatCd == '101550'}}
                   <a href="javascript:void(0)" class="btn-stance" onClick="_fCallTomms('\${lectSessId}')">입장</a>
                {{/if}}
            {{/each}}
            </td>
        {{else}}
            {{if $data.lectStatCd == '101543' || $data.lectStatCd == '101548' }}
                <td><a href="javascript:void(0)" class="btn-round-cancel" onclick="fnCancelLecture('\${lectSer}', '\${lectTims}', \${applCnt}, \${obsvCnt})">취소</a></td>
            {{else}}
                    <td></td>
            {{/if}}
        {{/if}}
        <td>
            {{if $data.expsYn == "Y"}}
            <a href="javascript:void(0)" onclick="fn_setExps('\${lectSer}', '\${lectTims}')" title="클릭 시 학교포털 수업전체 메뉴에 노출 되지 않습니다.">노출</a>
            {{/if}}
            {{if $data.expsYn == "N"}}
            <a href="javascript:void(0)" onclick="fn_setExps('\${lectSer}', '\${lectTims}')" title="클릭 시 학교포털 수업전체 메뉴에 노출 됩니다.">비노출</a>
            {{/if}}
        </td>
    </tr>
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: $("#recordCountPerPage").val(),
            totalRecordCount: 0,
            currentPageNo: 1,
            lectSer:'<%=lectSer%>'
        },
        data: {}
    };

    mentor.mentorDataSet = dataSet;

    //수업 취소
    function fnCancelLecture(lectSer, lectTims, applCnt, obsvCnt){
        if(applCnt > 0 ){
            alert("수업신청한 학교가 존재하여 취소할수없습니다.");
            return false;
        }

        if(obsvCnt > 0 ){
            alert("수업참관 신청한 학교가 존재하여 취소할수없습니다.");
            return false;
        }

        if(!confirm("취소 하시겠습니까?")) {
            return false;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureState/cnclLectSchdInfo.do',
            data : {lectSer:lectSer, lectTims:lectTims, lectStatCd:'${code['CD101541_101547_모집취소']}'},
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    fn_search(dataSet.params.currentPageNo);
                }else{
                    alert(rtnData.message);
                }
            }
        });
    }

    function callbackFnUpdMcSpdo(){
    }


    $(document).ready(function() {
        //수업일시추가
        $("#aLectureScheduleAdd").click(function(){
            if('<%=lectTypeCd%>' == '${code['CD101528_101530_연강']}'){
                $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupLectureScheduleContiAdd.do", {"callbackFunc":"callbackLectureScheduleContiAdd","lectTestYn":$('#lectTestYn').val(), "lectTargtCd":"<%=lectTargtCd%>", "assignDay":"${param.assignDay}"}, function(){ position_cm(); $("#layerOpen").trigger("click"); });
            }else{
                $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerPopupLectureScheduleAdd.do", {"callbackFunc":"callbackLectureScheduleAdd","lectTestYn":$('#lectTestYn').val(),"lectTypeCd":"<%=lectTypeCd%>", "lectTargtCd":"<%=lectTargtCd%>" , "assignDay":"${param.assignDay}"}, function(){ position_cm(); $("#layerOpen").trigger("click"); });
            }
        });

        $("#recordCountPerPage").change(function(){
            fn_search(1);
        });
        fn_search(1);
    });

    function fnUpdMcSpdo(lectSer, lectTims, schdSeq){
        $("#layerPopupDiv").load("${pageContext.request.contextPath}/layer/layerMcStdoUpdate.do?lectSer="+lectSer + "&lectTims=" + lectTims + "&schdSeq=" + schdSeq, {"callbackFunc":"callbackFnUpdMcSpdo"}, function(){ $("#layerOpen").trigger("click"); });
    }

    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }

    function fn_lectStat(data){
        for(var i=0;i<data.length;i++){
            if(data[i].lectStatCd == '${code['CD101541_101549_수업대기']}' || data[i].lectStatCd == '${code['CD101541_101550_수업중']}'){
                return true;
                break;
            }
        }
        return false;
    }

    // 노출/비노출 수정
    function fn_setExps(sLectSer, sLectTims) {
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureState/setExpsLectureInfo.do',
            data : {lectSer:sLectSer, lectTims:sLectTims},
            success: function(rtnData) {
                if(rtnData.success) {
                    //alert(rtnData.data);
                    fn_search(dataSet.params.currentPageNo);
                } else {
                    alert(rtnData.message);
                }
            }
        });
    }
</script>