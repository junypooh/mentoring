<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div class="layer-pop-wrap w710"  id="layPopupMvPlay" style="display: block;">
    <c:choose>
    <c:when test="${empty param.cId}">
		<div class="title">
			<strong>멘토링 샘플영상</strong>
			<a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"></a>
		</div>
		<div class="cont board">
			<div class="box-style request-lesson">
				<div class="video-data-frame">
					<img src="${pageContext.request.contextPath}/images/popup/img_movie_area.jpg" alt="동영상이미지">
				</div>
			</div>
		</div>
    </c:when>
    <c:otherwise>
        <div class="title">
            <strong>동영상 수업자료</strong>
            <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"></a>
        </div>
        <div class="cont board">
            <div class="box-style request-lesson">
                <p class="video-data-tit">${param.title}</p>
                <div class="video-data-frame">
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
            </div>
        </div>
    </c:otherwise>
    </c:choose>
</div>

<script type="text/javascript" src="${pageContext.request.contextPath}/ext/player/scripts/swfobject.js"></script>
<script type="text/javascript">
    swfobject.registerObject("MGPlayer", "10.0.0", "${pageContext.request.contextPath}/ext/player/scripts/expressInstall.swf");

    $('.pop-close').click(function() {
        window.close();
    });
</script>
