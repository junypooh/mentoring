/**
 * 질문답변 react.js
 */
var Article = React.createClass({
    render:function(){
        var timeStr = transSecToTime(this.props.article.cntntsPlayTime);
        var targtCd = this.props.article.lectTargtCd;
        return (
            <li>
                <div className="lesson-info-type">
                    <div className="thumb">
                        <a href={mentor.contextpath+'/lecture/lectureReplay/lectureReplyView.do?arclSer='+this.props.article.arclSer+'&cId='+this.props.article.cntntsId}>
                            <img src={this.props.article.cntntsThumbPath} />
                            <strong className="title">{this.props.article.lectTitle}</strong>
                            <span className="rating">
                                <span className="icon-rating elementary" style={{display:targtCd=='101534'?'':targtCd=='101537'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}>초</span>
                                <span className="icon-rating middle" style={{display:targtCd=='101535'?'':targtCd=='101537'?'':targtCd=='101538'?'':targtCd=='101540'?'':'none'}}>중</span>
                                <span className="icon-rating high" style={{display:targtCd=='101536'?'':targtCd=='101538'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}>고</span>
                            </span>
                            <span className="icon-play">동영상 재생</span>
                        </a>
                    </div>
                    <dl className="info">
                        <dt className="title"><a href={mentor.contextpath+'/lecture/lectureReplay/lectureReplyView.do?arclSer='+this.props.article.arclSer+'&cId='+this.props.article.cntntsId}>{this.props.article.lectTitle}<strong>{this.props.article.mentorMbrNm}</strong></a></dt>
                        <dd className="play-time">
                            <span>재생시간</span>
                            <p>{timeStr}</p>
                        </dd>
                        <dd className="date">
                            <span>일시</span>
                            <p>{this.props.article.lectDay.toDay()} <span className="t-mobile-blind">/</span> <strong>{this.props.article.lectStartTime.toTime() + ' ~ ' + this.props.article.lectEndTime.toTime()}</strong></p>
                        </dd>
                        <dd className="search">
                            <span>조회</span>
                            <p>{this.props.article.vcnt}</p>
                        </dd>
                        <dd className="file-info">
                            <span>파일명</span>
                            <p><span>{this.props.article.title}</span></p>
                        </dd>
                    </dl>
                </div>
            </li>
    );
  }
});

var ReplayList = React.createClass({
  getInitialState: function() {
    return {'bestData' : [], 'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 3, 'currentPageNo' : 1};
  },
  componentDidMount: function() {
      this.getList();
  },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'currentPageNo': this.state.currentPageNo,
      'recordCountPerPage' : this.state.recordCountPerPage,
      'cntntsTargtNo' : cntntsTargtNo,
      'cntntsTargtTims' : cntntsTargtTims,
      'cntntsTargtSeq' : cntntsTargtSeq,
      }, param);
    console.log(_param);
    $.ajax({
        url: this.props.url,
        data : _param,
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var rowCount = 0;
          if(rtnData.length > 0) {
            rowCount = rtnData[0].totalRecordCount;
          }
          if(_param.isMore == true){
              this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }else{
              this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this = this;
    return (
        <div className="lesson-replay-wrap">

          <ul>
              {this.state.data.map(function(article, index){
                  return (<Article key={index} article={article} />)
              })}
          </ul>

          <div className="btn-more-view">
              <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord})} style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
          </div>

        </div>
    );
  }
});

mentor.ReplayList = React.render(
  <ReplayList url={mentor.contextpath+'/community/ajax.arclReplaylList.do'} boardId='lecReplay' />,
  document.getElementById('boardReplayList')
);
