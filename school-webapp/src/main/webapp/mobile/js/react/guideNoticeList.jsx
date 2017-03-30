/**
 * 자료실 react.js
 */

var FileInfo = React.createClass({
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileInfo.fileSer;
  },
  render:function() {
    return(
      <li key={this.props.fileInfo.fileSer}>
        <span className={this.props.classStr}>
          <a href="javascript:void(0)" onClick={this.downloadFile}>{this.props.fileInfo.oriFileNm}</a>
        </span>
        <span className="file-size">{Math.ceil(this.props.fileInfo.fileSize/1024/1024)}MB</span>
      </li>
    );
  }
});

var NoticeInfo = React.createClass({
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.fileDetail)).is(":visible")) {
      $(React.findDOMNode(this.refs.fileDetail)).hide();
      $(".title").removeClass("active");
    } else {
      $(".file-list").hide();
      $(".title").removeClass("active");
      $(React.findDOMNode(this.refs.fileDetail)).parent().find(".title").addClass("active");
      $(React.findDOMNode(this.refs.fileDetail)).show();
    }
  },
  componentDidMount: function() {
      if(this.props.article.arclSer == this.props.selArclSer ){
          this.articleClick();
      }
  },
  downloadAll:function() {
    if(this.props.article.listArclFileInfo.length > 0) {
      location.href = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
    }
  },
  render:function(){
    var fileArcl;
    var totalSize = 0;
    var userClass = "user " + this.props.article.mbrClassNm;
    if(this.props.article.listArclFileInfo.length > 0) {
      fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
        totalSize += file.comFileInfo.fileSize;
        var classStr = "file-type " + file.comFileInfo.fileExt;
        return (
          <FileInfo key={index} classStr={classStr} fileInfo={file.comFileInfo} />
        );
      });
    }
    return (
        <li>
          <div className="title">
            <a href="javascript:void(0);" onClick={this.articleClick}>
              <span className="sort">공지</span>
              <em>{this.props.article.title}</em>
              <span className="r-info">
                <span className="file">파일 첨부</span>
                <span className="date">{(new Date(this.props.article.regDtm)).format("yyyy.MM.dd")}</span>
              </span>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <p className="info">
              {this.props.article.sust.split("\n").map(function(item, index) {
                return(<b>{item}<br /></b>);
              })}
            </p>
            <a href="javascript:void(0);" className="all-down" onClick={this.downloadAll}>전체파일 다운로드</a>
            <ul>
              {fileArcl}
            </ul>
          </div>
        </li>
    );
  }
});

var NoticeList = React.createClass({
  getInitialState: function() {
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':''};
  },
  componentDidMount: function() {
    this.getList();
  },
  getList: function(param) {
    var _param = jQuery.extend({'boardId':this.props.boardId, 'currentPageNo':1, 'recordCountPerPage':10, 'searchKey':0, 'searchWord':''}, param);
    $.ajax({
        url: this.props.url,
        data : _param,
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var rowCount = 0;
          var currentPageNo = 1;
          if(rtnData.length > 0) {
            rowCount = rtnData[0].totalRecordCount;
            currentPageNo = rtnData[0].currentPageNo;
          }
          if(_param.isMore == true){
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this=this;
    return (
        <div>
          <ul className="lesson-data-list notice">
            {this.state.data.map(function(article, index) {
              return (<NoticeInfo key={index} article={article} selArclSer={_this.props.selArclSer}/>);
            })}
          </ul>
          <div className="btn-more-view">
            <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord})} style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
          </div>
        </div>
    );
  }
});

mentor.NoticeList = React.render(
    <NoticeList url={mentor.contextpath+'/community/ajax.arclList.do'} boardId='mtNotice'  selArclSer='<c:out value="${param.arclSer}"/>' />,
    document.getElementById('boardNoticeList')
  );