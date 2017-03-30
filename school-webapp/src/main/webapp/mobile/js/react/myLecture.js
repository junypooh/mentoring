//SCHOOL-MAIN MyLesson

var MyLectureTab = React.createClass({displayName: "MyLectureTab",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0, 'currentPageNo':1};
    },
    componentDidMount: function() {
        this.getList({'listType':mentor.activeTab});
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,
                                    'recordCountPerPage':5,
                                    'lectTypeCd':param.listType},param);
        if(_param.isMore != true){
            this.setState({'data': [],'totalRecordCount':0, 'currentPageNo':1});
            _param.currentPageNo = 1;
        }
        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var totalCnt = 0;
                var totalRecordCount = 0;
                if(rtnData.myLectList.length > 0){
                    totalRecordCount = rtnData.myLectList[0].totalRecordCount;
                }
                this.setState({data: this.state.data.concat(rtnData.myLectList), 'totalRecordCount':totalRecordCount, currentPageNo: this.state.currentPageNo + 1});

                for(var index=0; index<rtnData.myLectCnt.length; index++){

                    if(typeof rtnData.myLectCnt[index].lectCntStatCd != "undefined"){
                        var lectCnt = rtnData.myLectCnt[index].lectCnt;
                        if(lectCnt.toString().length == "1") lectCnt = "0" + rtnData.myLectCnt[index].lectCnt;

                    }
                }
                if(totalCnt.toString().length == "1") totalCnt = "0" + totalCnt;

            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var moreBtn = [];
        moreBtn.push(
                React.createElement("div", {className: "btn-more", style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, 
                    React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true, 'listType':mentor.activeTab, 'currentPageNo':this.state.currentPageNo })}, 
                        React.createElement("span", null, "더보기(", React.createElement("strong", null, this.state.totalRecordCount-this.state.data.length), ")")
                    )



                )
        );


        return (
                React.createElement("div", {class: "content"}, 
                        React.createElement(MyLectureList, {data: this.state.data}), 
                        moreBtn
                )
               );
    }
});

var MyLectureList = React.createClass({displayName: "MyLectureList",

    render:function(){
        var myLecList = this.props.data.map(function(lecData, index) {
            return (
                React.createElement(MyLecture, {lectrNm: lecData.lectrNm, 
                           lectDay: to_date_format(lecData.lectDay, "-"), 
                           lectStartTime: to_time_format(lecData.lectStartTime, ":"), 
                           lectEndTime: to_time_format(lecData.lectEndTime, ":"), 
                           lectTitle: lecData.lectTitle, 
                           lectIntdcInfo: lecData.lectIntdcInfo, 
                           lectTypeCd: lecData.lectTypeCd, 
                           lectStatCd: lecData.lectStatCd, 
                           lectStatCdNm: lecData.lectStatCdNm, 
                           reqSer: lecData.reqSer, 
                           myLectList: lecData.myLecutureReqTimeList, 
                           regDtm: lecData.regDtm, 
                           imgPath: lecData.lectPicPath, 
                           lectSer: lecData.lectSer, 
                           lectTims: lecData.lectTims, 
                           clasRoomSer: lecData.clasRoomSer, 
                           clasRoomCualfCd: lecData.clasRoomCualfCd, 
                           setSer: lecData.setSer, 
                           schdSeq: lecData.schdSeq, 
                           applStatCd: lecData.applStatCd, 
                           clasRoomNm: lecData.clasRoomNm, 
                           schNm: lecData.schNm, 
                           reqStatCd: lecData.reqStatCd, 
                           schNo: lecData.schNo, 
                           lectSessId: lecData.lectSessId, 
                           applClassCd: lecData.applClassCd}
                    )
            );
        });
        return (
            React.createElement("ul", {className: "my-lesson-list"}, 
                myLecList
            )
        );
    }
});


