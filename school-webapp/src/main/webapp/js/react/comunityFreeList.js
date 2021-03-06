/**
 * 자유게시판 react.js
 */

var CmtData = React.createClass({displayName: "CmtData",
  PropTypes : {
    cmtData : React.PropTypes.shape({
      arclSer : React.PropTypes.number.isRequired,
      regMbrNo : React.PropTypes.string.isRequired,
      regMbrId : React.PropTypes.string.isRequired,
      regMbrNm : React.PropTypes.string.isRequired,
      cmtSust : React.PropTypes.string.isRequired,
      cmtSer : React.PropTypes.number.isRequired,
      mbrNo : React.PropTypes.string.isRequired
    }),
    deleteCmt : React.PropTypes.func.isRequired
  },
  _deleteCmt : function() {
    this.props.deleteCmt(this.props.cmtData.cmtSer);
  },
  render:function() {
    var delBtn = mentor.contextpath + "/images/lesson/btn_wastebasket01.png";
    var btnShow = "none";
    if(this.props.cmtData.regMbrNo === this.props.mbrNo) {
      btnShow = "";
    }
    var gradeIcon = [];
    if(this.props.cmtData.mbrClassCd == "100859"){
      gradeIcon.push(React.createElement("em", {className: "name teacher"}, this.props.cmtData.regMbrNm));
    }else if(this.props.cmtData.mbrClassCd == "101505"){
      gradeIcon.push(React.createElement("em", {className: "name mentorr"}, this.props.cmtData.regMbrNm));
    }else{
      gradeIcon.push(React.createElement("em", {className: "name student"}, this.props.cmtData.regMbrNm));
    }
    return (
        React.createElement("li", {key: this.props.cmtData.cmtSer}, 
          gradeIcon, 
          React.createElement("p", null, 
            (this.props.cmtData.cmtSust+"").split("\n").map(function(item) {
              return (React.createElement("span", null, item, React.createElement("br", null)))
            })
          ), 
          React.createElement("a", {href: "javascript:void(0);", className: "ben-del", onClick: this._deleteCmt}, React.createElement("img", {src: delBtn, alt: "댓글 삭제", style: {display : btnShow}}))
        )
    );
  }
});

var FreeArticle = React.createClass({displayName: "FreeArticle",
  getInitialState: function() {
    return {cmtList: [], cmtStrLength:0, cmtSustText : ''};
  },
  componentDidMount: function() {
      if(this.props.article.arclSer == this.props.selArclSer ){
          this.articleClick();
      }
  },
  getCmtList:function() {
    $.ajax({
      url: "../ajax.getCmtList.do",
      async:false,
      data : {arclSer : this.props.article.arclSer,
      boardId : this.props.article.boardId },
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        this.setState({cmtList: rtnData});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("ajax.getCmlList.do", status, err.toString());
      }.bind(this)
    });
  },
  deleteCmt : function(cmtSer) {
    if(!confirm("삭제 하시겠습니까?")) {
      return false;
    }

    var data = {cmtSer : cmtSer,
                     boardId : this.props.article.boardId};
    $.ajax({
      url: "../ajax.deleteCmt.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
        mentor.FreeList.getList();
        this.getCmtList();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("ajax.getCmlList.do", status, err.toString());
      }.bind(this)
    });
  },
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.freeDetail)).is(":visible")) {
      $(React.findDOMNode(this.refs.freeDetail)).hide("fast");
      $(".writing-list li").removeClass("active");
    } else {
        $.ajax({
            url: this.props.url,
            data : {'arclSer':this.props.article.arclSer, 'boardId':this.props.boardId},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
              console.log(rtnData);
              this.props.setDetail(rtnData);
            }.bind(this),
            error: function(xhr, status, err) {
              console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
      $(".subject-detail").hide("fast");
      $(".writing-list li").removeClass("active");
      $(React.findDOMNode(this.refs.freeDetail)).parent().addClass("active");
      $(React.findDOMNode(this.refs.freeDetail)).show("fast");
      this.addCnt();
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
  cmtClick:function(e){
    if($(React.findDOMNode(this.refs.freeCmt)).is(":visible")) {
      $(React.findDOMNode(this.refs.freeCmt)).hide("fast");
    } else {
      this.getCmtList();
      $(".comment-list").hide("fast");
      $(React.findDOMNode(this.refs.freeCmt)).show("fast");
    }
  },
  updateClick:function(e) {
    e.preventDefault();
    $('body').addClass('dim');
    $("#freeBoardPop").attr('tabindex',0).show().focus();
    $("#freeBoardPop").find('.layer-close, .btn-area.popup a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      e.preventDefault();
      $('body').removeClass('dim');
      $("#freeBoardPop").hide();
    });
    $("#arclSer").val(this.props.article.arclSer);
    $("#essentTitle").val(this.props.article.title);
    $("#textaInfo").val(this.props.article.sust);
    $("#contLen").text(this.props.article.sust.length);
  },
  deleteArcl:function() {
    if(!confirm("삭제하시겠습니까?")) {
      return false;
    }
    var data = {arclSer : this.props.article.arclSer,
                     boardId : this.props.article.boardId };
    $.ajax({
      url: "../ajax.deleteArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
        $(".subject-detail").hide("fast");
        $(".writing-list li").removeClass("active");
        mentor.FreeList.getList();
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
  },
  chkCmt:function(e) {
    this.setState({cmtSustText : e.target.value.substr(0, 200), cmtStrLength : this.state.cmtSustText.length});
  },
  registCmt:function() {
      if(sMbrNo == "") {
          alert("로그인이 필요한 서비스 입니다.");
          location.href = mentor.contextpath+"/login.do";
          return;
      }
      if(this.state.cmtSustText == "") {
          alert("내용을 입력해 주세요.");
          return;
      }
      var data = {arclSer : this.props.article.arclSer,
                         cmtSust : this.state.cmtSustText,
                         boardId : this.props.article.boardId
                       };
    $.ajax({
      url: "../ajax.registCmt.do",
      async:false,
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("등록했습니다.");
        mentor.FreeList.getList();
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
    this.getCmtList();
    this.setState({cmtSustText: '', cmtStrLength : 0});
  },
  render:function(){
    var _this = this;
    var modClass = "none";
    if(this.props.article.regMbrNo == this.props.mbrNo) {
      modClass = "";
    }
    var classNm = "user "+this.props.article.mbrClassNm;
    var cmtData = this.state.cmtList.map(function(cmt, index) {
      return (
        React.createElement(CmtData, {key: cmt.cmtSer, cmtData: cmt, deleteCmt: _this.deleteCmt, mbrNo: _this.props.mbrNo})
      );
    });
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "subject-info"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick, className: "subject"}, this.props.article.title), 
            React.createElement("span", {className: classNm}, this.props.article.regMbrNm), 
            React.createElement("span", {className: "date"}, (new Date(this.props.article.regDtm)).format("yyyy.MM.dd"))
          ), 
          React.createElement("div", {className: "subject-detail", ref: "freeDetail"}, 
            React.createElement("div", {className: "free-board-detail"}, 
              React.createElement("div", {className: "board-wrap"}, 
                React.createElement("p", null, (this.props.article.sust+"").split("\n").map(function(item) {
                  return (React.createElement("b", null, item, React.createElement("br", null)))
                })), 
                React.createElement("div", {className: "writing-btn", style: {display:modClass}}, 
                  React.createElement("a", {href: "javascript:void(0);", className: "btn-modi layer-open", title: "수정 팝업 - 열기", onClick: this.updateClick}, "수정"), 
                  React.createElement("a", {href: "javascript:void(0);", className: "btn-del", onClick: this.deleteArcl}, "삭제")
                )
              ), 
              React.createElement("div", {className: "comment"}, 
                React.createElement("a", {href: "javascript:void(0);", className: "num", onClick: this.cmtClick}, "댓글 ", React.createElement("span", null, "(", this.props.article.cmtCount, ")")), 
                React.createElement("div", {className: "comment-list", ref: "freeCmt"}, 
                  React.createElement("ul", null, 
                    cmtData
                  ), 
                  React.createElement("div", {className: "reg-form"}, 
                    React.createElement("div", null, 
                      React.createElement("textarea", {name: "cmtSust", title: "댓글입력란", value: this.state.cmtSustText, onChange: this.chkCmt}), 
                      React.createElement("span", null, React.createElement("strong", null, this.state.cmtStrLength), React.createElement("span", {className: "txt-num"}, " / 200자"))
                    ), 
                    React.createElement("a", {href: "javascript:void(0);", onClick: this.registCmt}, "등록")
                  )
                )
              )
            )
          )
        )
    );
  }
});

