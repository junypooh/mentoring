<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="layer-pop-wrap" id="layer1">
    <div class="title">
        <strong>스튜디오 및 MC 수정</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
    </div>
<form:form commandName="resultLectInfo" method="post" id="schdfrm" >
    <form:input type="hidden" path="lectSer" id="lectSer" value="${resultLectInfo.lectSer}"/>
    <form:input type="hidden" path="lectTims" id="lectTims" value="${resultLectInfo.lectTims}"/>
    <form:input type="hidden" path="schdSeq" id="schdSeq" value="${resultLectInfo.schdSeq}"/>
    <div class="layer-cont2">
        <div class="studio-search-list">
            <div class="lesson-add-wrap">
                <strong class="title-640">수업일시</strong>
                    <form:input type="hidden" path="lectDay" id="lectDay" value="${resultLectInfo.lectDay}"/>
                    <form:input type="hidden" path="lectStartTime" id="lectStartTime" value="${resultLectInfo.lectStartTime}"/>
                    <form:input type="hidden" path="lectEndTime" id="lectEndTime" value="${resultLectInfo.lectEndTime}"/>
                    <fmt:parseDate value="${resultLectInfo.lectDay}" var="lectDay" pattern="yyyyMMdd"/>
                    <fmt:parseDate value="${resultLectInfo.lectStartTime}" var="lectStartTime" pattern="HHmm"/>
                    <fmt:parseDate value="${resultLectInfo.lectEndTime}" var="lectEndTime" pattern="HHmm"/>
                    <span class="studio-date"><fmt:formatDate value="${lectDay}" pattern="yyyy.MM.dd"/> <fmt:formatDate value="${lectStartTime}" pattern="HH:mm"/>~<fmt:formatDate value="${lectEndTime}" pattern="HH:mm"/></span>
            </div>
            <div class="lesson-add-wrap other">
                <div class="lesson-add-wrap">
                    <input type="hidden" id="stdoNo" name="stdoNo" value="${resultLectInfo.stdoNo}">
                    <strong>스튜디오</strong>
                    <label class="radio-skin">사용안함
                        <input type="radio" name="studioNo" id="radioStudio1" />
                    </label>
                    <label class="radio-skin checked">사용
                        <input type="radio" name="studioNo" id="radioStudio2" />
                    </label>
                    <a href="#" class="studio-search">스튜디오 찾기</a>
                    <span id="stdoNm">${resultLectInfo.stdoNm}</span>
                </div>
                <div class="lesson-add-wrap">
                    <input type="hidden" id="mcNo" name="mcNo" value="${resultLectInfo.mcNo}">
                    <strong>MC</strong>
                    <label class="radio-skin">지정안함
                        <input type="radio" name="microNo" id="radioMc1" />
                    </label>
                    <label class="radio-skin checked">직접 지정
                        <input type="radio" name="microNo" id="radioMc2" />
                    </label>
                    <a href="#" class="mc-search">MC 찾기</a>
                    <span>${resultLectInfo.mcNm}</span>
                </div>
            </div>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type2 blue" onclick="fnUpdateMcStdo()">확인</a>
            <a href="#" class="btn-type2 gray" onclick="fnClosePopup()">취소</a>
        </div>
    </div>
</form:form>
</div>
<!-- 직업검색 -->
<script type="text/javascript">
    $(document).ready(function() {
        position_cm();

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                fnClosePopup();
            }
        });

        $(".studio-search").click(function(){
            var stdoUrl = mentor.contextpath + "/layer/popupStudioSearch.do?lectSer="+$("#lectSer").val() + "&stdoNo="+$("#stdoNo").val() +"&lectDay=" + $("#lectDay").val() + "&lectStartTime=" + $("#lectStartTime").val() +  "&lectEndTime=" + $("#lectEndTime").val();
            var popobj = window.open(stdoUrl, 'popupStudioSearch', 'width=660, height=670, menubar=no, status=no, toolbar=no');
            popobj.focus();
        });

        $(".mc-search").click(function(){
            var mcUrl = mentor.contextpath + "/layer/popupMcSearch.do?lectSer="+$("#lectSer").val() + "&mcNo="+$("#mcNo").val() +"&lectDay=" + $("#lectDay").val() + "&lectStartTime=" + $("#lectStartTime").val() +  "&lectEndTime=" + $("#lectEndTime").val();
            var popobj = window.open(mcUrl, 'popupMcSearch', 'width=660, height=670, menubar=no, status=no, toolbar=no');
            popobj.focus();
        });

        $(function(){
            $("input:radio[name='studioNo']").click(function(){
                if($("#radioStudio2").is(":checked")){
                    $(".studio-search").show();
                }else{
                    $("#stdoNo").val("");
                    $(this).parent().parent().find("span").text("");
                    $(".studio-search").hide();
                }
            });
        });
        $(function(){
            $("input:radio[name='microNo']").click(function(){
                if($("#radioMc2").is(":checked")){
                    $(".mc-search").show();
                }else{
                    $("#mcNo").val("");
                    $(this).parent().parent().find("span").text("");
                    $(".mc-search").hide();
                }
            });
        });
    });

    function fnUpdateMcStdo(){
        if($("#radioMc2").parent().hasClass("checked") && $("#mcNo").val() == ""){
            alert("MC를 지정하세요.");
            return false;
        }

        if($("#radioStudio2").parent().hasClass("checked") && $("#stdoNo").val() == ""){
            alert("스튜디오를 지정하세요.");
            return false;
        }

        if(!confirm("수정 하시겠습니까?")) {
            return false;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/layer/updateMcStdo.do',
            data : $("#schdfrm").serialize(),
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    $(".layer-pop-wrap").find(".btn-type2.gray").trigger('click');
                    fn_search(dataSet.params.currentPageNo);
                }else{
                    alert(rtnData.message);
                }
            }
        });

        fnClosePopup();
    }

    function fnClosePopup(){
        $(".pop-close").click();
    }
</script>