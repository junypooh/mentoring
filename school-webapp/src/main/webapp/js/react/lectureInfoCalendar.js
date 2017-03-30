/**
 *  수업일정 react.js
 * Created by junypooh on 2016-05-20.
 */
 //CalendarLect
var CalendarLect = React.createClass({displayName: "CalendarLect",
    getInitialState: function() {
        return {'data':[], 'lectDay':'', 'eleCnt':0, 'midCnt':0, 'highCnt':0, 'schoolGrd':''}
    },
    componentDidMount: function() {
        this.getList({'searchStDate':this.props.lectDay, 'searchEndDate':this.props.lectDay
                        , 'eleCnt':this.props.eleCnt, 'midCnt':this.props.midCnt, 'highCnt':this.props.highCnt, 'schoolGrd':''});
    },
    filterSchoolGrd: function(schoolGrd) {
        var param = {'searchStDate':this.state.lectDay, 'searchEndDate':this.state.lectDay, 'eleCnt':this.state.eleCnt
                    , 'midCnt':this.state.midCnt, 'highCnt':this.state.highCnt, 'schoolGrd':schoolGrd};
        mentor.CalendarLectList.getList(param);
    },
    getList: function(param) {
        firstCall = true;
        var orderBy = "asc";
        var _param = jQuery.extend(
                            {'orderBy':orderBy}
                            , param);

        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                this.setState({'data': rtnData, 'lectDay':param.searchStDate, 'eleCnt':param.eleCnt, 'midCnt':param.midCnt, 'highCnt':param.highCnt, 'schoolGrd':param.schoolGrd});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){

        var sMonth = Number(this.state.lectDay.substring(4,6));
        var sDate = Number(this.state.lectDay.substring(6,8));

        var summary = [];
        if(this.state.eleCnt > 0) {
            summary.push(React.createElement("span", {className: "lecture-con lv1", title: "초등학교"}, "초"));
            summary.push(React.createElement("em", null, this.state.eleCnt, "건"));
        } else {
            summary.push(React.createElement("span", {className: "lecture-con lv1", title: "초등학교"}, "초"));
            summary.push(React.createElement("em", null, "0건"));
        }
        if(this.state.midCnt > 0) {
            summary.push(React.createElement("span", {className: "lecture-con lv2", title: "중학교"}, "중"));
            summary.push(React.createElement("em", null, this.state.midCnt, "건"));
        } else {
            summary.push(React.createElement("span", {className: "lecture-con lv2", title: "중학교"}, "중"));
            summary.push(React.createElement("em", null, "0건"));
        }
        if(this.state.highCnt > 0) {
            summary.push(React.createElement("span", {className: "lecture-con lv3", title: "고등학교"}, "고"));
            summary.push(React.createElement("em", null, this.state.highCnt, "건"));
        } else {
            summary.push(React.createElement("span", {className: "lecture-con lv3", title: "고등학교"}, "고"));
            summary.push(React.createElement("em", null, "0건"));
        }

        return (
            React.createElement("div", {className: "board-list-type"}, 
                React.createElement("div", {className: "board-list-title"}, 
                    React.createElement("ul", {className: "sch-list-tab"}, 
                        React.createElement("li", {className: this.state.schoolGrd == '' ? "on" : ""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.filterSchoolGrd.bind(this, '')}, "전체")), 
                        React.createElement("li", {className: this.state.schoolGrd == '101534' ? "on" : ""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.filterSchoolGrd.bind(this, '101534')}, "초등학교")), 
                        React.createElement("li", {className: this.state.schoolGrd == '101535' ? "on" : ""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.filterSchoolGrd.bind(this, '101535')}, "중학교")), 
                        React.createElement("li", {className: this.state.schoolGrd == '101536' ? "on" : ""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.filterSchoolGrd.bind(this, '101536')}, "고등학교"))
                    ), 
                    React.createElement("div", {className: "sch-count"}, React.createElement("strong", null, sMonth, "월", sDate, "일"), " 수업목록 : ", summary)
                ), 
                React.createElement("table", {className: "sch-list"}, 
                    React.createElement("caption", null, "학교 테이블정보 - 번호, 수업시작(소요시간), 학교급, 직업분류, 직업명, 멘토, 수업명, 상태"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", {style: {'width':'5%'}}), 
                        React.createElement("col", {style: {'width':'15%'}}), 
                        React.createElement("col", null), 
                        React.createElement("col", null), 
                        React.createElement("col", null), 
                        React.createElement("col", null), 
                        React.createElement("col", {style: {'width':'28%'}}), 
                        React.createElement("col", null)
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, "번호"), 
                            React.createElement("th", {scope: "col"}, "수업시작(소요시간)"), 
                            React.createElement("th", {scope: "col"}, "학교급"), 
                            React.createElement("th", {scope: "col", className: "tbl-hide"}, "직업분류"), 
                            React.createElement("th", {scope: "col", className: "tbl-hide"}, "직업명"), 
                            React.createElement("th", {scope: "col", className: "tbl-hide"}, "멘토"), 
                            React.createElement("th", {scope: "col"}, "수업명"), 
                            React.createElement("th", {scope: "col"}, "상태")
                        )
                    ), 
                    React.createElement(LectureList, {data: this.state.data})
                )
            )
        );
    }
});

