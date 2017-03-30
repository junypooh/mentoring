<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" var="year" pattern="yyyy"/>
<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>아이디/비밀번호 찾기</span>
    </div>
    <div class="content">
        <h2>아이디/비밀번호 찾기</h2>
        <p class="tit-desc-txt">회원정보를 이용한 아이디/비밀번호 찾기입니다. 원하시는 항목을 선택해주세요.</p>
        <div class="cont">
            <div class="id-pw-search">
                <div class="id-search">
                    <div class="board-title">
                        <h3 class="board-tit"><span>아이디</span> 찾기</h3>
                        <div>
                            <span>회원가입 시 입력하신 정보를 기입해 주세요.</span>
                            <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_idpw_search.png" alt="열기/닫기" /></a>
                        </div>
                    </div>
                    <div class="board-input-type none"><form:form id="idSearchFrm" action="idSearchFinish.do" method="post">
                    <input type="hidden" name="mbrClassCd" />
                    <input type="hidden" name="mbrCualfCd" />
                    <input type="hidden" name="username" />
                    <input type="hidden" name="genCd" />
                    <input type="hidden" name="emailAddr" />
                    <input type="hidden" name="coNm" />
                    <input type="hidden" name="birthday" />
                        <table>
                            <caption>아이디찾기 - 구분, 이름, 생년월일</caption>
                            <colgroup>
                                <col style="width:65px;" />
                                <col style="width:320px;" />
                                <col style="width:92px;" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">구분</th>
                                    <td colspan="3">
										<span class="radio-align">
											<label class="radio-skin checked"><input type="radio" name="id_userType" class="radio-skin" checked="checked" value="1"/>소속멘토</label>
											<label class="radio-skin"><input type="radio" name="id_userType" class="radio-skin"  value="2"/>기업멘토</label>
											<label class="radio-skin"><input type="radio" name="id_userType" class="radio-skin"  value="3"/>개인멘토</label>
										</span>
                                    </td>
                                </tr>
                                <tr id="id_belonging">
                                    <th scope="row">이름</th>
                                    <td><input type="hidden" name="birthday">
                                        <input type="text" class="inp-style1 username" style="width:150px;"/>
                                        <span class="mgl-15">
                                        <label class="radio-skin checked"><input type="radio" name="id_belonging_genCd" class="radio-skin genCd" checked="checked" value="100323"/>남자</label>
                                        <label class="radio-skin"><input type="radio" name="id_belonging_genCd" class="radio-skin genCd" value="100324"/>여자</label>
                                        </span>
                                    </td>
                                    <th scope="row">이메일 주소</th>
                                    <td>
										<span class="email-adrs">
											<input type="text" class="inp-style1 email-adrs1" style="width:150px;" /> @
											<select id="email-adrs2" class="email-adrs2" style="width:160px;" onchange="fnDirectEmail('emailAdrs1', this)">
												<c:forEach items="${code100533}" var="item">
													<option value="${item.cdNm}">${item.cdNm}</option>
												</c:forEach>
												<option value="">직접입력</option>
											</select>
										</span>
										<span class="email-adrs mgt-10" style="display:none;">
											<input type="text" id="emailAdrs1" class="email-adrs3" style="width:330px;" />
										</span>
                                    </td>
                                    <%--<th scope="row">생년월일</th>
                                    <td>
                                        <select style="width:80px;" id="birthdayYear">
                                            <c:forEach begin="${1}" end="${70}" var="item">
                                            <option value="${year-item}">${year-item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" id="birthdayMonth">
                                            <c:forEach begin="${1}" end="${12}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" id="birthdayDay">
                                            <c:forEach begin="${1}" end="${31}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                    </td> --%>
                                </tr>
                                <!-- 기업멘토 선택시 -->
                                <tr style="display:none;" id="id_corporation">
                                    <th scope="row">기업명</th>
                                    <td>
                                        <input type="text" class="inp-style1 coNm" style="width:150px;"/>
                                    </td>
                                    <th scope="row">이메일 주소</th>
                                    <td>
                                        <input type="text" class="inp-style1 email-adrs1" style="width:150px;"/> @
                                        <select id="email-adrs2" class="email-adrs2" style="width:160px;" onchange="fnDirectEmail('emailAdrs2', this)">
                                            <c:forEach items="${code100533}" var="item">
                                                <option value="${item.cdNm}">${item.cdNm}</option>
                                            </c:forEach>
                                            <option value="">직접입력</option>
                                        </select>
                                        <span class="email-adrs mgt-10" style="display:none;">
                                            <input type="text" id="emailAdrs2" class="email-adrs3" style="width:150px;" />
                                        </span>
                                    </td>
                                </tr>
                                <!-- 기업멘토 선택시 -->
                                <!-- 개인멘토 선택시 -->
                                <tr style="display:none;" class="b-line" id="id_personal">
                                    <th scope="row">이름</th>
                                    <td>
                                        <input type="text" class="inp-style1 username" style="width:150px;"/>
                                    </td>
                                    <th scope="row">생년월일</th>
                                    <td>
                                        <select style="width:80px;" class="birthdayYear">
                                            <c:forEach begin="${1}" end="${70}" var="item">
                                            <option value="${year-item}">${year-item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" class="birthdayMonth">
                                            <c:forEach begin="${1}" end="${12}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" class="birthdayDay">
                                            <c:forEach begin="${1}" end="${31}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <!-- //개인멘토 선택시 -->
                            </tbody>
                        </table></form:form>
                        <div class="btn-area t-noline">
                            <a href="#" class="btn-type2" onClick="idSearch()">아이디찾기</a>
                        </div>
                    </div>
                </div>

                <div class="pw-search">
                    <div class="board-title">
                        <h3 class="board-tit"><span>비밀번호</span> 찾기</h3>
                        <div>
                            <span>입력하신 정보가 확인되면 비밀번호를 새로 발급해 드립니다.</span>
                            <a href="#"><img src="${pageContext.request.contextPath}/images/member/btn_idpw_search.png" alt="열기/닫기" /></a>
                        </div>
                    </div>
                    <div class="board-input-type"><form:form id="pwSearchFrm" action="pwSearch.do">
                        <input type="hidden" name="mbrClassCd" />
                        <input type="hidden" name="mbrCualfCd" />
                        <input type="hidden" name="id" />
                        <input type="hidden" name="genCd" />
                        <input type="hidden" name="emailAddr" />
                        <input type="hidden" name="birthday" />
                        <table>
                            <caption>비밀번호찾기 - 구분, 아이디, 생년월일, 비밀번호찾기 질문</caption>
                            <colgroup>
                                <col style="width:130px;" />
                                <col style="width:283px;" />
                                <col style="width:110px;" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">구분</th>
                                    <td colspan="3">
										<span class="radio-align">
											<label class="radio-skin checked"><input type="radio" name="pw_userType" class="radio-skin" checked="checked" value="1"/>소속멘토</label>
											<label class="radio-skin"><input type="radio" name="pw_userType" class="radio-skin" value="2"/>기업멘토</label>
											<label class="radio-skin"><input type="radio" name="pw_userType" class="radio-skin" value="3"/>개인멘토</label>
										</span>
                                    </td>
                                </tr>
                                <tr id="pw_belonging">
                                    <th scope="row">아이디</th>
                                    <td>
                                        <input type="text" class="inp-style1 id" style="width:120px;" />
                                        <span class="mgl-15">
                                        <label class="radio-skin checked"><input type="radio" class="genCd" name="pw_belonging_gencd" class="radio-skin" checked="checked" value="100323"/>남자</label>
                                        <label class="radio-skin"><input type="radio" class="genCd" name="pw_belonging_gencd" class="radio-skin" value="100324"/>여자</label>
                                        </span>
                                    </td>
                                    <th scope="row">이메일 주소</th>
                                    <td>
										<span class="email-adrs">
											<input type="text" class="inp-style1 email-adrs1" style="width:120px;"/> @
											<select id="email-adrs2" class="email-adrs2" style="width:140px;" onchange="fnDirectEmail('emailAdrs3', this)">
												<c:forEach items="${code100533}" var="item">
													<option value="${item.cdNm}">${item.cdNm}</option>
												</c:forEach>
												<option value="">직접입력</option>
											</select>
										</span>
										<span class="email-adrs mgt-10" style="display:none;">
											<input type="text" id="emailAdrs3" class="email-adrs3" style="width:281px;" />
										</span>
                                    </td>
                                </tr>
                                <%--   <input type="text" class="inp-style1" style="width:150px;" id="user-id" name="id" />
                                    </td>
                                    <th scope="row">생년월일</th>
                                    <td><input type="hidden" name="birthday">
                                        <select style="width:80px;" id="birthdayYear">
                                            <c:forEach begin="${1}" end="${70}" var="item">
                                            <option value="${year-item}">${year-item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" id="birthdayMonth">
                                            <c:forEach begin="${1}" end="${12}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" id="birthdayDay">
                                            <c:forEach begin="${1}" end="${31}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>--%>
                                <!-- 기업멘토 선택시 -->
                                <tr style="display:none;" id="pw_corporation">
                                    <th scope="row">아이디</th>
                                    <td>
                                        <input type="text" class="inp-style1 id" style="width:120px;" />
                                    </td>
                                    <th scope="row">이메일 주소</th>
                                    <td>
                                        <input type="text" class="inp-style1 email-adrs1" style="width:120px;" /> @
                                        <select id="email-adrs2" class="email-adrs2" style="width:160px;" onchange="fnDirectEmail('emailAdrs4', this)">
                                            <c:forEach items="${code100533}" var="item">
                                                <option value="${item.cdNm}">${item.cdNm}</option>
                                            </c:forEach>
                                            <option value="">직접입력</option>
                                        </select>
                                        <span class="email-adrs mgt-10" style="display:none;">
                                            <input type="text" id="emailAdrs4" class="email-adrs3" style="width:150px;" />
                                        </span>
                                    </td>
                                </tr>
                                <!-- //기업멘토 선택시 -->
                                <!-- 개인멘토 선택시 -->
                                <tr style="display:none;" id="pw_personal">
                                    <th scope="row">아이디</th>
                                    <td>
                                        <input type="text" class="inp-style1 id" style="width:150px;" />
                                    </td>
                                    <th scope="row">생년월일</th>
                                    <td>
                                        <select style="width:80px;" class="birthdayYear">
                                            <c:forEach begin="${1}" end="${70}" var="item">
                                            <option value="${year-item}">${year-item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" class="birthdayMonth">
                                            <c:forEach begin="${1}" end="${12}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                        <select style="width:56px;" class="birthdayDay">
                                            <c:forEach begin="${1}" end="${31}" var="item">
                                            <option value="${item}">${item}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <!-- //개인멘토 선택시 -->
                                <tr style="display:none;" class="b-line" id="pw_personal2">
                                    <th scope="row">비밀번호찾기 질문</th>
                                    <td colspan="3">
                                        <select id="pw-question" name="pwdQuestCd" style="width:270px;">
                                            <c:forEach items="${code100221}" var="item">
                                                <option value="${item.cd}">${item.cdNm}</option>
                                            </c:forEach>
                                        </select>
                                        <input type="text" id="question-answer" class="inp-style1" style="width:414px;" placeholder="질문에 대한 답변" name="pwdAnsSust" />
                                    </td>
                                </tr>
                            </tbody>
                        </table></form:form>
                        <div class="btn-area t-noline">
                            <a href="javascript:void(0)" class="btn-type2" onClick="pwSearch()">비밀번호찾기</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>
<a href="#pwPopup" class="btn-border-type layer-open" style="display:none" id="pwPopBtn">패스워드 찾기</a>
<div class="layer-pop-wrap" id="pwPopup">
    <div class="layer-pop class m-blind">
        <div class="title">
            <strong>비밀번호 찾기</strong>
            <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
        </div>
        <div class="cont">
            <div class="pw_email_send">
                <strong>임시비밀번호 발급 완료</strong>
                <dl>
                    <dt>임시비밀번호</dt>
                    <dd id="tempPw">AeEbbsdf1293</dd>
                </dl>
            </div>
            <p class="id-overlap-txt email">
                비밀번호 입력란에 임시비밀번호를 복사하여 붙여 넣으시면<br/>
                보다 편리하게 이용하실 수 있습니다.<br/>
                로그인 후, [회원정보] 메뉴에서 비밀번호를 변경하여 이용하시기 바랍니다.
            </p>
            <div class="btn-area">
                <a href="#" class="btn-type2 pop-close">확인</a>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
function idSearch(){
    var key = "id";
    var inputObjs = [];
    var frmId = "#"+key+"SearchFrm";

    $('input[name="mbrClassCd"]',frmId).val("");
    $('input[name="mbrCualfCd"]',frmId).val("");
    $('input[name="username"]',frmId).val("");
    $('input[name="genCd"]',frmId).val("");
    $('input[name="emailAddr"]',frmId).val("");
    $('input[name="coNm"]',frmId).val("");
    $('input[name="birthday"]',frmId).val("");
    switch($("input[name='{0}_userType']:checked".format(key),frmId).val()){
    case "1":
        $("input[name='mbrClassCd']",frmId).val("${code['CD100857_101505_멘토']}");
        $("input[name='mbrCualfCd']",frmId).val("${code['CD100204_101502_소속멘토']}");
        inputObjs.push($("input[name='username']".format(key),frmId).val( $("input.username","#"+key+"_belonging").val() ));
        inputObjs.push($("input[name='genCd']".format(key),frmId).val( $("input.genCd:checked","#"+key+"_belonging").val() ));
        //inputObjs.push($("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_belonging").val()+"@"+$("input.email-adrs3","#"+key+"_belonging").val()));
        if(inputObjs[0].val() == ""){
            alert("이름을 입력해주세요.");
            return false;
        }
        if(($("#email-adrs2","#"+ key +"_belonging").val() !="" && $("input.email-adrs1","#"+key+"_belonging").val() == "") || ($("#email-adrs2","#"+ key +"_belonging").val() =="" && $("input.email-adrs3","#"+key+"_belonging").val() == "")){
            alert("Email을 입력해주세요.");
            return false;
        }
        var emailDomain = $("#email-adrs2","#"+key+"_belonging").val();

        if(emailDomain == "")
            emailDomain = $("input.email-adrs3","#"+key+"_belonging").val();
        inputObjs.push($("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_belonging").val()+"@"+emailDomain));
        break;
    case "2":
        $("input[name='mbrClassCd']",frmId).val("${code['CD100857_101504_기관_업체']}");
        $("input[name='mbrCualfCd']",frmId).val("${code['CD100204_101501_업체담당자']}");
        inputObjs.push($("input[name='coNm']".format(key),frmId).val( $("input.coNm","#"+key+"_corporation").val() ));
        //$("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_corporation").val()+"@"+$("input.email-adrs3","#"+key+"_corporation").val());

        if(inputObjs[0].val() == ""){
            alert("기업명을 입력해주세요.");
            return false;
        }
        if($("input.email-adrs1","#"+key+"_corporation").val() == "" || $("input.email-adrs3","#"+key+"_corporation").val() == ""){
            alert("Email을 입력해주세요.");
            return false;
        }

        var emailDomain = $("#email-adrs2","#"+key+"_corporation").val();

        if(emailDomain == "")
            emailDomain = $("input.email-adrs3","#"+key+"_corporation").val();
        inputObjs.push($("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_corporation").val()+"@"+emailDomain));
        break;
    case "3":
        $("input[name='mbrClassCd']",frmId).val("${code['CD100857_101505_멘토']}");
        $("input[name='mbrCualfCd']",frmId).val("${code['CD100204_101503_개인멘토']}");
        inputObjs.push($("input[name='username']".format(key),frmId).val( $("input.username","#"+key+"_personal").val() ));
        $("input[name='birthday']".format(key),frmId).val( $("select.birthdayYear",frmId).val().zf(4)+$("select.birthdayMonth",frmId).val().zf(2)+$("select.birthdayDay",frmId).val().zf(2) );
        if(inputObjs[0].val() == ""){
            alert("이름을 입력해주세요.");
            return false;
        }
        break;
    }

    $("#idSearchFrm").submit();
}

function pwSearch(){
    var key = "pw";
    var inputObjs = [];
    var frmId = "#"+key+"SearchFrm";

    $('input[name="mbrClassCd"]',frmId).val("");
    $('input[name="mbrCualfCd"]',frmId).val("");
    $('input[name="id"]',frmId).val("");
    $('input[name="genCd"]',frmId).val("");
    $('input[name="emailAddr"]',frmId).val("");
    $('input[name="birthday"]',frmId).val("");

    switch($("input[name='{0}_userType']:checked".format(key),frmId).val()){
    case "1":
        $('input[name="pwdAnsSust"]',frmId).val("");
        $("input[name='mbrClassCd']",frmId).val("${code['CD100857_101505_멘토']}");
        $("input[name='mbrCualfCd']",frmId).val("${code['CD100204_101502_소속멘토']}");
        inputObjs.push($("input[name='id']".format(key),frmId).val( $("input.id","#"+key+"_belonging").val() ));
        inputObjs.push($("input[name='genCd']".format(key),frmId).val( $("input.genCd:checked","#"+key+"_belonging").val() ));


        if(inputObjs[0].val() == ""){
            alert("아이디를 입력해주세요.");
            return false;
        }

        if(($("#email-adrs2","#"+ key +"_belonging").val() !="" && $("input.email-adrs1","#"+key+"_belonging").val() == "") || ($("#email-adrs2","#"+ key +"_belonging").val() =="" && $("input.email-adrs3","#"+key+"_belonging").val() == "")){
            alert("Email을 입력해주세요.");
            return false;
        }
        var emailDomain = $("#email-adrs2","#"+key+"_belonging").val();

        if(emailDomain == "")
            emailDomain = $("input.email-adrs3","#"+key+"_belonging").val();
        inputObjs.push($("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_belonging").val()+"@"+emailDomain));
        break;
    case "2":
        $('input[name="pwdAnsSust"]',frmId).val("");
        $("input[name='mbrClassCd']",frmId).val("${code['CD100857_101504_기관_업체']}");
        $("input[name='mbrCualfCd']",frmId).val("${code['CD100204_101501_업체담당자']}");
        inputObjs.push($("input[name='id']".format(key),frmId).val( $("input.id","#"+key+"_corporation").val() ));
        //inputObjs.push($("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_corporation").val()+"@"+$("input.email-adrs3","#"+key+"_corporation").val()));

        if(inputObjs[0].val() == ""){
            alert("아이디를 입력해주세요.");
            return false;
        }
        if(($("#email-adrs2","#"+ key +"_belonging").val() !="" && $("input.email-adrs1","#"+key+"_corporation").val() == "") || ($("#email-adrs2","#"+ key +"_corporation").val() =="" && $("input.email-adrs3","#"+key+"_corporation").val() == "")){
            alert("Email을 입력해주세요.");
            return false;
        }

        var emailDomain = $("#email-adrs2","#"+key+"_corporation").val();

        if(emailDomain == "")
            emailDomain = $("input.email-adrs3","#"+key+"_corporation").val();
        inputObjs.push($("input[name='emailAddr']".format(key),frmId).val($("input.email-adrs1","#"+key+"_corporation").val()+"@"+emailDomain));
        break;
    case "3":
        $("input[name='mbrClassCd']",frmId).val("${code['CD100857_101505_멘토']}");
        $("input[name='mbrCualfCd']",frmId).val("${code['CD100204_101503_개인멘토']}");
        inputObjs.push($("input[name='id']".format(key),frmId).val( $("input.id","#"+key+"_personal").val() ));
        $("input[name='birthday']".format(key),frmId).val( $("select.birthdayYear",frmId).val().zf(4)+$("select.birthdayMonth",frmId).val().zf(2)+$("select.birthdayDay",frmId).val().zf(2) );
        if(inputObjs[0].val() == ""){
            alert("아이디를 입력해주세요.");
            return false;
        }
        if($("input[name='pwdAnsSust']",frmId).val() === ""){
            alert("비밀번호 찾기 질문에 대한 답을 입력해주세요.");
            return false;
        }
        break;
    }

    $.ajax({
        url: "ajax.pwSearchFinish.do",
        data : $("#pwSearchFrm").serialize(),
        method:"post",
        success: function(rtnData) {
            if(rtnData.success === "true"){
                $("#tempPw").text(rtnData.password);
                $("#pwPopBtn").click();
            }else{
                alert(rtnData.message);
            }
        }
    });
}

function searchWithEmail(){
    if($("#email-adrs1","#searchWithEmailFrm").val() === "" || $("#email-adrs3","#searchWithEmailFrm").val() ===""){
        alert("이메일 주소를 올바르게 입력해주세요.\n예) abc@abc.com");
        return false;
    }
    $("input[name='emailAddr']","#searchWithEmailFrm").val($("#email-adrs1","#searchWithEmailFrm").val()+"@"+$("#email-adrs3","#searchWithEmailFrm").val());
    $.ajax({
        url: "ajax.idPwSearchWithEmail.do",
        data : $("#searchWithEmailFrm").serialize(),
        method:"post",
        success: function(rtnData) {
            alert(rtnData.message);
        }
    });
}
$(function(){
    $(".email-adrs2").change(function(){
        if($(this).val() === ""){
            $(this).next().show();
        }else{
            $(this).next().hide();
        }
        $(this).next().val($(this).val());
    });

    actionRatio("id");
    actionRatio("pw");

<c:if test="${!empty message}">
    alert("${message}");
</c:if>
})

function actionRatio(key){
    $("input[name='{0}_userType']".format(key),"#"+key+"SearchFrm").change(function(){
        $("tr[id^='{0}_']".format(key)).hide();
        switch($(this).val()){
        case "1":
            $("#"+key+"_belonging").show();
            break;
        case "2":
            $("#"+key+"_corporation").show();
            break;
        case "3":
            $("tr[id^='{0}_personal']".format(key)).show();
            break;
        }
    });
}

function fnDirectEmail(obj, val){
    if($(val).val() == ""){
        $("#" + obj).parent().show();
    }else{
        $("#" + obj).parent().hide();
    }
}
</script>