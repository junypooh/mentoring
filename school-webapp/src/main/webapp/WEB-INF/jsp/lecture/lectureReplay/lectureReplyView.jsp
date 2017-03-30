<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String browser = request.getHeader("User-Agent");
boolean mobile = false;
if(browser.indexOf("Android") > 0) {
    mobile = true;
}
if(browser.indexOf("iPhone") > 0) {
    mobile = true;
}
if(browser.indexOf("iPad") > 0) {
    mobile = true;
}
%>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">HOME</a>
        <span class="first">수업</span>
        <span>수업다시보기</span>
    </div>
    <div class="content sub">
        <h2>수업다시보기</h2>
        <div class="lesson-replay-video">
            <h3 id="title"></h3>
            <div class="movie_area">
<% if(mobile) { %>
                <video id="moviePlayer" controls="controls" width="100%" height="100%"></video>
<% } else { %>
                <object id="MGPlayer" width="640" height="510" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" style="visibility: visible;">
                        <param name="movie" value="${pageContext.request.contextPath}/ext/player/MGPlayer.swf?mode=service&accessJS=true&cID=${param.cId}&isCopy=true&startTime=0&endTime=0&autoPlay=false&volume=50">
                        <param name="allowScriptAccess" value="always">
                        <param name="allowFullScreen" value="true">
                        <param name="quality" value="high">
                        <param name="wmode" value="window">
                        <!--[if !IE]>-->
                        <object name="MGPlayer" type="application/x-shockwave-flash" width="640" height="510" data="${pageContext.request.contextPath}/ext/player/MGPlayer.swf?mode=service&accessJS=true&cID=${param.cId}&isCopy=true&startTime=0&endTime=0&autoPlay=false&volume=50">
                            <param name="allowScriptAccess" value="always">
                            <param name="allowFullScreen" value="true">
                            <param name="quality" value="high">
                            <param name="wmode" value="window">
                            <!--<![endif]-->
                            <p>
                                해당 콘텐츠는 플래시 플레이어 10 이상에서 정상적으로 작동합니다.
                            </p>
                            <p>
                                <a href="http://www.adobe.com/go/getflashplayer"><img
                                src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif"
                                border="0" alt="Get Adobe Flash player"
                                title="Get Adobe Flash player"></a>
                            </p><!--[if !IE]>-->
                        </object><!--<![endif]-->
                    </object>
<% } %>
            </div>
            <h4>자막</h4>
            <div class="text_bar">
                <textarea cols="10" rows="10" title="동영상 내용 설명" id="contntsSust" readonly="readonly"></textarea>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/ext/player/scripts/swfobject.js"></script>
<script type="text/javascript">
    swfobject.registerObject("MGPlayer", "10.0.0", "${pageContext.request.contextPath}/ext/player/scripts/expressInstall.swf");
</script>

<script type="text/javascript">

$(document).ready(function() {
    getReplayInfo();
});

function getReplayInfo() {
    $.ajax({
        url: '${pageContext.request.contextPath}/community/ajax.replayView.do',
        data : {'arclSer':'${param.arclSer}'},
        success: function(rtnData) {
            $("#contntsSust").val(rtnData.cntntsSust);
            $("#title").text(rtnData.lectTitle);
            <% if(mobile) { %>
            $("#moviePlayer").attr("src", rtnData.cntntsApiPath.replace("rtmp","http").replace("mp4:",""));
            <% } %>
        }
    });
}

</script>