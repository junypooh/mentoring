/**
 * 자료실 react.js
 */

var Article = React.createClass({
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.fileDetail)).is(":visible")) {
      $(React.findDOMNode(this.refs.fileDetail)).hide("fast");
      $(".title").removeClass("active");
    } else {
      $(".file-list").hide("fast");
      $(".title").removeClass("active");
      $(React.findDOMNode(this.refs.fileDetail)).parent().find(".title").addClass("active");
      $(React.findDOMNode(this.refs.fileDetail)).show("fast");
    }
  },
  componentDidMount: function() {
      if(this.props.arclSer == this.props.selArclSer ){
          //this.articleClick();
      }
  },
  render:function(){
    var fileArcl;
    var totalSize = 0;
    var userClass = "user " + this.props.article.mbrClassNm;
    if(this.props.article.listArclFileInfo.length > 0) {
      fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
        totalSize += file.comFileInfo.fileSize;
        var classStr = "file-type " + file.comFileInfo.fileExt.changeExt();
        var fileDown = mentor.contextpath+"/fileDown.do?fileSer="+file.fileSer;
        return (
          <li key={index}>
            <span className={classStr}>
              <a href={fileDown}>{file.comFileInfo.fileNm}</a>
            </span>
            <span className="file-size">{Math.ceil(file.comFileInfo.fileSize/1024/1024)}MB</span>
          </li>
        );
      });
    }
    var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+this.props.article.cntntsTargtNo+"&lectTims=1&schdSeq=1";
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;
    var downAll = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
    return (
        <li>
          <div className="title">
            <a href="javascript:void(0)" onClick={this.articleClick}>
              <em>{this.props.article.title}</em>
              <div>
                <span className="file">{this.props.article.listArclFileInfo.length} 개 ({Math.ceil(totalSize/1024/1024)}MB)</span>
              </div>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <div className="relation-lesson">
              <span><strong>관련수업</strong><a href={lectureUrl} target="_self" title="새창열림">{this.props.article.lectTitle}</a></span>
            </div>
            <a href={downAll} className="all-down" style={{display:(this.props.article.listArclFileInfo.length == 0?'none':'')}} >전체파일 다운로드</a>
            <ul>
              {fileArcl}
            </ul>
          </div>
        </li>
    );
  }
});

var ArticleList = React.createClass({
  render:function(){
    var _this=this;
    var articleList = this.props.articles.map(function(article, index) {
      return (
          <Article key={index} article={article} />
      );
    });
    return (
        <ul className="lesson-data-list">
          {articleList}
        </ul>
    );
  }
});

var DataList = React.createClass({
  getInitialState: function() {
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':''};
  },
  componentDidMount: function() {
    this.getList();
  },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'dispNotice' : false,
      'currentPageNo':1,
      'recordCountPerPage':10,
      'searchKey':0,
      'searchWord':'',
      'srchMbrNo':mentorMbrNo
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
    return (
        <div>
          <ArticleList articles={this.state.data} boardId={this.props.boardId} selArclSer={this.props.selArclSer}/>
          <div className="btn-more-view">
            <a href="javascript:void(0)" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord})} style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
          </div>
        </div>
    );
  }
});

mentor.DataList = React.render(
        <DataList url={mentor.contextpath+'/community/ajax.arclList.do'} boardId='lecFile' />,
        document.getElementById('tab-files')
);
