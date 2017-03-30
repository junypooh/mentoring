<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>멘토회원</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>멘토회원관리</li>
            <li>멘토회원</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="mbrNo" value="${param.mbrNo}" />
        <input type="hidden" name="id" value="${param.id}" />
        <input type="hidden" name="name" value="${param.name}" />
        <input type="hidden" name="job" value="${param.job}" />
        <input type="hidden" name="jobTag" value="${param.jobTag}" />
        <input type="hidden" name="loginPermYn" value="${param.loginPermYn}" />
        <input type="hidden" name="jobClsfCd" value="${param.jobClsfCd}" />
        <input type="hidden" name="jobLv1Selector" value="${param.jobLv1Selector}" />
        <input type="hidden" name="jobLv2Selector" value="${param.jobLv2Selector}" />
        <input type="hidden" name="jobLv3Selector" value="${param.jobLv3Selector}" />
        <input type="hidden" name="regDtmBegin" value="${param.regDtmBegin}" />
        <input type="hidden" name="regDtmEnd" value="${param.regDtmEnd}" />
    </form>
    <!-- 2016-06-28 수정 -->
    <div class="mento-pic-wrap">
        <ul class="bxslider">
            <c:forEach items="${user.mbrpropicInfos}" var="eachObj" varStatus="vs">
            <li class="mento-img">
                <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${eachObj.fileSer}" alt="프로필 사진 ${vs.count}" /> <!-- 이미지 너비 145px 고정 -->
            </li>
            </c:forEach>
            <c:forEach begin="${fn:length(user.mbrpropicInfos) + 1}" end="3" var="eachObj">
            <li class="mento-img">
                <img src="${pageContext.request.contextPath}/images/img_mento_default.png" alt="프로필 사진 ${eachObj}" />
            </li>
            </c:forEach>
        </ul>
    </div>
    <script type="text/javascript">
        $('.bxslider').bxSlider({
            auto: false,
            controls : false,
            autoHover : false
        });
    </script>
    <!-- 2016-06-28 수정[E] -->
    <div class="board-area mento-info"><!-- 2016-06-27 클래스 mento-info 추가 -->
        <table class="tbl-style tbl-none-search">
            <colgroup>
                <col style="width:15%;" />
                <col style="width:100px;"/>
                <col style="width:25%" />
                <col style="width:15%" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">아이디</th>
                    <td colspan="2">${user.id}</td>
                    <th scope="col" class="ta-l">비밀번호</th>
                    <td>
                        <button type="button" class="btn-style01" onclick="pwdReset('EMS');"><span>초기화 메일 발송</span></button>
                        <button type="button" class="btn-style01" onclick="pwdReset('SMS');"><span>초기화 SMS 발송</span></button>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">이름</th>
                    <td colspan="2">${user.username} (${codeConstants['CD100322_100323_남자'] eq user.genCd ? '남' : '여'})</td>
                    <th scope="col" class="ta-l">이메일</th>
                    <td>${user.emailAddr}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">생년월일</th>
                    <td colspan="2"><c:if test="${not empty user.birthday}">${cnet:stringToDatePattern(user.birthday, 'yyyy.MM.dd')} (<c:choose><c:when test="${user.lunarYn eq 'N'}">양력</c:when><c:otherwise>음력</c:otherwise></c:choose>)</c:if></td>
                    <th scope="col" class="ta-l">이메일 수신</th>
                    <td><c:choose><c:when test="${not empty user.agrees[0].agrClassCd}">동의</c:when><c:otherwise>동의안함</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">휴대전화</th>
                    <td colspan="4">${user.mobile}</td>
                </tr>
                <tr>
                    <th scope="col" rowspan="3" class="ta-l">직업</th>
                    <td>특정분류</td>
                    <td colspan="3">
                        <c:forEach items="${user.mbrJobChrstcInfos}" var="eachObj" varStatus="vs">
                            ${eachObj.jobChrstcCdNm},
                        </c:forEach>
                    </td>
                </tr>
                <tr>
                    <td>직업분류</td>
                    <td colspan="3">
                        <c:if test="${not empty user.mbrJobInfo.jobClsfLv1Nm}">${user.mbrJobInfo.jobClsfLv1Nm}</c:if>
                        <c:if test="${not empty user.mbrJobInfo.jobClsfLv2Nm}"> > ${user.mbrJobInfo.jobClsfLv2Nm}</c:if>
                        <c:if test="${not empty user.mbrJobInfo.jobClsfLv3Nm}"> > ${user.mbrJobInfo.jobClsfLv3Nm}</c:if>
                    </td>
                </tr>
                <tr>
                    <td>직업명</td>
                    <td colspan="3">${user.mbrJobInfo.jobNm}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">태그</th>
                    <td colspan="4">${user.mbrJobInfo.jobTagInfo}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">멘토소개</th>
                    <td colspan="4"><c:if test="${not empty user.mbrProfInfo.intdcInfo}"><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(user.mbrProfInfo.intdcInfo)"></spring:eval></c:if></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">가입일</th>
                    <td colspan="2"><fmt:formatDate value="${user.regDtm}" pattern="yyyy.MM.dd HH:mm" /> / 최근 로그인: ${user.lastLoginDtm}</td>
                    <th scope="col" class="ta-l">사용유무</th>
                    <td><c:choose><c:when test="${user.loginPermYn eq 'Y'}">사용중</c:when><c:otherwise>사용안함</c:otherwise></c:choose></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">재동의 일자</th>
                    <td colspan="2">
                        <c:choose>
                        <c:when test="${not empty reAgrees[0].regDtm}">
                        <fmt:formatDate value="${reAgrees[0].regDtm}" pattern="yyyy.MM.dd HH:mm" />
                        </c:when>
                        <c:otherwise>
                        -
                        ${useRegDate}
                        </c:otherwise>
                        </c:choose>
                        / 재동의 예정일 :
                        <c:choose>
                        <c:when test="${not empty reAgrees[0].regDtm}">
                        <fmt:formatDate value="${cnet:calculateDate(reAgrees[0].regDtm, 'y', 2)}" pattern="yyyy.MM.dd HH:mm" />
                        </c:when>
                        <c:otherwise>
                        <fmt:formatDate value="${cnet:calculateDate(user.regDtm, 'y', 2)}" pattern="yyyy.MM.dd HH:mm" />
                        </c:otherwise>
                        </c:choose>
                    </td>
                    <th scope="col" class="ta-l">재동의여부</th>
                    <td>${empty reAgrees ? '-' : '재동의완료'}</td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">승인정보</th>
                    <td colspan="4"><c:if test="${authInfo.statChgRsltCd ne codeConstants['CD100861_101506_승인요청'] and authInfo.statChgRsltCd ne codeConstants['CD100861_101572_탈퇴요청']}"><fmt:formatDate value="${authInfo.regDtm}" pattern="yyyy.MM.dd HH:mm" /> / ${authInfo.regMbrNm} <c:if test="${not empty authInfo.coNm}">(${authInfo.coNm})</c:if></c:if></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onclick="location.href='edit.do?mbrNo=${param.mbrNo}'"><span>수정</span></button></li>
                <li><button type="button" class="btn-style02" onclick="goList()"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
    <div class="board-area board-area-bot" id="boardArea">
        <div class="tab-bar">
            <ul>
                <li class="on"><a href="#">수업현황</a></li><!-- 활성화 시 on 클래스 추가 -->
            </ul>
        </div>
        <div class="tab-cont"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
            <div class="board-top">
                <p class="total-num">총 <strong>0</strong> 건</p>
            </div>
            <table id="boardTable"></table>
            <div id="paging"></div>
        </div>
    </div>
