<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>

<div id="container">
    <div class="location">
        <a href="#" class="home">메인으로 이동</a>
        <span>수업관리</span>
        <span>자료등록</span>
    </div>
    <div class="content">
        <h2>자료등록</h2>
        <div class="cont type3">
            <div class="calculate-management lists">
                <div class="search-box">
                    <dl class="long">
                        <dt>조건검색</dt>
                        <dd>
                            <select id="searchKey" style="width:108px;">
                                <option value="">전체</option>
                                <option value="ownerMbrNm">멘토</option>
                                <option value="jobNm">직업명</option>
                                <option value="dataNm">자료명</option>
                            </select>
                            <input type="text" class="inp-style1" style="width:282px;" id="searchWord" name="searchWord">
                        </dd>
                        <dt>자료대상</dt>
                        <dd>
                            <input type="hidden" id="dataTargtClass" value="" />
                            <label class="chk-skin"><input type="checkbox" name="schoolGrd" class="chk-skin" value="101534">초</label>
                            <label class="chk-skin"><input type="checkbox" name="schoolGrd" class="chk-skin" value="101535">중</label>
                            <label class="chk-skin"><input type="checkbox" name="schoolGrd" class="chk-skin" value="101536">고</label>
                            <label class="chk-skin"><input type="checkbox" name="schoolEtcGrd" class="chk-skin" value="101713">기타</label>
                        </dd>
                        <dt>구분</dt>
                        <dd>
                            <select id="intdcDataYn" style="width:108px;">
                                <option value="">전체</option>
                                <option value="N">수업자료</option>
                                <option value="Y">멘토자료</option>
                            </select>
                        </dd>
                    </dl>
                    <div class="btn-area">
                        <a href="javascript:fn_search(1);" class="btn-search"><span>검색</span></a>
                    </div>
                </div>
            </div>
            <div class="lesson-task">
                <span class="list-num">
                    <select id="perPage" style="width:70px;">
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="30">30</option>
                    </select>
                </span>
            </div>
            <div class="board-type1 schedule">
                <table>
                    <caption>정산관리 - 번호, 수업일, 시간, 멘토명, 직업명, 유형, 수업명, 신청디바이스, 상태</caption>
                    <colgroup>
                        <col style="width:65px;">
                        <col style="width:92px;">
                        <col style="width:65px;">
                        <col>
                        <col style="width:122px;">
                        <col style="width:60px;">
                        <col style="width:100px;">
                        <col>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">구분</th>
                            <th scope="col">대상</th>
                            <th scope="col">자료명</th>
                            <th scope="col">연결수업수</th>
                            <th scope="col">직업명</th>
                            <th scope="col">멘토</th>
                            <th scope="col">최종수정일</th>
                        </tr>
                    </thead>
                    <tbody id="dataList">
                    </tbody>
                </table>
            </div>
            <div class="paging-btn">
                <div class="paging" id="paging"></div>
                <span class="r-btn"><a href="javascript:dataInsert();" class="btn-type1">자료등록</a></span>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listDataInfo">
    <tr>
        <td>\${fn_getNo($data.rn)}</td>
        <td>\${intdcDataNm}</td>
        <td>
            {{if dataTargtClass == '101534'}}초{{/if}}
            {{if dataTargtClass == '101535'}}중{{/if}}
            {{if dataTargtClass == '101536'}}고{{/if}}
            {{if dataTargtClass == '101537'}}초중{{/if}}
            {{if dataTargtClass == '101538'}}중고{{/if}}
            {{if dataTargtClass == '101539'}}초고{{/if}}
            {{if dataTargtClass == '101540'}}초중고{{/if}}
            {{if dataTargtClass == '101713'}}기타{{/if}}
        </td>
        <td class="al-left"><a href="javascript:fn_goDetail('\${dataSer}');">\${dataNm}</a></td>
        <td>\${connectLect}</td>
        <td>\${jobNm}</td>
        <td>\${ownerMbrNm}</td>
        <td>\${chgDtm}</td>
    </tr>
</script>
<%-- Template ================================================================================ --%>

<script type="text/jsx;harmony=true">
    mentor.pageNavi = React.render(
        <PageNavi  pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} pageSize={10} />,
                 document.getElementById('paging')
             );
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function(){
        enterFunc($("#searchWord"), fn_search);
        fn_search();
    });


    function fn_search(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        //자료대상 체크박스
        //dataTargtClass
        var checkDataTargt = new Array;
        $('input[name=schoolGrd]:checked').each(function(index){
            checkDataTargt.push($(this).val());
        });

        if(checkDataTargt.length == 1){
            $("#dataTargtClass").val(checkDataTargt[0]);
        }else if(checkDataTargt.length == 2){
            if (!!~checkDataTargt.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkDataTargt.indexOf("${code['CD101533_101535_중학교']}")) { //초등,중학교
                $("#dataTargtClass").val("${code['CD101533_101537_초등_중학교'] }");
            } else if (!!~checkDataTargt.indexOf("${code['CD101533_101535_중학교']}") && !!~checkDataTargt.indexOf("${code['CD101533_101536_고등학교']}")) { //중등,고등학교
                $("#dataTargtClass").val("${code['CD101533_101538_중_고등학교'] }");
            } else if (!!~checkDataTargt.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkDataTargt.indexOf("${code['CD101533_101536_고등학교']}")) { //초등,고등학교
                $("#dataTargtClass").val("${code['CD101533_101539_초등_고등학교'] }");
            }
        }else if(checkDataTargt.length == 3){
            $("#dataTargtClass").val("${code['CD101533_101540_초등_중_고등학교'] }");
        }else{
            $("#dataTargtClass").val("");
        }

        var _param = jQuery.extend({
                'searchKey' : $("#searchValue").val()
              , 'searchWord' : $("#searchWord").val()
              , 'intdcDataYn' : $("#intdcDataYn").val()
              , 'schoolGrd' : $("#dataTargtClass").val()
              , 'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val()
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.lectureDataList.do',
            data : $.param(_param, true),
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                $("#dataList").empty();
                $("#listDataInfo").tmpl(rtnData).appendTo("#dataList");


                mentor.pageNavi.setData(dataSet.params);

            }
        });
    }

    // 번호 정렬
    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }

    // 자료등록
    function dataInsert(){
        location.href = '${pageContext.request.contextPath}/lecture/lectureData/lectureDataEdit.do';
    }

    $('#perPage').change(function(){
        dataSet.params.recordCountPerPage = $('#perPage').val();
        fn_search(1);
    });

    /* 상세보기 */
    function fn_goDetail(dataSer){
        location.href = '${pageContext.request.contextPath}/lecture/lectureData/lectureDataEdit.do?dataSer=' + dataSer;
    }
</script>