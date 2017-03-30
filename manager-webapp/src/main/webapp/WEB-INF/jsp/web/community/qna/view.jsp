<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>수업자료실</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>프론트관리</li>
            <li>커뮤니티관리</li>
            <li>수업자료실</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
    <form id="frm">
        <!--input type="hidden" name="arclSer" value="${param.arclSer}" /-->
        <input type="hidden" name="sStartDate" value="${param.sStartDate}" />
        <input type="hidden" name="sEndDate" value="${param.sEndDate}" />
        <input type="hidden" name="prefNo" value="${param.prefNo}" />
        <input type="hidden" name="ansYn" value="${param.ansYn}" />
        <input type="hidden" name="searchKey" value="${param.searchKey}" />
        <input type="hidden" name="searchWord" value="${param.searchWord}" />
    </form>
        <table class="tbl-style tbl-manager-info">
            <colgroup>
                <col style="width:147px;" />
                <col />
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col">답변여부</th>
                    <td colspan="3" id="ansYn"></td>
                </tr>
                <tr>
                    <th scope="col">회원유형</th>
                    <td id="mbrCualfNm"></td>
                    <th scope="col">작성자</th>
                    <td id="regMbrNm"></td>
                </tr>
                <tr>
                    <th scope="col">지역</th>
                    <td id="sidoNm"></td>
                    <th scope="col">학교</th>
                    <td id="schNm"></td>
                </tr>
                <tr>
                    <th scope="col">문의유형</th>
                    <td id="prefNm"></td>
                    <th scope="col">수업명/멘토명</th>
                    <td id="titleOrMentor"></td>
                </tr>
                <tr>
                    <th scope="col">제목</th>
                    <td colspan="3" id="title"></td>
                </tr>
                <tr height="100px">
                    <th scope="col">내용</th>
                    <td colspan="3" id="sust"></td>
                </tr>
                <tr>
                    <th scope="col">등록일</th>
                    <td id="regDtm"></td>
                    <th scope="col">조회수</th>
                    <td id="vcnt"></td>
                </tr>
                <tr>
                    <th scope="col">답변자</th>
                    <td id="ansRegMbrNm"></td>
                    <th scope="col">답변일</th>
                    <td id="ansRegDtm"></td>
                </tr>
                <tr height="100px">
                    <th scope="col">답변내용</th>
                    <td colspan="3" id="cntntsSust"></td>
                </tr>
                <tr style="display:none;">
                    <th scope="col">답변내용</th>
                    <td colspan="3">
                        <textArea rows="7" cols="120" id="cntntsSustArea"></textArea>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onClick="fn_insView();"><span>답변하기</span></button></li>
                <li><button type="button" class="btn-orange" onClick="fn_insView();"><span>답변수정</span></button></li>
                <li><button type="button" class="btn-gray" onClick="goList()"><span>목록</span></button></li>
            </ul>
            <ul style="display:none;">
                <li><button type="button" class="btn-orange" onClick="fn_registArcl();"><span>확인</span></button></li>
                <li><button type="button" class="btn-gray" onClick="javascript:location.reload();"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
    var arclSer = '${param.arclSer}';

    $(document).ready(function(){
        fn_init();
    });

    // 상세데이터 조회
    function fn_init(){
        var arclSer = '${param.arclSer}';
        if(arclSer != null){
            $.ajax({
                url: '${pageContext.request.contextPath}/web/community/ajax.simpleArclView.do',
                data : {'arclSer' : '${param.arclSer}'},
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                success: function(rtnData) {
                    // 미답변일시 답변자, 답변일, 답변내용 hide
                    if(rtnData.ansYn != 'Y'){
                        $('#ansRegMbrNm').closest("tr").css('display', "none"); // 답변자, 답변일
                        $('#cntntsSust').closest("tr").css('display', "none"); // 답변내용
                        $('.board-bot > ul').children().eq(1).css('display', "none"); // 수정버튼 삭제
                    }else{
                        $('.board-bot > ul').children(':first').css('display', "none"); // 등록버튼 삭제
                    }
                    $('#ansYn').text(rtnData.ansYn == 'Y'? '답변완료':'미답변');
                    $('#mbrCualfNm').text(_nvl(rtnData.mbrCualfNm));
                    $('#regMbrNm').text(_nvl(rtnData.regMbrNm));
                    $('#sidoNm').text(_nvl(rtnData.sidoNm));
                    $('#schNm').text(_nvl(rtnData.schNm));
                    $('#prefNm').text(_nvl(rtnData.prefNm));
                    if(rtnData.qnaGbn == 'MENT'){
                        $('#titleOrMentor').text(rtnData.mentorMbrNm);
                    }else if(rtnData.qnaGbn == 'LECT'){
                        $('#titleOrMentor').text(rtnData.lectTitle);
                    }else if(rtnData.qnaGbn == 'COMM'){
                        $('#titleOrMentor').text('선택없음');
                    }
                    $('#title').text(_nvl(rtnData.title));
                    $('#sust').html(_nvl(rtnData.sust));
                    $('#regDtm').text((new Date(rtnData.regDtm)).format('yyyy.MM.dd'));
                    $('#vcnt').text(_nvl(rtnData.vcnt));
                    $('#ansRegMbrNm').text(_nvl(rtnData.ansRegMbrNm));
                    $('#ansRegDtm').text((new Date(rtnData.ansRegDtm)).format('yyyy.MM.dd'));

                    // 개행문자 처리
                    $('#cntntsSust').append(String(_nvl(rtnData.cntntsSust)).replaceAll('\n', '<br>'));
                    $('#cntntsSustArea').html(_nvl(rtnData.cntntsSust));
                }
            });
        }
    }

    function fn_insView(){
        $('#cntntsSust').closest("tr").css('display', "none"); // 기존 답변내용 hide
        $('#cntntsSustArea').closest("tr").css('display', ""); // testArea 답변내용 show

        $('.board-bot').children().eq(0).css('display', "none"); // 수정버튼 삭제
        $('.board-bot').children().eq(1).css('display', ""); // 수정버튼 삭제
    }

    // 확인버튼 클릭(답변 등록 및 수정)
    function fn_registArcl(){
        var _param = {
            boardId : 'lecQnA',
            arclSer : arclSer,
            cntntsSust : $('#cntntsSustArea').val()
        };

        if( confirm('저장하시겠습니까?')){
            $.ajax({
                url: '${pageContext.request.contextPath}/web/community/ajax.registArcl.do',
                data : _param,
                contentType: "application/json",
                dataType: 'json',
                type: 'GET',
                success: function(rtnData) {
                    if(rtnData.success){
                        alert(rtnData.data);
                        //location.href = '${pageContext.request.contextPath}/web/community/qna/list.do';
                        location.reload();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.registArcl.do", status, err.toString());
                }
            });
        }

    }

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

</script>