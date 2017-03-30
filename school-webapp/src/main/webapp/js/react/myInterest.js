var InterestJob = React.createClass({displayName: "InterestJob",
    showSetting:function(){
        if($(React.findDOMNode(this.refs.settings)).hasClass("active")) {
            $(React.findDOMNode(this.refs.settings)).removeClass("active");
        } else {
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(React.findDOMNode(this.refs.settings)).addClass("active");
        }
    },
    render:function(){
        var interestJob = [];
        if(this.props.jobPicInfo !=null && this.props.jobPicInfo != ""){
            interestJob.push(React.createElement("span", {className: "img"}, React.createElement("img", {src: parsePicInfo(this.props.jobPicInfo)})));
        }else if(this.props.fileSer !=null && this.props.fileSer != ""){
            interestJob.push(React.createElement("span", {className: "img"}, React.createElement("img", {src: mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileSer, alt: this.props.title})));
        }else{
            interestJob.push(React.createElement("span", {className: "img"}, React.createElement("img", {src: mentor.contextpath+"/images/mentor/bg_thumb_132x132.gif", alt: this.props.title})));
        }

        return (
                React.createElement("li", null, 
                    React.createElement("h3", null, "관심직업"), 
                    React.createElement("a", {href: "javascript:void(0)", className: "set-up", onClick: this.showSetting, ref: "settings"}, "설정"), 
                    React.createElement("div", {className: "layer"}, 
                        React.createElement("div", null, 
                            React.createElement("ul", null, 
                                React.createElement("li", null, 
                                    React.createElement("em", null, this.props.title), 
                                    React.createElement("a", {href: "javascript:void(0)", onClick: deleteMyInterest.bind(this,this.props)}, "소식안받기")
                                )
                            )
                        )
                    ), 
                    React.createElement("div", {className: "thumb"}, 
                        interestJob, 
                        React.createElement("strong", {className: "title"}, React.createElement("em", null, this.props.title), " 정보가 업데이트 되었습니다."), 
                        React.createElement("span", {className: "day"}, new Date(this.props.day).format('yyyy.MM.dd')), 
                        React.createElement("p", null, this.props.detail), 
                        React.createElement("a", {href: mentor.contextpath+"/mentor/jobIntroduce/showJobIntroduce.do?jobNo="+this.props.key1, className: "detail-view"}, "자세히보기")
                    )
                )
      );
    }
});

var InterestLecture = React.createClass({displayName: "InterestLecture",
    showSetting:function(){
        if($(React.findDOMNode(this.refs.settings)).hasClass("active")) {
            $(React.findDOMNode(this.refs.settings)).removeClass("active");
        } else {
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(React.findDOMNode(this.refs.settings)).addClass("active");
        }
    },
    render:function(){
        return (
                React.createElement("li", null, 
                    React.createElement("h3", null, "관심수업"), 
                    React.createElement("a", {href: "javascript:void(0)", className: "set-up", onClick: this.showSetting, ref: "settings"}, "설정"), 
                    React.createElement("div", {className: "layer"}, 
                        React.createElement("div", null, 
                            React.createElement("ul", null, 
                                React.createElement("li", null, 
                                    React.createElement("em", null, this.props.title), 
                                    React.createElement("a", {href: "javascript:void(0)", onClick: deleteMyInterest.bind(this,this.props)}, "소식안받기")
                                )
                            )
                        )
                    ), 
                    React.createElement("div", {className: "thumb lesson"}, 
                        React.createElement("span", {className: "img"}, React.createElement("img", {src: mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileSer, alt: this.props.title})), 
                        React.createElement("strong", {className: "title"}, React.createElement("em", null, this.props.title), " 수업이 관심수업으로 등록되었습니다."), 
                        React.createElement("span", {className: "day"}, new Date(this.props.day).format('yyyy.MM.dd')), 
                        React.createElement("span", {className: "lesson"}, "- 수업개설", React.createElement("span", null, this.props.detail)), 
                        React.createElement("a", {href: mentor.contextpath+"/lecture/lectureTotal/lectureView.do?lectSer="+this.props.key1+"&lectTims="+this.props.key2+"&schdSeq="+this.props.key3, className: "detail-view"}, "자세히보기")
                    )
                )
      );
    }
});

