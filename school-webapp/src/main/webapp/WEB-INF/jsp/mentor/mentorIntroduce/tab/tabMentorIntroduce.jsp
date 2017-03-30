<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 멘토 소개 -->
<div class="introduce-wrap tab-cont active">
    <h3>멘토소개</h3>
    <div class="introduce-info" id="introduce" style="display:none;">
        <p>라미컬러리스트의 대표이자 컬러리스트로서, 컬러리스트는 색채와 관련된 자료를 수집, 분석하여 물건과 환경의 여러 가지 용도와 목적에 맞는 색채를 기획, 적용하며 활동 중이다. 현재까지, 대학, 방송, 기관 등에서 컬러와 관련된 강의를 진행하였으며, 존박, 레이디스코드, 프라이머리 등 연예인의 뮤직비디오 색채구성에 조언을 주며 활발하게 활동 중.</p>
    </div>
    <div class="career" style="display:none;">
        <h4 class="stit-dot-type">관련정보</h4>
        <ul>
            <li id="liAbility" style="display:none;">
                <em>- 학력</em>
                <ul id="ability">
                    <li>순천사범학교 졸업  </li>
                    <li>OOOOOOO  졸업</li>
                </ul>
            </li>
            <li id="liCareer" style="display:none;">
                <em>- 경력</em>
                <ul id="career">
                    <li>前 전남상서서초등학교 교사</li>
                    <li>前 한국 소믈리에 협회 초대 회장 </li>
                    <li>現 한국와인협회 회장</li>
                    <li>現 와인교육기관 'The Wine Academy' 원장</li>
                </ul>
            </li>
            <li id="liAwarded" style="display:none;">
                <em>- 수상</em>
                <ul id="awarded">
                    <li></li>
                </ul>
            </li>
            <li id="liBook" style="display:none;">
                <em>- 저서</em>
                <ul id="book">
                    <li></li>
                </ul>
            </li>
        </ul>
    </div>
</div>
<!-- //멘토 소개 -->

<script type="text/javascript">
    $(document).ready(function(){
        fn_mentorIntroduce();
    });

    // 멘토소개 조회
    function fn_mentorIntroduce(){
        $.ajax({
            url: '${pageContext.request.contextPath}/mentor/mentorIntroduce/ajax.mentorIntroduce.do',
            data : {'mbrNo' : '${param.mbrNo}'},
            dataType: 'json',
            success: function(rtnData) {
                // 관련정보가 하나라도 있다면..
                if(rtnData.profSchCarInfo != null || rtnData.profCareerInfo != null || rtnData.profAwardInfo != null || rtnData.profBookInfo != null){
                    $('.career').css('display','');
                }

                rtnData.profIntdcInfo != null ? $('#introduce').css('display', '') : '';
                rtnData.profSchCarInfo != null ? $('#liAbility').css('display', '') : '';
                rtnData.profCareerInfo != null ? $('#liCareer').css('display', '') : '';
                rtnData.profAwardInfo != null ? $('#liAward').css('display', '') : '';
                rtnData.profBookInfo != null ? $('#liBook').css('display', '') : '';


                $('#introduce').html(String(rtnData.profIntdcInfo).replaceAll('\n', '<br>'));
                $('#ability').html(String(rtnData.profSchCarInfo).replaceAll('\n', '<br>'));
                $('#career').html(String(rtnData.profCareerInfo).replaceAll('\n', '<br>'));
                $('#awarded').html(String(rtnData.profAwardInfo).replaceAll('\n', '<br>'));
                $('#book').html(String(rtnData.profBookInfo).replaceAll('\n', '<br>'));
            }
        });
    }
</script>