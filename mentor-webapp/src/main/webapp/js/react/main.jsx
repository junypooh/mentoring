var CurrentTime = React.createClass({
    getInitialState: function() {
        return {'time': new Date(),'showTime':true};
    },
    componentDidMount: function() {
        this.setState({'time':mentor.parseDate(this.props.time),'showTime':true});
        this.updateTime();
    },
    updateTime:function(){
        mentor.currentTimeout = setTimeout(this.updateTime, 1000);
        var time = this.state.time;
        time.setSeconds(time.getSeconds()+1);
        this.setState({'time':time,'showTime':true});
    },
    setDate:function(date){
        clearTimeout(mentor.currentTimeout);
        this.setState({'time':date,'showTime':false});
    },
    render: function() {
        var timeTag = [];
        if(this.state.showTime)
        {
            timeTag.push(<p>현재시간<em>{this.state.time.format("HH:mm")}</em></p>);
        }
    return (
      <div className="schedule-day">
          <strong>{this.state.time.format("MM월 dd일(e)")}</strong>
          {timeTag}
      </div>
    );
  }
});

var Day = React.createClass({
    dayClick:function(){
        var date = mentor.parseDate(this.props.date.format("yyyyMM")+this.props.day.zf(2));
        setDispDate(date);
        this.props.setDate(date);
        $(React.findDOMNode(this.refs.dayItem)).parent().siblings().find("a.on").removeClass("on").end().end().addClass("on");
    },
    render: function() {
      return (
          <li className={this.props.class}>
              <a href="#" onClick={this.dayClick} ref="dayItem" className={(this.props.date.format("dd") == this.props.day)?"on":""}>
                  <em>{this.props.weekday}</em><strong>{this.props.day}</strong>
              </a>
          </li>
      );
    }
});

var DayList = React.createClass({
    render:function(){
        var _this = this;
        var dayNodes = this.props.data.map(function(day, index) {
          return (
            // `key` is a React-specific concept and is not mandatory for the
            // purpose of this tutorial. if you're curious, see more here:
            // http://facebook.github.io/react/docs/multiple-components.html#dynamic-children
            <Day weekday={day.WEEKDAY} day={day.DAYS} class={day.CLASS} key={index} date={_this.props.date} setDate={_this.props.setDate} curDay={_this.props.curDay}/>
          );
        });
        return (
            <div className="day-info" id="day-info">
                <ul>
                {dayNodes}
                </ul>
            </div>
        );
    }
});

var MonthInfo = React.createClass({
    loadMonthInfoFromServer: function(date) {
        this.setState({data: this.state.data,date:date});
        $.ajax({
            url: this.props.url,
            data : {'date':date.format("yyyyMM")},
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                this.setState({data: rtnData,date:this.state.date});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    prevMonth:function(){
        this.moveMonth(-1);
    },
    nextMonth:function(){
        this.moveMonth(1);
    },
    moveMonth:function(addMonth){
        var date = mentor.calDate(this.state.date,0,addMonth,0);
        setDispDate(date);
        this.loadMonthInfoFromServer(date);
    },
    getInitialState: function() {
        return {data: [],date:new Date()};
    },
    componentDidMount: function() {
        this.loadMonthInfoFromServer(new Date());
    },
    componentDidUpdate: function(){
        if(this.props.curDay == this.state.date.format("yyyyMMdd"))
        {
            $(".day-info").scrollTop((this.state.date.format("dd")*1-1)*51);
        }
    },
    setDate:function(date){
        this.setState({data: this.state.data,date:date});
    },
    render:function(){
        return (
                <div className="month-info-wrap">
                    <div className="month-info">
                        <span>{this.state.date.format("yyyy")} <strong>{this.state.date.format("MM")}</strong></span>
                        <button type="button" className="prev" onClick={this.prevMonth}>이전달</button><button type="button" className="next" onClick={this.nextMonth}>다음달</button>
                    </div>
                    <DayList data={this.state.data} date={this.state.date} setDate={this.setDate} curDay={this.props.curDay}/>
                </div>
        );
    }
});