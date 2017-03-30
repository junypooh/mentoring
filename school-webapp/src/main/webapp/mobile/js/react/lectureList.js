/**
 * Created by song on 2015-10-07.
 */
//Lecture
var Lecture = React.createClass({displayName: "Lecture",
    propTypes: {
        mentoNm:    React.PropTypes.string,
        title:      React.PropTypes.string,
        startTime:  React.PropTypes.string,
        endTime:    React.PropTypes.string,
        desc:       React.PropTypes.string,
        lectTargtCd:React.PropTypes.string,
        imgPath:    React.PropTypes.string,
        lectSer:    React.PropTypes.number,
        lectTims:   React.PropTypes.number,
        schdSeq:    React.PropTypes.number,
        lectStatCdNm:    React.PropTypes.string,
        lectTypeCd:    React.PropTypes.string,
        lectTypeCdNm:    React.PropTypes.string,
        lectSessId:		React.PropTypes.string
    },
    goLectureView: function(lectSer, lectTims, schdSeq, lectSessId) {
    	var sessId=null;
    	if(lectSessId==null){
    		sessId=0;
    	}else{
    		sessId=lectSessId;
    	}
        var url = mentor.contextpath + "/mobile/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq+"&lectSessId="+sessId;
        $(location).attr('href', url);
    },
    defaultImgPath: function(imtPath) {
        //수업요청 default 이미지
        imtPath.target.src = mentor.contextpath + "/images/lesson/img_epilogue_default.gif";
    },
    render:function(){
        var ratings = [];
        var lectTargtCd = this.props.lectTargtCd;
        var reqTimeTag = [];
        var reqTimeTagInfo = [];

        return (
        		React.createElement("li", null,
	        		React.createElement("span", {className: "date"}, this.props.date),
	              	React.createElement("ul", {className: "my-lesson-list"},
	                  		React.createElement("li", null,
	                  				React.createElement("a", {href: "javascript:void(0);", onClick: this.goLectureView.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq,this.props.lectSessId)}, /*React.createElement("em", null, lectTypeNm)),*/
		                  				React.createElement("dl", {className: "my-lesson-info"},
		                  						React.createElement("dt", {className: "title"},this.props.lectTypeCd == "101529" ?this.props.lectTitle:"[" + this.props.lectTypeCdNm + "]" +this.props.lectTitle),
		                  						React.createElement("dd", {className: "user"},this.props.lectrNm),
		                  						React.createElement("dd", {className: "date"},
			                  						React.createElement("span", {className: "num"},this.props.startTime),
			                  						React.createElement("span", {className: "bar"},"~"),
			                  						React.createElement("span", {className: "num"},this.props.endTime)),
		                  						React.createElement("dd", {className: "situation"},
		                  						React.createElement("span", {className: "r-icon schedule"},this.props.lectStatCdNm))
		                  					)
	                  				)
	                  		)
	                  )
	            )
        );
    }
});
var LectureList = React.createClass({displayName: "LectureList",
    render:function(){
        var lecList = this.props.data.map(function(lecData, index) {
//        	alert(lecData.lectTimsInfo.lectInfo.lectrNm);
//        	alert(lecData.lectSessId);
            return (
                React.createElement(Lecture, {lectTitle: lecData.lectTimsInfo.lectInfo.lectTitle, 
                    lectrNm: lecData.lectTimsInfo.lectInfo.lectrNm, 
                    date: to_date_format(lecData.lectDay, "-"), 
                    startTime: to_time_format(lecData.lectStartTime, ":"), 
                    endTime: to_time_format(lecData.lectEndTime,":"), 
                    desc: lecData.lectTimsInfo.lectInfo.lectOutlnInfo, 
                    lectTargtCd: lecData.lectTimsInfo.lectInfo.lectTargtCd, 
                    imgPath: lecData.lectTimsInfo.lectInfo.lectPicPath, 
                    lectSer: lecData.lectTimsInfo.lectSer, 
                    lectTims: lecData.lectTimsInfo.lectTims, 
                    schdSeq: lecData.schdSeq, 
                    lectStatCdNm: lecData.lectStatCdNm, 
                    lectTypeCd: lecData.lectTimsInfo.lectInfo.lectTypeCd, 
                    lectTypeCdNm: lecData.lectTimsInfo.lectInfo.lectTypeCdNm,
                    lectSessId:lecData.lectSessId})
            );
        });

        if(lecList.length == 0)
            lecList.push([]);
        return (
            React.createElement("ul", null, 
                lecList
            )
        );
    }
});
var LectureTabView = React.createClass({displayName: "LectureTabView",
    getInitialState: function() {
    	return {'data': [], 'totalRecordCount':0, 'currentPageNo':1, 'recordCountPerPage':9};
//        return {'data': [], 'totalRecordCount':0};
    },
    componentDidMount: function() {
//        this.getList({'listType':mentor.activeTab});
        this.getList({'listType':mentor.activeTab, 'isMore' :false});
    },
    getList: function(param) {
        var lectStatCd = "";

        console.log('list Type ::: > ' + param.listType);

        if(param.listType == "1"){  //수강모집
            lectStatCd = "101543";
        }else if(param.listType == "2"){ //수업예정
            lectStatCd ="101548";
        }else if(param.listType == "3"){  //수업대기
            lectStatCd ="101549";
        }else if(param.listType == "4"){  //수업중
            lectStatCd ="101550";
        }else if(param.listType == "5"){  //수업완료
            lectStatCd ="101551";
        }

        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,
            'recordCountPerPage':10,
            'schoolGrd':$("#schoolGrd").val(),
            'searchStDate':$("#searchStDate").val(),
            'searchEndDate':$("#searchEndDate").val(),
            'lectTime':$("#lectTime").val(),
            'lectType':$("#lectType").val(),
            'jobChrstcList':$("#jobChrstc").val(),
            'jobNo':$("#jobDetail").val(),
            'lectStatCd':lectStatCd,
            'searchKey':$("#searchKey").val(),
            'searchType':$("#seachType option:selected").val()},param);

        
        
        if(_param.isMore != true){
            this.setState({'data': [],'totalRecordCount':0, 'currentPageNo':1});
            _param.currentPageNo = 1;
        }
//        alert(this.props.url);
        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                if(rtnData.length>0){
//                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount});
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount,'currentPageNo':this.state.currentPageNo + 1});
//                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':rtnData[0].totalRecordCount,'currentPageNo':this.state.currentPageNo + 1});
//                    $(".result-total").html("검색 결과 총 <strong>"+ rtnData[0].totalRecordCount +"</strong> 건 ");
                }else{
//                    $(".result-total").html("검색 결과 총 <strong>"+ 0 +"</strong> 건 ");
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        return (
        		React.createElement(
                		"li", null,
                		React.createElement(LectureList, {data: this.state.data}),
                		React.createElement("div", {className: "btn-more", style: {display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}, 
                                React.createElement("a", {href: "javascript:void(0);", onClick: this.getList.bind(this,{'isMore':true, 'listType':mentor.activeTab, 'currentPageNo':this.state.currentPageNo })}, 
                                		React.createElement("span", null, "더 보기 "),
                                		React.createElement("strong", null, " ("),
                                		React.createElement("strong", null, this.state.totalRecordCount-this.state.data.length),
                                		React.createElement("strong", null, ")")
                                		)
                            )
                		));
    }
});
//Lecture