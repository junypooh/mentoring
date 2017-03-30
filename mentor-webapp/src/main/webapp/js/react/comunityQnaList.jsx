/**
 * 질문답변 react.js
 */

var Article = React.createClass({
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
    if(this.props.article.arclSer == selArclSer ){
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
    var artTitle = this.props.article.title;
    var ansStatus = <b className='qa-ok'>[답변완료]</b>;
    if(ansSust == null) {
      ansSust = "";
      ansStatus = <b className='qa-no'>[미답변]</b>;
    }

    var classname = "user " + this.props.article.mbrClassNm;

    var replyclassname = this.props.article.ansMbrClassNm == 'mentor' ? "user mentor" : (this.props.article.ansMbrClassNm == 'teacher' ? "user teacher" : "name");

    return (
        <li>
          <div className="title">
            <a href="javascript:void(0);" onClick={this.articleClick}>
              <span className="num">{this.props.totalCnt - this.props.article.rn + 1}</span>
              <em className="title notice">{this.props.article.title} {ansStatus}</em>
              <span className={classname}>{this.props.article.regMbrNm}</span>
              <span className="day">{new Date(this.props.article.regDtm).format("yyyy.MM.dd")}</span>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <p className="task-cont">
              {this.props.article.sust.split("\n").map(function(item, index) {
                return(<span key={index}>{item}<br /></span>);
              })}
            </p>
            <div className="btn-area" style={{display:ansSust != ""?"none":""}}>
              <a href="javascript:void(0)" className="btn-type1 reply layer-open" onClick={this.openLayer}>답변</a>
            </div>
            <div className="reply-area" style={{display:ansSust != ""?"":"none"}}>
              <a href="javascript:void(0)" onClick={this.showAnswer} ref="ansClick">
                <em>{ansSust}</em>
                <span className={replyclassname}>{this.props.article.ansRegMbrNm}</span>
                <span className="day">{new Date(this.props.article.ansRegDtm).format("yyyy.MM.dd")}</span>
              </a>
              <p className="full-answer" ref="ansSust">
                  {ansSust.split("\n").map(function(item, index) {
                    return (<span key={index}> {item}<br /></span>)
                  })}
                <span className="delete">
                  <a href="javascript:void(0)" className="layer-open" onClick={this.openLayer}><img src={mentor.contextpath+"/images/community/btn_icon_modify.png"} alt="수정" /></a>
                  <a href="javascript:void(0)" onClick={this.deleteAnswer}><img src={mentor.contextpath+"/images/community/btn_wastebasket.png"} alt="삭제" /></a>
                </span>
              </p>
            </div>
          </div>
        </li>
    );
  }
});

var DataList = React.createClass({
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 10, 'currentPageNo' : 1,  'searchKey' : 0, 'searchWord' : '', arclSer : 0, ansSust : '', ansSustLen : 0};
  },
  componentWillUnmount: function() {
    $(document.body).off('keydown', this.handleKeyDown);
  },
  componentDidMount: function() {
    $(document.body).on('keydown', this.handleKeyDown);
    this.getList();
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
    var data ={
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
        pageNode.push(<PageNavi url={this.props.url} pageFunc={this.goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} />);
    }
    return (
        <div className="lesson-task qna">

          <span className="list-num">
              <select style={{width:'70px'}} onChange={this.setRowCount} value={this.state.recordCountPerPage}>
                  <option value="10">10</option>
                  <option value="20">20</option>
                  <option value="30">30</option>
                  <option value="50">50</option>
              </select>
          </span>

          <ul className="lesson-data-list">
            {this.state.data.map(function(article, index){
              return (<Article key={index} article={article} selArclSer={_this.props.selArclSer} totalCnt={_this.state.totalRecordCount} openLayer={_this.openLayer} deleteAnswer={_this.deleteAnswer} />);
            })}
          </ul>

          {pageNode}

          <fieldset className="list-search-area">
            <legend>검색</legend>
            <select value={this.state.searchKey} onChange={this.setSearchKey}>
              <option value="0">전체</option>
              <option value="1">제목</option>
              <option value="2">내용</option>
            </select>
            <input type="search" className="inp-style1" value={this.state.searchWord} onChange={this.setSearchWord} />
            <a href="#" className="btn-search" onClick={this.searchList}><span>검색</span></a>
          </fieldset>

          <div className="layer-pop-wrap" id="layer1">
            <div className="title">
              <strong>문의하기 답변</strong>
              <a href="javascript:void(0)" className="pop-close"><img src={mentor.contextpath+"/images/common/btn_popup_close.png"} alt="팝업 닫기" /></a>
            </div>
            <div className="cont type1">
              <div className="lesson-task-popup">
                <textarea name="" rows="" className="textarea-type1" cols="" value={this.state.ansSust} onChange={this.checkAns} />
                <span className="area-txt"><em>{this.state.ansSustLen}</em>/400자</span>
              </div>
              <div className="btn-area">
                <a href="javascript:void(0)" className="btn-type2" onClick={this.registAns}>확인</a>
                <a href="javascript:void(0)" className="btn-type2 gray">취소</a>
              </div>
            </div>
          </div>

        </div>
    );
  }
});

mentor.DataList = React.render(
  <DataList url={mentor.contextpath+'/community/ajax.mentorDataArclList.do'} boardId='lecQnA' sMbrNo={sMbrNo} />,
  document.getElementById('boardQnaList')
);
