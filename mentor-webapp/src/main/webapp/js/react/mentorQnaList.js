/**
 * 질문답변 react.js
 */

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
    if(this.props.article.arclSer == this.props.selArclSer ){
      this.articleClick();
    }
  },
  openLayer:function(e) {
    this.props.openLayer(e, this.props.article);
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
  deleteAnswer:function() {
    this.props.deleteAnswer(this.props.article);
  },
  render:function(){
    var ansSust = this.props.article.cntntsSust;
    if(ansSust == null) {
      ansSust = "";
    }
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
              React.createElement("span", {className: "num"}, this.props.totalCnt - this.props.article.rn + 1), 
              React.createElement("em", {className: "title notice"}, this.props.article.title), 
              React.createElement("span", {className: "name"}, this.props.article.regMbrNm), 
              React.createElement("span", {className: "day"}, new Date(this.props.article.regDtm).format("yyyy.MM.dd"))
            )
          ), 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("p", {className: "task-cont"}, 
              this.props.article.sust.split("\n").map(function(item, index) {
                return(React.createElement("span", {key: index}, item, React.createElement("br", null)));
              })
            ), 
            React.createElement("div", {className: "btn-area", style: {display:ansSust != ""?"none":""}}, 
              React.createElement("a", {href: "javascript:void(0)", className: "btn-type1 reply layer-open", onClick: this.openLayer}, "답변")
            ), 
            React.createElement("div", {className: "reply-area", style: {display:ansSust != ""?"":"none"}}, 
              React.createElement("a", {href: "javascript:void(0)", onClick: this.showAnswer, ref: "ansClick"}, 
                React.createElement("em", null, ansSust), 
                React.createElement("span", {className: "name"}, this.props.article.ansRegMbrNm), 
                React.createElement("span", {className: "day"}, new Date(this.props.article.ansRegDtm).format("yyyy.MM.dd"))
              ), 
              React.createElement("p", {className: "full-answer", ref: "ansSust"}, 
                  ansSust.split("\n").map(function(item, index) {
                    return (React.createElement("span", {key: index}, item, React.createElement("br", null)))
                  }), 
                React.createElement("span", {className: "delete"}, 
                  React.createElement("a", {href: "javascript:void(0)", className: "layer-open", onClick: this.openLayer}, React.createElement("img", {src: mentor.contextpath+"/images/community/btn_icon_modify.png", alt: "수정"})), 
                  React.createElement("a", {href: "javascript:void(0)", onClick: this.deleteAnswer}, React.createElement("img", {src: mentor.contextpath+"/images/community/btn_wastebasket.png", alt: "삭제"}))
                )
              )
            )
          )
        )
    );
  }
});

var DataList = React.createClass({displayName: "DataList",
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 10, 'currentPageNo' : 1,  'searchKey' : 0, 'searchWord' : '', arclSer : 0, ansSust : '', ansSustLen : 0};
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
      url: mentor.contextpath+"/community/ajax.deleteArcl.do",
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
  checkAns:function(e) {
    if(e.target.value.length > 400) {
      alert("입력  글자 수를 초과하였습니다.");
    }
    this.setState({ansSust : e.target.value.substring(0, 400), ansSustLen : e.target.value.substring(0, 400).length});
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
        React.createElement("div", {className: "lesson-task qna"}, 

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
              React.createElement("strong", null, "문의하기 답변"), 
              React.createElement("a", {href: "javascript:void(0)", className: "pop-close"}, React.createElement("img", {src: mentor.contextpath+"/images/common/btn_popup_close.png", alt: "팝업 닫기"}))
            ), 
            React.createElement("div", {className: "cont type1"}, 
              React.createElement("div", {className: "lesson-task-popup"}, 
                React.createElement("textarea", {name: "", rows: "", className: "textarea-type1", cols: "", value: this.state.ansSust, onChange: this.checkAns}), 
                React.createElement("span", {className: "area-txt"}, React.createElement("em", null, this.state.ansSustLen), "/400자")
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

mentor.DataList = React.render(
  React.createElement(DataList, {url: mentor.contextpath+'/community/ajax.mentorDataArclList.do', boardId: "lecQnA", sMbrNo: sMbrNo}),
  document.getElementById('boardQnaList')
);
