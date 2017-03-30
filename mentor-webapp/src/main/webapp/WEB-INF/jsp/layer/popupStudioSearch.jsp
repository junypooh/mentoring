<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String stdoNo = request.getParameter("stdoNo");
%>
<%-- Template ================================================================================ --%>
<script type="text/html" id="studioList">
    <li>
        <label for="jobSel01" class="radio-skin" name="studioInfo">
            <span class="studio-name">\${stdoNm}</span>
            <span class="studio-floor">\${florNm}</span>
            <span class="studio-address" title="\${locaAddr}">\${locaAddr}</span>
            <span class="studio-place">\${indrYnNm}</span>
            <input type="radio" name="job" style="width:100%;" />
            <input type="hidden" name="stdoNo" value="\${stdoNo}">
        </label>
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>

<div id="wrap" class="popup other">
    <div class="layer-pop-wrap popup">
        <div class="title">
            <strong>스튜디오 찾기</strong>
            <a href="#" class="pop-close" onclick="window.close()"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
        </div>
        <div class="layer-cont2">
            <div class="mc-search">
                <div class="mc-search-area">
                    <select class="slt-style" title="지역선택" id="sidoCd">
                        <option value="">전체</option>
                        <c:forEach items="${code100351}" var="item">
                            <option value="${item.cd}">${item.cdNm}</option>
                        </c:forEach>
                    </select>
                    <input type="text" class="inp-style1" value="" style="width:400px" id="stdoNm"/>
                    <a href="#" class="btn-type2 search" id="aSearch"><span>검색</span></a>
                </div>
            </div>
            <div class="result-info">
                <%--<p class="search-result">검색 결과 <strong>총 <em>00</em> 건</strong></p>--%>
                <p class="search-result"></p>
            </div>
            <div class="mc-search-list box-scroll-wrap">
                <ul class="studio-info-ul">
                </ul>
            </div>
            <div class="btn-area">
                <a href="#" class="btn-type2 blue" id="aConfirm">확인</a>
                <a href="#" class="btn-type2 gray" id="aCancel">취소</a>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        //검색버튼 클릭
        $("#aSearch").click(function(e){
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.stdoList.do",
                data : $.param({ "lectSer" : "${param.lectSer}", "sidoCd":$("#sidoCd option:selected").val(), "stdoNm":$("#stdoNm").val(),"lectDay":"${param.lectDay}","lectStartTime":"${param.lectStartTime}","lectEndTime":"${param.lectEndTime}"}, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");

                    $(".studio-info-ul").empty();
                    $("#studioList").tmpl(rtnData).appendTo(".studio-info-ul");

                    //position_cm();
                }
            });
        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                window.close();
            }
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();
            var labelSelector = $("label.radio-skin.checked[name='studioInfo']");

            if(labelSelector.length < 1){
                alert("선택된 스튜디오가 없습니다.");
                return false;
            }else{
                var stdoNo = labelSelector.children("input[name='stdoNo']").val();
                var stdoNm = labelSelector.children(".studio-name").text();
                var stdoAdr = labelSelector.children(".studio-address").text();

                var selectStdo = '<%=stdoNo%>';

                var _studios =  $('#selectedStudios',opener.document);

                if( _studios.length > 0){

                        $("#"+ selectStdo,opener.document).val(stdoNo);
                        $("#"+ selectStdo,opener.document).parent().find("span").text(stdoNm);

                }else{
                    $("#stdoNo",opener.document).val(stdoNo);
                    $("#stdoNo", opener.document).parent().find("span").text(stdoNm);
                }
                window.close();
            }
        });

        //취소버튼 클릭
        $("#aCancel").click(function(){
            window.close();
        });

        $("#aSearch").click();
        //position_cm();
    });
</script>