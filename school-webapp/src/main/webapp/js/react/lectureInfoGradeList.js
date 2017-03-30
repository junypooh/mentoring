/**
 * 평점 및 후기 게시판 react.js
 */

var CmtInfo = React.createClass({displayName: "CmtInfo",
  delCmt:function() {
    this.props.delCmt(this.props.cmtItem.cmtSer);
  },
  render:function() {
    var gradeIcon = [];
    if(this.props.cmtItem.mbrClassCd == "100859"){
      gradeIcon.push(React.createElement("em", {className: "name teacher"}, this.props.cmtItem.regMbrNm));
    }else if(this.props.cmtItem.mbrClassCd == "101505"){
      gradeIcon.push(React.createElement("em", {className: "name mentorr"}, this.props.cmtItem.regMbrNm));
    }else{
      gradeIcon.push(React.createElement("em", {className: "name student"}, this.props.cmtItem.regMbrNm));
    }
    return(
      React.createElement("li", null, 
        gradeIcon, 
        React.createElement("p", null, 
        this.props.cmtItem.cmtSust.split("\n").map(function(row, index){
          return(React.createElement("b", {key: index}, row, React.createElement("br", null)));
        })
        ), 
        React.createElement("a", {href: "javascript:void(0)", className: "ben-del", style: {display:(sMbrNo===this.props.cmtItem.regMbrNo)?'':'none'}, onClick: this.delCmt}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/btn_wastebasket01.png", alt: "댓글 삭제"}))
      )
      )
  }
});

var GradeCmtList = React.createClass({displayName: "GradeCmtList",
  getInitialState: function() {
    return {'cmtSust' : '', 'cmtSustLen' : 0};
  },
  getList:function() {
    this.props.getList();
  },
  delGradeInfo:function() {
    this.props.delGrade(this.props.item.cmtSer);
  },
  delCmt:function(cmtSer) {
    this.props.delGrade(cmtSer);
  },
  toggleComment:function() {
    var cmtList = $(React.findDOMNode(this.refs.cmtList));
    if(cmtList.is(":visible")) {
      cmtList.hide();
    } else {
      cmtList.show();
    }
  },
  chkCmt:function(e) {
    if(e.target.value.length > 200) {
      alert("입력 글자수를 초과하였습니다.");
    }
    this.setState({cmtSust: e.target.value.substr(0, 200), cmtSustLen: e.target.value.substr(0, 200).length});
  },
  registCmt:function() {
    if(sMbrNo === "") {
      alert("로그인이 필요한 서비스 입니다.");
      location.href = mentor.contextpath+"/login.do";
      return false;
    }
    if(this.state.cmtSust == "") {
      alert("내용을 입력하세요.");
      return;
    }
    var data = {arclSer : this.props.item.arclSer,
                       cmtSust : this.state.cmtSust,
                       boardId : this.props.item.boardId,
                       supCmtSer : this.props.item.cmtSer,
                       mbrClassCd: this.props.item.mbrClassCd
                     };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.registCmt.do",
      async:false,
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
          alert(rtnData.data);
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
    this.setState({cmtSust: '', cmtSustLen : 0});
    this.getList();
  },
  render:function() {
    var _this = this;
    var pnt = this.props.item.asmPnt+"";
    var cmtItems = this.props.item.listSubCmtInfo;
    if(cmtItems == null) {
      cmtItems = [];
    }
    var cmtLenStr = "("+cmtItems.length+")";
    var cmtStrLen = this.state.cmtSustLen + " / 200자";

    var gradeIcon = [];
    if(this.props.item.mbrClassCd == "100859"){
      gradeIcon.push(React.createElement("span", {className: "name"}, React.createElement("em", null, React.createElement("img", {src: mentor.contextpath+"/images/lesson/icon_grade_t.gif", alt: "교사"})), this.props.item.regMbrNm));
    }else if(this.props.item.mbrClassCd == "101505"){
      gradeIcon.push(React.createElement("span", {className: "name"}, React.createElement("em", null, React.createElement("img", {src: mentor.contextpath+"/images/lesson/icon_grade_m.gif", alt: "멘토"})), this.props.item.regMbrNm));
    }else{
      gradeIcon.push(React.createElement("span", {className: "name"}, React.createElement("em", null, React.createElement("img", {src: mentor.contextpath+"/images/lesson/icon_grade_s.gif", alt: "학생"})), this.props.item.regMbrNm));
    }
    return(
      React.createElement("li", null, 
        React.createElement("div", {className: "picture-area"}, 
          React.createElement("span", {className: "img"}, React.createElement("img", {src: this.props.item.fileSer?mentor.contextpath+"/fileDown.do?fileSer="+this.props.item.fileSer:''})), 
            gradeIcon, 
          React.createElement("span", {className: "star"}, React.createElement("em", null, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star"+pnt.replace(".","_")+".png", alt: this.props.item.asmPnt})))
        ), 
        React.createElement("div", {className: "comment-box active"}, 
          React.createElement("p", null, 
            React.createElement("a", {href: "javascript:void(0)"}, 
              this.props.item.cmtSust !=null?this.props.item.cmtSust.split("\n").map(function(row, index){
                return(React.createElement("b", {key: index}, row, React.createElement("br", null)));
              }):React.createElement("b", null, React.createElement("br", null))
            )
          ), 
          React.createElement("span", {className: "btn-del"}, 
            React.createElement("a", {href: "javascript:void(0)", style: {display:(sMbrNo===this.props.item.regMbrNo)?'':'none'}, onClick: this.delGradeInfo}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/btn_wastebasket.png", alt: "댓글 삭제"}))
          ), 
          React.createElement("div", {className: "comment"}, 
            React.createElement("a", {href: "javascript:void(0)", className: "num", onClick: this.toggleComment}, "댓글 ", React.createElement("span", null, cmtLenStr)), 
            React.createElement("div", {className: "comment-list", ref: "cmtList"}, 
              React.createElement("ul", null, 
                cmtItems.map(function(cmtItem, index) {
                  return(React.createElement(CmtInfo, {key: index, cmtItem: cmtItem, delCmt: _this.delCmt}))
                })
              ), 
              React.createElement("div", {className: "reg-form"}, 
                React.createElement("div", null, 
                  React.createElement("textarea", {name: "", rows: "", cols: "", title: "댓글입력란", value: this.state.cmtSust, onChange: this.chkCmt}), 
                  React.createElement("span", null, cmtStrLen)
                ), 
                React.createElement("a", {href: "javascript:void(0)", onClick: this.registCmt}, "등록")
              )
            )
          )
        )
      )
    );
  }
});

var GradeList = React.createClass({displayName: "GradeList",
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'arclSer' : 0, 'gradeSust' : '', 'gradeSustLen' : 0, 'cmtSust' : '', 'cmtSustLen' : 0, 'asmPnt' : 0, 'isGradeYn': 'N'};
  },
  componentDidMount: function() {
    this.getLectureArcl();
  },
  getLectureArcl: function() {
    $.ajax({
        url: mentor.contextpath+"/community/ajax.lectureArclInfo.do",
        data : {
          boardId : this.props.boardId,
          cntntsTargtNo : cntntsTargtNo,
          cntntsTargtTims : cntntsTargtTims
        },
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        async:false,
        success: function(rtnData) {
          this.setState({'arclSer' : rtnData.arclSer});
          setTimeout(this.getList, 100);
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  checkGradeYn: function() {
      $.ajax({
          url: mentor.contextpath+"/community/ajax.checkGradeYn.do",
          data : {
              arclSer : this.state.arclSer,
              sMbrNo : sMbrNo
          },
          contentType: "application/json",
          dataType: 'json',
          cache: false,
          async:false,
          success: function(rtnData) {
            if(rtnData > 0) {
                this.setState({'isGradeYn' : 'Y'});
            }else if(rtnData == -1) {
                this.setState({'isGradeYn' : 'F'});
            }
          }.bind(this),
          error: function(xhr, status, err) {
            console.error(this.props.url, status, err.toString());
          }.bind(this)
      });
    },
  getList: function(param) {
    var _param = jQuery.extend({'boardId':this.props.boardId, 'arclSer' : this.state.arclSer, 'currentPageNo':1, 'recordCountPerPage': 5}, param);
    $.ajax({
        url: mentor.contextpath + "/community/ajax.getPagedCmtList.do",
        data : _param,
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var rowCount = 0;
          if(rtnData.length > 0) {
            rowCount = rtnData[0].totalRecordCount;
          }
          if(_param.isMore == true){
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo});
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1});
          }
          this.checkGradeYn();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  gradeSustChk:function(e) {
    if(e.target.value.length > 400) {
      alert("입력 글자수를 초과하였습니다.");
    }
    this.setState({gradeSust: e.target.value.substr(0, 400), gradeSustLen : e.target.value.substr(0, 400).length});
  },
  showStarLayer:function() {
    var tabHeight = $("#tabDetail").height();
    if(tabHeight < 302){
        $("#tabDetail").css('height','302px');
    }
    if($("#starLayer").is(":visible")) {
      $("#starLayer").hide();
    } else {
      $("#starLayer").show();
    }
  },
  setPoint:function(param) {
    this.setState({'asmPnt' : param.pnt});
    $("#starView").addClass("star");
    var starUrl = mentor.contextpath+"/images/lesson/score_star";
    if(param.pnt.indexOf(".5") != -1) {
        starUrl = starUrl + param.pnt.replace(".","_")+".png";
    } else{
        starUrl = starUrl + param.pnt.replace(".0","")+".png";
    }
    $("#starPoint").html("<img src=\""+starUrl+"\" alt=\""+param.pnt+"\" />");
    $("#starLayer").hide();
    $("#tabDetail").css('height','');
  },
  registGrade:function() {
    if(this.state.isGradeYn == "Y") {
        alert("이미 평가 했습니다.");
        return;
    }
    if(this.state.isGradeYn == "F") {
        alert("수강한 수업이 아닙니다.");
        return;
    }
    if(sMbrNo === "") {
      alert("로그인이 필요한 서비스 입니다.");
      location.href = mentor.contextpath+"/login.do";
      return;
    }
    if(this.state.cmtSustText == "") {
      alert("내용을 입력하세요.");
      return;
    }
    if(this.state.asmPnt == 0) {
      alert("평점을 입력하세요.");
      return;
    }
    var data = {arclSer : this.state.arclSer,
                       cmtSust : this.state.gradeSust,
                       boardId : this.props.boardId,
                       asmPnt : this.state.asmPnt,
                       lectSer : cntntsTargtNo
                     };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.registCmt.do",
      async:false,
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
          alert(rtnData.data);
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
    this.setState({gradeSust: '', gradeSustLen : 0, asmPnt : 0});
    $("#starView").removeClass("star");
    $("#starPoint").text("평점선택");
    this.getList();
  },
  delGrade:function(cmtSer) {
    if(!confirm("삭제 하시겠습니까?")) {
      return false;
    }
    var _this = this;
    var data = {cmtSer : cmtSer};
    $.ajax({
      url: mentor.contextpath+"/community/ajax.deleteCmt.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
          //DATA삭제
          _this.getList();
        alert(rtnData.data);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("ajax.getCmlList.do", status, err.toString());
      }.bind(this)
    });
  },
  render:function(){
    var _this = this;
    var gradeStrLen = this.state.gradeSustLen + " / 400자";
    return (
        React.createElement("div", null, 
          React.createElement("a", {href: "#layer2", title: "등록 팝업 - 열기", className: "btn-inquiry layer-open mobile"}, "등록"), 

          React.createElement("div", {className: "give-grade"}, 
            React.createElement("span", {className: "star-view", id: "starView"}, React.createElement("a", {href: "javascript:void(0)", onClick: this.showStarLayer, id: "starPoint"}, "평점선택")), 
            React.createElement("div", {className: "star-layer", id: "starLayer"}, 
              React.createElement("ul", null, 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'5.0'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star5.png", alt: "5.0"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'2.5'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star2_5.png", alt: "2.5"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'4.5'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star4_5.png", alt: "4.5"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'2.0'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star2.png", alt: "2.0"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'4.0'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star4.png", alt: "4.0"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'1.5'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star1_5.png", alt: "1.5"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'3.5'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star3_5.png", alt: "3.5"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'1.0'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star1.png", alt: "1.0"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'3.0'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star3.png", alt: "3.0"}))), 
                React.createElement("li", null, React.createElement("a", {href: "javascript:void(0)", onClick: this.setPoint.bind(this, {'pnt':'0.5'})}, React.createElement("img", {src: mentor.contextpath+"/images/lesson/score_star0_5.png", alt: "0.5"})))
              )
            ), 
            React.createElement("div", {className: "text-area"}, 
              React.createElement("textarea", {name: "", rows: "", cols: "", value: this.state.gradeSust, onChange: this.gradeSustChk}), 
              React.createElement("span", null, gradeStrLen)
            ), 
            React.createElement("a", {href: "javascript:void(0)", className: "btn-reg", onClick: this.registGrade}, "등록")
          ), 

          React.createElement("div", {className: "epilogue-list"}, 
            React.createElement("ul", null, 
              this.state.data.map(function(item, index) {
                return(React.createElement(GradeCmtList, {key: index, item: item, delGrade: _this.delGrade, getList: _this.getList}));
              })
            )
          ), 

          React.createElement("div", {className: "btn-more-view"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1}), style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, "더 보기 (", React.createElement("span", null, this.state.totalRecordCount-this.state.data.length), ")")
          )

        )
    );
  }
});

mentor.GradeList = React.render(
  React.createElement(GradeList, {boardId: "lecAppr"})
  ,document.getElementById('boardGradeList')
);