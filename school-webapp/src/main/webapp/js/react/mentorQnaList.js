/**
 * 문의하기 게시판 react.js
 */

var ArticleInfo = React.createClass({displayName: "ArticleInfo",
  articleClick:function(e){
    if(this.props.article.scrtArclYn == "Y" && this.props.article.regMbrNo != sMbrNo) {
        alert("비밀글 입니다.");
        return;
    }
    if($(React.findDOMNode(this.refs.detail)).is(":visible")) {
      $(React.findDOMNode(this.refs.detail)).hide("fast");
      $(".writing-list li").removeClass("active");
    } else {
      $(".subject-detail").hide("fast");
      $(".writing-list li").removeClass("active");
      $(React.findDOMNode(this.refs.detail)).parent().addClass("active");
      $(React.findDOMNode(this.refs.detail)).show("fast");
    }
  },
  componentDidMount: function() {
      if(this.props.article.arclSer == this.props.selArclSer ){
          this.articleClick();
      }
  },
  deleteArcl:function() {
    if(!confirm("삭제하시겠습니까?")) {
      return false;
    }
    $.ajax({
      url: mentor.contextpath+"/community/ajax.deleteArcl.do",
      data : {arclSer : this.props.article.arclSer,
      boardId : this.props.article.boardId },
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        alert(rtnData.data);
        mentor.QnaList.getList();
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
  },
  _updateClick:function() {
    this.props.updateClick(this.props.article);
  },
  render:function(){
    var userClass = "user " + this.props.article.mbrClassNm;
    var ansClass = "none";
    var ansClass2 = "question-detail no-answer";
    var ansSust = this.props.article.cntntsSust;
    var modClass = "none";

    if(ansSust != null && !ansSust.isEmpty()) {
      ansClass = "";
      ansClass2 = "question-detail";
    } else {
        if(this.props.article.regMbrNo == this.props.mbrNo) {
            modClass = "";
        }
    }
    var secretClass = "subject-info";
    if(this.props.article.scrtArclYn == "Y") {
        secretClass  += " secret";
    }
    var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+this.props.article.cntntsTargtNo+"&lectTims="+this.props.article.cntntsTargtTims+"&schdSeq="+this.props.article.cntntsTargtSeq;
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;
    return (
      React.createElement("li", {key: this.props.article.arclSer}, 
        React.createElement("div", {className: secretClass}, 
          React.createElement("a", {href: "javascript:void(0)", onClick: this.articleClick, className: "subject"}, this.props.article.title), 
          React.createElement("span", {className: userClass}, this.props.article.regMbrNm), 
          React.createElement("span", {className: "date"}, (new Date(this.props.article.regDtm)).format("yyyy.MM.dd"))
        ), 
        React.createElement("div", {className: "subject-detail", ref: "detail"}, 
          React.createElement("div", {className: "relation-lesson"}, 
              React.createElement("span", {style: {display:(this.props.article.cntntsTargtNo != "")?'':'none'}}, React.createElement("strong", null, "관련수업"), React.createElement("a", {href: lectureUrl, target: "_self", title: "새창열림"}, " ", this.props.article.lectTitle))
          ), 
          React.createElement("div", {className: ansClass2}, 
            React.createElement("div", {className: "question"}, 
              React.createElement("span", {className: "title"}, "질문"), 
              React.createElement("p", {className: "info"}, 
                this.props.article.sust.split("\n").map(function(item, index) {
                  return (React.createElement("b", {key: index}, item, React.createElement("br", null)));
                })
              )
            ), 
            React.createElement("div", {className: "answer", style: {display:ansClass}}, 
              React.createElement("span", {className: "title"}, "답변"), 
              React.createElement("p", {className: "info"}, ansSust)
            ), 
            React.createElement("div", {className: "writing-btn", style: {display:modClass}}, 
              React.createElement("a", {href: "javascript:void(0)", title: "수정 팝업 - 열기", className: "btn-modi layer-open", onClick: this._updateClick}, "수정"), 
              React.createElement("a", {href: "javascript:void(0)", className: "btn-del", onClick: this.deleteArcl}, "삭제")
            )
          )
        )
      )
    );
  }
});

var QnaList = React.createClass({displayName: "QnaList",
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'searchKey' : 0, 'searchWord' : '', 'prefNo' : 'qnaMentor', 'scrtArclYn' : '', 'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0, 'isChecked' : false};
  },
  componentDidMount: function() {
    this.getList();
  },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'dispNotice' : false,
      'srchMentorMbrNo' : mentorMbrNo,
      'siteGbn' : 'sMentorQnA',
      'currentPageNo':1,
      'recordCountPerPage':10,
      'searchKey':0,
      'searchWord':''
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
  registClick:function () {
    if(sMbrNo === "") {
        alert("로그인이 필요한 서비스 입니다.");
        location.href = mentor.contextpath+"/login.do";
        return false;
    }
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    thisW = $("#qnaPop").width(),
    thisH = $("#qnaPop").height();
    $("#qnaPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    $("#scrtArclYn").attr("checked", false);
    $("#scrtArclYn").parent().removeClass("checked");
    this.setState({'scrtArclYn' : '', 'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0});
    $('body').addClass('dim');
    $("#qnaPop").attr('tabindex',0).show().focus();
    $("#qnaPop").find('.layer-close, a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#qnaPop").hide();
    });
  },
  updateClick:function(obj) {
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    thisW = $("#qnaPop").width(),
    thisH = $("#qnaPop").height();
    $("#qnaPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    this.setState({
      'title' : obj.title,
      'sust' : obj.sust,
      'arclSer' : obj.arclSer,
      'sustLen' : obj.sust.length
    });
    if(obj.scrtArclYn === 'Y') {
      this.setState({'scrtArclYn' : 'Y', 'isChecked':true});
    } else {
      this.setState({'scrtArclYn' : 'N', 'isChecked':false});
    }
    $('body').addClass('dim');
    $("#qnaPop").attr('tabindex',0).show().focus();
    $("#qnaPop").find('.layer-close, .btn-area.popup a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#qnaPop").hide();
    });
  },
  registArcl : function () {
    if($("#title").val() === "") {
      alert("제목을 입력해 주세요.");
      return false;
    }
    if($("#sust").val() === "") {
      alert("내용을 입력해 주세요.");
      return false;
    }
    if(!confirm("등록하시겠습니까?")) {
      return false;
    }
    var data = {title : this.state.title,
                       boardId : 'lecQnA',
                       prefNo : this.state.prefNo,
                       cntntsTargtId : mentorMbrNo,
                       sust : this.state.sust,
                       scrtArclYn : this.state.scrtArclYn,
                       arclSer : this.state.arclSer,
                       ansRegMbrNo : mentorMbrNo};
    $.ajax({
      url: mentor.contextpath+"/community/ajax.registArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      type: 'post',
      async:false,
      success: function(rtnData) {
        alert(rtnData.data);
      },
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }
    });
    this.getList();
    $('body').removeClass('dim');
    $("#qnaPop").hide();
  },
  chkScrtArclYn:function(e) {
    if(this.state.isChecked) {
      this.setState({isChecked : false, scrtArclYn : 'N'});
    } else {
      this.setState({isChecked : true, scrtArclYn : 'Y'});
    }
  },
  chkTitle:function(e) {
    this.setState({title : e.target.value});
  },
  chkSust:function(e) {
    if(e.target.value.length > 400) {
      alert("입력 글자수를 초과하였습니다.");
    }
    this.setState({sust : e.target.value.substr(0, 400), sustLen: this.state.sust.length});
  },
  render:function(){
    var _this = this;
    return (
        React.createElement("div", null, 
          React.createElement("div", {className: "title-group"}, 
            React.createElement("div", {className: "btn"}, 
              React.createElement("a", {href: "javascript:void(0)", title: "등록 팝업 - 열기", className: "btn-border-type layer-open", onClick: this.registClick}, "등록")
            )
          ), 

          React.createElement("ul", {className: "writing-list"}, 
            this.state.data.map(function(article, index) {
                return (React.createElement(ArticleInfo, {key: index, article: article, updateClick: _this.updateClick, mbrNo: _this.props.mbrNo, selArclSer: _this.props.selArclSer}));
              }
            )
          ), 

          React.createElement("div", {className: "btn-more-view"}, 
            React.createElement("a", {href: "javascript:void(0)", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord}), style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, "더 보기 (", React.createElement("span", null, this.state.totalRecordCount-this.state.data.length), ")")
          ), 

          React.createElement("div", {className: "layer-pop-wrap", id: "qnaPop"}, 
            React.createElement("div", {className: "layer-pop"}, 
              React.createElement("div", {className: "layer-header"}, 
                React.createElement("strong", {className: "title"}, "문의하기 등록")
              ), 
              React.createElement("div", {className: "layer-cont"}, 
                React.createElement("div", {className: "tbl-style inquiry"}, 
                  React.createElement("p", null, React.createElement("span", {className: "essent-inp"}, "필수입력 알림"), "필수입력"), 
                  React.createElement("table", null, 
                    React.createElement("caption", null, "문의하기 등록 - 분류,제목,내용"), 
                    React.createElement("colgroup", null, 
                      React.createElement("col", {style: {width:'20%'}}), 
                      React.createElement("col", null)
                    ), 
                    React.createElement("tbody", null, 
                      React.createElement("tr", null, 
                        React.createElement("th", {scope: "row"}, React.createElement("span", {className: "essent-inp"}, "필수입력"), "분류"), 
                        React.createElement("td", null, "멘토", 
                          React.createElement("span", {className: "secret-text"}, 
                            React.createElement("label", {className: "chk-skin", title: "비밀글"}, 
                              React.createElement("input", {type: "checkbox", id: "scrtArclYn", name: "scrtArclYn", value: this.state.scrtArclYn, checked: this.state.isChecked, onChange: this.chkScrtArclYn}), "비밀글"
                            )
                          )
                        )
                      ), 
                      React.createElement("tr", null, 
                        React.createElement("th", {scope: "row"}, React.createElement("span", {className: "essent-inp"}, "필수입력"), React.createElement("label", {htmlFor: "title"}, "제목")), 
                        React.createElement("td", null, React.createElement("input", {type: "text", id: "title", name: "title", className: "inp-style", title: "제목", value: this.state.title, onChange: this.chkTitle}))
                      ), 
                      React.createElement("tr", null, 
                        React.createElement("th", {scope: "row"}, React.createElement("span", {className: "essent-inp"}, "필수입력"), React.createElement("label", {htmlFor: "sust"}, "내용")), 
                        React.createElement("td", null, 
                          React.createElement("div", {className: "text-area popup"}, 
                            React.createElement("textarea", {className: "ta-style", id: "sust", name: "sust", value: this.state.sust, onChange: this.chkSust}), React.createElement("span", {className: "text-limit"}, React.createElement("strong", {id: "currentTxt"}, this.state.sustLen), " / 400자"), 
                            React.createElement("input", {type: "hidden", id: "arclSer", value: this.state.arclSer})
                          )
                        )
                      )
                    )
                  )
                ), 
                React.createElement("div", {className: "btn-area popup"}, 
                  React.createElement("a", {href: "#", className: "btn-type2 popup", onClick: this.registArcl}, "확인"), 
                  React.createElement("a", {href: "#", className: "btn-type2 cancel"}, "취소")
                ), 
                React.createElement("a", {href: "#", className: "layer-close"}, "팝업 창 닫기")
              )
            )
          )

        )
    );
  }
});

    mentor.QnaList = React.render(
        React.createElement(QnaList, {url: mentor.contextpath+'/community/ajax.arclList.do', boardId: "lecQnA", mbrNo: sMbrNo}),
        document.getElementById('tab-qna')
    );