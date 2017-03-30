<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<%--
    [학교찾기 공통 레이어 팝업]
    - 사용법 :

        <!-- Popup -->
        <c:import url="/popup/schoolSearch.do">
          <c:param name="callbackFunc" value="리턴 받을 function 명" />
        </c:import>
        <!-- Popup[E] -->

        위와 같이 import 하고 (맨 밑에 import, 다른 contents와 섞이지 않도록 주의!) 부모창에서 레이어 오픈 호출을 아래와 같이 한다.
        $('#addSchRpsBtn').click(function(){
            $('.popup-area').css({'display': 'block'});
            emptySchoolGridSet(); <-- 꼭 호출 해야함.
        });

        학교 선택 후 확인 클릭 시 선택 된 학교 정보를 Array 형태로 리턴 함.
        ex) ['0000001237', '0000001242']
        callbackFunc 값으로 넘겨준 function 호출해줌.
--%>
<script type="text/javascript">
    var schoolCategory = {
        '${codeConstants["CD100494_100495_초등학교"]}': '초',
        '${codeConstants["CD100494_100496_중학교"]}': '중',
        '${codeConstants["CD100494_100497_고등학교"]}': '고',
        '${codeConstants["CD100494_100500_기타"]}': '기타',
    };
</script>
<div class="popup-area"  style="display:none;">
    <input type="hidden" name="grpNo" value="${param.grpNo}" />
    <div class="pop-title-box">
        <p class="pop-title">학교 찾기</p>
    </div>
    <div class="pop-cont-box">
        <p class="bullet-gray">학교 찾기</p>
        <table class="tbl-style">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">학교급</th>
                    <td class="condition-big" id="rdoSchClassCds">
                        <label>
                            <input type="radio" name="schClassCd" checked='checked' value="" /> 전체
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">지역/시군구</th>
                    <td>
                        <select id="sidoNm" name="sidoNm">
                            <option value="">지역선택</option>
                        </select>
                        <span> / </span>
                        <select id="sgguNm" name="sgguNm" title="지역선택(구/군)">
                            <option value="">시군구 선택</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">학교</th>
                    <td>
                        <input type="text" class="text" name="schNm" id="schNm" />
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="btn-group-c">
            <button type="button" class="btn-style02" onclick="loadSchoolData()"><span class="search">검색</span></button>
        </div>
        <div id="popBoardArea" class="pop-board-area">
            <div class="board-bot">
                <p class="bullet-gray fl-l">검색결과</p>
                <ul>
                    <li><button type="button" class="btn-orange" onclick="donePop()"><span>선택</span></button></li>
                    <li><button type="button" class="btn-gray" onclick="closePop()"><span>취소</span></button></li>
                </ul>
            </div>
            <table id="popBoardTable"></table>
        </div>
    </div>
    <a href="javascript:void(0)" class="btn-close-pop" onclick="closePop()">닫기</a>
</div>

<script type="text/javascript">

    var dataSet = {
        schParams: {
            recordCountPerPage: 20,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function() {
        sidoInfo();
        var schClassCds = [];
        $.each(schoolCategory, function(k, v) {
            schClassCds.push($('<label><input type="radio" name="schClassCd" value="' + k + '" /> ' + v + '</label>'));
        });

        $('#rdoSchClassCds').append(schClassCds);

        $('.popup-area').css({'display': 'none'});

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                closePop();
            }
        });


        // 지역 변경
        $('#sidoNm').change(function() {
            $('#sgguNm').find('option:not(:first)').remove()
                .end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/school/info/ajax.sgguInfo.do', {
                    data: { sidoNm: this.value },
                    success: function(rtnData) {
                        $('#sgguNm').loadSelectOptions(rtnData,'','sgguNm','sgguNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        enterFunc($("#schNm"), loadSchoolData);
    });

    /** 확인 버튼 클릭 */
    function donePop() {
    if(!confirm("학교를 추가하시겠습니까?")) {
        return false;
    }

        var selSchool =  $('#popBoardTable').jqGrid('getGridParam','selarrrow');

        if(selSchool == null || selSchool == '') {
            alert('학교를 선택해 주세요.');
        } else {
            ${param.callbackFunc}($.makeArray(selSchool));
        }
    }

    /** 취소/닫기 버튼 클릭 */
    function closePop() {
        $('body').removeClass('dim');
        $('.popup-area').css({'display': 'none'});
    }

    function emptySchoolGridSet() {
        // 검색조건 초기화
        $(':radio[name="schClassCd"]').eq(0).prop('checked', 'checked');
        $('#sidoNm').val('');
        $('#sgguNm').find('option:not(:first)').remove().end().val('').change();
        $("#schNm").val('');

        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassNm',index:'schClassNm', width:20, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:30, sortable: false});
        colModels.push({label:'시군구', name:'sgguNm',index:'sgguNm', width:30, sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:50, sortable: false});

        initJqGridTable('popBoardTable', 'popBoardArea', 1300, colModels, true, 278);

        var emptyData = [];
        // grid data binding
        var emptyText = '학교를 검색해 주세요.';
        setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, emptyData, emptyText, 278);
        // grid data binding
    }

    // 대표학교 추가 레이어 학교 조회
    function loadSchoolData() {
        //jqGrid
        var colModels = [];
        colModels.push({label:'번호', name:'rn',index:'rn', width:10, align:'center', sortable: false});
        colModels.push({label:'학교급', name:'schClassNm',index:'schClassNm', width:20, align:'center', sortable: false});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:30, sortable: false});
        colModels.push({label:'시군구', name:'sgguNm',index:'sgguNm', width:30, sortable: false});
        colModels.push({label:'학교', name:'schNm',index:'schNm', width:50, sortable: false});

        initJqGridTable('popBoardTable', 'popBoardArea', 1300, colModels, true, 278);

        var _param = jQuery.extend({'schClassCd':$(':radio[name="schClassCd"]:checked').val()
                                  ,'sidoNm':$("#sidoNm").val()
                                  ,'sgguNm':$("#sgguNm").val()
                                  ,'schNm':$("#schNm").val()
                                  ,'grpNo':$("#grpNo").val()}, dataSet.schParams);

        $.ajax({
            //url: "${pageContext.request.contextPath}/school/info/ajax.listSchInfoWithGroup.do",
            url: "${pageContext.request.contextPath}/ajax.listSchool.do",
            data : $.param(_param, true),
            success: function(rtnData) {

                var schoolData = rtnData.map(function(item, index) {

                    item.rn = rtnData.length - item.rn + 1;
                    item.gridRowId = item.schNo;
                    var groups = [];



                    return item;
                });

                // grid data binding
                var emptyText = '검색된 결과가 없습니다.';
                setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, schoolData, emptyText, 278);
                // grid data binding
            }
        });
    }

    function sidoInfo(){
        $('#sidoNm').find('option:not(:first)').remove()
            .end().val('').change();
        $.ajax('${pageContext.request.contextPath}/school/info/ajax.sidoInfo.do', {
            success: function(rtnData) {
                $('#sidoNm').loadSelectOptions(rtnData,'','sidoNm','sidoNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });
    }


</script>