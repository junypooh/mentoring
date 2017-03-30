

var MyClassInfoList = React.createClass({displayName: "MyClassInfoList",
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
                    React.createElement("li", {className: "my-class-info"}, 
                        React.createElement("a", {href: "#"}, 
                            React.createElement("p", {className: "school-nm"}, React.createElement("span", null, classData.clasRoomInfo.schInfo.schNm), React.createElement("em", null, classData.clasRoomInfo.clasRoomNm)), 
                            React.createElement("p", {className: "class-manager"}, "교실 담당자 : ", React.createElement("span", null, classData.reqMbrNmText), React.createElement("span", {className: "date"}, new Date(classData.reqDtm).format('yyyy-MM-dd')))
                        )
                    )
                  );
                });
            var paging = [];

            paging.push(
                React.createElement("div", {className: "btn-more", style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':'block'}}, 
                    React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})}, React.createElement("span", null, "더보기(", React.createElement("strong", null, this.state.totalRecordCount-this.state.data.length), ")"))
                )

            );

        }else{
            classList =[];
            classList.push(
                    React.createElement("div", {className: "ps-box"}, 
                        React.createElement("p", {className: "check-point"}, "교실 등록 관리는 홈페이지에서 가능합니다.")
                    )
            );
        }
        return (
        React.createElement("div", {className: "content"}, 
            React.createElement("ul", {className: "my-lesson-list"}, 
                React.createElement("li", null, 
                    React.createElement("span", {className: "result-count"}, "총 : ", React.createElement("em", null, totalCnt), "건"), 
                    React.createElement("ul", null, 
                        classList
                    )
                )
            ), 
            paging
        )
      );
    }
});

