/**
 * 문의하기 게시판 react.js
 */

var ArticleInfo = React.createClass({
    articleClick:function(e){
        if(this.props.article.scrtArclYn == "Y" && this.props.article.regMbrNo != sMbrNo) {
            alert("비밀글 입니다.")
            return false;
        }
        if($(React.findDOMNode(this.refs.detail)).is(":visible")) {
            $(React.findDOMNode(this.refs.detail)).hide();
            $(".writing-list li").removeClass("active");
        } else {
            $(".subject-detail").hide();
            $(".writing-list li").removeClass("active");
            $(React.findDOMNode(this.refs.detail)).parent().addClass("active");
            $(React.findDOMNode(this.refs.detail)).show();
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
        qnaList.getList();
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
    var modClass = "none;";
    var ansStatus = "";
    if(ansSust != null && !ansSust.isEmpty()) {
      ansClass = "";
      ansClass2 = "question-detail";
      ansSust = replaceLineBreakHtml(ansSust);
      ansStatus = <b className='qa-ok'>[답변완료]</b>;
    } else {
      ansStatus = <b className='qa-no'>[미답변]</b>;
        if(this.props.article.regMbrNo == sMbrNo) {
            modClass = "";
        }
    }
    var secretClass = "subject-info";
    if(this.props.article.scrtArclYn == "Y") {
        secretClass  += " secret";
    }

    var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+this.props.article.cntntsTargtNo+"&lectTims="+this.props.article.cntntsTargtTims+"&schdSeq="+this.props.article.cntntsTargtSeq;
    var mentorUrl = mentor.contextpath + "/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo="+this.props.article.cntntsTargtId;
    var jobUrl = mentor.contextpath + "/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.article.jobNo;

    return (
      <li key={this.props.article.arclSer}>
        <div className={secretClass}>
          <a href="javascript:void(0)" onClick={this.articleClick} className="subject">{this.props.article.title}{ansStatus}</a>
          <span className={userClass}>{this.props.article.regMbrNm}</span>
          <span className="date">{(new Date(this.props.article.regDtm)).format("yyyy.MM.dd")}</span>
        </div>
        <div className="subject-detail" ref="detail">
          <div className="relation-lesson">
            <span style={{display:(this.props.article.cntntsTargtNo == 0)?'none':''}}><strong>관련수업</strong><a href={lectureUrl} target="_self" title="새창열림">{this.props.article.lectTitle}</a></span>
            <span style={{display:(this.props.article.ansRegMbrNm == null)?'none':''}}><strong>멘토</strong><a href={mentorUrl} target="_self" title="새창열림">{this.props.article.ansRegMbrNm}</a></span>
            <span style={{display:(this.props.article.jobNo == null || this.props.article.jobNo == "")?'none':''}}><strong>직업</strong><a href={jobUrl} target="_self" title="새창열림">{this.props.article.jobNm}</a></span>
          </div>
          <div className={ansClass2}>
            <div className="question">
              <span className="title">질문</span>
              <p className="info">
                {this.props.article.sust.split("\n").map(function(item, index) {
                  return (<b key={index}>{item}<br /></b>);
                })}
              </p>
            </div>
            <div className="answer" style={{display:ansClass}}>
              <span className="title">답변</span>
              <p className="info" dangerouslySetInnerHTML={{__html : ansSust+""}}></p>
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
    myCommunity();
  },
  getPrefList:function() {
    $.ajax({
      url: mentor.contextpath+"/community/ajax.getBoardPrefList.do",
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
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();
    var thisW = $("#qnaPop").width();
    var thisH = $("#qnaPop").height();
    $("#qnaPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    this.setState({'prefNo' : '', 'scrtArclYn' : '', 'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0});
    $('body').addClass('dim');
    $("#qnaPop").attr('tabindex',0).show().focus();
    $("#qnaPop").find('.layer-close, a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#qnaPop").hide();
    });
  },
  updateClick:function(obj) {
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();
    var thisW = $("#qnaPop").width();
    var thisH = $("#qnaPop").height();
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
      url: mentor.contextpath+"/community/ajax.registArcl.do",
      data : JSON.stringify(data),
      contentType: "application/json",
      dataType: 'json',
      type:'post',
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
    var dataList = null;
    if(this.state.data != null && this.state.data.length > 0){
        dataList = this.state.data.map(function(article, index) {
            return (<ArticleInfo key={index} article={article} updateClick={_this.updateClick} />);
            });
    } else if(firstCall) {
        dataList  = [];
        dataList.push(<li>
                        <div className="subject-info">
                             <a href="javascript:void(0)" className="subject" style={{'width':'100%', 'text-align':'center'}}>등록된 데이터가 없습니다.</a>
                        </div>
                      </li>);
    }
    return (
        <div>

          <ul className="writing-list">
            {dataList}
          </ul>

          <PageNavi
                                                url={this.props.url}
                                                pageFunc={this.goPage}
                                                totalRecordCount={this.state.totalRecordCount}
                                                currentPageNo={this.state.currentPageNo}
                                                recordCountPerPage={this.state.recordPerPage}
                                                contextPath={this.props.contextPath} />

          <div className="btn">
            <a href="javascript:void(0)" className="btn-border-type layer-open" title="등록 팝업 - 열기" onClick={this.registClick} style={{display:'block'}}>등록</a>
          </div>

          <div className="layer-pop-wrap" id="qnaPop">
            <div className="layer-pop">
              <div className="layer-header">
                <strong className="title">문의하기 등록</strong>
              </div>
              <div className="layer-cont">
                <div className="tbl-style inquiry">
                  <p><span className="essent-inp">필수입력 알림</span>필수입력</p>
                  <table>
                    <caption>문의하기 등록 - 분류,제목,내용</caption>
                    <colgroup>
                      <col style={{width:'20%'}} />
                      <col />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row"><span className="essent-inp">필수입력</span><label htmlFor="prefNo">분류</label></th>
                        <td>
                          <select className="slt-style" title="분류선택" id="prefNo" name="prefNo" value={this.state.prefNo} onChange={this.setPrefNo}>
                            <option value="">선택</option>
                          </select>
                          <span className="secret-text">
                            <label className="chk-skin" title="비밀글">
                              <input type="checkbox" id="scrtArclYn" name="scrtArclYn" value={this.state.scrtArclYn} checked={this.state.isChecked} onChange={this.chkScrtArclYn} />비밀글
                            </label>
                          </span>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><span className="essent-inp">필수입력</span><label htmlFor="title">제목</label></th>
                        <td><input type="text" id="title" name="title" className="inp-style" title="제목" value={this.state.title} onChange={this.chkTitle} /></td>
                      </tr>
                      <tr>
                        <th scope="row"><span className="essent-inp">필수입력</span><label htmlFor="sust">내용</label></th>
                        <td>
                          <div className="text-area popup">
                            <textarea className="ta-style" id="sust" name="sust" value={this.state.sust} onChange={this.chkSust} /><span className="text-limit"><strong id="currentTxt">{this.state.sustLen}</strong> / 400자</span>
                            <input type="hidden" id="arclSer" value={this.state.arclSer} />
                          </div>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div className="btn-area popup">
                  <a href="#" className="btn-type2 popup" onClick={this.registArcl} >확인</a>
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