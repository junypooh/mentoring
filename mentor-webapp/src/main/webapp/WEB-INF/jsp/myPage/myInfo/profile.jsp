<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<jsp:useBean id="now" class="java.util.Date" />
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />
<security:authentication var="principal" property="principal" />

<script type="text/javascript">
$().ready(function() {

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


    // 나의 태그 보기
    $('#showTag').click(function(e) {
        e.preventDefault();
        $(this).toggleClass('active');
    });

    $('.tag-layer').on('click', '.deleteTag', function() {
        var tagInfos = $(this).closest('li').siblings()
            .map(function() { return $('a', this).text(); }).get().join(',');
        $('#mbrJobInfo-jobTagInfo').val(tagInfos);
        $(this).closest('li').remove();
    });

    $('#mbrJobInfo-jobTagInfo').blur(function() {
        $('div.tag ul').empty();
        $.each(this.value.split(','), function(i, o) {
            if (o && o.trim()) {
                $('<li><a href="#" class="deleteTag">' + o.trim() + '</a></li>')
                    .appendTo('div.tag ul');
            }
        })
    });


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

    $('#mbrProfPicUploadForm').ajaxForm({
        success: function(response) {
        var fileInfo = JSON.parse(response);
            var selectedPicIdx = $('#profile-navi li').index($('#profile-navi li.active'));
            $('#profile-img img:eq(' + selectedPicIdx + ')')
                    .attr('src', '${pageContext.request.contextPath}/fileDown.do?fileSer=' + fileInfo.fileSer);
            $('#profile-img :hidden:eq(' + selectedPicIdx + ')').val(fileInfo.fileSer);
        }
    });

    $('#mbrProfPicUploadForm #pic').change(function() {
        $(this).closest('form').submit();
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

    // 업데이트 폼
    $('#updateProfileForm').submit(function() {

        // 직업분류 선택
        if ($('#jobChrstcInfoSelector').length && !$(':hidden[name^="mbrJobChrstcInfos"]', this).length) {
            alert('특징분류를 추가하세요.');
            return false;
        }
        if ($('#jobInfoSelector').length && !$('select[name="mbrJobInfo.jobNo"]', this).val()) {
            alert('직업을 선택하세요.');
            return false;
        }

        // 프로필 정보
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
        var stringByteLength =  $(':input[name="mbrJobInfo.jobTagInfo"]', this).val();
        if(stringByteLength.replace(/[\0-\x7f]|([0-\u07ff]|(.))/g,"$&$1$2").length >= 200){
           alert('태그는 200bytes 까지 입력이 가능합니다.');
           return false;
        }
    });

    // 업데이트 버튼 클릭
    $('.updateBtn').click(function(e) {
        e.preventDefault();
        $(this).closest('form').submit();
    });
    $('.cancelBtn').click(function(e) {
        e.preventDefault();
        $(this).closest('form')[0].reset();
    });
});


// 직업등록시 콜백
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
        <span>회원정보</span>
        <span>프로필관리</span>
    </div>

    <!-- 파일업로드 폼 -->
    <form id="mbrProfPicUploadForm" action="${pageContext.request.contextPath}/uploadFile.do" method="post" enctype="multipart/form-data">
        <input type="file" name="upload_file" id="pic" style="display:none"/>
    </form>

    <form:form modelAttribute="user" action="${pageContext.request.contextPath}/myPage/myInfo/updateProfile.do" id="updateProfileForm">
        <div class="content">
            <h2>프로필 관리</h2>
            <p class="tit-desc-txt">멘토 프로필 정보를 입력할 수 있습니다. <a href="${pageContext.request.contextPath}/myPage/myInfo/myInfo.do" class="btn-profill-set">내 정보 수정</a></p>
            <div class="cont type1">
                <div class="board-title1">
                    <h3 class="board-tit">직업분류 선택</h3>
                </div>
                <div class="board-input-type all-view mgb-35">
                    <table>
                        <caption>직업분류 선택 - 직업분류, 직업명, 직업 한 줄 소개, 태그</caption>
                        <colgroup>
                            <col style="width:118px;">
                            <col>
                        </colgroup>
                        <tbody>

                            <c:if test="${empty principal.lastLoginDtm or empty user.mbrJobChrstcInfos or empty empty user.mbrJobInfo}">
                                <tr>
                                    <th scope="row" class="compulsory">직업선택</th>
                                    <td>
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
                                                    <div>
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
                            </c:if>

                            <c:if test="${not empty principal.lastLoginDtm and not empty user.mbrJobChrstcInfos and not empty user.mbrJobInfo}">
                            <input type="hidden" name="mbrJobInfo.jobNo" value="${user.mbrJobInfo.jobNo}" />
                                <tr>
                                    <th scope="row">직업분류</th>
                                    <td>
                                        <div class="job-classification">
                                            <ul>
                                                <li>
                                                    <!-- <em>특징분류</em> -->
                                                    <div>
                                                        <c:forEach items="${user.mbrJobChrstcInfos}" var="eachObj">
                                                            <span>${eachObj.jobChrstcCdNm}</span>
                                                        </c:forEach>
                                                    </div>
                                                </li>
                                                <!-- <li>
                                                    <em>직업분류</em>
                                                    <div><span>문화&middot;예술&middot;디자인&middot;방송</span></div>
                                                </li> -->
                                            </ul>
                                            <!-- <a href="#" class="btn-type1">수정요청</a>
                                            <p></p> -->
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">직업명</th>
                                    <td><%-- <form:input path="mbrJobInfo.jobNm" class="inp-style1" style="width:140px;" /> --%>
                                        <div class="job-classification">
                                            <ul>
                                                <li>
                                                    <div><span>${user.mbrJobInfo.jobNm}</span></div>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">직업 한 줄 소개</th>
                                    <td><form:input path="mbrJobInfo.jobDesc" class="inp-style1" style="width:590px;" /></td>
                                </tr>
                            </c:if>

                            <tr>
                                <th scope="row">태그</th>
                                <td>
                                    <div class="tag-layer">
                                        <form:input path="mbrJobInfo.jobTagInfo" id="mbrJobInfo-jobTagInfo" class="inp-style1" style="width:590px;" placeholder="태그를 쉼표로 구분합니다." maxlength="250" />
                                        <a href="#" class="btn-type3" id="showTag">나의 태그보기</a><!-- active 추가 시 레이어 활성화 -->
                                        <div class="tag">
                                            <ul>
                                                <c:forTokens items="${user.mbrJobInfo.jobTagInfo}" delims="," var="eachObj">
                                                    <li>
                                                        <a href="#" class="deleteTag">${eachObj}</a>
                                                    </li>
                                                </c:forTokens>
                                            </ul>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="board-title1">
                    <h3 class="board-tit">프로필</h3>
                    <span class="compulsory"><em>*</em> 표기된 항목은 필수 입력사항 입니다.</span>
                </div>

                <div class="board-input-type all-view profile">
                    <div class="profile-reg">
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
                    <table>
                        <caption>프로필 입력폼 - 멘토 타이틀, 멘토 소개글, 학력, 경력, 수상, 저서, 관련정보</caption>
                        <colgroup>
                            <col style="width:118px;">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="compulsory">멘토타이틀</th>
                                <td><form:input path="mbrProfInfo.title" class="inp-style1" style="width:500px;" maxlength="25" /></td>
                            </tr>
                            <tr>
                                <th scope="row" class="compulsory">멘토 소개글</th>
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
                <c:choose>
                    <c:when test="${empty principal.lastLoginDtm or empty user.mbrJobChrstcInfos or empty empty user.mbrJobInfo}">
                        <a href="#" class="btn-type2 updateBtn">등록</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="btn-type2 updateBtn">수정</a>
                    </c:otherwise>
                </c:choose>
                    <a href="#" class="btn-type2 gray cancelBtn">취소</a>
                </div>
            </div>
        </div>
    </form:form>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>


<script type="text/javascript">
$('.bxslider1').sistarGallery({
    $animateTime_ : 500,
    $animateEffect_ : "easeInOutQuint",
    $autoDelay : 2000,
    $focusFade : 500,
    $currentNum : 1
});
</script>


<%--직업등록 레이어 --%>
<jsp:include page="/WEB-INF/jsp/layer/layerPopupInsertJob.jsp">
    <jsp:param value="insertJobConfirm" name="callback"/>
</jsp:include>