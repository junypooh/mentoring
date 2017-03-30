<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="id" property="principal.id" />
    <security:authentication var="username" property="principal.username" />
</security:authorize>

<div class="cont">
    <div class="title-bar">
        <h2>직업관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>직업관리</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="jobNo" value="${param.jobNo}" />
        <input type="hidden" name="jobLv1Selector" value="${param.jobLv1Selector}" />
        <input type="hidden" name="jobLv2Selector" value="${param.jobLv2Selector}" />
        <input type="hidden" name="jobLv3Selector" value="${param.jobLv3Selector}" />
        <input type="hidden" name="searchWord" value="${param.searchWord}" />
    </form>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-none-search">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">직업분류 <span class="red-point">*</span></th>
                    <td>
                        <select id="jobLv1Selector">
                            <option value="">1차분류</option>
                        </select>
                        <select id="jobLv2Selector">
                            <option value="">2차분류</option>
                        </select>
                        <select id="jobLv3Selector">
                            <option value="">3차분류</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">직업명 <span class="red-point">*</span></th>
                    <td>
                        <input type="text" class="text" id="jobNm" name="jobNm" />
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">등록자</th>
                    <td id="regMbrNm"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">등록일</th>
                    <td id="regDtm"></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <c:choose>
                    <c:when test="${param.jobNo ne null}">
                        <li><button type="button" class="btn-gray" onClick="fn_goDelete();"><span>삭제</span></button></li>
                        <li><button type="button" class="btn-orange" onClick="fn_goSeve();"><span>수정</span></button></li>
                        <li><button type="button" class="btn-gray" onClick="fn_goCancel();"><span>취소</span></button></li>
                    </c:when>
                    <c:otherwise>
                        <li><button type="button" class="btn-orange" onClick="fn_goSeve();"><span>등록</span></button></li>
                        <li><button type="button" class="btn-gray" onClick="fn_goCancel();"><span>취소</span></button></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
    var jobNo = '${param.jobNo}';

    $(document).ready(function(){

        if(jobNo != ''){
            fn_init();
        }else{
            $('#regMbrNm').text('${username}(${id})');
            var now = new Date();
            var year = now.getFullYear();
            var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
            var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
            var toDay = year + '.' + mon + '.' + day;
            $('#regDtm').text(toDay);
        }

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
            jobLv1Chang(this.value);
        });

        // 2차 분류 변경
        $('#jobLv2Selector').change(function() {
            jobLv2Chang(this.value);
        });


    });

    //상세데이터 조회
    function fn_init(){
        $.ajax({
            url: '${pageContext.request.contextPath}/opr/job/ajax.view.do',
            data : {'jobNo' : jobNo},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                jobLv1Chang(rtnData[0].jobClsfCdLv1);
                jobLv2Chang(rtnData[0].jobClsfCdLv2);

                $('#jobLv1Selector').val(rtnData[0].jobClsfCdLv1);
                $('#jobLv2Selector').val(rtnData[0].jobClsfCdLv2);
                $('#jobLv3Selector').val(rtnData[0].jobClsfCdLv3);
                $('#jobNm').val(rtnData[0].jobNm);
                $('#regMbrNm').val(rtnData[0].regMbrNm);

                $('#regDtm').text((new Date(rtnData[0].regDtm)).format('yyyy.MM.dd'));
            }
        });
    }

    // 1차분류 변경
    function jobLv1Chang(jobClsfCdLv1){
        $('#jobLv2Selector').find('option:not(:first)').remove()
            .end().val('').change();

        if (jobClsfCdLv1) {
            $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                data: { cdLv: 2, supCd: jobClsfCdLv1 },
                success: function(rtnData) {
                    $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    }

    // 2차분류 변경
    function jobLv2Chang(jobClsfCdLv2){
        $('#jobLv3Selector').find('option:not(:first)').remove()
            .end().val('').change();
        if (jobClsfCdLv2) {
            $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                data: { cdLv: 3, supCd: jobClsfCdLv2 },
                success: function(rtnData) {
                    $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                },
                async: false,
                cache: false,
                type: 'post',
            });
        }
    }

    // 등록 및 수정 버튼 클릭
    function fn_goSeve(){
        var msg = '등록하시겠습니까?';
        if(jobNo != ''){
            msg = '수정하시겠습니까?'
        }

        if($('#jobLv1Selector').val() == '' || $('#jobLv2Selector').val() == '' || $('#jobLv3Selector').val() == ''){
            alert('직업분류를 선택해주세요.');
            return;
        }

        if($.trim($('#jobNm').val()) == '' ){
            alert('직업명을 입력해주세요.');
            return;
        }

        if(confirm(msg)){
            var _param = {
                'jobNo' : jobNo,
                'jobClsfCdLv1' : $('#jobLv1Selector').val(),
                'jobClsfCdLv2' : $('#jobLv2Selector').val(),
                'jobClsfCdLv3' : $('#jobLv3Selector').val(),
                'jobNm' : $('#jobNm').val()
            };
            $.ajax({
                url: "${pageContext.request.contextPath}/opr/job/ajax.regist.do",
                data : _param,
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                success: function(rtnData) {
                    if(rtnData.success){
                        if(rtnData.data == '900001'){
                            alert('등록 되었습니다.');
                            //location.href = '${pageContext.request.contextPath}/opr/job/list.do';
                            goList();
                        }else if(rtnData.data == '900003'){
                            alert('수정 되었습니다.');
                            //location.href = '${pageContext.request.contextPath}/opr/job/list.do';
                            goList();
                        }else if(rtnData.data == '800016'){
                            alert('기 등록된 직업이 존재합니다');
                        }else if(rtnData.data == '900002'){
                            alert('등록 실패하였습니다.')
                        }else if(rtnData.data == '900008'){
                            alert('수정 실패하였습니다.')
                        }
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.regist.do", status, err.toString());
                }
            });

        }
    }

    // 직업정보 삭제
    function fn_goDelete(){
        if(confirm('삭제하시겠습니까?')){
            $.ajax({
                url: "${pageContext.request.contextPath}/opr/job/ajax.delete.do",
                data : {'jobNo' : jobNo},
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                success: function(rtnData) {
                    if(rtnData.success){
                        if(rtnData.data == '900004'){
                            alert('삭제 되었습니다.');
                            location.href = '${pageContext.request.contextPath}/opr/job/list.do';
                            //goList();
                        }else if(rtnData.data == '800017'){
                            alert('해당 직업명을 사용중인 멘토가 있습니다.\n멘토의 직업명을 변경 후 삭제해주세요.');
                        }else if(rtnData.data == '900009'){
                            alert('삭제 실패 하였습니다.');
                        }
                    }
                },
                error: function(err){
                    console.error("ajax.delete.do", status, err.toString());
                }
            });
        }
    }

    // 취소버튼 클릭
    function fn_goCancel(){
        //location.href = '${pageContext.request.contextPath}/opr/job/list.do';
        goList();
    }

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }
</script>