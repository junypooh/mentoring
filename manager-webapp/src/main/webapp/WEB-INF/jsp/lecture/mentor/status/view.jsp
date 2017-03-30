<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<security:authorize access="isAuthenticated()">
	<security:authentication var="id" property="principal.id" />
	<security:authentication var="username" property="principal.username" />
	<security:authentication var="posCoNm" property="principal.posCoNm" />
</security:authorize>

<div class="cont">
    <div class="title-bar">
		<h2>수업현황</h2>
		<ul class="location">
			<li class="home">Home</li>
			<li>수업관리</li>
			<li>수업개설관리</li>
			<li>수업현황</li>
		</ul>
	</div>
	<div class="over-hidden">
		<div class="mento-pic-wrap">
			<ul class="bxslider">
    	        <c:if test="${fn:length(lectInfo.listLectPicInfo) < 1}">
			        <li class="mento-img">
			            <img src="${pageContext.request.contextPath}/images/img_mento_default.png" alt="수업이미지"/>
			        </li>
		        </c:if>
                <c:forEach items="${lectInfo.listLectPicInfo}" var="lectPicInfo" varStatus="vs">
                    <li class="mento-img">
                         <img src="${pageContext.request.contextPath}/fileDown.do?fileSer=${lectPicInfo.fileSer}" alt="수업이미지${vs.count}"  onerror="${pageContext.request.contextPath}/images/img_mento_default.png"/>
                    </li>
                </c:forEach>
			</ul>
		</div>
		<div class="board-area mento-info">
		<input type="hidden" id="lectSer" value="${lectSer}"/>
		<input type="hidden" id="lectTims" value="${lectTims}"/>
		<input type="hidden" id="lectStatCd" />
		<input type="hidden" id="lectureCnt"/>
			<table class="tbl-style tbl-none-search">
				<colgroup>
					<col style="width:147px;" />
					<col />
					<col style="width:147px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" class="ta-l">배정사업</th>
						<td colspan="3" id="grpNm">${lectInfo.grpNm}</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">수업명</th>
						<td colspan="3" id="lectTitle">${lectInfo.lectTitle}</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">수업유형</th>
						<td id="lectTypeCdNm">${lectInfo.lectTypeCdNm}</td>
						<th scope="col" class="ta-l">멘토</th>
						<td id="lectrNm">${lectInfo.lectrNm}</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">수업대상</th>
						<td id="lectTargtCd">
						    <c:choose>
						        <c:when test="${lectInfo.lectTargtCd eq '101534'}"> 초 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101535'}"> 중 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101536'}"> 고 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101537'}"> 초중 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101538'}"> 중고 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101539'}"> 초고 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101540'}"> 초중고 </c:when>
						        <c:when test="${lectInfo.lectTargtCd eq '101713'}"> 기타 </c:when>
                            </c:choose>
						</td>
						<th scope="col" class="ta-l">직업명</th>
						<td id="lectrJobNm">${lectInfo.lectrJobNm}</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">수업개요</th>
						<td colspan="3" id="lectOutlnInfo">${lectInfo.lectOutlnInfo}</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">수업소개</th>
						<td colspan="3" class="textarea-wrap" id="lectIntdcInfo">
						    <spring:eval expression="T(kr.or.career.mentor.util.PooqUtils).toHTML(lectInfo.lectIntdcInfo)"></spring:eval>
						</td>
					</tr>
                    <tr>
                        <th scope="col" class="ta-l">수업내용</th>
                        <td colspan="3" class="textarea-wrap" id="lectSustInfo">${lectInfo.lectSustInfo}</td>
                    </tr>
					<tr>
						<th scope="col" class="ta-l">교육수행기관</th>
						<td colspan="3" id="coNm">${lectInfo.coNm}</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">등록자</th>
						<td id="regMbrNm">
                            ${lectInfo.regMbrNm} <c:if test="${lectInfo.regCoNm ne null}"> (${lectInfo.regCoNm}) </c:if>
						</td>
						<th scope="col" class="ta-l">등록일</th>
						<td id="regDtm"><fmt:formatDate value="${lectInfo.regDtm}" pattern="yyyy.MM.dd HH:mm" /></td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">최종수정자</th>
						<td id="chgMbrNm">
						    ${lectInfo.chgMbrNm} <c:if test="${lectInfo.chgCoNm ne null}"> (${lectInfo.regCoNm}) </c:if>
						</td>
						<th scope="col" class="ta-l">최종수정일</th>
						<td id="chgDtm"><fmt:formatDate value="${lectInfo.chgDtm}" pattern="yyyy.MM.dd HH:mm" /></td>
					</tr>
				</tbody>
			</table>
			<div class="board-bot">
				<ul>
					<li><button type="button" class="btn-orange" onclick="location.href='${pageContext.request.contextPath}/lecture/mentor/register/edit.do?lectSer=${lectSer}'"><span>수정</span></button></li>
					<li><button type="button" class="btn-style02" onclick="location.href='list.do'"><span>목록</span></button></li>

				</ul>
			</div>
		</div>
		<div class="board-area board-area-bot" id="boardArea">
			<div class="board-top">
				<p>수업 상세 정보</p>
			</div>
			<table class="tbl-style">
				<colgroup>
					<col style="width:165px;">
					<col>
				</colgroup>
				<tbody id="lectTimsSchdInfoTable"></tbody>
			</table>
			<div class="board-top">
				<p>신청 기기 <span class="red-txt" id="applCnt"></span>  <span id="applMaxCnt"></span>   <span class="fw-normal" id="applLectCnt"></span></p>
				<ul>
					<li><button type="button" id="applReqBtn"  class="btn-orange"><span>수업신청</span></button>
					</li>
				</ul>
			</div>
			<table id="boardTable01"></table>
			<div class="board-top">
				<p>참관 기기 <span class="red-txt" id="obsvCnt"></span> <span id="obsvMaxCnt"></span> <span class="fw-normal" id="obsvLectCnt"></span></p>
                <ul>
                	<li><button type="button" id="obsvReqBtn" class="btn-orange"><span>참관신청</span></button></li>
                </ul>
			</div>
			<table id="boardTable02"></table>
			<div class="board-top">
				<p>관련 수업 목록</p>
			</div>
			<table id="boardTable03"></table>
            <div id="paging"></div>
		</div>
	</div>
