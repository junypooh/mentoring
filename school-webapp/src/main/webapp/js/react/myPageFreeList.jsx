/**
 * 자유게시판 react.js
 */

var CmtData = React.createClass({
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
    var imgUrl = mentor.contextpath + "/images/lesson/btn_wastebasket01.png";
    var btnShow = "none";
    if(this.props.cmtData.regMbrNo === this.props.mbrNo) {
      btnShow = "";
    }
    var cmtSust = "";
    if(this.props.cmtData.cmtSust != null) {
        cmtSust = this.props.cmtData.cmtSust;
    }
    var gradeIcon = [];
    if(this.props.cmtData.mbrClassCd == "100859"){
      gradeIcon.push(<em className="name teacher">{this.props.cmtData.regMbrNm}</em>);
    }else if(this.props.cmtData.mbrClassCd == "101505"){
      gradeIcon.push(<em className="name mentorr">{this.props.cmtData.regMbrNm}</em>);
    }else{
      gradeIcon.push(<em className="name student">{this.props.cmtData.regMbrNm}</em>);
    }
    return (
        <li key={this.props.cmtData.cmtSer}>
          {gradeIcon}
          <p>
            {cmtSust.split("\n").map(function(item) {
              return (<span>{item}<br /></span>)
            })}
          </p>
          <a href="javascript:void(0)" className="ben-del" onClick={this._deleteCmt}><img src={imgUrl} alt="댓글 삭제" style={{display : btnShow}} /></a>
        </li>
    );
  }
});

var FreeArticle = React.createClass({
  getInitialState: function() {
    return {cmtList: [], cmtStrLength:0, cmtSustText : ''};
  },
  getCmtList:function() {
    $.ajax({
      url: mentor.contextpath+"/community/ajax.getCmtList.do",
      async : false,
      data : {arclSer : this.props.article.arclSer,
      boardId : this.props.article.boardId },
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        this.setState({cmtList: rtnData});
        setTimeout(myCommunity, 100);
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
                     boardId : this.props.boardId};
    $.ajax({
      url: mentor.contextpath+"/community/ajax.deleteCmt.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
        freeList.getList();
        this.getCmtList();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("ajax.getCmlList.do", status, err.toString());
      }.bind(this)
    });
  },
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.freeDetail)).is(":visible")) {
      $(React.findDOMNode(this.refs.freeDetail)).hide();
      $(".writing-list li").removeClass("active");
    } else {
      $(".subject-detail").hide();
      $(".writing-list li").removeClass("active");
      $(React.findDOMNode(this.refs.freeDetail)).parent().addClass("active");
      $(React.findDOMNode(this.refs.freeDetail)).show();
      this.addCnt();
    }
    myCommunity();
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
      $(React.findDOMNode(this.refs.freeCmt)).hide();
    } else {
      this.getCmtList();
      $(".comment-list").hide();
      $(React.findDOMNode(this.refs.freeCmt)).show();
    }
    myCommunity();
  },
  updateClick:function() {
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    thisW = $("#freeBoardPop").width(),
    thisH = $("#freeBoardPop").height();
    $("#freeBoardPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    freeList.setState({'title' : this.props.article.title, 'sust' : this.props.article.sust, 'arclSer' : this.props.article.arclSer, 'sustLen' : this.props.article.sust.length});
    $('body').addClass('dim');
    $("#freeBoardPop").attr('tabindex',0).show().focus();
    $("#freeBoardPop").find('.layer-close, .btn-area.popup a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#freeBoardPop").hide();
    });
  },
  deleteArcl:function() {
    if(!confirm("삭제하시겠습니까?")) {
      return false;
    }
    var data = {arclSer : this.props.article.arclSer,
                     boardId : this.props.article.boardId };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.deleteArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
        freeList.getList();
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
    if(this.state.cmtSustText == "") {
      alert("내용을 입력해 주세요.");
      return;
    }

    var data = {arclSer : this.props.article.arclSer,
                       cmtSust : this.state.cmtSustText,
                       boardId : this.props.article.boardId
                     };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.registCmt.do",
      async:false,
      data : JSON.stringify(data) ,
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      success: function(rtnData) {
        alert("등록했습니다.");
        freeList.getList();
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
    var arclInfo = this.props.article;
    var classNm = "user "+this.props.mbrClassNm;
    var cmtData = this.state.cmtList.map(function(cmt, index) {
      return (
        <CmtData key={cmt.cmtSer} cmtData={cmt} deleteCmt={_this.deleteCmt} mbrNo={_this.props.mbrNo} />
      );
    });
    var sust = "";
    if(arclInfo.sust != null) {
        sust = arclInfo.sust;
    }
    var cmtCountHtml = "";
    if(arclInfo.cmtCount != null && arclInfo.cmtCount > 0) {
        var cmtCount = "(" + arclInfo.cmtCount + ")";
        cmtCountHtml = <b className='cmt-count'>{cmtCount}</b>;
    }
    return (
        <li>
          <div className="subject-info">
            <a href="javascript:void(0)" onClick={this.articleClick} className="subject">{arclInfo.title}{cmtCountHtml}</a>
            <span className={classNm}>{arclInfo.regMbrNm}</span>
            <span className="date">{(new Date(arclInfo.regDtm)).format("yyyy.MM.dd")}</span>
          </div>
          <div className="subject-detail" ref="freeDetail">
            <div className="free-board-detail">
              <div className="board-wrap">
                <p>{sust.split("\n").map(function(item, index) {
                  return (<b key={index}>{item}<br /></b>)
                })}</p>
                <div className="writing-btn">
                  <a href="javascript:void(0)" title="수정 팝업 - 열기" className="btn-modi layer-open" onClick={this.updateClick}>수정</a>
                  <a href="javascript:void(0)" className="btn-del" onClick={this.deleteArcl}>삭제</a>
                </div>
              </div>
              <div className="comment">
                <a href="javascript:void(0)" className="num" onClick={this.cmtClick}>댓글 <span>({arclInfo.cmtCount})</span></a>
                <div className="comment-list" ref="freeCmt">
                  <ul>
                    {cmtData}
                  </ul>
                  <div className="reg-form">
                    <div>
                      <textarea name="cmtSust" value={this.state.cmtSustText} onChange={this.chkCmt} />
                      <span><strong>{this.state.cmtStrLength}</strong><span className="txt-num"> / 200자</span></span>
                    </div>
                    <a href="javascript:void(0)" onClick={this.registCmt} >등록</a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </li>
    );
  }
});

