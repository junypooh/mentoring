/**
 * 자료실 react.js
 */

var FileInfo = React.createClass({displayName: "FileInfo",
  downloadFile:function() {

      if(userId == ""){
            location.href = mentor.contextpath+"/login.do";
        }else{
            location.href = mentor.contextpath+"/fileDown.do?fileSer="+this.props.file.fileSer;
        }
  },
  render:function() {
    return (
      React.createElement("li", {key: this.props.file.fileSer}, 
        React.createElement("span", {className: this.props.classStr}, 
          React.createElement("a", {href: "javascript:void(0)", onClick: this.downloadFile}, this.props.file.oriFileNm)
        ), 
        React.createElement("span", {className: "file-size"}, Math.ceil(this.props.file.fileSize/1024/1024), "MB")
      )
    );
  }
});

var Article = React.createClass({displayName: "Article",
  articleClick:function(e){
  var fileDetail = $(React.findDOMNode(this.refs.fileDetail));
    if(fileDetail.is(":visible")) {
      fileDetail.hide();
      $(".title").parent().removeClass("active");
    } else {
      $(".file-list").hide();
      $(".title").parent().removeClass("active");
      fileDetail.parent().addClass("active");
      fileDetail.show();
    }
  },
  componentDidMount: function() {

  },
  openLayer:function(e) {
    this.props.openLayer(e, this.props.article);
  },
  windowPopupMoviePlay: function(titleNm, cId) {
      if(cId == 0 || cId == null){
        alert("동영상이 등록되지 않았습니다");
        return false;
      }
      var url = mentor.contextpath + "/lecture/lectureTotal/popupMoviePlay.do?title=" + titleNm + "&cId=" + cId;
      var popobj = window.open(url, 'popupMoviePlay', 'width=700, height=670, menubar=no, status=no, toolbar=no');
      popobj.focus();
  },
  render:function(){
    var fileArcl = [];
    var totalSize = 0;

    if(this.props.article.dataTypeCd == "101759"){
        totalSize += this.props.article.comFileInfo.fileSize;
        var classStr = "file-type " + this.props.article.comFileInfo.fileExt.changeExt();
        fileArcl.push(React.createElement(FileInfo, {classStr: classStr, file: this.props.article.comFileInfo}));
    }else if(this.props.article.dataTypeCd == "101760") {
        fileArcl.push(
                      React.createElement("li", null, 
                        React.createElement("span", {className: "file-type avi"}, 
                          React.createElement("a", {href: "javascript:void(0)", onClick: this.windowPopupMoviePlay.bind(this, this.props.article.dataNm, this.props.article.cntntsId)}, "media file.mp4")
                        ), 
                        React.createElement("span", {className: "file-size"}, Math.ceil(this.props.article.cntntsPlayTime), "분")
                      )
                  );
    }else if(this.props.article.dataTypeCd == "101761") {
             var linkUrl = this.props.article.dataUrl;
             if(this.props.article.dataUrl.indexOf("http://") == -1 && this.props.article.dataUrl.indexOf("https://") == -1 ) {
                linkUrl = "http://" + linkUrl;
             }
             fileArcl.push(
                           React.createElement("li", null, 
                             React.createElement("span", {className: "file-type etc"}, 
                               React.createElement("a", {href: linkUrl, target: "_blank"}, this.props.article.linkTitle)
                             )
                           )
                       );
    }


    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
              React.createElement("em", null, "[", this.props.article.dataTypeCdNm, "]    ", this.props.article.dataNm), 
              React.createElement("span", {className: "file", style: {display:(this.props.article.dataTypeCd == "101759")?"":"none"}}, "1개(", Math.ceil(totalSize/1024/1024), "MB)")
            )
          ), 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("ul", null, 
              fileArcl
            )
          )
        )
    );
  }
});

var DataList = React.createClass({displayName: "DataList",
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 5, 'currentPageNo' : 1, 'searchKey' : 0, 'searchWord' : '', 'isChecked' : false, fileSers : '', arclSer : 0, 'fileList' : [], title : '', notiYn : 'N'};
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
      'currentPageNo': this.state.currentPageNo,
      'recordCountPerPage':5,
      'searchKey':this.state.searchKey,
      'searchWord': this.state.searchWord,
      'ownerMbrNo': lectrMbrNo,
      'lectSer' : cntntsTargtNo
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
          }
          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  searchList:function() {
    this.getList();
  },
  render:function(){
    var _this = this;
    var pageNode = [];
    var result= [];

    if(this.state.data != null && this.state.data.length > 0) {
        pageNode.push(React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage}));

        result = this.state.data.map(
                        function(article, index){
                            var idx = _this.state.totalRecordCount - ((_this.state.currentPageNo - 1) * 10) - index;
                            return (React.createElement(Article, {key: index, article: article, selArclSer: _this.props.selArclSer, idx: idx, openLayer: _this.openLayer}));
                        }
                    );

    }
    var regBtn = "none";

    if(this.state.data != null && this.state.data.length > 0) {
        $("#lectData").show();
        return (
            React.createElement("div", {className: "lesson-task data"}, 
                React.createElement("ul", {className: "lesson-data-list"}, 
                
                    result
                
                ), 
                React.createElement("div", {className: "paging-btn", style: {height:'30px'}}, 
                    pageNode
                )
            )
        );
    }else{
        $("#lectData").hide();
        return (React.createElement("p", null));
    }
  }
});
    var params = document.body.getElementsByTagName('script');
    var query = params[2].className.split(" ");
    var paramArclSer = query[0];



var dataUrl = mentor.contextpath + "/lecture/lectureTotal/ajax.lectDataList.do";
mentor.DataList = React.render(
  React.createElement(DataList, {url: dataUrl, boardId: "lecFile"}),document.getElementById('boardDataList')
);