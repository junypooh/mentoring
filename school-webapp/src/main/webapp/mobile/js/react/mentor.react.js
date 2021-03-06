//PAGE NAVI -START
var PageNavi = React.createClass({
    propTypes: {
      url:                React.PropTypes.string,
      pageFunc:             React.PropTypes.func,
      totalRecordCount:   React.PropTypes.number.isRequired,
      currentPageNo:      React.PropTypes.number.isRequired,
      recordCountPerPage: React.PropTypes.number
    },
    getInitialState: function() {
        var _param = { 'totalRecordCount':this.props.totalRecordCount
            , 'currentPageNo':this.props.currentPageNo
            , 'recordCountPerPage':this.props.recordCountPerPage};

        return this.calData(_param);
    },
    setData:function(param){
        var _param = jQuery.extend(
            { 'totalRecordCount':this.state.totalRecordCount||this.props.totalRecordCount
            , 'currentPageNo':this.state.currentPageNo||this.props.currentPageNo
            , 'recordCountPerPage':this.state.recordCountPerPage||this.props.recordCountPerPage}
            , param);

        _param = this.calData(_param);
        this.setState(_param);
    },
    calData:function(_param){
        //전체 Page계산
        _param.totalPage = Math.ceil(_param.totalRecordCount/_param.recordCountPerPage);

        //현재 표시되어야 할 시작Page, 끝Page계산
        _param.startPage = Math.floor((_param.currentPageNo-1)/_param.recordCountPerPage)*_param.recordCountPerPage+1;
        _param.endPage = Math.min(_param.startPage+9,_param.totalPage);

        //이전, 다음 페이지 계산
        _param.prev = Math.max(_param.startPage-1, 1);
        _param.next = Math.min(_param.endPage+1,_param.totalPage);
        return _param;
    },
    _pageFunc:function(pageNo){
        this.setData({'currentPageNo':pageNo});
        this.props.pageFunc(pageNo);
    },
    render:function(){
        var pageNodes = [];
        for(var i=this.state.startPage; i <= this.state.endPage; i++){
            if(i==this.state.currentPageNo){
                pageNodes.push(<strong>{i}</strong>);
            }else{
                pageNodes.push(<a href="javascript:void(0)" onClick={this._pageFunc.bind(this,i)}>{i}</a>);
            }
        }
        return (
          <div className="paging">
              <a href="javascript:void(0)" className="prev" onClick={this._pageFunc.bind(this,this.state.prev)}><img src={mentor.contextpath+"/images/common/btn_paging_prev.gif"} alt="처음" /></a>
                  {pageNodes}
              <a href="javascript:void(0)" className="next" onClick={this._pageFunc.bind(this,this.state.next)}><img src={mentor.contextpath+"/images/common/btn_paging_next.gif"} alt="맨끝" /></a>
          </div>
      );
    }
});
//PAGE NAVI -END


//Board-data
var DataArticle = React.createClass({
    lessonDataListClick:function(e){
        /*
        debugger
        lessonDataListClick.bind(React.findDOMNode(this.refs.myTextInput),e);
        */
        if($(React.findDOMNode(this.refs.fileInfo)).is(":visible")) {
            $(React.findDOMNode(this.refs.fileInfo)).hide("fast");
        } else {
            $(".file-list").hide("fast");
            $(React.findDOMNode(this.refs.fileInfo)).show("fast");
        }
    },
    render:function(){
        var fileItem = this.props.listArclFileInfo.map(function(lecData, index) {
            return (
                    <li>
                        <span className="file-type jpg">
                            <a href="javascript:void(0);">variousflower_buy.jpg</a>
                        </span>
                        <span className="file-size">999MB</span>
                    </li>
                  );
                });
        return (
            <li>
                <div className="title">
                    <a href="javascript:void(0);" onClick={this.lessonDataListClick}>
                        <em>수업보조자료 및 사후활동지_8월 26일_최경민 멘토_초등용</em>
                        <span className="file">12개 (45MB)</span>
                    </a>
                </div>
                <div className="file-list" ref="fileInfo">
                    <p className="relation-lesson"><strong>관련수업</strong><a href="#">꽃을 창조하는 직업, 플로리스트</a></p>
                    <a href="#" className="all-down">전체파일 다운로드</a>
                    <ul>
                        {fileItem}
                    </ul>
                </div>
            </li>
        );
    }
});
var DataArticleList = React.createClass({
    render:function(){
        var articleList = this.props.articles.map(function(article, index) {
            return (
              <DataArticle  title={article.title} listArclFileInfo={article.listArclFileInfo}/>
            );
          });
        return (
                <ul className="lesson-data-list">
                    {articleList}
                </ul>
      );
    }
});
var BoardData = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    componentDidMount: function() {
        this.getList();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':1,'recordCountPerPage':10},param);
        if(_param.isMore != true){
            this.setState({'data': [],'totalRecordCount':0});
        }
        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                this.setState({data: this.state.data.concat(rtnData.data),'totalRecordCount':rtnData.totalRecordCount});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        return (
            <div>
                <DataArticleList articles={this.state.data}/>
                <div className="btn-more-view" style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                    <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true})}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
                </div>
            </div>
      );
    }
});
//Board-data

/*
 * yyyyMMdd 날짜문자열을 gubun으로 포맷을 변경
 */
function to_date_format(date_str, gubun)
{
    var yyyyMMdd = String(date_str);
    var sYear = yyyyMMdd.substring(0,4);
    var sMonth = yyyyMMdd.substring(4,6);
    var sDate = yyyyMMdd.substring(6,8);

    return sYear + gubun + sMonth + gubun + sDate;
}

/*
 * hh24mi 시간문자열을 gubun으로 포맷을 변경
 */
function to_time_format(time_str, gubun)
{
    var time = String(time_str);
    var hh = time.substring(0,2);
    var mm = time.substring(2,4);
    return hh + gubun + mm;
}