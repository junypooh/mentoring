/**
 * 질문답변 react.js
 */

var BestArticle = React.createClass({displayName: "BestArticle",
    render:function(){
        var classStr = "best-lesson ";
        if(this.props.seq == 1) {
            classStr += "first";
        } else if(this.props.seq == 3) {
            classStr += "last";
        }
        var timeStr = hhmmssFormat(this.props.article.cntntsPlayTime);
        var targtCd = this.props.article.lectTargtCd;
        var lectUrl = mentor.contextpath+'/lecture/lectureTotal/lectureView.do?lectSer='+this.props.article.cntntsTargtNo+'&lectTims='+this.props.article.cntntsTargtTims+'&schdSeq='+this.props.article.cntntsTargtSeq;
        return (
            React.createElement("li", {className: "best-lesson"}, 
                React.createElement("div", {className: "lesson-info-type"}, 
                    React.createElement("div", {className: "thumb"}, 
                        React.createElement("a", {href: 'lectureReplyView.do?arclSer='+this.props.article.arclSer+'&cId='+this.props.article.cntntsId}, 
                            React.createElement("img", {src: this.props.article.cntntsThumbPath, alt: this.props.article.lectTitle}), 
                            React.createElement("strong", {className: "title"}, this.props.article.lectTitle), 
                            React.createElement("span", {className: "ranking"}, React.createElement("span", null, "재생 순위 1")), 
                            React.createElement("span", {className: "rating"}, 
                                React.createElement("span", {className: "icon-rating elementary", style: {display:targtCd=='101534'?'':targtCd=='101537'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}, "초"), 
                                React.createElement("span", {className: "icon-rating middle", style: {display:targtCd=='101535'?'':targtCd=='101537'?'':targtCd=='101538'?'':targtCd=='101540'?'':'none'}}, "중"), 
                                React.createElement("span", {className: "icon-rating high", style: {display:targtCd=='101536'?'':targtCd=='101538'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}, "고")
                            ), 
                            React.createElement("span", {className: "icon-play"}, "동영상 재생")
                        )
                    ), 
                    React.createElement("dl", {className: "info"}, 
                        React.createElement("dt", {className: "title"}, React.createElement("a", {href: lectUrl}, this.props.article.lectTitle, React.createElement("strong", null, this.props.article.mentorMbrNm))), 
                        React.createElement("dd", {className: "play-time"}, 
                            React.createElement("span", null, "재생시간"), 
                            React.createElement("p", null, timeStr)
                        ), 
                        React.createElement("dd", {className: "date"}, 
                            React.createElement("span", null, "일시"), 
                            React.createElement("p", null, this.props.article.lectDay.toDay(), " ", React.createElement("span", {className: "t-mobile-blind"}, "/"), " ", React.createElement("strong", null, this.props.article.lectStartTime.toTime() + '~' + this.props.article.lectEndTime.toTime()))
                        ), 
                        React.createElement("dd", {className: "search"}, 
                            React.createElement("span", null, "조회"), 
                            React.createElement("p", null, this.props.article.vcnt)
                        ), 
                        React.createElement("dd", {className: "file-info"}, 
                            React.createElement("span", null, "파일명"), 
                            React.createElement("p", null, React.createElement("span", null, this.props.article.title))
                        )
                    )
                )
            )
    );
  }
});

var Article = React.createClass({displayName: "Article",
    render:function(){
        var timeStr = hhmmssFormat(this.props.article.cntntsPlayTime);
        var targtCd = this.props.article.lectTargtCd;
        var lectUrl = mentor.contextpath+'/lecture/lectureTotal/lectureView.do?lectSer='+this.props.article.cntntsTargtNo+'&lectTims='+this.props.article.cntntsTargtTims+'&schdSeq='+this.props.article.cntntsTargtSeq;
        return (
            React.createElement("li", null, 
                React.createElement("div", {className: "lesson-info-type"}, 
                    React.createElement("div", {className: "thumb"}, 
                        React.createElement("a", {href: 'lectureReplyView.do?arclSer='+this.props.article.arclSer+'&cId='+this.props.article.cntntsId}, 
                            React.createElement("img", {src: this.props.article.cntntsThumbPath, alt: this.props.article.lectTitle}), 
                            React.createElement("strong", {className: "title"}, this.props.article.lectTitle), 
                            React.createElement("span", {className: "rating"}, 
                                React.createElement("span", {className: "icon-rating elementary", style: {display:targtCd=='101534'?'':targtCd=='101537'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}, "초"), 
                                React.createElement("span", {className: "icon-rating middle", style: {display:targtCd=='101535'?'':targtCd=='101537'?'':targtCd=='101538'?'':targtCd=='101540'?'':'none'}}, "중"), 
                                React.createElement("span", {className: "icon-rating high", style: {display:targtCd=='101536'?'':targtCd=='101538'?'':targtCd=='101539'?'':targtCd=='101540'?'':'none'}}, "고")
                            ), 
                            React.createElement("span", {className: "icon-play"}, "동영상 재생")
                        )
                    ), 
                    React.createElement("dl", {className: "info"}, 
                        React.createElement("dt", {className: "title"}, React.createElement("a", {href: lectUrl}, this.props.article.lectTitle, React.createElement("strong", null, this.props.article.mentorMbrNm))), 
                        React.createElement("dd", {className: "play-time"}, 
                            React.createElement("span", null, "재생시간"), 
                            React.createElement("p", null, timeStr)
                        ), 
                        React.createElement("dd", {className: "date"}, 
                            React.createElement("span", null, "일시"), 
                            React.createElement("p", null, this.props.article.lectDay.toDay(), " ", React.createElement("span", {className: "t-mobile-blind"}, "/"), " ", React.createElement("strong", null, this.props.article.lectStartTime.toTime() + ' ~ ' + this.props.article.lectEndTime.toTime()))
                        ), 
                        React.createElement("dd", {className: "search"}, 
                            React.createElement("span", null, "조회"), 
                            React.createElement("p", null, this.props.article.vcnt)
                        ), 
                        React.createElement("dd", {className: "file-info"}, 
                            React.createElement("span", null, "파일명"), 
                            React.createElement("p", null, React.createElement("span", null, this.props.article.title))
                        )
                    )
                )
            )
    );
  }
});

var ReplayList = React.createClass({displayName: "ReplayList",
  getInitialState: function() {
    return {'bestData' : [], 'data' : [], 'totalRecordCount' : 0, 'recordCountPerPage' : 6, 'currentPageNo' : 1};
  },
  componentDidMount: function() {
      this.getBestList();
      this.getList();
  },
  getBestList: function(param) {
      $.ajax({
          url: this.props.url,
          data : {
              boardId : this.props.boardId,
              recordCountPerPage : 3,
              currentPageNo : 1,
              bestYn : 'Y'
          },
          contentType: "application/json",
          dataType: 'json',
          cache: false,
          success: function(rtnData) {
            var rowCount = 0;
            if(rtnData.length > 0) {
              rowCount = rtnData[0].totalRecordCount;
            }
            this.setState({bestData: rtnData});
          }.bind(this),
          error: function(xhr, status, err) {
            console.error(this.props.url, status, err.toString());
          }.bind(this)
      });
    },
  getList: function(param) {
    var _param = jQuery.extend({
      'boardId':this.props.boardId,
      'currentPageNo': this.state.currentPageNo,
      'clasStartDay':$("#clasStartDay").val(),
      'clasEndDay':$("#clasEndDay").val(),
      'lectTargtCd':$("#lectTargtCd").val(),
      'lectTime':$("#lectTime").val(),
      'lectTypeCd':$("#lectTypeCd").val(),
      'searchKey':$("#searchKey").val(),
      'searchWord':$("#searchWord").val(),
      'sJobChrstcCds' : sJobChrstcCds,
      'sJobNo' : sJobNo
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
          if(mentor.isMobile){
              if(_param.isMore == true){
                  this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
              }else{
                  this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':1, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
              }
          }else{
            this.setState({data: rtnData,'totalRecordCount':rowCount,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage, 'searchKey':_param.searchKey, 'searchWord':_param.searchWord});
          }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(this.props.url, status, err.toString());
        }.bind(this)
    });
  },
  render:function(){
    var _this = this;
    var paging = [];
    if(mentor.isMobile){
        paging.push(
              React.createElement("div", {className: "btn-more-view"}, 
                  React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1, 'searchKey':this.state.searchKey, 'searchWord':this.state.searchWord}), style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, "더 보기 (", React.createElement("span", null, this.state.totalRecordCount-this.state.data.length), ")")
              )
        );
    }else{
        paging.push(
              React.createElement("div", {className: "btn-paging"}, 
                  React.createElement(PageNavi, {url: this.props.url, pageFunc: goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
              )
        );
    }
    return (
        React.createElement("div", {className: "lesson-replay-wrap"}, 

          React.createElement("ul", {className: "best-lesson"}, 
              this.state.bestData.map(function(article, index){
                  return (React.createElement(BestArticle, {key: index, article: article, seq: index}))
              })
          ), 

          React.createElement("ul", null, 
              this.state.data.map(function(article, index){
                  return (React.createElement(Article, {key: index, article: article}))
              })
          ), 

          paging

        )
    );
  }
});

mentor.ReplayList = React.render(
  React.createElement(ReplayList, {url: mentor.contextpath+'/community/ajax.arclReplaylList.do', boardId: "lecReplay", isMobile: mentor.isMobile}),
  document.getElementById('replayList')
);



