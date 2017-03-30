<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<%--
    [소속찾기 공통 레이어 팝업]
    - 사용법 :

        <!-- Popup -->
        <c:import url="/popup/coInfoSearch.do">
          <c:param name="callbackFunc" value="리턴 받을 function 명" />
        </c:import>
        <!-- Popup[E] -->

        위와 같이 import 하고 (맨 밑에 import, 다른 contents와 섞이지 않도록 주의!) 부모창에서 레이어 오픈 호출을 아래와 같이 한다.
        $('#버튼ID').click(function(){
            $('.popup-area').css({'display': 'block'});
            emptyCorpGridSet(); <-- 꼭 호출 해야함.
        });

        학교 선택 후 확인 클릭 시 선택 된 소속 정보를 리턴 함.
        ex) {coNm : '강원도교육청', coNo: '0000000010'}
        callbackFunc 값으로 넘겨준 function 호출해줌.
--%>
<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
        <p class="pop-title">소속찾기</p>
    </div>
    <div class="pop-cont-box">
        <p class="bullet-gray">소속선택</p>
        <table class="tbl-style">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">소속유형</th>
                    <td>
                        <spring:eval expression="@codeManagementService.listCodeBySupCd(codeConstants['CD101512_101659_업체구분코드'])" var="coClassCd" />
                        <select id="coClassCd" name="coClassCd">
                            <option value="">전체</option>
                            <c:forEach items="${coClassCd}" var="eachObj" varStatus="vs">
                            <option value="${eachObj.cd}">${eachObj.cdNm}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">검색어</th>
                    <td>
                        <input type="text" class="text" id="coNm" name="coNm" />
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="btn-group-c">
            <button type="button" class="btn-style02" onclick="loadData()"><span class="search">검색</span></button>
        </div>
        <div id="popCoBoardArea" class="pop-board-area">
            <div class="board-bot">
                <p class="bullet-gray fl-l">검색결과</p>
            </div>
            <table id="popCoBoardTable"></table>
        </div>
    </div>
    <a href="javascript:void(0)" class="btn-close-pop" onclick="closePop()">닫기</a>
</div>

<script type="text/javascript">

    var coDataSet = {
        coParams: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function() {

        $('.popup-area').css({'display': 'none'});

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closePop();
            }
        });

        enterFunc($("#coNm"), loadData);
    });

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('body').removeClass('dim');
        $('.popup-area').css({'display': 'none'});
    }

    function emptyCorpGridSet() {

        // 검색조건 초기화
        $('#coClassCd').val('');
        $("#coNm").val('');

        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'소속유형', name:'coClassNm',index:'schClassNm', width:40, align:'center', sortable: false});
        colModels.push({label:'소속명', name:'coNm',index:'coNm', width:70, align:'center', sortable: false});
        colModels.push({label:'선택', name:'selected',index:'selected', width:20, align:'center', sortable: false});

        initJqGridTable('popCoBoardTable', 'popCoBoardArea', 1300, colModels, false, 278);

        var emptyData = [];
        // grid data binding
        var emptyText = '소속을 검색해 주세요.';
        setDataJqGridTable('popCoBoardTable', 'popCoBoardArea', 1300, emptyData, emptyText, 278);
        // grid data binding
    }

    // 소속찾기 레이어 업체 조회
    function loadData() {
        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'소속유형', name:'coClassNm',index:'schClassNm', width:40, align:'center', sortable: false});
        colModels.push({label:'소속명', name:'coNm',index:'coNm', width:70, align:'center', sortable: false});
        colModels.push({label:'선택', name:'selected',index:'selected', width:20, align:'center', sortable: false});

        initJqGridTable('popCoBoardTable', 'popCoBoardArea', 1300, colModels, false, 278);

        var _param = jQuery.extend({'coClassCd':$('#coClassCd').val()
                                  ,'coNm':$("#coNm").val()}, coDataSet.coParams);

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/corp/ajax.list.nopaging.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var coInfoData = rtnData.map(function(item, index) {

                    item.rn = rtnData.length - item.rn + 1;
                    item.selected = "<button type='button' class='btn-style01' onclick='selectCoInfo(\"" + item.coNo + "\", \"" + item.coNm + "\")'><span>선택</span></button>";

                    return item;
                });

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('popCoBoardTable', 'popCoBoardArea', 1300, coInfoData, emptyText, 278);
                // grid data binding
            }
        });
    }

    function selectCoInfo(coNo, coNm) {
        var coInfo = {coNo : coNo, coNm: coNm}
         ${param.callbackFunc}(coInfo);
         closePop();
    }


</script>