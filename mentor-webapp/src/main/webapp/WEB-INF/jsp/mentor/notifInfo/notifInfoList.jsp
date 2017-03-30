<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="container">
    <div class="location">
        <a href="#" class="home">메인으로 이동</a>
        <span>활동이력</span>
        <span>알림내역</span>
    </div>
    <div class="content">
        <h2>알림내역</h2>
        <p class="tit-desc-txt">내게 온 알림을 확인할 수 있습니다.</p>
        <div class="cont type3">
            <div class="calculate-management lists">
                <div class="search-box">
                    <dl>
                        <dt>기간</dt>
                        <dd>
                            <span class="calendar">
                                <input type="text" class="inp-style1" style="width:110px;" id="searchStDate">
                                <!--<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_calendar.png" alt="달력"></a>--> ~
                                <input type="text" class="inp-style1" style="width:110px;" id="searchEndDate">
                                <!--<a href="#"><img src="${pageContext.request.contextPath}/images/common/btn_calendar.png" alt="달력"></a>-->
                            </span>
                            <span class="calendar-btn">
                                <a href="#" class="btn-type1" id="btnWeekRange">1주일</a>
                                <a href="#" class="btn-type1" id="btnMonthRange">1개월</a>
                                <a href="#" class="btn-type1" id="btn3MonthRange">3개월</a>
                            </span>
                        </dd>
                        <dt>조건</dt>
                        <dd>
                            <spring:eval expression="@codeManagementService.listCodeBySupCd('101737')" var="list" />
                            <select style="width:110px" id="notifTypeCd">
                                <option value="">알림유형</option>
                                <c:forEach items="${list}" var="list" varStatus="vs">
                                    <option value="${list.cd}">${list.cdNm}</option>
                                </c:forEach>
                            </select>
                            <select style="width:110px" id="notifVerfYn">
                                <option value="">상태</option>
                                <option value="Y">확인</option>
                                <option value="N">미확인</option>
                            </select>
                        </dd>
                    </dl>
                    <div class="btn-area">
                        <a href="javascript:fn_search(1);" class="btn-search"><span>검색</span></a>
                    </div>
                </div>
            </div>
            <div class="board-type1 schedule">
                <table>
                    <caption>알림내역 - 번호, 상태, 유형, 알림, 발송일, 확인일</caption>
                    <colgroup>
                        <col style="width:20px;">
                        <col style="width:65px;">
                        <col style="width:80px;">
                        <col style="width:80px;">
                        <col>
                        <col style="width:100px;">
                        <col style="width:100px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><input type="checkbox" id="checkAll"></th>
                            <th scope="col">번호</th>
                            <th scope="col">상태</th>
                            <th scope="col">유형</th>
                            <th scope="col">알림</th>
                            <th scope="col">발송일</th>
                            <th scope="col">확인일</th>
                        </tr>
                    </thead>
                    <tbody id="notifiList"></tbody>
                </table>
            </div>
            <div class="paging-btn">
                <div class="paging" id="paging"></div>
                <span class="r-btn"><a href="javascript:fn_delete();" class="btn-type5">알림삭제</a></span>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동" /></a></div>
</div>

<!-- layerpopup -->
<div class="layer-pop-wrap w480" id="notifLayer">
    <input type="hidden" id="notifSer" value="" />
    <div class="title">
        <strong>알림</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기" /></a>
    </div>
    <div class="cont board">
        <div class="box-style alert">
            <p class="alert-date" id="regDtm">2016.00.00</p>
            <p class="alert-txt" id="notifTitle">[수업개설 승인]  개설 신청 하신 수업이 승인되었습니다. </p>
            <div class="alert-desc" id="notifMsg">
                신청하신 수업이 승인되어 수업이 등록될 예정입니다. 수업등록 후, 수강모집이 시작되면 수업현황 > 수강모집 탭에서 확인할 수 있습니다.
            </div>
            <p class="alert-memo" id="lectRjctRsnSust">홍길동 선생님<br />수업과 관련하여 따로 연락 드리도록 하겠습니다.</p>
        </div>
        <div class="btn-area">
            <a href="javascript:fn_statusUpdate();" class="btn-type2" id="noShow">더 이상 보지않기</a>
        </div>
    </div>
</div>
<!-- //layerpopup -->

