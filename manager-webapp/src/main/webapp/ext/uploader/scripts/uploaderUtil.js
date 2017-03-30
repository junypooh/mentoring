	var com = new Object();	//Package Definition
	com.zodiack = {};
	com.zodiack.uploader = {};
	com.zodiack.uploader.utils = function(){
		com.zodiack.uploader.utils.contentID = 0;
		com.zodiack.uploader.utils.thumbCheckResult = 0;
		com.zodiack.uploader.utils.vodTransResult = 0;
		com.zodiack.uploader.utils.vodDuration = 0.0;
		com.zodiack.uploader.utils.vodURL = "";
		com.zodiack.uploader.utils.thumbURL = "";
	}

	com.zodiack.uploader.utils.getObject = function(id, name){
		var targetObject;

  		if(com.zodiack.uploader.utils.browserCheck() == "msie"){
  			targetObject = document.getElementById(id);
  		}else{
  			targetObject = document.getElementsByName(name)[0];
  		}

  		return targetObject;
  	}

  	com.zodiack.uploader.utils.browserCheck = function(){
		var agt = navigator.userAgent.toLowerCase();

		if (agt.indexOf("opera") != -1) return 'opera';
		if (agt.indexOf("staroffice") != -1) return 'staroffice';
		if (agt.indexOf("webtv") != -1) return 'webtv';
		if (agt.indexOf("beonex") != -1) return 'beonex';
		if (agt.indexOf("chimera") != -1) return 'chimera';
		if (agt.indexOf("netpositive") != -1) return 'netpositive';
		if (agt.indexOf("phoenix") != -1) return 'phoenix';
		if (agt.indexOf("firefox") != -1) return 'firefox';
		if (agt.indexOf("safari") != -1) return 'safari';
		if (agt.indexOf("skipstone") != -1) return 'skipstone';
		if (agt.indexOf("msie") != -1) return 'msie';
		if (agt.indexOf("netscape") != -1) return 'netscape';
		if (agt.indexOf("mozilla/5.0") != -1) return 'mozilla';
	}

	com.zodiack.uploader.utils.printErrMsg = function(mode, errMsg){
	    console.err(errMsg);
		if(mode == "DEV"){
			$("#debugArea").val(errMsg);
		}else{
			alert("일시적으로 오류가 발생하였습니다.\n관리자에게 문의해주세요.");
			//alert(errMsg); //@@@
		}
	}

	com.zodiack.uploader.utils.printTraceMsg = function(traceMsg){
		console.log(traceMsg);
	    var totalMsg = $("#traceArea").val();
		totalMsg += "\n"+ traceMsg;

		$("#traceArea").val(totalMsg);

		//alert(traceMsg); //@@@
	}

	$("#errorMsgDelBtn").click(function(e){
  		$("#debugArea").val("");
	});

	$("#traceMsgDelBtn").click(function(e){
  		$("#traceArea").val("");
	});

	$("#transCompBtn").hide("fast");
  	var mgUploaderObj = com.zodiack.uploader.utils.getObject("MGUploader", "MGUploader");

  	com.zodiack.uploader.utils.vodUploadFinished = function(cID){
  		com.zodiack.uploader.utils.contentID = cID;

  		com.zodiack.uploader.utils.printTraceMsg("업로드한 동영상번호 : " + cID);

  		/*동영상 업로드만 하고 CID값 갱신 kpm*/
  		opener.document.frm.CID.value = com.zodiack.uploader.utils.contentID;
  	}

  	com.zodiack.uploader.utils.thumbCheckFinished = function(result){
  		com.zodiack.uploader.utils.thumbCheckResult = result;

  		com.zodiack.uploader.utils.printTraceMsg("썸네일 추출여부 : " + result);
  	}

  	com.zodiack.uploader.utils.vodTransFinished = function(result, dur, vod, thumb){
  	    com.zodiack.uploader.utils.vodTransResult = result;
  		com.zodiack.uploader.utils.vodDuration = dur;
  		com.zodiack.uploader.utils.vodURL = vod;
  		com.zodiack.uploader.utils.thumbURL = thumb;
  		var resultMsg = "변환결과 : "+ result +", 동영상 재생시간 : "+ dur +", 동영상 URL : "+ vod +", 대표이미지 URL : "+ thumb;
  		com.zodiack.uploader.utils.printTraceMsg(resultMsg);
        opener.checkResult(com.zodiack.uploader.utils.contentID, result, dur, vod, thumb);
  		if(com.zodiack.uploader.utils.vodTransResult > 0){
  			alert("변환이 완료되었습니다.");
  			//self.close();
  		}
  	}

  	com.zodiack.uploader.utils.thumbUploadFinished = function(){
  		if(com.zodiack.uploader.utils.contentID > 0 && com.zodiack.uploader.utils.thumbCheckResult > 0){
  			$("#updCompBtn").hide("fast");
			$("#transCompBtn").show("fast");
  		}else{
  			alert("썸네일이 제대로 등록되지 않았습니다.");
  		}
  	}

  	$("#updCompBtn").click(function(e){
  		if(com.zodiack.uploader.utils.contentID > 0 && com.zodiack.uploader.utils.thumbCheckResult > 0){
  			$("#updCompBtn").hide("fast");
			$("#transCompBtn").show("fast");

			mgUploaderObj.startTransCheck();
  		}else{
  			alert("동영상 업로드 및 이미지 추출을 완료해주세요.");
		}
	});

	$("#transCompBtn").click(function(e){
		if(com.zodiack.uploader.utils.vodTransResult > 0){
		    console.log(com.zodiack.uploader.utils.vodTransResult);
	        console.log(com.zodiack.uploader.utils.vodDuration);
	        console.log(com.zodiack.uploader.utils.vodURL);
	        console.log(com.zodiack.uploader.utils.thumbURL);
	        opener.checkResult(com.zodiack.uploader.utils.contentID, com.zodiack.uploader.utils.vodTransResult, com.zodiack.uploader.utils.vodDuration, com.zodiack.uploader.utils.vodURL, com.zodiack.uploader.utils.thumbURL);
		    self.close();
		}else{

			if(confirm("변환이 진행중입니다.\n강제로 중지하시겠습니까?")){
				opener.checkResult(com.zodiack.uploader.utils.contentID, com.zodiack.uploader.utils.vodTransResult, com.zodiack.uploader.utils.vodDuration, com.zodiack.uploader.utils.vodURL, com.zodiack.uploader.utils.thumbURL);
				self.close();
			}
		}
	});

	$("#updCancleBtn").click(function(e){
  		if(confirm("현재 업로드 창을 종료하시겠습니까?")){
			self.close();
		}
	});

	//@@ 2012-03-19 업로드 중 창을 닫아도 처리가 가능하도록함
  	com.zodiack.uploader.utils.vodTransProc = function(result, dur, vod, thumb){
  		com.zodiack.uploader.utils.vodTransResult = result;
  		com.zodiack.uploader.utils.vodDuration = dur;
  		com.zodiack.uploader.utils.vodURL = vod;
  		com.zodiack.uploader.utils.thumbURL = thumb;

  		opener.document.writeForm.contentID.value = com.zodiack.uploader.utils.contentID;

  		var resultMsg = "변환결과 : "+ result +", 동영상 재생시간 : "+ dur +", 동영상 URL : "+ vod +", 대표이미지 URL : "+ thumb;
  		com.zodiack.uploader.utils.printTraceMsg(resultMsg);
  	}