</div>

<c:import url="/popup/layerMcStdoUpdate.do">
  <c:param name="popupId" value="_mcStdoPopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>
<c:import url="/popup/layerCnclLectureUpdate.do">
  <c:param name="popupId" value="_cnclLecturePopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>
<c:import url="/popup/layerLectClassSearch.do">
  <c:param name="popupId" value="_reqLecturePopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>


<script type="text/jsx;harmony=true">
    mentor.schoolPageNavi = React.render(
        <PageNavi  pageFunc={loadTimsList} totalRecordCount={0} currentPageNo={1} recordCountPerPage={20} pageSize={10} />,
        document.getElementById('paging')
    );
</script>

<script type="text/html" id="lectTimsSchdInfo">
    {{if $data.lectSchdInfo.length > 0}}
        {{each lectSchdInfo}}
            <tr>
                {{if $index==0 }}
                <th scope="col" rowspan="\${lectSchdInfo.length}" class="ta-l">수업일시</th>
                {{/if}}
                <td>
                    <span> \${lectDay}  \${lectStartTime} ~ \${lectEndTime} (\${lectRunTime}분)</span>
                    {{if lectSessId != null && '101549,101550'.indexOf(lectStatCd) >=0 }}
                        <button type="button" class="btn-style01 fl-r" onclick="_fCallTomms('\${lectSessId}')"><span>입장</span></button>
                    {{else lectSessId == null }}
                        <button type="button" class="btn-style01 fl-r" onclick="_createSession(this, '\${lectSer}','\${lectTims}','\${schdSeq}')"><span>회의재생성</span></button>
                    {{else}}
                        <button type="button" class="btn-style01 default fl-r"><span>입장</span></button>
                    {{/if}}
                </td>
            </tr>
        {{/each}}
        {{each lectSchdInfo}}
            <tr>
                {{if $index==0 }}
                <th scope="col" rowspan="\${lectSchdInfo.length}" class="ta-l">MC 및 스튜디오</th>
                {{/if}}
                <td>
                    <span>
                        {{if mcNm == null }}지정안함{{else}}\${mcNm}{{/if}}
                            /
                        {{if stdoNm == null }}지정안함{{else}}\${stdoNm}{{/if}}
                    </span>
                    {{if '101543,101548'.indexOf($data.lectStatCd) >=0 }}
                        <button type="button" class="btn-style01 fl-r" id="mcStdoPopup" onclick="getMcStdoPopUp()"><span>수정</span></button>
                    {{else}}
                        <button type="button" class="btn-style01 default fl-r"><span>수정</span></button>
                    {{/if}}
                </td>
            </tr>
        {{/each}}
	{{else}}
        <tr><th scope="col" rowspan="1" class="ta-l">수업일시</th><td></td></tr>
        <tr><th scope="col" rowspan="1" class="ta-l">MC 및 스튜디오</th><td></td></tr>
    {{/if}}
	<tr>
	    <th scope="col" class="ta-l">수업상태</th>
		<td>
	    	<strong class="orange-txt">\${lectStatCdNm}</strong>
	    	{{if '101542,101543,101548'.indexOf(lectStatCd) >=0 }}
		        <button type="button" class="btn-style01 fl-r" id="cnclLecturePopup" onclick="getCnclLecturePopUp()"><span>수동취소</span></button>
		    {{else}}
		        <button type="button" class="btn-style01 default fl-r"><span>수동취소</span></button>
		    {{/if}}
	   	</td>
	</tr>
	<tr>
		<th scope="col" class="ta-l">노출여부</th>
		<td>
			<strong>
                {{if expsYn == 'Y' }}노출<button type="button" class="btn-style01 fl-r" onclick="lectExpsUpdate('N');"><span>비노출</span></button>
                {{else}}비노출<button type="button" class="btn-style01 fl-r" onclick="lectExpsUpdate('Y');"><span>노출</span></button>
                {{/if}}
			</strong>
			</td>
	</tr>
    {{if '101547,101553,101545'.indexOf(lectStatCd) >=0  }}
	<tr>
		<th scope="col" rowspan="2" class="ta-l">취소사유</th>
		<td>
            <span> \${cnclMbrNm} / \${cnclDtm}</span>
            {{if lectStatCd == '101545' }}
                <button type="button" class="btn-style01 default fl-r" ><span>수정</span></button>
            {{else}}
                <button type="button" class="btn-style01 fl-r" onclick="getCnclLecturePopUp()"><span>수정</span></button>
            {{/if}}
        </td>
    </tr>
	<tr>
		<td ><span id="cnclRsn"></span></td>
	</tr>
	{{/if}}
