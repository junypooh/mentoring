<%--
  Created by IntelliJ IDEA.
  User: song
  Date: 2015-10-12
  Time: 오후 2:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/react/popupMentorSearch.js"></script>
<div class="layer-pop">
    <div class="layer-header">
        <strong class="title">멘토찾기</strong>
    </div>
    <div class="layer-cont">
        <div class="mentor-search">
            <div class="mentor-search-area">
                <select class="slt-style" title="전체" id="seachType">
                    <option value="all">전체</option>
                    <option value="lectTitle">수업</option>
                    <option value="mentorNm">멘토</option>
                    <option value="jobTagInfo">태그</option>
                    <option value="jobNm">직업</option>
                </select>
                <input type="search" class="inp-style" id="searchKey" value="${param.jobNm}"/>
                <a href="#" class="job-search" onClick="searchList()">멘토찾기</a>
            </div>
        </div>
        <div class="result-info">
            <p class="search-result">검색 결과<strong>총<em>00</em>건</strong></p>
        </div>
        <div class="lesson-search-list box-scroll-wrap" id="mentorSearch">

        </div>
        <div class="btn-area popup">
            <a href="#" class="btn-type2 popup" onclick="selectMentor();">확인</a>
            <a href="#" class="btn-type2 cancel" onclick="window.close()">취소</a>
        </div>
    </div>
    <a href="#" class="layer-close" onclick="window.close()">팝업 창 닫기</a>
</div>
<script type="text/javascript">
mentor.mentorSearch = React.render(
  React.createElement(MentorSearchView, {url:'${pageContext.request.contextPath}/lecture/lectureTotal/mentorjobSearch.do'}),
  document.getElementById('mentorSearch')
);
</script>
<script type="text/javascript">

    $(document).ready(function(){
        $('#searchKey').keydown(function(e) {
            if (e.which == 13) {/* 13 == enter key@ascii */
                searchList();
            }
        });
        if($('#searchKey').val() !=""){
            searchList();
        }
    });

    function searchList(){
        if($('#searchKey').val() ==""){
            alert("키워드를 입력하세요.");
            return false;
        }

        if($('#searchKey').val().length < 2){
            alert("두 글자 이상 입력하세요.");
            return false;
        }
        mentor.mentorSearch.getList();
    }
    mentor._callbackTabClick = function(){
        searchList();
    }

    function selectMentor(){

        var radioVal = $(':radio[name="mentorRadio"]:checked').val();
        if($(':radio[name="mentorRadio"]:checked').length == 0){
            alert("선택된 멘토가 없습니다.");
            return false;
        }
        $("#targtMbrNo",opener.document).val(radioVal);
        $("#targtMentorNm",opener.document).text($(':radio[name="mentorRadio"]:checked').parent().find(".mento").text());
        window.close();
    }

</script>