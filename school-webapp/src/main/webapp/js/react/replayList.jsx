/**
 * 질문답변 react.js
 */

var BestArticle = React.createClass({
    render:function(){
        var classStr = "best-lesson ";
        if(this.props.seq == 1) {
            classStr += "first";
        } else if(this.props.seq == 3) {
            classStr += "last";
        }
        var timeStr = hhmmssFormat(this.props.article.cntntsPlayTime);
        var targtCd = this.props.article.lectTargtCd;
        var lectUrl = mentor.contextpath+'/lecture/lectureTotal/lectureView.do?lectSer='+this.props.article.cntntsTargtNo+'&lectTims='+this.props.article.cntntsTargtTims+'&schdSeq='+this.props.article.cntntsTargtSeq;
        return (
            <li className="best-lesson">
                <div className="lesson-info-type">
                    <div className="thumb">
                        <a href={'lectureReplyView.do?arclSer='+this.props.article.arclSer+'&cId='+this.props.article.cntntsId}>
                            <img src={this.props.article.cntntsThumbPath} alt={this.props.article.lectTitle}/>
                            <strong className="title">{this.props.article.lectTitle}</strong>
                            <span className="ranking"><span>재생 순위 1</span></span>
                            <span className="rating">
                                <span className="icon-rating elementary" style={{display:targtCd=='101534'?'':targtCd=='101537'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}>초</span>
                                <span className="icon-rating middle" style={{display:targtCd=='101535'?'':targtCd=='101537'?'':targtCd=='101538'?'':targtCd=='101540'?'':'none'}}>중</span>
                                <span className="icon-rating high" style={{display:targtCd=='101536'?'':targtCd=='101538'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}>고</span>
                            </span>
                            <span className="icon-play">동영상 재생</span>
                        </a>
                    </div>
                    <dl className="info">
                        <dt className="title"><a href={lectUrl}>{this.props.article.lectTitle}<strong>{this.props.article.mentorMbrNm}</strong></a></dt>
                        <dd className="play-time">
                            <span>재생시간</span>
                            <p>{timeStr}</p>
                        </dd>
                        <dd className="date">
                            <span>일시</span>
                            <p>{this.props.article.lectDay.toDay()} <span className="t-mobile-blind">/</span> <strong>{this.props.article.lectStartTime.toTime() + '~' + this.props.article.lectEndTime.toTime()}</strong></p>
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

var Article = React.createClass({
    render:function(){
        var timeStr = hhmmssFormat(this.props.article.cntntsPlayTime);
        var targtCd = this.props.article.lectTargtCd;
        var lectUrl = mentor.contextpath+'/lecture/lectureTotal/lectureView.do?lectSer='+this.props.article.cntntsTargtNo+'&lectTims='+this.props.article.cntntsTargtTims+'&schdSeq='+this.props.article.cntntsTargtSeq;
        return (
            <li>
                <div className="lesson-info-type">
                    <div className="thumb">
                        <a href={'lectureReplyView.do?arclSer='+this.props.article.arclSer+'&cId='+this.props.article.cntntsId}>
                            <img src={this.props.article.cntntsThumbPath} alt={this.props.article.lectTitle}/>
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
                        <dt className="title"><a href={lectUrl}>{this.props.article.lectTitle}<strong>{this.props.article.mentorMbrNm}</strong></a></dt>
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
    return {'bestData' : [], 'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 6, 'currentPageNo' : 1};
  },
  componentDidMount: function() {
      this.getBestList();
      this.getList();
  },
  getBestList: function(param) {
      $.ajax({
          url: this.props.url,
          data : {
              boardId : this.props.boardId,
              recordCountPerPage : 3,
              currentPageNo : 1,
              bestYn : 'Y'
          },
          contentType: "application/json",
          dataType: 'json',
          cache: false,
          success: function(rtnData) {
            var rowCount = 0;
            if(rtnData.length > 0) {
              rowCount = rtnData[0].totalRecordCount;
            }
            this.setState({bestData: rtnData});
          }.bind(this),
          error: function(xhr, status, err) {
            console.error(this.props.url, status, err.toString());
          }.bind(this)
      });
    },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'currentPageNo': this.state.currentPageNo,
      'clasStartDay':$("#clasStartDay").val(),
      'clasEndDay':$("#clasEndDay").val(),
      'lectTargtCd':$("#lectTargtCd").val(),
      'lectTime':$("#lectTime").val(),
      'lectTypeCd':$("#lectTypeCd").val(),
      'searchKey':$("#searchKey").val(),
      'searchWord':$("#searchWord").val(),
      'sJobChrstcCds' : sJobChrstcCds,
      'sJobNo' : sJobNo
      }, param);
    $.ajax({
        url: this.props.url,
        data : $.param(_param, true),
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var rowCount = 0;
          if(rtnData.length > 0) {
            rowCount = rtnData[0].totalRecordCount;
          }
          if(mentor.isMobile){
              if(_param.isMore == true){
                  this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
              }else{
                  this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
              }
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this = this;
    var paging = [];
    if(mentor.isMobile){
        paging.push(
              <div className="btn-more-view">
                  <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord})} style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
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
        <div className="lesson-replay-wrap" >

          <ul className="best-lesson">
              {this.state.bestData.map(function(article, index){
                  return (<BestArticle key={index} article={article} seq={index} />)
              })}
          </ul>

          <ul>
              {this.state.data.map(function(article, index){
                  return (<Article key={index} article={article} />)
              })}
          </ul>

          {paging}

        </div>
    );
  }
});

mentor.ReplayList = React.render(
  <ReplayList url={mentor.contextpath+'/community/ajax.arclReplaylList.do'} boardId='lecReplay' isMobile={mentor.isMobile}/>,
  document.getElementById('replayList')
);



