/**
 * 자료실 react.js
 */
var UpFile = React.createClass({displayName: "UpFile",
  fileDelete:function() {
    this.props.fileDelete(this.props.fileSer);
  },
  render:function() {
    var fileInfo = "";
    return(
      React.createElement("li", null, this.props.fileStr, React.createElement("a", {href: "javascript:void(0)", onClick: this.fileDelete}, React.createElement("img", {src: mentor.contextpath+"/images/common/btn_file_del.gif", alt: "삭제"})))
    );
  }
});

 var AddFile = React.createClass({displayName: "AddFile",
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
        React.createElement(UpFile, {key: index, fileStr: fileStr, fileSer: file.fileSer, fileDelete: _this.fileDelete})
      );
    });
    return(
      React.createElement("ul", {className: "file-list-type01"}, 
        fileInfo
      )
    );
  }
});

var FileInfo = React.createClass({displayName: "FileInfo",
  downloadFile:function() {
    location.href = mentor.contextpath+"/fileDown.do?origin=true&fileSer="+this.props.file.fileSer;
  },
  render:function() {
    return (
      React.createElement("li", {key: this.props.file.fileSer}, 
        React.createElement("span", {className: this.props.classStr}, 
          React.createElement("a", {href: "javascript:void(0)", onClick: this.downloadFile}, this.props.file.comFileInfo.oriFileNm)
        ), 
        React.createElement("span", {className: "file-size"}, Math.ceil(this.props.file.comFileInfo.fileSize/1024/1024), "MB")
      )
    );
  }
});

var Article = React.createClass({displayName: "Article",
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
          React.createElement(FileInfo, {key: index, classStr: classStr, file: file})
        );
      });
    }

    var prefNm = "";
    switch(this.props.article.prefNo){
    case 'beforeData':
        prefNm = React.createElement("b", null, "[사전보조자료]");
        break;
    case 'afterData':
        prefNm = React.createElement("b", null, "[사후보조자료]");
        break;
    case 'etcData':
        prefNm = React.createElement("b", null, "[기타자료]");
        break;
    case 'lectData':
        prefNm = React.createElement("b", null, "[수업보조자료]");
        break;
    default:
        prefNm = "";
    }

    var cntntsTypeNm = "";
    switch(this.props.article.cntntsTypeCd){
    case '101534':
        cntntsTypeNm = React.createElement("span", {className: "icon-rating elementary"}, "초");
        break;
    case '101535':
        cntntsTypeNm = React.createElement("span", {className: "icon-rating middle"}, "중");
        break;
    case '101536':
        cntntsTypeNm = React.createElement("span", {className: "icon-rating high"}, "고");
        break;
    case '101537':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating elementary"}, "초"), React.createElement("span", {className: "icon-rating middle"}, "중"));
        break;
    case '101538':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating middle"}, "중"), React.createElement("span", {className: "icon-rating high"}, "고"));
        break;
    case '101539':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating elementary"}, "초"), React.createElement("span", {className: "icon-rating high"}, "고"));
        break;
    case '101540':
        cntntsTypeNm = React.createElement("span", null, React.createElement("span", {className: "icon-rating elementary"}, "초"), React.createElement("span", {className: "icon-rating middle"}, "중"), React.createElement("span", {className: "icon-rating high"}, "고"));
        break;
    default:
        cntntsTypeNm = "";
    }
    return (
        React.createElement("li", null, 
          React.createElement("div", {className: "title"}, 
            React.createElement("a", {href: "javascript:void(0);", onClick: this.articleClick}, 
              React.createElement("span", {className: "num"}, React.createElement("span", {className: "notice", style: {display:(this.props.article.notiYn == "Y")?"":"none"}}, "공지"), this.props.article.notiYn == 'Y'?'':this.props.idx), 
              cntntsTypeNm, 
              React.createElement("em", {className: "title notice", style: {width:'500px'}}, prefNm, this.props.article.title), 
              React.createElement("span", {className: "file-mb"}, React.createElement("em", null, this.props.article.listArclFileInfo.length), "개", React.createElement("span", null, "(", Math.ceil(totalSize/1024/1024), "MB)"))
            )
          ), 
          React.createElement("div", {className: "file-list", ref: "fileDetail"}, 
            React.createElement("div", {className: "file-down"}, 
              React.createElement("span", {className: "left"}, 
                React.createElement("a", {href: "javascript:void(0)", className: "all-file-down", style: {display:(this.props.article.listArclFileInfo.length > 1)?'':'none'}, onClick: this.downloadAll}, "전체파일 다운로드")
              ), 
              React.createElement("span", {className: "right"}, 
                React.createElement("a", {href: "javascript:void(0)", className: "layer-open", onClick: this.openLayer}, React.createElement("img", {src: mentor.contextpath+"/images/community/btn_icon_modify.png", alt: "수정"})), 
                React.createElement("a", {href: "javascript:noid(0)", onClick: this.deleteArcl}, React.createElement("img", {src: mentor.contextpath+"/images/community/btn_icon_delete.png", alt: "삭제"}))
              )
            ), 
            React.createElement("ul", null, 
              fileArcl
            )
          )
        )
    );
  }
});

