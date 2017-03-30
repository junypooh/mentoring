//SCHOOL-MAIN MyLesson
var MyLessonTeacher = React.createClass({displayName: "MyLessonTeacher",
    propTypes: {
        url:                React.PropTypes.string
      },
      getInitialState: function() {
          return {'setSer':0};
      },
      componentDidMount: function() {
        this.getList({});
      },
      getList : function(_param){
          $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            success: function(rtnData) {
                this.setState({data: rtnData,'setSer':this.state.setSer});
                mainSlide('slide-type1', 3);
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
      },
      setSetSer : function (sel){
          this.setState({'data':[],'setSer':sel});
          $(React.findDOMNode(this.refs.dataArea)).find("li").remove();
          this.getList({'setSer':sel});
      },
      parseTime : function(time){
        return "{0}:{1}".format(time.substring(0,2),time.substring(2,4));
      },
      render:function(){
          var items = null;
          var _this = this;
          debugger
          if(this.state.data != null){
              items = this.state.data.map(function(item, index) {return (
                React.createElement("li", null, 
                      React.createElement("a", {href: "#"}, 
                          React.createElement("dl", {className: "my-lesson-info"}, 
                              React.createElement("dt", {className: "title"}, item.lectTitle, React.createElement("strong", null, item.lectrNm)), 
                              React.createElement("dd", {className: "icon-area"}, React.createElement("span", {className: "icon start"}, item.lectStatNm)), 
                              React.createElement("dd", {className: "date"}, mentor.parseDate(item.lectDay).format('yyyy-MM-dd(e)'), " ", _this.parseTime(item.lectStartTime), " ~ ", _this.parseTime(item.lectEndTime)), 
                              React.createElement("dd", {className: "info"}, item.lectIntdcInfo)
                          )
                      )
                  )
              );});
          }else{
                items = [];
          }
          var curDate = mentor.parseDate(this.props.curDate);
          var toDate = mentor.calDate(curDate,0,0,this.state.setSer);
          return (
                  React.createElement("div", {className: "my-lesson"}, 
                  React.createElement("div", {className: "my-lesson-header"}, 
                      React.createElement("strong", {className: "tit"}, "수업 신청현황"), 
                      React.createElement("div", {className: "my-lesson-date"}, 
                          React.createElement("strong", null, curDate.format('yyyy-MM-dd(e)'), " ~ ", toDate.format('MM-dd(e)')), 
                          React.createElement("ul", null, 
                              React.createElement("li", {className: (this.state.setSer == 0)?"on":""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.setSetSer.bind(this,0)}, "오늘")), 
                              React.createElement("li", {className: (this.state.setSer == 7)?"on":""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.setSetSer.bind(this,7)}, "1주")), 
                              React.createElement("li", {className: (this.state.setSer == 14)?"on":""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.setSetSer.bind(this,14)}, "2주"))
                          )
                      )
                  ), 
                  React.createElement("div", {className: "my-lesson-cont slide-type1"}, 
                      React.createElement("div", {className: "my-lesson-list-wrap"}, 
                          React.createElement("ul", {className: "my-lesson-list", ref: "dataArea"}, 
                              items
                          )
                      ), 
                      React.createElement("button", {type: "button", className: "my-lesson-direction prev"}, "이전"), React.createElement("button", {type: "button", className: "my-lesson-direction next"}, "다음")
                  ), 
                  React.createElement("a", {href: mentor.contextpath+"/myPage/myLecture/myLecture.do", className: "my-lesson-detail"}, "자세히 보기")
              )
        );
      }
  });
//MyLessonTeacher END
//SCHOOL-MAIN MyLesson
var MyLessonStudent = React.createClass({displayName: "MyLessonStudent",
    propTypes: {
        url:                React.PropTypes.string
      },
      getInitialState: function() {
          return {'setSer':0};
      },
      componentDidMount: function() {
        this.getList({});
      },
      getList : function(_param){
          $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            success: function(rtnData) {
                this.setState({data: rtnData,'setSer':this.state.setSer});
                mainSlide('slide-type2', 3);
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
      },
      setSetSer : function (sel){
          this.setState({'data':this.state.data,'setSer':sel});
          this.getList({'setSer':sel});
      },
      parseTime : function(time){
        return "{0}:{1}".format(time.subtring(0,2),time.subtring(2,4));
      },
      render:function(){
          var items = null;
          if(this.state.data != null && this.state.data.length > 0){
              items = this.state.data.map(function(item, index) {return (
                React.createElement("li", null, 
                    React.createElement("a", {href: "#"}, 
                        React.createElement("dl", {className: "lesson-replay-info"}, 
                            React.createElement("dt", {className: "mentor"}, React.createElement("strong", null, item.lectrNm)), 
                            React.createElement("dd", {className: "date"}, mentor.parseDate(item.lectDay).format('yyyy-MM-dd(e)')), 
                            React.createElement("dd", {className: "info"}, React.createElement("p", null, item.lectIntdcInfo)), 
                            React.createElement("dd", {className: "thumb"}, React.createElement("img", {src: mentor.contextpath+"/fileDown.do?fileSer="+item.lectPicPath, alt: ""}))
                        )
                    )
                )
              );});
          }else{
                items = [];
          }
          var curDate = mentor.parseDate(this.props.curDate);
          var toDate = mentor.calDate(curDate,0,0,this.state.setSer);
          return (
              React.createElement("div", {className: "my-lesson"}, 
                  React.createElement("div", {className: "my-lesson-header"}, 
                      React.createElement("strong", {className: "tit"}, React.createElement("span", null, "수업 신청현황")), 
                      React.createElement("div", {className: "my-lesson-date"}, 
                        React.createElement("ul", null, 
                              React.createElement("li", {className: (this.state.setSer == 0)?"on":""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.setSetSer.bind(this,0)}, "최근")), 
                              React.createElement("li", {className: (this.state.setSer == 7)?"on":""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.setSetSer.bind(this,7)}, "1학기")), 
                              React.createElement("li", {className: (this.state.setSer == 14)?"on":""}, React.createElement("a", {href: "javascript:void(0)", onClick: this.setSetSer.bind(this,14)}, "2학기"))
                        )
                      )
                  ), 
                  React.createElement("div", {className: "my-lesson-cont slide-type2"}, 
                      React.createElement("div", {className: "my-lesson-list-wrap"}, 
                          React.createElement("ul", {className: "my-lesson-list"}, 
                              items
                          )
                      ), 
                      React.createElement("button", {type: "button", className: "my-lesson-direction prev"}, "이전"), React.createElement("button", {type: "button", className: "my-lesson-direction next"}, "다음")
                  ), 
                  React.createElement("a", {href: mentor.contextpath+"/myPage/myLecture/myLecture.do", className: "my-lesson-detail"}, "자세히 보기")
              )
        );
      }
  });
//MyLessonStudent END