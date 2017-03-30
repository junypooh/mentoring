/**
 * 수업과제 react.js
 */

var FileInfo = React.createClass({displayName: "FileInfo",
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?fileSer="+this.props.file.fileSer;
  },
  render:function() {
    return (
      React.createElement("li", {key: this.props.file.fileSer}, 
        React.createElement("span", {className: this.props.classStr}, 
          React.createElement("a", {href: "javascript:void(0)", onClick: this.downloadFile}, this.props.file.comFileInfo.oriFileNm)
        ), 
        React.createElement("span", {className: "file-size"}, Math.ceil(this.props.file.comFileInfo.fileSize/1024/1024), "MB")
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
  showAnswer:function() {
    var ans = $(React.findDOMNode(this.refs.ansSust));
    if(ans.is(":visible")) {
      $(React.findDOMNode(this.refs.ansClick)).removeClass("active");
      ans.hide();
    } else {
      $(React.findDOMNode(this.refs.ansClick)).addClass("active");
      ans.show();
    }
  },
  componentDidMount: function() {
    if(this.props.article.arclSer == selArclSer ){
      this.articleClick();
    }
  },
  openLayer:function(e) {
    this.props.openLayer(e, this.props.article);
  },
  deleteAnswer:function() {
    this.props.deleteAnswer(this.props.article);
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
          React.createElement(FileInfo, {key: index, classStr: classStr, file: file})
        );
      });
    }
    var ansSust = this.props.article.cntntsSust;
    if(ansSust == null) {
      ansSust = "";
    }
    var classname = "user " + this.props.article.mbrClassNm;
    var replyclassname = this.props.article.ansMbrClassNm == 'mentor' ? "user mentor" : (this.props.article.ansMbrClassNm == 'teacher' ? "user teacher" : "name");
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
              React.createElement("span", {className: "num"}, this.props.article.notiYn == "Y"?"":this.props.totalCnt - this.props.article.rn + 1), 
              React.createElement("em", {className: "title"}, this.props.article.title), 
              React.createElement("span", {className: classname}, this.props.article.regMbrNm), 
              React.createElement("span", {className: "day"}, new Date(this.props.article.regDtm).format("yyyy.MM.dd"))
            )
          ), 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("p", {className: "task-cont"}, 
              this.props.article.sust.split("\n").map(function(item, index) {
                return (React.createElement("b", {key: index}, item, React.createElement("br", null)));
              })
            ), 
            React.createElement("ul", null, 
              fileArcl
            ), 
            React.createElement("div", {className: "btn-area", style: {display:ansSust != ""?"none":""}}, 
              React.createElement("a", {href: "javascript:void(0)", className: "btn-type1 reply layer-open", onClick: this.openLayer}, "답글")
            ), 
            React.createElement("div", {className: "reply-area", style: {display:ansSust != ""?"":"none"}}, 
              React.createElement("a", {href: "javascript:void(0)", onClick: this.showAnswer, ref: "ansClick"}, 
                React.createElement("em", null, ansSust), 
                React.createElement("span", {className: replyclassname}, this.props.article.ansRegMbrNm), 
                React.createElement("span", {className: "day"}, new Date(this.props.article.ansRegDtm).format("yyyy.MM.dd"))
              ), 
              React.createElement("p", {className: "full-answer", ref: "ansSust"}, 
                ansSust.split("\n").map(function(item, index) {
                  return (React.createElement("span", {key: index}, item, React.createElement("br", null)))
                }), 
                React.createElement("a", {href: "javascript:void(0)", className: "delete", onClick: this.deleteAnswer}, React.createElement("img", {src: mentor.contextpath+"/images/community/btn_wastebasket.png", alt: "삭제"}))
              )
            )
          )
        )
    );
  }
});

