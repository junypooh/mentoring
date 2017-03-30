//PAGE NAVI -START
var PageNavi = React.createClass({
    propTypes: {
      url:                  React.PropTypes.string,
      pageFunc:             React.PropTypes.func,
      totalRecordCount:     React.PropTypes.number.isRequired,
      currentPageNo:        React.PropTypes.number.isRequired,
      recordCountPerPage:   React.PropTypes.number,
      pageSize:             React.PropTypes.number
    },
    getInitialState: function() {
        var _param = { 'totalRecordCount':this.props.totalRecordCount
                        , 'currentPageNo':this.props.currentPageNo
                        , 'pageSize':this.props.pageSize||10
                        , 'recordCountPerPage':this.props.recordCountPerPage};

        return this.calData(_param);
    },
    componentDidUpdate: function() {
        console.log("Paging componentDidUpdate");
    },
    componentWillReceiveProps:function(nextProps){
    },
    setData:function(param){
        console.log("Paging setData");
        var _param = jQuery.extend(
            { 'totalRecordCount':this.state.totalRecordCount||this.props.totalRecordCount
            , 'currentPageNo':this.state.currentPageNo||this.props.currentPageNo
            , 'pageSize':this.props.pageSize||10
            , 'recordCountPerPage':this.state.recordCountPerPage||this.props.recordCountPerPage}
            , param);

        this.setState(this.calData(_param));
    },
    calData:function(_param){
        console.log("Paging calData");
        //전체 Page계산
        _param.totalPage = Math.ceil(_param.totalRecordCount/_param.recordCountPerPage);

        //현재 표시되어야 할 시작Page, 끝Page계산
        _param.startPage = Math.floor((_param.currentPageNo-1)/_param.pageSize)*_param.pageSize+1;
        _param.endPage = Math.min(_param.startPage+_param.pageSize-1,_param.totalPage);

        //이전, 다음 페이지 계산
        _param.prev = Math.max(_param.startPage-1, 1);
        _param.next = Math.min(_param.endPage+1,_param.totalPage);
        return _param;
    },
    _pageFunc:function(pageNo){
        if(this.state.totalRecordCount > 0 && pageNo > 0) {
            this.setData({'currentPageNo':pageNo});
            this.props.pageFunc(pageNo);
        }
    },
    _setRowCount:function(e) {
        this.setData({'currentPageNo':1, recordCountPerPage : e.target.value});
        this.props.pageFunc(1, e.target.value);
    },
    render:function(){
        console.log("Paging render");
        var pageNodes = [];
        for (var i=this.state.startPage; i <= this.state.endPage; i++) {
            if (i==this.state.currentPageNo) {
                pageNodes.push(<li className="on" key={i}><a href="javascript:void(0);">{i}</a></li>);
            }
            else {
                pageNodes.push(<li key={i}><a href="javascript:void(0);" onClick={this._pageFunc.bind(this,i,this.state.recordCountPerPage)}>{i}</a></li>);
            }
        }
        return (pageNodes.length) ? (
            <div className="tbl-pager">
                <a href="javascript:void(0)" className="btn-page-first" onClick={this._pageFunc.bind(this,1,this.state.recordCountPerPage)}>첫페이지</a>
                <a href="javascript:void(0)" className="btn-page-prev" onClick={this._pageFunc.bind(this,this.state.prev,this.state.recordCountPerPage)}>이전페이지</a>
                <ul className="page-list">
                    {pageNodes}
                </ul>
                <a href="javascript:void(0)" className="btn-page-next" onClick={this._pageFunc.bind(this,this.state.next,this.state.recordCountPerPage)}>다음페이지</a>
                <a href="javascript:void(0)" className="btn-page-last" onClick={this._pageFunc.bind(this,this.state.totalPage,this.state.recordCountPerPage)}>마지막페이지</a>

                <div className="view-list-num">
                    <select value={this.state.recordCountPerPage} onChange={this._setRowCount}>
                        <option value="20">20</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                </div>
            </div>
      ) : (
            <div className="tbl-pager"></div>
      );
    }
});
//PAGE NAVI -END