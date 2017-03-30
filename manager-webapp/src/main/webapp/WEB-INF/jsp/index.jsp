<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="posCoNo" property="principal.posCoNo" />
    <security:authentication var="posCoNm" property="principal.posCoNm" />
</security:authorize>
<!-- contents -->
<script src="https://d3js.org/d3.v3.min.js"  charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/js/d3pie.min.js"></script>
<div id="contents">
    <div class="cont type1">
        <!-- 배정그룹 현황 -->
        <div class="strator-list">
            <h2>배정그룹 현황</h2>
            <div class="present">
            <security:authorize access="hasAnyRole('ROLE_ADMIN_GROUP')">
            <fmt:parseNumber value="${posCoNo}" var="idx" />
            <p class="assing-grop">- ${posCoNm} <a href="${pageContext.request.contextPath}/lecture/school/assignGroup.do" >${allocateGroupCnt[idx-1].cnt}개</a> 배정 그룹</p>
            </security:authorize>
            <security:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_ADMIN_LEVEL1','ROLE_ADMIN_LEVEL2')">
                <p class="assing-grop">- ${fn:length(allocateGroupCnt)}개 시도교육청 중 <a href="${pageContext.request.contextPath}/lecture/school/assignGroup.do" id="totalGroupCnt">개</a> 배정 그룹</p>
                <div class="tbl-present">
                    <table id="groupTable">
                        <caption></caption>
                        <colgroup>
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col style="width:11%" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th rowspan="2" class="total">전체<a href="${pageContext.request.contextPath}/lecture/school/assignGroup.do" id="totalGroupCnt2"></a></th>
                                <th>서울특별시</th>
                                <th>부산광역시</th>
                                <th>대구광역시</th>
                                <th>인천광역시</th>
                                <th>광주광역시</th>
                                <th>대전광역시</th>
                                <th>울산광역시</th>
                                <th>세종특별자치시</th>
                            </tr>
                            <tr>
                                <td><a href="#${allocateGroupCnt[0].coNm}" id="0000000001">${allocateGroupCnt[0].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[1].coNm}" id="0000000002">${allocateGroupCnt[1].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[2].coNm}" id="0000000003">${allocateGroupCnt[2].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[3].coNm}" id="0000000004">${allocateGroupCnt[3].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[4].coNm}" id="0000000005">${allocateGroupCnt[4].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[5].coNm}" id="0000000006">${allocateGroupCnt[5].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[6].coNm}" id="0000000007">${allocateGroupCnt[6].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[7].coNm}" id="0000000008">${allocateGroupCnt[7].cnt}</a></td>
                            </tr>
                            <tr>
                                <th>경기도</th>
                                <th>강원도</th>
                                <th>충청북도</th>
                                <th>충청남도</th>
                                <th>전라북도</th>
                                <th>전라남도</th>
                                <th>경상북도</th>
                                <th>경상남도</th>
                                <th>제주특별자치도</th>
                            </tr>
                            <tr>
                                <td><a href="#${allocateGroupCnt[8].coNm}" id="0000000009">${allocateGroupCnt[8].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[9].coNm}" id="0000000010">${allocateGroupCnt[9].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[10].coNm}" id="0000000011">${allocateGroupCnt[10].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[11].coNm}" id="0000000012">${allocateGroupCnt[11].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[12].coNm}" id="0000000013">${allocateGroupCnt[12].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[13].coNm}" id="0000000014">${allocateGroupCnt[13].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[14].coNm}" id="0000000015">${allocateGroupCnt[14].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[15].coNm}" id="0000000016">${allocateGroupCnt[15].cnt}</a></td>
                                <td><a href="#${allocateGroupCnt[16].coNm}" id="0000000017">${allocateGroupCnt[16].cnt}</a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </security:authorize>
            </div>
        </div>
        <!-- 수업 현황 -->
        <div class="strator-list">
            <h2>수업 현황</h2>
            <a href="${pageContext.request.contextPath}/lecture/lectureStatus/lectureStatusList.do" class="btn-more"><img src="${pageContext.request.contextPath}/images/common/btn_more.gif" alt="더보기" /></a>
            <div class="present">
                <ul class="lesson-present">
                    <li><em>수업전체</em><a href="${pageContext.request.contextPath}/lecture/lectureStatus/lectureStatusList.do?lectStatCd=" id="lectTotCnt">${lectureStatusCnt.STTOTAL}건</a></li>
                    <security:authorize access="!hasAnyRole('ROLE_ADMIN_GROUP')">
                    <li><em>승인요청</em><a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do?filter=v2">${lectureStatusCnt.ST101542}건</a></li>
                    </security:authorize>
                    <li><em>수강모집중</em><a href="${pageContext.request.contextPath}/lecture/lectureStatus/lectureStatusList.do?lectStatCd=101543">${lectureStatusCnt.ST101543+lectureStatusCnt.ST101544}건</a></li>
                    <li><em>수업예정</em><a href="${pageContext.request.contextPath}/lecture/lectureStatus/lectureStatusList.do?lectStatCd=101548">${lectureStatusCnt.ST101548+lectureStatusCnt.ST101549}건</a></li>
                    <li><em>수업진행중</em><a href="${pageContext.request.contextPath}/lecture/lectureStatus/lectureStatusList.do?lectStatCd=101550">${lectureStatusCnt.ST101550}건</a></li>
                    <li class="finish"><em>수업완료</em><a href="${pageContext.request.contextPath}/lecture/lectureStatus/lectureStatusList.do?lectStatCd=101551">${lectureStatusCnt.ST101551}건</a></li>
                </ul>
            </div>
        </div>
        <security:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_ADMIN_LEVEL1','ROLE_ADMIN_LEVEL2')">
        <div class="approval-comu">
            <!-- 승인요청 현황 -->
            <div class="strator-list">
                <h2>승인요청 현황</h2>
                <a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do" class="btn-more"><img src="${pageContext.request.contextPath}/images/common/btn_more.gif" alt="더보기" /></a>
                <div class="present">
                    <div class="tbl-present th60">
                        <table>
                            <caption></caption>
                            <colgroup>
                                <col style="width:20%" />
                                <col style="width:20%" />
                                <col style="width:20%" />
                                <col style="width:20%" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>전체</th>
                                    <th>회원가입<br/>승인요청</th>
                                    <th>수업개설<br/>승인요청</th>
                                    <th>수업모집<br/>취소요청</th>
                                    <th>탈퇴<br/>승인요청</th>
                                </tr>
                                <tr>
                                    <td><a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do">${approvalRequestCnt.ST1+approvalRequestCnt.ST2+approvalRequestCnt.ST3+approvalRequestCnt.ST4}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do?filter=v1">${approvalRequestCnt.ST1}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do?filter=v2">${approvalRequestCnt.ST2}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do?filter=v3">${approvalRequestCnt.ST3}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/lecture/mentorApproval/mentorApprovalList.do?filter=v4">${approvalRequestCnt.ST4}</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- 커뮤니티 현황 -->
            <div class="strator-list comu">
                <h2>커뮤니티 현황</h2>
                <a href="${pageContext.request.contextPath}/board/data/dataList.do" class="btn-more"><img src="${pageContext.request.contextPath}/images/common/btn_more.gif" alt="더보기" /></a>
                <div class="present">
                    <div class="tbl-present th30">
                        <table>
                            <caption></caption>
                            <colgroup>
                                <col style="width:20%" />
                                <col style="width:20%" />
                                <col style="width:20%" />
                                <col style="width:20%" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2">자료실</th>
                                    <th colspan="2">문의하기</th>
                                    <th rowspan="2">자유게시판</th>
                                    <th rowspan="2">수업후기</th>
                                </tr>
                                <tr>
                                    <th>질문</th>
                                    <th>답변</th>
                                </tr>
                                <tr>
                                    <td><a href="${pageContext.request.contextPath}/board/data/dataList.do">${articleCnt.ST1}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/board/qna/qnaList.do">${articleCnt.ST2}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/board/qna/qnaList.do">${articleCnt.ST2A}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/board/free/freeList.do">${articleCnt.ST3}</a></td>
                                    <td><a href="${pageContext.request.contextPath}/board/rating/ratingList.do">${articleCnt.ST4}</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        </security:authorize>
        <security:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_ADMIN_LEVEL1')">
        <!-- 회원 현황 -->
        <div class="strator-list">
            <h2>회원 현황</h2>
            <a href="statistics/member/memberStatistics.do" class="btn-more"><img src="${pageContext.request.contextPath}/images/common/btn_more.gif" alt="더보기" /></a>
            <div class="present">
                <!-- 멘토 -->
                <div class="mentor-present">
                    <h3>멘토</h3>
                    <div class="tbl-present th60">
                        <table>
                            <caption></caption>
                            <colgroup>
                                <col style="width:20%" />
                                <col style="width:25%" />
                                <col style="width:25%" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>전체</th>
                                    <th>기업멘토</th>
                                    <th>소속멘토</th>
                                    <th>개인멘토</th>
                                </tr>
                                <tr>
                                    <td><%--<a href="${pageContext.request.contextPath}/user/member/listMentorMember.do">--%>${memberCnt.ST1+memberCnt.ST2+memberCnt.ST3}<%--</a>--%></td>
                                    <td><%--<a href="${pageContext.request.contextPath}/user/corpo/listCorporationMentor.do">--%>${memberCnt.ST1}<%--</a>--%></td>
                                    <td><%--<a href="${pageContext.request.contextPath}/user/member/listMentorMember.do">--%>${memberCnt.ST2}<%--</a>--%></td>
                                    <td><%--<a href="${pageContext.request.contextPath}/user/member/listMentorMember.do">--%>${memberCnt.ST3}<%--</a>--%></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <security:authorize access="hasAnyRole('ROLE_ADMIN','ROLE_ADMIN_LEVEL1')">
                <!-- 학교 -->
                <div class="mentor-present school">
                    <h3>학교</h3>
                    <div class="tbl-present th30">
                        <table>
                            <caption></caption>
                            <colgroup>
                                <col style="width:20%" />
                                <col style="width:25%" />
                                <col style="width:25%" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="2">전체</th>
                                    <th colspan="3">학교급</th>
                                </tr>
                                <tr>
                                    <th>초등학교</th>
                                    <th>중학교</th>
                                    <th>고등학교</th>
                                </tr>
                                <tr>
                                    <td><%--<a href="${pageContext.request.contextPath}/lecture/school/schoolInfo.do">--%>${schoolCnt.TOTAL}<%--</a>--%></td>
                                    <td><%--<a href="${pageContext.request.contextPath}/lecture/school/schoolInfo.do?schClassCd=100495">--%>${schoolCnt.ST1}<%--</a>--%></td>
                                    <td><%--<a href="${pageContext.request.contextPath}/lecture/school/schoolInfo.do?schClassCd=100496">--%>${schoolCnt.ST2}<%--</a>--%></td>
                                    <td><%--<a href="${pageContext.request.contextPath}/lecture/school/schoolInfo.do?schClassCd=100497">--%>${schoolCnt.ST3}<%--</a>--%></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 회원 -->
                <div class="member-present">
                    <h3>회원</h3>
                    <div class="graph" id="pieChart"></div>
                </div>
                </security:authorize>
            </div>
        </div>
        </security:authorize>
    </div>
