<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>

<div class="popup-area" id="${param.popupId}" style="display:none;">
    <div class="pop-title-box">
    <p class="pop-title">불러오기</p>
    </div>
    <div class="pop-cont-box">
        <form name="form" id="form" method="post">
                    <input type="hidden" name="currentPage" value="1"/>
                    <input type="hidden" name="countPerPage" value="10"/>
                    <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>
        <p class="bullet-gray">회원선택</p>
        <table class="tbl-style">
            <colgroup>
                <col style="width:145px;">
                <col>
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">회원유형</th>
                    <td>
                        <select name="siteGubun"  id="siteGubunSelector">
                            <option value="">전체</option>
                            <option value="S">학교회원</option>
                            <option value="M">멘토회원</option>
                        </select>

                       <select name="mbrClassCds"  id="mbrClassCdSelector">
                           <option value="">전체</option>
                           <option value="100858">일반회원</option>
                           <option value="100859">교사회원</option>
                       </select>

                        <select name="mbrCualfCds"  id="mbrCualfCdSelector" default="${status.actualValue[0]}">
                            <option value="">전체</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">검색어</th>
                    <td>
                        <select id="selType" name="selType">
                            <option value="1">전체</option>
                            <option value="2">지역</option>
                            <option value="3">소속</option>
                            <option value="4">이름</option>
                        </select>

                       <input type="text" class="text" name="searchWord" id="searchWord" />
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="btn-group-c">
            <a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/btn_search.gif" alt="검색"  onclick="goPage();" /></a>
        </div>
        <div id="popBoardArea" class="board-area">
            <div id="popBoardArea" class="pop-board-area">
                <div class="board-bot">
                    <p class="bullet-gray fl-l">검색결과</p>
                    <ul>
                        <li><button type="button" class="btn-orange" onclick="donePop()"><span>선택</span></button></li>
                        <li><button type="button" class="btn-gray" onclick="closePop()"><span>취소</span></button></li>
                    </ul>
                </div>

                <table id="userList">

                            </table>
            </div>

        </div>
        <div id="addrSearchPaging" class="board-area"></div>
    </div>
    <a href="javascript:void(0)" id="closePopup" class="btn-close-pop">닫기</a>
</div>