var WorkList = React.createClass({displayName: "WorkList",
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 10, 'currentPageNo' : 1, 'searchKey' : 0, 'searchWord' : '', arclSer : 0, ansSust : '', ansSustLen : 0};
  },
  componentDidMount: function() {
    $(document.body).on('keydown', this.handleKeyDown);
    this.getList();
  },
  componentWillUnmount: function() {
    $(document.body).off('keydown', this.handleKeyDown);
  },
  goPage:function(pageNo) {
    var param = {currentPageNo : pageNo};
    this.getList(param);
  },
  handleKeyDown: function(e) {
    var ENTER = 13;
    if( e.keyCode == ENTER ) {
      this.getList();
    }
  },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'currentPageNo': this.state.currentPageNo,
      'recordCountPerPage':this.state.recordCountPerPage,
      'searchKey':this.state.searchKey,
      'searchWord': this.state.searchWord,
      srchMbrNo: sMbrNo
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
  openLayer:function(e, article) {
    e.preventDefault();
    $('body').addClass('dim');
    $("#layer1").attr('tabindex',0).show().focus();
    $("#layer1").find('.pop-close, .btn-area.popup a.cancel, .btn-type2.gray').on('click',function (e) {
      e.preventDefault();
      $('body').removeClass('dim');
      $("#layer1").hide();
    });
    var ansSust = article.cntntsSust;
    if(ansSust == null) {
      ansSust = "";
    }
    this.setState({arclSer : article.arclSer, ansSust : ansSust, ansSustLen : ansSust.length});
  },
  registAns :function() {
    if(this.state.ansSust == "") {
      alert("내용을 입력하세요.");
      return false;
    }
    if(!confirm("등록하시겠습니까?")) {
      return false;
    }
    var data = {
                       arclSer : this.state.arclSer,
                       boardId : this.props.boardId,
                       cntntsSust : this.state.ansSust,
                       ansRegMbrNo : sMbrNo
                       };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.registArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      async : false,
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert(" 등록했습니다.");
      },
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }
    });
    this.getList();
    $('body').removeClass('dim');
    $("#layer1").hide();
  },
  deleteAnswer :function(article) {
    if(!confirm("삭제하시겠습니까?")) {
      return false;
    }
    var data = {
                       arclSer : article.arclSer,
                       boardId : this.props.boardId,
                       cntntsSust : '',
                       ansChgMbrNo : sMbrNo
                       };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.deleteArclReply.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      async : false,
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
      },
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }
    });
    this.getList();
  },
  setSearchKey:function(e) {
    this.setState({searchKey : e.target.value});
  },
  setSearchWord:function(e) {
    this.setState({searchWord : e.target.value});
  },
  searchList:function() {
    this.getList();
  },
  checkAns:function(e) {
    if(e.target.value.length > 200) {
      alert("입력  글자 수를 초과하였습니다.");
    }
    this.setState({ansSust : e.target.value.substring(0, 200), ansSustLen : e.target.value.substring(0, 200).length});
  },
  setRowCount:function(e) {
      this.setState({recordCountPerPage : e.target.value});
  },
  render:function(){
    var _this = this;
    var pageNode = [];
    if(this.state.data != null && this.state.data.length > 0) {
        pageNode.push(React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage}));
    }
    return (
        React.createElement("div", {className: "lesson-task"}, 

          React.createElement("span", {className: "list-num"}, 
            React.createElement("select", {style: {width:'70px'}, onChange: this.setRowCount, value: this.state.recordCountPerPage}, 
                React.createElement("option", {value: "10"}, "10"), 
                React.createElement("option", {value: "20"}, "20"), 
                React.createElement("option", {value: "30"}, "30"), 
                React.createElement("option", {value: "50"}, "50")
            )
          ), 

          React.createElement("ul", {className: "lesson-data-list"}, 
            this.state.data.map(function(article, index){
              return (React.createElement(Article, {key: index, article: article, selArclSer: _this.props.selArclSer, totalCnt: _this.state.totalRecordCount, openLayer: _this.openLayer, deleteAnswer: _this.deleteAnswer}));
            })
          ), 

          pageNode, 

          React.createElement("fieldset", {className: "list-search-area"}, 
            React.createElement("legend", null, "검색"), 
            React.createElement("select", {value: this.state.searchKey, onChange: this.setSearchKey}, 
              React.createElement("option", {value: "0"}, "전체"), 
              React.createElement("option", {value: "1"}, "제목"), 
              React.createElement("option", {value: "2"}, "내용")
            ), 
            React.createElement("input", {type: "search", className: "inp-style1", value: this.state.searchWord, onChange: this.setSearchWord}), 
            React.createElement("a", {href: "#", className: "btn-search", onClick: this.searchList}, React.createElement("span", null, "검색"))
          ), 

          React.createElement("div", {className: "layer-pop-wrap", id: "layer1"}, 
            React.createElement("div", {className: "title"}, 
              React.createElement("strong", null, "수업과제 답글"), 
              React.createElement("a", {href: "#", className: "pop-close"}, React.createElement("img", {src: mentor.contextpath+"/images/common/btn_popup_close.png", alt: "팝업 닫기"}))
            ), 
            React.createElement("div", {className: "cont type1"}, 
              React.createElement("div", {className: "lesson-task-popup"}, 
                React.createElement("textarea", {name: "", rows: "", className: "textarea-type1", cols: "", value: this.state.ansSust, onChange: this.checkAns}), 
                React.createElement("span", {className: "area-txt"}, React.createElement("em", null, this.state.ansSustLen), "/200자")
              ), 
              React.createElement("div", {className: "btn-area"}, 
              React.createElement("a", {href: "javascript:void(0)", className: "btn-type2", onClick: this.registAns}, "확인"), 
              React.createElement("a", {href: "javascript:void(0)", className: "btn-type2 gray"}, "취소")
              )
            )
          )

        )
    );
  }
});

mentor.WorkList = React.render(
  React.createElement(WorkList, {url: mentor.contextpath+'/community/ajax.mentorDataArclList.do', boardId: "lecWork", sMbrNo: sMbrNo}),
  document.getElementById('boardWorkList')
);
