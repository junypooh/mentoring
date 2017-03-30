<%@ page language="java" contentType="text/html; charset=utf-8"%>
<HTML>
<HEAD>
	<TITLE>::: 하나은행 샘플 글쓰기 폼:::</TITLE>
	<STYLE>
	<!--
		* {text-decoration:none; color:#7F7F7F; font-family:dotum; font-size:12}
		td.movieInfo {background-color:#FF0000;}
		input,Textarea {text-decoration:none; color:#7F7F7F; font-family:dotum;border: 1 solid silver; border-bottom: 1 solid silver}
	-->
	</STYLE>
	<SCRIPT>
		function goUpload(){
			window.open(
	 			"uploader.html", "",
	 			"scrollbars=no, resizeable=no, width=580, height=280"
	 		);
		}

		function playeVideo(){
			var cid = document.writeForm.contentID.value;


			if(cid.length == 0){
				alert("동영상을 업로드해주세요.");
			}else{
				window.open(
	 				"../player/index.jsp?cID="+ cid, "",
	 				"scrollbars=no, resizeable=no, width=672, height=590"
	 			);
			}
		}
	</SCRIPT>
</HEAD>
<BODY>
<CENTER>
	<TABLE border="0" width="700" cellpadding="0" cellspacing="0">
	<FORM METHOD="POST" ACTION="" NAME="writeForm">
		<TR height="30">
			<TD align="center"><BR><INPUT type="button" value="동영상 올리기" onclick="goUpload();"></TD>
		</TR>
		<tr height="30">
			<td align="center">
				<input type="text" value="" id="contentID" size="10">
				<input type="button" value="동영상 보기" onclick="playeVideo();">
			</td>
		</tr>
	</FORM>
	</TABLE>
</CENTER>
</BODY>
</HTML>