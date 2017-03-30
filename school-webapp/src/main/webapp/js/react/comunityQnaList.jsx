/**
 * 문의하기 게시판 react.js
 */

var ArticleInfo = React.createClass({
  articleClick:function(e){
    if(this.props.article.scrtArclYn == "Y" && this.props.article.regMbrNo != this.props.mbrNo) {
        alert("비밀글 입니다.")
        return false;
    }
    if($(React.findDOMNode(this.refs.detail)).is(":visible")) {
      $(React.findDOMNode(this.refs.detail)).hide("fast");
      $(".writing-list li").removeClass("active");
    } else {
      $(".subject-detail").hide("fast");
      $(".writing-list li").removeClass("active");
      $(React.findDOMNode(this.refs.detail)).parent().addClass("active");
      $(React.findDOMNode(this.refs.detail)).show("fast");
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
    var sust = this.props.article.sust;
    if(sust != null && !sust.isEmpty()) {
        sust = replaceLineBreakHtml(sust);
    }
    var ansSust = this.props.article.cntntsSust;
    var modClass = "none";
    if(ansSust != null && !ansSust.isEmpty()) {
        ansClass = "";
        ansClass2 = "question-detail";
        ansSust = replaceLineBreakHtml(ansSust);
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
    var mentorUrl = '';
    if(this.props.article.ansRegMbrNm == "전체관리자") {
        mentorUrl = "javascript:void(0)";
    } else {
        mentorUrl = mentor.contextpath + "/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo="+this.props.article.cntntsTargtId;
    }
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;
    return (
      <li key={this.props.article.arclSer}>
        <div className={secretClass}>
          <a href="javascript:void(0)" onClick={this.articleClick} className="subject">{this.props.article.prefNm} | {this.props.article.title}</a>
          <span className={userClass}>{this.props.article.regMbrNm}</span>
          <span className="date">{(new Date(this.props.article.regDtm)).format("yyyy.MM.dd")}</span>
        </div>
        <div className="subject-detail" ref="detail">
          <div className="relation-lesson">
            <span style={{display:(this.props.article.cntntsTargtNo == 0)?'none':''}}><strong>관련수업</strong><a href={lectureUrl} target="_self" title="새창열림">{this.props.article.lectTitle}</a></span>
            <span style={{display:(this.props.article.ansRegMbrNm == null)?'none':''}}><strong>멘토</strong><a href={mentorUrl} target="_self" title="새창열림">{this.props.article.ansRegMbrNm}</a></span>
            <span style={{display:(this.props.article.jobNo == null || this.props.article.jobNo == "")?'none':''}}><strong>직업</strong><a href="javascript:void(0)" target="_self" title="새창열림">{this.props.article.jobNm}</a></span>
          </div>
          <div className={ansClass2}>
            <div className="question">
              <span className="title">질문</span>
              <div className="info" dangerouslySetInnerHTML={{__html : sust+""}} ></div>
            </div>
            <div className="answer" style={{display:ansClass}}>
              <span className="title">답변</span>
              <div className="info" dangerouslySetInnerHTML={{__html : ansSust+""}} ></div>
            </div>
            <div className="writing-btn" style={{display:modClass}}>
              <a href="javascript:void(0)" className="btn-modi layer-open" title="수정 팝업 - 열기" onClick={this._updateClick}>수정</a>
              <a href="javascript:void(0)" className="btn-del" onClick={this.deleteArcl}>삭제</a>
            </div>
          </div>
        </div>
      </li>
    );
  }
});

var QnaList = React.createClass({
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'searchKey' : 0, 'searchWord' : '', 'prefNo' : '', 'scrtArclYn' : '', 'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0, 'isChecked' : false,'recordPerPage':10,'currentPageNo':1};
  },
  componentDidMount: function() {
    this.getList();
    this.getPrefList();
  },
goPage:function(pageNo) {
    this.getList({'currentPageNo': pageNo});
  },
  getPrefList:function() {
    $.ajax({
      url: this.props.context+"/community/ajax.getBoardPrefList.do",
      data : {boardId : 'lecQnA'},
      contentType: "application/json",
      dataType: 'json',
      cache: false,
      success: function(rtnData) {
        var optStr = "";
        for(var i=0;i<rtnData.length;i++) {
          optStr += "<option value='"+rtnData[i].prefNo+"'>"+rtnData[i].prefNm+"</option>";
        }
        $("#prefNo").append(optStr);
      },
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }
    });
  },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'currentPageNo':this.state.currentPageNo,
      'pageSize' : this.props.pageSize,
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
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord, 'pageSize':_param.pageSize});
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord, 'pageSize':_param.pageSize});
          //}else{
          //  this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          //}
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  registClick:function () {
    if(!loginCheck()){
      $(location).attr("href", mentor.contextpath + "/login.do");
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
    this.setState({'prefNo' : '', 'scrtArclYn' : '', 'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0});
    $('#frm')[0].reset();
    $('#sust').val(' '); // 공백을 넣어주어야 에디터창이 초기화 된다.
    loadContent();
    $('.chk-skin').removeClass('checked');
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
      'prefNo' : obj.prefNo,
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

    /* 레이어 팝업 값 셋팅 */
    $('#prefNo').val(obj.prefNo);
    if(obj.scrtArclYn === 'Y') {
        $('.chk-skin').addClass('checked');
    } else {
        $('.chk-skin').removeClass('checked');
    }
    $('#title').val(obj.title);
    $('#sust').val(obj.sust);
    loadContent();
    $('#arclSer').val(obj.arclSer);
    /* 레이어 팝업 값 셋팅 */

    $('body').addClass('dim');
    $("#qnaPop").attr('tabindex',0).show().focus();
    $("#qnaPop").find('.layer-close, .btn-area.popup a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#qnaPop").hide();
    });
  },
  registArcl : function () {
    if($("#prefNo").val() === "") {
      alert("분류를 선택해 주세요.");
      return false;
    }
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
                       sust : this.state.sust,
                       scrtArclYn : this.state.scrtArclYn,
                       arclSer : this.state.arclSer };
    $.ajax({
      url: this.props.context+"/community/ajax.registArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type: 'post',
      cache: false,
      async:false,
      success: function(rtnData) {
        alert("등록했습니다.");
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
  setPrefNo:function(e) {
    this.setState({prefNo : e.target.value});
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
        <div>
          <div className="title-group">
            <div className="btn m-hide">
              <a href="javascript:void(0)" className="btn-border-type layer-open" title="등록 팝업 - 열기" onClick={this.registClick}>등록</a> <br />
            </div>
          </div>

          <ul className="writing-list">
            {this.state.data.map(function(article, index) {
                return (<ArticleInfo key={index} article={article} updateClick={_this.updateClick} mbrNo={_this.props.mbrNo} selArclSer={_this.props.selArclSer}/>);
              }
            )}
          </ul>

          <PageNavi
                                                url={this.props.url}
                                                pageFunc={this.goPage}
                                                totalRecordCount={this.state.totalRecordCount}
                                                currentPageNo={this.state.currentPageNo}
                                                recordCountPerPage={this.state.recordPerPage}
                                                pageSize={this.props.pageSize}
                                                contextPath={this.props.context} />

        </div>
    );
  }
});