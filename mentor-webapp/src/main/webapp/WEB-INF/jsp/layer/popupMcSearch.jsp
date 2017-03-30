<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String mcNo = request.getParameter("mcNo");
%>
<%-- Template ================================================================================ --%>
<script type="text/html" id="mcList">
    <li>
        <label for="jobSel01" class="radio-skin" name="mcInfo">
            <span class="job-subject">\${mcNm}</span>
            <span class="sort">\${stdoNm}</span>
            <span class="job-sort">\${contTel}</span>
            <input type="radio" name="job" style="width:100%;" />
            <input type="hidden" name="mcNo" value="\${mcNo}">
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
            <strong>MC 찾기</strong>
            <%--<a href="#" class="pop-close"><img src="../images/common/btn_popup_close.png" alt="팝업 닫기"/></a>--%>
            <a href="#" class="pop-close" onclick="window.close()"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
        </div>
        <div class="layer-cont2">
            <div class="mc-search">
                <div class="mc-search-area">
                    <input type="text" class="inp-style1" value="" style="width:532px" id="keyword"/>
                    <a href="#" class="btn-type2 search" id="aSearch"><span>검색</span></a>
                </div>
            </div>
            <div class="result-info">
                <%--<p class="search-result">검색 결과 <strong>총 <em>00</em> 건</strong></p>--%>
                <p class="search-result"></p>
            </div>
            <div class="mc-search-list box-scroll-wrap">
                <ul id="mcListArea">
                    <!--<li class="no-result">
                        검색 결과가 없습니다.
                    </li>-->
                    <%--<li>--%>
                        <%--<label for="jobSel01" class="radio-skin">--%>
                            <%--<span class="job-subject">방은솔</span>--%>
                            <%--<span class="sort">코리아보드게임즈</span>--%>
                            <%--<span class="job-sort">010-0000-0000</span>--%>
                            <%--<input type="radio" id="jobSel01" name="job">--%>
                        <%--</label>--%>
                    <%--</li>--%>
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

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                window.close();
            }
        });

        //검색버튼 클릭
        $("#aSearch").click(function(e){
            e.preventDefault();
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listMc.do",
                data : $.param({"mcNm":$("#keyword").val(),"mcNo":"${param.mcNo}","lectSchdInfoDomain.lectDay":"${param.lectDay}","lectSchdInfoDomain.lectStartTime":"${param.lectStartTime}","lectSchdInfoDomain.lectEndTime":"${param.lectEndTime}"}, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");
                    $("#mcListArea").empty();
                    $("#mcList").tmpl(rtnData).appendTo("#mcListArea");

                    //position_cm();
                }
            });
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();
            var labelSelector = $("label.radio-skin.checked[name='mcInfo']");

            if(labelSelector.length < 1){
                alert("선택된 MC가 없습니다.");
                return false;
            }

            var mcNo = labelSelector.children("input[name='mcNo']").val();
            var mcNm = labelSelector.children(".job-subject").text();

            var _mcs =  $('#selectedMcs',opener.document);

            if( _mcs.length > 0){
                var selectMc = '<%=mcNo%>';
                $("#"+selectMc,opener.document).val(mcNo);
                $("#"+ selectMc,opener.document).parent().find("span").text(mcNm);
            }else{
                $("#mcNo" ,opener.document).val(mcNo);
                $("#mcNo" ,opener.document).parent().find("span").text(mcNm);
            }
            window.close();
        });

        //취소버튼 클릭
        $("#aCancel").click(function(){
            window.close();
        });

        $("#aSearch").click();
        //position_cm();
    });
</script>