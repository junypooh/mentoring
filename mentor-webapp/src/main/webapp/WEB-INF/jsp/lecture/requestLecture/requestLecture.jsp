<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Template ================================================================================ --%>
<script type="text/html" id="listInfo">
<li>
    <div class="title">
        <a href="#" id="req_\${reqSer}">
            <span class="num">\${fn_getNo(rn)}</span>
            <em class="title">\${lectTitle}</em>
            <span class="file-mb">\${fn_getFormatDate(reqDtm)}</span>
        </a>
    </div>
    <div class="file-list">
        <div class="board-type2 request">
            <table>
                <caption>요청수업 - 요청유형, 학교급, 교사, 학교, 직업, 멘토, 희망일시, 내용</caption>
                <colgroup>
                    <col style="width:93px;"/>
                    <col/>
                    <col style="width:93px;"/>
                    <col/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row">요청유형</th>
                    <td>\${lectureRequestType}</td>
                    <th scope="row">학교급</th>
                    <td>\${schClassCdNm}</td>
                </tr>
                <tr>
                    <th scope="row">교사</th>
                    <td>\${reqMbrNm}{{if solCoTel != null}} / \${solCoTel}{{/if}}</td>
                    <th scope="row">학교</th>
                    <td>\${schNm}</td>
                </tr>
                <tr>
                    <th scope="row">직업</th>
                    <td>\${targtJobNm}</td>
                    <th scope="row">멘토</th>
                    <td>\${targtMbrNm}</td>
                </tr>
                <tr>
                    <th scope="row">희망일시</th>
                    <td colspan="3">
                        <ul class="hope-day">
                            {{each lectReqTimeInfoDomain}}
                            <li>
                                <span class="day">\${to_date_format(lectPrefDay, "-")}</span>
                                <span class="time">\${to_time_format(lectPrefTime, ":")}</span>
                            </li>
                            {{/each}}
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th scope="row">내용</th>
                    <td colspan="3">\${lectSust}</td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="btn-area r-align request">
            <a href="#" class="btn-type4 modify" onclick="fn_goLectureInfoInsert('\${reqSer}', '\${lectTitle}')">개설</a>
        </div>
    </div>
</li>
</script>
<%-- Template ================================================================================ --%>

<div id="container">
    <div class="location">
        <a href="${pageContext.request.contextPath}/" class="home">메인으로 이동</a>
        <span>수업관리</span>
        <span>요청수업</span>
    </div>
    <div class="content">
        <h2 class="">요청수업</h2>

        <div class="cont type3">

            <div class="tab-action">
                <ul class="sub-tab tab05">
                    <li class="active"><a href="javascript:void(0)" id="aTotalTab" name="total">전체</a></li>
                    <li><a href="javascript:void(0)" id="aOpenTab" name="open">오픈</a></li>
                    <li><a href="javascript:void(0)" id="aJobTab" name="job">직업지정</a></li>
                    <li><a href="javascript:void(0)" id="aMentorTab" name="mentor">멘토지정</a></li>
                    <li><a href="javascript:void(0)" id="aSolutionTab" name="solution">솔루션지정</a></li>
                </ul>

                <div class="tab-action-cont">

                    <div class="tab-cont active">
                        <div class="tit-wrap">
                            <span class="right">
                                <select style="width:68px;" id="recordCountPerPage">
                                    <option value="10">10</option>
                                    <option value="20">20</option>
                                    <option value="30">30</option>
                                    <option value="50">50</option>
                                </select>
                            </span>
                        </div>
                        <div class="lesson-task data">
                            <ul class="lesson-data-list detail">

                            </ul>
                        </div>
                        <div class="paging" id="divPaging">
                        </div>
                        <fieldset class="list-search-area">
                            <legend>검색</legend>
                            <select id="category">
                                <option value="titlePlusContents">제목+내용</option>
                                <option value="title">제목</option>
                                <option value="writer">작성자</option>
                            </select>
                            <input type="search" class="inp-style1" id="keyword"/>
                            <a href="#" class="btn-search" id="aSearch"><span>검색</span></a>
                        </fieldset>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="cont-quick"><a href="#header"><img src="${pageContext.request.contextPath}/images/common/img_quick.png" alt="상단으로 이동"/></a></div>