var FreeArticleList = React.createClass({displayName: "FreeArticleList",
  render:function(){
    var _this = this;
    var articleList = this.props.articles.map(function(article, index) {
      return (
          React.createElement(FreeArticle, {key: index, article: article, selArclSer: _this.props.selArclSer, mbrNo: _this.props.mbrNo, url: _this.props.url, boardId: _this.props.boardId, setDetail: _this.props.setDetail})
      );
    });
    return (
        React.createElement("ul", {className: "writing-list"}, 
          articleList
        )
    );
  }
});

var FreeList = React.createClass({displayName: "FreeList",
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
    var _param = jQuery.extend({'boardId':this.props.boardId, 'currentPageNo':this.state.currentPageNo, 'recordCountPerPage':10, 'searchKey':0, 'searchWord':''}, param);
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
          //if(_param.isMore == true){
            //this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          //}else{
          //  this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          //}
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  setDetail:function(obj){
      for(var i=0; i < this.state.data.length ; i++){
          if(this.state.data[i].arclSer == obj[0].arclSer){
              this.state.data[i] = obj[0].arclSer;
              console.log(obj[0].arclSer);
              break;
          }
      }
  },
  render:function(){
    return (
        React.createElement("div", null, 
          React.createElement(FreeArticleList, {articles: this.state.data, boardId: this.props.boardId, selArclSer: this.props.selArclSer, mbrNo: this.props.mbrNo, url: this.props.urlDetail, setDetail: this.setDetail}), 
          React.createElement(PageNavi, {
                                                url: this.props.url, 
                                                pageFunc: this.goPage, 
                                                totalRecordCount: this.state.totalRecordCount, 
                                                currentPageNo: this.state.currentPageNo, 
                                                recordCountPerPage: this.state.recordPerPage, 
                                                contextPath: this.props.contextPath})
        )
    );
  }
});

mentor.FreeList = React.render(
  React.createElement(FreeList, {url: mentor.contextpath+'/community/ajax.arclListWithoutFile.do', urlDetail: mentor.contextpath+'/community/ajax.arclList.do', boardId: "lecFreeBoard", selArclSer: arclSer, mbrNo: sMbrNo, contextPath: mentor.contextpath})
  ,document.getElementById('boardFreeList')
);