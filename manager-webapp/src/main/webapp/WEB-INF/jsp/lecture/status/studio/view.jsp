<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>수업후기</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업정보관리</li>
            <li>수업후기</li>
        </ul>
    </div>
    <form id="frm">
        <input type="hidden" name="stdoNo" value="${param.stdoNo}" />
        <input type="hidden" name="indrYn" value="${param.indrYn}" />
        <input type="hidden" name="useYn" value="${param.useYn}" />
        <input type="hidden" name="sidoNm" value="${param.sidoNm}" />
        <input type="hidden" name="sgguNm" value="${param.sgguNm}" />
        <input type="hidden" name="posCoNm" value="${param.posCoNm}" />
        <input type="hidden" name="stdoNm" value="${param.stdoNm}" />
    </form>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-manager-info">
            <colgroup>
                <col style="width:147px;" />
                <col />
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">구분</th>
                    <td colspan="3" id="indrYnNm"></td>
                </tr>
                <tr>
                    <th scope="col">스튜디오</th>
                    <td colspan="3" id="stdoNm"></td>
                </tr>
                <tr>
                    <th scope="col">주소</th>
                    <td colspan="3" id="locaAddr"></td>
                </tr>
                <tr>
                    <th scope="col">소속기관</th>
                    <td colspan="3" id="posCoNm"></td>
                </tr>
                </tr>
                    <th scope="col">담당자</th>
                    <td colspan="3" id="chrgrNm"></td>
                <tr>
                    <th scope="col">전화번호</th>
                    <td colspan="3" id="repTel"></td>
                </tr>
                <tr>
                    <th scope="col">비고</th>
                    <td colspan="3" id="florNm"></td>
                </tr>
                <tr>
                    <th scope="col">사용유무</th>
                    <td colspan="3" id="useYnNm"></td>
                </tr>
                <tr>
                    <th scope="col">등록자</th>
                    <td id="regMbrNm"></td>
                    <th scope="col">등록일</th>
                    <td id="regDtm"></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange"><span>수정</span></button></li>
                <li><button type="button" class="btn-gray" onClick="goList()"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
</div>

<script type="text/javascript">
    var stdoNo = '${param.stdoNo}';

    $(document).ready(function(){
        fn_init();
    });

    // 상세데이터 조회
    function fn_init(){
        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/studio/ajax.list.do",
            data : {'stdoNo' : stdoNo},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                $('#indrYnNm').text(rtnData[0].indrYnNm);
                $('#stdoNm').text(rtnData[0].stdoNm);
                $('#locaAddr').text(rtnData[0].locaAddr +" "+_nvl(rtnData[0].locaDetailAddr));
                $('#posCoNm').text(_nvl(rtnData[0].posCoNm));
                $('#chrgrNm').text(_nvl(rtnData[0].chrgrNm));
                $('#repTel').text(_nvl(rtnData[0].repTel));
                $('#florNm').text(_nvl(rtnData[0].florNm));
                $('#useYnNm').text(rtnData[0].useYnNm);
                $('#regMbrNm').text(rtnData[0].regMbrNm);
                $('#regDtm').text((new Date(rtnData[0].regDtm)).format('yyyy.MM.dd'));
            }
        });
    }

    // 수정버튼클릭
    $('.btn-orange').click(function(){
        location.href = '${pageContext.request.contextPath}/lecture/status/studio/edit.do?stdoNo=' + stdoNo;
    });

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

</script>