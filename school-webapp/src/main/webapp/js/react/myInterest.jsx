var InterestJob = React.createClass({
    showSetting:function(){
        if($(React.findDOMNode(this.refs.settings)).hasClass("active")) {
            $(React.findDOMNode(this.refs.settings)).removeClass("active");
        } else {
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(React.findDOMNode(this.refs.settings)).addClass("active");
        }
    },
    render:function(){
        var interestJob = [];
        if(this.props.jobPicInfo !=null && this.props.jobPicInfo != ""){
            interestJob.push(<span className="img"><img src={parsePicInfo(this.props.jobPicInfo)}/></span>);
        }else if(this.props.fileSer !=null && this.props.fileSer != ""){
            interestJob.push(<span className="img"><img src={mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileSer} alt={this.props.title} /></span>);
        }else{
            interestJob.push(<span className="img"><img src={mentor.contextpath+"/images/mentor/bg_thumb_132x132.gif"} alt={this.props.title} /></span>);
        }

        return (
                <li>
                    <h3>관심직업</h3>
                    <a href="javascript:void(0)" className="set-up" onClick={this.showSetting} ref="settings">설정</a>
                    <div className="layer" >
                        <div>
                            <ul>
                                <li>
                                    <em>{this.props.title}</em>
                                    <a href="javascript:void(0)" onClick={deleteMyInterest.bind(this,this.props)}>소식안받기</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div className="thumb">
                        {interestJob}
                        <strong className="title"><em>{this.props.title}</em> 정보가 업데이트 되었습니다.</strong>
                        <span className="day">{new Date(this.props.day).format('yyyy.MM.dd')}</span>
                        <p>{this.props.detail}</p>
                        <a href={mentor.contextpath+"/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.key1} className="detail-view">자세히보기</a>
                    </div>
                </li>
      );
    }
});

var InterestLecture = React.createClass({
    showSetting:function(){
        if($(React.findDOMNode(this.refs.settings)).hasClass("active")) {
            $(React.findDOMNode(this.refs.settings)).removeClass("active");
        } else {
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(React.findDOMNode(this.refs.settings)).addClass("active");
        }
    },
    render:function(){
        return (
                <li>
                    <h3>관심수업</h3>
                    <a href="javascript:void(0)" className="set-up" onClick={this.showSetting} ref="settings">설정</a>
                    <div className="layer">
                        <div>
                            <ul>
                                <li>
                                    <em>{this.props.title}</em>
                                    <a href="javascript:void(0)" onClick={deleteMyInterest.bind(this,this.props)}>소식안받기</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div className="thumb lesson">
                        <span className="img"><img src={mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileSer} alt={this.props.title} /></span>
                        <strong className="title"><em>{this.props.title}</em> 수업이 관심수업으로 등록되었습니다.</strong>
                        <span className="day">{new Date(this.props.day).format('yyyy.MM.dd')}</span>
                        <span className="lesson">- 수업개설<span>{this.props.detail}</span></span>
                        <a href={mentor.contextpath+"/lecture/lectureTotal/lectureView.do?lectSer="+this.props.key1+"&lectTims="+this.props.key2+"&schdSeq="+this.props.key3} className="detail-view">자세히보기</a>
                    </div>
                </li>
      );
    }
});

var InterestMentor = React.createClass({
    showSetting:function(){
        if($(React.findDOMNode(this.refs.settings)).hasClass("active")) {
            $(React.findDOMNode(this.refs.settings)).removeClass("active");
        } else {
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(React.findDOMNode(this.refs.settings)).addClass("active");
        }
    },
    render:function(){
        return (
                <li>
                    <h3>관심멘토</h3>
                    <a href="javascript:void(0)" className="set-up" onClick={this.showSetting} ref="settings">설정</a>
                    <div className="layer">
                        <div>
                            <ul className="mentor">
                                <li>
                                    <em>{this.props.title}</em>
                                    <a href="javascript:void(0)" onClick={deleteMyInterest.bind(this,this.props)}>소식안받기</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div className="thumb lesson">
                        <span className="img"><img src={mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileSer} alt={this.props.title} /></span>
                        <strong className="title"><em>{this.props.title}</em> 멘토가 관심멘토로 등록되었습니다.</strong>
                        <span className="day">{new Date(this.props.day).format('yyyy.MM.dd')}</span>
                        <span className="lesson"><span>{this.props.detail}</span></span>
                        <a href={mentor.contextpath+"/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo="+this.props.key1} className="detail-view">자세히보기</a>
                    </div>
                </li>
      );
    }
});
var InterestList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function(){
        this.getList();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);
        if(mentor.isMobile){
            if(_param.isMore != true){
                this.setState({'data': [],'totalRecordCount':0,'currentPageNo':1});
            }
        }
        $.ajax({
            url: this.props.url,
            data : _param,
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null && rtnData.length > 0){
                    totalCnt = rtnData[0].totalRecordCount;
                }
                if(mentor.isMobile){
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':totalCnt});
                }else{
                    this.setState({data: rtnData,'totalRecordCount':totalCnt, 'currentPageNo':_param.currentPageNo});
                }
            }.bind(this)
        });
    },
    render:function(){
        var interests = this.state.data.map(function(data, index) {
            if(data.type === "JOB"){
                return (
                        <InterestJob fileSer={data.fileSer} title={data.title} detail={data.detail} day={data.regDtm} itrstTargtCd={data.itrstTargtCd} key1={data.key1} key2={data.key2} key3={data.key3} jobPicInfo={data.jobPicInfo} />
                        );
            }else if(data.type === "LECTURE"){
                return (
                        <InterestLecture fileSer={data.fileSer} title={data.title} detail={data.detail} day={data.regDtm} itrstTargtCd={data.itrstTargtCd} key1={data.key1} key2={data.key2} key3={data.key3}/>
                        );
            }else if(data.type === "MENTOR"){
                return (
                        <InterestMentor fileSer={data.fileSer} title={data.title} detail={data.detail} day={data.regDtm} itrstTargtCd={data.itrstTargtCd} key1={data.key1} key2={data.key2} key3={data.key3}/>
                        );
            }
          });

        var paging = [];
        if(mentor.isMobile){
            paging.push(
                <div className="btn-more-view" style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                    <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
                </div>
            );
        }else{
            paging.push(
                <div className="btn-paging">
                  <PageNavi url={this.props.url} pageFunc={goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
                </div>
            );
        }

        return (
    <div>
        <div className="my_interest">
{/*
            <span className="update">
                <span>2015.08.23</span>
                <em>00</em>개 업데이트
            </span>
*/}
            <ul>
                {interests}
            </ul>
        </div>
        {paging}
    </div>
      );
    }
});