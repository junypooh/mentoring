/**
 * 자주 찾는 질문 게시판 react.js
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

var ArticleInfo = React.createClass({displayName: "ArticleInfo",
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.detail)).is(":visible")) {
      $(React.findDOMNode(this.refs.detail)).hide();
      $(".writing-list li").removeClass("active");
    } else {
      $(".subject-detail").hide();
      $(".writing-list li").removeClass("active");
      $(React.findDOMNode(this.refs.detail)).parent().addClass("active");
      $(React.findDOMNode(this.refs.detail)).show();
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
  downloadAll:function() {
      if(this.props.article.listArclFileInfo.length > 0) {
          location.href = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
      }
  },
  render:function(){
    var userClass = "user " + this.props.article.mbrClassNm;
    var ansClass = "none";
    var ansClass2 = "question-detail no-answer";
    var ansSust = "";
    var modClass = "none";
    if(this.props.article.regMbrNo == this.props.mbrNo) {
      modClass = "";
    }
    if(this.props.article.ansArclInfo) {
      ansSust = this.props.article.ansArclInfo.sust;
      ansClass = "";
      ansClass2 = "question-detail";
    } else {
      modClass = "";
    }
    var fileArcl;
    if(this.props.article.listArclFileInfo.length > 0) {
        fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
            var classStr = "file-type " + file.comFileInfo.fileExt.changeExt();
            return (
              React.createElement(FileInfo, {key: index, classStr: classStr, fileInfo: file.comFileInfo})
            );
        });
    }
    return (
      React.createElement("li", {key: this.props.article.arclSer}, 
        React.createElement("div", {className: "subject-info"}, 
          React.createElement("span", {className: "sort"}, this.props.article.prefNm), 
          React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick, className: "subject"}, this.props.article.title)
        ), 
        React.createElement("div", {className: "subject-detail", ref: "detail"}, 
          React.createElement("div", {className: "question-detail"}, 
            React.createElement("div", {className: "answer"}, 
              React.createElement("span", {className: "title"}, "답변"), 
              React.createElement("div", {className: "info", dangerouslySetInnerHTML: {__html : this.props.article.cntntsSust+""}}), 
              React.createElement("div", {className: "file-list"}, 
                React.createElement("a", {href: "javascript:void(0);", className: "all-down", style: {display:(this.props.article.listArclFileInfo.length == 0)?'none':''}, onClick: this.downloadAll}, "전체파일 다운로드"), 
                React.createElement("ul", null, 
                    fileArcl
                )
              )
            )
          )
        )
      )
    );
  }
});

var FaqList = React.createClass({displayName: "FaqList",
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'searchKey' : 0, 'searchWord' : '', 'prefNo' : '', 'scrtArclYn' : '', 'prefNo' : '','recordPerPage':10,'currentPageNo':1};
  },
  componentDidMount: function() {
    this.getList();
  },
  goPage:function(pageNo) {
        param = {'currentPageNo': pageNo};
        this.getList(param);
      },
  getList: function(param) {
    var _param = jQuery.extend({
        'boardId':this.props.boardId,
        'currentPageNo':this.state.currentPageNo,
        'recordCountPerPage':10,
        'searchKey':this.state.searchKey,
        'searchWord':this.state.searchWord,
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
            currentPageNo = _param.currentPageNo;
          }
          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
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
    return (
        React.createElement("div", null, 
          React.createElement("ul", {className: "writing-list faq"}, 
            this.state.data.map(function(article, index) {
                return (React.createElement(ArticleInfo, {key: index, article: article, selArclSer: _this.props.selArclSer}));
              }
            )
          ), 
          React.createElement(PageNavi, {
                                                url: this.props.url, 
                                                pageFunc: this.goPage, 
                                                totalRecordCount: this.state.totalRecordCount, 
                                                currentPageNo: this.state.currentPageNo, 
                                                recordCountPerPage: this.state.recordPerPage, 
                                                pageSize: this.props.pageSize, 
                                                contextPath: this.props.context})
        )
    );
  }
});