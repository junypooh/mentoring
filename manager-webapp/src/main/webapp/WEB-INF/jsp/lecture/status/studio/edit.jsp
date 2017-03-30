<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="cont">
    <div class="title-bar">
        <h2>스튜디오현황</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업정보관리</li>
            <li>스튜디오현황</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <table class="tbl-style tbl-none-search">
            <colgroup>
                <col style="width:147px;" />
                <col style="width:100px;" />
                <col />
            </colgroup>
            <tbody>
                <form id="frm" name="frm">
                    <input type="hidden" class="stdoNo" id="stdoNo" name="stdoNo" value="${param.stdoNo}"/>
                    <tr>
                        <th scope="col" class="ta-l">구분 <span class="red-point">*</span></th>
                        <td colspan="3">
                            <label>
                                <input type="radio" name="indrYn" value="Y" checked /> 내부
                            </label>
                            <label>
                                <input type="radio" name="indrYn" value="N" /> 외부
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">스튜디오 <span class="red-point">*</span></th>
                        <td colspan="3">
                            <input type="text" class="text" id="stdoNm" name="stdoNm"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" rowspan="2" class="ta-l">주소 <span class="red-point">*</span></th>
                        <td>기본주소</td>
                        <td class="address02">
                            <input type="hidden" id="postCd" name="postCd">
                            <input type="hidden" id="sidoNm" name="sidoNm">
                            <input type="hidden" id="sgguNm" name="sgguNm">
                            <input type="hidden" id="umdngNm" name="umdngNm">
                            <input type="text" class="text" id="locaAddr" name="locaAddr" readOnly>
                            <button type="button" class="btn-style01" id="addressPopup"><span>주소검색</span></button>
                        </td>
                    </tr>
                    <tr>
                        <td>상세주소</td>
                        <td class="address02"><input type="text" class="text" id="locaDetailAddr" name="locaDetailAddr"></td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">소속기관</th>
                        <td colspan="3">
                            <input type="hidden" id="posCoNo" name="posCoNo">
                            <input type="text" class="text" id="posCoNm" name="posCoNm" />
                            <button type="button" class="btn-style01" id="coInfoPopup"><span>찾기</span></button>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">담당자</th>
                        <td colspan="3">
                            <input type="text" class="text" id="chrgrNm" name="chrgrNm" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">전화번호</th>
                        <td colspan="3">
                            <input type="text" class="text" id="repTel" name="repTel" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">비고</th>
                        <td colspan="3" class="textarea-wrap">
                            <textarea cols="30" rows="10" class="textarea" id="florNm" name="florNm"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th scope="col" class="ta-l">사용유무</th>
                        <td colspan="3">
                            <label>
                                <input type="radio" name="useYn" value="Y" checked /> 사용중
                            </label>
                            <label>
                                <input type="radio" name="useYn" value="N" /> 사용안함
                            </label>
                        </td>
                    </tr>
                </form>
            </tbody>
        </table>
        <div class="board-bot">
            <ul>
                <li><button type="button" class="btn-orange"><span>저장</span></button></li>
                <li><button type="button" class="btn-gray" onClick="javascript:location.href='${pageContext.request.contextPath}/lecture/status/studio/list.do'"><span>취소</span></button></li>
            </ul>
        </div>
    </div>
</div>
<c:import url="/popup/addressSearch.do">
    <c:param name="popupId" value="_addressPopup" />
    <c:param name="callbackFunc" value="callbackAddSelected" />
</c:import>
<c:import url="/popup/coInfoSearch.do">
    <c:param name="popupId" value="_coInfoPopup" />
    <c:param name="callbackFunc" value="callbackCoSelected" />
</c:import>

<script type="text/javascript">
    var stdoNo = '${param.stdoNo}';

    $(document).ready(function(){

        $('#florNm').on('keyup', function() {
            if($(this).val().length > 250) {
                $(this).val($(this).val().substring(0, 250));
                alert('250자만 입력가능합니다.');
            }
        });

        // 우편번호 찾기
        $("#addressPopup").click(function(){
            $('body').addClass('dim');
            $("#_addressPopup").css("display","block");
            getAddr(1);
        });

        // 소속기관 찾기
        $("#coInfoPopup").click(function(){
            $('body').addClass('dim');
            $("#_coInfoPopup").css("display","block");
            emptyCorpGridSet();
        });

        if(_nvl(stdoNo) != ''){
            fn_init();
        }
    });

    // 우편번호 콜백 함수
    function callbackAddSelected(schInfos){
        $("#locaAddr").val(schInfos.ROADADDR);
        $("#postCd").val(schInfos.ZIPNO);
        var splitAddr = schInfos.JIBUNADDR.split(" ");
        $("#sidoNm").val(splitAddr[0]);
        $("#sgguNm").val(splitAddr[1]);
        $("#umdngNm").val(splitAddr[2]);
    }

    // 소속기관 콜백 함수
    function callbackCoSelected(coInfo){
        $('#posCoNm').val(coInfo.coNm);
        $('#posCoNo').val(coInfo.coNo);
    }

    // 상세데이터 조회
    function fn_init(){
        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/status/studio/ajax.list.do",
            data : {'stdoNo' : stdoNo},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                $('input:radio[name="indrYn"][value="'+rtnData[0].indrYn+'"]').attr('checked', 'checked');
                $('#stdoNm').val(rtnData[0].stdoNm);
                $('#locaAddr').val(rtnData[0].locaAddr);
                $('#locaDetailAddr').val(rtnData[0].locaDetailAddr);
                $('#postCd').val(rtnData[0].postCd);
                $('#sidoNm').val(rtnData[0].sidoNm);
                $('#sgguNm').val(rtnData[0].sgguNm);
                $('#umdngNm').val(rtnData[0].umdngNm);
                $('#posCoNo').val(rtnData[0].posCoNo);
                $('#posCoNm').val(rtnData[0].posCoNm);
                $('#chrgrNm').val(rtnData[0].chrgrNm);
                $('#repTel').val(rtnData[0].repTel);
                $('#florNm').val(rtnData[0].florNm);
                $('input:radio[name="useYn"][value="'+rtnData[0].useYn+'"]').attr('checked', 'checked');
            }
        });
    }

    // 등록 및 수정
    $('.btn-orange').click(function(){
        if($.trim($('#stdoNm').val()) == ''){
            alert('스튜디오 이름을 입력하세요.');
            return;
        }

        if($('#locaAddr').val() == ''){
            alert('주소를 입력하세요.');
            return;
        }

        if($('#locaDetailAddr').val() == ''){
            alert('상세주소를 입력하세요.');
            return;
        }



        if(confirm('저장하시겠습니까?')){
            $.ajax({
                url: "${pageContext.request.contextPath}/lecture/status/studio/ajax.saveStudioInfo.do",
                data : $('#frm').serialize(),
                cache: false,
                success: function(rtnData) {
                    if(rtnData == 'SUCCESS'){
                        alert('저장되었습니다.');
                        location.href='${pageContext.request.contextPath}/lecture/status/studio/list.do'
                    }else{
                        alert('저장에 실패하였습니다.');
                    }
                }
            });
        }




    });
</script>