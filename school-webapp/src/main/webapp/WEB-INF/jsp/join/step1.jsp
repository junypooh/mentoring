<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span>회원가입</span>
    </div>
    <div class="content sub">
        <h2>회원가입</h2>
        <span class="join-step-img"><img src="${pageContext.request.contextPath}/images/utility/img_join_step1.gif" alt="step1.회원분류 선택, step2.약관동의, step.3 가입정보 입력, step4.접수완료 중 step1.회원분류 선택 페이지" /></span>
        <div class="member_class">
            <span class="welcome">회원가입을 환영합니다!</span>
            <em>양방향 실시간, 원격영상 멘토링 서비스</em>
            <p>회원구분에 따라 차별화된 서비스를 제공하고 있습니다.</p>
            <strong>회원구분을 선택해주세요.</strong>
            <div class="choice-box"><form id="frm" action="step2.do">
                <ul class="select">
                    <li>
                        <div class="form">
                            <div class="design-select-box cate">
                                <select class="design-select" title="회원구분 선택" name="mbrClassCd" style="display:none;">
                                    <option value="">선택</option>
                                </select>
                            </div>
                        </div>
                        <%--<span class="check-box"><label class="chk-skin checked"><input type="checkbox" name="a" checked="checked" class="chk-skin" /></label></span> --%>
                    </li>
                    <li>
                        <div class="form">
                            <div class="design-select-box cate">
                                <select class="design-select" title="회원유형 선택" name="mbrCualfCd" style="display:none;">
                                    <option value="">선택</option>
                                </select>
                            </div>
                        </div>
                        <%--<span class="check-box"><label class="chk-skin checked"><input type="checkbox" name="a" checked="checked" class="chk-skin" /></label></span> --%>
                    </li>
                </ul></form>
                <div class="btn-area">
                    <a href="javascript:void(0)" class="btn-type2 arw" onclick="pageSubmit()">회원구분 선택 완료</a>
                </div>
            </div>
        </div>
    </div>
</div>

    <div class="cont-quick">
        <a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick2.png" alt="상단으로 이동" /></a>
    </div>

<script type="text/javascript">
$(function(){
    $("select[name='mbrClassCd']").change(function(){
        if($(this).val() === ''){
          $("select[name='mbrCualfCd']").loadSelectOptions([{"cd":"","cdNm": "선택"}],"","cd","cdNm",0);

          resetDesignSelect($("select[name='mbrCualfCd']"));
        }else{
            $.ajax({
                url: "${pageContext.request.contextPath}/code.do",
                data : {"supCd":"${code['CD100211_100204_회원구분']}","cdClsfInfo":$(this).val(), "useYn":"Y"},
                success: function(rtnData) {
                    $("select[name='mbrCualfCd']").loadSelectOptions(rtnData,"","cd","cdNm",1);

                    resetDesignSelect($("select[name='mbrCualfCd']"));
                }
            });
        }
    });

    $.ajax({
        url: "${pageContext.request.contextPath}/code.do",
        data : {"supCd":"${code['CD100211_100857_회원구분_그룹_']}"},
        success: function(rtnData) {
            var filteredData = rtnData.filter(function(code) {
                                                   return (code.cd == "${code['CD100857_100858_일반회원']}"
                                                           || code.cd == "${code['CD100857_100859_교사']}");
                                               });
            $("select[name='mbrClassCd']").loadSelectOptions(filteredData,"","cd","cdNm",1).change();

            resetDesignSelect($("select[name='mbrClassCd']"));
        }
    });
});

function pageSubmit(){
    if($("select[name='mbrClassCd']").val() == "" || $("select[name='mbrCualfCd']").val() == ""){
        alert("회원 구분을 선택해주세요");
        return false;
    }
    $("#frm").submit();
}
</script>