</div>

<script type="text/jsx;harmony=true">
mentor.PageNavi = React.render(
    <PageNavi url={mentor.contextpath + "/lecture/requestLecture/ajax.listRequestLecture.do"} pageFunc={fn_search} totalRecordCount={0} currentPageNo={1} recordCountPerPage={10} contextPath={'${pageContext.request.contextPath}'}/>,
    document.getElementById('divPaging')
);
</script>

<script type="text/javascript">
    var dataSet = {
        params: {
            recordCountPerPage: $("#recordCountPerPage option:selected").val(),
            totalRecordCount: 0,
            currentPageNo: 1,
            lectureRequestType:"total",
            category:"",
            keyword: ""
        },
        data: {}
    };
    mentor.mentorDataSet = dataSet;

    //탭페이지 전체 클릭
    $("#aTotalTab").click(function(){
        dataSet.params.lectureRequestType = "total";
        $("#aSearch").click();
    });

    //탭페이지 오픈 클릭
    $("#aOpenTab").click(function(){
        dataSet.params.lectureRequestType = "open";
        $("#aSearch").click();
    });

    //탭페이지 직업지정 클릭
    $("#aJobTab").click(function(){
        dataSet.params.lectureRequestType = "job";
        $("#aSearch").click();
    });

    //탭페이지 멘토지정 클릭
    $("#aMentorTab").click(function(){
        dataSet.params.lectureRequestType = "mentor";
        $("#aSearch").click();
    });

    //탭페이지 솔루션지정 클릭
    $("#aSolutionTab").click(function(){
        dataSet.params.lectureRequestType = "solution";
        $("#aSearch").click();
    });

    //한페이지당 보여주는 건수 변경시
    $("#recordCountPerPage").change(function(){
        dataSet.params.recordCountPerPage = this.value;
        dataSet.params.lectureRequestType = $(".tab-action .sub-tab.tab05 li.active a").attr("name");
        $("#aSearch").click();
    });

    //조회
    var fn_search = function(pageNum, openReqSer){
        dataSet.params.currentPageNo = pageNum;

        $.ajax({
            url: "${pageContext.request.contextPath}/lecture/requestLecture/ajax.listRequestLecture.do",
            data : $.param(dataSet.params, true),
            success: function(rtnData) {

                dataSet.data = rtnData;

                if(rtnData != null && rtnData.length > 0){
                    dataSet.params.totalRecordCount = rtnData[0].totalRecordCount;
                }else{
                    dataSet.params.currentPageNo = 1;
                    dataSet.params.totalRecordCount = 0;
                }

                mentor.PageNavi.setData(dataSet.params);

                $(".lesson-data-list").empty();
                $("#listInfo").tmpl(dataSet.data).appendTo(".lesson-data-list");
                detailTab();

                if(dataSet.params.lectureRequestType == "solution") {
                    $(".btn-area.r-align.request").hide();
                }else{
                    $(".btn-area.r-align.request").show();
                }

                if(!!openReqSer){
                    $("#req_"+openReqSer).click();
                }
            },
            error: function(jqXHR, textStatus, errorThrown){
            }
        });
    };

    //조회 버튼 클릭
    $("#aSearch").click(function(){
        dataSet.params.category = $("#category option:selected").val();
        dataSet.params.keyword = $("#keyword").val();

        mentor.PageNavi._pageFunc(1);
    });

    function fn_getFormatDate(source) {
        var value = new Date(source);
        return value.getFullYear() + "-" + String(value.getMonth() + 1).lpad('0', 2) + "-" + value.getDate();
    }

    function fn_goLectureInfoInsert(nReqSer, sLectTitle){
        var url = mentor.contextpath + "/lecture/lectureState/lectureInfoInsert.do?requestReqSer="+nReqSer+"&requestLectTitle="+sLectTitle;
        window.open(url, '_blank');
    }

    function fn_getNo(num){
        return dataSet.params.totalRecordCount - num + 1;
    }

    $(document).ready(function () {
        fn_search(1,"${param.reqSer}");
    });

</script>