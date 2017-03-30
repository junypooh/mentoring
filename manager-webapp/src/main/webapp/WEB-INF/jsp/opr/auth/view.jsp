<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<div class="cont">
    <div class="title-bar">
        <h2>권한관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>운영관리</li>
            <li>권한관리</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="authCd" value="${param.authCd}" />
        <input type="hidden" name="authType" value="${param.authType}" />
    </form>
    <form:form modelAttribute="authInfo" id="updateAuthInfo" action="editSubmit.do">
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-manager-info">
            <colgroup>
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">관리자 코드 <span class="red-point">*</span></th>
                    <td><input type="text" class="text" id="authCd" name="authCd" value="${authInfo.authCd}" <c:if test="${not empty authInfo.authCd}">readonly='readonly'</c:if> /></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">관리자 유형 <span class="red-point">*</span></th>
                    <td>
                        <select id="authType" name="authType">
                            <option value="">전체</option>
                            <option value="0" <c:if test="${authInfo.authType eq '0'}">selected='selected'</c:if>>운영관리자</option>
                            <option value="1" <c:if test="${authInfo.authType eq '1'}">selected='selected'</c:if>>그룹관리자</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">관리자 권한명 <span class="red-point">*</span></th>
                    <td><input type="text" class="text" id="authNm" name="authNm" value="${authInfo.authNm}" /></td>
                </tr>
            </tbody>
        </table>
        <div class="h3-wrap">
            <h3 class="h3-title">관리자권한설정 <label><input type="checkbox" id="allCheck" /><span>전체선택</span></label></h3>
        </div>
        <table class="tbl-style">
            <colgroup>
                <col style="width:147px;" />
                <col style="width:156px;" />
                <col />
            </colgroup>
            <thead>
                <tr>
                    <th scope="row">1depth</th>
                    <th scope="row">2depth</th>
                    <th scope="row">3depth</th>
                </tr>
            </thead>
            <tbody id="mnuTbody">
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <c:choose>
                <c:when test="${not empty authInfo.authCd}">
                <input type="hidden" name="crudType" value="U" />
                <li><button type="button" class="btn-style02" id="updateButton"><span>수정</span></button></li><!-- 2016-06-10 수정 -->
                </c:when>
                <c:otherwise>
                <input type="hidden" name="crudType" value="C" />
                <li><button type="button" class="btn-style02" id="updateButton"><span>등록</span></button></li><!-- 2016-06-10 수정 -->
                </c:otherwise>
                </c:choose>
                <li><button type="button" class="btn-gray" onclick="goList()"><span>취소</span></button></li><!-- 2016-06-10 수정 -->
            </ul>
        </div>
    </div>
    </form:form>
</div>

