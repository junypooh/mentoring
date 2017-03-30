<%--
  Created by IntelliJ IDEA.
  User: song
  Date: 2015-10-12
  Time: 오후 2:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/jsx;harmony=true" src="${pageContext.request.contextPath}/js/react/popupJobSearch.js"></script>
<div class="layer-pop">
    <div class="layer-header">
        <strong class="title">직업찾기</strong>
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
                <input type="search" class="inp-style" id="searchKey"/>
                <a href="#" class="job-search" onClick="searchList()">직업찾기</a>
            </div>
        </div>
        <div class="result-info">
            <p class="search-result">검색 결과<strong>총<em>00</em>건</strong></p>
        </div>
        <div class="lesson-search-list box-scroll-wrap" id="jobSearch">

        </div>
        <div class="btn-area popup">
            <a href="#" class="btn-type2 popup" onclick="selectMentor();">확인</a>
            <a href="#" class="btn-type2 cancel" onclick="window.close()">취소</a>
        </div>
    </div>
    <a href="#" class="layer-close" onclick="window.close()">팝업 창 닫기</a>
</div>
<script type="text/jsx;harmony=true">
mentor.jobSearch = React.render(
  <JobSearchView url='${pageContext.request.contextPath}/lecture/lectureTotal/jobDetailSearch.do'/>,
  document.getElementById('jobSearch')
);
</script>
<script type="text/javascript">

    $(document).ready(function(){
        $('#searchKey').keydown(function(e) {
            if (e.which == 13) {/* 13 == enter key@ascii */
                searchList();
            }
        });
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
        mentor.jobSearch.getList();
    }
    mentor._callbackTabClick = function(){
        searchList();
    }

    function selectMentor(){

        var radioVal = $(':radio[name="jobRadio"]:checked').val();
        if($(':radio[name="jobRadio"]:checked').length == 0){
            alert("선택된 직업이 없습니다.")
            return false;
        }

        $("#targtJobNo",opener.document).val(radioVal);
        $("#targtJobNm",opener.document).text($(':radio[name="jobRadio"]:checked').parent().find(".job-subject").text());
        window.close();
    }

</script>