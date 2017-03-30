<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>



<%-- Template ================================================================================ --%>
<script type="text/html" id="requestList">
    <tr>INTDC_DATA_YN
		<td>\${rn}</td>
		<td>
		    \${dataTypeCdNm}
		</td>
		<td>
            {{if dataTargtClass == '101534' }} 초
		    {{else dataTargtClass == '101535' }} 중
		    {{else dataTargtClass == '101536' }} 고
		    {{else dataTargtClass == '101537' }} 초, 중
		    {{else dataTargtClass == '101538' }} 중, 고
		    {{else dataTargtClass == '101539' }} 초, 고
		    {{else dataTargtClass == '101540' }} 초, 중, 고
		    {{else dataTargtClass == '101713' }} 기타
            {{/if}}
		</td>
		<td class="al-left"><span class="txt-hid">\${dataNm}</span></td>
		<td><a href="#" class="btn-type1"  onclick="fnSetLectData(\${dataSer})">선택</a></td>
	</tr>
</script>
<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>


<div class="layer-pop-wrap" id="layer">
    <div class="title">
        <strong>수업자료 연결</strong>
        <a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"></a>
    </div>
    <div class="cont board">
		<div class="box-style request-lesson">
			<div class="board-type2">
				<table>
					<caption>수업자료 검색 테이블 - 자료대상, 자료명</caption>
					<colgroup>
						<col style="width:114px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<input type="hidden" id="lectTargtCd" />
							<input type="hidden" id="ownerMbrNo" value="${param.lectrMbrNo}"/>
							<input type="hidden" id="lectSer" value="${param.lectSer}"/>
							<th scope="row">자료대상</th>
							<td>
    							<label class="chk-skin"><input type="checkbox" name="cntntsType" value="101534" class="chk-skin"/>초등</label>
								<label class="chk-skin"><input type="checkbox" name="cntntsType" value="101535" class="chk-skin"/>중등</label>
								<label class="chk-skin"><input type="checkbox" name="cntntsType" value="101536" class="chk-skin"/>고등</label>
								<label class="chk-skin"><input type="checkbox" name="schoolEtcGrd" value="101713" class="chk-skin"/>기타</label>
							</td>
						</tr>
						<tr>
							<th scope="row" class="compulsory">자료명</th>
							<td><input type="text" class="inp-style1" id="searchWord" style="width:97%" name=""></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-area">
				<a href="#" class="btn-search" id="aSearch"><span>검색</span></a>
			</div>
			<div class="result-info">
				<p class="search-result"></p>
			</div>
			<div class="pop-board-scroll">
				<div class="board-type1">
					<table>
						<caption>수업자료 검색결과 - 번호, 구분, 대상, 자료명, 선택</caption>
						<colgroup>
							<col style="width:50px;" />
							<col style="width:80px;" />
							<col style="width:80px;" />
							<col />
							<col style="width:80px;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">구분</th>
								<th scope="col">대상</th>
								<th scope="col">자료명</th>
								<th scope="col">선택</th>
							</tr>
						</thead>
						<tbody id="resultList"> </tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>



<script type="text/javascript">
    $(document).ready(function() {
        position_cm();


        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".pop-close").click();
            }
        });



        //검색버튼 클릭
        $("#aSearch").click(function(e){
            e.preventDefault();

            // 수업대상
            var checkLectType = new Array;

            // 대상선택 체크박스
            $('input[name=cntntsType]:checked').each(function(index){
                checkLectType.push($(this).val());
            });

            if(checkLectType.length == 1){
                $("#lectTargtCd").val(checkLectType[0]);
            }else if(checkLectType.length == 2){
                if (!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101535_중학교']}")) { //초등,중학교
                    $("#lectTargtCd").val("${code['CD101533_101537_초등_중학교'] }");
                } else if (!!~checkLectType.indexOf("${code['CD101533_101535_중학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")) { //중등,고등학교
                    $("#lectTargtCd").val("${code['CD101533_101538_중_고등학교'] }");
                } else if (!!~checkLectType.indexOf("${code['CD101533_101534_초등학교']}") && !!~checkLectType.indexOf("${code['CD101533_101536_고등학교']}")) { //초등,고등학교
                    $("#lectTargtCd").val("${code['CD101533_101539_초등_고등학교'] }");
                }
            }else if(checkLectType.length == 3){
                $("#lectTargtCd").val("${code['CD101533_101540_초등_중_고등학교'] }");
            }else{
                $("#lectTargtCd").val("");
            }

            var dataSet = {
                params: {
                    schoolGrd: $("#lectTargtCd").val(),
                    schoolEtcGrd: $('input[name=schoolEtcGrd]:checked').val(),
                    ownerMbrNo : $("#ownerMbrNo").val(),
                    intdcDataYn : 'N',
                    lectSer : $("#lectSer").val(),
                    searchWord : $("#searchWord").val(),
                    searchKey : 'dataNm'
                }
            };

            $.ajax({
                url: "${pageContext.request.contextPath}/lecture/lectureData/ajax.mentorDataList.do",
                data : $.param(dataSet.params, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#resultList").empty();

                    if(rtnData.length >0){
                        $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");
                        $("#requestList").tmpl(rtnData).appendTo("#resultList");
                    }else{
                        $('.search-result').append(
                            '검색 결과 <strong>총 <em>0</em> 건</strong>'
                        );
                        $('#resultList').append(
                            '<tr><td colspan="5">검색된 결과가 없습니다.</td></tr>'
                        );
                    }
                position_cm();
                }
            });
        });
        $("#aSearch").click();

    });


    function fnSetLectData(dataSer){

        if(!confirm("등록 하시겠습니까?")) {
            return false;
        }

        var dataSet = {
            params: {
                lectSer : $("#lectSer").val(),
                dataSer : dataSer
                }
            };

        $.ajax({
            url: '${pageContext.request.contextPath}/lecture/lectureData/ajax.insertMappingLectData.do',
            data : $.param(dataSet.params, true),
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                    $(".layer-pop-wrap").find(".btn-type2.gray").trigger('click');
                    mentor.DataList.getList(dataSet.params.currentPageNo);
                }else{
                    alert(rtnData.message);
                }
            }
        });

        $(".pop-close").click();
    }


</script>