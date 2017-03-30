/**
 * 자료실 react.js
 */

var FileInfo = React.createClass({displayName: "FileInfo",
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?origin=true&fileSer="+this.props.fileInfo.fileSer;
  },
  render:function() {
    return(
      React.createElement("li", {key: this.props.fileInfo.fileSer}, 
        React.createElement("span", {className: this.props.classStr}, 
          React.createElement("a", {href: "javascript:void(0)", onClick: this.downloadFile}, this.props.fileInfo.oriFileNm)
        ), 
        React.createElement("span", {className: "file-size"}, Math.ceil(this.props.fileInfo.fileSize/1024/1024), "MB")
      )
    );
  }
});

var NoticeInfo = React.createClass({displayName: "NoticeInfo",
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
          React.createElement(FileInfo, {key: index, classStr: classStr, fileInfo: file.comFileInfo})
        );
      });
    }

    var newIconHtml = "";
    if(this.props.article.newYn == "Y") {
        var imgPath = mentor.contextpath + '/images/community/icon_new.png';
        newIconHtml = React.createElement("img", {src: imgPath, alt: "new"});
    }
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
              React.createElement("span", {className: "num"}, React.createElement("span", {className: "notice", style: {display:(this.props.article.notiYn == "Y")?"":"none"}}, "공지"), this.props.article.notiYn == "Y"?"":this.props.totalCnt - this.props.article.rn + 1), 
              React.createElement("em", {className: "title notice"}, this.props.article.title, " ", newIconHtml), 
              React.createElement("span", {className: "day"}, (new Date(this.props.article.regDtm)).format("yyyy.MM.dd"))
            )
          ), 
          React.createElement("div", {className: "text-editer"}, 
            React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
              React.createElement("p", {dangerouslySetInnerHTML: {__html : this.props.article.sust+""}}), 
              React.createElement("div", {className: "file-down"}, 
                React.createElement("span", {className: "left"}, 
                  (this.props.article.listArclFileInfo.length > 0)? React.createElement("a", {href: "javascript:void(0);", className: "all-file-down", onClick: this.downloadAll}, "전체파일 다운로드") : ""
                )
              ), 
              React.createElement("ul", null, 
                fileArcl
              )
            )
          )
        )
    );
  }
});

var NoticeList = React.createClass({displayName: "NoticeList",
  getInitialState: function() {
    return {'data': [], 'currentPageNo':1, 'totalRecordCount':0, 'searchKey':0, 'searchWord':'', totalCnt : 0, 'recordCountPerPage': 0};
  },
  componentDidMount: function() {
    this.getList();
  },
  goPage:function(pageNo) {
    var param = {currentPageNo : pageNo};
    this.getList(param);
  },
  getList: function(param) {
    var _param = jQuery.extend({
        'boardId':this.props.boardId,
        'currentPageNo':1,
        'recordCountPerPage':10,
        'searchKey':0,
        'searchWord':'',
        'expsTargtCd' : '101636'
    }, param);
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
            currentPageNo = rtnData[0].currentPageNo;
          }
          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo,'recordCountPerPage':10,'searchKey':_param.searchKey, 'searchWord':_param.searchWord, totalCnt : rowCount});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this=this;
    return (
        React.createElement("div", {className: "lesson-task data"}, 
          React.createElement("ul", {className: "lesson-data-list userguide"}, 
            this.state.data.map(function(article, index) {
              return (React.createElement(NoticeInfo, {key: index, article: article, selArclSer: _this.props.selArclSer, totalCnt: _this.state.totalCnt}));
            })
          ), 

          React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage})

        )
    );
  }
});
    var params = document.body.getElementsByTagName('script');
    var query = params[2].className.split(" ");
    var paramArclSer = query[0];
mentor.NoticeList = React.render(
  /* <NoticeList url={mentor.contextpath+'/community/ajax.arclList.do'} boardId='mtNotice'  selArclSer={paramArclSer} />, */
  React.createElement(NoticeList, {url: mentor.contextpath+'/useGuide/ajax.arclListWithNotice.do', boardId: "mtNotice", selArclSer: paramArclSer}),
  document.getElementById('boardNoticeList')
);