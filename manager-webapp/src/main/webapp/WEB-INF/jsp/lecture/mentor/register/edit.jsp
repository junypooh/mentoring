<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<security:authorize access="isAuthenticated()">
    <security:authentication var="username" property="principal.username" />
</security:authorize>

<div class="cont">
    <div class="title-bar">
        <h2>수업등록관리</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업개설관리</li>
            <li>수업등록관리</li>
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
            <form:form commandName="lectInfo" id="frm" method="post" action="${pageContext.request.contextPath}/lecture/mentor/register/lectInfoUpdate.do">
                <form:hidden path="lectSer"/>
                <input type="hidden" id="fileSer" name="fileSer" />
                <input type="hidden" id="delFileSer" name="delFileSer" />
                <tr>
                    <th scope="col">배정사업</th>
                    <td colspan="3"> ${lectInfo.grpNm} </td>
                </tr>
                <tr>
                    <th scope="col">수업명 *</th>
                    <td colspan="3">
                        <form:input path="lectTitle" cssStyle="width:60%" />
                        <span class="fl-r"><strong class="red-txt">${fn:length(lectInfo.lectTitle)}</strong> / 20자</span>
                    </td>
                </tr>
                <tr>
                    <th scope="col">멘토</th>
                    <td colspan="3"> ${lectInfo.lectrNm} </td>
                </tr>
                <tr>
                    <th scope="col">직업명</th>
                    <td colspan="3"> ${lectInfo.lectrJobNm} </td>
                </tr>
                <tr>
                    <th scope="col">수업유형</th>
                    <td colspan="3"> ${lectInfo.lectTypeCdNm} </td>
                </tr>
                <tr>
                    <th scope="col">수업대상</th>
                    <td colspan="3">
    				    <c:choose>
					        <c:when test="${lectInfo.lectTargtCd eq '101534'}"> 초 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101535'}"> 중 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101536'}"> 고 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101537'}"> 초중 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101538'}"> 중고 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101539'}"> 초고 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101540'}"> 초중고 </c:when>
					        <c:when test="${lectInfo.lectTargtCd eq '101713'}"> 기타 </c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th scope="col">수업개요</th>
                    <td colspan="3">
                        <form:input path="lectOutlnInfo" cssStyle="width:60%" />
                        <span class="fl-r"><strong class="red-txt">${fn:length(lectInfo.lectOutlnInfo)}</strong> / 20자</span>
                    </td>
                </tr>
                <tr>
                    <th scope="col">수업소개 *</th>
                    <td colspan="3" class="textarea-wrap">
                            <form:textarea path="lectIntdcInfo"  cols="30" rows="10" class="textarea"  placeholder="* Text 내용이 들어갑니다.."/>
                            <p class="over-hidden"><span class="fl-r"><strong class="red-txt">${fn:length(lectInfo.lectIntdcInfo)}</strong> / 200자</span></p>
                    </td>
                </tr>
                <tr>
                    <th scope="col">수업내용 *</th>
                    <td colspan="3">
                        <jsp:include page="/layer/editor.do" flush="true">
                            <jsp:param name="wrapperId" value="content_area_id"/>
                            <jsp:param name="contentId" value="content_area_id"/>
                            <jsp:param name="formName" value="frm"/>
                        </jsp:include>
                        <form:textarea path="lectSustInfo" id="content_area_id" cssStyle="display:none;" />
                    </td>
                </tr>
            </form:form>
                <tr>
                    <th scope="col">이미지 *</th>
                    <td colspan="3">
                        <p class="attach-box">
                            <form id="fileForm" method="post" enctype="multipart/form-data">
                                <input type="text" class="text" />
                                <input type="file" id="uploadFile" name="upload_file" class="btn-file" />
                                <span class="attach-ps">* jpg, png 지원 / 최적화 사이즈 245*245</span>
                            </form>
                        </p>
                        <ul class="attach-list">
                             <c:forEach items="${lectInfo.listLectPicInfo}" var="item">
                                <li id="${item.fileSer}">
                                    <a href="#">${item.comFileInfo.oriFileNm}</a>
                                    <button type="button" class="btn-attach-delete" onClick="fn_fileDelete(${item.fileSer});"><img src="${pageContext.request.contextPath}/images/btn_attach_delete.gif" alt="첨부파일 삭제" /></button>
                                </li>
                             </c:forEach>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th scope="col">요청수업 *</th>
                    <td colspan="3"> 버튼 노출 예정</td>
                </tr>
                <tr>
                    <th scope="col">교육수행기관</th>
                    <td colspan="3"> ${lectInfo.coNm} </td>
                </tr>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange" onClick="fn_UpdateLectInfo();"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" onClick="javascript:location.href='${pageContext.request.contextPath}/lecture/mentor/register/view.do?lectSer=${lectSer}'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
</div>

<script type="text/javascript">
    var arclSer = '${param.arclSer}';

    $(document).ready(function(){

        $("#lectTitle").bind('change keydown keyup blur', function() {
            var maximumLength = 20;
            var $input = $("#lectTitle");

            fnMaxLengthChk($input, maximumLength);
        });

        $("#lectOutlnInfo").bind('change keydown keyup blur', function() {
            var maximumLength = 20;
            var $input = $("#lectOutlnInfo");

            fnMaxLengthChk($input, maximumLength);
        });

        $("#lectIntdcInfo").bind('change keydown keyup blur', function() {
            var maximumLength = 200;
            var $input = $("#lectIntdcInfo");

            fnMaxLengthChk($input, maximumLength);
        });


    });

    function fnMaxLengthChk($input, maximumLength){
        if($input.val().length > maximumLength){
            alert('허용된 글자수가 초과되었습니다.\r\n\n초과된 부분은 자동으로 삭제됩니다.');
            var str = $input.val().substr(0, maximumLength);
            $input.val(str);
        }
        stringByteLength = $input.val().length;
        $input.parent().find('span').find('strong').text(stringByteLength);
    }


    // 첨부파일 삭제
    function fn_fileDelete(fileSer){
        if(confirm('첨부파일을 정말 삭제하시겠습니까?')){
            $('#'+fileSer).remove();
            var delFileSer = $('#delFileSer').val() + fileSer + ',';
            $('#delFileSer').val(delFileSer);
        }
    }

    // 첨부파일 추가
    $('#uploadFile').change(function(){
        if($('.attach-list li').length >= 3){
            alert('최대 3개의 파일을 등록할 수 있습니다.');
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

                var fileSer = $('#fileSer').val() + response.fileSer + ',';
                $('#fileSer').val(fileSer);
            }
        }).submit();
    });

    //등록 및 수정버튼 클릭
    function fn_UpdateLectInfo(){

        if($.trim($("#lectTitle").val()) == "") {
            alert("수업명을 입력해 주세요");
            return;
        }

        if($.trim($("#lectIntdcInfo").val()) == "") {
            alert("수업 소개를 입력해 주세요");
            return;
        }

        if(!validForm(Editor)){
           return false;
        }


        if($('.attach-list li').length < 1){
            alert('1개 이상의 수업 이미지를 등록해주세요.');
            return;
        }


        if(confirm('수정하시겠습니까?')) {
/*            var fileSers = "";
            $('.attach-list').children().each(function(){
                fileSers += $(this).attr('id') + ',';
            });
            $('#fileSers').val(fileSers);
*/
            saveContent();
        }
    }

</script>