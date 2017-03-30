<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="popup-area" id="_reqLecturePopup" style="display:none;">
    <div class="pop-title-box">
        <p class="pop-title">수업 신청</p>
    </div>
    <div class="pop-cont-box">
        <p class="bullet-gray">수업 신청 추가 반조회</p>
        <table class="tbl-style">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">유형</th>
                    <td>
						<label>
							<input type="radio" name="mbrType" value="" checked/> 전체
						</label>
						<label>
							<input type="radio" name="mbrType" value="101691" /> 반대표
						</label>
						<label>
							<input type="radio" name="mbrType" value="101689"/> 교사
						</label>
					</td>
                </tr>
                <tr>
					<th scope="col" class="ta-l">학교급</th>
					<td>
						<label>
							<input type="radio" name="schoolGrd" value="" checked/> 전체
						</label>
                        <spring:eval expression="@codeManagementService.listUseCodeBySupCd(codeConstants['CD100211_100494_학교'])" var="schoolGrd" />
		                <c:forEach items="${schoolGrd}" var="eachObj">
                            <label><input type="radio" name="schoolGrd" value="${eachObj.cd}"/> ${eachObj.cdNm}</label>
                        </c:forEach>
					</td>
				</tr>
                <tr>
                    <th scope="col" class="ta-l">학교명</th>
                    <td>
                        <input type="text" name="schNm" id="schNm" class="text"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">이름</th>
                    <td>
                        <input type="text" name="mbrNm" id="mbrNm" class="text"/>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">아이디</th>
                    <td>
                        <input type="text" name="mbrId" id="mbrId" class="text"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="btn-group-c">
            <button type="button" class="btn-style02" onclick="loadData()"><span class="search">검색</span></button>
        </div>
        <div id="popBoardArea" class="pop-board-area">
            <div class="board-bot">
                <p class="bullet-gray fl-l">검색결과</p>
            </div>
            <table id="classListBoardTable"></table>
        </div>
    </div>
    <a href="javascript:void(0)" class="btn-close-pop" onclick="closePop()">닫기</a>
</div>