//LectureList
var LectureList = React.createClass({displayName: "LectureList",
    render:function(){
        var lecList = null;
        if(this.props.data != null && this.props.data.length > 0){
            lecList = this.props.data.map(function(lecData, index) {
                    return (
                        React.createElement(Lecture, {key: index, date: to_date_format(lecData.lectDay, "/").substring(5,10), 
                                 startTime: to_time_format(lecData.lectStartTime, ":"), 
                                 lectRunTime: lecData.lectRunTime, 
                                 lectTargtCd: lecData.lectTimsInfo.lectInfo.lectTargtCd, 
                                 lectrJobNm: lecData.lectTimsInfo.lectInfo.lectrJobNm === null ? '' :lecData.lectTimsInfo.lectInfo.lectrJobNm, 
                                 lectrJobClsfNm: lecData.lectTimsInfo.lectInfo.lectrJobClsfNm === null ? '' :lecData.lectTimsInfo.lectInfo.lectrJobClsfNm, 
                                 lectrNm: lecData.lectTimsInfo.lectInfo.lectrNm, 
                                 lectTitle: lecData.lectTimsInfo.lectInfo.lectTitle, 
                                 lectStatCdNm: lecData.lectStatCdNm, 
                                 lectSer: lecData.lectTimsInfo.lectSer, 
                                 lectTims: lecData.lectTimsInfo.lectTims, 
                                 schdSeq: lecData.schdSeq, 
                                 rn: index}
                            )
                    );
                });
        } else if(firstCall) {
            lecList = [];
            lecList.push(
                    React.createElement("tr", null, 

                        React.createElement("td", {colSpan: "8", className: "tbl-hide"}, "\"수업이 없습니다.\""), 
                        React.createElement("td", {colSpan: "5", className: "tbl"}, "\"수업이 없습니다.\"")
                    )
            );
        }
        return (
            React.createElement("tbody", null, 
                lecList
            )
        );
    }
});

//Lecture
var Lecture = React.createClass({displayName: "Lecture",
    propTypes: {
        date:           React.PropTypes.string,
        startTime:      React.PropTypes.string,
        lectRunTime:    React.PropTypes.string,
        lectTargtCd:    React.PropTypes.string,
        lectrJobNm:     React.PropTypes.string,
        lectrJobClsfNm: React.PropTypes.string,
        lectrNm:        React.PropTypes.string,
        lectTitle:      React.PropTypes.string,
        lectStatCdNm:   React.PropTypes.string,
        lectSer:        React.PropTypes.number,
        lectTims:       React.PropTypes.number,
        schdSeq:        React.PropTypes.number,
        rn:             React.PropTypes.number
    },
    goLectureView: function(lectSer, lectTims, schdSeq) {
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq;
        $(location).attr('href', url);
    },
    render:function(){
        var ratings = [];
        var lectTargtCd = this.props.lectTargtCd;

        if(lectTargtCd == "101534"){
            ratings.push(React.createElement("span", {className: "lecture-con lv1", title: "초등학교"}, "초"));
        }else if(lectTargtCd == "101535"){
            ratings.push(React.createElement("span", {className: "lecture-con lv2", title: "중학교"}, "중"));
        }else if(lectTargtCd == "101536"){
            ratings.push(React.createElement("span", {className: "lecture-con lv3", title: "고등학교"}, "고"));
        }else if(lectTargtCd == "101537"){
            ratings.push(React.createElement("span", {className: "lecture-con lv1", title: "초등학교"}, "초"));
            ratings.push(React.createElement("span", {className: "lecture-con lv2", title: "중학교"}, "중"));
        }else if(lectTargtCd == "101538"){
            ratings.push(React.createElement("span", {className: "lecture-con lv2", title: "중학교"}, "중"));
            ratings.push(React.createElement("span", {className: "lecture-con lv3", title: "고등학교"}, "고"));
        }else if(lectTargtCd == "101539"){
            ratings.push(React.createElement("span", {className: "lecture-con lv1", title: "초등학교"}, "초"));
            ratings.push(React.createElement("span", {className: "lecture-con lv3", title: "고등학교"}, "고"));
        }else if(lectTargtCd == "101540"){
            ratings.push(React.createElement("span", {className: "lecture-con lv1", title: "초등학교"}, "초"));
            ratings.push(React.createElement("span", {className: "lecture-con lv2", title: "중학교"}, "중"));
            ratings.push(React.createElement("span", {className: "lecture-con lv3", title: "고등학교"}, "고"));
        }

        var mon = Number(this.props.date.substring(0,2));
        var dd = Number(this.props.date.substring(3,5));


        var lectStat = [];
        if(this.props.lectStatCdNm == "수강모집"){
            lectStat.push(React.createElement("td", {className: "txt-recruit"}, this.props.lectStatCdNm));
        }else{
            lectStat.push(React.createElement("td", null, this.props.lectStatCdNm));
        }


        return (
            React.createElement("tr", null, 
                React.createElement("td", null, this.props.rn + 1), 
                React.createElement("td", null, mon, "/", dd, " ", this.props.startTime, " (", this.props.lectRunTime, "분)"), 
                React.createElement("td", null, ratings), 
                React.createElement("td", {className: "tbl-hide"}, React.createElement("span", {className: "long-txt"}, this.props.lectrJobClsfNm)), 
                React.createElement("td", {className: "tbl-hide"}, React.createElement("span", {className: "long-txt"}, this.props.lectrJobNm)), 
                React.createElement("td", {className: "tbl-hide"}, this.props.lectrNm), 
                React.createElement("td", null, React.createElement("a", {href: "javascript:void(0)", className: "long-txt class-name", onClick: this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}, this.props.lectTitle)), 
                lectStat
            )
        );
    }
});