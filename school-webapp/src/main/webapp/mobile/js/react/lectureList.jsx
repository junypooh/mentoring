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
        imgPath:    React.PropTypes.string,
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
        var lectTargtCd = this.props.lectTargtCd;

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

        return (
            <li>
                <a href="javascript:void(0);" onClick={this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}>
                    <dl className="lesson-info">
                        <dt className="mento">{this.props.mentoNm}</dt>
                        <dd className="title">{this.props.title}</dd>
                        <dd className="rating">{ratings}</dd>
                        <dd className="date-time">
                            <span className="date">{this.props.date}</span><span className="time">{this.props.startTime}~{this.props.endTime}</span>
                        </dd>
                        <dd className="sort"><span className="icon" >수강모집</span></dd>
                        <dd className="info"><p>{this.props.desc}</p></dd>
                        <dd className="image"><img src={mentor.contextpath+this.props.imgPath} alt={this.props.title} /></dd>
                    </dl>
                </a>
            </li>
        );
    }
});
var LectureList = React.createClass({
    render:function(){
        var lecList = this.props.data.map(function(lecData, index) {
            return (
                <Lecture mentoNm={lecData.lectTimsInfo.lectInfo.lectIntdcInfo}
                         title={lecData.lectTimsInfo.lectInfo.lectrNm}
                         date={to_date_format(lecData.lectDay, "-")}
                         startTime={to_time_format(lecData.lectStartTime, ":")}
                         endTime={to_time_format(lecData.lectEndTime,":")}
                         desc={lecData.lectTimsInfo.lectInfo.lectOutlnInfo}
                         lectTargtCd={lecData.lectTimsInfo.lectInfo.lectTargtCd}
                         imgPath={lecData.lectTimsInfo.lectInfo.lectPicPath}
                         lectSer={lecData.lectTimsInfo.lectSer}
                         lectTims={lecData.lectTimsInfo.lectTims}
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
var LectureTabView = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    componentDidMount: function() {
        //this.getList();
    },
    getList: function(param) {
        var lectStatCd = "";

        if(param.listType == "1"){  //수강모집
            lectStatCd = "101543";
        }else if(param.listType == "2"){ //수업예정
            lectStatCd ="101548";
        }else if(param.listType == "3"){  //수업대기
            lectStatCd ="101549";
        }else if(param.listType == "4"){  //수업중
            lectStatCd ="101550";
        }else if(param.listType == "5"){  //수업완료
            lectStatCd ="101551";
        }

        var _param = jQuery.extend({'currentPageNo':1,
            'recordCountPerPage':9,
            'schoolGrd':$("#schoolGrd").val(),
            'searchStDate':$("#searchStDate").val(),
            'searchEndDate':$("#searchEndDate").val(),
            'lectTime':$("#lectTime").val(),
            'lectType':$("#lectType").val(),
            'jobChrstcList':$("#jobChrstc").val(),
            'jobNo':$("#jobDetail").val(),
            'lectStatCd':lectStatCd,
            'searchKey':$("#searchKey").val(),
            'searchType':$("#seachType option:selected").val()},param);

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
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount});
                    $(".result-total").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ");
                }else{
                    $(".result-total").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ");
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
                <h3 className="invisible">전체 검색 내용</h3>
                <div className="search-list-type">
                    <LectureList data={this.state.data}/>
                </div>
                <div className="btn-more-view" style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                    <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true})}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
                </div>
                <a href="#lessonTab02" className="btn-focus-move" >수강모집 메뉴로 이동</a>
            </div>
        );
    }
});
//Lecture