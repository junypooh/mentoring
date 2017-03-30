<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>

<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="mbrNo" property="principal.mbrNo" />
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
</security:authorize>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">수업</span>
        <span>수업전체</span>
    </div>
    <div class="content sub">
        <h2 class="txt-type"><c:choose><c:when test="${applClassCd == '101715'}">수업신청</c:when><c:otherwise>참관신청</c:otherwise></c:choose></h2>
        <div class="lesson-request">
            <div class="board-input-type">
                <table>
                    <caption>수업신청 - 수업,멘토,일시,학교,학급/그룹, 차감기준횟수, 학교보유수업횟수</caption>
                    <colgroup>
						<col style="width:20%">
						<col>
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
                                    <c:forEach var="schdInfo" items="${lectTimsInfo.lectSchdInfo}" varStatus="status">
                                        <li>
                                            ${schdInfo.lectDay} / ${schdInfo.lectStartTime} ~ ${schdInfo.lectEndTime}
                                        </li>
                                    </c:forEach>
                                </ul>
							</td>
						</tr>
						<tr>
							<th scope="row"><label for="lessonSchool">학교</label></th>
                            <td id="tdSchool">
                                <div id="singleSchoolArea" style="display:none;"></div>
                                <select id="lessonSchool" name="lessonSchool" class="slt-style1" style="width:auto;" title="학교">
                                        <option value="">선택</option>
                                </select>
                            </td>
						</tr>
                        <tr>
                            <th scope="row"><label for="SchoolGroup">학급/그룹</label></th>
                            <td>
                                <select id="SchoolGroup" name="SchoolGroup" class="slt-style1" title="학급/그룹">
                                    <option value="">선택</option>
                                </select>
                            </td>
                        </tr>
						<tr>
							<th scope="row">차감기준횟수</th>
							<td>
							    <c:choose>
                                    <c:when test="${applClassCd == '101715'}">${fn:replace(lectTimsInfo.lectureCnt, '.0', '')}</c:when>
                                    <c:otherwise>${fn:replace(lectTimsInfo.lectureCnt/2, '.0', '')}</c:otherwise>
                                </c:choose>
                                <span class="num-comment">수업 신청 시, 차감되는 기준 횟수입니다.</span>
							</td>
						</tr>
                        <tr>
							<th scope="row"><label for="lessonNum">학교보유<br />기준횟수</label></th>
							<td class="num-info">
								<div>
									${lectInfo.grpNm}
									<p id="cntArea">잔여횟수 <strong>0</strong>회 / 배정횟수 0회</p>
								</div>
								<span class="num-comment">자세한 정보는 마이페이지에서 확인하세요.</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-area">
                <a href="javascript:void(0);" id="lectureApply" class="btn-type2 popup">확인</a>
                <a href="${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${param.lectSer}&lectTims=${param.lectTims}&schdSeq=${param.schdSeq}" id="lectureApply" class="btn-type2 cancel">취소</a>
			</div>
		</div>
	</div>
</div>



<script type="text/javascript">
    var schPermCnt = 0;
    var lectureCnt = ${applClassCd == '101715' ? lectTimsInfo.lectureCnt : lectTimsInfo.lectureCnt/2};

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

                    alert("등록된 교실정보가 없습니다.  마이페이지>나의교실에서 교실정보 등록 후 이용해주세요.");
                    location.href= "${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${param.lectSer}&lectTims=${param.lectTims}&schdSeq=${param.schdSeq}";
                }
            }
        });


        //학교 selectbox onChange
        $("#lessonSchool").change(function(){
            //학급/그룹 selectbox 내용을 변경
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listClasRoomInfo.do",
                data: {schNo:this.value,lectSer:${lectTimsInfo.lectSer}, setSer:${lectInfo.setSer}},
                contentType: "application/json",
                dataType: 'json',
                success: function (rtnData) {
                    if(rtnData != null && rtnData.length > 0) {
                        if(rtnData[0].applable === false){
                            alert('신청할 수 없는 학교등급입니다.');

                            if($("#singleSchoolArea").text().length >0 ){
                                $("#btnClose").trigger("click");
                            }


                            $("#SchoolGroup").emptySelect(1);
                            schPermCnt = 0;
                        }else{
                            if(${ mbrClassCd eq '100858'}){ //일반 학생일 경우

                                var selectObj = document.getElementById( "SchoolGroup" );

                                var memberData = rtnData.map(function(item, index) {
                                    if(item.clasRoomCualfCd == '101691'){
                                        selectObj.add( createOption( item.clasRoomSer ,item.clasRoomNm) );
                                    }
                                 });
                            }else{
                                $("#SchoolGroup").loadSelectOptions(rtnData, "", "clasRoomSer", "clasRoomNm", 1);
                            }

                            var bizCnt = rtnData[0].permCnt + rtnData[0].applyCnt;
                            if(rtnData[0].permCnt > 0){
                               $("#cntArea").html("잔여횟수 <strong>" + rtnData[0].permCnt + "</strong>회 / 배정횟수" + bizCnt + "회");
                               schPermCnt = rtnData[0].permCnt;
                            }else{
                               $("#cntArea").html("학교에서 보유한 수업횟수가 없습니다");
                            }

                        }
                    }else{
                        $("#SchoolGroup").emptySelect(1);
                        schPermCnt = 0;
                    }
                }
            });
        });

        //학교 selectbox onChange
        $("#lessonSchool").change(function(){
            //설정 대상 selectbox 초기화
            $("#lessonNum option:eq(0)").attr("selected", "selected");
        });


        //수업신청
        $("#lectureApply").click(function(){
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

            if(schPermCnt == 0){
                alert("잔여 배정횟수가 없습니다.");
                return false;
            }else if(schPermCnt < lectureCnt){
                alert("차감기준횟수가 잔여횟수를 초과하기 때문에 수업을 신청할 수 없습니다.");
                return false;
            }

            if(confirm("수업신청을 하시겠습니까?")){
                $.ajax({
                    url: "${pageContext.request.contextPath}/layer/ajax.lectureApply.do",
                    data : {  "lectSer" : "${lectTimsInfo.lectSer}"
                            , "lectTims" : "${lectTimsInfo.lectTims}"
                            , "schNo" : schNo
                            , "clasRoomSer" : clasRoomSer
                            , "setSer" : "${lectInfo.setSer}"
                            , "applClassCd" : "${applClassCd}"
                            , "lectureCnt" : "${fn:replace(lectTimsInfo.lectureCnt, '.0', '')}"
                    },
                    type : 'post',
                    success: function(rtnData) {
                        if(rtnData.success){
                            alert(rtnData.data);

                            var func = "${param.callbackFunc}";

                            if(func != null && func != ""){
                                eval(func).call(null);
                            }
                            location.href= "${pageContext.request.contextPath}/lecture/lectureTotal/lectureView.do?lectSer=${param.lectSer}&lectTims=${param.lectTims}&schdSeq=${param.schdSeq}";
                        }else{
                            alert(rtnData.message);

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