var MyLecture = React.createClass({displayName: "MyLecture",
    propTypes: {
        lectrNm:        React.PropTypes.string,
        lectDay:        React.PropTypes.string,
        lectStartTime:  React.PropTypes.string,
        lectEndTime:    React.PropTypes.string,
        lectTitle:      React.PropTypes.string,
        lectIntdcInfo:  React.PropTypes.string,
        lectTypeCd:     React.PropTypes.string,
        lectStatCd:     React.PropTypes.string,
        lectStatCdNm:   React.PropTypes.string,
        reqSer:         React.PropTypes.string,
        myLectList:     React.PropTypes.array,
        regDtm:         React.PropTypes.string,
        imgPath:        React.PropTypes.string,
        lectSer:        React.PropTypes.string,
        lectTims:       React.PropTypes.string,
        schdSeq:        React.PropTypes.string,
        clasRoomSer:    React.PropTypes.string,
        clasRoomCualfCd:React.PropTypes.string,
        setSer:         React.PropTypes.string,
        schdSeq:        React.PropTypes.string,
        applStatCd:     React.PropTypes.string,
        clasRoomSer:    React.PropTypes.string,
        schNm:          React.PropTypes.string,
        schNo:          React.PropTypes.string,
        reqStatCd:      React.PropTypes.string,
        lectSessId:		React.PropTypes.string,
        applClassCd:	React.PropTypes.string,
        compareDate:	React.PropTypes.string
    },
    handleClick: function(id) {
        var dateOpen = $('.my-lesson-list span.lesson-time a');

        if(!$("#"+id).parent().hasClass('active')){
            $("#"+id).parent().addClass('active');
        }else{
            $("#"+id).parent().removeClass('active');
        }
    },
    closeClick: function(id) {
        $("#"+id).parent().removeClass('active');
        $("#"+id).parent().siblings('a').css('display','');
    },
    defaultImgPath: function(imtPath) {
        //수업요청 default 이미지
        imtPath.target.src = "/school/images/lesson/img_epilogue_default.gif";
    },
    goLectureView: function(lectSer, lectTims, schdSeq, lectSessId, clasRoomCualfCd, applClassCd, clasRoomSer) {
        var url = mentor.contextpath + "/mobile/myLessonView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq+"&lectSessId="+lectSessId+"&clasRoomCualfCd="+clasRoomCualfCd+"&applClassCd="+applClassCd+"&clasRoomSer="+clasRoomSer;
        $(location).attr('href', url);
    },
    
    lectureEntrance: function(clasRoomSer, lectSessId){
    	solutionStart(lectSessId, clasRoomSer);
    },
    
    render:function(){

        var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

        var lectStatCd = this.props.lectStatCd;
        var applStatCd = this.props.applStatCd;
        var reqStatCd = this.props.reqStatCd;
        var clasRoomCualfCd = this.props.clasRoomCualfCd;

        var lectStatHtml = [];
        var iconTag = [];

        var enterNm = "신청입장";

        if(this.props.applClassCd == "101716"){
            enterNm = "참관입장";
        }

        if(clasRoomCualfCd != "101691" && mbrClassCd != "100859" && mbrClassCd != "101707"){
            enterNm = "참관하기";
        }

        if(lectStatCd == "101548"){
            iconTag.push(React.createElement("span", {className: "r-icon stand-by"}, "수업확정"));
        }else if(lectStatCd == "101549"){
            iconTag.push(React.createElement("span", {className: "r-icon schedule"}, "수업예정"));
            //lectStatHtml.push(<a href="javascript:void(0);" onClick={this.lectureEntrance.bind(this, this.props.clasRoomSer, this.props.lectSessId)}>{enterNm}</a>);
        }else if(lectStatCd == "101550"){
            iconTag.push(React.createElement("span", {className: "r-icon lessoning"}, "수업중"));
            //lectStatHtml.push(<a href="javascript:void(0);" onClick={this.lectureEntrance.bind(this, this.props.clasRoomSer, this.props.lectSessId)}>{enterNm}</a>);
        }

        var reqTimeTag = [];
        var reqTimeTagInfo = [];


        //수업상세 링크
      	reqTimeTag.push(React.createElement("span", {className: "date"}, this.props.lectDay, " (", getWeekday(this.props.lectDay), ")"));
       	reqTimeTagInfo.push(
                    React.createElement("ul", null, 
                        React.createElement("li", null, 
                            React.createElement("a", {href: "#", onClick: this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq,this.props.lectSessId, this.props.clasRoomCualfCd, this.props.applClassCd, this.props.clasRoomSer)}, 
                                React.createElement("dl", {className: "my-lesson-info"}, 
                                    React.createElement("dt", {className: "title"}, this.props.lectTitle), 
                                    React.createElement("dd", {className: "user"}, this.props.lectrNm), 
                                    React.createElement("dd", {className: "job"}, this.props.lectrNm), 
                                    React.createElement("dd", {className: "date"}, 
                                        React.createElement("span", {className: "num"}, this.props.lectStartTime), 
                                        React.createElement("span", {className: "bar"}, "~"), 
                                        React.createElement("span", {className: "num"}, this.props.lectEndTime), 
                                        React.createElement("span", {className: "time"}, "(", to_time_space(this.props.lectStartTime, this.props.lectEndTime), "분)")
                                    ), 
                                    React.createElement("dd", {className: "situation"}, 
                                        iconTag
                                    )
                                )
                            )
                        )
                    )
        );
        return (
                    React.createElement("li", {className: "today"}, 
                        reqTimeTag, 
                        reqTimeTagInfo
                    )
        );
    }
});

