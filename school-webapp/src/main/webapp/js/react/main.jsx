//SCHOOL-MAIN MyLesson
var MyLessonTeacher = React.createClass({
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
          if(this.state.data != null){
              items = this.state.data.map(function(item, index) {return (
                <li>
                      <a href="#">
                          <dl className="my-lesson-info">
                              <dt className="title">{item.lectTitle}<strong>{item.lectrNm}</strong></dt>
                              <dd className="icon-area"><span className="icon start">{item.lectStatNm}</span></dd>
                              <dd className="date">{mentor.parseDate(item.lectDay).format('yyyy-MM-dd(e)')} {_this.parseTime(item.lectStartTime)} ~ {_this.parseTime(item.lectEndTime)}</dd>
                              <dd className="info">{item.lectIntdcInfo}</dd>
                          </dl>
                      </a>
                  </li>
              );});
          }else{
                items = [];
          }
          var curDate = mentor.parseDate(this.props.curDate);
          var toDate = mentor.calDate(curDate,0,0,this.state.setSer);
          return (
                  <div className="my-lesson">
                  <div className="my-lesson-header">
                      <strong className="tit">수업 신청현황</strong>
                      <div className="my-lesson-date">
                          <strong>{curDate.format('yyyy-MM-dd(e)')} ~ {toDate.format('MM-dd(e)')}</strong>
                          <ul>
                              <li className={(this.state.setSer == 0)?"on":""}><a href="javascript:void(0)" onClick={this.setSetSer.bind(this,0)} >오늘</a></li>
                              <li className={(this.state.setSer == 7)?"on":""}><a href="javascript:void(0)" onClick={this.setSetSer.bind(this,7)} >1주</a></li>
                              <li className={(this.state.setSer == 14)?"on":""}><a href="javascript:void(0)" onClick={this.setSetSer.bind(this,14)} >2주</a></li>
                          </ul>
                      </div>
                  </div>
                  <div className="my-lesson-cont slide-type1">
                      <div className="my-lesson-list-wrap">
                          <ul className="my-lesson-list" ref="dataArea">
                              {items}
                          </ul>
                      </div>
                      <button type="button" className="my-lesson-direction prev">이전</button><button type="button" className="my-lesson-direction next">다음</button>
                  </div>
                  <a href={mentor.contextpath+"/myPage/myLecture/myLecture.do"} className="my-lesson-detail">자세히 보기</a>
              </div>
        );
      }
  });
//MyLessonTeacher END
//SCHOOL-MAIN MyLesson
var MyLessonStudent = React.createClass({
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
                <li>
                    <a href="#">
                        <dl className="lesson-replay-info">
                            <dt className="mentor"><strong>{item.lectrNm}</strong></dt>
                            <dd className="date">{mentor.parseDate(item.lectDay).format('yyyy-MM-dd(e)')}</dd>
                            <dd className="info"><p>{item.lectIntdcInfo}</p></dd>
                            <dd className="thumb"><img src={mentor.contextpath+"/fileDown.do?fileSer="+item.lectPicPath} alt="" /></dd>
                        </dl>
                    </a>
                </li>
              );});
          }else{
                items = [];
          }
          var curDate = mentor.parseDate(this.props.curDate);
          var toDate = mentor.calDate(curDate,0,0,this.state.setSer);
          return (
              <div className="my-lesson">
                  <div className="my-lesson-header">
                      <strong className="tit"><span>수업 신청현황</span></strong>
                      <div className="my-lesson-date">
                        <ul>
                              <li className={(this.state.setSer == 0)?"on":""}><a href="javascript:void(0)" onClick={this.setSetSer.bind(this,0)} >최근</a></li>
                              <li className={(this.state.setSer == 7)?"on":""}><a href="javascript:void(0)" onClick={this.setSetSer.bind(this,7)} >1학기</a></li>
                              <li className={(this.state.setSer == 14)?"on":""}><a href="javascript:void(0)" onClick={this.setSetSer.bind(this,14)} >2학기</a></li>
                        </ul>
                      </div>
                  </div>
                  <div className="my-lesson-cont slide-type2">
                      <div className="my-lesson-list-wrap">
                          <ul className="my-lesson-list">
                              {items}
                          </ul>
                      </div>
                      <button type="button" className="my-lesson-direction prev">이전</button><button type="button" className="my-lesson-direction next">다음</button>
                  </div>
                  <a href={mentor.contextpath+"/myPage/myLecture/myLecture.do"} className="my-lesson-detail">자세히 보기</a>
              </div>
        );
      }
  });
//MyLessonStudent END