var DataList = React.createClass({displayName: "DataList",
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
        pageNode.push(React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage}));
        article = this.state.data.map(function(article, index){
            var idx = _this.state.totalRecordCount - ((_this.state.currentPageNo -1)*10) - index;
            return (React.createElement(Article, {key: index, article: article, selArclSer: _this.props.selArclSer, idx: idx, openLayer: _this.openLayer}));
        });
    } else {
        article = [];
        article.push(React.createElement("li", {className: "no-data-txt"}, "자료가 없습니다."));
    }
    return (
        React.createElement("div", {className: "lesson-task data"}, 

          React.createElement("span", {className: "list-num"}, 
            React.createElement("select", {style: {width:'70px'}, onChange: this.setRowCount, value: this.state.recordCountPerPage}, 
              React.createElement("option", {value: "10"}, "10"), 
              React.createElement("option", {value: "20"}, "20"), 
              React.createElement("option", {value: "30"}, "30"), 
              React.createElement("option", {value: "50"}, "50")
            )
          ), 

          React.createElement("ul", {className: "lesson-data-list"}, 
            article
          ), 

          pageNode, 

          React.createElement("fieldset", {className: "list-search-area"}, 
            React.createElement("legend", null, "검색"), 
            React.createElement("select", {value: this.state.searchKey, onChange: this.setSearchKey}, 
              React.createElement("option", {value: "0"}, "전체"), 
              React.createElement("option", {value: "1"}, "제목"), 
              React.createElement("option", {value: "2"}, "내용")
            ), 
            React.createElement("input", {type: "search", className: "inp-style1", value: this.state.searchWord, onChange: this.setSearchWord}), 
            React.createElement("a", {href: "#", className: "btn-search", onClick: this.searchList}, React.createElement("span", null, "검색"))
          ), 

          React.createElement("div", {className: "layer-pop-wrap", id: "layer1"}, 
            React.createElement("div", {className: "title"}, 
              React.createElement("strong", null, "수업자료 수정"), 
              React.createElement("a", {href: "#", className: "pop-close"}, React.createElement("img", {src: mentor.contextpath+"/images/common/btn_popup_close.png", alt: "팝업 닫기"}))
            ), 
            React.createElement("div", {className: "cont type1"}, 
              React.createElement("div", {className: "lesson-data"}, 
                React.createElement("span", {className: "designation"}, React.createElement("label", null, React.createElement("input", {type: "checkbox", name: "notiYn", className: "aaa", checked: this.state.isChecked, onClick: this.setCheckBox}), " 공지 지정")), 
                React.createElement("div", {className: "board-input-type1 upload"}, 
                  React.createElement("table", null, 
                    React.createElement("caption", null, "추가정보 항목 - 연락처, 직업선택, 멘토약력 및 자기소개"), 
                    React.createElement("colgroup", null, 
                      React.createElement("col", {style: {width:'98px'}}), 
                      React.createElement("col", null)
                    ), 
                    React.createElement("tbody", null, 
                      React.createElement("tr", null, 
                        React.createElement("th", {scope: "row"}, "제목"), 
                        React.createElement("td", null, React.createElement("input", {type: "text", className: "inp-style1 h30", style: {width:'485px'}, value: this.state.title, onChange: this.titleCheck}))
                      ), 
                      React.createElement("tr", null, 
                        React.createElement("th", {scope: "row"}, "분류"), 
                        React.createElement("td", null, 
                          React.createElement("label", {className: "radio-skin checked", style: {'margin-right': '15px'}}, React.createElement("input", {type: "radio", title: "사전보조자료", name: "categorize", value: "beforeData"}), "사전보조자료"), 
                          React.createElement("label", {className: "radio-skin", style: {'margin-right': '15px'}}, React.createElement("input", {type: "radio", title: "사후보조자료", name: "categorize", value: "afterData"}), "사후보조자료"), 
                          React.createElement("label", {className: "radio-skin", style: {'margin-right': '15px'}}, React.createElement("input", {type: "radio", title: "수업보조자료", name: "categorize", value: "lectData"}), "수업보조자료"), 
                          React.createElement("label", {className: "radio-skin", style: {'margin-right': '15px'}}, React.createElement("input", {type: "radio", title: "기타자료", name: "categorize", value: "etcData"}), "기타자료")
                        )
                      ), 
                      React.createElement("tr", null, 
                          React.createElement("th", {scope: "row"}, "수업대상"), 
                          React.createElement("td", null, 
                              React.createElement("label", {className: "chk-skin checked", style: {'margin-right': '15px'}}, React.createElement("input", {type: "checkbox", name: "lectTargtCheck", id: "lectTargtCheck0", className: "chk-skin", value: "101534"}), "초등"), 
                              React.createElement("label", {className: "chk-skin", style: {'margin-right': '15px'}}, React.createElement("input", {type: "checkbox", name: "lectTargtCheck", id: "lectTargtCheck1", className: "chk-skin", value: "101535"}), "중등"), 
                              React.createElement("label", {className: "chk-skin", style: {'margin-right': '15px'}}, React.createElement("input", {type: "checkbox", name: "lectTargtCheck", id: "lectTargtCheck2", className: "chk-skin", value: "101536"}), "고등")
                          )
                      ), 
                      React.createElement("tr", null, 
                        React.createElement("th", {scope: "row"}, "파일첨부"), 
                        React.createElement("td", null, 
                          React.createElement("div", {className: "input-file"}, 
                            React.createElement("form", {id: "frm", method: "post", encType: "multipart/form-data"}, 
                              React.createElement("input", {type: "file", title: "파일찾기", name: "upload_file", onChange: this.uploadFile})
                            ), 
                            React.createElement("span", {className: "max-num"}, "* 개별 파일 용량 20MB 및 최대 5개까지 지원")
                          ), 
                          React.createElement(AddFile, {files: this.state.fileList, fileDelete: this.fileDelete})
                        )
                      )
                    )
                  )
                ), 
                React.createElement("div", {className: "btn-area"}, 
                  React.createElement("a", {href: "javascript:void(0)", className: "btn-type2", onClick: this.registArcl}, "확인"), 
                  React.createElement("a", {href: "#", className: "btn-type2 gray"}, "취소")
                )
              )
            )
          )
        )
    );
  }
});

mentor.DataList = React.render(
  React.createElement(DataList, {url: mentor.contextpath+'/community/ajax.mentorDataArclList.do', boardId: "lecFile", sMbrNo: sMbrNo}),
  document.getElementById('boardDataList')
);