<script type="text/javascript">
    var dataSet = {
        params: {
            mbrId: $("#mbrId").val(),
            mbrNm: $("#mbrNm").val(),
            schNm: $("#schNm").val(),
            schoolGrd : $(':radio[name="schoolGrd"]:checked').val(),
            mbrType : $(':radio[name="mbrType"]:checked').val(),
            lectSer : $("#lectSer").val(),
            lectTims : $("#lectTims").val(),
            applClassCd : ""
        }
    };

    $(document).ready(function() {

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closePop();
            }
        });

        enterFunc($("#mbrNm"), loadData);
        enterFunc($("#mbrId"), loadData);
        enterFunc($("#schNm"), loadData);

    });

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('.popup-area').css({'display': 'none'});
        $('body').removeClass('dim');
    }

    function emptyCorpGridSet(applClassCd) {

        dataSet.params.applClassCd = applClassCd;

        $("#mbrNm").val("");
        $("#mbrId").val("");
        $("#schNm").val("");
        var colModels = [];

        colModels.push({label:'번호', name:'no',index:'no', width:'5', align:'center', sortable: false});
        colModels.push({label:'유형', name:'tchrMbrClassNm',index:'tchrMbrClassNm', width:'5', align:'center', sortable: false});
        colModels.push({label:'이름', name:'tchrMbrNm',index:'tchrMbrNm', width:'8', align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schGrdNm',index:'schGrdNm', width:'5', align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:'12', align:'center', sortable: false});
        colModels.push({label:'학급/그룹(신청가능횟수)', name:'clasRoomNm',index:'clasRoomNm', width:'30', align:'center', sortable: false});
        colModels.push({label:'선택', name:'clasRoomSer',index:'clasRoomSer', width:'8', align:'center', sortable: false});

        initJqGridTable('classListBoardTable', 'popBoardArea', 1300, colModels, false, 278);

        var emptyData = [];
        // grid data binding
        var emptyText = '소속을 검색해 주세요.';
        setDataJqGridTable('classListBoardTable', 'popBoardArea', 1300, emptyData, emptyText, 278);
        // grid data binding
    }

    // 소속찾기 레이어 업체 조회
    function loadData() {
        var colModels = [];

        colModels.push({label:'번호', name:'no',index:'no', width:'5', align:'center', sortable: false});
        colModels.push({label:'유형', name:'tchrMbrClassNm',index:'tchrMbrClassNm', width:'5', align:'center', sortable: false});
        colModels.push({label:'이름', name:'tchrMbrNm',index:'tchrMbrNm', width:'8', align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schGrdNm',index:'schGrdNm', width:'5', align:'center', sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:'12', align:'center', sortable: false});
        colModels.push({label:'학급/그룹(신청가능횟수)', name:'clasRoomNm',index:'clasRoomNm', width:'30', align:'center', sortable: false});
        colModels.push({label:'선택', name:'clasRoomSer',index:'clasRoomSer', width:'8', align:'center', sortable: false});

        initJqGridTable('classListBoardTable', 'popBoardArea', 1300, colModels, false, 278);

        dataSet.params.mbrId = $("#mbrId").val();
        dataSet.params.mbrNm = $("#mbrNm").val();
        dataSet.params.schNm = $("#schNm").val();
        dataSet.params.schoolGrd = $(':radio[name="schoolGrd"]:checked').val();
        dataSet.params.mbrType = $(':radio[name="mbrType"]:checked').val();

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.listLectClass.do",
            data : $.param(dataSet.params, true),
            contentType: "application/json",
            dataType: 'json',
            success: function(rtnData) {
                var rtnData = rtnData.map(function(item, index) {
                    item.no = index +1;
                    item.clasRoomNm = item.clasRoomNm + '/' + '${lectInfo.grpNm}' + '(' + item.applyCnt + ')';

                    var clasRoomSer = '<button type="button" class="btn-style01" onClick="clickOk(this);"><span>선택</span></button>';
                    clasRoomSer += '<input type="hidden" name="setSer" value="'+item.setSer+'"/>';
                    clasRoomSer += '<input type="hidden" name="classNo" value="'+item.clasRoomSer+'"/>';
                    clasRoomSer += '<input type="hidden" name="applyCnt" value="'+item.applyCnt+'"/>';
                    clasRoomSer += '<input type="hidden" name="schClassCd" value="'+item.schGrdCd+'"/>';
                    clasRoomSer += '<input type="hidden" name="schNo" value="'+item.schNo+'"/>';
                    clasRoomSer += '<input type="hidden" name="tchrMbrNo" value="'+item.tchrMbrNo+'"/>';
                    item.clasRoomSer = clasRoomSer;
                    return item;
                });
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('classListBoardTable', 'popBoardArea', 1300, rtnData, emptyText, 200);

            }
        });
    }

   function clickOk(obj){
        var lectureCnt = $('#lectureCnt').val();

        var applyCnt = $(obj).parent().find('input[name=applyCnt]').val();

        if(dataSet.params.applClassCd == "101715" && Number(lectureCnt) > Number(applyCnt))
        {
            alert("수업 신청 가능 횟수가 부족합니다.");
            return false;
        }

        if(dataSet.params.applClassCd == "101716" && Number(lectureCnt/2) > Number(applyCnt))
        {
            alert("수업 참관 가능 횟수가 부족합니다.");
            return false;
        }

        if(!confirm("수업 신청을 진행 하시겠습니까?")) {
            return false;
        }

        var _param = jQuery.extend({'setSer':$(obj).parent().find('input[name=setSer]').val(),
                                    'clasRoomSer': $(obj).parent().find('input[name=classNo]').val(),
                                    'schClassCd': $(obj).parent().find('input[name=schClassCd]').val(),
                                    'schNo': $(obj).parent().find('input[name=schNo]').val(),
                                    'tchrMbrNo': $(obj).parent().find('input[name=tchrMbrNo]').val(),
                                    'lectTargtCd': ${lectInfo.lectTargtCd},
                                    'lectTypeCd' : ${lectInfo.lectTypeCd},
                                    'lectureCnt' : lectureCnt
                                   },  dataSet.params);
        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.lectInsertClass.do",
            data : $.param(_param, true),
            method : "post",
            success: function(rtnData) {
                if(rtnData.success == true){
                    alert(rtnData.data);
                    closePop();
                    getTimsSchdInfo();
                    loadApplList("101715");
                    loadApplList("101716");
                }else{
                    alert(rtnData.message);
                }
            }
        });
    }

</script>