
var MentorSearchView = React.createClass({displayName: "MentorSearchView",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    componentDidMount: function() {
        //this.getList();
    },
    getList: function(param) {
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
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData.length});
                    $(".search-result").html("검색 결과 총 <strong>"+ rtnData.length +"</strong> 건 ");
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
        if(this.state.data != null && this.state.data.length > 0){
            return(
                    React.createElement(MentorList, {data: this.state.data})
            );
        }else{
        return(
            React.createElement("ul", null, 
                React.createElement("li", {className: "no-result"}, 
                    "검색 결과가 없습니다."
                )
            )
            );
        }
    }
});

var MentorList = React.createClass({displayName: "MentorList",
    render:function(){
        var mentorJobList = this.props.data.map(function(lecData, index) {
            return (
                React.createElement(Mentor, {mentorNm: lecData.mentorNm, 
                         jobNm: lecData.jobNm, 
                        mbrNo: lecData.mbrNo})
            );
        });
        return (
            React.createElement("ul", null, 
                mentorJobList
            )
        );
    }
});

var Mentor = React.createClass({displayName: "Mentor",
    propTypes: {
        mentorNm:    React.PropTypes.string,
        jobNm:       React.PropTypes.string
    },
    render:function(){
        return (
            React.createElement("li", null, 
                React.createElement("label", null, 
                    React.createElement("span", {className: "mento"}, this.props.mentorNm), 
                    React.createElement("span", {className: "job"}, this.props.jobNm), 
                    React.createElement("input", {type: "radio", name: "mentorRadio", id: this.props.mbrNo, value: this.props.mbrNo})
                )
            )
        );
    }
});