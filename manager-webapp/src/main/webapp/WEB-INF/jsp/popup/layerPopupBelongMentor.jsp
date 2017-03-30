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
        <c:import url="/popup/layerPopupBelongMentor.do">
          <c:param name="popupId"      value="리턴 받을 팝업명" />
          <c:param name="callbackFunc" value="리턴 받을 function 명" />
        </c:import>
        <!-- Popup[E] -->

        위와 같이 import 하고 (맨 밑에 import, 다른 contents와 섞이지 않도록 주의!) 부모창에서 레이어 오픈 호출을 아래와 같이 한다.
        $('#버튼ID').click(function(){
            $('.popup-area').css({'display': 'block'});
            emptyCorpGridSet(); <-- 꼭 호출 해야함.
        });

        학교 선택 후 확인 클릭 시 선택 된 소속 정보를 리턴 함.
        ex) {mbrNo : '0000000000', mbrNm: '멘토명', jobNm: '직업명'}
        callbackFunc 값으로 넘겨준 function 호출해줌.
--%>
<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
        <p class="pop-title">멘토찾기</p>
    </div>
    <div class="pop-cont-box">
        <p class="bullet-gray">검색어</p>
        <table class="tbl-style">
            <colgroup>
                <col style="width:120px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">요청유형</th>
                    <td>
                        <select id="jobLv1Selector" style="width:140px;">
                            <option value="">1차분류</option>
                        </select>
                        <select id="jobLv2Selector" style="width:140px;">
                            <option value="">2차분류</option>
                        </select>
                        <select id="jobLv3Selector" style="width:140px;">
                            <option value="">3차분류</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">검색유형</th>
                    <td>
                        <select id="searchType" name="searchType">
                            <option value="">전체</option>
                            <option value="name">멘토명</option>
                            <option value="id">아이디</option>
                        </select>
                        <input type="text" class="text" id="searchKey" name="searchKey" />
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
            <table id="popBoardTable"></table>
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

        enterFunc($("#searchKey"), loadData);

        // 1차 분류 코드 정보
        $.ajax({
            url: '${pageContext.request.contextPath}/jobClsfCd.do',
            data: { cdLv: 1 },
            success: function(rtnData) {
                $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });

        // 1차 분류 변경
        $('#jobLv1Selector').change(function() {

            $('#jobLv2Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 2, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 2차 분류 변경
        $('#jobLv2Selector').change(function() {

            $('#jobLv3Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 3, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

    });

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('body').removeClass('dim');
        $('.popup-area').css({'display': 'none'});
    }

    function emptyCorpGridSet() {

        // 검색조건 초기화
        $('#searchKey').val('');
        $("#searchType").val('');

        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'아이디', name:'id',index:'id', width:40, align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'nm',index:'nm', width:50, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:50, align:'center', sortable: false});
        colModels.push({label:'선택', name:'selected',index:'selected', width:20, align:'center', sortable: false});

        initJqGridTable('popBoardTable', 'popBoardArea', 500, colModels, false, 278);

        var emptyData = [];
        // grid data binding
        var emptyText = '멘토를 검색해 주세요.';
        setDataJqGridTable('popBoardTable', 'popBoardArea', 500, emptyData, emptyText, 278);
        // grid data binding
    }

    // 소속찾기 레이어 업체 조회
    function loadData() {
        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'아이디', name:'id',index:'id', width:40, align:'center', sortable: false});
        colModels.push({label:'멘토명', name:'nm',index:'nm', width:50, align:'center', sortable: false});
        colModels.push({label:'직업명', name:'jobNm',index:'jobNm', width:50, align:'center', sortable: false});
        colModels.push({label:'선택', name:'selected',index:'selected', width:20, align:'center', sortable: false});

        initJqGridTable('popBoardTable', 'popBoardArea', 500, colModels, false, 278);


        var jobClsfCd = ""
        if($('#jobLv3Selector').val() != ""){
            jobClsfCd = $('#jobLv3Selector').val();
        }else if($('#jobLv2Selector').val() != ""){
            jobClsfCd = $('#jobLv2Selector').val();
        }else{
            jobClsfCd = $('#jobLv1Selector').val();
        }

        var _param = jQuery.extend({
                'searchKey':$('#searchKey').val()
              , 'searchType':$('#searchType').val()
              , 'jobClsfCd' : jobClsfCd
        }, coDataSet.coParams);

        $.ajax({
            url: "${pageContext.request.contextPath}/layer/ajax.listBelongMentor.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var coInfoData = rtnData.map(function(item, index) {

                    item.rn = rtnData.length - item.rn + 1;
                    item.selected = "<button type='button' class='btn-style01' onclick='selectMentorInfo(\"" + item.mbrNo + "\", \"" + item.nm + "\", \"" + item.jobNm + "\")'><span>선택</span></button>";

                    return item;
                });

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, coInfoData, emptyText, 278);
                // grid data binding
            }
        });
    }

    function selectMentorInfo(mbrNo, mbrNm, jobNm) {
        var mentorInfo = {mbrNo : mbrNo, mbrNm: mbrNm, jobNm: jobNm}
         ${param.callbackFunc}(mentorInfo);
         closePop();
    }


</script>