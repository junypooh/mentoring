<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="layer-pop-wrap" id="layerAppInfo">
    <div class="layer-pop class">
        <div class="layer-header">
            <strong class="title">APP 다운로드 안내</strong>
        </div>
        <div class="layer-cont">
            <div class="app-down-info">
                <strong>모바일 어플리케이션(App) 다운로드 안내</strong>
                <div>
                    <p>온라인 멘토링 수업은 모바일 App에서 입장 가능합니다.</p>
                    <p>아래 ‘ App Store로 이동‘ 버튼을 눌러 App을 설치해주세요.</p>
                    <span class="btn"><a href="javascript:void(0)" class="btn-type2" id="aGoAppStore">APP Store 로 이동</a></span>
                </div>
            </div>
            <div class="btn-area popup">
                <a href="javascript:void(0)" class="btn-type2 popup">확인</a>
                <a href="javascript:void(0)" class="btn-type2 cancel">취소</a>
            </div>
            <a href="#" class="layer-close">팝업 창 닫기</a>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        //확인 버튼 클릭
        $(".btn-type2.popup").click(function(){
            $(".btn-type2.cancel").click();
        });

        //APP Store 로 이동
        $("#aGoAppStore").click(function () {
            //추후개발
        });
    });
</script>