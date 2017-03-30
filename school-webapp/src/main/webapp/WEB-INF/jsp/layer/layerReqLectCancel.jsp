<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="layer-pop-wrap" id="layer1">
<div class="layer-pop" >
    <div class="layer-header">
        <strong class="title">수업 요청취소</strong>
    </div>
    <div class="layer-cont">
        <div class="box-style cancel">
            <strong class="title-style"><em>해당 요청을</em> 취소하시겠습니까?.</strong>
            <div class="box-style2 class">
                <strong>${resultLectReqInfo.lectTitle}</strong>
            </div>
            <div class="cancel-reason">
                <div class="reason-input">
                    <strong>취소사유입력</strong>
                    <span><em>0</em> / 200자</span>
                </div>
                <div class="reason-text">
                    <textarea class="ta-style" id="lectSust" maxlength="200"></textarea>
                </div>
                <div class="reason-btn">
                    <a href="#" class="btn-type2 search" onclick="fnCancelReqLectInfo()">취소신청</a>
                </div>
            </div>
        </div>
        <div class="btn-area popup">
            <%--<a href="#" class="btn-type2 popup">취소</a>--%>
        </div>
        <a href="#" class="layer-close">팝업 창 닫기</a>
    </div>
</div>
    </div>
<script type="text/javascript">
    $(document).ready(function(){
        position_cm();
        $("#lectSust").bind('change keydown keyup blur', function() {
            stringByteLength = $("#lectSust").val().length;
            $(this).parent().parent().find('span').html('<em>'+stringByteLength+'</em>/20자');
        });
    });

    function fnCancelReqLectInfo(){
        if($("#lectSust").val() == ""){
            alert("취소사유를 입력해주세요.");
            return false;
        }

        if(!confirm("요청취소 하시겠습니까?")) {
            return false;
        }

        var _param = {'reqSer':'${resultLectReqInfo.reqSer}', 'lectSust':$("#lectSust").val()};
        $.ajax({
            url: mentor.contextpath + '/myPage/myLecture/cancelReqLectInfo.do',
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                if(rtnData.success){
                    alert(rtnData.data);
                }else{
                    alert(rtnData.message);
                }
                $(".layer-pop-wrap").find(".layer-close").trigger('click');
                mentor.myLecutreList.getList({'listType':mentor.activeTab});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    }

</script>