var InterestMentor = React.createClass({displayName: "InterestMentor",
    showSetting:function(){
        if($(React.findDOMNode(this.refs.settings)).hasClass("active")) {
            $(React.findDOMNode(this.refs.settings)).removeClass("active");
        } else {
            $('.choice-box > ul > li > a, .my_interest ul li a.set-up').removeClass('active');
            $(React.findDOMNode(this.refs.settings)).addClass("active");
        }
    },
    render:function(){
        return (
                React.createElement("li", null, 
                    React.createElement("h3", null, "관심멘토"), 
                    React.createElement("a", {href: "javascript:void(0)", className: "set-up", onClick: this.showSetting, ref: "settings"}, "설정"), 
                    React.createElement("div", {className: "layer"}, 
                        React.createElement("div", null, 
                            React.createElement("ul", {className: "mentor"}, 
                                React.createElement("li", null, 
                                    React.createElement("em", null, this.props.title), 
                                    React.createElement("a", {href: "javascript:void(0)", onClick: deleteMyInterest.bind(this,this.props)}, "소식안받기")
                                )
                            )
                        )
                    ), 
                    React.createElement("div", {className: "thumb lesson"}, 
                        React.createElement("span", {className: "img"}, React.createElement("img", {src: mentor.contextpath+"/fileDown.do?fileSer="+this.props.fileSer, alt: this.props.title})), 
                        React.createElement("strong", {className: "title"}, React.createElement("em", null, this.props.title), " 멘토가 관심멘토로 등록되었습니다."), 
                        React.createElement("span", {className: "day"}, new Date(this.props.day).format('yyyy.MM.dd')), 
                        React.createElement("span", {className: "lesson"}, React.createElement("span", null, this.props.detail)), 
                        React.createElement("a", {href: mentor.contextpath+"/mentor/mentorIntroduce/showMentorIntroduce.do?mbrNo="+this.props.key1, className: "detail-view"}, "자세히보기")
                    )
                )
      );
    }
});
var InterestList = React.createClass({displayName: "InterestList",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function(){
        this.getList();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);
        if(mentor.isMobile){
            if(_param.isMore != true){
                this.setState({'data': [],'totalRecordCount':0,'currentPageNo':1});
            }
        }
        $.ajax({
            url: this.props.url,
            data : _param,
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null && rtnData.length > 0){
                    totalCnt = rtnData[0].totalRecordCount;
                }
                if(mentor.isMobile){
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':totalCnt});
                }else{
                    this.setState({data: rtnData,'totalRecordCount':totalCnt, 'currentPageNo':_param.currentPageNo});
                }
            }.bind(this)
        });
    },
    render:function(){
        var interests = this.state.data.map(function(data, index) {
            if(data.type === "JOB"){
                return (
                        React.createElement(InterestJob, {fileSer: data.fileSer, title: data.title, detail: data.detail, day: data.regDtm, itrstTargtCd: data.itrstTargtCd, key1: data.key1, key2: data.key2, key3: data.key3, jobPicInfo: data.jobPicInfo})
                        );
            }else if(data.type === "LECTURE"){
                return (
                        React.createElement(InterestLecture, {fileSer: data.fileSer, title: data.title, detail: data.detail, day: data.regDtm, itrstTargtCd: data.itrstTargtCd, key1: data.key1, key2: data.key2, key3: data.key3})
                        );
            }else if(data.type === "MENTOR"){
                return (
                        React.createElement(InterestMentor, {fileSer: data.fileSer, title: data.title, detail: data.detail, day: data.regDtm, itrstTargtCd: data.itrstTargtCd, key1: data.key1, key2: data.key2, key3: data.key3})
                        );
            }
          });

        var paging = [];
        if(mentor.isMobile){
            paging.push(
                React.createElement("div", {className: "btn-more-view", style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, 
                    React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})}, "더 보기 (", React.createElement("span", null, this.state.totalRecordCount-this.state.data.length), ")")
                )
            );
        }else{
            paging.push(
                React.createElement("div", {className: "btn-paging"}, 
                  React.createElement(PageNavi, {url: this.props.url, pageFunc: goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
                )
            );
        }

        return (
    React.createElement("div", null, 
        React.createElement("div", {className: "my_interest"}, 
/*
            <span className="update">
                <span>2015.08.23</span>
                <em>00</em>개 업데이트
            </span>
*/
            React.createElement("ul", null, 
                interests
            )
        ), 
        paging
    )
      );
    }
});