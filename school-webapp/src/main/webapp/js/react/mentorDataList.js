/**
 * 자료실 react.js
 */

var Article = React.createClass({displayName: "Article",
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
          React.createElement("li", {key: index}, 
            React.createElement("span", {className: classStr}, 
              React.createElement("a", {href: fileDown}, file.comFileInfo.fileNm)
            ), 
            React.createElement("span", {className: "file-size"}, Math.ceil(file.comFileInfo.fileSize/1024/1024), "MB")
          )
        );
      });
    }
    var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+this.props.article.cntntsTargtNo+"&lectTims=1&schdSeq=1";
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;
    var downAll = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0)", onClick: this.articleClick}, 
              React.createElement("em", null, this.props.article.title), 
              React.createElement("div", null, 
                React.createElement("span", {className: "file"}, this.props.article.listArclFileInfo.length, " 개 (", Math.ceil(totalSize/1024/1024), "MB)")
              )
            )
          ), 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("div", {className: "relation-lesson"}, 
              React.createElement("span", null, React.createElement("strong", null, "관련수업"), React.createElement("a", {href: lectureUrl, target: "_self", title: "새창열림"}, this.props.article.lectTitle))
            ), 
            React.createElement("a", {href: downAll, className: "all-down", style: {display:(this.props.article.listArclFileInfo.length == 0?'none':'')}}, "전체파일 다운로드"), 
            React.createElement("ul", null, 
              fileArcl
            )
          )
        )
    );
  }
});

var ArticleList = React.createClass({displayName: "ArticleList",
  render:function(){
    var _this=this;
    var articleList = this.props.articles.map(function(article, index) {
      return (
          React.createElement(Article, {key: index, article: article})
      );
    });
    return (
        React.createElement("ul", {className: "lesson-data-list"}, 
          articleList
        )
    );
  }
});

var DataList = React.createClass({displayName: "DataList",
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
        React.createElement("div", null, 
          React.createElement(ArticleList, {articles: this.state.data, boardId: this.props.boardId, selArclSer: this.props.selArclSer}), 
          React.createElement("div", {className: "btn-more-view"}, 
            React.createElement("a", {href: "javascript:void(0)", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord}), style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, "더 보기 (", React.createElement("span", null, this.state.totalRecordCount-this.state.data.length), ")")
          )
        )
    );
  }
});

mentor.DataList = React.render(
        React.createElement(DataList, {url: mentor.contextpath+'/community/ajax.arclList.do', boardId: "lecFile"}),
        document.getElementById('tab-files')
);
