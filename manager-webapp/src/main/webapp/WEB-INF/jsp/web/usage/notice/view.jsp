<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="username" property="principal.username" />
</security:authorize>

<div class="cont">
    <div class="title-bar">
        <h2>공지사항</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>Web관리</li>
            <li>이용안내관리</li>
            <li>공지사항</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-manager-info">
            <colgroup>
                <col style="width:147px;" />
                <col />
                <col style="width:147px;" />
                <col />
            </colgroup>
            <tbody>
            <form:form commandName="arclInfo" id="frm" method="post" action="${pageContext.request.contextPath}/web/usage/registArcl.do">
                <form:hidden path="arclSer"/>
                <form:hidden path="boardId" />
                <input type="hidden" name="redirectUrl" value="/web/usage/notice/list.do" />
                <input type="hidden" id="fileSers" name="fileSers" />
                <input type="hidden" id="popupYn" name="popupYn" />
                <input type="hidden" id="popupWidth" name="popupWidth" />
                <input type="hidden" id="popupHigh" name="popupHigh" />
                <input type="hidden" id="notiYn" name="notiYn" />
                <tr>
                    <th scope="col">채널</th>
                    <td colspan="3">
                        <form:radiobuttons path="expsTargtCd" items="${code101633}" itemLabel="cdNm" itemValue="cd" />
                    </td>
                </tr>
                <tr>
                    <th scope="col">제목</th>
                    <td colspan="3">
                        <form:input path="title" cssStyle="width:60%" />
                        <label class="mr5"><input type="checkbox" name="noti" value="" <c:if test="${arclInfo.notiYn eq 'Y'}">checked</c:if>/> 중요공지</label>
                    </td>
                </tr>
                <tr>
                    <th scope="col">내용</th>
                    <td colspan="3">
                        <jsp:include page="/layer/editor.do" flush="true">
                            <jsp:param name="wrapperId" value="sust"/>
                            <jsp:param name="contentId" value="sust"/>
                            <jsp:param name="formName" value="frm"/>
                        </jsp:include>
                        <form:textarea path="sust"  cssStyle="display:none;" />
                    </td>
                </tr>
            </form:form>
                <tr>
                    <th scope="col">첨부파일</th>
                    <td colspan="3">
                        <p class="attach-box">
                            <form id="fileForm" method="post" enctype="multipart/form-data">
                                <input type="text" class="text" />
                                <input type="file" id="uploadFile" name="upload_file" class="btn-file" />
                                <span class="attach-ps">*최대 5개까지 첨부 가능합니다.</span>
                            </form>
                        </p>
                        <ul class="attach-list">
                             <c:forEach items="${fileList}" var="item">
                                <li id="${item.fileSer}">
                                    <a href="#">${item.comFileInfo.oriFileNm}</a>
                                    <button type="button" class="btn-attach-delete" onClick="fn_fileDelete(${item.fileSer});"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                                </li>
                             </c:forEach>
                            <!-- li>
                                <a href="#">모집안내문.txt</a>
                                <button type="button" class="btn-attach-delete"><img src="../images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                            </li -->
                        </ul>
                    </td>
                </tr>
                <!--
                <tr>
                    <th scope="col">팝업여부</th>
                    <td colspan="3" id="popYn">
                    <label><input type="radio" name="popYn" value="N" <c:if test="${arclInfo.popupYn ne 'Y'}">checked</c:if> /> 사용안함</label>
                    <label><input type="radio" name="popYn" value="Y" <c:if test="${arclInfo.popupYn eq 'Y'}">checked</c:if> /> 팝업사용</label>

                    <strong>팝업창</strong>
                    <input type="text" id="popWidth" style="width:5%" value="${arclInfo.popupWidth}"/> X <input type="text" id="popHigh" style="width:5%" value="${arclInfo.popupHigh}"/>Pixel
                    <span class="attach-ps">팝업사용 체크시 공지사항으로는 게시되지 않습니다.</span>
                    </td>
                </tr>
                -->
                <tr>
                    <th scope="col">작성자</th>
                    <td id="regMbrNm">${arclInfo.regMbrNm}</td>
                    <th scope="col">등록일</th>
                    <td id="regDtm"><fmt:formatDate value="${arclInfo.regDtm}" pattern="yyyy.MM.dd" /></td>

                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <c:choose>
                    <c:when test="${param.arclSer != null}">
                        <li><button type="button" class="btn-orange" onClick="fn_registArcl();"><span>수정</span></button></li>
                        <li><button type="button" class="btn-gray" onClick="fn_deleteArcl();"><span>삭제</span></button></li>
                        <li><button type="button" class="btn-gray" onClick="goList()"><span>목록</span></button></li>
                    </c:when>
                    <c:otherwise>
                        <li><button type="button" class="btn-orange" onClick="fn_registArcl();"><span>등록</span></button></li>
                        <li><button type="button" class="btn-gray" onClick="goList()"><span>취소</span></button></li>
                    </c:otherwise>
                </c:choose>

            </ul>
        </div>
    </div>
    <form id="frm">
        <input type="hidden" name="arclSer" value="${param.arclSer}" />
        <input type="hidden" name="sStartDate" value="${param.sStartDate}" />
        <input type="hidden" name="sEndDate" value="${param.sEndDate}" />
        <input type="hidden" name="expsTargt" value="${param.expsTargt}" />
        <input type="hidden" name="searchKey" value="${param.searchKey}" />
        <input type="hidden" name="searchWord" value="${param.searchWord}" />
    </form>