</div>
<!-- //contents -->
<a href="#statusLayer" class="layer-open" style="display:none" id="btnStatusLayer"></a>
<!-- layerpopup --><!-- body 에 dim 클래스 추가 시 검은반투명 bg -->
<div class="layer-pop-wrap w720" id="statusLayer">
    <div class="title">
        <strong>배정그룹 현황</strong>
        <a href="#" class="pop-close layer-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont type1">
        <div class="grop-present">
            <p><span id="coNm">서울시교육청</span> 그룹 관리자 소속 총 합계  <span id="coNoAssignGrpCnt">0개</span> 배정 그룹</p>
            <div class="tbl-style2">
                <div class="pop-scroll">
                    <table>
                        <caption></caption>
                        <colgroup>
                            <col style="width:10%" />
                            <col style="width:30%" />
                            <col style="width:10%" />
                            <col />
                            <col style="width:15%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">번호</th>
                                <th scope="col">배정그룹</th>
                                <th scope="col">배정횟수</th>
                                <th scope="col">배정기간</th>
                                <th scope="col">학교 수</th>
                            </tr>
                        </thead>
                        <tbody id="assignGroupData"></tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type1 layer-close">확인</a>
            <a href="#" class="btn-type1 gray layer-close">취소</a>
        </div>
    </div>
