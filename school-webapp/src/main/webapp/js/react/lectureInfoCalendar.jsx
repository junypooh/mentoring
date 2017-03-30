/**
 *  수업일정 react.js
 * Created by junypooh on 2016-05-20.
 */
 //CalendarLect
var CalendarLect = React.createClass({
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
            summary.push(<span className="lecture-con lv1" title="초등학교">초</span>);
            summary.push(<em>{this.state.eleCnt}건</em>);
        } else {
            summary.push(<span className="lecture-con lv1" title="초등학교">초</span>);
            summary.push(<em>0건</em>);
        }
        if(this.state.midCnt > 0) {
            summary.push(<span className="lecture-con lv2" title="중학교">중</span>);
            summary.push(<em>{this.state.midCnt}건</em>);
        } else {
            summary.push(<span className="lecture-con lv2" title="중학교">중</span>);
            summary.push(<em>0건</em>);
        }
        if(this.state.highCnt > 0) {
            summary.push(<span className="lecture-con lv3" title="고등학교">고</span>);
            summary.push(<em>{this.state.highCnt}건</em>);
        } else {
            summary.push(<span className="lecture-con lv3" title="고등학교">고</span>);
            summary.push(<em>0건</em>);
        }

        return (
            <div className="board-list-type">
                <div className="board-list-title">
                    <ul className="sch-list-tab">
                        <li className={this.state.schoolGrd == '' ? "on" : ""}><a href="javascript:void(0)" onClick={this.filterSchoolGrd.bind(this, '')}>전체</a></li>
                        <li className={this.state.schoolGrd == '101534' ? "on" : ""}><a href="javascript:void(0)" onClick={this.filterSchoolGrd.bind(this, '101534')}>초등학교</a></li>
                        <li className={this.state.schoolGrd == '101535' ? "on" : ""}><a href="javascript:void(0)" onClick={this.filterSchoolGrd.bind(this, '101535')}>중학교</a></li>
                        <li className={this.state.schoolGrd == '101536' ? "on" : ""}><a href="javascript:void(0)" onClick={this.filterSchoolGrd.bind(this, '101536')}>고등학교</a></li>
                    </ul>
                    <div className="sch-count"><strong>{sMonth}월{sDate}일</strong> 수업목록 : {summary}</div>
                </div>
                <table className="sch-list">
                    <caption>학교 테이블정보 - 번호, 수업시작(소요시간), 학교급, 직업분류, 직업명, 멘토, 수업명, 상태</caption>
                    <colgroup>
                        <col style={{'width':'5%'}}/>
                        <col style={{'width':'15%'}}/>
                        <col/>
                        <col/>
                        <col/>
                        <col/>
                        <col style={{'width':'28%'}}/>
                        <col/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">수업시작(소요시간)</th>
                            <th scope="col">학교급</th>
                            <th scope="col" className="tbl-hide">직업분류</th>
                            <th scope="col" className="tbl-hide">직업명</th>
                            <th scope="col" className="tbl-hide">멘토</th>
                            <th scope="col">수업명</th>
                            <th scope="col">상태</th>
                        </tr>
                    </thead>
                    <LectureList data={this.state.data}/>
                </table>
            </div>
        );
    }
});

//LectureList
var LectureList = React.createClass({
    render:function(){
        var lecList = null;
        if(this.props.data != null && this.props.data.length > 0){
            lecList = this.props.data.map(function(lecData, index) {
                    return (
                        <Lecture key={index} date={to_date_format(lecData.lectDay, "/").substring(5,10)}
                                 startTime={to_time_format(lecData.lectStartTime, ":")}
                                 lectRunTime={lecData.lectRunTime}
                                 lectTargtCd={lecData.lectTimsInfo.lectInfo.lectTargtCd}
                                 lectrJobNm={lecData.lectTimsInfo.lectInfo.lectrJobNm === null ? '' :lecData.lectTimsInfo.lectInfo.lectrJobNm }
                                 lectrJobClsfNm={lecData.lectTimsInfo.lectInfo.lectrJobClsfNm === null ? '' :lecData.lectTimsInfo.lectInfo.lectrJobClsfNm }
                                 lectrNm={lecData.lectTimsInfo.lectInfo.lectrNm}
                                 lectTitle={lecData.lectTimsInfo.lectInfo.lectTitle}
                                 lectStatCdNm={lecData.lectStatCdNm}
                                 lectSer={lecData.lectTimsInfo.lectSer}
                                 lectTims={lecData.lectTimsInfo.lectTims}
                                 schdSeq={lecData.schdSeq}
                                 rn={index}
                            />
                    );
                });
        } else if(firstCall) {
            lecList = [];
            lecList.push(
                    <tr>

                        <td colSpan="8" className="tbl-hide">"수업이 없습니다."</td>
                        <td colSpan="5" className="tbl">"수업이 없습니다."</td>
                    </tr>
            );
        }
        return (
            <tbody>
                {lecList}
            </tbody>
        );
    }
});

//Lecture
var Lecture = React.createClass({
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
            ratings.push(<span className="lecture-con lv1" title="초등학교">초</span>);
        }else if(lectTargtCd == "101535"){
            ratings.push(<span className="lecture-con lv2" title="중학교">중</span>);
        }else if(lectTargtCd == "101536"){
            ratings.push(<span className="lecture-con lv3" title="고등학교">고</span>);
        }else if(lectTargtCd == "101537"){
            ratings.push(<span className="lecture-con lv1" title="초등학교">초</span>);
            ratings.push(<span className="lecture-con lv2" title="중학교">중</span>);
        }else if(lectTargtCd == "101538"){
            ratings.push(<span className="lecture-con lv2" title="중학교">중</span>);
            ratings.push(<span className="lecture-con lv3" title="고등학교">고</span>);
        }else if(lectTargtCd == "101539"){
            ratings.push(<span className="lecture-con lv1" title="초등학교">초</span>);
            ratings.push(<span className="lecture-con lv3" title="고등학교">고</span>);
        }else if(lectTargtCd == "101540"){
            ratings.push(<span className="lecture-con lv1" title="초등학교">초</span>);
            ratings.push(<span className="lecture-con lv2" title="중학교">중</span>);
            ratings.push(<span className="lecture-con lv3" title="고등학교">고</span>);
        }

        var mon = Number(this.props.date.substring(0,2));
        var dd = Number(this.props.date.substring(3,5));


        var lectStat = [];
        if(this.props.lectStatCdNm == "수강모집"){
            lectStat.push(<td className="txt-recruit">{this.props.lectStatCdNm}</td>);
        }else{
            lectStat.push(<td>{this.props.lectStatCdNm}</td>);
        }


        return (
            <tr>
                <td>{this.props.rn + 1}</td>
                <td>{mon}/{dd} {this.props.startTime} ({this.props.lectRunTime}분)</td>
                <td>{ratings}</td>
                <td className="tbl-hide"><span className="long-txt">{this.props.lectrJobClsfNm}</span></td>
                <td className="tbl-hide"><span className="long-txt">{this.props.lectrJobNm}</span></td>
                <td className="tbl-hide">{this.props.lectrNm}</td>
                <td><a href="javascript:void(0)" className="long-txt class-name" onClick={this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}>{this.props.lectTitle}</a></td>
                {lectStat}
            </tr>
        );
    }
});