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
        <input type="hidden" name="arclSer" value="${param.arclSer}" />
        <input type="hidden" name="sStartDate" value="${param.sStartDate}" />
        <input type="hidden" name="sEndDate" value="${param.sEndDate}" />
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
                    <th scope="col">등록자</th>
                    <td id="regMbrNm"></td>
                    <th scope="col">지역</th>
                    <td id="sidoNm"></td>
                </tr>
                <tr>
                    <th scope="col">학교</th>
                    <td id="schNm"></td>
                    <th scope="col">반</th>
                    <td id="clasRoomNm"></td>
                </tr>
                <tr>
                    <th scope="col">수업일</th>
                    <td id="lectDay"></td>
                    <th scope="col">수업명</th>
                    <td id="cntntsTargtNm"></td>
                </tr>
                <tr>
                    <th scope="col">멘토명</th>
                    <td id="lectrNm"></td>
                    <th scope="col">직업명</th>
                    <td id="jobNm"></td>
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
                    <th scope="col">첨부파일</th>
                    <td colspan="3">
                        <ul class="attach-list">
                            <!-- li>
                                <a href="#">모집안내문.txt</a>
                                <button type="button" class="btn-attach-delete"><img src="../images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                            </li -->
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th scope="col">등록일</th>
                    <td colspan="3" id="regDtm"></td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onClick="fn_deleteArcl();"><span>삭제</span></button></li>
                <li><button type="button" class="btn-gray" onClick="goList()"><span>목록</span></button></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
    var arclSer = '${param.arclSer}';

    $(document).ready(function(){
        if(arclSer != null){
            fn_init();
            getFileList();
        }
    });


    // 상세데이터 조회
    function fn_init(){
        var arclSer = '${param.arclSer}';
        if(arclSer != null){
            $.ajax({
                url: '${pageContext.request.contextPath}/web/community/ajax.classTaskList.do',
                data : {'arclSer' : '${param.arclSer}'},
                contentType: "application/json",
                dataType: 'json',
                cache: false,
                success: function(rtnData) {
                    $('#regMbrNm').text(_nvl(rtnData[0].regMbrNm));
                    $('#sidoNm').text(_nvl(rtnData[0].sidoNm));
                    $('#schNm').text(_nvl(rtnData[0].schNm));
                    $('#clasRoomNm').text(_nvl(rtnData[0].clasRoomNm));
                    $('#lectDay').text(_nvl(to_date_format(rtnData[0].lectDay, '.')));
                    $('#cntntsTargtNm').text(_nvl(rtnData[0].cntntsTargtNm));
                    $('#lectrNm').text(_nvl(rtnData[0].lectrNm));
                    $('#jobNm').text(_nvl(rtnData[0].jobNm));
                    $('#title').text(_nvl(rtnData[0].title));
                    $('#sust').text(_nvl(rtnData[0].sust));
                    $('#regDtm').text(_nvl((new Date(rtnData[0].regDtm)).format('yyyy.MM.dd')));
                }
            });
        }
    }

    // 상세 첨부파일 조회
    function getFileList() {
        $.ajax({
            url: '${pageContext.request.contextPath}/web/community/ajax.getFileInfoList.do',
            data : {'arclSer' : '${param.arclSer}'},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var str = "";
                for(var i=0;i<rtnData.length;i++) {
                    str += '<li id="'+rtnData[i].fileSer+'">';
                    str += '    <a href="${pageContext.request.contextPath}/fileDown.do?fileSer='+ rtnData[i].fileSer +'">' + rtnData[i].comFileInfo.oriFileNm + '</a>';
                    str += '</li>';
                }
                $('.attach-list').html(str);
            }
        });
    }

    //삭제버튼 클릭
    function fn_deleteArcl(){
        if(confirm("자료삭제시 프론트에 바로 반영됩니다.\n정말 삭제하시겠습니까?")){
            var arclSers =  [];
            arclSers.push(arclSer);

            $.ajax({
                url: "${pageContext.request.contextPath}/web/community/ajax.deleteArcl.do",
                data : {'arclSers':arclSers},
                contentType: "application/json",
                dataType: 'json',
                type: 'GET',
                traditional: true,
                success: function(rtnData) {
                    if(rtnData.success) {
                        alert(rtnData.data);
                        //location.href = '${pageContext.request.contextPath}/web/community/task/list.do';
                        goList();
                    }else{
                        alert(rtnData.message);
                    }
                },
                error: function(xhr, status, err) {
                    console.error("ajax.deleteArcl.do", status, err.toString());
                }
            });
        }
    }

    function goList() {
        var qry = $('#frm').serialize();
        $(location).attr('href', 'list.do?' + qry);
    }

</script>