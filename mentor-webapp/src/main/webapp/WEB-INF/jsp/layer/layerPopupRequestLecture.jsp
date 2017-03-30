<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Template ================================================================================ --%>
<script type="text/html" id="requestList">
    <li>
        <label class="radio-skin" name="reqLectInfo">
            <span class="lesson-request-title" style="width:220px;padding-left:5px;">\${lectTitle}</span>
            <span class="lesson-request-status" style="width:85px;padding-left:0px;">\${schClassCdNm}</span>
            <span class="lesson-request-status">\${lectureRequestType}</span>
            <div class="lesson-request-date">
                <div class="time-list">
                    {{each lectReqTimeInfoDomain}}
                        <span>\${to_date_format(lectPrefDay, "-")} <em>\${to_time_format(lectPrefTime, ":")}</em></span>
                    {{/each}}
                </div>
                {{if lectReqTimeInfoDomain.length > 1 }}
                <div class="time-box">
                    {{each lectReqTimeInfoDomain}}
                        <span>\${to_date_format(lectPrefDay, "-")} <em>\${to_time_format(lectPrefTime, ":")}</em></span>
                    {{/each}}
                </div>
                {{/if}}
            </div>
            <input type="radio" name="job">
            <input type="hidden" name="reqSer" value="\${reqSer}">
        </label>
    </li>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>

<input type="hidden" name="schClassCds" value="${param.schClassCds}" />
<input type="hidden" name="jobNo" value="${param.jobNo}" />
<div class="layer-pop-wrap" id="layer1">
    <div class="title">
        <strong>요청수업 선택</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
    </div>
    <div class="cont type3">
        <div class="mc-search">
            <div class="mc-search-area lesson">
                <select class="slt-style" title="카테고리선택" id="category1">
                    <option value="">전체</option>
                    <%--<option>오픈</option>--%>
                    <%--<option>멘토지정</option>--%>
                    <%--<option>직업지정</option>--%>
                    <c:forEach items="${code101645}" var="item">
                        <option value="${item.cd}">${item.cdNm}</option>
                    </c:forEach>
                </select>
                <select class="slt-style" title="키워드선택" id="category2">
                    <option value="">전체</option>
                    <%--<option>수업</option>--%>
                    <%--<option>직업</option>--%>
                    <%--<option>멘토</option>--%>
                    <c:forEach items="${code101649}" var="item">
                        <option value="${item.cd}">${item.cdNm}</option>
                    </c:forEach>
                </select>
                <input type="text" class="inp-style1" value="" style="width:298px" id="keyword"/>
                <a href="#" class="btn-type2 search" id="aSearch"><span>검색</span></a>
            </div>
        </div>
        <div class="result-info">
            <%--<p class="search-result">검색 결과 <strong>총 <em>00</em> 건</strong></p>--%>
            <p class="search-result"></p>
        </div>
        <div class="mc-search-list box-scroll-wrap">
            <ul class="studio-info-ul choice">
                <%--<li>--%>
                    <%--<label class="radio-skin">--%>
                        <%--<span class="lesson-request-title">아시아나항공 공항서비스 직업특강</span>--%>
                        <%--<span class="lesson-request-status">멘토지정</span>--%>
                        <%--<span class="lesson-request-date">2015.09.20</span>--%>
                        <%--<input type="radio" name="job">--%>
                    <%--</label>--%>
                <%--</li>--%>
            </ul>
        </div>
        <div class="btn-area">
            <a href="#" class="btn-type2 blue" id="aConfirm">확인</a>
            <a href="#" class="btn-type2 gray" id="aCancle">취소</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    var isloaded = true;
    $(document).ready(function() {

        //검색버튼 클릭
        $("#aSearch").click(function(e){
            e.preventDefault();

            var schClassCds = [];
            var jobNo="";

            /* 코드 변환이 필요함 */
            if(isloaded){
                var value = $("input:hidden[name=schClassCds]").val();
                value = value.replace('101534','100731').replace('101535','100732').replace('101536','100733');

                jobNo = $("input:hidden[name=jobNo]").val();

                schClassCds = value.split(',');
            }
            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listRequestLecture.do",
                data : $.param({"category1":$("#category1 option:selected").val(), "category2":$("#category2 option:selected").val(), "keyword":$("#keyword").val(),"schClassCds": schClassCds,"jobNo": jobNo}, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");

                    $(".studio-info-ul").empty();
                    $("#requestList").tmpl(rtnData).appendTo(".studio-info-ul");

                    position_cm();
                    lessonChoice();
                    isloaded = false;
                }
            });
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();
            var labelSelector = $("label.radio-skin.checked[name='reqLectInfo']");

            if(labelSelector.length < 1){
                alert("선택된 요청수업이 없습니다.");
                return false;
            }else{
                var lectTitle = labelSelector.children(".lesson-request-title").text();
                var reqSer = labelSelector.children("input[name='reqSer']").val();

                var func = "${param.callbackFunc}";

                if(func != null){
                    eval(func).call(null, reqSer, lectTitle);
                    $(".pop-close").click();
                }
            }
        });

        //취소버튼 클릭
        $("#aCancle").click(function(e){
            $(".pop-close").click();

        });

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".pop-close").click();
            }
        });

        $("#keyword").keydown(function(e) {
            if (e.which == 13) {/* 13 == enter key@ascii */
                $("#aSearch").click();
            }
        });

        $("#aSearch").click();
        position_cm();
    });
</script>