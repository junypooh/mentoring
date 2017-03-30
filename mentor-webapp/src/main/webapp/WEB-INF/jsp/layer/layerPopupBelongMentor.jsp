<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Template ================================================================================ --%>
<script type="text/html" id="mentorList">
    <tr name="mentorInfo">
        <td >\${rn}</td>
        <td class="mentor-find-id">\${id}</td>
        <td class="mentor-find-name">\${nm}</td>
        <td class="mentor-find-job">\${jobNm}</td>
        <td><input type="radio" name="job"></td>
        <input type="hidden" name="mbrNo" value="\${mbrNo}">
        <input type="hidden" name="jobNo" value="\${jobNo}">
        <input type="hidden" name="jobNm" value="\${jobNm}">
    </tr>
</script>
<script type="text/html" id="emptyMentorList">
    <tr>
        <td colspan="5">검색된 결과가 없습니다.</td>
    </tr>

</script>

<%-- Template ================================================================================ --%>
<script type="text/html" id="totalInfo">
    검색 결과 <strong>총 <em>\${totalRecordCount}</em> 건</strong>
</script>
<%-- Template ================================================================================ --%>

<div class="layer-pop-wrap" id="layer1">
    <div class="title">
		<strong>멘토 찾기</strong>
		<a href="#" class="pop-close"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"></a>
	</div>
	<div class="cont board">
		<div class="box-style request-lesson">
			<div class="board-type2">
				<table>
					<caption>멘토 - 요청유형, 수업대상, 멘토, 제목</caption>
					<colgroup>
						<col style="width:80px;">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">요청유형</th>
							<td>
								<select id="jobLv1Selector" style="width:150px;">
                                    <option value="">1차분류</option>
                                </select>
                                <select id="jobLv2Selector" style="width:150px;">
                                    <option value="">2차분류</option>
                                </select>
                                <select id="jobLv3Selector" style="width:150px;">
                                    <option value="">3차분류</option>
                                </select>
                            </td>
                        </tr>
						<tr>
							<th scope="row" class="compulsory">아이디</th>
							<td><input type="text" id="mbrId" class="inp-style1" style="width:97%" name=""></td>
						</tr>
                        <tr>
							<th scope="row" class="compulsory">이름</th>
							<td><input type="text" id="mbrNm" class="inp-style1" style="width:97%" name=""></td>
						</tr>
						<tr>
							<th scope="row" class="compulsory">직업명</th>
							<td><input type="text" id="mbrJobNm" class="inp-style1" style="width:97%" name=""></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-area">
                <a href="javascript:void(0)" class="btn-type2 search" id="aSearch"><span>검색</span></a>
			</div>
            <div class="result-info">
                <p class="search-result"></p>
            </div>
			<div class="pop-board-scroll">
				<div class="board-type1">
					<table>
						<caption>멘토찾기 검색결과 - 번호, 이름, 아이디, 닉네임, 직업명, 선택</caption>
						<colgroup>
							<col style="width:50px;"/>
							<col style="width:120px;" />
							<col style="width:90px;" />
							<col style="width:120px;" />
							<col style="width:50px;" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">아이디</th>
								<th scope="col">이름</th>
								<th scope="col">직업명</th>
								<th scope="col">선택</th>
							</tr>
						</thead>
						<tbody class="studio-info-ul">
						    <tr>
                                <td colspan="5">멘토 검색정보를 입력해주세요.</td>
                            </tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
        <div class="btn-area">
            <a href="#" class="btn-type2 blue" id="aConfirm">확인</a>
            <a href="#" class="btn-type2 gray" id="cnclBtn">취소</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {

         searchEnter($("#mbrId"));
         searchEnter($("#mbrJobNm"));
         searchEnter($("#mbrNm"));

        // 1차 분류 코드 정보
        $.ajax({
            url: '${pageContext.request.contextPath}/jobClsfCd.do',
            data: { cdLv: 1 },
            success: function(rtnData) {
                $('#jobLv1Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
            },
            async: false,
            cache: false,
            type: 'post',
        });

        // 1차 분류 변경
        $('#jobLv1Selector').change(function() {

            $('#jobLv2Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 2, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv2Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });

        // 2차 분류 변경
        $('#jobLv2Selector').change(function() {

            $('#jobLv3Selector').find('option:not(:first)').remove().end().val('').change();

            if (this.value) {
                $.ajax('${pageContext.request.contextPath}/jobClsfCd.do', {
                    data: { cdLv: 3, supCd: this.value },
                    success: function(rtnData) {
                        $('#jobLv3Selector').loadSelectOptions(rtnData,'','cd','cdNm',1);
                    },
                    async: false,
                    cache: false,
                    type: 'post',
                });
            }
        });



        //검색버튼 클릭
        $("#aSearch").click(function(){
            goSearch();
        });

        //확인버튼 클릭
        $("#aConfirm").click(function(e){
            e.preventDefault();

            var labelSelector = $("input:radio:checked[name='job']").parent().parent();

            if(labelSelector.length < 1){
                alert("선택된 멘토가 없습니다.");
                return false;
            }else{
                var nm = labelSelector.children(".mentor-find-name").text();
                var mbrNo = labelSelector.children("input[name='mbrNo']").val();
                var jobNo = labelSelector.children("input[name='jobNo']").val();
                var jobNm = labelSelector.children("input[name='jobNm']").val();

                var func = "${param.callbackFunc}";

                if(func != null){
                    eval(func).call(null, mbrNo, nm, jobNo, jobNm);
                    $(".pop-close").click();
                }
            }
        });

        $("#cnclBtn").click(function(e){
            $(".pop-close").click();
        });



        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $(".pop-close").click();
            }
        });

        position_cm();

    });

    function goSearch(){

            if(  $('#jobLv1Selector').val() == "" && $('#jobLv2Selector').val() == "" && $('#jobLv3Selector').val() == ""
              && $("#mbrId").val() == "" && $("#mbrNm").val() == "" && $("#mbrJobNm").val() == "") {
                alert("하나 이상의 검색을 지정해 주세요");
                return false;
            }


            var jobClsfCd = ""
            if($('#jobLv3Selector').val() != ""){
                jobClsfCd = $('#jobLv3Selector').val();
            }else if($('#jobLv2Selector').val() != ""){
                jobClsfCd = $('#jobLv2Selector').val();
            }else{
                jobClsfCd = $('#jobLv1Selector').val();
            }



            $.ajax({
                url: "${pageContext.request.contextPath}/layer/ajax.listBelongMentor.do",
                data : $.param({"mbrId":$("#mbrId").val(), "mbrNm":$("#mbrNm").val(), "mbrJobNm":$("#mbrJobNm").val(), "jobClsfCd" : jobClsfCd }, true),
                success: function(rtnData) {
                    $(".search-result").empty();
                    $("#totalInfo").tmpl({"totalRecordCount":rtnData.length}).appendTo(".search-result");

                    $(".studio-info-ul").empty();

                    if(rtnData.length > 0){
                        $("#mentorList").tmpl(rtnData).appendTo(".studio-info-ul");
                    }else{
                        $("#emptyMentorList").tmpl().appendTo(".studio-info-ul");
                    }


                    position_cm();
                }
            });
    }

    function searchEnter(obj){
        obj.keypress(function(e){
            if(e.keyCode==13){
                goSearch();
            }
        });
    }


</script>
