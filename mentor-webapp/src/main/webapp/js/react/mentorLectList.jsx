/**
 * Created by song on 2015-10-07.
 */
//Lecture
var Lecture = React.createClass({
    propTypes: {
        mentoNm:     React.PropTypes.string,
        title:       React.PropTypes.string,
        startTime:   React.PropTypes.string,
        endTime:     React.PropTypes.string,
        desc:        React.PropTypes.string,
        lectTargtCd: React.PropTypes.string,
        imgPath:     React.PropTypes.string,
        lectStatCd : React.PropTypes.string,
        lectStatCdNm:React.PropTypes.string,
        lectTypeCd : React.PropTypes.string,
        lectSer:     React.PropTypes.number,
        lectrNm:     React.PropTypes.number,
        lectTims:    React.PropTypes.number,
        schdSeq:     React.PropTypes.number,
        maxApplCnt:  React.PropTypes.number,
        maxObsvCnt:  React.PropTypes.number,
        applCnt:     React.PropTypes.number,
        obsvCnt:     React.PropTypes.number,
        replayCnt:   React.PropTypes.number,
        lectSessId:  React.PropTypes.string,
        applClassCd: React.PropTypes.string,
    },
    goLectureDetailView: function(lectSer, lectTims, schdSeq, activeTab) {
        if(lectTims == "null"){
            lectTims = "";
            schdSeq = "";
        }
        var parameter = $.param({"lectSer":lectSer, "lectTims":lectTims, "schdSeq":schdSeq, "listType":activeTab});
        var url = mentor.contextpath + "/lecture/lectureState/lectureDetailView.do?"+ parameter;
        $(location).attr('href', url);
        //window.open(url, '_blank');
    },
    layerPopupApplDvc: function(lectSer, lectTims, applCnt, maxApplCnt, applClassCd) {
        $('#layerPopupDiv').load(mentor.contextpath + "/layer/layerPopupApplDvcList.do?lectSer="+lectSer+"&lectTims="+lectTims+"&applCnt="+applCnt+"&maxApplCnt="+maxApplCnt+"&applClassCd="+applClassCd, function() {
            $("#layerOpen").trigger("click");
        });
    },
    lectureEntrance: function(lectSessId){
        _fCallTomms(lectSessId);
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
        }else if(lectTargtCd == "101713"){
            ratings.push(<span className="icon-rating etc">기타</span>);
        }

        var lectTitle = this.props.title;

        if(this.props.lectTypeCd == "101530"){
            lectTitle = "[연강] " + this.props.title;
        }else if(this.props.lectTypeCd == "101531"){
            lectTitle = "[특강] " + this.props.title;
        }else if(this.props.lectTypeCd == "101532"){
            lectTitle = "[블록] " + this.props.title;
        }

        var lectStatCd = this.props.lectStatCd;
        var goLectureTag = [];

        if(lectStatCd == "101549" || lectStatCd == "101550"){ /*수업대기, 수업중*/
            goLectureTag.push(<span className="admission"><a href="#" onClick={this.lectureEntrance.bind(this, this.props.lectSessId)}>입장</a></span>);
        }

        var goApplTag = [];

        if(this.props.applCnt != "0"){
            goApplTag.push(
                            <span className="visit">
                                <a href="javascript:void(0)" onClick={this.props.applCnt == 0 ?"": this.layerPopupApplDvc.bind(this, this.props.lectSer, this.props.lectTims,this.props.applCnt,this.props.maxApplCnt, '101715')}>
                                    {this.props.applCnt}
                                </a>{this.props.maxApplCnt}
                            </span>
                          );
        }else{
            goApplTag.push(
                            <span className="visit">
                                    {this.props.applCnt} / {this.props.maxApplCnt}
                            </span>
                          );
        }

        var goObsvTag = [];

        if(this.props.obsvCnt != "0"){
            goObsvTag.push(
                            <span className="visit">
                                <a href="javascript:void(0)" onClick={this.props.obsvCnt == 0 ?"": this.layerPopupApplDvc.bind(this, this.props.lectSer, this.props.lectTims,this.props.obsvCnt,this.props.maxObsvCnt, '101716')}>
                                    {this.props.obsvCnt}
                                </a>{this.props.maxObsvCnt}
                            </span>
                          );
        }else{
            goObsvTag.push(
                            <span className="visit">
                                    {this.props.obsvCnt} / {this.props.maxObsvCnt}
                            </span>
                          );
        }

        return (
            <tr>
                <td>{this.props.lectStatCdNm}</td>
                <td className="al-left">
                    <div className="lesson-mngmt-info">
                        <a href="javascript:void(0)" onClick={this.goLectureDetailView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq, mentor.activeTab)}>{lectTitle}</a>
                        {this.props.date == null?<span className="time" >&nbsp;</span>:<span className="time">{this.props.date}<em>{this.props.startTime}~{this.props.endTime}</em></span>}
                        {ratings}
                        {goLectureTag}
                    </div>
                </td>
                <td>{this.props.lectrNm}</td>
                <td className="al-r">
                    {goApplTag}
                </td>
                <td className="al-r">
                    {goObsvTag}
                </td>
            </tr>
        );
    }
});
var LectureList = React.createClass({
    render:function(){
        var lecList = this.props.data.map(function(lecData, index) {
            return (
                <Lecture lectIntdcInfo={lecData.lectIntdcInfo}
                         mentorNm={lecData.mentorNm}
                         title={lecData.lectTitle}
                         date={to_date_format(lecData.lectDay, "-")}
                         startTime={to_time_format(lecData.lectStartTime, ":")}
                         endTime={to_time_format(lecData.lectEndTime,":")}
                         desc={lecData.lectOutlnInfo}
                         lectTargtCd={lecData.lectTargtCd}
                         imgPath={lecData.lectPicPath}
                         lectSer={lecData.lectSer}
                         lectTims={lecData.lectTims}
                         schdSeq={lecData.schdSeq}
                         maxApplCnt={lecData.maxApplCnt}
                         maxObsvCnt={lecData.maxObsvCnt}
                         obsvCnt={lecData.obsvCnt}
                         applCnt={lecData.applCnt}
                         lectStatCd={lecData.lectStatCd}
                         lectStatCdNm={lecData.lectStatCdNm}
                         lectTypeCd={lecData.lectTypeCd}
                         lectSessId={lecData.lectSessId}
                         replayCnt = {lecData.replayCnt}
                         lectrNm = {lecData.lectrNm}
                         applClassCd = {lecData.applClassCd}
                    />
            );
        });
        return (
            <tbody>
                {lecList}
            </tbody>
        );
    }
});
var MentorLectTabView = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1,'recordCountPerPage':$("#recordCountPerPage").val()};
    },
    componentDidMount: function() {
        this.getList({'listType': mentor.activeTab,'currentPageNo':1,'recordCountPerPage':$("#recordCountPerPage").val()});
    },
    recordChange: function() {
        this.getList({'listType': mentor.activeTab,'currentPageNo':1,'recordCountPerPage':$("#recordCountPerPage").val()});
    },
    componentWillReceiveProps:function(nextProps){
    },
    getList: function(param) {
        var lectStatCd = "";

        if(param.listType == "1"){ //수강모집
            lectStatCd ="101543";
        }else if(param.listType == "2"){  //수업예정
            lectStatCd ="101548";
        }else if(param.listType == "3"){  //수업대기
            lectStatCd ="101549";
        }else if(param.listType == "4"){  //수업완료
            lectStatCd ="101551";
        }
        var _param = jQuery.extend({'currentPageNo':1,
            'recordCountPerPage':Number(this.props.recordCountPerPage),
            'schoolGrd':$("#schoolGrd").val(),
            'searchStDate':$("#searchStDate").val(),
            'searchEndDate':$("#searchEndDate").val(),
            'lectType':$("#lectType").val(),
            'lectStatCd':lectStatCd,
            'searchKey':$("#searchKey").val(),
            'searchType':$("#seachType option:selected").val()},param);

        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null && rtnData.length > 0){
                    totalCnt = rtnData[0].totalRecordCount;
                }
                this.setState({data: rtnData,'totalRecordCount':Number(totalCnt),'currentPageNo':Number(_param.currentPageNo),'recordCountPerPage':Number(_param.recordCountPerPage)});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var pageNode = [];
        var dataNode = [];
        if(this.state.data.length >0){
            pageNode.push(<PageNavi url={this.props.url} pageFunc={searchList} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath}/>);
            dataNode.push(<LectureList data={this.state.data}/>);
        }else{ //검색결과 존재안할때 추가사용
            dataNode.push(<tr><td className="board-no-data" colSpan="4">등록된 수업이 없습니다.</td></tr>);
        }

        return (
            <div className="tab-cont active">
                <div className="tit-wrap">
                    <span className="right">
                        <select style={{width:'68px'}} id="recordCountPerPage" onChange={this.recordChange}>
                            <option>10</option>
                            <option>20</option>
                            <option>30</option>
                            <option>50</option>
                        </select>
                    </span>
                </div>
                <div className="board-type1 lesson_lists">
                    <table>
                        <caption>수업 전체현황 - 상태, 수업, 신청, 참관</caption>
                        <colgroup>
                            <col style={{width:'100px'}} />
                            <col />
                            <col style={{width:'110px'}} />
                            <col style={{width:'80px'}} />
                            <col style={{width:'80px'}} />
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col">상태</th>
                            <th scope="col">수업</th>
                            <th scope="col">멘토</th>
                            <th scope="col">신청</th>
                            <th scope="col">참관</th>
                        </tr>
                        </thead>
                            {dataNode}
                        </table>
                 </div>
                {pageNode}
            </div>
        );
    }
});
//Lecture