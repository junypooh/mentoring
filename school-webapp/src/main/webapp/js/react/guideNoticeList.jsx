/**
 * 자료실 react.js
 */

var FileInfo = React.createClass({
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?origin=true&fileSer="+this.props.fileInfo.fileSer;
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
        var classStr = "file-type " + file.comFileInfo.fileExt.changeExt();
        return (
          <FileInfo key={index} classStr={classStr} fileInfo={file.comFileInfo} />
        );
      });
    }

    var newIconHtml = "";
    if(this.props.article.newYn == "Y") {
        var imgPath = mentor.contextpath + '/images/lesson/icon_new.png';
        newIconHtml = <img src={imgPath} alt='new' />;
    }
    return (
        <li>
          <div className={(this.props.article.notiYn == "Y")?"title notice":"title"}>
            <a href="javascript:void(0);" onClick={this.articleClick}>
              <span className={(this.props.article.notiYn == "Y")?"sort":"num"}>{this.props.article.notiYn == "Y"?"공지":this.props.totalRecordCount - this.props.article.rn + 1}</span>
              <em>{this.props.article.title} {newIconHtml}</em>
              <span className="r-info">
                <span className="file" style={{display:(this.props.article.listArclFileInfo.length == 0)?'none':''}}>{this.props.article.listArclFileInfo.length} 파일 첨부</span>
                <span className="date">{(new Date(this.props.article.regDtm)).format("yyyy.MM.dd")}</span>
              </span>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <div className="info" dangerouslySetInnerHTML={{__html : this.props.article.sust+""}} />
            <a href="javascript:void(0);" className="all-down" style={{display:(this.props.article.listArclFileInfo.length == 0)?'none':''}} onClick={this.downloadAll}>전체파일 다운로드</a>
            <ul style={{display:(this.props.article.listArclFileInfo.length == 0)?'none':''}}>
              {fileArcl}
            </ul>
          </div>
        </li>
    );
  }
});

var NoticeList = React.createClass({
  getInitialState: function() {
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':'','recordPerPage':10,'currentPageNo':1,'noticeData':[]};
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
        'expsTargtCd' : '101635'
    }, param);
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
            currentPageNo = this.state.currentPageNo ? this.state.currentPageNo : rtnData[0].currentPageNo;

          }



          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          /*
          if(_param.isMore == true){
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':currentPageNo+1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
          */
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this=this;
    var totalRecordCount = this.state.totalRecordCount;
    return (
        <div>
          <ul className="lesson-data-list notice">
            {this.state.data.map(function(article, index) {
              return (<NoticeInfo key={index} article={article} selArclSer={_this.props.selArclSer} totalRecordCount={totalRecordCount}/>);
            })}
          </ul>
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