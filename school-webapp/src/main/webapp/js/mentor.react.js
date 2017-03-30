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


//Board-data
var DataArticle = React.createClass({displayName: "DataArticle",
    lessonDataListClick:function(e){
        /*
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
                    React.createElement("li", null, 
                        React.createElement("span", {className: "file-type jpg"}, 
                            React.createElement("a", {href: "javascript:void(0);"}, "variousflower_buy.jpg")
                        ), 
                        React.createElement("span", {className: "file-size"}, "999MB")
                    )
                  );
                });
        return (
            React.createElement("li", null, 
                React.createElement("div", {className: "title"}, 
                    React.createElement("a", {href: "javascript:void(0);", onClick: this.lessonDataListClick}, 
                        React.createElement("em", null, "수업보조자료 및 사후활동지_8월 26일_최경민 멘토_초등용"), 
                        React.createElement("span", {className: "file"}, "12개 (45MB)")
                    )
                ), 
                React.createElement("div", {className: "file-list", ref: "fileInfo"}, 
                    React.createElement("p", {className: "relation-lesson"}, React.createElement("strong", null, "관련수업"), React.createElement("a", {href: "#"}, "꽃을 창조하는 직업, 플로리스트")), 
                    React.createElement("a", {href: "#", className: "all-down"}, "전체파일 다운로드"), 
                    React.createElement("ul", null, 
                        fileItem
                    )
                )
            )
        );
    }
});
var DataArticleList = React.createClass({displayName: "DataArticleList",
    render:function(){
        var articleList = this.props.articles.map(function(article, index) {
            return (
              React.createElement(DataArticle, {title: article.title, listArclFileInfo: article.listArclFileInfo})
            );
          });
        return (
                React.createElement("ul", {className: "lesson-data-list"}, 
                    articleList
                )
      );
    }
});
var BoardData = React.createClass({displayName: "BoardData",
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
            React.createElement("div", null, 
                React.createElement(DataArticleList, {articles: this.state.data}), 
                React.createElement("div", {className: "btn-more-view", style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, 
                    React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true})}, "더 보기 (", React.createElement("span", null, this.state.totalRecordCount-this.state.data.length), ")")
                )
            )
      );
    }
});
//Board-data