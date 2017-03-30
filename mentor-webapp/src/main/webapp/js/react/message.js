var CheckBox = React.createClass({displayName: "CheckBox",
    componentDidMount: function() {
    },
    componentWillReceiveProps:function(nextProps){
    },
    handleChange: function(event) {
        if(event.target.name == 'checkAll'){
            if(event.target.checked)
                allToggle(false);
            else
                allToggle(true);
        }
    },
    render: function(){
        return (
                React.createElement("label", {className: "chk-skin"}, React.createElement("input", {type: "checkbox", name: this.props.name, id: this.props.name, disabled: this.props.disabled, className: "chk-skin", onClick: this.handleChange, value: this.props.value}))
                );
    }
}
);


var PushTargetData = React.createClass({displayName: "PushTargetData",
    getInitialState: function() {
        return {'data': [], 'keyword':''};
    },
    componentDidMount: function() {

    },
    componentWillReceiveProps:function(nextProps){
    },
    getList: function(param) {
        this.setState({data: param});
    },
    render:function(){
        var artleList = null;
        if(this.state.data != null && this.state.data.length > 0){
                artleList = this.state.data.map(function(messageReciever, index) {
                    var disabled = messageReciever.deviceToken == null  ? true : false;
                    return (
                        React.createElement("tr", null, 
                            React.createElement("td", null, 
                                React.createElement(CheckBox, {name: "pushTarget", disabled: disabled, value: messageReciever.memberNo})
                            ), 
                            React.createElement("td", null, messageReciever.osType, React.createElement("input", {type: "hidden", name: "osType", disabled: disabled, value: messageReciever.osType})), 
                            React.createElement("td", {className: "omission"}, messageReciever.schNm), 
                            React.createElement("td", null, messageReciever.classRoomNm), 
                            React.createElement("td", null, messageReciever.typeNm), 
                            React.createElement("td", null, messageReciever.name, React.createElement("input", {type: "hidden", name: "deviceToken", disabled: disabled, value: messageReciever.deviceToken}))
                        )
                      );
                    });

        }else{
            artleList =[];
            artleList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "6", className: "empty"}, "수업신청자가 없습니다.")
                    )
            );
        }
        return (
        React.createElement("div", {className: "number-board"}, 
            React.createElement("table", {className: "send-target"}, 
                React.createElement("caption", null), 
                React.createElement("colgroup", null, 
                    React.createElement("col", {style: {width:'45px'}}), 
                    React.createElement("col", {style: {width:'79px'}}), 
                    React.createElement("col", {style: {width:'185px'}}), 
                    React.createElement("col", {style: {width:'60px'}}), 
                    React.createElement("col", {style: {width:'80px'}}), 
                    React.createElement("col", null)
                ), 
                React.createElement("thead", null, 
                    React.createElement("tr", null, 
                        React.createElement("th", {scope: "col"}, 
                            React.createElement(CheckBox, {name: "checkAll"})
                        ), 
                        React.createElement("th", {scope: "col"}, "OS"), 
                        React.createElement("th", {scope: "col"}, "학교"), 
                        React.createElement("th", {scope: "col"}, "학급/그룹"), 
                        React.createElement("th", {scope: "col"}, "유형"), 
                        React.createElement("th", {scope: "col"}, "이름")
                    )
                ), 
                React.createElement("tbody", null, 
                     artleList
                )
            )
        )
      );
    }
});


