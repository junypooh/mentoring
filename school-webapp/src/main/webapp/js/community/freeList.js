/**
 * 자유게시판 react.js
 */

var CmtList = React.createClass({
  getInitialState: function() {
    return {cmtList: []};
  },
  getCmtList:function() {
    $.ajax({
      url: "ajax.getCmtList.do",
      data : {arclSer : this.props.arclSer },
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
  deleteCmt:function(param) {
    console.log(param);
    return;
    $.ajax({
      url: "ajax.deleteCmt.do",
      data : param,
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
        this.getCmtList();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("ajax.getCmlList.do", status, err.toString());
      }.bind(this)
    });
  },
  componentDidMount: function() {
    this.getCmtList();
  },
  render:function() {
    var cmtList;
    if(this.state.cmtList) {
      cmtList = this.state.cmtList.map(function(cmt, index) {
        return (
            <li key={cmt.cmtSer}>
              <em className="name">{cmt.regMbrNo}</em>
              <p>{cmt.cmtSust}</p>
              <a href="javascript:void(0);" className="ben-del" onclick={this.deleteCmt}><img src="../../images/lesson/btn_wastebasket01.png" alt="댓글 삭제" /></a>
            </li>
        );
      });
    }
    return (
        <ul>
          {cmtList}
        </ul>
    );
  }
});

var FreeArticle = React.createClass({
  getInitialState: function() {
    return {cmtList: [], cmtStrLength:0, cmtSustText : ''};
  },
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.freeDetail)).is(":visible")) {
      $(React.findDOMNode(this.refs.freeDetail)).hide("fast");
      $(".writing-list li").removeClass("active");
    } else {
      $(".subject-detail").hide("fast");
      $(".writing-list li").removeClass("active");
      $(React.findDOMNode(this.refs.freeDetail)).parent().addClass("active");
      $(React.findDOMNode(this.refs.freeDetail)).show("fast");
    }
  },
  cmtClick:function(e){
    if($(React.findDOMNode(this.refs.freeCmt)).is(":visible")) {
      $(React.findDOMNode(this.refs.freeCmt)).hide("fast");
    } else {
      $(".comment-list").hide("fast");
      $(React.findDOMNode(this.refs.freeCmt)).show("fast");
    }
    CmtList.getCmtList();
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
    $("#arclSer").val(this.props.arclSer);
    $("#essentTitle").val(this.props.title);
    $("#textaInfo").val(this.props.sust);
  },
  deleteArcl:function() {
    if(!confirm("삭제하시겠습니까?")) {
      return false;
    }
    $.ajax({
      url: "ajax.deleteArcl.do",
      data : {arclSer : this.props.arclSer },
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        alert("삭제했습니다.");
        mentor.CmtList.getCmtList();
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
    $.ajax({
      url: "ajax.registCmt.do",
      data : {arclSer : this.props.arclSer,
        cmtSust : this.state.cmtSustText
      },
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        alert("등록했습니다..");
        mentor.CmtList.getCmtList();
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
  },
  render:function(){
    return (
        <li>
          <div className="subject-info">
            <a href="javascript:void(0);" onClick={this.articleClick} className="subject">{this.props.title}</a>
            <span className="user">{this.props.regMbrNo}</span>
            <span className="date">{this.props.regDtm}</span>
          </div>
          <div className="subject-detail" ref="freeDetail">
            <div className="free-board-detail">
              <div className="board-wrap">
                <p>{this.props.sust}</p>
                <div className="writing-btn">
                  <a href="javascript:void(0);" className="btn-modi layer-open" onClick={this.updateClick}>수정</a>
                  <a href="javascript:void(0);" className="btn-del" onClick={this.deleteArcl}>삭제</a>
                </div>
              </div>
              <div className="comment">
                <a href="javascript:void(0);" className="num" onClick={this.cmtClick}>댓글 <span>({this.props.cmtCount})</span></a>
                <div className="comment-list" ref="freeCmt">
                  <CmtList arclSer={this.props.arclSer} />
                  <div className="reg-form">
                    <div>
                      <textarea name="cmtSust" value={this.state.cmtSustText} onChange={this.chkCmt} />
                      <span><strong> {this.state.cmtStrLength} </strong> / 200자 </span>
                    </div>
                    <a href="javascript:void(0);" onClick={this.registCmt} >등록</a>
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
    var articleList = this.props.articles.map(function(article, index) {
      return (
          <FreeArticle key={article.arclSer} arclSer={article.arclSer} title={article.title} regDtm={article.regDtm} regMbrNo={article.regMbrNo} sust={article.sust} cmtCount={article.cmtCount} />
      );
    });
    return (
        <ul className="writing-list">
          {articleList}
        </ul>
    );
  }
});

var FreeList = React.createClass({
  getInitialState: function() {
    return {'data': [], 'totalRecordCount':0};
  },
  componentDidMount: function() {
    this.getList();
  },
  getList: function(param) {
    var _param = jQuery.extend({'currentPageNo':1,'recordCountPerPage':10},param);
    $.ajax({
        url: this.props.url,
        data : _param,
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var rowCount = 0;
          var currentPageNo = 1;
          if(rtnData[0] != "undefiend") {
            rowCount = rtnData[0].totalRecordCount;
            currentPageNo = rtnData[0].currentPageNo;
          }
          if(_param.isMore == true){
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':currentPageNo});
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo});
          }
          console.log(this.state);
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    return (
        <div>
          <FreeArticleList articles={this.state.data}/>
          <div className="btn-more-view">
            <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})} style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
          </div>
        </div>
    );
  }
});