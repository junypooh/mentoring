<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="layer-pop">
    <div class="layer-header">
        <strong class="title">동영상보기</strong>
    </div>
    <div class="layer-cont">
        <div style="text-align:center">
            <object id="MGPlayer" width="600" height="510" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" style="visibility: visible;">
                <param name="movie" value="${pageContext.request.contextPath}/ext/player/MGPlayer.swf?mode=service&accessJS=true&cID=${param.cId}&isCopy=true&startTime=0&endTime=0&autoPlay=false&volume=50">
                <param name="allowScriptAccess" value="always">
                <param name="allowFullScreen" value="true">
                <param name="quality" value="high">
                <param name="wmode" value="window">
                <!--[if !IE]>-->
                <object name="MGPlayer" type="application/x-shockwave-flash" width="600" height="510" data="${pageContext.request.contextPath}/ext/player/MGPlayer.swf?mode=service&accessJS=true&cID=${param.cId}&isCopy=true&startTime=0&endTime=0&autoPlay=false&volume=50">
                    <param name="allowScriptAccess" value="always">
                    <param name="allowFullScreen" value="true">
                    <param name="quality" value="high">
                    <param name="wmode" value="window">
                    <!--<![endif]-->
                    <p>
                        해당 콘텐츠는 플래시 플레이어 10 이상에서 정상적으로 작동합니다.
                    </p>
                    <p>
                        <a href="http://www.adobe.com/go/getflashplayer">
                            <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" border="0" alt="Get Adobe Flash player" title="Get Adobe Flash player">
                        </a>
                    </p><!--[if !IE]>-->
                </object><!--<![endif]-->
            </object>
        </div>
        <div class="btn-area popup">
		    <a href="#" class="btn-type2 cancel" onclick="window.close()">닫기</a>
		</div>
		<a href="#" class="layer-close" onclick="window.close()">팝업 창 닫기</a>
	</div>
</div>


<script type="text/javascript" src="${pageContext.request.contextPath}/ext/player/scripts/swfobject.js"></script>
<script type="text/javascript">
    swfobject.registerObject("MGPlayer", "10.0.0", "${pageContext.request.contextPath}/ext/player/scripts/expressInstall.swf");
</script>
