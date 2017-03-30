/**
 * 자료실 react.js
 */

var UpFile = React.createClass({
  fileDelete:function() {
    this.props.fileDelete(this.props.fileSer);
  },
  render:function() {
    return(
      <li key={this.props.fileSer}><span className="file">{this.props.fileStr}</span><span onClick={this.fileDelete}>선택취소</span></li>
    );
  }
});

var Reply = React.createClass({
  render:function() {

    if(this.props.reply){
        var reply = replaceLineBreakHtml(this.props.reply);
        return (
          <div className="download-brd">
            <a href="javascript:void(0)" className="reply">답변</a>
            <ul><li><div style={{'padding-left':'39px'}} dangerouslySetInnerHTML={{__html : reply+""}} ></div></li></ul>
          </div>
        );
    }else{
        return false;
    }
  }
});

var AddFile = React.createClass({
  fileDelete:function(fileSer) {
    this.props.fileDelete(fileSer);
  },
  render:function() {
    var _this = this;
    var fileInfo = this.props.files.map(function(file, index) {
      if(file.comFileInfo) {
        file = file.comFileInfo;
      }
      var fileStr = file.oriFileNm + "(" +(Math.ceil(file.fileSize/1024/1024)) + "MB)"
      return(
        <UpFile key={index} fileStr={fileStr} fileSer={file.fileSer} fileDelete={_this.fileDelete} />
      );
    });
    return(
      <ul className="add-file">
        {fileInfo}
      </ul>
    );
  }
});

var FileInfo = React.createClass({
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileInfo.fileSer;
  },
  render:function() {
    return(
      <li key={this.props.fileInfo.fileSer}>
        <span className={this.props.classStr}>
          <a href="javascript:void(0)" onClick={this.downloadFile}>{this.props.fileInfo.oriFileNm}</a>
        </span>
        <span className="file-size">{Math.ceil(this.props.fileInfo.fileSize/1024/1024)}MB</span>
      </li>
    );
  }
});

