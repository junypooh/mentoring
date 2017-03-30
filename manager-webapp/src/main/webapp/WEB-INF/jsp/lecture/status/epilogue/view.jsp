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
        <input type="hidden" name="cmtSer" value="${param.cmtSer}" />
        <input type="hidden" name="lectTypeCd" value="${param.lectTypeCd}" />
        <input type="hidden" name="mbrCualfType" value="${param.mbrCualfType}" />
        <input type="hidden" name="lectTitle" value="${param.lectTitle}" />
        <input type="hidden" name="lectTargtCd" value="${param.lectTargtCd}" />
        <input type="hidden" name="lectrNm" value="${param.lectrNm}" />
        <input type="hidden" name="grpNm" value="${param.grpNm}" />
        <input type="hidden" name="jobNm" value="${param.jobNm}" />
        <input type="hidden" name="coNm" value="${param.coNm}" />
        <input type="hidden" name="searchStDate" value="${param.searchStDate}" />
        <input type="hidden" name="searchEndDate" value="${param.searchEndDate}" />
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
                    <th scope="col">배정사업</th>
                    <td colspan="3" id="grpNm"></td>
                </tr>
                <tr>
                    <th scope="col">수업유형</th>
                    <td colspan="3" id="lectTypeNm"></td>
                </tr>
                <tr>
                    <th scope="col">수업명</th>
                    <td colspan="3" id="lectTitle"></td>
                </tr>
                <tr>
                    <th scope="col">멘토</th>
                    <td id="lectrNm"></td>
                    <th scope="col">직업명</th>
                    <td id="jobNm"></td>
                </tr>
                </tr>
                <tr height="100px">
                    <th scope="col">후기내용</th>
                    <td colspan="3" id="cmtSust"></td>
                </tr>
                <tr>
                    <th scope="col">교육수행기관</th>
                    <td colspan="3" id="coNm"></td>
                </tr>
                <tr>
                    <th scope="col">회원유형</th>
                    <td id="mbrCualfNm"></td>
                    <th scope="col">평점</th>
                    <td id="asmPnt"></td>
                </tr>
                <tr>
                    <th scope="col">학교</th>
                    <td id="schNm"></td>
                    <th scope="col">교실명</th>
                    <td id="clasRoomNm"></td>
                </tr>
                <tr>
                    <th scope="col">작성자</th>
                    <td id="regMbrNm"></td>
                    <th scope="col">등록일</th>
                    <td id="regDtm"></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange"><span>삭제</span></button></li>
                <li><button type="button" class="btn-gray" onClick="goList()"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">

    $(document).ready(function(){
        fn_init();
    });

    // 상세데이터 조회
    function fn_init(){
        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/epilogue/ajax.list.do",
            data : {'cmtSer' : '${param.cmtSer}'},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                $('#grpNm').text(_nvl(rtnData[0].grpNm));
                $('#lectTypeNm').text(_nvl(rtnData[0].lectTypeNm));
                $('#lectTitle').text(_nvl(rtnData[0].lectTitle));
                $('#lectrNm').text(_nvl(rtnData[0].lectrNm));
                $('#jobNm').text(_nvl(rtnData[0].jobNm));
                $('#cmtSust').append(String(_nvl(rtnData[0].cmtSust)).replaceAll('\n', '<br>'));
                $('#coNm').text(_nvl(rtnData[0].coNm));

                if(rtnData[0].mbrCualfCd == '100205' || rtnData[0].mbrCualfCd == '100206' || rtnData[0].mbrCualfCd == '100207' || rtnData[0].mbrCualfCd == '100208'){
                    $('#mbrCualfNm').text('학생');
                }else if(rtnData[0].mbrCualfCd == '100214' || rtnData[0].mbrCualfCd == '100215'){
                    $('#mbrCualfNm').text('교사');
                }else{
                    $('#mbrCualfNm').text(_nvl(rtnData[0].mbrCualfNm));
                }

                $('#asmPnt').text(_nvl(rtnData[0].asmPnt) + '점');
                $('#schNm').text(_nvl(rtnData[0].schNm));
                $('#clasRoomNm').text(_nvl(rtnData[0].clasRoomNm));
                $('#regMbrNm').text(_nvl(rtnData[0].regMbrNm) + ' (' + rtnData[0].regMbrId + ')');
                $('#regDtm').text(_nvl((new Date(rtnData[0].regDtm)).format('yyyy.MM.dd')));
            }
        });
    }

    // 삭제버튼클릭
    $('.btn-orange').click(function(){
        if(confirm("삭제하시겠습니까?")){

            $.ajax({
                url: "${pageContext.request.contextPath}/lecture/status/epilogue/ajax.delete.do",
                data : {'cmtSer' : '${param.cmtSer}'},
                contentType: "application/json",
                dataType: 'json',
                type: 'GET',
                traditional: true,
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert(rtnData.data);
                        //location.href = '${pageContext.request.contextPath}/lecture/status/epilogue/list.do';
                        goList();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("epilogue/ajax.delete.do", status, err.toString());
                }
            });
        }
    });

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }


</script>