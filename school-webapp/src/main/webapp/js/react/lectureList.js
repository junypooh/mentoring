/**
 * Created by song on 2015-10-07.
 */
//Lecture
var Lecture = React.createClass({displayName: "Lecture",
    propTypes: {
        lectTitle:    React.PropTypes.string,
        lectrNm:      React.PropTypes.string,
        startTime:    React.PropTypes.string,
        endTime:      React.PropTypes.string,
        lectRunTime:  React.PropTypes.string,
        desc:         React.PropTypes.string,
        lectTargtCd:  React.PropTypes.string,
        imgPath:      React.PropTypes.string,
        lectSer:      React.PropTypes.number,
        lectTims:     React.PropTypes.number,
        schdSeq:      React.PropTypes.number,
        lectStatCdNm: React.PropTypes.string,
        lectStatCd  : React.PropTypes.string,
        lectTypeCd:   React.PropTypes.string,
        lectTypeCdNm: React.PropTypes.string,
        lectIntdcInfo:React.PropTypes.string,
        lectrJobNm:   React.PropTypes.string
    },
    goLectureView: function(lectSer, lectTims, schdSeq) {
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq;
        $(location).attr('href', url);
    },
    defaultImgPath: function(imtPath) {
        //수업요청 default 이미지
        imtPath.target.src = mentor.contextpath + "/images/lesson/img_epilogue_default.gif";
    },
    render:function(){
        var ratings = [];
        var lectTypeTag = [];
        var lectTargtCd = this.props.lectTargtCd;
        var lectStatCd = this.props.lectStatCd;
        var lectTypeCd = this.props.lectTypeCd;


        if(true){
            ratings.push();
        }

        if(lectTargtCd == "101534"){
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
        }else if(lectTargtCd == "101535"){
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
        }else if(lectTargtCd == "101536"){
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        }else if(lectTargtCd == "101537"){
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
        }else if(lectTargtCd == "101538"){
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        }else if(lectTargtCd == "101539"){
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        }else if(lectTargtCd == "101540"){
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        }else if(lectTargtCd == "101713"){
            ratings.push(React.createElement("span", {className: "icon-rating etc"}, "기타"));
        }

        var lectStatClass = "icon-lesson";

        if(this.props.lectStatCdNm == "정원마감"){
            lectStatClass = lectStatClass + " red"
        }
        else if(lectStatCd == "101543"){
            lectStatClass = lectStatClass + " orange"
        }else if(lectStatCd == "101548"){
            lectStatClass = lectStatClass + " yellow"
        }else if(lectStatCd == "101549" || lectStatCd == "101550"){
             lectStatClass = lectStatClass + " skyblue"
        }

        return (
            React.createElement("li", null, 
                React.createElement("a", {href: "javascript:void(0);", onClick: this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}, 
                    React.createElement("dl", {className: "lesson-info"}, 
                        React.createElement("dt", {className: "mento"}, React.createElement("strong", null, this.props.lectrNm), React.createElement("em", null, this.props.lectrJobNm, "  ")), 
                        React.createElement("dd", {className: "rating"}, 
                            React.createElement("span", {className: "ico-ls-type"}, this.props.lectTypeCdNm), 
                            ratings
                        ), 
                        React.createElement("dd", {className: "date-time"}, 
                            React.createElement("span", {className: "date"}, this.props.date), React.createElement("span", {className: "time"}, this.props.startTime, "~", this.props.endTime, "(", this.props.lectRunTime, "분)")
                        ), 
                        React.createElement("dd", {className: "title"}, 
                            React.createElement("span", {className: lectStatClass}, this.props.lectStatCdNm), 
                        React.createElement("span", null, this.props.lectTitle)), 
                        React.createElement("dd", {className: "info"}, React.createElement("p", null, this.props.lectIntdcInfo)), 
                        React.createElement("dd", {className: "image"}, React.createElement("img", {src: mentor.contextpath + "/fileDown.do?fileSer="+ this.props.imgPath, alt: this.props.lectTitle, onError: this.defaultImgPath}))
                    )
                )
            )
        );
    }
});
var LectureList = React.createClass({displayName: "LectureList",
    render:function(){
        var lecList = this.props.data.map(function(lecData, index) {
            return (
                React.createElement(Lecture, {lectTitle: lecData.lectTimsInfo.lectInfo.lectTitle, 
                         lectrNm: lecData.lectTimsInfo.lectInfo.lectrNm, 
                         date: to_date_format(lecData.lectDay, "-"), 
                         startTime: to_time_format(lecData.lectStartTime, ":"), 
                         endTime: to_time_format(lecData.lectEndTime,":"), 
                         lectRunTime: lecData.lectRunTime, 
                         desc: lecData.lectTimsInfo.lectInfo.lectOutlnInfo, 
                         lectTargtCd: lecData.lectTimsInfo.lectInfo.lectTargtCd, 
                         imgPath: lecData.lectTimsInfo.lectInfo.lectPicPath, 
                         lectSer: lecData.lectTimsInfo.lectSer, 
                         lectTims: lecData.lectTimsInfo.lectTims, 
                         schdSeq: lecData.schdSeq, 
                         lectStatCdNm: lecData.lectStatCdNm, 
                         lectStatCd: lecData.lectStatCd, 
                         lectTypeCd: lecData.lectTimsInfo.lectInfo.lectTypeCd, 
                         lectTypeCdNm: lecData.lectTimsInfo.lectInfo.lectTypeCdNm, 
                         lectIntdcInfo: lecData.lectTimsInfo.lectInfo.lectIntdcInfo, 
                         lectrJobNm: lecData.lectTimsInfo.lectInfo.lectrJobNm === null ? '' :lecData.lectTimsInfo.lectInfo.lectrJobNm}
                )
            );
        });
        return (
            React.createElement("ul", null, 
                lecList
            )
        );
    }
});
var LectureTabView = React.createClass({displayName: "LectureTabView",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0, 'currentPageNo':1, 'recordCountPerPage':9};
    },
    componentDidMount: function() {
        this.getList({'listType':mentor.activeTab, 'isMore' :false, 'params' : dataSet.params});
    },
    getList: function(param) {

        var lectStatCd = "";
        var orderBy = "desc";

        if(param.listType == "1"){  //수강모집
            lectStatCd = "101543";
            orderBy = "asc";
        }else if(param.listType == "2"){ //수업예정
            lectStatCd ="101548";
            orderBy = "asc";
        }else if(param.listType == "3"){  //수업대기
            lectStatCd ="101549";
            orderBy = "asc";
        }else if(param.listType == "4"){  //수업중
            lectStatCd ="101552";
            orderBy = "asc";
        }

        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,
            'recordCountPerPage':9,
            'schoolGrd':$("#lectTargtCd").val(),
            'schoolEtcGrd': $('input[name=schoolEtcGrd]:checked').val(),
            'searchStDate':$("#searchStDate").val(),
            'searchEndDate':$("#searchEndDate").val(),
            'grpNo' : $("#grpNo").val(),
            'lectTime':$("#lectTime").val(),
            'lectType':$("#lectType").val(),
            'jobChrstcList' :param.params.jobChrstcList,
            'jobNo': param.params.lectrJob,
            'lectStatCd':lectStatCd,
            'orderBy':orderBy,
            'listType': param.listType,
            'consonantsVal' : param.params.consonantsVal,
            'searchKey':$("#searchKey").val(),
            'searchType':$("#seachType option:selected").val()},param);

        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            traditional: true,
            success: function(rtnData) {
                if((dataSet.params.jobChrstcList !=null && dataSet.params.lectrJob !="")|| (dataSet.params.lectrJob !=null && dataSet.params.jobChrstcList !="")){
                    if($("p.result-total").parent().hasClass("result-total")){
                        $("p.result-total").parent().removeClass("result-total").addClass("result-total-wrap");
                    }
                    if(rtnData.length>0){
                        this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount,'currentPageNo':this.state.currentPageNo + 1});
                        $("p.result-total").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ");
                    }else{
                        $("p.result-total").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ");
                    }

                    $('.result-total-wrap')
                        .find('.result-class').empty()
                        .append(function() {
                            var ls = [];
                            // 특징 분류
                            $.each(dataSet.params.jobChrstcList, function(i, v) {
                                var el = $('#chrstcClsfSelector label:has(:checkbox[value=' + v + '])');
                                if (!el.length) {
                                    return;
                                }
                                ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                            });

                            // 직업 분류
                            if (dataSet.params.lectrJob) {
                                var el = $('#jobClsfSelector label:has(:radio[value=' + dataSet.params.lectrJob + '])');
                                if (el.length) {
                                    ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                                }
                            }
                            return ls;
                        }).end()
                        .css({visibility: 'visible'});
                }else{
                    $('.result-total-wrap')
                        .find('.result-class').empty();

                    if($("p.result-total").parent().hasClass("result-total-wrap")){

                        $("p.result-total").parent().removeClass("result-total-wrap").addClass("result-total");
                    }
                    if(rtnData.length>0){
                        this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount,'currentPageNo':this.state.currentPageNo + 1});
                        $("p.result-total").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ").css({visibility: 'visible'});
                    }else{
                        $("p.result-total").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ").css({visibility: 'visible'});
                    }
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        return (
            React.createElement("div", null, 
                React.createElement("h3", {className: "invisible"}, "전체 검색 내용"), 
                React.createElement("div", {className: "search-list-type"}, 
                    React.createElement(LectureList, {data: this.state.data})
                ), 
                React.createElement("div", {className: "btn-paging"}, 
                    React.createElement(PageNavi, {url: this.props.url, pageFunc: goPage, totalRecordCount: this.state.totalRecordCount, pageSize: 5, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
                ), 
                React.createElement("a", {href: "#lessonTab02", className: "btn-focus-move"}, "수강모집 메뉴로 이동")
            )
        );
    }
});

