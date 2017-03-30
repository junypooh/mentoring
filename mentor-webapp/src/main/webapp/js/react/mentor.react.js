//PAGE NAVI -START
var PageNavi = React.createClass({displayName: "PageNavi",
    propTypes: {
      url:                React.PropTypes.string,
      pageFunc:             React.PropTypes.func,
      totalRecordCount:   React.PropTypes.number.isRequired,
      currentPageNo:      React.PropTypes.number.isRequired,
      recordCountPerPage: React.PropTypes.number,
      pageSize: React.PropTypes.number
    },
    getInitialState: function() {
        var _param = { 'totalRecordCount':this.props.totalRecordCount
            , 'currentPageNo':this.props.currentPageNo
            , 'recordCountPerPage':this.props.recordCountPerPage
            , 'pageSize':this.props.pageSize||10};

        return this.calData(_param);
    },
    componentDidUpdate: function() {
        //this.setData();
    },
    componentWillReceiveProps:function(nextProps){
        this.setData(nextProps);
    },
    setData:function(param){
        var _param = jQuery.extend(
            { 'totalRecordCount':this.state.totalRecordCount||this.props.totalRecordCount
            , 'currentPageNo':this.state.currentPageNo||this.props.currentPageNo
            , 'pageSize':this.props.pageSize||10
            , 'recordCountPerPage':this.state.recordCountPerPage||this.props.recordCountPerPage}
            , param);

        this.setState(this.calData(_param));
    },
    calData:function(_param){
        //전체 Page계산
        _param.totalPage = Math.ceil(_param.totalRecordCount/_param.recordCountPerPage);

        //현재 표시되어야 할 시작Page, 끝Page계산
        //_param.startPage = Math.floor((_param.currentPageNo-1)/_param.recordCountPerPage)*_param.recordCountPerPage+1;
        //_param.endPage = Math.min(_param.startPage+9,_param.totalPage);

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
    render:function(){
        var pageNodes = [];
        for(var i=this.state.startPage; i <= this.state.endPage; i++){
            if(i==this.state.currentPageNo){
                pageNodes.push(React.createElement("strong", null, i));
            }else{
                pageNodes.push(React.createElement("a", {href: "javascript:void(0)", onClick: this._pageFunc.bind(this,i)}, React.createElement("span", null, i)));
            }
        }

        if(pageNodes.length > 0){
            var prevImgUrl = mentor.contextpath + '/images/common/btn_paging_prev.gif';
            var nextImgUrl = mentor.contextpath + '/images/common/btn_paging_next.gif';
            return (
                React.createElement("div", {className: "paging"}, 
                    React.createElement("a", {href: "javascript:void(0)", className: "prev", onClick: this._pageFunc.bind(this,this.state.prev)}, 
                        React.createElement("img", {src: prevImgUrl, alt: "처음"})
                    ), 
                    pageNodes, 
                    React.createElement("a", {href: "javascript:void(0)", className: "next", onClick: this._pageFunc.bind(this,this.state.next)}, 
                        React.createElement("img", {src: nextImgUrl, alt: "맨끝"})
                    )
                )
            );
        }else{
            return (
                React.createElement("div", {className: "paging"}
                )
            );
        }
    }
});
//PAGE NAVI -END