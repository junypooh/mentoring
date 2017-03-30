<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="layer-pop-wrap" id="layer3">
    <div class="layer-pop">
        <div class="layer-header">
            <strong class="title">수업신청대기</strong>
        </div>
        <div class="layer-cont">
            <div class="layer-pop-scroll">
                <div class="tbl-style standby">
                    <table>
                        <caption>수업신청 - 수업,멘토,일시,학교,학급/그룹, 차감기준횟수, 학교보유수업횟수</caption>
                        <colgroup>
                            <col style="width:20%" />
                            <col />
                        </colgroup>
                        <tbody>
                        <tr>
                            <th scope="row">수업</th>
                            <td>${lectInfo.lectTitle}</td>
                        </tr>
                        <tr>
                            <th scope="row">멘토</th>
                            <td>${lectInfo.lectrNm}</td>
                        </tr>
                        <tr>
                            <th scope="row">일시</th>
                            <td>
                                <ul>
                                    <c:forEach var="schdInfo" items="${lectSchdInfoList}">
                                        <fmt:parseDate value="${schdInfo.lectDay}" var="lectDay" pattern="yyyyMMdd"/>
                                        <fmt:parseDate value="${schdInfo.lectStartTime}" var="lectStartTime" pattern="HHmm"/>
                                        <fmt:parseDate value="${schdInfo.lectEndTime}" var="lectEndTime" pattern="HHmm"/>
                                        <li>
                                            <fmt:formatDate value="${lectDay}" pattern="yyyy.MM.dd"/> / <fmt:formatDate value="${lectStartTime}" pattern="HH:mm"/> ~ <fmt:formatDate value="${lectEndTime}" pattern="HH:mm"/>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lessonSchool">학교</label></th>
                            <td id="tdSchool">
                                <div id="singleSchoolArea" style="display:none;"></div>
                                <select id="lessonSchool" name="lessonSchool" class="slt-style" title="학교">
                                    <option value="">선택</option>
                                    <%--<option>예일 초등학교</option>--%>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="SchoolGroup">학급/그룹</label></th>
                            <td>
                                <select id="SchoolGroup" name="SchoolGroup" class="slt-style" title="학급/그룹">
                                    <option value="">선택</option>
                                    <%--<option>3학년 1반</option>--%>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">차감기준횟수</th>
                            <td>${lectureCnt}<span class="num-comment">수업 신청 시, 차감되는 기준 횟수입니다.</span></td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="lessonNum">학교보유<br />기준횟수</label></th>
                            <td class="num-info">
                                <div>
                                    <%--설정 대상 구분 (학교 자체 배정, 교육청 사업 배정)--%>
                                    <select id="lessonNum" class="slt-style" title="학교보유수업횟수">
                                        <option value="">선택</option>
                                        <%--<option>학교 자체 배정</option>--%>
                                        <%--<option selected="seleted">교육청 사업 배정</option>--%>
                                    </select>
                                    <%-- 학교 자체 배정의 설정일련번호 --%>
                                    <input type="hidden" id="schoolSetSerValue">
                                    <%--교육청--%>
                                    <select id="bizGrp" class="slt-style" title="배정명" style="display: none">
                                        <option value="">선택</option>
                                        <%--<option>배정명</option>--%>
                                        <%--<option selected="selected">서울특별시교육청</option>--%>
                                    </select>
                                    <%--사업--%>
                                    <select id="biz"  class="slt-style" title="교육청선택" style="display: none">
                                        <option value="">선택</option>
                                        <%--<option>배정그룹</option>--%>
                                        <%--<option selected="selected">2015년도 자율고 지원사업</option>--%>
                                    </select>
                                    <p id="cntArea"></p>
                                    <%-- 선택된 사업의 수업신청 잔여횟수 --%>
                                    <input type="hidden" id="selectedClasPermCntValue">
                                </div>
                                <span class="num-comment">자세한 정보는 마이페이지에서 확인하세요.</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <ul class="lesson-standby">
                        <li>대기자 등록하신 경우, <em>결원 발생 시 자동 수업 신청 상태로 변경</em>됩니다.<br/>변경 내용은 이메일로 연락 드립니다. 마이페이지에서 최신 정보를 정확히 입력하여 주십시오.</li>
                        <li>자세한 관련 정보는 [마이페이지]에서 확인하세요.</li>
                    </ul>
                </div>
            </div>
            <div class="btn-area popup">
                <%--<a href="#" class="btn-type2 popup">확인</a>--%>
                    <a href="javascript:void(0);" id="lectureApplyWait" class="btn-type2 popup">확인</a>
                <a href="#" class="btn-type2 cancel">취소</a>
            </div>
            <a href="#" id="btnClose" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        //학교 selectbox 조회
        $.ajax({
            url: "${pageContext.request.contextPath}/layer/ajax.listSchInfo.do",
            success: function (rtnData) {
                if(rtnData != null && rtnData.length > 0){
                    $("#lessonSchool").loadSelectOptions(rtnData,"","schNo","schNm",1);

                    if(rtnData.length == 1){
                        $("#singleSchoolArea").html(rtnData[0].schNm);
                        $("#singleSchoolArea").show();
                        $("#lessonSchool").hide();
                        $("#lessonSchool").val(rtnData[0].schNo).change();
                    }

                }else{
                    $("#singleSchoolArea").html("등록된 학교가 없습니다.");
                    $("#singleSchoolArea").show();
                    $("#lessonSchool").hide();
                    $("#lessonSchool").change();

                    alert("나의 교실 정보를 먼저 등록해주세요");
                    $("#btnClose").trigger("click");
                }
            }
        });

        //설정 대상 selectbox
        $.ajax({
            url: "${pageContext.request.contextPath}/code.do",
            data : {"supCd":"101599"},
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                if(rtnData != null && rtnData.length > 0) {
                    $("#lessonNum").loadSelectOptions(rtnData, "", "cd", "cdNm", 1).change();
                }
            }
        });

        position_cm();

        //학교 selectbox onChange
        $("#lessonSchool").change(function(){
            //학급/그룹 selectbox 내용을 변경
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listClasRoomInfo.do",
                data: {schNo:this.value,lectSer:${lectSer}},
                contentType: "application/json",
                dataType: 'json',
                success: function (rtnData) {
                    if(rtnData != null && rtnData.length > 0) {
                        if(rtnData[0].applable === false){
                            alert('신청할 수 없는 학교등급입니다.');
                            $("#SchoolGroup").emptySelect(1);
                        }else{
                            $("#SchoolGroup").loadSelectOptions(rtnData, "", "clasRoomSer", "clasRoomNm", 1);
                        }
                    }else{
                        $("#SchoolGroup").emptySelect(1);
                    }
                }
            });
        });

        //학교 selectbox onChange
        $("#lessonSchool").change(function(){
            //설정 대상 selectbox 초기화
            $("#lessonNum option:eq(0)").attr("selected", "selected");
            $("#lessonNum").trigger("change");
        });

        $("#SchoolGroup").change(function(){
            if(this.value == null || this.value == ""){
                $("#lessonNum option:eq(0)").attr("selected", "selected");
                $("#lessonNum").trigger("change");
            }
        });

        //설정 대상 selectbox onChange
        $("#lessonNum").change(function(){
            var setTargtCd = $("#lessonNum").val();
            if(setTargtCd != null && setTargtCd != ""){
                var schNo = $("#lessonSchool option:selected").val();
                if(schNo == null || schNo == ""){
                    alert("학교를 먼저 선택해 주십시오.");
                    $("#lessonNum option:eq(0)").attr("selected", "selected");
                    return false;
                }

                /* 배정횟수는 학교에 주는 것이기 때문에 어떤 교실인지와는 상관이 없음
                var clasRoomSer = $("#SchoolGroup option:selected").val();
                if(clasRoomSer == null || clasRoomSer == ""){
                    alert("학급/그룹을 먼저 선택해 주십시오.");
                    $("#lessonNum option:eq(0)").attr("selected", "selected");
                    return false;
                }
                */

                switch (setTargtCd){
                    case "101600" : //학교 자체 배정
                        $("#bizGrp").emptySelect(1);
                        $("#bizGrp").hide();
                        $("#biz").emptySelect(1);
                        $("#biz").hide();

                        //학교 자체 잔여횟수/배정횟수 조회
                        $.ajax({
                            url: "${pageContext.request.contextPath}/layer/ajax.listBizSetInfoBySchool.do",
                            data: {"schNo":$("#lessonSchool").val(),"lectSer":"${lectSer}","lectTims":"${lectTims}"},
                            success: function(rtnData) {
                                if(rtnData != null && rtnData !== undefined){
                                    $("#cntArea").html('잔여횟수 <strong>{0}</strong>회 / 배정횟수 {1}회'.format(rtnData.lectApplCnt.clasPermCnt, rtnData.clasCnt));
                                    $("#schoolSetSerValue").val(rtnData.setSer);
                                    $("#selectedClasPermCntValue").val(rtnData.lectApplCnt.clasPermCnt);
                                }else{
                                    $("#cntArea").html('잔여횟수 <strong>0</strong>회 / 배정횟수 0회');
                                    $("#schoolSetSerValue").val("");
                                    $("#selectedClasPermCntValue").val("");
                                }
                            },
                            error: function(xhr, status, err){
                                console.error(this.url, status, err.toString());
                                $("#cntArea").html("");
                                $("#schoolSetSerValue").val("");
                                $("#selectedClasPermCntValue").val("");
                            }
                        });
                    break;
                    case "101601" : //교육청 사업 배정
                        //교육청 조회
                        $.ajax({
                            url: "${pageContext.request.contextPath}/layer/ajax.listCoInfo.do",
                            data: {  schNo : $("#lessonSchool").val()
                                   , lectSer : "${lectSer}"
                                   , lectTims : "${lectTims}"
                            },
                            contentType: "application/json",
                            dataType: 'json',
                            success: function (rtnData) {
                                if(rtnData != null && rtnData.length > 0) {
                                    $("#bizGrp").loadSelectOptions(rtnData, "", "coNo", "coNm", 1);
                                    $("#bizGrp").change();
                                    $("#bizGrp").show();
                                    $("#biz").show();
                                }else{
                                    $("#cntArea").html("교육청 사업 배정이 존재하지 않습니다.");
                                }
                            }
                        });
                    break;
                }
            }else{
                $("#bizGrp").emptySelect(1);
                $("#bizGrp").hide();
                $("#biz").emptySelect(1);
                $("#biz").hide();

                $("#cntArea").html("");
            }
        });

        //교육청 selectbox onChange
        $("#bizGrp").change(function(){
            var selectedValue = this.value;
            if(selectedValue != null && selectedValue != ""){
                $.ajax({
                    url: "${pageContext.request.contextPath}/layer/ajax.listBizSetGrp.do",
                    data: {  schNo : $("#lessonSchool").val()
                           , lectSer : "${lectSer}"
                           , lectTims : "${lectTims}"
                           , coNo : selectedValue
                    },
                    contentType: "application/json",
                    dataType: 'json',
                    success: function(rtnData) {
                        if(rtnData != null && rtnData.length > 0){
                            mentor.bizGrpData = rtnData;
                            $("#biz").loadSelectOptions(mentor.bizGrpData, "", function(obj){return obj.setSer}, function(obj){return obj.bizGrpInfo.grpNm}, 1);
                        }else{
                            mentor.bizGrpData = null;
                            $("#biz").emptySelect(1);
                            $("#biz").change();
                        }
                    }
                });
            }else{
                $("#biz").emptySelect(1);
                $("#cntArea").html("");
            }
        });

        //사업 selectbox onChange
        $("#biz").change(function(){
            var selectedValue = this.value;

            if(selectedValue != null && selectedValue != ""){
                for(var i in mentor.bizGrpData){
                    if(mentor.bizGrpData[i].setSer == selectedValue){
                        $("#cntArea").html('잔여횟수 <strong>{0}</strong>회 / 배정횟수 {1}회'.format(mentor.bizGrpData[i].lectApplCnt.clasPermCnt, mentor.bizGrpData[i].clasCnt));
                        $("#selectedClasPermCntValue").val(mentor.bizGrpData[i].lectApplCnt.clasPermCnt);
                        break;
                    }
                }
            }else{
                $("#cntArea").html("");
                $("#selectedClasPermCntValue").val("");
            }
        });

        //수업신청
        $("#lectureApplyWait").click(function(){
            var schNo = $("#lessonSchool").val();
            if(schNo == null || schNo == ""){
                alert("학교를 선택하세요.");
                $("#lessonSchool").focus();
                return false;
            }

            var clasRoomSer = $("#SchoolGroup").val();
            if(clasRoomSer == null || clasRoomSer == ""){
                alert("학급/그룹을 선택하세요.");
                $("#SchoolGroup").focus();
                return false;
            }

            var lessonNum = $("#lessonNum").val();
            var setSer = "";
            if(lessonNum == null || lessonNum == ""){
                alert("학교보유 수업횟수를 선택하세요.");
                $("#lessonNum").focus();
                return false;
            }else{
                switch (lessonNum){
                    case "101600" : //학교 자체 배정
                        setSer = $("#schoolSetSerValue").val();
                    break;
                    case "101601" : //교육청 사업 배정
                        setSer = "";
                        var bizGrp = $("#bizGrp").val();
                        if(bizGrp == null || bizGrp == ""){
                            alert("학교보유 수업횟수를 선택하세요.");
                            $("#bizGrp").focus();
                            return false;
                        }

                        var biz = $("#biz").val();
                        if(biz == null || biz == ""){
                            alert("학교보유 수업횟수를 선택하세요.");
                            $("#biz").focus();
                            return false;
                        }

                        setSer = biz;

                    break;
                }

                var clasPermCnt = $("#selectedClasPermCntValue").val();
                if(clasPermCnt == null || clasPermCnt == "" || parseInt(clasPermCnt) <= 0){
                    alert("배정횟수를 전부 사용하여 수업을 신청할 수 없습니다.");
                    return false;
                }else if(parseInt(clasPermCnt) - parseInt(${lectureCnt}) < 0){
                    alert("차감기준횟수가 잔여횟수를 초과하기 때문에 수업을 신청할 수 없습니다.");
                    return false;
                }
            }

            if(confirm("수업신청대기를 하시겠습니까?")){
                $.ajax({
                    url: "${pageContext.request.contextPath}/layer/ajax.lectureApplyWait.do",
                    data : {  "lectSer" : "${lectSer}"
                            , "lectTims" : "${lectTims}"
                            , "schNo" : schNo
                            , "clasRoomSer" : clasRoomSer
                            , "setSer" : setSer
                    },
                    type : 'post',
                    success: function(rtnData) {
                        if(rtnData.success){
                            alert(rtnData.data);

                            var func = "${param.callbackFunc}";

                            if(func != null && func != ""){
                                eval(func).call(null);
                            }
                            $("#btnClose").trigger("click");
                        }else{
                            alert(rtnData.message);

                            $("#btnClose").trigger("click");
                        }
                    },
                    error: function(xhr, status, err){
                        console.error(this.url, status, err.toString());
                    }
                });
            }
        });

    });
</script>