var FreeArticleList = React.createClass({
  render:function(){
    var _this = this;
    var articleList = null;

    if(this.props.articles != null && this.props.articles.length > 0){
        articleList = this.props.articles.map(function(article, index) {
              return (
                  <FreeArticle key={index} article={article} mbrNo={_this.props.mbrNo} />
              );
        });
    } else if(firstCall) {
        articleList = [];
        articleList.push(
                <li>
                  <div className="subject-info">
                    <a href="javascript:void(0)" className="subject" style={{'width':'100%', 'text-align':'center'}}>등록된 데이터가 없습니다.</a>
                  </div>
                </li>
        );
    }
    return (
        <ul className="writing-list">
          {articleList}
        </ul>
    );
  }
});

var FreeList = React.createClass({
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'searchKey' : 0, 'searchWord' : '', 'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0,'recordPerPage':10,'currentPageNo':1};
  },
  componentDidMount: function() {
    this.getList();
    myCommunity();
  },
  goPage:function(pageNo) {
    this.getList({'currentPageNo': pageNo});
  },
  getList: function(param) {
    firstCall = true;
    var _param = jQuery.extend({
        'boardId':this.props.boardId,
        'currentPageNo':this.state.currentPageNo,
        'recordCountPerPage':10,
        'searchKey':0,
        'searchWord':'',
        'srchMbrNo': this.props.mbrNo,
        'dispNotice' : false,
        'srchMbrNo' : sMbrNo,
        'siteGbn' : 'sMyComm'
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
          /*
          if(_param.isMore == true){
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
          */
          myCommunity();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  registClick:function () {
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    thisW = $("#freeBoardPop").width(),
    thisH = $("#freeBoardPop").height();
    $("#freeBoardPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    this.setState({'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0});
    $('body').addClass('dim');
    $("#freeBoardPop").attr('tabindex',0).show().focus();
    $("#freeBoardPop").find('.layer-close, a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#freeBoardPop").hide();
    });
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
  registArcl :function() {
    if(this.state.title == ""){
        alert("제목을 입력하세요.");
        return false;
    }
    if(this.state.sust == ""){
        alert("내용을 입력하세요.");
        return false;
    }
    if(!confirm("등록하시겠습니까?")) {
      return false;
    }

    var data = {title : this.state.title,
                       boardId : this.props.boardId,
                       sust : this.state.sust,
                       arclSer : this.state.arclSer };
    $.ajax({
      url: mentor.contextpath+"/community/ajax.registArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      async : false,
      dataType: 'json',
      cache: false,
      type:'POST',
      success: function(rtnData) {
        alert(" 등록했습니다.");
      },
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }
    });
    this.getList();
    $('body').removeClass('dim');
    $("#freeBoardPop").hide();
  },
  render:function(){
    return (
        <div>
          <FreeArticleList articles={this.state.data} boardId={this.props.boardId} mbrNo={this.props.mbrNo} />

          <PageNavi
                                                url={this.props.url}
                                                pageFunc={this.goPage}
                                                totalRecordCount={this.state.totalRecordCount}
                                                currentPageNo={this.state.currentPageNo}
                                                recordCountPerPage={this.state.recordPerPage}
                                                contextPath={this.props.contextPath} />

          <div className="btn">
            <a href="javascript:void(0)" title="등록 팝업 - 열기" className="btn-border-type layer-open" onClick={this.registClick} style={{display:'block'}}>등록</a>
          </div>

          <div className="layer-pop-wrap" id="freeBoardPop">
            <div className="layer-pop">
              <div className="layer-header">
                <strong className="title">게시글 등록/수정</strong>
              </div>
              <div className="layer-cont">
                <div className="tbl-style">
                  <p><span className="essent-inp">필수입력 알림</span>필수입력</p>
                  <table>
                    <caption>게시글 등록/수정 입력창 - 제목,내용</caption>
                    <colgroup>
                      <col style={{width:'20%'}} />
                      <col />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><span className="essent-inp">필수입력</span><label htmlFor="essentTitle">제목</label></th>
                        <td><input type="text" id="essentTitle" className="inp-style" name="제목" value={this.state.title} onChange={this.chkTitle} /></td>
                      </tr>
                      <tr>
                        <th scope="row"><span className="essent-inp">필수입력</span><label htmlFor="textaInfo">내용</label></th>
                        <td>
                          <div className="text-area popup">
                            <textarea id="textaInfo" className="ta-style" name="text" value={this.state.sust} onChange={this.chkSust} /><span className="text-limit"><strong id="contLen">{this.state.sustLen}</strong> / 400자</span>
                            <input type="hidden" id="arclSer" value={this.state.arclSer} />
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div className="btn-area popup">
                  <a href="#" className="btn-type2 popup" onClick={this.registArcl}>확인</a>
                  <a href="#" className="btn-type2 cancel">취소</a>
                </div>
                <a href="#" className="layer-close">팝업 창 닫기</a>
              </div>
            </div>
          </div>

        </div>
    );
  }
});