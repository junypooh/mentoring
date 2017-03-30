<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="layer-pop-wrap" id="layer1">
    <div class="title">
        <strong>수업자료 등록</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"/></a>
    </div>
    <div class="cont type3">
        <div class="lesson-data">
            <span class="designation"><label><input type="checkbox" name="" class="aaa"> 공지 지정</label></span>

            <div class="board-input-type1 upload">
                <form:form commandName="arclInfo" action="${pageContext.request.contextPath}/layer/registLecutureData.do?${_csrf.parameterName}=${_csrf.token}" method="post" id="arclFrm" enctype="multipart/form-data">
                    <form:input type="hidden" path="boardId" value="lecFile"/>
                    <form:input type="hidden" path="sust" value=""/>
                    <form:input type="hidden" path="arclSer" value="0"/>
                    <form:input type="hidden" path="cntntsTargtCd" value="101509"/>
                    <form:input type="hidden" path="cntntsTargtNo" value=""/>
                    <form:input type="hidden" path="cntntsTargtTims" value=""/>
                    <form:input type="hidden" path="cntntsTargtNm" value=""/>
                    <form:input type="hidden" path="title" value=""/>
                    <form:input type="hidden" path="notiYn" value="N"/>
                    <form:input type="hidden" path="regMbrNo" value=""/>
                <table>
                    <caption>추가정보 항목 - 연락처, 직업선택, 멘토약력 및 자기소개</caption>
                    <colgroup>
                        <col style="width:98px;"/>
                        <col/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">제목</th>
                        <td><input type="text" class="inp-style1 h30" style="width:485px;" value="" name="" id="articleSubject"/></td>
                    </tr>
                    <tr>
                              <th scope="row">분류</th>
                              <td>
                                <label class="radio-skin checked" style={{'margin-right': '15px'}}><input type="radio" title="사전보조자료" name="categorize" value="beforeData" />사전보조자료</label>
                                <label class="radio-skin" style={{'margin-right': '15px'}}><input type="radio" title="사후보조자료" name="categorize" value="afterData" />사후보조자료</label>
                                <label class="radio-skin" style={{'margin-right': '15px'}}><input type="radio" title="수업보조자료" name="categorize" value="lectData" />수업보조자료</label>
                                <label class="radio-skin" style={{'margin-right': '15px'}}><input type="radio" title="기타자료" name="categorize" value="etcData" />기타자료</label>
                              </td>
                            </tr>
                            <tr>
                                <th scope="row">수업대상</th>
                                <td>
                                    <label class="chk-skin checked" style={{'margin-right': '15px'}}><input type="checkbox" name="lectTargtSubCheck" id="lectTargtCheck0" className="chk-skin" value="101534" />초등</label>
                                    <label class="chk-skin" style={{'margin-right': '15px'}}><input type="checkbox" name="lectTargtSubCheck" id="lectTargtCheck1" className="chk-skin" value="101535"/>중등</label>
                                    <label class="chk-skin" style={{'margin-right': '15px'}}><input type="checkbox" name="lectTargtSubCheck" id="lectTargtCheck2" className="chk-skin" value="101536"/>고등</label>
                                </td>
                            </tr>
                          <tr>
                    <tr>
                        <th scope="row">파일첨부</th>
                        <td>
                            <div class="input-file" id="layerInputFile"><input type="file" title="파일찾기" name="upload_file" id="layerComFileInfoFile0" onchange="fnLayerFileSelect(this.files)" /><span class="max-num">* 개별 파일 용량 20MB 및 최대 5개까지 지원</span></div>
                            <ul class="file-list-type01" id="layerfileList">
                            </ul>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </form:form>
            </div>
            <div class="btn-area">
                <a href="javascript:void(0)" class="btn-type2" id="aConfirm">확인</a>
                <a href="javascript:void(0)" class="btn-type2 gray" id="aCancel">취소</a>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function() {

        //확인버튼 클릭
        $("#aConfirm").click(function(){

            if($("#articleSubject").val().trim() == ""){
                alert("수업자료 제목을 입력해주세요.");
                return false;
            }

            if($("#layerfileList").find("li").length == 0){
                alert("등록할 수업자료가 없습니다.");
                return false;
            }

            if($("#layerfileList").find("li").length > 5){
                alert("수업자료는 5개까지 등록가능합니다.");
                return false;
            }

            if(!confirm("등록하시겠습니까?")) {
                return false;
            }

          /////////////////////
          var cntntsTypeCd = "";

              //수업대상
              var checkLectType = new Array;

              $("input:checkbox[name=lectTargtSubCheck]").each(function () {
                  if ($(this).parent().hasClass("checked")) {
                      var checkVal = $(this).val();
                      checkLectType.push(checkVal);
                  }
              });
              if (checkLectType.length == 2) {
                  if (!!~checkLectType.indexOf("101534") && !!~checkLectType.indexOf("101535")) { //초등,중학교
                      cntntsTypeCd = "101537";
                  } else if (!!~checkLectType.indexOf("101535") && !!~checkLectType.indexOf("101536")) { //중등,고등학교
                      cntntsTypeCd = "101538";
                  } else if (!!~checkLectType.indexOf("101534") && !!~checkLectType.indexOf("101536")) { //초등,고등학교
                      cntntsTypeCd = "101539";
                  }
              } else if (checkLectType.length == 1) {
                  cntntsTypeCd = checkLectType[0];
              } else {
                  cntntsTypeCd = "101540";
              }

              var prefNo = "";
              $("input:radio[name=categorize]").each(function () {
                  if ($(this).parent().hasClass("checked")) {
                      prefNo = $(this).val();
                  }
              });

          ///////////////////

            //수업자료
            $("#layerInputFile").find("input[type=file]").each(function(idx) {
                $(this).attr("name", "listArclFileInfo[" +idx +"].comFileInfo.file");
            }).filter(':last').attr('name', '_');

            //멘토ID
            $("#regMbrNo").val($("#lectrMbrNo").val());

            $("#cntntsTargtNo").val($("#lectSer").val());
            $("#cntntsTargtNm").val($("#lectTitle").val());
            $("#title").val($("#articleSubject").val());

            //로딩바
            $("body").addClass("loader");
            $(".page-loader").show();
            $("#arclFrm").ajaxForm({
                url :  "${pageContext.request.contextPath}/layer/registLecutureData.do?${_csrf.parameterName}=${_csrf.token}&prefNo="+prefNo+"&cntntsTypeCd="+cntntsTypeCd,
                sync : true,
                success:function(response, status){
//                    $("#aCancel").trigger('click');
                    if(response.success){
                        alert(response.data);
                        document.location.reload();
                    }else{
                        $("body").removeClass("loader");
                        alert(response.message);
                    }
                    $(".page-loader").hide();
                }
            }).submit();
//            $('#arclFrm')[0].reset();
        });
        position_cm();
    });


    $("input:checkbox[name=lectTargtCheck]").each(function (idx) {
            if(typeof(article) == "object"){
                var cntntsTypeCds = [];
                switch(article.cntntsTypeCd){
                    case '101534':
                        cntntsTypeCds.push(article.cntntsTypeCd);
                        break;
                    case '101535':
                        cntntsTypeCds.push(article.cntntsTypeCd);
                        break;
                    case '101536':
                        cntntsTypeCds.push(article.cntntsTypeCd);
                        break;
                    case '101537':
                        cntntsTypeCds.push('101534','101535');
                        break;
                    case '101538':
                        cntntsTypeCds.push('101535','101536');
                        break;
                    case '101539':
                        cntntsTypeCds.push('101534','101536');
                        break;
                    case '101540':
                        cntntsTypeCds.push('101534','101535','101536');
                        break;
                    default:
                }

                var idx = $.inArray($(this).val(),cntntsTypeCds);
                if(idx >= 0){
                    $(this).parent().addClass("checked");
                }else{
                    $(this).parent().removeClass("checked");
                }

            }else{
                if(idx == 0)
                    $(this).parent().addClass("checked");
                else
                    $(this).parent().removeClass("checked");
            }
        });

        $("input:radio[name=categorize]").each(function (idx) {
            if(typeof(article) == "object"){
                 if($(this).val() == article.prefNo){
                    $(this).parent().addClass("checked");
                 }else{
                    $(this).parent().removeClass("checked");
                 }
            }else{
                if(idx == 0)
                    $(this).parent().addClass("checked");
                else
                    $(this).parent().removeClass("checked");
            }
        });

    function fnTabFileSelect(obj){
        if(!$(obj).parent().parent().hasClass('active')){
            $('.lesson-data-list li').removeClass('active');
            $(obj).parent().parent().addClass('active');
        }else{
            $(obj).parent().parent().removeClass('active');
        }
    }

    function fnLayerFileSelect(files){
        var fileClone = $("#layerInputFile").find("input[type=file]:last").clone();
        $("#layerInputFile").find("input[type=file]:last").hide();
        $('#layerfileList').append('<li>'+files[0].name + '<a href="javascript:void(0)"><img src="${pageContext.request.contextPath}/images/common/btn_file_del.gif" alt="삭제" onclick="fileLayerRemove(this, null)"></a></li>');
        $('#layerInputFile').append(fileClone);
    }

    function fileLayerRemove(obj, fileSer){
        $(obj).parent().parent().remove();

        if($("#layerInputFile").find("input[type=file]").length == 1){
            $("#layerInputFile").find("input[type=file]:first").val("");
        }else{
            $("#layerInputFile").find("input[type=file]:first").remove();
        }
    }
</script>