var WorkInfo = React.createClass({
  articleClick:function(e){
    if($(React.findDOMNode(this.refs.fileDetail)).is(":visible")) {
      $(React.findDOMNode(this.refs.fileDetail)).hide();
      $(".title").removeClass("active");
    } else {
      $(".file-list").hide();
      $(".title").removeClass("active");
      $(React.findDOMNode(this.refs.fileDetail)).parent().find(".title").addClass("active");
      $(React.findDOMNode(this.refs.fileDetail)).show();
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
  downloadAll:function() {
    if(this.props.article.listArclFileInfo.length > 0) {
      location.href = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
    }
  },
  deleteArcl:function() {
    if(!confirm("삭제하시겠습니까?")) {
      return false;
    }
    var data =    {arclSer : this.props.article.arclSer,
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
        workList.getList();
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
  },
  updateClick:function() {
    this.props.updateClick(this.props.article);
  },
  render:function(){
    var _this = this;
    var fileArcl;
    var totalSize = 0;
    var userClass = "user " + this.props.article.mbrClassNm;

    if(this.props.article.listArclFileInfo.length > 0) {
      fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
        totalSize += file.comFileInfo.fileSize;

        var  classStr = "file-type ";
        if(file.comFileInfo.fileExt == "zip" || file.comFileInfo.fileExt == "7z" || file.comFileInfo.fileExt == "rar"){
          classStr = "file-type " + "zip";
        }else if(file.comFileInfo.fileExt == "mp3" || file.comFileInfo.fileExt == "wav" || file.comFileInfo.fileExt == "wma"){
          classStr = "file-type " + "mp4";
        }else if(file.comFileInfo.fileExt == "mp4" || file.comFileInfo.fileExt == "mov" || file.comFileInfo.fileExt == "avi"){
          classStr = "file-type " + "avi";
        }else if(file.comFileInfo.fileExt == "jpg" || file.comFileInfo.fileExt == "jpeg" || file.comFileInfo.fileExt == "png" || file.comFileInfo.fileExt == "gif"){
          classStr = "file-type " + "jpg";
        }else if(file.comFileInfo.fileExt == "hwp" || file.comFileInfo.fileExt == "pdf" || file.comFileInfo.fileExt == "txt"|| file.comFileInfo.fileExt == "pptx"|| file.comFileInfo.fileExt == "ppt"|| file.comFileInfo.fileExt == "xlsx" || file.comFileInfo.fileExt == "xls" || file.comFileInfo.fileExt == "docx"){
          classStr = "file-type " + "pptx";
        }else{
          classStr = "file-type " + file.comFileInfo.fileExt;
        }

        return (
          <FileInfo key={index} classStr={classStr} fileInfo={file.comFileInfo} />
        );
      });
    }
    return (
        <li>
          <div className="title">
            <a href="javascript:void(0)" onClick={this.articleClick}>
              <em>{this.props.article.title}</em>
              <div>
                <span className={userClass}>{this.props.article.regMbrNm}</span>
                <span className="file">{this.props.article.listArclFileInfo.length} 개 ({Math.ceil(totalSize/1024/1024)}MB)</span>
              </div>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <p className="relation-lesson"><strong>관련수업</strong><a href="#">{this.props.article.cntntsTargtNm}</a></p>
            <Reply reply={this.props.article.cntntsSust}/>
            <div className="download-brd">
              <a href="javascript:void(0)" onClick={this.downloadAll} className="all-down">전체파일 다운로드</a>
              <span>
                <a href="javascript:void(0)" className="btn-edit layer-open" title="수정 팝업 - 열기" onClick={this.updateClick}>수정</a>
                <a href="javascript:void(0)" className="btn-del" onClick={this.deleteArcl}>삭제</a>
              </span>
            </div>
            <ul>
              {fileArcl}
            </ul>
          </div>
        </li>
    );
  }
});

var WorkList = React.createClass({
  getInitialState: function() {
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':'', 'title' : '', sust : '', 'sustLen' : 0, 'arclSer' : 0, 'fileObj' : '', 'fileList' : [], 'cntntsTargtCd' : '', 'cntntsTargtNo' : '', 'cntntsTargtTims' : '', 'lastLectList':[],'recordPerPage':10,'currentPageNo':1};
  },
  componentDidMount: function() {
    this.getList();
    this.getLastLect();

    if(this.props.lectSer !='null'){
      dataSet.params.tabValue = 'work';
      $(".tab-type2 li").removeClass("mypage-data-li active");
      $("#homeWorkList").parent().addClass("mypage-data-li active");
      $('.mypage-wrap').hide();
      $("#homeWorkList").show();
      myCommunity();
      this.getList();
    }
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
        'teacherYn': this.props.teacherYn,
        'srchMbrNo': this.props.mbrNo
    }, param);
    $.ajax({
        url: this.props.url,
        data : _param,
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var rowCount = 0;
          var currentPageNo = 1;
          if(rtnData.length > 0) {
            rowCount = rtnData[0].totalRecordCount;
            currentPageNo = rtnData[0].currentPageNo;
          }
          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
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
  uploadFile:function() {
    if(this.state.fileList.length >= 5) {
      alert("최대 5개의 파일을 등록할 수 있습니다.");
      return;
    }

    //로딩바
    $("body").addClass("loader");
    $(".page-loader").show();
    var _this = this;
    $("#frm").ajaxForm({
      url : mentor.contextpath+"/uploadFile.do?"+mentor.csrf_parameterName+"="+mentor.csrf,
      dataType: 'text',
      success:function(data, status){
        var response = JSON.parse(data);
        $("body").removeClass("loader");
        $(".page-loader").hide();
        _this.setState({fileList: _this.state.fileList.concat(response)});
      }
    }).submit();
    return false;
  },
  registClick:function () {
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    thisW = $("#homeworkPop").width(),
    thisH = $("#homeworkPop").height();
    $("#homeworkPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    this.setState({'title' : '', 'sust' : '', 'arclSer' : 0, 'sustLen' : 0, 'fileList':[]});
    $('body').addClass('dim');
    $("#homeworkPop").attr('tabindex',0).show().focus();
    $("#homeworkPop").find('.layer-close, a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#homeworkPop").hide();
    });
  },
  updateClick:function (arclInfo) {
    windowWidth = $(window).width();
    windowHeight = $(window).height();
    thisW = $("#homeworkPop").width(),
    thisH = $("#homeworkPop").height();
    $("#homeworkPop").css({
      'left':(windowWidth/2)-(thisW/2),
      'top':(windowHeight/2)-(thisH/2)
    });
    this.setState({'title' : arclInfo.title, 'sust' : arclInfo.sust, 'arclSer' : arclInfo.arclSer, 'sustLen' : arclInfo.sust.length});
    var files = arclInfo.listArclFileInfo.map(function(file) {
      return file.comFileInfo;
    });
    this.setState({'fileList': files});
    $('body').addClass('dim');
    $("#homeworkPop").attr('tabindex',0).show().focus();
    $("#homeworkPop").find('.layer-close, a.cancel, .btn-area.border a.cancel').on('click',function (e) {
      $('body').removeClass('dim');
      $("#homeworkPop").hide();
    });
  },
  chkTitle:function(e) {
      this.setState({title : e.target.value});
  },
  chkSust:function(e) {
      this.setState({sust : e.target.value.substring(0,100), sustLen : this.state.sust.length});
  },
  registArcl :function() {
    if($("#lastLect").val() == null || $("#lastLect").val() == ''){
      alert("선택수업이 없습니다.");
      return false;
    }

    if(this.state.title == null || this.state.title == ''){
      alert("제목을 입력해주세요.");
      return false;
    }

    if(!confirm("등록하시겠습니까?")) {
      return false;
    }

    var fileSers ="";
    var lastLecVal = $("#lastLect").val().split(";");
    this.state.fileList.map(function(file) {
      fileSers += file.fileSer+",";
    });

    var data = {title : this.state.title,
                       boardId : this.props.boardId,
                       sust : this.state.sust,
                       arclSer : this.state.arclSer,
                       cntntsTargtCd : '101510',
                       cntntsTargtNo : lastLecVal[0],
                       cntntsTargtTims : lastLecVal[1],
                       cntntsTargtNm : $("#lastLect option:selected").text(),
                       fileSers : fileSers};

    $.ajax({
      url: mentor.contextpath+"/community/ajax.registArcl.do",
      data : JSON.stringify(data),
      contentType: 'application/json',
      dataType: 'json',
      type:'POST',
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
    $("#homeworkPop").hide();
  },
  fileDelete:function(fileSer) {
    this.setState({fileList : this.state.fileList.filter(function(file) {
        return file.fileSer != fileSer;
      })
    });
  },
  getLastLect:function() {
    $.ajax({
        url: mentor.contextpath+"/community/ajax.getLastLectList.do",
        data : {mbrNo : this.props.mbrNo},
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          var optStr = "";
          for(var i=0;i<rtnData.length;i++) {
            optStr += "<option value='"+rtnData[i].LECT_SER+";"+rtnData[i].LECT_TIMS+";"+rtnData[i].SCHD_SEQ+"'>"+rtnData[i].LECT_TITLE+"</option>";
          }
          $("#lastLect").append(optStr);
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this = this;
    var options = this.state.lastLectList.map(function(lect, index) {
      return <option key={index} value={lect.LECT_SER} lectTims={lect.LECT_TIMS} schdSeq={lect.SCHD_SEQ} >{lect.LECT_TITLE}</option>;
    });


    var dataList = null;
    if(this.state.data != null && this.state.data.length > 0){
        dataList = this.state.data.map(function(article, index) {
            return (<WorkInfo key={index} article={article} updateClick={_this.updateClick} />);
            });
    } else if(firstCall) {
        dataList  = [];
        dataList.push(<li>
                        <div className="title">
                             <a href="javascript:void(0)">
                                <em style={{'width':'100%', 'text-align':'center'}}>등록된 데이터가 없습니다.</em>
                             </a>
                        </div>
                      </li>);
    }
    return (
        <div>

          <ul className="community-data-list">
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

          <div className="layer-pop-wrap" id="homeworkPop">
            <div className="layer-pop">
              <div className="layer-header">
                <strong className="title">수업과제 등록</strong>
              </div>
              <div className="layer-cont">
                <div className="tbl-style homework">
                  <table>
                    <caption>수업과제 등록 입력창 - 관련수업, 제목,내용, 분류</caption>
                    <colgroup>
                      <col style={{width:'20%'}} />
                      <col />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row">관련수업</th>
                        <td>
                          <select id="lastLect" className="slt-style" title="관련수업" >
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row"><label htmlFor="essentTitle">제목</label></th>
                        <td><input type="text" id="essentTitle" className="inp-style" title="제목" value={this.state.title} onChange={this.chkTitle} maxLength="50"/></td>
                      </tr>
                      <tr>
                        <th scope="row"><label htmlFor="textaInfo">내용</label></th>
                        <td>
                          <div className="text-area popup">
                            <textarea id="textaInfo" className="ta-style" name="text" value={this.state.sust} onChange={this.chkSust} /><span className="text-limit"><strong>{this.state.sustLen}</strong> / 100자</span>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <th scope="row">첨부파일</th>
                        <td className="add-style">
                          <span className="select-file">개별 파일 용량은 20MB 및 최대 5개까지 지원</span>
                          <div className="search-file">
                            <form id="frm" method="post" encType="multipart/form-data" action={mentor.contextpath+"/myPage/myInfo/uploadFile.do?"+mentor.csrf_parameterName+"="+mentor.csrf}>
                              <input type="file" title="파일찾기" name="upload_file" onChange={this.uploadFile} />
                            </form>
                          </div>
                          <AddFile files={this.state.fileList} fileDelete={this.fileDelete} />
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