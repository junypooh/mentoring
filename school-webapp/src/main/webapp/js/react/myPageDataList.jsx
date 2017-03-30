/**
 * 자료실 react.js
 */

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

var DataInfo = React.createClass({
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
  render:function(){
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
            <a href="javascript:void(0)" onClick={this.articleClick}>
              <em style={{width:'510px'}}>{prefNm}{this.props.article.title}</em>
              {cntntsTypeNm}
              <div>
                <span className={userClass}>{this.props.article.regMbrNm}</span>
                <span className="file">{this.props.article.listArclFileInfo.length} 개 ({Math.ceil(totalSize/1024/1024)}MB)</span>
              </div>
            </a>
          </div>
          <div className="file-list" ref="fileDetail">
            <div className="relation-lesson">
              <span><strong>관련수업</strong><a href="#">{this.props.article.lectTitle}</a></span>
              <span><strong>직업</strong><a href="#">{this.props.article.jobNm}</a></span>
            </div>
            <a href="javascript:void(0)" className="all-down" onClick={this.downloadAll}>전체파일 다운로드</a>
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
    return {'data': [], 'totalRecordCount':0, 'searchKey':0, 'searchWord':'','srchMbrNo':'','recordPerPage':10,'currentPageNo':1};
  },
  componentDidMount: function() {
    this.getList();
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
        'siteGbn' : 'sMyComm',
        'srchMbrNo': this.props.mbrNo,
        'dispNotice' : false
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
          this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord, 'srchMbrNo':_param.srchMbrNo});
          /*
          if(_param.isMore == true){
            this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord, 'srchMbrNo':_param.srchMbrNo});
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord, 'srchMbrNo':_param.srchMbrNo});
          }
          */
          myCommunity();
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var dataList = null;
    if(this.state.data != null && this.state.data.length > 0){
        dataList = this.state.data.map(function(article, index) {
            return (<DataInfo key={index} article={article} />);
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
        </div>
    );
  }
});