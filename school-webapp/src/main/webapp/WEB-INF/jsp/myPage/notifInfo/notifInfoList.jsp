<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<cnet:loadConstants className="kr.or.career.mentor.constant.CodeConstants" var="code"/>
<security:authorize access="isAuthenticated()">
    <security:authentication var="mbrClassCd" property="principal.mbrClassCd" />
</security:authorize>

<div id="container">
    <div class="location">
        <a href="#" class="home">HOME</a>
        <span class="first">마이페이지</span>
        <span>알림내역</span>
    </div>
    <div class="content sub">
        <div class="title-group">
            <h2 class="txt-type">알림내역</h2>
            <p class="tit-desc-txt">내게 온 알림을 확인할 수 있습니다.</p>
        </div>
        <div class="review-tbl-wrap">
            <div class="review-tbl">
                <div class="selectbox-zindex-wrap">
                    <div class="selectbox-zindex-box">
                        <div class="m-height540"></div>
                        <iframe scrolling="no" title="빈프레임" class="m-height540" frameborder="0"></iframe>
                    </div>
                </div>
                <table>
                    <caption>수업 다시보기 검색창 - 날짜,학교,시간,수업유형,키워드,직업</caption>
                    <colgroup>
                        <col class="size-tbl1">
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row"><label for="reviewDate">날짜</label></th>
                            <td class="review-cardat">
                                <input type="text" id="searchStDate" title="시작일 선택 달력" style="width: 100px;"/>
                                <span class="calendar-hyphen">~</span>
                                <input type="text" id="searchEndDate" title="마지막 선택 달력" style="width: 100px;"/>
                                <a href="#" class="btn-type1" id="btnWeekRange">1주일</a>
                                <a href="#" class="btn-type1" id="btnMonthRange">1개월</a>
                                <a href="#" class="btn-type1" id="btn3MonthRange">3개월</a>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row"><label for="alertType">조건</label></th>
                            <td>
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
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="btn-area">
                <a href="javascript:fn_search(1);" class="btn-search"><span>검색</span></a>
            </div>
        </div>
        <div class="board-list-type more">
            <div class="board-list-title">
                <h3></h3>
            </div>
            <div class="btn">
                <a href="javascript:fn_delete();"  class="btn-border-type m-none">알림삭제</a>
            </div>
            <table>
                <caption>알림내역 목록</caption>
                <colgroup>
                    <col style="width:40px" />
                    <col style="width:50px" />
                    <col style="width:70px" />
                    <col style="width:90px" />
                    <col />
                    <col style="width:100px" />
                    <col style="width:100px" />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col"><label class="chk-skin"><input type="checkbox" name="a" class="chk-skin" id="checkAll"></label></th>
                        <th scope="col">no</th>
                        <th scope="col">상태</th>
                        <th scope="col">유형</th>
                        <th scope="col" class="request-size">알림</th>
                        <th scope="col">발송일</th>
                        <th scope="col">확인일</th>
                    </tr>
                </thead>
                <tbody id="notifiList"></tbody>
            </table>
            <div class="paging">
                <div class="paging" id="paging"></div>
            </div>
        </div>
    </div>
</div>







<div class="layer-pop-wrap" id="notifLayer">
    <div class="layer-pop class" >
        <input type="hidden" id="notifSer" value="" />
        <div class="layer-header">
            <strong class="title">알림</strong>
        </div>
        <div class="layer-cont alert-pop">
            <p class="alert-date" id="regDtm">2016.00.00</p>
            <p class="alert-title" id="notifTitle">[수업개설 승인] 개설 신청 하신 수업이 승인되었습니다.</p>
            <div class="box-style alert-text" id="notifMsg">
                <p>신청하신 수업이 승인되어 수업이 등록될 예정입니다. 수업등록 후, 수강모집이 시작되면 수업현황 > 수강모집 탭에서 확인 할 수 있습니다.</p>
            </div>
            <div class="box-style2 alert-memo">
                <p id="lectRjctRsnSust">홍길동 선생님 <br />수업과 관련하여 따로 연락 드리도록 하겠습니다.</p>
            </div>
            <div class="btn-area">
                <a href="javascript:fn_statusUpdate();" class="btn-type2" id="noShow">더 이상 보지않기</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>






<%-- Template ================================================================================ --%>
<script type="text/html" id="listNotifInfo">
    <tr>
        <td><label class="chk-skin"><input type="checkbox" name="chkBox" class="chk-skin" value="\${notifSer}"></label></td>
        <td>\${fn_getNo(rn)}</td>
        <td>\${notifVerfNm}</td>
        <td>\${notifTypeNm}</td>
        {{if notifVerfYn != 'N'}}
        <td class="al-left">
        {{/if}}
        {{if notifVerfYn == 'N'}}
        <td class="new al-left">
        {{/if}}
            <a href="#" onClick="fn_detail(\${notifSer})">[\${notifClsfNm}]  \${notifTitle}
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

        $('.layer-close').click(function(){
            // 기존 데이터 삭제
            $('#notifSer').val('');

            $('#notifLayer').hide();
            $('.selectbox-zindex-box').css('display', 'none');
            $('body').removeClass('dim');
        });

        //달력 SETTING
        _applyDatepicker($("#searchStDate"), '시작일 선택 달력');
        _applyDatepicker($("#searchEndDate"), '마지막 선택 달력');


         $('#searchStDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchEndDate").datepicker( "option", "minDate", selectedDate );

        });

        $('#searchEndDate').datepicker("option", "onClose", function ( selectedDate ) {
            $("#searchStDate").datepicker( "option", "maxDate", selectedDate );
        });

        $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");


        $('.hasDatepicker').keyup(function(e) {

            var dateExp = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;

            if($(this).val().length >= 10) {
                $(this).val($(this).val().substring(0, 10));

                if(!dateExp.test($(this).val())) {
                    alert('날짜 형식에 맞지 않습니다. ex) 2015-10-26');
                    $(this).val('');
                }
                return;
            } else {
                if($(this).val().length == 4) {
                    $(this).val($(this).val() + "-");
                }
                if($(this).val().length == 7) {
                    $(this).val($(this).val() + "-");
                }
            }
        });

        // 기본 조건값(0 첫째날 ~ 마지막날)
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
        if($('input[name=chkBox]:checked').length<1){
            alert("알림을 선택해주세요");
            return false;
        }
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
                       fn_search(1);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.deleteNotifInfo.do", status, err.toString());
                }
            });
        }

    }

</script>