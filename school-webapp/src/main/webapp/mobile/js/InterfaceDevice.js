
var currentOS;
var mobile = (/iphone|ipad|ipod|android/i.test(navigator.userAgent.toLowerCase()));

if (mobile) {
	// 유저에이전트를 불러와서 OS를 구분합니다.
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.search("android") > -1)
		currentOS = "android";
	else if ((userAgent.search("iphone") > -1) || (userAgent.search("ipod") > -1)
				|| (userAgent.search("ipad") > -1))
		currentOS = "ios";
	else
		currentOS = "else";
} else {
	// 모바일이 아닐 때
	currentOS = "nomobile";
}

function startTomms(obj){
	if(currentOS=='android'){
		window.EMentoring.tomms(obj);
	}else{
		alert(obj);
	}
}

//pc버전 URL 열기
function goToPCVersion(){
	var obj = "{\"URL\":\"http://mentoring.career.go.kr/school/index.do\"}";
	if(currentOS=='android'){
		window.EMentoring.openNewURL(obj);
	}else{
		alert(obj);
	}
}
//이용약관 URL 열기
function goToUsageRule(){
	var obj = "{\"URL\":\"http://mentoring.career.go.kr/school/footer/usageRule.do\"}";
	if(currentOS=='android'){
		window.EMentoring.openNewURL(obj);
	}else{
		alert(obj);
	}
}
//개인정보처리방침 URL 열기
function goToPersonInfoRule(){
	var obj = "{\"URL\":\"http://mentoring.career.go.kr/school/footer/personalInformationRule.do\"}";
	if(currentOS=='android'){
		window.EMentoring.openNewURL(obj);
	}else{
		alert(obj);
	}
}

function checkVersion(){
	if(currentOS=='android'){
		window.EMentoring.checkVersion();
	}else{
		//alert('this part is not android');
	}
}

function checkVersionForMarket(){
	if(currentOS=='android'){
		window.EMentoring.checkVersionForMarket();
	}else{
		//alert('this part is not android');
	}
}

//function checkPushNoti(){
//	if(currentOS=='android'){
//		window.EMentoring.checkPushNoti();
//	}else{
//		//alert('this part is not android');
//	}
//}

//function setStudyPushToggle(){
//	if(currentOS=='android'){
//		window.EMentoring.setStudyPushToggle();
//	}else{
//		//alert('this part is not android');
//	}
//} 
//
//function setNoticePushToggle(){
//	if(currentOS=='android'){
//		window.EMentoring.setNoticePushToggle();
//	}else{
//		//alert('this part is not android');
//	}
//} 

//자동로그인 설정시
function setAutoLogin(name,pass){
	var obj = "{\"username\":\""+name+"\",\"password\":\""+pass+"\"}";
	if(currentOS=='android'){
		window.EMentoring.setAutoLogin(obj);
	}else{
		alert(obj);
	}
} 

//로그인 성공시 전달
function setLoginComplite(keep){
	var obj = "{\"LOGIN\":\""+keep+"\"}";
	if(currentOS=='android'){
		window.EMentoring.setLoginComplite(obj);
	}else{
		alert(obj);
	}
}

function comfirmLogout(){
	 $('#mLogout').submit()
}

$(document).ready(function(){
});

$(window).resize(function(){
});