</script>


<script type="text/javascript">

    var dataSet = {
        params: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
            lectSer: $("#lectSer").val(),
            lectTims: $("#lectTims").val(),
        }
    };

    $(document).ready(function(){

        //jqGrid setting
        var colModels = [];
        colModels.push({label:'no', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', width:60, align:'center', sortable: false});
        colModels.push({label:'MC 및 스튜디오', name:'mcNm', index:'mcNm', width:55, align:'center', sortable: false});
        colModels.push({label:'노출여부', name:'expsYn', index:'expsYn', width:50, align:'center' , sortable: false});
        colModels.push({label:'신청', name:'applCnt',index:'applCnt', width:50, align:'center', sortable: false});
        colModels.push({label:'참관', name:'obsvCnt',index:'obsvCnt', width:50, align:'center', sortable: false});
        colModels.push({label:'수업상태', name:'lectStatCdNm', index:'lectStatCdNm', width:40, align:'center', sortable: false});

        initJqGridTable('boardTable03', 'boardArea', 1300, colModels, false);
        //jqGrid setting
        resizeJqGridWidth('boardTable03', 'boardArea', 13000);
        $('.bxslider').bxSlider({
            auto: false,
            controls : false,
            autoHover : false
        });


        //수업신청버튼 클릭
        $("#applReqBtn").click(function(e){
            e.preventDefault();

            if( $('#applReqBtn').attr("class") == "btn-orange"){
                getReqLecturePopUp("101715");
            }
        });

        //수업참관버튼 클릭
        $("#obsvReqBtn").click(function(e){
            e.preventDefault();

            if( $('#obsvReqBtn').attr("class") == "btn-orange"){
                getReqLecturePopUp("101716");
            }
        });

        //신청이력 그리드
        loadApplList("101715");

        //참관이력 그리드
        loadApplList("101716");

        //동일 수업 다른 차수 정보 그리드
        loadTimsList(1);

        //수업 상세 정보
        getTimsSchdInfo();

     });

    function fnDefaultImg(imtPath){
        imtPath.src = "${pageContext.request.contextPath}/images/main/img_popup_01.jpg";
    }

    /** 노출/ 비노출 버튼 클릭 */
    function lectExpsUpdate(expsYn) {

        if(!confirm("수정 하시겠습니까?")) {
            return false;
        }

        var expsDataSet = {
            params: {
                lectSer: $("#lectSer").val(),
                lectTims: $("#lectTims").val(),
                expsYn : expsYn
            }
        };

        $.ajax({
            url:"ajax.expsLect.do",
            data : $.param(expsDataSet.params, true),
            method:"post",
            success: function(rtnData) {
            console.log(rtnData);
                if(rtnData.success == true){
                    getTimsSchdInfo();
                }else{
                    alert(rtnData.message);
                }
            }
        });
    }


    /** Class 수업 취소  */
    function cnclLectClass(obj) {

        if(!confirm("수업 신청을 취소 하시겠습니까?")) {
            return false;
        }

        var cnclDataSet = {
            params: {
                lectSer: $("#lectSer").val(),
                lectTims: $("#lectTims").val(),
                lectureCnt : $("#lectureCnt").val(),
                setSer : $(obj).parent().find('input[name=setSer]').val(),
                schNo : $(obj).parent().find('input[name=schNo]').val(),
                clasRoomSer : $(obj).parent().find('input[name=clasRoomSer]').val(),
                applClassCd : $(obj).parent().find('input[name=applClassCd]').val()
            }
        };
        $.ajax({
            url:"ajax.cnclLectClass.do",
            data : $.param(cnclDataSet.params, true),
            method:"post",
            success: function(rtnData) {
                if(rtnData.success == true){
                    alert(rtnData.data);
                    getTimsSchdInfo();
                    loadApplList("101715");
                    loadApplList("101716");
                }else{
                    alert(rtnData.message);
                }
            }
        });
    }

    function getTimsSchdInfo(){
        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/mentor/status/ajax.view.do',
            data : $.param(dataSet.params, true),
            success: function(rtnData) {
                dataSet.data = rtnData;

                $('#lectureCnt').val(rtnData.lectureCnt);
                $('#lectStatCd').val(rtnData.lectStatCd);

                //수업 상세정보
                $('#applCnt').text(rtnData.applCnt);
                $('#applMaxCnt').text("/" + rtnData.maxApplCnt);
                $('#applLectCnt').text("(신청 차감 기준 :" + rtnData.lectureCnt + "회)");
                $('#obsvCnt').text(rtnData.obsvCnt);
                $('#obsvMaxCnt').text("/" + rtnData.maxObsvCnt);
                $('#obsvLectCnt').text("(참관 차감 기준 :" + rtnData.lectureCnt/2 + "회)");

                //수업 가능한 상태에서만 수업 수동 추가 가능
                if(rtnData.lectStatCd == "101543" || rtnData.lectStatCd == "101548" || rtnData.lectStatCd == "101549" ) {
                    $('#applReqBtn').attr("class", "btn-orange");
                    $('#obsvReqBtn').attr("class", "btn-orange");
                }else{
                    $('#applReqBtn').attr("class", "btn-style01 default fl-r");
                    $('#obsvReqBtn').attr("class", "btn-style01 default fl-r");
                }

                //수업 잔여 신청수가 없다면 불가
                if(rtnData.maxApplCnt <= rtnData.applCnt){
                   $('#applReqBtn').attr("class", "btn-style01 default fl-r");
                }
                //수업 잔여 참관수가 없다면 불가
                if(rtnData.maxObsvCnt <= rtnData.obsvCnt){
                   $('#obsvReqBtn').attr("class", "btn-style01 default fl-r");
                }

                $('#lectTimsSchdInfoTable').empty();
                $('#lectTimsSchdInfo').tmpl(dataSet.data).appendTo('#lectTimsSchdInfoTable');

                if(dataSet.data.lectStatCd == '101545'){
                    $('#cnclRsn').html("신청자 부족으로 자동 취소되었습니다.");
                }else if(dataSet.data.lectCnclRsnSust != null){
                    $('#cnclRsn').html(dataSet.data.lectCnclRsnSust.split("\n").join("<br/>"));
                }




                //MC/스튜디오 수정팝업
                $('#lectMcStdoInfoTable').empty();
                $('#lectMcStdoInfo').tmpl(dataSet.data).appendTo('#lectMcStdoInfoTable');
                $("#lectSchdSeq").text('총' + dataSet.data.lectSchdInfo.length + '회차');

                //수업 수동 취소 팝업 데이터 셋팅
                if(dataSet.data.cnclDtm == null){
                   $('#cnclMbrNm').text( '${username}(${posCoNm})');
                   $('#cnclDtmTr').hide();
                }else{
                   $('#cnclMbrNm').text(dataSet.data.cnclMbrNm + "(" + dataSet.data.cnclCoNm + ")");
                   $('#cnclDtmTd').text(dataSet.data.cnclDtm);
                   $('#cnclDtmTr').show();
                }

                if(dataSet.data.lectCnclRsnSust != null){
                    $('#lectCnclRsnSust').text(dataSet.data.lectCnclRsnSust);
                    $('#result').text(dataSet.data.lectCnclRsnSust.length);
                }

            }
        });
    }

    function getMcStdoPopUp(){
        $('body').addClass('dim');
        $("#_mcStdoPopup").css("display","block");
    }

    function getCnclLecturePopUp(){
        $('body').addClass('dim');
        $("#_cnclLecturePopup").css("display","block");
    }

    function getReqLecturePopUp(applClassCd){
        $('body').addClass('dim');
        $("#_reqLecturePopup").css("display","block");
        emptyCorpGridSet(applClassCd);
    }

    function loadApplList(applClassCd){
        //jqGrid setting
        var colModels = [];
        colModels.push({label:'no', name:'rn', index:'rn', width:20, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassCdNm', index:'schClassCdNm', width:20, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm', index:'sidoNm', width:30, sortable: false});
        colModels.push({label:'시군구', name:'sgguNm', index:'sgguNm', width:30 , sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:60, sortable: false});
        colModels.push({label:'교실정보(인원수)', name:'clasRoomNm',index:'clasRoomNm', width:60, sortable: false});
        colModels.push({label:'신청자', name:'tchrNm', index:'tchrNm', width:50, align:'center', sortable: false});
        colModels.push({label:'연락처', name:'tchrMobile', index:'tchrMobile', width:50, align:'center', sortable: false});
        colModels.push({label:'신청일', name:'applRegDtm', index:'applRegDtm', width:50, align:'center', sortable: false});
        colModels.push({label:'관리', name:'mngBtn', index:'mngBtn', width:30, align:'center', sortable: false});

        if(applClassCd == "101715"){
            initJqGridTable('boardTable01', 'boardArea', 1300, colModels, false);
        }else if(applClassCd == "101716"){
            initJqGridTable('boardTable02', 'boardArea', 1300, colModels, false);
        }


        var dataSet = {
            params: {
                lectSer: $("#lectSer").val(),
                lectTims: $("#lectTims").val(),
                applClassCd: applClassCd
            }
        };
        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.appList.do",
            data : $.param(dataSet.params, true),
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = index + 1;
                    item.clasRoomNm = item.clasRoomNm + " (" + item.stdntCnt + ")";
                    item.tchrNm = item.tchrNm + " (" + item.mbrCualfCd + ")";

                    var mngBtn = '<button type="button" class="btn-style01" onclick="cnclLectClass(this)"><span>신청취소</span></button>';
                    mngBtn += '<input type="hidden" name="setSer" value="'+item.setSer+'"/>';
                    mngBtn += '<input type="hidden" name="schNo" value="'+item.schNo+'"/>';
                    mngBtn += '<input type="hidden" name="clasRoomSer" value="'+item.clasRoomSer+'"/>';
                    mngBtn += '<input type="hidden" name="applClassCd" value="'+item.applClassCd+'"/>';

                    item.mngBtn = mngBtn;
                    return item;
                });

                // grid data binding
                var emptyText = '등록된 데이터가 없습니다.';

                if(applClassCd == "101715"){
                    setDataJqGridTable('boardTable01', 'boardArea', 1300, memberData, emptyText);
                }else if(applClassCd == "101716"){
                    setDataJqGridTable('boardTable02', 'boardArea', 1300, memberData, emptyText);
                }

                resizeJqGridWidth('boardTable02', 'boardArea', 13000);
            }
        });
    }

    function loadTimsList(curPage, recordCountPerPage){
        if(curPage == null){
            curPage = 1;
        }

        dataSet.params.currentPageNo = curPage;
        if(recordCountPerPage != null && recordCountPerPage != 'undefined'){
            dataSet.params.recordCountPerPage = recordCountPerPage;
        }


        $('.jqgrid-overlay').show();
        $('.loading').show();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.otherTimsList.do",
            data : $.param(dataSet.params, true),
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.id = "<a class='underline' href='view.do?mbrNo='" + item.mbrNo + ">" + item.id + "</a>";
                    item.expsYn = (item.expsYn == 'Y'  ? '노출' : '비노출');
                    item.applCnt = item.applCnt + '/' + item.maxApplCnt;
                    item.obsvCnt = item.obsvCnt + '/' + item.maxObsvCnt;

                    var lectSchdData = item.lectSchdInfo.map(function(schdData, schdIndex) {
                        item.lectDay = schdData.lectDay + " " + schdData.lectStartTime + " (" + schdData.lectRunTime + "분)";
                        if(schdData.mcNm == null) {
                            schdData.mcNm = '지정안함';
                        }
                        if(schdData.stdoNm == null) {
                            schdData.stdoNm = '지정안함';
                        }
                        item.mcNm = schdData.mcNm + "/" + schdData.stdoNm;
                    });

                    return item;
                });

                // grid data binding
                emptyText = '등록된 관련 수업이 없습니다.';

                setDataJqGridTable('boardTable03', 'boardArea', 1300, memberData, emptyText);
                // grid data binding

                if(rtnData != null && rtnData.length > 0) {
                    dataSet.params.totalRecordCount = totalCount;
                } else {
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                mentor.schoolPageNavi.setData(dataSet.params);
                $('.loading').hide();
                $('.jqgrid-overlay').hide();
            }
        });
    }

    function _createSession(obj, lectSer,lectTims,schdSeq){
        $.ajax({
            url: "ajax.createSession.do",
            data : {"lectSer":lectSer,"lectTims":lectTims,"schdSeq":schdSeq},
            success: function(rtnData) {
                if(rtnData.lectSessId >= 0){
                alert("회의를 생성 했습니다.");
                getTimsSchdInfo();
                }else{
                    alert("회의 생성에 실패했습니다.");
                }
            }
        });
    }

</script>

