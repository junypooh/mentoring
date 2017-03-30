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
      this.addCnt();
    }
  },
  componentDidMount: function() {
      if(this.props.article.arclSer == this.props.selArclSer ){
          this.articleClick();
      }
  },
  addCnt:function(){
      $.ajax({
          url: mentor.contextpath+"/community/ajax.addVcnt.do",
          data : {arclSer : this.props.article.arclSer},
          contentType: "application/json",
          dataType: 'json',
          cache: false,
          success: function(rtnData) {}
      });
  },
  _downLoad:function(url) {
    if(this.props.sMbrNo === 'null') {
        alert("로그인이 필요한 서비스 입니다.");
        location.href = mentor.contextpath+"/login.do";
        return false;
    } else {
        location.href = url;
    }
  },
  _downLoadAll:function(url) {
    if(this.props.sMbrNo === 'null') {
        alert("로그인이 필요한 서비스 입니다.");
        location.href = mentor.contextpath+"/login.do";
        return false;
    } else {
        location.href = url;
    }
  },
  render:function(){
    var fileArcl;
    var totalSize = 0;
    var userClass = "user " + this.props.article.mbrClassNm;
    var _this = this;
    if(this.props.article.listArclFileInfo.length > 0) {
      fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
        totalSize += file.comFileInfo.fileSize;
        var classStr = "file-type " + file.comFileInfo.fileExt.changeExt();
        var downUrl = mentor.contextpath+"/fileDown.do?origin=true&fileSer="+file.fileSer;
        return (
          <li key={index}>
            <span className={classStr}>
              <a href="javascript:void(0);" onClick={_this._downLoad.bind(this, downUrl)}>{file.comFileInfo.oriFileNm}</a>
            </span>
            <span className="file-size">{Math.ceil(file.comFileInfo.fileSize/1024/1024)}MB</span>
          </li>
        );
      });
    }
    var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+this.props.article.cntntsTargtNo+"&lectTims=1&schdSeq=1";
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;
    var downAllUrl = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;

    var prefNm = "";
    switch(this.props.article.prefNo){
    case 'beforeData':
        prefNm = <b>[사전보조자료]</b>;
        break;
    case 'afterData':
        prefNm = <b>[사후보조자료]</b>;
        break;
    case 'etcData':
        prefNm = <b>[기타자료]</b>;
        break;
    case 'lectData':
        prefNm = <b>[수업보조자료]</b>;
        break;
    default:
        prefNm = "";
    }

    var cntntsTypeNm = "";
    switch(this.props.article.cntntsTypeCd){
    case '101534':
        cntntsTypeNm = <span className='icon-rating elementary'>초</span>;
        break;
    case '101535':
        cntntsTypeNm = <span className='icon-rating middle'>중</span>;
        break;
    case '101536':
        cntntsTypeNm = <span className='icon-rating high'>고</span>;
        break;
    case '101537':
        cntntsTypeNm = <span><span className='icon-rating elementary'>초</span><span className='icon-rating middle'>중</span></span>;
        break;
    case '101538':
        cntntsTypeNm = <span><span className='icon-rating middle'>중</span><span className='icon-rating high'>고</span></span>;
        break;
    case '101539':
        cntntsTypeNm = <span><span className='icon-rating elementary'>초</span><span className='icon-rating high'>고</span></span>;
        break;
    case '101540':
        cntntsTypeNm = <span><span className='icon-rating elementary'>초</span><span className='icon-rating middle'>중</span><span className='icon-rating high'>고</span></span>;
        break;
    default:
        cntntsTypeNm = "";
    }
    return (
        <li>
          <div className="title">
            <a href="javascript:void(0);" onClick={this.articleClick}>
              <em style={{width:'510px'}}>{prefNm}{this.props.article.title}</em>
              {cntntsTypeNm}
              <div>
                <span className={userClass}>{this.props.article.regMbrNm}</span>
                <span className="file">{this.props.article.listArclFileInfo.length} 개 ({Math.ceil(totalSize/1024/1024)}MB)</span>
              </div>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <div className="relation-lesson">
              <span><strong>관련수업</strong><a href={lectureUrl} target="_self" title="새창열림">{this.props.article.cntntsTargtNm}</a></span>
              <span><strong>직업</strong><a href={jobUrl} target="_self" title="새창열림">{this.props.article.jobNm}</a></span>
            </div>
            <a href="javascript:void(0);" onClick={_this._downLoadAll.bind(this, downAllUrl)} className="all-down" style={{display:(this.props.article.listArclFileInfo.length < 1?'none':'')}}>전체파일 다운로드</a>
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
          <Article key={index} article={article} selArclSer={_this.props.selArclSer} sMbrNo={_this.props.sMbrNo}/>
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
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':'','recordPerPage':10,'currentPageNo':1};
  },
  componentDidMount: function() {
    this.getList();
  },
  goPage:function(pageNo) {
      this.getList({'currentPageNo': pageNo});
    },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'currentPageNo':this.state.currentPageNo,
      'recordCountPerPage':10,
      'searchKey':0,
      'searchWord':'',
      'sJobChrstcCds' : sJobChrstcCds,
      'sJobNo' : sJobNo,
      'dispNotice' : false
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
          //if(_param.isMore == true){
            //this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          /*
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
          */
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    return (
        <div>
          <ArticleList articles={this.state.data} boardId={this.props.boardId} selArclSer={this.props.selArclSer} sMbrNo={this.props.sMbrNo}/>
          <PageNavi
                                      url={this.props.url}
                                      pageFunc={this.goPage}
                                      totalRecordCount={this.state.totalRecordCount}
                                      currentPageNo={this.state.currentPageNo}
                                      recordCountPerPage={this.state.recordPerPage}
                                      pageSize={this.props.pageSize}
                                      contextPath={this.props.contextPath} />
        </div>
    );
  }
});