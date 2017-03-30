<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cnet" uri="http://www.career.or.kr/taglib/cnet" %>
<cnet:loadConstants var="code" className="kr.or.career.mentor.constant.CodeConstants" />

<div class="cont">
    <div class="title-bar">
        <h2>평점조회</h2>
        <ul class="location">
            <li class="home">Home</li>
            <li>수업관리</li>
            <li>수업정보관리</li>
            <li>평점조회</li>
        </ul>
    </div>
    <div class="board-area" id="boardArea">
        <div class="tab-bar">
            <ul>
                <li class="on"><a href="javascript:void(0);" onClick="tabChg(0);">수업별</a></li><!-- 활성화 시 on 클래스 추가 -->
                <li><a href="javascript:void(0);" onClick="tabChg(1);">멘토별</a></li>
            </ul>
        </div>
        <div class="tab-cont"> <!-- Tab 클릭 시 보이는 컨텐츠 -->
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
        tabChg(0);
    });

    function tabChg(number){
        $('.tab-bar > ul > li').each(function(){
            $(this).removeClass('on');
        });
        $('.tab-bar > ul > li').eq(number).addClass('on');

        switch (number) {
            case 0 :
                $('.tab-cont').load('${pageContext.request.contextPath}/lecture/status/rating/tabLectureList.do');
                break;
            case 1  :
                $('.tab-cont').load('${pageContext.request.contextPath}/lecture/status/rating/tabMentorList.do');
                break;
        }
    }
</script>