// 수업전체 웹버전
var LectureTabViewWeb = React.createClass({displayName: "LectureTabViewWeb",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0, 'currentPageNo':1, 'recordCountPerPage':9};
    },
    componentDidMount: function() {
        this.getList({'listType':mentor.activeTab, 'params' : dataSet.params});
    },
    getList: function(param) {

        var lectStatCd = "";
        var orderBy = "desc";

        if(param.listType == "1"){  //수강모집
            lectStatCd = "101543";
            orderBy = "asc";
        }else if(param.listType == "2"){ //수업예정
            lectStatCd ="101548";
            orderBy = "asc";
        }else if(param.listType == "3"){  //수업대기
            lectStatCd ="101549";
            orderBy = "asc";
        }else if(param.listType == "4"){  //수업중
            lectStatCd ="101551";
            orderBy = "desc";
        }

        var _param = jQuery.extend({
            'currentPageNo':1,
            'recordCountPerPage':9,
            'schoolGrd':$("#lectTargtCd").val(),
            'schoolEtcGrd' : $('input[name=schoolEtcGrd]:checked').val(),
            'searchStDate':$("#searchStDate").val(),
            'searchEndDate':$("#searchEndDate").val(),
            'grpNo' : $("#grpNo").val(),
            'lectTime':$("#lectTime").val(),
            'lectType':$("#lectType").val(),
            'jobChrstcList' :param.params.jobChrstcList,
            'jobNo': param.params.lectrJob,
            'lectStatCd':lectStatCd,
            'orderBy':orderBy,
            'listType': param.listType,
            'consonantsVal' : param.params.consonantsVal,
            'searchKey':$("#searchKey").val(),
            'searchType':$("#seachType option:selected").val()},param);
        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            traditional: true,
            success: function(rtnData) {
                var totalCnt = 0;

                if((dataSet.params.jobChrstcList !=null && dataSet.params.lectrJob !="")|| (dataSet.params.lectrJob !=null && dataSet.params.jobChrstcList !="")){
                    if($("p.result-total").parent().hasClass("result-total")){
                        $("p.result-total").parent().removeClass("result-total").addClass("result-total-wrap");
                    }
                    if(rtnData.length>0){
                        this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount,'currentPageNo':this.state.currentPageNo + 1});
                        $("p.result-total").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ");
                        totalCnt = rtnData[0].totalRecordCount;
                    }else{
                        $("p.result-total").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ");
                    }

                    $('.result-total-wrap')
                        .find('.result-class').empty()
                        .append(function() {
                            var ls = [];
                            // 특징 분류
                            $.each(dataSet.params.jobChrstcList, function(i, v) {
                                var el = $('#chrstcClsfSelector label:has(:checkbox[value=' + v + '])');
                                if (!el.length) {
                                    return;
                                }
                                ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                            });

                            // 직업 분류
                            if (dataSet.params.lectrJob) {
                                var el = $('#jobClsfSelector label:has(:radio[value=' + dataSet.params.lectrJob + '])');
                                if (el.length) {
                                    ls.push($('<a href="#">' + el.find('.job-wrap').text() + '</a>'));
                                }
                            }
                            return ls;
                        }).end()
                        .css({visibility: 'visible'});
                }else{
                    $('.result-total-wrap')
                        .find('.result-class').empty();

                    if($("p.result-total").parent().hasClass("result-total-wrap")){

                        $("p.result-total").parent().removeClass("result-total-wrap").addClass("result-total");
                    }
                    if(rtnData.length>0){
                        this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount,'currentPageNo':this.state.currentPageNo + 1});
                        $("p.result-total").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ").css({visibility: 'visible'});
                        totalCnt = rtnData[0].totalRecordCount;
                    }else{
                        $("p.result-total").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ").css({visibility: 'visible'});
                    }
                }
                var pageSize = 10;
                if(mentor.isMobile){
                    pageSize = 5;
                }

                this.setState({data: rtnData,'pageSize':pageSize, 'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        return (
            React.createElement("div", null, 
                React.createElement("h3", {className: "invisible"}, "전체 검색 내용"), 
                React.createElement("div", {className: "search-list-type"}, 
                    React.createElement(LectureList, {data: this.state.data})
                ), 
                React.createElement("div", {className: "btn-paging"}, 
                    React.createElement(PageNavi, {url: this.props.url, pageFunc: goPage, pageSize: this.state.pageSize, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
                ), 
                React.createElement("a", {href: "#lessonTab02", className: "btn-focus-move"}, "수강모집 메뉴로 이동")
            )
        );
    }

});

//Lecture