<script type="text/javascript">

    $(document).ready(function() {

        // 전체 메뉴 table 그리기
        drawMenuTable();

        // 권한별 메뉴에 체크 처리
        <c:if test="${not empty param.authCd}">
        menuCheckByAuthCd();
        </c:if>

        // 전체 체크
        $('#allCheck').click(function() {
            var chk = $(this).prop("checked");
            $(':checkbox').each(function() {
                $(this).prop("checked", chk);
            });
        });

        // 1depth 체크 시 해당 2~3depth 체크 컨트롤
        $('.mnu1depthChk').click(function() {
            var chk = $(this).prop("checked");
            var mnu1Id = $(this).attr('id');
            $(':checkbox').each(function() {
                if( mnu1Id == $(this).attr('supId')) {
                    $(this).prop("checked", chk);

                    var mnu2Id = $(this).attr('id');
                    $(':checkbox').each(function() {
                        if( mnu2Id == $(this).attr('supId')) {
                            $(this).prop("checked", chk);
                        }
                    });
                }
            });
        });

        // 2depth 체크 시 해당 3depth 체크 컨트롤
        $('.mnu2depthChk').click(function() {
            var chk = $(this).prop("checked");
            $(this).parent().parent().next().children().find('input[type=checkbox]').each(function() {
                $(this).prop("checked", chk);
            });
        });

        // 저장/수정 버튼 클릭
        $('#updateButton').click(function(e) {

            checkboxValidate();

            if($('#authCd').val() == '') {
                alert('* 가 표시된 필수항목은 모두 기입해 주세요.');
                return false;
            }
            if($('#authType').val() == '') {
                alert('* 가 표시된 필수항목은 모두 기입해 주세요.');
                return false;
            }
            if($('#authNm').val() == '') {
                alert('* 가 표시된 필수항목은 모두 기입해 주세요.');
                return false;
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/opr/auth/ajax.isValidateCode.do",
                data : {authCd: $('[id="authCd"]').val()},
                async : false,
                success: function(rtnData) {
                    if(rtnData.success == "false" && $('[name="crudType"]').val() == 'C'){
                        alert(rtnData.message);
                        return false;
                    } else {

                        var checked = false;
                        $(':checkbox').each(function() {
                            if($(this).prop("checked")) {
                                checked = true;
                                return;
                            }
                        });

                        if(!checked) {
                            alert('최소한 한개의 메뉴는 선택해주세요.');
                            return false;
                        }

                        if(confirm('저장하시겠습니까?')) {
                            $('#updateButton').closest('form').submit();
                            return false;
                        } else {
                            return false;
                        }

                    }
                }
            });
        });

    });

    function checkboxValidate() {

        // 3depth 메뉴가 하나라도 체크 되어 있다면 2depth 를 무조건 체크한다.
        $('.mnu2depthChk').each(function() {
            if($(this).hasClass('hasChild')) { // 3depth 메뉴를 가지고 있는 2depth 만 초기화
                $(this).prop("checked", false);
            }
        });
        $('.mnu3depthChk').each(function() {
            if($(this).prop("checked")) {
                $('#'+$(this).attr('supId')).prop("checked", true);
            }
        });

        // 2depth 메뉴가 하나라도 체크 되어 있다면 1depth 를 무조건 체크한다.
        $('.mnu1depthChk').each(function() {
            $(this).prop("checked", false);
        });
        $('.mnu2depthChk').each(function() {
            if($(this).prop("checked")) {
                $('#'+$(this).attr('supId')).prop("checked", true);
            }
        });
    }

    // 전체 메뉴 table 그리기
    function drawMenuTable() {

        var menu2ndTotList = [];
        //var menuList = JSON.parse('${menuJson}');

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/auth/ajax.view.do",
            data : {},
            async : false,
            success: function(menuList) {

                // 2depth 메뉴 합치기
                $.each(menuList, function() {

                    var menu2ndListTemp = [];
                    var menu2ndList = this.globalSubMnuInfos;

                    // 2depth 첫번째 메뉴에 {order: 'first'} 추가.
                    $.each(menu2ndList, function(idx, value) {
                        var obj = {};
                        if(idx == 0) {
                            obj = $.extend({}, this, {order: 'first'});
                        } else {
                            obj = this;
                        }

                        menu2ndListTemp.push(obj);
                    });

                    menu2ndTotList = $.merge(menu2ndTotList, menu2ndListTemp);
                });

                // 2depth 메뉴 먼저 그리기
                var secondDeptHTML = "";
                $.each(menu2ndTotList, function(idx) {
                    secondDeptHTML += "<tr id='firstDepth-"+ this.supMnuId + "'>";
                    // 2depth 첫번째 메뉴일 경우 id 부여
                    if(this.order == 'first') {
                        secondDeptHTML += "   <td id='secondDepth-"+ this.supMnuId +"'>";
                    } else {
                        secondDeptHTML += "   <td>";
                    }
                    secondDeptHTML += "       <label>";
                    if((this.globalSubMnuInfos).length > 0) { // 3depth 메뉴가 있을 경우와 없을 경우 분리
                        secondDeptHTML += "           <input type='checkbox' id='" + this.mnuId + "' supId='" + this.supMnuId + "' name='mnuIds' value='" + this.mnuId + "' class='mnu2depthChk hasChild' /><span>" + this.mnuNm + "</span>";
                    } else {
                        secondDeptHTML += "           <input type='checkbox' id='" + this.mnuId + "' supId='" + this.supMnuId + "' name='mnuIds' value='" + this.mnuId + "' class='mnu2depthChk' /><span>" + this.mnuNm + "</span>";
                    }
                    secondDeptHTML += "       </label>";
                    secondDeptHTML += "   </td>";
                    secondDeptHTML += "   <td>";
                    $.each(this.globalSubMnuInfos, function() {
                        secondDeptHTML += "       <label>";
                        secondDeptHTML += "           <input type='checkbox' id='" + this.mnuId + "' supId='" + this.supMnuId + "' name='mnuIds' value='" + this.mnuId + "' class='mnu3depthChk' /><span>" + this.mnuNm + "</span>";
                        secondDeptHTML += "       </label>";
                    });
                    secondDeptHTML += "   </td>";
                    secondDeptHTML += "</tr>";
                });

                $('#mnuTbody').append(secondDeptHTML);

                // 1depth 메뉴 그리기
                var firstDepthHtml = "";
                $.each(menuList, function() {
                    firstDepthHtml = "";
                    firstDepthHtml += "<th scope='col' rowspan='" + (this.globalSubMnuInfos).length + "'>";
                    firstDepthHtml += "       <label>";
                    firstDepthHtml += "           <input type='checkbox' id='" + this.mnuId + "' name='mnuIds' value='" + this.mnuId + "' class='mnu1depthChk' /><span>" + this.mnuNm + "</span>";
                    firstDepthHtml += "       </label>";
                    firstDepthHtml += "</th>";
                    // 2depth 첫번째 메뉴 td 앞에 1depth 넣어주기
                    $('#secondDepth-'+this.mnuId).before(firstDepthHtml);
                });

            }
        });
    }

    // 권한별 메뉴에 체크 처리
    function menuCheckByAuthCd() {

        $.ajax({
            url: "${pageContext.request.contextPath}/opr/auth/ajax.getMenuInfoByAuth.do",
            data : {authCd: '${param.authCd}'},
            async : false,
            success: function(menuList) {
                $.each(menuList, function() {
                    $('[id=' + this.mnuId + ']').prop('checked', true);

                    $.each(this.globalSubMnuInfos, function() {
                        $('[id=' + this.mnuId + ']').prop('checked', true);

                        $.each(this.globalSubMnuInfos, function() {
                            $('[id=' + this.mnuId + ']').prop('checked', true);
                        });
                    });
                });
            }
        });
    }

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

</script>