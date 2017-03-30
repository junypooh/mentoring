var CurrentTime = React.createClass({displayName: "CurrentTime",
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
            timeTag.push(React.createElement("p", null, "현재시간", React.createElement("em", null, this.state.time.format("HH:mm"))));
        }
    return (
      React.createElement("div", {className: "schedule-day"}, 
          React.createElement("strong", null, this.state.time.format("MM월 dd일(e)")), 
          timeTag
      )
    );
  }
});

var Day = React.createClass({displayName: "Day",
    dayClick:function(){
        var date = mentor.parseDate(this.props.date.format("yyyyMM")+this.props.day.zf(2));
        setDispDate(date);
        this.props.setDate(date);
        $(React.findDOMNode(this.refs.dayItem)).parent().siblings().find("a.on").removeClass("on").end().end().addClass("on");
    },
    render: function() {
      return (
          React.createElement("li", {className: this.props.class}, 
              React.createElement("a", {href: "#", onClick: this.dayClick, ref: "dayItem", className: (this.props.date.format("dd") == this.props.day)?"on":""}, 
                  React.createElement("em", null, this.props.weekday), React.createElement("strong", null, this.props.day)
              )
          )
      );
    }
});

var DayList = React.createClass({displayName: "DayList",
    render:function(){
        var _this = this;
        var dayNodes = this.props.data.map(function(day, index) {
          return (
            // `key` is a React-specific concept and is not mandatory for the
            // purpose of this tutorial. if you're curious, see more here:
            // http://facebook.github.io/react/docs/multiple-components.html#dynamic-children
            React.createElement(Day, {weekday: day.WEEKDAY, day: day.DAYS, class: day.CLASS, key: index, date: _this.props.date, setDate: _this.props.setDate, curDay: _this.props.curDay})
          );
        });
        return (
            React.createElement("div", {className: "day-info", id: "day-info"}, 
                React.createElement("ul", null, 
                dayNodes
                )
            )
        );
    }
});

var MonthInfo = React.createClass({displayName: "MonthInfo",
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
                React.createElement("div", {className: "month-info-wrap"}, 
                    React.createElement("div", {className: "month-info"}, 
                        React.createElement("span", null, this.state.date.format("yyyy"), " ", React.createElement("strong", null, this.state.date.format("MM"))), 
                        React.createElement("button", {type: "button", className: "prev", onClick: this.prevMonth}, "이전달"), React.createElement("button", {type: "button", className: "next", onClick: this.nextMonth}, "다음달")
                    ), 
                    React.createElement(DayList, {data: this.state.data, date: this.state.date, setDate: this.setDate, curDay: this.props.curDay})
                )
        );
    }
});