<script type="text/javascript">
    var userCategory = {
        '100858': {
            '100205': '초등학생 회원',
            '100206': '중학생 회원',
            '100207': '고등학생 회원',
            '100208': '대학생 회원',
            '100209': '일반 회원',
            '100210': '학부모 회원',
        },
        '100859': {
            '100214': '교사 회원',
            '100215': '진로상담교사 회원',
        },
    };

    var siteCategory = {
            'S': {
                '100858': '일반회원',
                '100859': '교사회원',
            },
            'M': {
                '101501': '기업멘토',
                '101502': '소속멘토',
                '101503': '개인멘토',
            },
        };

    function goPage(){
        //jqGrid
        var colModels = [];
        colModels.push({label:'no', name:'rn',index:'rn', width:50, align:'center', sortable: false});
        colModels.push({label:'회원유형', name:'mbrCualfNm',index:'mbrCualfNm', width:90, align:'center', sortable: false, key: true});
        colModels.push({label:'지역', name:'sidoNm',index:'sidoNm', width:90, align:'center', sortable: false});
        colModels.push({label:'소속', name:'posCoNm',index:'posCoNm', width:80, align:'center', sortable: false});
        colModels.push({label:'이름', name:'username',index:'username', width:80, align:'center', sortable: false});
        colModels.push({label:'이메일', name:'emailAddr',index:'emailAddr', width:110, align:'center', sortable: false});
        initJqGridTable('userList', 'popBoardArea', 1300, colModels,  true, 310);
        //resizeJqGridWidth('userList', 'popBoardArea', 570);

        var userSearch = {};
        userSearch.name = $('#searchWord').val();
        userSearch.selType = $('#selType').val();

        if($('#siteGubunSelector').val() == 'S'){
            if($('#mbrClassCdSelector').val() !== ''){
                userSearch.mbrClassCds = [$('#mbrClassCdSelector').val()];

                if($('#mbrClassCdSelector').val() == '100858'){
                    if($('#mbrCualfCdSelector').val() !== ''){
                        userSearch.mbrCualfCds = [$('#mbrCualfCdSelector').val()];
                    }else{
                        userSearch.mbrCualfCds = ['100205','100206','100207','100208','100209','100210'];
                    }
                }else if($('#mbrClassCdSelector').val() == '100859'){
                    if($('#mbrCualfCdSelector').val() !== ''){
                        userSearch.mbrCualfCds = [$('#mbrCualfCdSelector').val()];
                    }else{
                        userSearch.mbrCualfCds = ['100214','100215'];
                    }
                }
            }else{
                userSearch.mbrClassCds = ['100858','100859'];
            }

        }else if($('#siteGubunSelector').val() == 'M'){
            if($('#mbrClassCdSelector').val() !== ''){
                userSearch.mbrCualfCds = [$('#mbrClassCdSelector').val()];
            }else{
                userSearch.mbrCualfCds = ['101501','101502','101503'];
            }
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/user/manager/ajax.searchUser.do',
            data : JSON.stringify(userSearch),
            contentType: "application/json",
            dataType: 'json',
            method:"post",
            cache: false,
            success: function(data) {
            var rowCnt = 0;

                var emptyText = "조건에 맞는 회원이 존재하지 않습니다.";

                var data2 = new Array();
                var smsData = data.map(function(item, index) {
                    item.gridRowId = item.mbrNo+"|"+item.emailAddr;
                    var disabled = item.emailAddr == null ? true : false;
                    if(!disabled){
                        item.emailAddr = item.emailAddr;
                        item.rn = rowCnt+1;
                        data2[rowCnt] = item;
                        rowCnt++;
                    }else{
                        item.emailAddr = "";
                    }
                    return item;

                });


                setDataJqGridTable('userList', 'popBoardArea', 1300, data2, emptyText, 310);

                var idArry = $("#userList").jqGrid('getDataIDs'); //grid의 id 값을 배열로 가져옴




            }
        });
    }
    var dataSet = {
        params: {
            recordCountPerPage: 10,
            totalRecordCount: 0,
            currentPageNo: 1,
            pageSize: 10,
        }
    };
    $(document).ready(function(){

        $("#closePopup").click(function(){
            $(".popup-area").css("display","none");
            $('body').removeClass('dim');
        });



        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".popup-area").css("display","none");
                $('body').removeClass('dim');
            }
        });


    });


    function clickOk(obj){
        var element = {};
        element.ROADADDR =  $("#userList tr[id="+obj+"] >td:eq(1)").text();
        element.JIBUNADDR = $("#userList tr[id="+obj+"] >td:eq(2)").text();
        element.ZIPNO = $("#userList tr[id="+obj+"] >td:eq(0)").text();

        ${param.callbackFunc}(element);
        $("#closePopup").click();
    }


    $(function () {

        $('#siteGubunSelector').change(
            function() {
                if(this.value == 'M'){
                    $('#mbrCualfCdSelector').hide();
                }else{
                    $('#mbrCualfCdSelector').show();
                }
                $('#mbrClassCdSelector').find('option:not(:first)').remove().end()
                    .append(function() {
                                if (this.value) {
                                    var options = [];
                                    $.each(siteCategory[this.value],
                                        function(k, v) {
                                            options.push($('<option value="' + k + '">' + v + '</option>'));
                                        }
                                    )
                                    return options;
                                }
                            }.bind(this));
                    }).filter(function() { return !!this.value; }).change();


        $('#mbrClassCdSelector').val($('#mbrClassCdSelector').attr('default'));


        $('#mbrClassCdSelector').change(function() {
                        $('#mbrCualfCdSelector').find('option:not(:first)').remove().end()
                            .append(function() {
                                if (this.value) {
                                    var options = [];
                                    $.each(userCategory[this.value], function(k, v) {
                                        options.push($('<option value="' + k + '">' + v + '</option>'));
                                    })
                                    return options;
                                }
                            }.bind(this));
                    }).filter(function() { return !!this.value; }).change();
        $('#mbrCualfCdSelector').val($('#mbrCualfCdSelector').attr('default'));

        }
    );

    function donePop() {
        var selEmailList =  $('#userList').jqGrid('getGridParam','selarrrow');
        if(selEmailList == null || selEmailList == '') {
         alert('회원을 선택해 주세요.');
        } else {
         ${param.callbackFunc}($.makeArray(selEmailList));
        }
     }

</script>
<script type="text/jsx;harmony=true">


    function makeData(xmlStr){
        var data = [];
        $(xmlStr).find("juso").each(function(){
            var item = {};

            $(this).children().each(function(){
                item[$(this).prop("tagName")] = $(this).text();
            });
            data.push(item);
        });
        return data;
    }

    function popupShow(){
        $(".popup-area").show();
    }
    function popupHide(){
        $(".popup-area").hide();
    }

    var searchSmsTargets = [];

    function setSmsTargets(){

        $('#searchMemberPanel').hide();
        $('#sendSmsPanel').show();

        var appendMails = "";
        $("input:checkbox[name='selectedTarget']").each(
            function (index) {
                if(this.checked){
                    appendMails += ($('input[name="mailAddress"]')[index].value + ',');
                }
            }
        );

        $('#receiver').val(appendMails);

        isSelected = true;



    }

    function closePop(){
        $(".popup-area").css("display","none");
        $('body').removeClass('dim');
    }
</script>