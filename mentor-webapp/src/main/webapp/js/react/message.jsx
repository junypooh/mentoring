var CheckBox = React.createClass({
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
                <label className='chk-skin'><input type="checkbox" name={this.props.name} id={this.props.name} disabled={this.props.disabled} className="chk-skin" onClick={this.handleChange} value={this.props.value} /></label>
                );
    }
}
);


var PushTargetData = React.createClass({
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
                        <tr>
                            <td>
                                <CheckBox name={"pushTarget"} disabled={disabled} value={messageReciever.memberNo}/>
                            </td>
                            <td>{messageReciever.osType}<input type="hidden" name="osType" disabled={disabled} value={messageReciever.osType} /></td>
                            <td className="omission">{messageReciever.schNm}</td>
                            <td>{messageReciever.classRoomNm}</td>
                            <td>{messageReciever.typeNm}</td>
                            <td>{messageReciever.name}<input type="hidden" name="deviceToken" disabled={disabled} value={messageReciever.deviceToken} /></td>
                        </tr>
                      );
                    });

        }else{
            artleList =[];
            artleList.push(
                    <tr>
                        <td colSpan="6" className="empty">수업신청자가 없습니다.</td>
                    </tr>
            );
        }
        return (
        <div className="number-board">
            <table className="send-target">
                <caption></caption>
                <colgroup>
                    <col style={{width:'45px'}} />
                    <col style={{width:'79px'}} />
                    <col style={{width:'185px'}} />
                    <col style={{width:'60px'}} />
                    <col style={{width:'80px'}} />
                    <col />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">
                            <CheckBox name="checkAll"/>
                        </th>
                        <th scope="col">OS</th>
                        <th scope="col">학교</th>
                        <th scope="col">학급/그룹</th>
                        <th scope="col">유형</th>
                        <th scope="col">이름</th>
                    </tr>
                </thead>
                <tbody>
                     {artleList}
                </tbody>
            </table>
        </div>
      );
    }
});


var EmailTargetData = React.createClass({
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
                    <tr>
                        <td>
                            <CheckBox name={"emailTarget"} disabled={disabled} value={messageReciever.memberNo}/>
                        </td>
                        <td className="omission">{messageReciever.schNm}</td>
                        <td>{messageReciever.classRoomNm}</td>
                        <td>{messageReciever.typeNm}</td>
                        <td>{messageReciever.name}</td>
                        <td className="omission">{messageReciever.mailAddress}<input type="hidden" name="mailAddress" disabled={disabled} value={messageReciever.mailAddress} /></td>
                    </tr>
                  );
                });

        }else{
            artleList =[];
            artleList.push(
                    <tr>
                        <td colSpan="6" className="empty">수업신청자가 없습니다.</td>
                    </tr>
            );
        }
        return (
        <div className="number-board">
            <table className="send-target">
                <caption></caption>
                <colgroup>
                    <col style={{width:'45px'}} />
                    <col style={{width:'119px'}} />
                    <col style={{width:'65px'}} />
                    <col style={{width:'57px'}} />
                    <col style={{width:'107px'}} />
                    <col />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col">
                            <CheckBox name="checkAll"/>
                        </th>
                        <th scope="col">학교</th>
                        <th scope="col">학급/그룹</th>
                        <th scope="col">유형</th>
                        <th scope="col">이름</th>
                        <th scope="col">이메일</th>
                    </tr>
                </thead>
                <tbody>
                     {artleList}
                </tbody>
            </table>
        </div>
      );
    }
});

var SmsTargetData = React.createClass({
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
                    <tr>
                        <td>
                             <CheckBox name={"smsTarget"} disabled={disabled} value={messageReciever.memberNo}/>
                        </td>
                        <td className="school">{messageReciever.schNm}</td>
                        <td>{messageReciever.typeNm}</td>
                        <td>{messageReciever.name}</td>
                        <td>{messageReciever.telNo}<input type="hidden" name="telNo" disabled={disabled} value={messageReciever.telNo} /></td>
                    </tr>
                  );
                });

        }else{
            artleList =[];
            artleList.push(
                    <tr>
                        <td colSpan="5" className="empty">수업신청자가 없습니다.</td>
                    </tr>
            );
        }
        return (
        <div className="number-board">
            <table>
                <caption></caption>
                <colgroup>
                    <col style={{width:'43px'}} />
                    <col style={{width:'120px'}} />
                    <col style={{width:'42px'}} />
                    <col style={{width:'115px'}} />
                    <col />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col"><CheckBox name="checkAll"/></th>
                        <th scope="col">학교</th>
                        <th scope="col">유형</th>
                        <th scope="col">이름</th>
                        <th scope="col">휴대전화 번호</th>
                    </tr>
                </thead>
                <tbody>
                     {artleList}
                </tbody>
            </table>
        </div>
      );
    }
});