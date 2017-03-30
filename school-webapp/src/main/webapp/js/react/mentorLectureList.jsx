/**
 * Created by song on 2015-10-07.
 */
//Lecture
var Lecture = React.createClass({
    propTypes: {
        mentoNm:    React.PropTypes.string,
        title:      React.PropTypes.string,
        startTime:  React.PropTypes.string,
        endTime:    React.PropTypes.string,
        desc:       React.PropTypes.string,
        lectTargtCd:React.PropTypes.string,
        lectTypeCdNm:React.PropTypes.string,
        imgPath:    React.PropTypes.string,
        lectIntdcInfo:    React.PropTypes.string,
        lectStatCd:    React.PropTypes.string,
        lectSer:    React.PropTypes.number,
        lectTims:   React.PropTypes.number,
        schdSeq:    React.PropTypes.number
    },
    goLectureView: function(lectSer, lectTims, schdSeq) {
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq;
        $(location).attr('href', url);
    },
    render:function(){
        var ratings = [];
        var lectStatTag = [];
        var lectTargtCd = this.props.lectTargtCd;
        var lectStatCd = this.props.lectStatCd;
        var arclSer = this.props.arclSer;
        var cntntsId = this.props.cntntsId;
        var lectTypeCdNm = this.props.lectTypeCdNm;

        var replayUrl = "";

        if(arclSer && cntntsId)
            replayUrl = mentor.contextpath + "/lecture/lectureReplay/lectureReplyView.do?arclSer="+arclSer+"&cId=" + cntntsId;

        //수업대상
        if(lectTargtCd == "101534"){
            ratings.push(<span className="icon-rating elementary">초</span>);
        }else if(lectTargtCd == "101535"){
            ratings.push(<span className="icon-rating middle">중</span>);
        }else if(lectTargtCd == "101536"){
            ratings.push(<span className="icon-rating high">고</span>);
        }else if(lectTargtCd == "101537"){
            ratings.push(<span className="icon-rating elementary">초</span>);
            ratings.push(<span className="icon-rating middle">중</span>);
        }else if(lectTargtCd == "101538"){
            ratings.push(<span className="icon-rating middle">중</span>);
            ratings.push(<span className="icon-rating high">고</span>);
        }else if(lectTargtCd == "101539"){
            ratings.push(<span className="icon-rating elementary">초</span>);
            ratings.push(<span className="icon-rating high">고</span>);
        }else if(lectTargtCd == "101540"){
            ratings.push(<span className="icon-rating elementary">초</span>);
            ratings.push(<span className="icon-rating middle">중</span>);
            ratings.push(<span className="icon-rating high">고</span>);
        }

        //수업상태
        if(lectStatCd == "101543"){
            lectStatTag.push(<em>수강모집</em>);
        }else if(lectStatCd == "101547"){
            lectStatTag.push(<em>모집취소</em>);
        }else if(lectStatCd == "101548"){
            lectStatTag.push(<em>수업예정</em>);
        }else if(lectStatCd == "101549"){
            lectStatTag.push(<em>수업대기</em>);
        }else if(lectStatCd == "101550"){
            lectStatTag.push(<em>수업중</em>);
        }else if(lectStatCd == "101551"){
            lectStatTag.push(<em>수업완료</em>);
            if(replayUrl !== ''){
                lectStatTag.push(<a href={replayUrl} className="video" target="_self">동영상보기</a>);  //수업다시보기 완성되면 url연결
            }
        }else if(lectStatCd == "101553"){
            lectStatTag.push(<em>수업취소</em>);
        }

        return (
            <li>
                <div className="title">
                        <span className="tit"><a href="javascript:void(0);" onClick={this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}>[{lectTypeCdNm}]{this.props.title}</a></span>
                            {lectStatTag}
                        <span className="r-align">
                            {ratings}
                        </span>
                </div>
                <div className="date">
                    <span className="user mentor">{this.props.mentorNm}</span>
                    <p>{this.props.date} <span className="t-mobile-blind">/</span><strong>{this.props.startTime}~{this.props.endTime}</strong></p>
                </div>
                <p>
                    <a href="#" className="view">수업소개보기</a>
                    <span dangerouslySetInnerHTML={{__html: this.props.lectIntdcInfo}}></span>
                </p>
            </li>
        );
    }
});
var LectureList = React.createClass({
    render:function(){
        var lecList = this.props.data.map(function(lecData, index) {
            return (
                <Lecture lectIntdcInfo={lecData.lectTimsInfo.lectInfo.lectIntdcInfo}
                         lectSustInfo={lecData.lectTimsInfo.lectInfo.lectSustInfo}
                         title={lecData.lectTimsInfo.lectInfo.lectTitle}
                         mentorNm={lecData.lectTimsInfo.lectInfo.lectrNm}
                         date={to_date_format(lecData.lectDay, "-")}
                         startTime={to_time_format(lecData.lectStartTime, ":")}
                         endTime={to_time_format(lecData.lectEndTime,":")}
                         lectTypeCdNm={lecData.lectTimsInfo.lectInfo.lectTypeCdNm}
                         desc={lecData.lectTimsInfo.lectInfo.lectOutlnInfo}
                         lectTargtCd={lecData.lectTimsInfo.lectInfo.lectTargtCd}
                         imgPath={lecData.lectTimsInfo.lectInfo.lectPicPath}
                         lectSer={lecData.lectTimsInfo.lectSer}
                         lectTims={lecData.lectTimsInfo.lectTims}
                         schdSeq={lecData.schdSeq}
                         lectStatCd={lecData.lectStatCd}
                         arclSer={lecData.arclSer}
                         cntntsId={lecData.cntntsId}/>
            );
        });
        return (
            <ul>
                {lecList}
            </ul>
        );
    }
});
var MentorLectureList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    componentDidMount: function() {
        this.getList();
    },
    getList: function(param) {
        var _param = jQuery.extend({
            'currentPageNo':1,
            'recordCountPerPage':5,
            'mbrNo':this.props.mbrNo
        }, param);

        if(_param.isMore != true){
            this.setState({'data': [],'totalRecordCount':0});
        }

        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                if(rtnData.length>0){
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount, currentPageNo: _param.currentPageNo}, function(){connectionLesson();});
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        return (
            <div>
                <h3>멘토수업</h3>
                    <LectureList data={this.state.data}/>
                <div className="btn-more-view" style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                    <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
                </div>
            </div>
        );
    }
});
//Lecture