<%-- Template ================================================================================ --%>
<script type="text/html" id="listNotifInfo">
    <tr>
        <td><input type="checkbox" name="chkBox" value="\${notifSer}"></td>
        <td>\${fn_getNo(rn)}</td>
        <td>\${notifVerfNm}</td>
        <td>\${notifTypeNm}</td>
        <td class="al-left">
            <a href="#" onClick="fn_detail(\${notifSer})">[\${notifClsfNm}]  \${notifTitle}
                {{if notifVerfYn == 'N'}}
                    <span class="icon-new">new</span>
                {{/if}}
            </a>
        </td>
        <td>\${fn_date_to_string(regDtm)}</td>
        <td>\${fn_date_to_string(notifVerfDtm)}</td>
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
            recordCountPerPage: 15,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };

    $(document).ready(function(){

        //달력 SETTING
        _applyDatepicker($("#searchStDate"));
        _applyDatepicker($("#searchEndDate"));

        $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );
        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

        // 기본 조건값(현재달 첫째날 ~ 마지막날)
        var date = new Date();
        var startDay = new Date(date.getFullYear(), date.getMonth(), 1);
        var endDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
        $("#searchStDate").val(startDay.format("yyyy-MM-dd"));
        $("#searchEndDate").val(endDay.format("yyyy-MM-dd"));

       // 7일 버튼 클릭 event
       $("#btnWeekRange").click(function(){
           var dCurrentDate = new Date()
           var sEndDate = dCurrentDate.format("yyyy-MM-dd");
           $("#searchEndDate").val(sEndDate);
           var sStartDate = new Date(dCurrentDate.setDate(dCurrentDate.getDate() - 7)).format("yyyy-MM-dd");
           $("#searchStDate").val(sStartDate);
       });

       // 1개월 버튼 클릭 event
       $("#btnMonthRange").click(function(){
           var dCurrentDate = new Date()
           var sEndDate = dCurrentDate.format("yyyy-MM-dd");
           $("#searchEndDate").val(sEndDate);
           var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 1)).format("yyyy-MM-dd");
           $("#searchStDate").val(sStartDate);
       });

       // 3개월 버튼 클릭 event
       $("#btn3MonthRange").click(function(){
           var dCurrentDate = new Date()
           var sEndDate = dCurrentDate.format("yyyy-MM-dd");
           $("#searchEndDate").val(sEndDate);
           var sStartDate = new Date(dCurrentDate.setMonth(dCurrentDate.getMonth() - 3)).format("yyyy-MM-dd");
           $("#searchStDate").val(sStartDate);
       });

        // 체크박스 선택
        $("#checkAll").change(function(){
            var isChecked = $(this).prop("checked");
            $("input[name^='chkBox']:checkbox").each(function(){
                $(this).prop("checked",isChecked);
                if(isChecked){
                      $(this).parent().addClass("checked");
                }else{
                    $(this).parent().removeClass("checked");
                }
            });
        });

        fn_search();
    });

    function fn_search(curPage){
        if(curPage == null){
            curPage = 1;
        }
        dataSet.params.currentPageNo = curPage;

        var _param = jQuery.extend({
                'searchStDate' : $("#searchStDate").val()
              , 'searchEndDate' : $("#searchEndDate").val()
              , 'notifTypeCd' : $("#notifTypeCd").val()
              , 'notifVerfYn' : $("#notifVerfYn").val()
        }, dataSet.params);

        $.ajax({
            url: '${pageContext.request.contextPath}/notifInfo/ajax.mbrNotifInfoList.do',
            data : $.param(_param, true),
            success: function(rtnData) {
                var totalCount = 0;
                if(rtnData.length > 0) {
                    totalCount = rtnData[0].totalRecordCount;
                }
                dataSet.params.totalRecordCount = totalCount;

                $("#notifiList").empty();
                $("#listNotifInfo").tmpl(rtnData).appendTo("#notifiList");

                mentor.pageNavi.setData(dataSet.params);
            },
            error: function(request,status,error){
                 alert("error:"+error);
            }
        });
    }

    // 번호 정렬
    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }

    // 상세조회
    function fn_detail(notifSer){
        $('#notifSer').val(notifSer);
        $.ajax({
            url: '${pageContext.request.contextPath}/notifInfo/ajax.mbrNotifInfoList.do',
            data : {'notifSer': notifSer},
            success: function(rtnData) {
                $('#regDtm').text(fn_date_to_string(rtnData[0].regDtm));
                $('#notifTitle').html(rtnData[0].notifTitle);
                $('#notifMsg').html(String(rtnData[0].notifMsg).replaceAll('\n', '<br>'));
                $('#lectRjctRsnSust').html(String(rtnData[0].lectRjctRsnSust).replaceAll('\n', '<br>'));

                if(rtnData[0].notifVerfYn == 'Y'){
                    $('#noShow').css('display', 'none');
                }else{
                    $('#noShow').css('display', '');
                }
            },
            error: function(request,status,error){
                 alert("error:"+error);
            }
        });
        layerOpen();
    }

    // 레이어팝업 열기
    function layerOpen(){
        $('body').addClass('dim');
        $('.selectbox-zindex-box').css('display', 'block');
        $('#notifLayer').attr('tabindex',0).show().focus();
    }

    // 레이어 팝업 닫기
    $('.pop-close').click(function(){
        // 기존 데이터 삭제
        $('#notifSer').val('');

        $('#notifLayer').hide();
        $('.selectbox-zindex-box').css('display', 'none');
        $('body').removeClass('dim');
    });

    // 팝업 더이상보지않기 클릭 (알림상태 확인 update)
    function fn_statusUpdate(){
        $.ajax({
            url: '${pageContext.request.contextPath}/notifInfo/ajax.notifVerf.do',
            data : {'notifSer': $('#notifSer').val()},
            contentType: "application/json",
            dataType: 'text',
            type: 'GET',
            traditional: true,
            success: function(rtnData) {
                if(rtnData == 'SUCCESS'){
                    fn_search(dataSet.params.currentPageNo);
                    $('.pop-close').trigger('click');
                }
            },
            error: function(xhr, status, err) {
                alert(err);
            }
        });
    }

    // 알림삭제
    function fn_delete(){
        if(confirm("삭제하시겠습니까?")){
            var notifSers = new Array();
            $('input[name=chkBox]:checked').each(function(){
                notifSers.push($(this).val());
            });

            $.ajax({
                url: '${pageContext.request.contextPath}/notifInfo/ajax.deleteNotifInfo.do',
                data : {'notifSers': notifSers},
                contentType: "application/json",
                dataType: 'text',
                type: 'GET',
                traditional: true,
                success: function(rtnData) {
                    if(rtnData == 'SUCCESS'){
                        alert('삭제되었습니다.');
                        location.reload();
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.deleteNotifInfo.do", status, err.toString());
                }
            });
        }

    }



</script>