</div>
<!-- //layerpopup -->
<script type="text/html" id="assignGroupTmpl">
<tr>
    <td>\${rn}</td>
    <td><a href="${pageContext.request.contextPath}/lecture/school/viewAssignGroup.do?setTargtNo=\${setTargtNo}">\${bizGrpInfo.grpNm}</a></td>
    <td>\${clasCnt}</td>
    <td>\${mentor.parseDate(clasStartDay).format('yyyy.MM.dd')}~\${mentor.parseDate(clasStartDay).format('yyyy.MM.dd')}</td>
    <td>\${lectApplCnt.clasApplCnt}</td>
</tr>
</script>
<script type="text/javascript">
$(document).ready(function(){
    var totCnt = 0;
    $("#groupTable td a").each(function(){
        totCnt += mentor.getOnlyNumber($(this).text())*1;
    }).click(function(){
        listAsignGroup($(this).attr("id"),$(this).attr("href").substring(1));

        //팝업장의 내용 갱신
        $("#btnStatusLayer").click();
    });
    $("#totalGroupCnt").text("{0}개".format(toCurrency(totCnt)));
    $("#totalGroupCnt2").text("{0}".format(toCurrency(totCnt)));
//    var totCnt = 0;
//    $("#lectTotCnt").closest("li").find("~").find("a").each(function(){
//        totCnt += Number(mentor.getOnlyNumber($(this).text()));
//    });
//    $("#lectTotCnt").html("{0}건".format(totCnt));

    var data = [
            {"label":"학생", "value":${memberCnt.ST4}},
            {"label":"일반", "value":${memberCnt.ST5}},
            {"label":"교사", "value":${memberCnt.ST6}},
            ];

    var pie = new d3pie("pieChart", {
        <%--"header": {
              "title": {
                "text": "회원",
                "fontSize": 22,
                "font": "verdana"
              },
            },--%>
        "size": {
              "canvasHeight": 150,
              "canvasWidth": 200
            },
         "labels": {
             "outer": {
               "pieDistance": 5
             }
           },
        "data": {
            "content": [
              {"label":"학생(${memberCnt.ST4})","value":${memberCnt.ST4}},
              {"label":"일반(${memberCnt.ST5})", "value":${memberCnt.ST5}},
              {"label":"교사(${memberCnt.ST6})", "value": ${memberCnt.ST6}}
              ]
         }
    });
});

function listAsignGroup(coNo,coNm){
    $("#coNm").text(coNm);
    $.ajax({
        url: "${pageContext.request.contextPath}/lecture/school/ajax.listAssignGroupAll.do",
        data : {'coNo':coNo},
        success: function(rtnData) {
            $("#coNoAssignGrpCnt").text(rtnData.length+"개");
            $("#assignGroupData>tr").remove();
            $("#assignGroupTmpl").tmpl(rtnData).appendTo(assignGroupData);
        }
    });
}
</script>