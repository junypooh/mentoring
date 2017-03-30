<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String lectDay = request.getParameter("lectDay").replace(".","");
           lectDay = request.getParameter("lectDay").replace("-","");
    String lectStartTime = request.getParameter("lectStartTime").replace(":","");
    String lectEndTime = request.getParameter("lectEndTime").replace(":","");
    String mcNo = request.getParameter("mcNo").replace(":","");
%>

	<div class="w-pop-wrap">
		<div class="w-pop-title-box">
			<p class="w-pop-title">MC 찾기</p>
		</div>
		<div class="w-pop-cont">
			<table class="tbl-style">
				<colgroup>
					<col style="width:85px" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" class="ta-l">MC 명</th>
						<td>
							<input type="text" class="text" name="mcNm" id="mcNm"/>
						</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">소속 기관</th>
						<td>
							<input type="text" class="text" name="coNm" id="coNm" />
						</td>
					</tr>
				</tbody>
            </table>
            <div class="btn-group-c">
				<button type="button" class="btn-style02" id="aSearch"><span class="search">검색</span></button>
			</div>
            <div id="popBoardArea" class="pop-board-area">
				<div class="board-bot">
					<p class="bullet-gray fl-l">검색결과</p>
				</div>
				<table id="popBoardTable"></table>
				<!-- <div class="empty-data">소속 기관을 검색해주세요.</div> -->
				<!-- <div class="empty-data">검색된 결과가 없습니다.</div> -->
			</div>
        </div>
	</div>

<script type="text/javascript">
    $(document).ready(function() {
        $('div').removeClass("wrap");

        $("input[name='mcNm']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                $("#aSearch").click();
            }
        });

        $("input[name='coNm']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                $("#aSearch").click();
            }
        });

        var colModels = [];

        colModels.push({label:'번호', name:'no',index:'no', width:'20', align:'center', sortable: false});
        colModels.push({label:'MC명', name:'mcNm',index:'mcNm', width:'100', align:'center', sortable: false});
        colModels.push({label:'성별', name:'genCd',index:'genCd', width:'20', align:'center', sortable: false});
        colModels.push({label:'소속기관', name:'mngrPosNm',index:'mngrPosNm', width:'100', align:'center', sortable: false});
        colModels.push({label:'선택', name:'mcInfo',index:'mcInfo', width:'20', align:'center', sortable: false});

        initJqGridTable('popBoardTable', 'popBoardArea', 589, colModels, false, 310);
        var initText = 'MC명 또는 소속기관으로 검색해주세요';
        setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, '', initText);


        //검색버튼 클릭
        $("#aSearch").click(function(e){

            e.preventDefault();

            $.ajax({
                url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.listMcInfo.do",
                data : $.param({"mcNm": $("#mcNm").val(),
                                "coNm": $("#coNm").val(),
                                "lectDay": '<%=lectDay%>',
                                "searchStDate": '<%=lectStartTime%>',
                                "searchEndDate": '<%=lectEndTime%>'
                                }, true),
                contentType: "application/json",
                dataType: 'json',
                success: function(rtnData) {

                    var rtnData = rtnData.map(function(item, index) {
                        item.no = index + 1;
                        var mcInfo = '<button type="button" class="btn-style01" onClick="clickOk('+index+');"><span>선택</span></button>';
                        mcInfo += '<input type="hidden" name="mcNo" value="'+item.mcNo+'"/>';
                        mcInfo += '<input type="hidden" name="mcNm" value="'+item.mcNm+'"/>';
                        item.mcInfo = mcInfo;
                        return item;
                    });
                    var emptyText = '검색된 결과가 없습니다.';
                    setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, rtnData, emptyText);
                }
            });
        });

    });

   function clickOk(obj){
       var selectMcNo = '<%=mcNo%>';
        $("#"+ selectMcNo,opener.document).val( $("input[name=mcNo]:eq("+obj+")").val());
        $("#"+ selectMcNo,opener.document).parent().find("strong").text($("#popBoardTable tr[id="+obj+"] >td:eq(1)").text());
        window.close();
    }

</script>