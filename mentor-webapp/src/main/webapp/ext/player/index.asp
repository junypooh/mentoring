<%
	contentID = Request.QueryString("cID")
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>::: Sample Player :::</title>
	<STYLE>
	<!--
		* {text-decoration:none; color:#7F7F7F; font-family:dotum; font-size:12}
		input,Textarea {text-decoration:none; color:#7F7F7F; font-family:dotum;border: 1 solid silver; border-bottom: 1 solid silver}
	-->
	</STYLE>
</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" oncontextmenu="return true" onselectstart="return true" ondragstart="return true">
<TABLE border="0" width="672" height="580" cellpadding="0" cellspacing="0">
	<TR height="38">
		<td>&nbsp;<!--<img src="./images/logo.png">--></td>
	</TR>
	<TR>
		<TD align="center" valign="center" background="./images/playBG.png">
			<object id="MGPlayer" width="640" height="510"
				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000">
				<param name="movie" value="MGPlayer.swf?mode=debug&accessJS=true&cID=<%=contentID%>&isCopy=true&startTime=0&endTime=0&autoPlay=true&volume=50" />
				<param name="allowScriptAccess" value="always" />
				<param name="allowFullScreen" value="true" />
				<param name="quality" value="high" />
				<param name="wmode" value="window" />
			</object>
		</TD>
	</TR>
</TABLE>
<script type="text/javascript" src="./scripts/swfobject.js"></script>
<script type="text/javascript">
	swfobject.registerObject("MGPlayer", "10.0.0", "expressInstall.swf");
</script>
</body>
</html>