var EmailTargetData = React.createClass({displayName: "EmailTargetData",
    getInitialState: function() {
        return {'data': [], 'keyword':''};
    },
    componentDidMount: function() {

    },
    componentWillReceiveProps:function(nextProps){
    },
    getList: function(param) {
        this.setState({data: param});
    },
    render:function(){
        var artleList = null;
        if(this.state.data != null && this.state.data.length > 0){
            artleList = this.state.data.map(function(messageReciever, index) {
                var disabled = messageReciever.mailAddress == null ? true : false;
                return (
                    React.createElement("tr", null, 
                        React.createElement("td", null, 
                            React.createElement(CheckBox, {name: "emailTarget", disabled: disabled, value: messageReciever.memberNo})
                        ), 
                        React.createElement("td", {className: "omission"}, messageReciever.schNm), 
                        React.createElement("td", null, messageReciever.classRoomNm), 
                        React.createElement("td", null, messageReciever.typeNm), 
                        React.createElement("td", null, messageReciever.name), 
                        React.createElement("td", {className: "omission"}, messageReciever.mailAddress, React.createElement("input", {type: "hidden", name: "mailAddress", disabled: disabled, value: messageReciever.mailAddress}))
                    )
                  );
                });

        }else{
            artleList =[];
            artleList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "6", className: "empty"}, "수업신청자가 없습니다.")
                    )
            );
        }
        return (
        React.createElement("div", {className: "number-board"}, 
            React.createElement("table", {className: "send-target"}, 
                React.createElement("caption", null), 
                React.createElement("colgroup", null, 
                    React.createElement("col", {style: {width:'45px'}}), 
                    React.createElement("col", {style: {width:'119px'}}), 
                    React.createElement("col", {style: {width:'65px'}}), 
                    React.createElement("col", {style: {width:'57px'}}), 
                    React.createElement("col", {style: {width:'107px'}}), 
                    React.createElement("col", null)
                ), 
                React.createElement("thead", null, 
                    React.createElement("tr", null, 
                        React.createElement("th", {scope: "col"}, 
                            React.createElement(CheckBox, {name: "checkAll"})
                        ), 
                        React.createElement("th", {scope: "col"}, "학교"), 
                        React.createElement("th", {scope: "col"}, "학급/그룹"), 
                        React.createElement("th", {scope: "col"}, "유형"), 
                        React.createElement("th", {scope: "col"}, "이름"), 
                        React.createElement("th", {scope: "col"}, "이메일")
                    )
                ), 
                React.createElement("tbody", null, 
                     artleList
                )
            )
        )
      );
    }
});

var SmsTargetData = React.createClass({displayName: "SmsTargetData",
    getInitialState: function() {
        return {'data': [], 'keyword':''};
    },
    componentDidMount: function() {

    },
    componentWillReceiveProps:function(nextProps){
    },
    getList: function(param) {
        this.setState({data: param});
    },

    render:function(){
        var artleList = null;
        if(this.state.data != null && this.state.data.length > 0){
            artleList = this.state.data.map(function(messageReciever, index) {

                var regExp = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;

                var disabled = (!regExp.test( messageReciever.telNo ) )  ? true : false;

                return (
                    React.createElement("tr", null, 
                        React.createElement("td", null, 
                             React.createElement(CheckBox, {name: "smsTarget", disabled: disabled, value: messageReciever.memberNo})
                        ), 
                        React.createElement("td", {className: "school"}, messageReciever.schNm), 
                        React.createElement("td", null, messageReciever.typeNm), 
                        React.createElement("td", null, messageReciever.name), 
                        React.createElement("td", null, messageReciever.telNo, React.createElement("input", {type: "hidden", name: "telNo", disabled: disabled, value: messageReciever.telNo}))
                    )
                  );
                });

        }else{
            artleList =[];
            artleList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "5", className: "empty"}, "수업신청자가 없습니다.")
                    )
            );
        }
        return (
        React.createElement("div", {className: "number-board"}, 
            React.createElement("table", null, 
                React.createElement("caption", null), 
                React.createElement("colgroup", null, 
                    React.createElement("col", {style: {width:'43px'}}), 
                    React.createElement("col", {style: {width:'120px'}}), 
                    React.createElement("col", {style: {width:'42px'}}), 
                    React.createElement("col", {style: {width:'115px'}}), 
                    React.createElement("col", null)
                ), 
                React.createElement("thead", null, 
                    React.createElement("tr", null, 
                        React.createElement("th", {scope: "col"}, React.createElement(CheckBox, {name: "checkAll"})), 
                        React.createElement("th", {scope: "col"}, "학교"), 
                        React.createElement("th", {scope: "col"}, "유형"), 
                        React.createElement("th", {scope: "col"}, "이름"), 
                        React.createElement("th", {scope: "col"}, "휴대전화 번호")
                    )
                ), 
                React.createElement("tbody", null, 
                     artleList
                )
            )
        )
      );
    }
});