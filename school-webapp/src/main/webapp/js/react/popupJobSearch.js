
var JobSearchView = React.createClass({displayName: "MentorSearchView",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0, 'initMsgType' : 0};
    },
    componentDidMount: function() {
        //this.getList();
    },
    getList: function(param) {

        this.initMsgType = 1;

        var _param = jQuery.extend({'currentPageNo':1,
            'recordCountPerPage':500,
            'searchKey':$("#searchKey").val(),
            'searchType':$("#seachType option:selected").val()},param);
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
                if(rtnData.length>0){
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount});
                    $(".search-result").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ");
                }else{
                    $(".search-result").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ");
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        if(this.initMsgType == 1){
            if(this.state.data != null && this.state.data.length > 0){
                return(
                        React.createElement(JobList, {data: this.state.data})
                );
            }else{
                    return(
                        React.createElement("ul", null, 
                            React.createElement("li", {className: "no-result"}, 
                                "검색된 결과가 없습니다.", React.createElement("br", null), 
                                "찾으시는 직업이 없는 경우 내용에 상세하게 입력해주세요."
                            )
                        )
                        );
            }
        }else{
        return(
            React.createElement("ul", null, 
                React.createElement("li", {className: "no-result"}, 
                    "직업을 검색해주세요."
                )
            )
            );
        }
    }
});

var JobList = React.createClass({displayName: "JobList",
    render:function(){
        var jobDetailList = this.props.data.map(function(lecData, index) {
            return (
                React.createElement(Job, {jobChrstcNm: lecData.jobChrstcNm, 
                     jobNm: lecData.jobNm, 
                     jobClsfNm: lecData.jobClsfNm, 
                     jobNo: lecData.jobNo})
            );
        });
        return (
            React.createElement("ul", null, 
                jobDetailList
            )
        );
    }
});

var Job = React.createClass({displayName: "Job",
    propTypes: {
        jobChrstcNm:    React.PropTypes.string,
        jobNm:       React.PropTypes.string,
        jobClsfNm:       React.PropTypes.string,
        jobNo:       React.PropTypes.string
    },
    render:function(){
        return (
            React.createElement("li", null, 
                React.createElement("label", null, 
                    React.createElement("span", {className: "job-subject"}, this.props.jobNm), 
                    React.createElement("span", {className: "sort"}, this.props.jobChrstcNm), 
                    React.createElement("span", {className: "job-sort"}, this.props.jobClsfNm), 
                    React.createElement("input", {type: "radio", name: "jobRadio", id: this.props.jobNo, value: this.props.jobNo})
                )
            )
        );
    }
});