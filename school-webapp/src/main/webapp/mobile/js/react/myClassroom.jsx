

var MyClassInfoList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'recordPerPage':10,'currentPageNo':1, 'regStatCd':this.props.regStatCd};
    },
    componentDidMount: function() {
        this.getList();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10, 'regStatCd':this.props.regStatCd, 'clasRoomCualfCd':$("#clasRoomCualfCd").val()},param);
        if(_param.isMore != true){
            this.setState({'data': [],'totalRecordCount':0,'currentPageNo':1});
        }

        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null && rtnData.length > 0){
                    totalCnt = rtnData[0].totalRecordCount;
                }
                $("#totalCnt").text(totalCnt);
                this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':totalCnt,'currentPageNo':Number(_param.currentPageNo),'recordCountPerPage':Number(_param.recordCountPerPage)});

            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var classList = null;
        var totalCnt = null;
        if(this.state.data != null && this.state.data.length > 0){
            totalCnt =  this.state.totalRecordCount;
            classList = this.state.data.map(function(classData, index) {


            var classes = classData.reqMbrNm.split(",");
            if(classes.length > 1) {
                classData.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
            } else {
                classData.reqMbrNmText = classes[0];
            }
            //classData.reqMbrNm = replaceAll(classData.reqMbrNm, ",", "");
            return (
                    <li className="my-class-info">
                        <a href="#">
                            <p className="school-nm"><span>{classData.clasRoomInfo.schInfo.schNm}</span><em>{classData.clasRoomInfo.clasRoomNm}</em></p>
                            <p className="class-manager">교실 담당자 : <span>{classData.reqMbrNmText}</span><span className="date">{new Date(classData.reqDtm).format('yyyy-MM-dd')}</span></p>
                        </a>
                    </li>
                  );
                });
            var paging = [];

            paging.push(
                <div className="btn-more" style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':'block'}}>
                    <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})}><span>더보기(<strong>{this.state.totalRecordCount-this.state.data.length}</strong>)</span></a>
                </div>

            );

        }else{
            classList =[];
            classList.push(
                    <div className="ps-box">
                        <p className="check-point">교실 등록 관리는 홈페이지에서 가능합니다.</p>
                    </div>
            );
        }
        return (
        <div className="content" >
            <ul className="my-lesson-list" >
                <li>
                    <span className="result-count" >총 : <em>{totalCnt}</em>건</span>
                    <ul>
                        {classList}
                    </ul>
                </li>
            </ul>
            {paging}
        </div>
      );
    }
});

