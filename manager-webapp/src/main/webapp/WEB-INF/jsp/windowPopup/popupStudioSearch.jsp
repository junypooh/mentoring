<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String lectDay = request.getParameter("lectDay").replace(".","");
           lectDay = request.getParameter("lectDay").replace("-","");
    String lectStartTime = request.getParameter("lectStartTime").replace(":","");
    String lectEndTime = request.getParameter("lectEndTime").replace(":","");
    String stdoNo = request.getParameter("stdoNo");
%>


	<div class="w-pop-wrap">
		<div class="w-pop-title-box">
			<p class="w-pop-title">스튜디오 찾기</p>
		</div>
		<div class="w-pop-cont">
			<table class="tbl-style">
				<colgroup>
					<col style="width:85px" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" class="ta-l">소속기관</th>
						<td>
							<input type="text" class="text" name="coNm" id="coNm"/>
						</td>
					</tr>
					<tr>
						<th scope="col" class="ta-l">스튜디오</th>
						<td>
							<input type="text" class="text" name="stdoNm" id="stdoNm" />
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

        $("input[name='coNm']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                $("#aSearch").click();
            }
        });

        $("input[name='stdoNm']").keypress(function (e){
            if(e.keyCode==13){
                e.preventDefault();
                $("#aSearch").click();
            }
        });

        var colModels = [];

        colModels.push({label:'스튜디오', name:'stdoNm',index:'stdoNm', width:'90', align:'center', sortable: false});
        colModels.push({label:'주소', name:'locaAddr',index:'locaAddr', width:'120', align:'center', sortable: false});
        colModels.push({label:'소속기관', name:'posCoNm',index:'posCoNm', width:'90', align:'center', sortable: false});
        colModels.push({label:'선택', name:'stdoInfo',index:'stdoInfo', width:'30', align:'center', sortable: false});

        initJqGridTable('popBoardTable', 'popBoardArea', 589, colModels, false, 310);
        var initText = '스튜디오 또는 소속기관으로 검색해주세요';
        setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, '', initText);


        //검색버튼 클릭
        $("#aSearch").click(function(e){

            e.preventDefault();

            $.ajax({
                url: "${pageContext.request.contextPath}/lecture/mentor/status/ajax.listStdoInfo.do",
                data : $.param({"stdoNm": $("#stdoNm").val(),
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
                        var stdoInfo = '<button type="button" class="btn-style01" onClick="clickOk('+index+');"><span>선택</span></button>';
                        stdoInfo += '<input type="hidden" name="stdoNo" value="'+item.stdoNo+'"/>';
                        stdoInfo += '<input type="hidden" name="stdoNm" value="'+item.stdoNm+'"/>';
                        item.stdoInfo = stdoInfo;
                        return item;
                    });
                    var emptyText = '검색된 결과가 없습니다.';
                    setDataJqGridTable('popBoardTable', 'popBoardArea', 1300, rtnData, emptyText);
                }
            });
        });

    });

   function clickOk(obj){
       var selectStdoNo = '<%=stdoNo%>';
        $("#"+ selectStdoNo,opener.document).val( $("input[name=stdoNo]:eq("+obj+")").val());
        $("#"+ selectStdoNo,opener.document).parent().find("strong").text($("#popBoardTable tr[id="+obj+"] >td:eq(0)").text());
        window.close();
    }

</script>