<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<cnet:loadConstants var="codeConstants" className="kr.or.career.mentor.constant.CodeConstants" />
<div class="cont">
    <div class="title-bar">
        <h2>이메일 발송</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>알림관리</li>
            <li>이메일 발송</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-none-search">
        <input type="hidden" id="stdoNo" value="<c:out value="${mcInfo.stdoNo}" />"/>
            <colgroup>
               <col style="width:15%" />
               <col style="width:35%" />
               <col style="width:15%" />
               <col style="width:35%" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="col" class="ta-l">보내는 사람</th>
                    <td colspan="3" id="name"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">받는 사람</th>
                    <td colspan="3" id="sendTargtInfo"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">제목</th>
                    <td colspan="3" id="sendTitle"></td>
                </tr>
                <tr>
                    <th scope="col" class="ta-l">내용</th>
                    <td colspan="3" id="sendMsg"></td>
                </tr>

            </tbody>
        </table>
        <p class="search-btnbox">
            <button type="button" class="btn-style02" onclick="location.href='list.do'"><span>목록</span></button>
        </p>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function(){
    var msgSer = '${param.msgSer}';
    var _param = {'msgSer':msgSer};

     $.ajax({
         url: "${pageContext.request.contextPath}/notify/email/ajax.sendView.do",
         data : _param,
         contentType: "application/json",
         dataType: 'json',
         cache: false,
         success: function(rtnData) {
                $("#name").text(rtnData.nm);
                $("#sendTargtInfo").text(rtnData.sendTargtInfo);
                if(rtnData.sendTitle != null){
                    $("#sendTitle").text(rtnData.sendTitle);
                }
                $('#sendMsg').html(rtnData.sendMsg);

        }
     });
});
</script>
