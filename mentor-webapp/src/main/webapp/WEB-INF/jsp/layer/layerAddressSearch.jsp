<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

		<div class="layer-pop-wrap w710" id="addressLayer">
			<div class="title">
				<strong>주소 검색</strong>
				<a href="javascript:void(0)" class="pop-close" id="popClose"><img src="${pageContext.request.contextPath}/images/common/btn_popup_close.png" alt="팝업 닫기"></a>
			</div>
			<div class="cont board">
                <form name="form" id="form" method="post">
                <input type="hidden" name="currentPage" value="1"/>
                <input type="hidden" name="countPerPage" value="1000"/>
                <input type="text" name="confmKey" id="confmKey" style="width:250px;display:none" value="U01TX0FVVEgyMDE1MTExODE3MDgyMjA="/>
				<div class="box-style request-lesson">
					<div class="board-type2">
						<table>
							<caption>주소 검색 테이블 - 주소</caption>
							<colgroup>
								<col style="width:114px;">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row" class="compulsory">주소</th>
									<td><input type="text" class="inp-style1" style="width:97%" name="keyword" id="keyword"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<p class="id-overlap-txt">* 도로명, 건물명, 지번에 대한 통합 검색이 가능합니다. (예 : 반포대로 58, 국립중앙박물관, 삼성동25)</p>
					<div class="btn-area" id="addrSearchBtn">
						<a href="javascript:void(0)" class="btn-search" onclick="getAddr()"><span>검색</span></a>
					</div>
					<div class="pop-board-scroll">
						<div class="board-type1">
							<table>
								<caption>주소 검색결과 - 우편번호, 도로명주소, 지번주소, 선택</caption>
								<colgroup>
									<col style="width:100px;" />
									<col />
									<col />
									<col style="width:90px;" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">우편번호</th>
										<th scope="col">도로명주소</th>
										<th scope="col">지번주소</th>
										<th scope="col">선택</th>
									</tr>
								</thead>
								<tbody id="addrList">
									<tr>
										<td colspan="4">검색해주세요.</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				</form>
			</div>
		</div>

<%-- Template ================================================================================ --%>
<script type="text/html" id="addrListData">
    <tr>
        <td>\${ZIPNO}</td>
        <td class="al-left">\${ROADADDR}</td>
        <td class="al-left">\${JIBUNADDR}</td>
        <td><a href="javascript:void(0)"; class="btn-type1" onclick="selectAddr(\${idx})">선택</a></td>
    </tr>
</script>
<%-- Template ================================================================================ --%>
<script type="text/javascript">

    $(document).ready(function() {

        enterFunc($("#keyword"), getAddr);

        /** ESC 버튼 으로 레이어 닫기 */
        $(document).on('keyup',function(evt) {
            if (evt.keyCode == 27) {
                $("#popClose").click();
            }
        });
    });


    function selectAddr(obj){
        var element = {};

        $('#addrList').find('tr').each(function(idx) {
            if(idx == obj) {
                element.ROADADDR = $(this).children().eq(1).text();
                element.JIBUNADDR = $(this).children().eq(2).text();
                element.ZIPNO = $(this).children().eq(0).text();
            }
        });

        //console.log(element);

        ${param.callbackFunc}(element);
        $("#popClose").click();
    }

    function getAddr(){

        $('#addrSearchBtn').css('display', 'none');
        $("#addrList").empty().append("<tr><td colspan='4'>조회 중입니다. 잠시만 기다려주세요.</td></tr>");

        var protocol = document.location.protocol;
        $.ajax({
             url : protocol+"//www.juso.go.kr/addrlink/addrLinkApiJsonp.do"
            , type:"post"
            , data:$("#form").serialize()
            , dataType:"jsonp"
            , crossDomain:true
            , success:function(xmlStr){

                if(xmlStr != null){

                    if(navigator.appName.indexOf("Microsoft") > -1){
                        var xmlData = new ActiveXObject("Microsoft.XMLDOM");
                        xmlData.loadXML(xmlStr.returnXml)
                    }else{
                        var xmlData = xmlStr.returnXml;
                    }

                    var errCode = $(xmlData).find("errorCode").text();
                    var errDesc = $(xmlData).find("errorMessage").text();
                    if(errCode != "0"){
                        //alert(errCode+"="+errDesc);
                        $("#addrList").empty().append("<tr><td colspan='4'>["+errCode+"] "+errDesc+"</td></tr>");
                    }else{
                        data = makeData(xmlData);
                        //console.log(data);

                        var addrData = data.map(function(item, index) {
                            item.idx = index;
                            return item;
                        });

                        $("#addrList").empty();
                        $("#addrListData").tmpl(addrData).appendTo("#addrList");

                        if(data == null || data.length < 1) {
                            $("#addrList").empty().append("<tr><td colspan='4'>검색된 결과가 없습니다.</td></tr>");
                        }

                    }
                }
                $('#addrSearchBtn').css('display', 'block');
            }
        });
    }

    function makeData(xmlStr){
        var data = [];
        $(xmlStr).find("juso").each(function(){
            var item = {};

            $(this).children().each(function(){
                item[$(this).prop("tagName")] = $(this).text();
            });
            data.push(item);
        });
        return data;
    }
</script>