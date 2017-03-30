/**
 * 자료실 react.js
 */

var FileInfo = React.createClass({displayName: "FileInfo",
//  downloadFile:function() {
//    location.href = mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileInfo.fileSer;
//  },
  render:function() {
    return(
      React.createElement("li"//, {key: this.props.fileInfo.fileSer}, 
//        React.createElement("span", {className: this.props.classStr}, 
//          React.createElement("a", {href: "javascript:void(0)", onClick: this.downloadFile}, this.props.fileInfo.oriFileNm)
//        ), 
//        React.createElement("span", {className: "file-size"}, Math.ceil(this.props.fileInfo.fileSize/1024/1024), "MB")
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
//  downloadAll:function() {
//    if(this.props.article.listArclFileInfo.length > 0) {
//      location.href = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
//    }
//  },
  render:function(){
    var fileArcl;
    var totalSize = 0;
    var userClass = "user " + this.props.article.mbrClassNm;
    if(this.props.article.listArclFileInfo.length > 0) {
      fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
        totalSize += file.comFileInfo.fileSize;
        var classStr = "file-type " + file.comFileInfo.fileExt;
        return (
          React.createElement(FileInfo/*, {key: index, classStr: classStr, fileInfo: file.comFileInfo}*/)
        );
      });
    }
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
            		React.createElement("em", null,React.createElement("span", {className: "sort"}, "공지 "),this.props.article.title),
//            		React.createElement("em", null,
//            				React.createElement("span", {className: "sort"}, "공지",React.createElement("em", null, this.props.article.title))),
//              React.createElement("span", {className: "sort"}, "공지"), 
//              React.createElement("em", null, this.props.article.title), 
              React.createElement("span", {className: "r-info"}
//              , 
//                React.createElement("span", {className: "file"}, "파일 첨부"), 
//                React.createElement("span", {className: "date"}, (new Date(this.props.article.regDtm)).format("yyyy.MM.dd"))
              )
            )
          )
          
          , 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("div", {className: "info", dangerouslySetInnerHTML: {__html : this.props.article.sust+""}})//,
            /*React.createElement("a", {href: "javascript:void(0);", className: "all-down", style: {display:(this.props.article.listArclFileInfo.length == 0)?'none':''}, onClick: this.downloadAll}, "전체파일 다운로드"),
            React.createElement("ul", {style: {display:(this.props.article.listArclFileInfo.length == 0)?'none':''}},
              fileArcl
            )*/
          )
          
//          , 
//          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
//            React.createElement("div", {className: "info", dangerouslySetInnerHTML: {__html : this.props.article.sust+""}}),
//            React.createElement("a", {href: "javascript:void(0);", className: "all-down", style: {display:(this.props.article.listArclFileInfo.length == 0)?'none':''}, onClick: this.downloadAll}, "전체파일 다운로드"),
//            React.createElement("ul", {style: {display:(this.props.article.listArclFileInfo.length == 0)?'none':''}},
//              fileArcl
//            )
//          )
        )
    );
  }
});

var NoticeList = React.createClass({displayName: "NoticeList",
  getInitialState: function() {
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':''};
  },
  componentDidMount: function() {
    this.getList();
  },
  getList: function(param) {
    var _param = jQuery.extend({
        'boardId':this.props.boardId,
        'currentPageNo':1,
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
        React.createElement("div", null, 
          React.createElement("ul", {className: "norice-list notice"}, 
            this.state.data.map(function(article, index) {
              return (React.createElement(NoticeInfo, {key: index, article: article, selArclSer: _this.props.selArclSer}));
            })
          ), 
          React.createElement("div", {className: "btn-more"},
            React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord}), style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, "더 보기", React.createElement("strong", null, " ("), React.createElement("strong", null, this.state.totalRecordCount-this.state.data.length), React.createElement("strong", null, ")"))
          )
        )
    );
  }
});

mentor.NoticeList = React.render(
    React.createElement(NoticeList, {url: mentor.contextpath+'/community/ajax.arclList.do', boardId: "mtNotice", selArclSer: "<c:out value=\"${param.arclSer}\"/>"}),
    document.getElementById('boardNoticeList')
  );