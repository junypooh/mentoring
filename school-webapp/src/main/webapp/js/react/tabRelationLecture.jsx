/**
 * 수업상세화면 관련수업 탭
 */

var TabRelationLectureListView = React.createClass({
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
            <div className="lesson-connection">
                <h3>관련수업</h3>
                <TabRelationLectureList data={this.state.data}/>

                <div className="paging-btn" >
                  <PageNavi url={this.props.url} pageFunc={this.goPage} pageSize={10} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={5} contextPath={mentor.contextpath} />
                </div>

            </div>
        );
    }
});

var TabRelationLectureList = React.createClass({
    render: function () {
        var lecList = this.props.data.map(function (lecData, index) {
            return (
                <TabRelationLecture lectTitle={lecData.lectTitle}
                                    lectStatCdNm={lecData.lectStatCdNm}
                                    lectTargtCd={lecData.lectTargtCd}
                                    lectrNm={lecData.lectrNm}
                                    lectDay={to_date_format(lecData.lectDay, "-")}
                                    lectStartTime={to_time_format(lecData.lectStartTime, ":")}
                                    lectEndTime={to_time_format(lecData.lectEndTime,":")}
                                    cntntsId={lecData.cntntsId}
                                    arclSer={lecData.arclSer}
                                    lectIntdcInfo={lecData.lectIntdcInfo}
                                    lectSer={lecData.lectSer}
                                    lectTims={lecData.lectTims}
                                    schdSeq={lecData.schdSeq}/>
            );
        });
        return (
            <ul>
                {lecList}
            </ul>
        );
    }
});

var TabRelationLecture = React.createClass({
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
            ratings.push(<span className="icon-rating elementary">초</span>);
        } else if (lectTargtCd == "101535") {
            ratings.push(<span className="icon-rating middle">중</span>);
        } else if (lectTargtCd == "101536") {
            ratings.push(<span className="icon-rating high">고</span>);
        } else if (lectTargtCd == "101537") {
            ratings.push(<span className="icon-rating elementary">초</span>);
            ratings.push(<span className="icon-rating middle">중</span>);
        } else if (lectTargtCd == "101538") {
            ratings.push(<span className="icon-rating middle">중</span>);
            ratings.push(<span className="icon-rating high">고</span>);
        } else if (lectTargtCd == "101539") {
            ratings.push(<span className="icon-rating elementary">초</span>);
            ratings.push(<span className="icon-rating high">고</span>);
        } else if (lectTargtCd == "101540") {
            ratings.push(<span className="icon-rating elementary">초</span>);
            ratings.push(<span className="icon-rating middle">중</span>);
            ratings.push(<span className="icon-rating high">고</span>);
        }

        var rePlay = "";
        if (this.props.cntntsId && this.props.arclSer) {
            rePlay = <a href="javascript:void(0);" onClick={this.goLectureReplay.bind(this, this.props.arclSer, this.props.cntntsId)} className="video">동영상보기</a>;
        }


        return (
            <li>
                <div className="title">
                    <span className="tit"><a href="javascript:void(0);" onClick={this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}>{this.props.lectTitle}</a></span>
                    <em>{this.props.lectStatCdNm}</em>
                    {rePlay}
					<span className="r-align">
                        {ratings}
					</span>
                </div>
                <div className="date">
                    <span className="user mentor">{this.props.lectrNm}</span>

                    <p>{this.props.lectDay} <span className="t-mobile-blind">/</span> <strong>{this.props.lectStartTime}~{this.props.lectEndTime}</strong></p>
                </div>
                <p>
                    <a href="javascript:void(0)" className="view">수업소개보기</a>
                    <span>{this.props.lectIntdcInfo}</span>
                </p>
            </li>
        );
    }
});