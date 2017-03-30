<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Template ================================================================================ --%>
<script type="text/html" id="lectCopyList">
    <li>
        <label class="radio-skin" name="lectCopyInfo">
            <span class="lesson-info-title">\${lectTitle}</span>
            <span class="lesson-info-name">\${lectrNm}</span>
            <input type="radio" name="job">
            <input type="hidden" name="lectSer" value="\${lectSer}">
            <input type="hidden" name="lectGrpNo" value="\${lectGrpNo}">
            <input type="hidden" name="lectTitle" value="\${lectTitle}">
            <input type="hidden" name="lectrMbrNo" value="\${lectrMbrNo}">
            <input type="hidden" name="lectrJobNo" value="\${lectrJobNo}">
            <input type="hidden" name="lectrNm" value="\${lectrNm}">
            <input type="hidden" name="lectTypeCd" value="\${lectTypeCd}">
            <input type="hidden" name="lectTargtCd" value="\${lectTargtCd}">
            <input type="hidden" name="lectOutlnInfo" value="\${lectOutlnInfo}">
            <input type="hidden" name="lectIntdcInfo" value="\${lectIntdcInfo}">
            <input type="hidden" name="lectSustInfo" value="\${lectSustInfo}">

        </label>
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>

<div class="layer-pop-wrap" id="layer1">
    <div class="title">
        <strong>수업정보 복사</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
    </div>
    <div class="cont type3">
        <div class="mc-search">
            <div class="mc-search-area">
                <select class="slt-style" title="카테고리선택" id="category">
                    <option value="">전체</option>
                    <c:forEach items="${code101649}" var="item">
                        <option value="${item.cd}">${item.cdNm}</option>
                    </c:forEach>
                </select>
                <input type="text" class="inp-style1" value="" style="width:400px" id="keyword"/>
                <a href="#" class="btn-type2 search" id="aSearch"><span>검색</span></a>
            </div>
        </div>
        <div class="result-info">
            <p class="search-result"></p>
        </div>
        <div class="mc-search-list box-scroll-wrap">
            <ul class="studio-info-ul">
            </ul>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type2 blue" id="aConfirm">확인</a>
            <a href="#" class="btn-type2 gray">취소</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

        //검색버튼 클릭
        $("#aSearch").click(function(e){
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listLectInfo.do",
                data : $.param({"category":$("#category option:selected").val(), "keyword":$("#keyword").val()}, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");

                    $(".studio-info-ul").empty();
                    $("#lectCopyList").tmpl(rtnData).appendTo(".studio-info-ul");

                    position_cm();
                }
            });
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();
            var labelSelector = $("label.radio-skin.checked[name='lectCopyInfo']");

            if(labelSelector.length < 1){
                alert("선택된 수업이 없습니다.");
                return false;
            }else{
                var lectSer = labelSelector.children("input[name='lectSer']").val();
                var lectGrpNo = labelSelector.children("input[name='lectGrpNo']").val();
                var lectTitle = labelSelector.children("input[name='lectTitle']").val();
                var lectrMbrNo = labelSelector.children("input[name='lectrMbrNo']").val();
                var lectrJobNo = labelSelector.children("input[name='lectrJobNo']").val();
                var lectrNm = labelSelector.children("input[name='lectrNm']").val();
                var lectTypeCd = labelSelector.children("input[name='lectTypeCd']").val();
                var lectTargtCd = labelSelector.children("input[name='lectTargtCd']").val();
                var lectOutlnInfo = labelSelector.children("input[name='lectOutlnInfo']").val();
                var lectIntdcInfo = labelSelector.children("input[name='lectIntdcInfo']").val();
                var lectSustInfo = labelSelector.children("input[name='lectSustInfo']").val();

                var func = "${param.callbackFunc}";

                if(func != null){
                    eval(func).call(null, lectSer, lectGrpNo, lectTitle, lectrMbrNo, lectrJobNo, lectrNm, lectTypeCd, lectTargtCd, lectOutlnInfo, lectIntdcInfo, lectSustInfo);
                    $(".pop-close").click();
                }
            }
        });

        $("#keyword").keydown(function(e){
            if (e.which == 13){
                $("#aSearch").click();
            }
        });

        $("#aSearch").click();
        position_cm();
    });
</script>