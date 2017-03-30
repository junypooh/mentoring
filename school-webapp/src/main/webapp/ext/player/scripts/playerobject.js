function playerLoad(cid,width,height){	

	document.write("<object id='MGPlayer' width='"+width+"' height='"+height+"' classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'>");
	document.write("<param name='WindowlessVideo' value='1'>");
	document.write("	<param name='movie' value='http://movie.career.go.kr/test/player/MGPlayer.swf?mode=debug&accessJS=true&cID="+cid+"&isCopy=true&startTime=0&endTime=0&autoPlay=false&volume=50' />");
	document.write("	<param name='allowScriptAccess' value='always' />");
	document.write("	<param name='allowFullScreen' value='true' />");
	document.write("	<param name='quality' value='high' />");
	document.write("	<param name='wmode' value='transparent' />");
	document.write("	<param name='seamlessTabbing' value='true' />");
	document.write("	<param name='preventDefault' value='false' />");
	document.write("	<param name='focusToStage' value='false' />");
	document.write("	<object name='MGPlayer' type='application/x-shockwave-flash' width='"+width+"' height='"+height+"' data='http://movie.career.go.kr/test/player/MGPlayer.swf?mode=service&accessJS=true&cid="+cid+"&ctid=0&isCopy=true&startTime=0&endTime=0&autoPlay=false&volume=50'>");
	document.write("		<param name='WindowlessVideo' value='1'>");
	document.write("		<param name='allowScriptAccess' value='always' />");
	document.write("		<param name='allowFullScreen' value='true' />");
	document.write("		<param name='quality' value='high' />");
	document.write("		<param name='wmode' value='transparent' />");
	document.write("		<param name='seamlessTabbing' value='true' />");
	document.write("		<param name='preventDefault' value='false' />");
	document.write("		<param name='focusToStage' value='false' />");
	document.write("		<p>해당 콘텐츠는 플래시 플레이어 10 이상에서 정상적으로 작동합니다.</p>");
	document.write("		<p><a href='http://www.adobe.com/go/getflashplayer'><img src='http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif' border='0' alt='Get Adobe Flash player' title='Get Adobe Flash player' /></a></p>");
	document.write("	</object>");
	document.write("</object>");
}