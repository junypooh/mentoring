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
          React.createElement("li", {key: index}, 
            React.createElement("span", {className: classStr}, 
              React.createElement("a", {href: "javascript:void(0);", onClick: _this._downLoad.bind(this, downUrl)}, file.comFileInfo.oriFileNm)
            ), 
            React.createElement("span", {className: "file-size"}, Math.ceil(file.comFileInfo.fileSize/1024/1024), "MB")
          )
        );
      });
    }
    var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+this.props.article.cntntsTargtNo+"&lectTims=1&schdSeq=1";
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;
    var downAllUrl = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;

    var prefNm = "";
    switch(this.props.article.prefNo){
    case 'beforeData':
        prefNm = React.createElement("b", null, "[사전보조자료]");
        break;
    case 'afterData':
        prefNm = React.createElement("b", null, "[사후보조자료]");
        break;
    case 'etcData':
        prefNm = React.createElement("b", null, "[기타자료]");
        break;
    case 'lectData':
        prefNm = React.createElement("b", null, "[수업보조자료]");
        break;
    default:
        prefNm = "";
    }

    var cntntsTypeNm = "";
    switch(this.props.article.cntntsTypeCd){
    case '101534':
        cntntsTypeNm = React.createElement("span", {className: "icon-rating elementary"}, "초");
        break;
    case '101535':
        cntntsTypeNm = React.createElement("span", {className: "icon-rating middle"}, "중");
        break;
    case '101536':
        cntntsTypeNm = React.createElement("span", {className: "icon-rating high"}, "고");
        break;
    case '101537':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating elementary"}, "초"), React.createElement("span", {className: "icon-rating middle"}, "중"));
        break;
    case '101538':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating middle"}, "중"), React.createElement("span", {className: "icon-rating high"}, "고"));
        break;
    case '101539':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating elementary"}, "초"), React.createElement("span", {className: "icon-rating high"}, "고"));
        break;
    case '101540':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating elementary"}, "초"), React.createElement("span", {className: "icon-rating middle"}, "중"), React.createElement("span", {className: "icon-rating high"}, "고"));
        break;
    default:
        cntntsTypeNm = "";
    }
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
              React.createElement("em", {style: {width:'510px'}}, prefNm, this.props.article.title), 
              cntntsTypeNm, 
              React.createElement("div", null, 
                React.createElement("span", {className: userClass}, this.props.article.regMbrNm), 
                React.createElement("span", {className: "file"}, this.props.article.listArclFileInfo.length, " 개 (", Math.ceil(totalSize/1024/1024), "MB)")
              )
            )
          ), 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("div", {className: "relation-lesson"}, 
              React.createElement("span", null, React.createElement("strong", null, "관련수업"), React.createElement("a", {href: lectureUrl, target: "_self", title: "새창열림"}, this.props.article.cntntsTargtNm)), 
              React.createElement("span", null, React.createElement("strong", null, "직업"), React.createElement("a", {href: jobUrl, target: "_self", title: "새창열림"}, this.props.article.jobNm))
            ), 
            React.createElement("a", {href: "javascript:void(0);", onClick: _this._downLoadAll.bind(this, downAllUrl), className: "all-down", style: {display:(this.props.article.listArclFileInfo.length < 1?'none':'')}}, "전체파일 다운로드"), 
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
          React.createElement(Article, {key: index, article: article, selArclSer: _this.props.selArclSer, sMbrNo: _this.props.sMbrNo})
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
        React.createElement("div", null, 
          React.createElement(ArticleList, {articles: this.state.data, boardId: this.props.boardId, selArclSer: this.props.selArclSer, sMbrNo: this.props.sMbrNo}), 
          React.createElement(PageNavi, {
                                      url: this.props.url, 
                                      pageFunc: this.goPage, 
                                      totalRecordCount: this.state.totalRecordCount, 
                                      currentPageNo: this.state.currentPageNo, 
                                      recordCountPerPage: this.state.recordPerPage, 
                                      pageSize: this.props.pageSize, 
                                      contextPath: this.props.contextPath})
        )
    );
  }
});