</div>
<script type="text/jsx;harmony=true">
    mentor.schoolPageNavi = React.render(
        <PageNavi  pageFunc={loadData} totalRecordCount={0} currentPageNo={1} recordCountPerPage={20} pageSize={10} />,
        document.getElementById('paging')
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

    $(document).ready(function() {
        loadData(1);
    });

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

    function loadData(curPage, recordCountPerPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'번호', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'수업유형', name:'lectTypeCdNm', index:'lectTypeCdNm', width:30, align:'center', sortable: false});
        colModels.push({label:'수업대상', name:'lectTargtCd', index:'lectTargtCd', width:30, align:'center', sortable: false});
        colModels.push({label:'수업명', name:'lectTitle',index:'lectTitle', width:70, sortable: false});
        colModels.push({label:'배정사업', name:'grpNm', index:'grpNm', width:40, sortable: false});
        colModels.push({label:'교육수행기관', name:'coNm', index:'coNm', width:40, sortable: false});
        colModels.push({label:'수업차수', name:'lectTimsCnt', index:'lectTimsCnt', width:20, align:'center', sortable: false});
        colModels.push({label:'최종수정일', name:'chgDtm', index:'chgDtm', width:30, align:'center', sortable: false});

        initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.jqgrid-overlay').show();
        $('.loading').show();

        var _param = jQuery.extend({'lectMbrNo': ${param.mbrNo}, 'orderBy': 'lectDay'}, dataSet.params);

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/register/ajax.list.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    if(item.lectTargtCd == 101534) {
                        item.lectTargtCd = '초'
                    } else if(item.lectTargtCd == 101535) {
                        item.lectTargtCd = '중'
                    } else if(item.lectTargtCd == 101536) {
                        item.lectTargtCd = '고'
                    } else if(item.lectTargtCd == 101537) {
                        item.lectTargtCd = '초중'
                    } else if(item.lectTargtCd == 101538) {
                        item.lectTargtCd = '중고'
                    } else if(item.lectTargtCd == 101539) {
                        item.lectTargtCd = '초고'
                    } else if(item.lectTargtCd == 101540) {
                        item.lectTargtCd = '초중고'
                    } else if(item.lectTargtCd == 101713) {
                        item.lectTargtCd = '기타'
                    }

                    if(item.chgDtm == null) {
                        item.chgDtm = item.regDtm;
                    }
                    item.chgDtm = new Date(item.chgDtm).format('yyyy.MM.dd');

                    var strDlistUrl = mentor.contextpath + "/lecture/mentor/register/view.do?lectSer=" + item.lectSer;
                    if(item.lectTitle != null){
                        var lectTitle = "<a href=" + strDlistUrl +" class='underline'>" + item.lectTitle + "</a>";
                        item.lectTitle = lectTitle;
                    }

                    return item;
                });

                // grid data binding
                var emptyText = '등록된 데이터가 없습니다.';
                setDataJqGridTable('boardTable', 'boardArea', 1300, memberData, emptyText);
                // grid data binding

                if(rtnData != null && rtnData.length > 0) {
                    $('.board-top .total-num').html('총 <strong>' + totalCount +'</strong> 건');
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    $('.board-top .total-num').html('총 <strong>0</strong> 건');
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }
                mentor.schoolPageNavi.setData(dataSet.params);

                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    function pwdReset(sendType){
        var emailName = '${user.emailAddr}';
        if(sendType == 'EMS'){
            if(!isValidEmailAddress(emailName) || emailName == ""){
                alert("담당자 이메일을 확인해주세요.");
                return false;
            }
        }else{
            var tel = '${user.mobile}';
            if(tel.replace(/-/gi, "").length != 11){
                alert("담당자 휴대전화를 확인해주세요.");
                return false;
            }
        }
        $.ajax({
            url: "${pageContext.request.contextPath}/user/manager/changePwdAndSendMail.do",
            data : {'mbrNo':${param.mbrNo}, 'sendType':sendType},
            success: function(rtnData) {
                if(sendType == "EMS"){
                    alert("이메일이 발송되었습니다.");
                }else{
                    alert("SMS가 발송되었습니다.");
                }
            },
            error: function(xhr, status, err) {
                if(sendType == "EMS"){
                    alert("이메일이 발송이 실패하였습니다.");
                }else{
                    alert("SMS가 발송이 실패하였습니다.");
                }
            }
        });

    }

    function isValidEmailAddress(emailAddress) {
        var pattern = new RegExp(/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/);
        return pattern.test(emailAddress);
    }
</script>