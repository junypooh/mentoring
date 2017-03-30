<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

		<div class="layer-pop-wrap" id="stdoLayer">
			<div class="title">
				<strong>스튜디오 찾기</strong>
				<a href="javascript:void(0)" class="pop-close" id="popClose"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
			</div>
			<div class="layer-cont2">
				<div class="mc-search">
					<div class="mc-search-area">
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD100135_100351_지역코드'])" var="sidoNm" />
                        <select class="slt-style" title="지역선택" id="sidoCd" name="sidoCd">
                            <option value="">전체</option>
                            <c:forEach items="${sidoNm}" var="eachObj" varStatus="vs">
                            <option value="${eachObj.cdNm}">${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
						<input type="text" class="inp-style1" value="" style="width:400px" id="layerStdoNm" />
						<a href="#" class="btn-type2 search" id="aSearch"><span>검색</span></a>
					</div>
				</div>
				<div class="result-info">
					<p class="search-result"></p>
				</div>
				<div class="mc-search-list box-scroll-wrap">
					<ul class="studio-info-ul" id="listStdo">
					</ul>
				</div>
				<div class="btn-area">
					<a href="javascript:void(0)" class="btn-type2 blue" id="aConfirm">확인</a>
					<a href="javascript:void(0)" class="btn-type2 gray" id="aCancel">취소</a>
				</div>
			</div>
		</div>
<%-- Template ================================================================================ --%>
<script type="text/html" id="studioList">
    <li>
        <label for="jobSel0\${rn}" class="radio-skin" name="studioInfo">
            <span class="studio-name">\${stdoNm}</span>
            <span class="studio-floor">\${florNm}</span>
            <span class="studio-address">\${locaAddr}</span>
            <span class="studio-place">\${indrYnNm}</span>
            <input type="radio" id="jobSel0\${rn}" name="job">
            <input type="hidden" name="stdoNo" value="\${stdoNo}">
        </label>
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>

<script type="text/javascript">

    $(document).ready(function() {

        //enterFunc($("#keyword"), getAddr);

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $("#popClose").click();
            }
        });

        //검색버튼 클릭
        $("#aSearch").click(function(e){
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listStudio.do",
                data : $.param({"sidoCd":$("#sidoCd option:selected").val(), "stdoNm":$("#layerStdoNm").val()}, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");

                    $(".studio-info-ul").empty();
                    $("#studioList").tmpl(rtnData).appendTo(".studio-info-ul");
                }
            });
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();
            var labelSelector = $("label.radio-skin.checked[name='studioInfo']");

            if(labelSelector.length < 1){
                alert("선택된 스튜디오가 없습니다.");
                return false;
            }else{
                var element = {};
                element.stdoNo = labelSelector.children("input[name='stdoNo']").val();
                element.stdoNm = labelSelector.children(".studio-name").text();
                element.stdoAdr = labelSelector.children(".studio-address").text();

                ${param.callbackFunc}(element);
                $("#popClose").click();
            }
        });

        //취소버튼 클릭
        $("#aCancel").click(function(){
            $("#popClose").click();
        });

        $("#aSearch").click();


    });
</script>