</div>

<script type="text/javascript">
    var arclSer = '${param.arclSer}';

    $(document).ready(function(){
        // 등록시 데이터 생성
        if(_nvl(arclSer) == ''){
            var now = new Date();
            var year= now.getFullYear();
            var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
            var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
            var chan_val = year + '.' + mon + '.' + day;
            $('#regDtm').text(chan_val);
            $('#regMbrNm').text('${username}');
            $("input[name='expsTargtCd']").eq(0).attr("checked", true);
        }

        // 팝업설정여부
        /*
        $('input[name=popYn]').change(function(){
            if($(this).val() == 'N'){
                $('#popWidth').val('');
                $('#popHigh').val('');
                $('#popWidth').attr('readonly', true);
                $('#popHigh').attr('readonly', true);
            }else{
                $('#popWidth').attr('readonly', false);
                $('#popHigh').attr('readonly', false);
            }
        });
        */

        // 팝업 미사용시 팝업사이즈지정 readonly
        /*
        if($(':radio[name="popYn"]:checked').val() == 'N'){
            $('#popWidth').attr('readonly', true);
            $('#popHigh').attr('readonly', true);
        }
        */

    });

    // 첨부파일 삭제
    function fn_fileDelete(fileSer){
        if(confirm('첨부파일을 정말 삭제하시겠습니까?')){
            $('#'+fileSer).remove();
        }
    }
    // 첨부파일 추가
    $('#uploadFile').change(function(){
        if($('.attach-list li').length >= 5){
            alert('최대 5개의 파일을 등록할 수 있습니다.');
            return;
        }

        $("#fileForm").ajaxForm({
            url : "${pageContext.request.contextPath}/uploadFile.do?${_csrf.parameterName}=${_csrf.token}",
            dataType: 'text',
            success:function(data, status){
                var response = JSON.parse(data);
                var str = '';
                str += '<li id="'+response.fileSer+'">';
                str += '    <a href="#">' + response.oriFileNm + '</a>';
                str += '    <button type="button" class="btn-attach-delete" onClick="fn_fileDelete('+ response.fileSer +');"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>'
                str += '</li>';
                $('#uploadFile').val("");
                $('.attach-list').append(str);
            }
        }).submit();
    });

    //등록 및 수정버튼 클릭
    function fn_registArcl(){
        if(!$("input[name='expsTargtCd']").is(":checked")) {
            alert("채널을 선택해 주세요");
            return;
        }

        if($.trim($("#title").val()) == "") {
            alert("제목을 입력해 주세요");
            return;
        }

        /*
        if($(':radio[name="popYn"]:checked').val() == 'Y'){
            if($.trim($('#popWidth').val()) == '' || $.trim($('#popHigh').val()) == ''){
                alert('팝업창 사이즈를 설정해주세요.');
                return;
            }
        }
        */

        if($('input:checkbox[name=noti]').is(':checked')){
            $('#notiYn').val('Y');
        }else{
            $('#notiYn').val('N');
        }

        var msg = '';
        if(_nvl(arclSer) != ''){
            msg = '수정하시겠습니까?';
        }else{
            msg = '등록하시겠습니까?';
        }

        if(confirm(msg)) {
            var fileSers = "";
            $('.attach-list').children().each(function(){
                fileSers += $(this).attr('id') + ',';
            });
            $('#fileSers').val(fileSers);
            //$('#popupYn').val($(':radio[name="popYn"]:checked').val());
            $('#popupWidth').val($('#popWidth').val());
            $('#popupHigh').val($('#popHigh').val());
            $('#boardId').val('mtNotice');


            saveContent();
        }
    }

    // 삭제버튼 클릭
    function fn_deleteArcl(){
        if(confirm("삭제하시겠습니까?")){
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
                        //location.href = '${pageContext.request.contextPath}/web/usage/notice/list.do';
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