<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="username" property="principal.username" />
    <security:authentication var="posCoNm" property="principal.posCoNm" />
</security:authorize>
<% pageContext.setAttribute("LF", "\n"); %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>멘토회원</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>회원관리</li>
            <li>멘토회원관리</li>
            <li>가입탈퇴승인</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="mbrNo" value="${param.mbrNo}" />
        <input type="hidden" name="statChgSer" value="${param.statChgSer}" />
        <input type="hidden" name="statChgClassCd" value="${param.statChgClassCd}" />
        <input type="hidden" name="statChgRsltCd" value="${param.statChgRsltCd}" />
        <input type="hidden" name="id" value="${param.id}" />
        <input type="hidden" name="mobile" value="${param.mobile}" />
        <input type="hidden" name="name" value="${param.name}" />
        <input type="hidden" name="job" value="${param.job}" />
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
        <form:form modelAttribute="user" id="statChgForm" action="${pageContext.request.contextPath}/stat/chg/hist/submit.do">
        <input type="hidden" name="statChgClassCd" value="${user.statChgHistInfo.statChgClassCd}" />
        <input type="hidden" name="statChgTargtMbrNo" value="${user.mbrNo}" />
        <input type="hidden" name="statChgSer" value="${param.statChgSer}" />
        <input type="hidden" name="statChgRsltCd" />
        <input type="hidden" name="referType" value="managerMentorApproval" />
        <input type="hidden" name="username" value="${user.username}" />
        <input type="hidden" name="emailAddr" value="${user.emailAddr}"/>
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
                    <td colspan="4">${user.id}</td>
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
                    <td colspan="4"><spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(user.mbrProfInfo.intdcInfo)"></spring:eval></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">가입일</th>
                    <td colspan="2"><fmt:formatDate value="${user.regDtm}" pattern="yyyy.MM.dd HH:mm" /> / 최근 로그인: ${user.lastLoginDtm}</td>
                    <th scope="col" class="ta-l">사용유무</th>
                    <td><c:choose><c:when test="${user.loginPermYn eq 'Y'}">사용중</c:when><c:otherwise>사용안함</c:otherwise></c:choose></td>
                </tr>
            </tbody>
        </table>
        <!-- 반려 팝업 레이어 -->
        <div class="popup-area lesson-cancel" id="rejectEdit" style="display:none;">
            <div class="pop-title-box">
                <p class="pop-title">멘토회원 처리</p>
            </div>
            <div class="pop-cont-box">
                <table class="tbl-style">
                    <colgroup>
                        <col style="width:145px;">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="col" class="ta-l">승인상태</th>
                            <td>${user.statChgHistInfo.statChgRsltNm}</td>
                        </tr>
                        <tr>
                            <th scope="col" class="ta-l">처리자</th>
                            <td>${username} (${posCoNm})</td>
                        </tr>
                        <tr>
                            <th scope="col" class="ta-l">사유</th>
                            <td class="textarea-wrap">
                                <textarea class="textarea" cols="30" rows="10" name="statChgRsn" id="statChgRsn" placeholder="* 반려사유를 자세하게 입력하세요."></textarea>
                                <p class="over-hidden"><span class="fl-r"><strong class="red-txt" id="statChgRsnByte">0</strong> / 400 byte</span></p>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="btn-group-c">
                    <c:choose>
                    <c:when test="${user.statChgHistInfo.statChgClassCd eq codeConstants['CD101718_101719_회원가입요청상태']}">
                    <button type="button" class="btn-orange" onclick="statSubmit('${codeConstants['CD100861_100863_이용중지']}', 'NOK')"><span>저장</span></button>
                    </c:when>
                    <c:when test="${user.statChgHistInfo.statChgClassCd eq codeConstants['CD101718_101751_회원탈퇴요청상태']}">
                    <button type="button" class="btn-orange" onclick="statSubmit('${codeConstants['CD100861_100862_정상이용']}', 'NOK')"><span>저장</span></button>
                    </c:when>
                    </c:choose>
                    <button type="button" onclick="hideRejectEdit()" class="btn-gray"><span>취소</span></button>
                </div>
            </div>
            <a href="javascript:void(0)" onclick="hideRejectEdit()" class="btn-close-pop">닫기</a>
        </div>
        <!-- 반려 팝업 레이어 -->

        </form:form>
    </div>
    <div class="board-area board-area-bot" id="boardArea">
        <div class="board-top">
            <p>상세이력</p>
        </div>
        <table id="boardTable"></table>

        <c:set var="stepFinish" value="false" />
        <c:choose>
        <c:when test="${user.statChgHistInfo.statChgClassCd eq codeConstants['CD101718_101719_회원가입요청상태']}">
            <c:choose>
            <c:when test="${user.statChgHistInfo.statChgRsltCd eq codeConstants['CD100861_100862_정상이용']}">
            <c:set var="stepFinish" value="true" />
            </c:when>
            <c:when test="${user.statChgHistInfo.statChgRsltCd eq codeConstants['CD100861_100863_이용중지']}">
            <c:set var="stepFinish" value="true" />
            </c:when>
            </c:choose>
        </c:when>
        <c:when test="${user.statChgHistInfo.statChgClassCd eq codeConstants['CD101718_101751_회원탈퇴요청상태']}">
            <c:choose>
            <c:when test="${user.statChgHistInfo.statChgRsltCd eq codeConstants['CD100861_100864_탈퇴']}">
            <c:set var="stepFinish" value="true" />
            </c:when>
            <c:when test="${user.statChgHistInfo.statChgRsltCd eq codeConstants['CD100861_100862_정상이용']}">
            <c:set var="stepFinish" value="true" />
            </c:when>
            </c:choose>
        </c:when>
        </c:choose>

        <div style="display:none;" id="rejectRsn">
            <div class="board-top">
                <p>반려사유</p>
            </div>
            <div class="return-reason">
                <p></p>
            </div>
        </div>
        <div class="board-bot">
            <ul>
                <c:if test="${!stepFinish}">
                    <c:choose>
                    <c:when test="${user.statChgHistInfo.statChgClassCd eq codeConstants['CD101718_101719_회원가입요청상태']}">
                <li><button type="button" class="btn-orange" onclick="statSubmit('${codeConstants['CD100861_100862_정상이용']}', 'OK')"><span>승인</span></button></li>
                <li><button type="button" class="btn-gray" onclick="showRejectEdit()"><span>반려</span></button></li>
                    </c:when>
                    <c:when test="${user.statChgHistInfo.statChgClassCd eq codeConstants['CD101718_101751_회원탈퇴요청상태']}">
                <li><button type="button" class="btn-orange" onclick="statSubmit('${codeConstants['CD100861_100864_탈퇴']}', 'OK')"><span>승인</span></button></li>
                <li><button type="button" class="btn-gray" onclick="showRejectEdit()"><span>반려</span></button></li>
                    </c:when>
                    </c:choose>
                </c:if>
                <li><button type="button" class="btn-style02" onclick="goList()"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">

    $().ready(function() {
        $('#statChgRsn').bind('keyup', function(e) {

            var textLength = $.trim(this.value).length;
            var normalChar = "";
            var byteCnt = 0;
            for (i = 0; i < textLength; i++) {
                var charTemp = this.value.charAt(i);
                if (escape(charTemp).length > 4) {
                    byteCnt += 2;
                } else {
                    byteCnt += 1;
                }

                if(byteCnt <= 400) {
                    normalChar += charTemp;
                }
            }
            if( byteCnt > 400){
                alert("입력 가능한 최대 글자수는 한글 200자, 영문 400자입니다.");
                this.value = normalChar;
                byteCnt = 0;
                var textLength = $.trim(this.value).length;
                for (i = 0; i < textLength; i++) {
                    var charTemp = this.value.charAt(i);
                    if (escape(charTemp).length > 4) {
                        byteCnt += 2;
                    } else {
                        byteCnt += 1;
                    }

                    if(byteCnt <= 400) {
                        normalChar += charTemp;
                    }
                }
                $('#statChgRsnByte').text(byteCnt);
            }
            $('#statChgRsnByte').text(byteCnt);

            return false;
        });
    });


    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

    //var data = JSON.parse('${statChgHist}');
    var data = ${statChgHist};

    // 반려사유
    var rejectRsn = '';
    $.each(data, function() {
        if(!String(this.statChgRsn).isEmpty() && this.statChgRsn != null) {
            rejectRsn = this.statChgRsn;
        }
    });

    if(!String(rejectRsn).isEmpty()) {
        $('#rejectRsn').css('display','block');
        $('.return-reason > p').html(rejectRsn.replace( /[\r\t\n]/g, "<br /> " ));
    }

    //jqGrid setting
    var colModels = [];
    colModels.push({label:'번호', name:'rn', index:'rn', width:25, align:'center', sortable: false});
    colModels.push({label:'구분', name:'statChgClassNm', index:'statChgClassNm', width:60, align:'center', sortable: false});
    colModels.push({label:'상태', name:'status', index:'status', width:60, align:'center', sortable: false});
    colModels.push({label:'요청일/승인일', name:'regDtm', index:'regDtm', width:60, align:'center', sortable: false});
    colModels.push({label:'요청/승인자', name:'regMbrNm', index:'regMbrNm', width:70, align:'center', sortable: false});

    initJqGridTable('boardTable', 'boardArea', 1300, colModels, false);
    //jqGrid setting

    var histData = data.map(function(item, index) {
        item.rn = index + 1;
        item.regDtm = new Date(item.regDtm).format('yyyy.MM.dd');
        item.statChgClassNm = (item.statChgClassNm).substring(0,4);

        if ( item.statChgClassCd == '${codeConstants['CD101718_101719_회원가입요청상태']}' ) {
            if( item.statChgRsltCd == '${codeConstants['CD100861_101506_승인요청']}' ) {
                item.status = '승인요청';
            } else if( item.statChgRsltCd == '${codeConstants['CD100861_100862_정상이용']}' ) {
                item.status = '승인완료';
                if(!String(item.coNm).isEmpty()) {
                    item.regMbrNm = item.regMbrNm + '(' + item.coNm + ')';
                }
            } else if( item.statChgRsltCd == '${codeConstants['CD100861_100863_이용중지']}' ) {
                item.status = '반려';
                if(!String(item.coNm).isEmpty()) {
                    item.regMbrNm = item.regMbrNm + '(' + item.coNm + ')';
                }
            }
        } else if ( item.statChgClassCd == '${codeConstants['CD101718_101751_회원탈퇴요청상태']}' ) {
            if( item.statChgRsltCd == '${codeConstants['CD100861_101572_탈퇴요청']}' ) {
                item.status = '승인요청';
            } else if( item.statChgRsltCd == '${codeConstants['CD100861_100864_탈퇴']}' ) {
                item.status = '승인완료';
                if(!String(item.coNm).isEmpty()) {
                    item.regMbrNm = item.regMbrNm + '(' + item.coNm + ')';
                }
            } else if( item.statChgRsltCd == '${codeConstants['CD100861_100862_정상이용']}' ) {
                item.status = '반려';
                if(!String(item.coNm).isEmpty()) {
                    item.regMbrNm = item.regMbrNm + '(' + item.coNm + ')';
                }
            }
        }

        return item;
    });

    // grid data binding
    var emptyText = '등록된 데이터가 없습니다.';
    setDataJqGridTable('boardTable', 'boardArea', 1300, histData, emptyText);
    // grid data binding

    function statSubmit(statChgRsltCd, type) {
        var confirmMsg = '';
        if(type == 'OK') {
            confirmMsg = '승인하시겠습니까?';
        } else {
            confirmMsg = '반려하시겠습니까?';

            if($('#statChgRsnByte').text() == '0') {
                alert('반려 사유를 입력하세요.');
                return;
            }
        }

        if(confirm(confirmMsg)) {
            $('input[name="statChgRsltCd"]').val(statChgRsltCd);
            $('#statChgForm').submit();
        }
    }

    function showRejectEdit() {
        $('#statChgRsn').val('');
        $('#statChgRsnByte').text('0');
        $('#rejectEdit').css('display','block');
    }

    function hideRejectEdit() {
        $('#rejectEdit').css('display','none');
    }
</script>