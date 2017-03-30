<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<jsp:useBean id="now" class="java.util.Date" />
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />

<style>
.id-pw-search.mentor-detail .profile-reg .profile-list .profile img { width: 162px; height: 180px;}
</style>

<script type="text/javascript">
$().ready(function() {
    $('.radio-skin:has(:checked)').addClass('checked');
    $('.updateBelongMentor').click(function(e) {
        e.preventDefault();
        $(this).closest('form').submit();
    });
    $('.cancelBelongMentor').click(function(e) {
        e.preventDefault();
        $(this).closest('form')[0].reset();
    });


    // 멘토 기본정보 처리 ====================================================----------------------------++++++
    $('#domain-choice1').change(function() {
        $('#email-entry1').val(this.value)
            .toggle(!this.value);
    }).filter(function() { return !this.value; }).change();

    //email주소가 직접 입력 이었을 경우 지워짐,,
    $('#email-entry1').val("${cnet:splitWithIndex(user.emailAddr, '@', 1)}");

    $('#mentorBaseForm').submit(function() {
        if (!$('input[name="pwdAnsSust"]').val()) {
            alert('질문에 대한 답변을 입력하세요.');
            return false;
        }

        if (!$('#email-adrs1').val() || !$('#email-entry1').val()) {
            alert('이메일을 입력하세요.');
            return false;
        }

        $('input[name="mobile"]').val($('#dialing-code').val()+'-'+$('#number-middle').val()+'-'+$('#number-last').val());
        $('input[name="emailAddr"]').val($('#email-adrs1').val()+'@'+$('#email-entry1').val());
        $('input[name="birthday"]').val($('#birth-year').val().zf(4)+$('#birth-month').val().zf(2)+$('#birth-day').val().zf(2));
    });


    // 멘토 직업정보 처리 =======================================++++++++++++++++++++++++++++==================
    // 직업분류 추가
    $.template('jobChrstcInfo', '<li><a href="#">\${jobNm}</a><input type="hidden" name="job" value="\${jobNo}" /></li>');
    $('#jobChrstcInfoAdder').click(function(e) {
        e.preventDefault();

        // 3개까지 선택 가능
        if ($('#jobChrstcInfoSelected li').length >= 3) {
            alert('특징분류는 3개까지 선택 가능 합니다.');
            return;
        }

        if ($('#jobChrstcInfoSelected :has(:hidden[value="' + $('#jobChrstcInfoSelector option:selected').val() + '"])').length) {
            alert('추가된 특징분류 입니다.');
            return;
        }

        $.tmpl('jobChrstcInfo', {
            jobNo: $('#jobChrstcInfoSelector option:selected').val(),
            jobNm: $('#jobChrstcInfoSelector option:selected').text()
        }).appendTo('#jobChrstcInfoSelected');
        indexingJobChrstcCd();
    });

    // 직업분류 삭제
    $('#jobChrstcInfoSelected').on('click', 'li > a', function(e) {
        e.preventDefault();
        $(this).closest('li').remove();
        indexingJobChrstcCd();
    });

    // 특정분류 인덱싱
    var indexingJobChrstcCd = function() {
        $('#jobChrstcInfoSelected').find(':hidden').each(function(i, o) {
            $(o).attr('name', 'mbrJobChrstcInfos[{0}].jobChrstcCd'.format(i));
            //name="mbrJobChrstcInfos"
        });
    };

    // 1차 분류 코드 정보
    $.ajax({
        url: '${pageContext.request.contextPath}/jobClsfCd.do',
        data: { cdLv: 1 },
        success: function(rtnData) {
            $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
        },
        async: false,
        cache: false,
        type: 'post',
    });

    // 1차 분류 변경
    $('#jobLv1Selector').change(function() {
        //if (!this.value) {
            $('#jobLv2Selector').find('option:not(:first)').remove()
                .end().val('').change();
        //    return;
        //}

        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                data: { cdLv: 2, supCd: this.value },
                success: function(rtnData) {
                    $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    });

    // 2차 분류 변경
    $('#jobLv2Selector').change(function() {
        //if (!this.value) {
            $('#jobLv3Selector').find('option:not(:first)').remove()
                .end().val('').change();
        //    return;
        //}
        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                data: { cdLv: 3, supCd: this.value },
                success: function(rtnData) {
                    $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    });

    // 3차 분류 변경
    $('#jobLv3Selector').change(function() {
        //if (!this.value) {
            $('#jobInfoSelector').find('option:not(:first)').remove()
                .end().val('').change();
        //    return;
        //}
        if (this.value) {
            $.ajax('${pageContext.request.contextPath}/jobInfo.do', {
                data: { jobClsfCd: this.value },
                success: function(rtnData) {
                    $('#jobInfoSelector').loadSelectOptions(rtnData,'','jobNo','jobNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    });


    // 직업선택시 직업명 값도 설정
    $('#jobInfoSelector').change(function() {
        $('#mbrJobInfo-jobNm').val($(this).find(':selected').text());
    });


    // 등록된 직업이 있을경우 처리
    if ($('#mbrJobInfo-jobNo').val()) {
        //alert($('#mbrJobInfo-jobNo').val())
        $.ajax('${pageContext.request.contextPath}/jobClsfCdByJobNo.do', {
            data: { jobNo: $('#mbrJobInfo-jobNo').val() },
            success: function(rtnData) {
                if (!rtnData|| !rtnData.length) {
                    return;
                }
                $('#jobLv1Selector').val(rtnData[0].cd).change();
                $('#jobLv2Selector').val(rtnData[1].cd).change();
                $('#jobLv3Selector').val(rtnData[2].cd).change();
                $('#jobInfoSelector').val($('#mbrJobInfo-jobNo').val()).change();
            },
            async: false,
            cache: false,
            type: 'post',
        });
    }


    // 직업등록 레이어
    $('#openSaveJobLayer').bindFirst('click', function(e) {
        if (!$('#jobLv3Selector').val() || !$('#jobLv2Selector').val() || !$('#jobLv1Selector').val()) {
            e.stopImmediatePropagation();
            alert('3차분류 직업 선택후 직업 등록 가능.')
            return false;
        }

        initInsertJobLayer(
                $('#jobLv3Selector').val(),
                $('#jobLv3Selector option:selected').text(),
                $('#jobLv2Selector option:selected').text(),
                $('#jobLv1Selector option:selected').text());

        return false;
    });


    $('#mentorJobForm').submit(function() {
        if (!$(':hidden[name^="mbrJobChrstcInfos"]', this).length) {
            alert('특징분류를 추가하세요.');
            return false;
        }
        if (!$('select[name="mbrJobInfo.jobNo"]', this).val()) {
            alert('직업을 선택하세요.');
            return false;
        }
        if (!$(':input[name="mbrJobInfo.jobTagInfo"]', this).val()) {
            alert('태그를 입력하세요..');
            return false;
        }

    });


    // 멘토 프로필 처리 ==============================================================================
    // 프로필 사진 업로드 버튼클릭
    $('#mbrProfPicUploadBtn').click(function(e) {
        e.preventDefault();
        $('#mbrProfPicUploadForm #pic').click();
    });

    // 프로필 사진 삭제 버튼클릭
    $('#mbrProfPicDeleteBtn').click(function(e) {
        e.preventDefault();
        var selectedPicIdx = $('#profile-navi li').index($('#profile-navi li.active'));
        $('#profile-img img:eq(' + selectedPicIdx + ')')
                .attr('src', '${pageContext.request.contextPath}/images/img_epilogue_default.gif');
        $('#profile-img :hidden:eq(' + selectedPicIdx + ')').val('');
    });


    // 관련정보 복사
    var profScrpCloned = $('span.info-add:last').clone();
    $('#addMbrPropScrpInfoBtn').click(function(e) {
        e.preventDefault();
        var scrpSize = $('span.info-add').length;
        profScrpCloned.clone()
                .find('[name$="scrpClassCd"]').attr('name', 'mbrProfScrpInfos['+scrpSize+'].scrpClassCd')
                    .find('option:first-child').prop('selected', true).end().end()
                .find('[name$="scrpTitle"]').attr('name', 'mbrProfScrpInfos['+scrpSize+'].scrpTitle').val('').end()
                .find('[name$="scrpURL"]').attr('name', 'mbrProfScrpInfos['+scrpSize+'].scrpURL').val('').end()
            .insertAfter('span.info-add:last');
    });

    $('#mentorProfileForm').submit(function() {
        if (!$(':input[name="mbrProfInfo.title"]', this).val()) {
            alert('멘토 타이틀을 입력하세요.');
            return false;
        }
        if (!$(':input[name="mbrProfInfo.intdcInfo"]', this).val()) {
            alert('멘토 소개를 입력하세요.');
            return false;
        }
        if (!$(':input[name="mbrProfInfo.careerInfo"]', this).val()) {
            alert('멘토 경력을 입력하세요.');
            return false;
        }

        if (false && $(':input[name$="scrpTitle"]', this).filter(function() { return !this.value }).length) {
            alert('관련정보 제목을 입력하세요.');
            return false;
        }
        if (false && $(':input[name$="scrpURL"]', this).filter(function() { return !this.value }).length) {
            alert('관련정보 URL을 입력하세요.');
            return false;
        }
    });


    // 프로필 파일 처리 ============================================================================+++++
    $('#mbrProfPicUploadForm').ajaxForm({
        dataType: 'text',
        success: function(data) {
            var fileInfo = JSON.parse(data);
            var selectedPicIdx = $('#profile-navi li').index($('#profile-navi li.active'));
            $('#profile-img img:eq(' + selectedPicIdx + ')')
                    .attr('src', '${pageContext.request.contextPath}/fileDown.do?fileSer=' + fileInfo.fileSer);
            $('#profile-img :hidden:eq(' + selectedPicIdx + ')').val(fileInfo.fileSer);
        }
    });

    $('#mbrProfPicUploadForm #pic').change(function() {
        $(this).closest('form').submit();
    });

    // activTab
    $('.board-title:eq(${not empty param.actived ? param.actived : "0"})').addClass('active');
});

function insertJobConfirm() {
    $.template("prevRegistedJobNm","<li style='margin-bottom: 0px;padding-bottom: 0px;'><div><span>[기등록]</span><span>\${jobClsfNmLv1}</span><span>\${jobClsfNmLv2}</span><span>\${jobClsfNm}</span></div><em style='margin-top: 0px;'>\${jobNm}</em></li>");

    $('.job-classification .job-choice').find('li:gt(2)').remove();
    if(this != null && this != window){
        $(this).each(
            function(index,value){
               $.tmpl('prevRegistedJobNm', {
                           jobNm: value.jobNm,
                           jobClsfNmLv1: value.jobClsfNmLv1,
                           jobClsfNmLv2:value.jobClsfNmLv2,
                           jobClsfNm: value.jobClsfNm
                       }).appendTo('.job-classification .job-choice');
            }
        );
    }
    $('#jobLv3Selector').change();
}
</script>


<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>멘토관리</span>
        <span>멘토상세</span>
    </div>
    <div class="content">
        <h2>멘토관리</h2>
        <div class="cont">
            <div class="id-pw-search mentor-detail">
                <!-- 기본정보 -->
                <form:form modelAttribute="user" id="mentorBaseForm" action="${pageContext.request.contextPath}/mentor/belongMentor/belongMentorBaseUpdate.do">
                    <form:hidden path="mbrNo" />

                    <div class="id-search">
                        <div class="board-title">
                            <h3 class="board-tit">기본정보</h3>
                            <div>
                                <c:if test="${not empty user.chgDtm}">
                                    <span>최종 업데이트<em><fmt:formatDate value="${user.chgDtm}" pattern="yyyy.MM.dd hh:mm" /></em></span>
                                </c:if>
                                <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_mentor_management.png" alt="열기/닫기" /></a>
                            </div>
                        </div>
                        <div class="board-input-type">
                            <div class="pad20">
                                <table>
                                    <caption>기본정보 - 아이디, 이름, 생년월일, 이메일, 이메일수신, 연락처, 계정 사용 여부</caption>
                                    <colgroup>
                                        <col style="width:145px;" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th scope="row" class="compulsory">아이디</th>
                                            <td>${user.id}</td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">비밀번호찾기 질문</th>
                                            <td>
                                                <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD100211_100221_비밀번호_분실_시_확인질문'])" var="questCodes" />
                                                <form:select path="pwdQuestCd" style="width:270px;">
                                                    <form:options items="${questCodes}" itemLabel="cdNm" itemValue="cd" />
                                                </form:select>
                                                <form:input path="pwdAnsSust" class="inp-style1" style="width:410px;" placeholder="질문에 대한 답변" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">이름</th>
                                            <td>${user.username}
                                            <!--, ${code['CD100322_100323_남자'] eq user.genCd ? '남자' : '여자'} -->
                                                <span class="mgl-15">
                                                    <label class="radio-skin ${code['CD100322_100323_남자'] eq user.genCd ?'checked':''}"><form:radiobutton path="genCd" cssClass="radio-skin" value="100323"/>남자</label>
                                                    <label class="radio-skin ${code['CD100322_100324_여자'] eq user.genCd ?'checked':''}"><form:radiobutton path="genCd" cssClass="radio-skin" value="100324"/>여자</label>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">생년월일</th>
                                            <td>
                                                <form:hidden path="birthday" />
                                                <fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
                                                <select id="birth-year" style="width:80px;">
                                                    <c:forEach begin="${1}" end="${70}" var="item">
                                                        <option value="${year - item}"
                                                                <c:if test="${cnet:substring(user.birthday, 0, 4) eq (year - item)}">selected="selected"</c:if>>${year-item}</option>
                                                    </c:forEach>
                                                </select>
                                                <select id="birth-month" style="width:56px;">
                                                    <c:forEach begin="${1}" end="${12}" var="item">
                                                        <option value="${item}"
                                                                <c:if test="${cnet:substring(user.birthday, 4, 6) eq cnet:leftPad((item), 2, '0')}">selected="selected"</c:if>>${item}</option>
                                                    </c:forEach>
                                                </select>
                                                <select id="birth-day" style="width:56px;">
                                                    <c:forEach begin="${1}" end="${31}" var="item">
                                                        <option value="${item}"
                                                                <c:if test="${cnet:substring(user.birthday, 6, 8) eq cnet:leftPad((item), 2, '0')}">selected="selected"</c:if>>${item}</option>
                                                    </c:forEach>
                                                </select>
                                                <span class="mgl-15">
                                                    <c:if test="${empty user.lunarYn}">
                                                        <c:set target="${user}" property="lunarYn" value="N" />
                                                    </c:if>
                                                    <label class="radio-skin"><form:radiobutton path="lunarYn" value="N" class="radio-skin" />양력</label>
                                                    <label class="radio-skin"><form:radiobutton path="lunarYn" value="Y" class="radio-skin" />음력</label>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">이메일</th>
                                            <td>
                                                <form:hidden path="emailAddr" />
                                                <input type="text" class="inp-style1" style="width:180px;" id="email-adrs1" maxlength="50" value="${cnet:splitWithIndex(user.emailAddr, '@', 0)}"> @
                                                <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD100423_100533_이메일'])" var="emailCodes" />
                                                <select id="domain-choice1" style="width:160px;">
                                                    <option value="">직접입력</option>
                                                    <c:forEach items="${emailCodes}" var="eachObj" varStatus="vs">
                                                        <option value="${eachObj.cdNm}"
                                                                <c:if test="${cnet:splitWithIndex(user.emailAddr, '@', 1) eq eachObj.cdNm}">selected="selected"</c:if>>${eachObj.cdNm}</option>
                                                    </c:forEach>
                                                </select>
                                                <input type="text" class="inp-style1" style="width:180px;display:none;" id="email-entry1" maxlength="50" value="${cnet:splitWithIndex(user.emailAddr, '@', 1)}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">이메일수신</th>
                                            <td><%--CD100939_100944_메일수집동의 --%>
                                                <spring:bind path="agrees[0].agrClassCd">
                                                    <label class="radio-skin"><form:radiobutton path="agrees[0].agrClassCd" value="${code['CD100939_100944_메일수집동의']}" class="radio-skin" />예</label>
                                                    <label class="radio-skin"><input type="radio" name="agrees[0].agrClassCd" value="" class="radio-skin"
                                                            <c:if test="${status.value ne code['CD100939_100944_메일수집동의']}">checked="checked"</c:if> />아니오</label>
                                                </spring:bind>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">연락처</th>
                                            <td>
                                                <form:hidden path="mobile" />
                                                <spring:eval expression="{'010', '011', '016', '017', '018', '019'}" var="dialingCode" />
                                                <select id="dialing-code" title="번호앞자리 선택" style="width:80px;">
                                                    <c:forEach items="${dialingCode}" var="eachObj">
                                                        <option value="${eachObj}" <c:if test="${cnet:splitWithIndex(user.mobile, '-', 0) eq eachObj}">selected="selected"</c:if>>${eachObj}</option>
                                                    </c:forEach>
                                                </select> -
                                                <input type="text" class="inp-style1" id="number-middle" style="width:65px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 1)}" /> -
                                                <input type="text" class="inp-style1" id="number-last" style="width:65px;" maxlength="4" value="${cnet:splitWithIndex(user.mobile, '-', 2)}"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">계정 사용 여부</th>
                                            <td>
                                                <label class="radio-skin"><form:radiobutton path="loginPermYn" value="Y" class="radio-skin" />예</label>
                                                <label class="radio-skin"><form:radiobutton path="loginPermYn" value="N" class="radio-skin" />아니오</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">학교사이트 노출여부</th>
                                            <td>
                                                <label class="radio-skin"><form:radiobutton path="schSiteExpsYn" value="Y" class="radio-skin" />예</label>
                                                <label class="radio-skin"><form:radiobutton path="schSiteExpsYn" value="N" class="radio-skin" />아니오</label>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="btn-area">
                                <a href="#" class="btn-type2 updateBelongMentor">수정</a>
                                <a href="#" class="btn-type2 gray cancelBelongMentor">취소</a>
                            </div>
                        </div>
                    </div>
                </form:form>

                <!-- 직업분류 선택 -->
                <form:form modelAttribute="user" id="mentorJobForm" action="${pageContext.request.contextPath}/mentor/belongMentor/belongMentorJobUpdate.do">
                    <form:hidden path="mbrNo" />

                    <div class="pw-search">
                        <div class="board-title">
                            <h3 class="board-tit">직업분류 선택</h3>
                            <div>
                                <c:if test="${not empty user.chgDtm}">
                                    <span>최종 업데이트<em><fmt:formatDate value="${user.chgDtm}" pattern="yyyy.MM.dd hh:mm" /></em></span>
                                </c:if>
                                <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_mentor_management.png" alt="열기/닫기" /></a>
                            </div>
                        </div>

                        <div class="board-input-type">
                            <div class="pad20">
                                <table>
                                    <caption>직업분류 선택 - 직업선택, 태그</caption>
                                    <colgroup>
                                        <col style="width:122px;" />
                                        <col />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th scope="row" class="compulsory">직업선택</th>
                                            <td colspan="3">
                                                <div class="job-classification">
                                                    <ul class="job-choice">
                                                        <li>
                                                            <em>특징분류</em>
                                                            <div class="form">
                                                                <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD101512_101564_직업특성분류'])" var="jobChrstcCodes" />
                                                                <select id="jobChrstcInfoSelector" style="width:150px;">
                                                                    <c:forEach items="${jobChrstcCodes}" var="eachObj">
                                                                        <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                                                                    </c:forEach>
                                                                </select>
                                                                <a href="#" class="btn-type1" id="jobChrstcInfoAdder">추가</a>
                                                                <ul id="jobChrstcInfoSelected">
                                                                    <c:forEach items="${user.mbrJobChrstcInfos}" var="eachObj" varStatus="vs">
                                                                        <li><a href="#">${eachObj.jobChrstcCdNm}</a><form:hidden path="mbrJobChrstcInfos[${vs.index}].jobChrstcCd" /></li>
                                                                    </c:forEach>
                                                                </ul>
                                                            </div>
                                                        </li>
                                                        <li>
                                                            <em>직업분류</em>
                                                            <div class="form">
                                                                <select style="width:150px;" id="jobLv1Selector">
                                                                    <option value="">1차분류</option>
                                                                </select>
                                                                <select style="width:150px;" id="jobLv2Selector">
                                                                    <option value="">2차분류</option>
                                                                </select>
                                                                <select style="width:150px;" id="jobLv3Selector">
                                                                    <option value="">3차분류</option>
                                                                </select>
                                                            </div>
                                                        </li>
                                                        <li>
                                                            <em>직업명</em>
                                                            <div>
                                                                <input type="hidden" id="mbrJobInfo-jobNo" value="${user.mbrJobInfo.jobNo}" />
                                                                <select name="mbrJobInfo.jobNo" style="width:150px;" id="jobInfoSelector">
                                                                    <option value="">4차분류</option>
                                                                </select>
                                                                <input type="hidden" name="mbrJobInfo.jobNm" id="mbrJobInfo-jobNm" />
                                                                <a href="#jobRegPop" class="btn-type1 layer-open" id="openSaveJobLayer">직업추가</a>
                                                                <span class="job-name">※ 등록 된 직업명이 없을 경우 ‘직업추가‘ 버튼을 클릭해 직업명을 추가해주세요. </span>
                                                            </div>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">태그</th>
                                            <td>
                                                <div class="tag-layer">
                                                    <form:input path="mbrJobInfo.jobTagInfo" class="inp-style1" style="width:590px;" placeholder="태그를 쉼표로 구분합니다." maxlength="200" />
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="btn-area">
                                <a href="#" class="btn-type2 updateBelongMentor">수정</a>
                                <a href="#" class="btn-type2 gray cancelBelongMentor">취소</a>
                            </div>
                        </div>

                    </div>
                </form:form>

                <!-- 파일업로드 폼 -->
                <form id="mbrProfPicUploadForm" action="${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
                    <input type="file" name="upload_file" id="pic" style="display:none"/>
                </form>


                <!-- 프로필정보 -->
                <form:form modelAttribute="user" id="mentorProfileForm" action="${pageContext.request.contextPath}/mentor/belongMentor/belongMentorProfileUpdate.do">
                    <form:hidden path="mbrNo" />

                    <div class="email-search">
                        <div class="board-title">
                            <h3 class="board-tit">프로필정보</h3>
                            <div>
                                <c:if test="${not empty user.mbrProfInfo}">
                                    <span>최종 업데이트<em><fmt:formatDate value="${user.mbrProfInfo.chgDtm}" pattern="yyyy.MM.dd hh:mm" /></em></span>
                                </c:if>
                                <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_mentor_management.png" alt="열기/닫기" /></a>
                            </div>
                        </div>
                        <div class="board-input-type profile">
                            <div class="pad20">
                                <div class="profile-reg">
                                    <%-- <!-- 최초등록시 -->
                                    <div style="display:;">
                                        <em>프로필 사진</em>
                                        <div class="btn-area upload">
                                            <a href="#" class="btn-type4">사진업로드</a>
                                        </div>
                                        <div class="img-info">
                                            <span class="size">개별 파일 용량 20MB 및 최대 3개<br>까지 지원<br>(이미지 사이즈 162x180픽셀)</span>
                                            <ul class="img-list">
                                                <li>
                                                    <span>김멘토_프로필01김멘토_프로필01</span>
                                                    <em>(13KB)</em>
                                                    <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_job_del.gif" alt="삭제"></a>
                                                </li>
                                                <li>
                                                    <span>김멘토_프로필01김멘토_프로필01</span>
                                                    <em>(123KB)</em>
                                                    <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_job_del.gif" alt="삭제"></a>
                                                </li>
                                            </ul>
                                            <p>240MB 이하의 jpg, png, gif 파일만<br> 등록하실 수 있습니다.</p>
                                        </div>
                                    </div> --%>

                                    <!-- 등록시 이미지롤링 -->
                                    <div class="profile-list">
                                        <em>프로필 사진</em>
                                        <div class="profile">
                                            <ul class="img bxslider1" id="profile-img">
                                                <c:forEach items="${user.mbrpropicInfos}" var="eachObj" varStatus="vs">
                                                    <li><div><img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${eachObj.fileSer}" alt="프로필 사진 ${vs.count}" /></div>
                                                        <form:hidden path="mbrpropicInfos[${vs.index}].fileSer" />
                                                    </li>
                                                </c:forEach>
                                                <c:forEach begin="${fn:length(user.mbrpropicInfos) + 1}" end="3" var="eachObj">
                                                    <li><div><img src="${pageContext.request.contextPath}/images/img_epilogue_default.gif" alt="프로필 사진 ${eachObj}" /></div>
                                                        <form:hidden path="mbrpropicInfos[${eachObj - 1}].fileSer" />
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                            <ul class="navi slide-btn" id="profile-navi">
                                                <li class="active"><button type="button">사진1</button></li>
                                                <li><button type="button">사진2</button></li>
                                                <li><button type="button">사진3</button></li>
                                            </ul>
                                        </div>
                                        <div class="btn-area">
                                            <a href="#" class="btn-type4" id="mbrProfPicUploadBtn">사진업로드</a>
                                            <a href="#" class="btn-type4 del" id="mbrProfPicDeleteBtn">삭제</a>
                                        </div>
                                        <div class="img-info">
                                            <p>240MB 이하의 jpg, png, gif 파일만<br/> 등록하실 수 있습니다.</p>
                                            <span>이미지 사이즈(162X180픽셀)</span>
                                        </div>
                                    </div>
                                </div>
                                <table>
                                    <caption>프로필 정보 - 멘토 타이틀, 멘토 소개글, 학력, 경력, 수상, 저서, 관련정보</caption>
                                    <colgroup>
                                        <col style="width:118px;">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th scope="row" class="compulsory">멘토 타이틀</th>
                                            <td><form:input path="mbrProfInfo.title" class="inp-style1" style="width:500px;" maxlength="25" /></td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">멘토 소개</th>
                                            <td><form:textarea path="mbrProfInfo.intdcInfo" rows="" class="textarea" cols="" maxlength="500" /></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">학력</th>
                                            <td><form:textarea path="mbrProfInfo.schCarInfo" rows="" class="textarea" cols="" maxlength="500" /></td>
                                        </tr>
                                        <tr>
                                            <th scope="row" class="compulsory">경력</th>
                                            <td><form:textarea path="mbrProfInfo.careerInfo" rows="" style="height: 90px;" class="textarea" cols="" maxlength="500" /></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">수상</th>
                                            <td><form:textarea path="mbrProfInfo.awardInfo" rows="" class="textarea" cols="" maxlength="500" /></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">저서</th>
                                            <td><form:textarea path="mbrProfInfo.bookInfo" rows="" class="textarea" cols="" maxlength="500" /></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">관련정보</th>
                                            <td>
                                                <spring:eval expression="@codeManagementService.listCodeBySupCd(code['CD101512_101517_스크랩구분코드'])" var="scrpClassCodes" />
                                                <c:forEach items="${user.mbrProfScrpInfos}" var="eachObj" varStatus="vs">
                                                    <form:hidden path="mbrProfScrpInfos[${vs.index}].scrpSer" />
                                                    <span class="info-add">
                                                        <form:select path="mbrProfScrpInfos[${vs.index}].scrpClassCd" style="width:80px;">
                                                            <c:forEach items="${scrpClassCodes}" var="codeEachObj">
                                                                <form:option value="${codeEachObj.cd}">${codeEachObj.cdNm}</form:option>
                                                            </c:forEach>
                                                        </form:select>
                                                        <form:input path="mbrProfScrpInfos[${vs.index}].scrpTitle" class="inp-style1" style="width:181px;" maxlength="50" placeholder="제목입력" />
                                                        <form:input path="mbrProfScrpInfos[${vs.index}].scrpURL" class="inp-style1" style="width:181px;" maxlength="100" placeholder="URL입력" />
                                                    </span>
                                                </c:forEach>
                                                <c:if test="${empty user.mbrProfScrpInfos}">
                                                    <span class="info-add">
                                                        <select name="mbrProfScrpInfos[0].scrpClassCd" style="width:80px;">
                                                            <c:forEach items="${scrpClassCodes}" var="codeEachObj">
                                                                <option value="${codeEachObj.cd}">${codeEachObj.cdNm}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <input type="text" name="mbrProfScrpInfos[0].scrpTitle" class="inp-style1" style="width:181px;" maxlength="50" placeholder="제목입력" />
                                                        <input type="text" name="mbrProfScrpInfos[0].scrpURL" class="inp-style1" style="width:181px;" maxlength="100" placeholder="URL입력" />
                                                    </span>
                                                </c:if>
                                                <a href="#" class="btn-type1" id="addMbrPropScrpInfoBtn">추가</a>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="btn-area">
                                <a href="#" class="btn-type2 updateBelongMentor">수정</a>
                                <a href="#" class="btn-type2 gray cancelBelongMentor">취소</a>
                            </div>
                        </div>
                    </div>
                </form:form>

            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>


<!-- 슬라이더 처리 -->
<script type="text/javascript">
    $('.bxslider1').sistarGallery({
        $animateTime_ : 500,
        $animateEffect_ : "easeInOutQuint",
        $autoDelay : 100,
        $focusFade : 500,
        $currentNum : 1
    });
</script>

<%--직업등록 레이어 --%>
<jsp:include page="/WEB-INF/jsp/layer/layerPopupInsertJob.jsp">
    <jsp:param value="insertJobConfirm" name="callback"/>
</jsp:include>