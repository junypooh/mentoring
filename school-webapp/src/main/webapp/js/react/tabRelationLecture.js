/**
 * 수업상세화면 관련수업 탭
 */

var TabRelationLectureListView = React.createClass({displayName: "TabRelationLectureListView",
    getInitialState: function () {
        return {'data': [], 'totalRecordCount': 0, 'currentPageNo': 1, 'recordCountPerPage':5};
    },
    componentDidMount: function () {
        this.getList();
    },
    goPage:function(pageNo) {
        var param = {currentPageNo : pageNo};
        this.getList(param);
    },
    getList: function (param) {
        var _param = jQuery.extend({
            'currentPageNo': this.state.currentPageNo,
            'recordCountPerPage': 5,
            'lectSer': $("#lectSer").val(),
            'lectTims': $("#lectTims").val(),
            'schdSeq': $("#schdSeq").val()
        }, param);
        $.ajax({
            url: this.props.url,
            data: _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function (rtnData) {
                if (rtnData.length > 0) {
                    this.setState({data: rtnData,'totalRecordCount': rtnData[0].totalRecordCount, currentPageNo: _param.currentPageNo}, function(){connectionLesson();});

                } else {

                }
            }.bind(this),
            error: function (xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render: function () {


        return (
            React.createElement("div", {className: "lesson-connection"}, 
                React.createElement("h3", null, "관련수업"), 
                React.createElement(TabRelationLectureList, {data: this.state.data}), 

                React.createElement("div", {className: "paging-btn"}, 
                  React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, pageSize: 10, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: 5, contextPath: mentor.contextpath})
                )

            )
        );
    }
});

var TabRelationLectureList = React.createClass({displayName: "TabRelationLectureList",
    render: function () {
        var lecList = this.props.data.map(function (lecData, index) {
            return (
                React.createElement(TabRelationLecture, {lectTitle: lecData.lectTitle, 
                                    lectStatCdNm: lecData.lectStatCdNm, 
                                    lectTargtCd: lecData.lectTargtCd, 
                                    lectrNm: lecData.lectrNm, 
                                    lectDay: to_date_format(lecData.lectDay, "-"), 
                                    lectStartTime: to_time_format(lecData.lectStartTime, ":"), 
                                    lectEndTime: to_time_format(lecData.lectEndTime,":"), 
                                    cntntsId: lecData.cntntsId, 
                                    arclSer: lecData.arclSer, 
                                    lectIntdcInfo: lecData.lectIntdcInfo, 
                                    lectSer: lecData.lectSer, 
                                    lectTims: lecData.lectTims, 
                                    schdSeq: lecData.schdSeq})
            );
        });
        return (
            React.createElement("ul", null, 
                lecList
            )
        );
    }
});

var TabRelationLecture = React.createClass({displayName: "TabRelationLecture",
    propTypes: {
        lectTitle: React.PropTypes.string, //수업제목
        lectStatCdNm: React.PropTypes.string, //수업상태코드명
        lectTargtCd: React.PropTypes.string, //수업대상코드
        lectrNm: React.PropTypes.string, //수업강사명(멘토명)
        lectDay: React.PropTypes.string, //수업일
        lectStartTime: React.PropTypes.string, //수업시작시간
        lectEndTime: React.PropTypes.string, //수업종료시간
        cntntsId: React.PropTypes.string, //동영상 컨텐츠ID
        arclSer: React.PropTypes.string,
        lectIntdcInfo: React.PropTypes.string, //수업소개글
        lectSer: React.PropTypes.number, //수업일련번호
        lectTims: React.PropTypes.number, //수업차수번호
        schdSeq: React.PropTypes.number  //수업일정순서
    },
    //수업상세화면
    goLectureView: function (lectSer, lectTims, schdSeq) {
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer=" + lectSer + "&lectTims=" + lectTims + "&schdSeq=" + schdSeq;
        $(location).attr('href', url);
//        window.open(url, "_blank");
    },
    //동영상다시보기 상세화면
    goLectureReplay: function (arclSer, cntntsId) {
        var url = mentor.contextpath + "/lecture/lectureReplay/lectureReplyView.do?arclSer="+arclSer+"&cId=" + cntntsId;
        $(location).attr('href', url);
    },
    render: function () {
        var ratings = [];
        var lectTargtCd = this.props.lectTargtCd;

        if (lectTargtCd == "101534") {
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
        } else if (lectTargtCd == "101535") {
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
        } else if (lectTargtCd == "101536") {
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        } else if (lectTargtCd == "101537") {
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
        } else if (lectTargtCd == "101538") {
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        } else if (lectTargtCd == "101539") {
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        } else if (lectTargtCd == "101540") {
            ratings.push(React.createElement("span", {className: "icon-rating elementary"}, "초"));
            ratings.push(React.createElement("span", {className: "icon-rating middle"}, "중"));
            ratings.push(React.createElement("span", {className: "icon-rating high"}, "고"));
        }

        var rePlay = "";
        if (this.props.cntntsId && this.props.arclSer) {
            rePlay = React.createElement("a", {href: "javascript:void(0);", onClick: this.goLectureReplay.bind(this, this.props.arclSer, this.props.cntntsId), className: "video"}, "동영상보기");
        }


        return (
            React.createElement("li", null, 
                React.createElement("div", {className: "title"}, 
                    React.createElement("span", {className: "tit"}, React.createElement("a", {href: "javascript:void(0);", onClick: this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}, this.props.lectTitle)), 
                    React.createElement("em", null, this.props.lectStatCdNm), 
                    rePlay, 
					React.createElement("span", {className: "r-align"}, 
                        ratings
					)
                ), 
                React.createElement("div", {className: "date"}, 
                    React.createElement("span", {className: "user mentor"}, this.props.lectrNm), 

                    React.createElement("p", null, this.props.lectDay, " ", React.createElement("span", {className: "t-mobile-blind"}, "/"), " ", React.createElement("strong", null, this.props.lectStartTime, "~", this.props.lectEndTime))
                ), 
                React.createElement("p", null, 
                    React.createElement("a", {href: "javascript:void(0)", className: "view"}, "수업소개보기"), 
                    React.createElement("span", null, this.props.lectIntdcInfo)
                )
            )
        );
    }
});