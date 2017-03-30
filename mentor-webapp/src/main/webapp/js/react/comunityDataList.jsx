/**
 * 자료실 react.js
 */
var UpFile = React.createClass({
  fileDelete:function() {
    this.props.fileDelete(this.props.fileSer);
  },
  render:function() {
    var fileInfo = "";
    return(
      <li>{this.props.fileStr}<a href="javascript:void(0)" onClick={this.fileDelete}><img src={mentor.contextpath+"/images/common/btn_file_del.gif"} alt="삭제" /></a></li>
    );
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
      <ul className="file-list-type01">
        {fileInfo}
      </ul>
    );
  }
});

var FileInfo = React.createClass({
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?origin=true&fileSer="+this.props.file.fileSer;
  },
  render:function() {
    return (
      <li key={this.props.file.fileSer}>
        <span className={this.props.classStr}>
          <a href="javascript:void(0)" onClick={this.downloadFile}>{this.props.file.comFileInfo.oriFileNm}</a>
        </span>
        <span className="file-size">{Math.ceil(this.props.file.comFileInfo.fileSize/1024/1024)}MB</span>
      </li>
    );
  }
});

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
        mentor.DataList.getList();
      },
      error: function(xhr, status, err) {
        console.error("ajax.deleteArcl.do", status, err.toString());
      }
    });
  },
  downloadAll:function() {
    if(this.props.article.listArclFileInfo.length > 0) {
      location.href = mentor.contextpath+"/fileDownAll.do?arclSer="+this.props.article.arclSer+"&boardId="+this.props.article.boardId;
    }
  },
  render:function(){
    var fileArcl;
    var totalSize = 0;
    var userClass = "user " + this.props.article.mbrClassNm;
    if(this.props.article.listArclFileInfo.length > 0) {
      fileArcl = this.props.article.listArclFileInfo.map(function(file, index) {
        totalSize += file.comFileInfo.fileSize;
        var classStr = "file-type " + file.comFileInfo.fileExt.changeExt();
        return (
          <FileInfo key={index} classStr={classStr} file={file} />
        );
      });
    }

    var prefNm = "";
    switch(this.props.article.prefNo){
    case 'beforeData':
        prefNm = <b>[사전보조자료]</b>;
        break;
    case 'afterData':
        prefNm = <b>[사후보조자료]</b>;
        break;
    case 'etcData':
        prefNm = <b>[기타자료]</b>;
        break;
    case 'lectData':
        prefNm = <b>[수업보조자료]</b>;
        break;
    default:
        prefNm = "";
    }

    var cntntsTypeNm = "";
    switch(this.props.article.cntntsTypeCd){
    case '101534':
        cntntsTypeNm = <span className='icon-rating elementary'>초</span>;
        break;
    case '101535':
        cntntsTypeNm = <span className='icon-rating middle'>중</span>;
        break;
    case '101536':
        cntntsTypeNm = <span className='icon-rating high'>고</span>;
        break;
    case '101537':
        cntntsTypeNm = <span><span className='icon-rating elementary'>초</span><span className='icon-rating middle'>중</span></span>;
        break;
    case '101538':
        cntntsTypeNm = <span><span className='icon-rating middle'>중</span><span className='icon-rating high'>고</span></span>;
        break;
    case '101539':
        cntntsTypeNm = <span><span className='icon-rating elementary'>초</span><span className='icon-rating high'>고</span></span>;
        break;
    case '101540':
        cntntsTypeNm = <span><span className='icon-rating elementary'>초</span><span className='icon-rating middle'>중</span><span className='icon-rating high'>고</span></span>;
        break;
    default:
        cntntsTypeNm = "";
    }
    return (
        <li>
          <div className="title">
            <a href="javascript:void(0);" onClick={this.articleClick}>
              <span className="num"><span className="notice" style={{display:(this.props.article.notiYn == "Y")?"":"none"}}>공지</span>{this.props.article.notiYn == 'Y'?'':this.props.idx}</span>
              {cntntsTypeNm}
              <em className="title notice" style={{width:'500px'}}>{prefNm}{this.props.article.title}</em>
              <span className="file-mb"><em>{this.props.article.listArclFileInfo.length}</em>개<span>({Math.ceil(totalSize/1024/1024)}MB)</span></span>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <div className="file-down">
              <span className="left">
                <a href="javascript:void(0)" className="all-file-down" style={{display:(this.props.article.listArclFileInfo.length > 1)?'':'none'}} onClick={this.downloadAll}>전체파일 다운로드</a>
              </span>
              <span className="right">
                <a href="javascript:void(0)" className="layer-open" onClick={this.openLayer}><img src={mentor.contextpath+"/images/community/btn_icon_modify.png"} alt="수정" /></a>
                <a href="javascript:noid(0)" onClick={this.deleteArcl}><img src={mentor.contextpath+"/images/community/btn_icon_delete.png"} alt="삭제" /></a>
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

var DataList = React.createClass({
  getInitialState: function() {
    return {'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 10, 'currentPageNo' : 1, 'searchKey' : 0, 'searchWord' : '', 'isChecked' : false, fileSers : '', arclSer : 0, 'fileList' : [], title : '', notiYn : 'N'};
  },
  componentDidMount: function() {
    $(document.body).on('keydown', this.handleKeyDown);
    this.getList();
  },
  componentWillUnmount: function() {
    $(document.body).off('keydown', this.handleKeyDown);
  },
  goPage:function(pageNo) {
    this.setState({'currentPageNo' : pageNo});
    this.getList();
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
    $.ajax({
        url: mentor.contextpath+"/community/ajax.getNoticeCount.do",
        data : {
          boardId : this.props.boardId,
          srchMbrNo : this.props.sMbrNo
        },
        contentType: "application/json",
        dataType: 'json',
        cache: false,
        success: function(rtnData) {
          this.setState({notiCnt : rtnData});
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(mentor.contextpath+"/community/ajax.getNoticeCount.do", status, err.toString());
        }.bind(this)
    });

    e.preventDefault();
    $('body').addClass('dim');
    $("#layer1").attr('tabindex',0).show().focus();
    $("#layer1").find('.pop-close, .btn-area.popup a.cancel, .btn-type2.gray').on('click',function (e) {
      e.preventDefault();
      $('body').removeClass('dim');
      $("#layer1").hide();
    });

    $("input:checkbox[name=lectTargtCheck]").each(function (idx) {
        if(typeof(article) == "object"){
            var cntntsTypeCds = [];
            switch(article.cntntsTypeCd){
                case '101534':
                    cntntsTypeCds.push(article.cntntsTypeCd);
                    break;
                case '101535':
                    cntntsTypeCds.push(article.cntntsTypeCd);
                    break;
                case '101536':
                    cntntsTypeCds.push(article.cntntsTypeCd);
                    break;
                case '101537':
                    cntntsTypeCds.push('101534','101535');
                    break;
                case '101538':
                    cntntsTypeCds.push('101535','101536');
                    break;
                case '101539':
                    cntntsTypeCds.push('101534','101536');
                    break;
                case '101540':
                    cntntsTypeCds.push('101534','101535','101536');
                    break;
                default:
            }

            var idx = $.inArray($(this).val(),cntntsTypeCds);
            if(idx >= 0){
                $(this).parent().addClass("checked");
            }else{
                $(this).parent().removeClass("checked");
            }

        }else{
            if(idx == 0)
                $(this).parent().addClass("checked");
            else
                $(this).parent().removeClass("checked");
        }
    });

    $("input:radio[name=categorize]").each(function (idx) {
        if(typeof(article) == "object"){
             if($(this).val() == article.prefNo){
                $(this).parent().addClass("checked");
             }else{
                $(this).parent().removeClass("checked");
             }
        }else{
            if(idx == 0)
                $(this).parent().addClass("checked");
            else
                $(this).parent().removeClass("checked");
        }
    });

    this.setState({title : article.title, arclSer : article.arclSer});
    var files = article.listArclFileInfo.map(function(file) {
      return file.comFileInfo;
    });
    this.setState({'fileList': files});
    /*
    if(article.notiYn === "Y") {
      this.setState({isChecked : true, notiYn : 'Y'});
    } else {
      this.setState({isChecked : false, notiYn : 'N'});
    }
    */
  },
  uploadFile:function() {
    if(this.state.fileList.length >= 5) {
      alert("최대 5개의 파일을 등록할 수 있습니다.");
      return;
    }
    var _this = this;
    //로딩바
    $("body").addClass("loader");
    $(".page-loader").show();
    $("#frm").ajaxForm({
      url : mentor.contextpath+"/uploadFile.do?"+mentor.csrf_parameterName+"="+mentor.csrf,
      sync : true,
      dataType : 'text',
      success:function(response, status){
        $("body").removeClass("loader");
        $(".page-loader").hide();
        _this.setState({fileList: _this.state.fileList.concat(response)});
      }
    }).submit();

    $("#frm").each(function(){
      this.reset();
    });
  },
  fileDelete:function(fileSer) {
    this.setState({fileList : this.state.fileList.filter(function(file) {
        return file.fileSer != fileSer;
      })
    });
  },
  registArcl :function() {
    if(!confirm("등록하시겠습니까?")) {
      return false;
    }
    var fileSers ="";
    this.state.fileList.map(function(file) {
      fileSers += file.fileSer+",";
    });

    var data = {title : this.state.title,
                       boardId : this.props.boardId,
                       sust : '',
                       arclSer : this.state.arclSer,
                       notiYn : this.state.notiYn,
                       fileSers : fileSers};
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
  setSearchKey:function(e) {
    this.setState({searchKey : e.target.value});
  },
  setSearchWord:function(e) {
    this.setState({searchWord : e.target.value});
  },
  searchList:function() {
    this.getList();
  },
  setCheckBox:function(e) {
    if(this.state.isChecked) {
      this.setState({isChecked : false, notiYn : 'N'});
      this.setState({notiCnt : this.state.notiCnt - 1});
    } else {
      if(this.state.notiCnt >= 3) {
        alert("최대 3개까지 공지 지정이 가능합니다.");
        return false;
      }
      this.setState({isChecked : true, notiYn : 'Y'});
      this.setState({notiCnt : this.state.notiCnt + 1});
    }
  },
  titleCheck:function(e) {
      this.setState({title : e.target.value});
  },
  setRowCount:function(e) {
      this.setState({recordCountPerPage : e.target.value});
  },
  handleKeyDown: function(e) {
    var ENTER = 13;
    if( e.keyCode == ENTER ) {
      this.getList();
    }
  },
  render:function(){
    var _this = this;
    var article = null;
    var pageNode = [];
    if(this.state.data != null && this.state.data.length > 0) {
        pageNode.push(<PageNavi url={this.props.url} pageFunc={this.goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} />);
        article = this.state.data.map(function(article, index){
            var idx = _this.state.totalRecordCount - ((_this.state.currentPageNo -1)*10) - index;
            return (<Article key={index} article={article} selArclSer={_this.props.selArclSer} idx={idx} openLayer={_this.openLayer} />);
        });
    } else {
        article = [];
        article.push(<li className="no-data-txt">자료가 없습니다.</li>);
    }
    return (
        <div className="lesson-task data">

          <span className="list-num">
            <select style={{width:'70px'}} onChange={this.setRowCount} value={this.state.recordCountPerPage}>
              <option value="10">10</option>
              <option value="20">20</option>
              <option value="30">30</option>
              <option value="50">50</option>
            </select>
          </span>

          <ul className="lesson-data-list">
            {article}
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
              <strong>수업자료 수정</strong>
              <a href="#" className="pop-close"><img src={mentor.contextpath+"/images/common/btn_popup_close.png"} alt="팝업 닫기" /></a>
            </div>
            <div className="cont type1">
              <div className="lesson-data">
                <span className="designation"><label><input type="checkbox" name="notiYn" className="aaa" checked={this.state.isChecked} onClick={this.setCheckBox} /> 공지 지정</label></span>
                <div className="board-input-type1 upload">
                  <table>
                    <caption>추가정보 항목 - 연락처, 직업선택, 멘토약력 및 자기소개</caption>
                    <colgroup>
                      <col style={{width:'98px'}} />
                      <col />
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="row">제목</th>
                        <td><input type="text" className="inp-style1 h30" style={{width:'485px'}} value={this.state.title} onChange={this.titleCheck} /></td>
                      </tr>
                      <tr>
                        <th scope="row">분류</th>
                        <td>
                          <label className="radio-skin checked" style={{'margin-right': '15px'}}><input type="radio" title="사전보조자료" name="categorize" value="beforeData" />사전보조자료</label>
                          <label className="radio-skin" style={{'margin-right': '15px'}}><input type="radio" title="사후보조자료" name="categorize" value="afterData" />사후보조자료</label>
                          <label className="radio-skin" style={{'margin-right': '15px'}}><input type="radio" title="수업보조자료" name="categorize" value="lectData" />수업보조자료</label>
                          <label className="radio-skin" style={{'margin-right': '15px'}}><input type="radio" title="기타자료" name="categorize" value="etcData" />기타자료</label>
                        </td>
                      </tr>
                      <tr>
                          <th scope="row">수업대상</th>
                          <td>
                              <label className="chk-skin checked" style={{'margin-right': '15px'}}><input type="checkbox" name="lectTargtCheck" id="lectTargtCheck0" className="chk-skin" value="101534" />초등</label>
                              <label className="chk-skin" style={{'margin-right': '15px'}}><input type="checkbox" name="lectTargtCheck" id="lectTargtCheck1" className="chk-skin" value="101535"/>중등</label>
                              <label className="chk-skin" style={{'margin-right': '15px'}}><input type="checkbox" name="lectTargtCheck" id="lectTargtCheck2" className="chk-skin" value="101536"/>고등</label>
                          </td>
                      </tr>
                      <tr>
                        <th scope="row">파일첨부</th>
                        <td>
                          <div className="input-file">
                            <form id="frm" method="post" encType="multipart/form-data">
                              <input type="file" title="파일찾기" name="upload_file" onChange={this.uploadFile} />
                            </form>
                            <span className="max-num">* 개별 파일 용량 20MB 및 최대 5개까지 지원</span>
                          </div>
                          <AddFile files={this.state.fileList} fileDelete={this.fileDelete} />
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
                <div className="btn-area">
                  <a href="javascript:void(0)" className="btn-type2" onClick={this.registArcl }>확인</a>
                  <a href="#" className="btn-type2 gray">취소</a>
                </div>
              </div>
            </div>
          </div>
        </div>
    );
  }
});

mentor.DataList = React.render(
  <DataList url={mentor.contextpath+'/community/ajax.mentorDataArclList.do'} boardId='lecFile' sMbrNo={sMbrNo} />,
  document.getElementById('boardDataList')
);
