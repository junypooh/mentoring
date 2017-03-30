<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
		<h2>수업등록관리</h2>
		<ul class="location">
			<li class="home">Home</li>
			<li>수업관리</li>
			<li>수업개설관리</li>
			<li>수업등록관리</li>
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
		<input type="hidden" id="lectrMbrNo" value="${lectInfo.lectrMbrNo}"/>
		<input type="hidden" id="lectStatCd" value="${lectInfo.lectStatCd}"/>
		<input type="hidden" id="BizMaxApplCnt" value="${lectInfo.maxApplCnt}"/>
		<input type="hidden" id="BizMaxObsvCnt" value="${lectInfo.maxObsvCnt}"/>
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
					<li><button type="button" class="btn-orange" onclick="location.href='edit.do?lectSer=${lectInfo.lectSer}'"><span>수정</span></button></li>
					<li><button type="button" class="btn-style02" onclick="location.href='list.do'"><span>목록</span></button></li>

				</ul>
			</div>
		</div>
		<div class="board-area board-area-bot" id="boardArea">
			<div class="board-top">
				<p>수업 차수 정보</p>
                <ul>
                    <li>
                        <button type="button" class="btn-style02" onClick="getTimsAddPopUp();"><span>+일시추가</span></button>
                    </li>
                </ul>
			</div>
			<table id="boardTable03"></table>
            <div id="paging"></div>
		</div>
	</div>
</div>

<c:import url="/popup/layerLectTimsAdd.do">
  <c:param name="popupId" value="_lectTimsAddPopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>
<c:import url="/popup/layerApplCntMcStdoUpdate.do">
  <c:param name="popupId" value="_applCntMcStdoUpdatePopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>
<c:import url="/popup/layerCnclLectureManager.do">
  <c:param name="popupId" value="_cnclLecturePopup" />
  <c:param name="callbackFunc" value="callbackUpdated" />
</c:import>

<script type="text/jsx;harmony=true">
    mentor.schoolPageNavi = React.render(
        <PageNavi  pageFunc={loadTimsList} totalRecordCount={0} currentPageNo={1} recordCountPerPage={20} pageSize={10} />,
        document.getElementById('paging')
    );
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
        colModels.push({label:'번호', name:'rn', index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'수업일시', name:'lectDay', index:'lectDay', width:40, align:'center', sortable: false});
        colModels.push({label:'수업상태', name:'lectStatCdNm', index:'lectStatCdNm', width:20, align:'center', sortable: false});
        colModels.push({label:'MC 및 스튜디오', name:'mcNm', index:'mcNm', width:100, align:'center', sortable: false});
        colModels.push({label:'신청', name:'applCnt',index:'applCnt', width:30, align:'center', sortable: false});
        colModels.push({label:'참관', name:'obsvCnt',index:'obsvCnt', width:30, align:'center', sortable: false});
        colModels.push({label:'관리', name:'lectCncl', index:'lectCncl', width:15, align:'center' , sortable: false});
        colModels.push({label:'노출여부', name:'expsYn', index:'expsYn', width:15, align:'center' , sortable: false});


        initJqGridTable('boardTable03', 'boardArea', 1300, colModels, false);
        //jqGrid setting

        $('.bxslider').bxSlider({
            auto: false,
            controls : false,
            autoHover : false
        });


        //동일 수업 다른 차수 정보 그리드
        loadTimsList(1);

     });


    /** 노출/ 비노출 버튼 클릭 */
    function lectExpsUpdate(obj) {

        if(!confirm("수정 하시겠습니까?")) {
            return false;
        }

        var expsDataSet = {
            params: {
                lectSer: $("#lectSer").val(),
                lectTims: $(obj).parent().find('input[name=lectTims]').val(),
                expsYn :  $(obj).parent().find('input[name=expsYn]').val()
            }
        };

        $.ajax({
            url:"ajax.expsLect.do",
            data : $.param(expsDataSet.params, true),
            method:"post",
            success: function(rtnData) {
                if(rtnData.success == true){
                    loadTimsList();
                }else{
                    alert(rtnData.message);
                }
            }
        });
    }

    function getTimsAddPopUp(){
        if(${lectInfo.lectTypeCd != '101530' }){
            fnAddSchdSeq(1);
        }
        $('#timsAddApplCnt').val($('#BizMaxApplCnt').val());
        $('#timsAddObsvCnt').val($('#BizMaxObsvCnt').val());
        $('body').addClass('dim');
        $("#_lectTimsAddPopup").css("display","block");
    }

    function getApplCntMcStdoUpdatePopUp(lectSer, lectTims){

        $('body').addClass('dim');
        $("#_applCntMcStdoUpdatePopup").css("display","block");
        getTimsUpdateInfo(lectSer, lectTims);
    }

    function getCnclLecturePopUp(lectTims, lectureCnt){
        $('body').addClass('dim');
        $("#_cnclLecturePopup").css("display","block");
        cnclLectInit(lectTims, lectureCnt);

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
            url: "${pageContext.request.contextPath}/lecture/mentor/register/ajax.lectTimsList.do",
            data : $.param(dataSet.params, true),
            method:"post",
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                var memberData = rtnData.map(function(item, index) {
                    item.rn = totalCount - item.rn + 1;
                    item.applCnt = item.applCnt + '/' + item.maxApplCnt;
                    item.obsvCnt = item.obsvCnt + '/' + item.maxObsvCnt;

                    var lectSchdData = item.lectSchdInfo.map(function(schdData, schdIndex) {
                        item.lectDay = schdData.lectDay + " " + schdData.lectStartTime + " ~ " + schdData.lectEndTime + " (" + schdData.lectRunTime + "분)";
                        item.lectDay = '<a href="#" class="underline" onclick="getApplCntMcStdoUpdatePopUp('+item.lectSer+', '+item.lectTims+')">'+item.lectDay+'</a>'
                        if(schdData.mcNm == null) {
                            schdData.mcNm = '지정안함';
                        }
                        if(schdData.stdoNm == null) {
                            schdData.stdoNm = '지정안함';
                        }
                        item.mcNm = schdData.mcNm + "/" + schdData.stdoNm;
                    });

                    if(item.expsYn == 'Y'){
                       item.expsYn = '<button type="button" class="btn-style01" onclick="lectExpsUpdate(this)"><span>노출</span></button>';
                       item.expsYn += '<input type="hidden" name="expsYn" value="N"/>';
                    }else{
                        item.expsYn = '<button type="button" class="btn-style01" onclick="lectExpsUpdate(this)"><span>비노출</span></button>';
                        item.expsYn += '<input type="hidden" name="expsYn" value="Y"/>';
                    }
                    item.expsYn += '<input type="hidden" name="lectTims" value="'+item.lectTims+'"/>';

                    if(item.lectStatCd == '101542' || item.lectStatCd == '101543' || item.lectStatCd == '101548'){
                        item.lectCncl = '<button type="button" class="btn-style01" id="cnclLecturePopup" onclick="getCnclLecturePopUp('+item.lectTims+', '+item.lectureCnt+')"><span>취소</span></button>'
                    }else{
                        item.lectCncl = '<button type="button" class="btn-style01 default" disabled="true"><span>취소</span></button>'
                    }

                    return item;
                });

                // grid data binding
                emptyText = '등록된 데이터가 없습니다.';

                setDataJqGridTable('boardTable03', 'boardArea', 1300, memberData, emptyText);
                // grid data binding

                resizeJqGridWidth('boardTable03', 'boardArea', 13000);

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

</script>

