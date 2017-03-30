//SCHOOL-MAIN MyLesson

var MyLectureTab = React.createClass({displayName: "MyLectureTab",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0, 'currentPageNo':1, 'recordCountPerPage':5};
    },
    componentDidMount: function() {
        this.getList({'listType':mentor.activeTab});
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,
                                    'recordCountPerPage':5,
                                    'lectTypeCd':param.listType},param);
        $.ajax({
            url: this.props.url,
            data : _param,
            contentType: "application/json",
            dataType: 'json',
            cache: false,
            success: function(rtnData) {
                var totalCnt = 0;
                var totalRecordCount = 0;
                if(rtnData.myLectList && rtnData.myLectList.length > 0){
                    totalRecordCount = rtnData.myLectList[0].totalRecordCount;
                    this.setState({data: rtnData.myLectList, 'totalRecordCount':totalRecordCount, currentPageNo: _param.currentPageNo});

                    var lectRegCnt = Number(rtnData.myLectCnt.st101543) + Number(rtnData.myLectCnt.st101548);
                    var lectIngCnt = Number(rtnData.myLectCnt.st101549) + Number(rtnData.myLectCnt.st101550);
                    var lectCnclCnt = Number(rtnData.myLectCnt.st101578) + Number(rtnData.myLectCnt.st101547) + Number(rtnData.myLectCnt.st101545);

                    totalCnt = lectRegCnt +  lectIngCnt + lectCnclCnt + Number(rtnData.myLectCnt.st101551) + Number(rtnData.myLectCnt.lectCnt);

                    $("#lessonTab01").text(Number(totalCnt).toString().length == 1?"전체(0" + Number(totalCnt)+ ")" :"전체(" +Number(totalCnt) + ")" );
                    $("#lessonTab02").text(lectRegCnt.toString().length == 1?"신청수업(0" + lectRegCnt+ ")" :"신청수업(" +lectRegCnt + ")" );
                    $("#lessonTab03").text(lectIngCnt.toString().length == 1?"오늘의 수업(0" + lectIngCnt+ ")" :"오늘의 수업(" +lectIngCnt + ")" );

                    $("#lessonTab04").text(Number(rtnData.myLectCnt.st101551).toString().length == 1?"수업완료(0" + Number(rtnData.myLectCnt.st101551)+ ")" :"수업완료(" +Number(rtnData.myLectCnt.st101551) + ")" );
                    $("#lessonTab05").text(lectCnclCnt.toString().length == 1?"수업취소(0" + lectCnclCnt+ ")" :"수업취소(" +lectCnclCnt + ")" );
                    $("#lessonTab06").text(Number(rtnData.myLectCnt.lectCnt).toString().length == 1?"요청수업(0" + Number(rtnData.myLectCnt.lectCnt)+ ")" :"요청수업(" +Number(rtnData.myLectCnt.lectCnt) + ")" );
                }else{
                    if(!mentor.isMobile){
                        this.setState({data: rtnData.myLectList, 'totalRecordCount': 0, currentPageNo: 1});
                    }
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var myLecture = [];
        if(this.state.data != null && this.state.data.length > 0){
            myLecture.push(React.createElement(MyLectureList, {data: this.state.data}));
        }else{
            myLecture.push(
                React.createElement("div", {className: "no-lesson-txt"}, 
                    "신청 된 수업이 없습니다."
                )
            );
        }

        var paging = [];
        var pageSize = 10;
        if(mentor.isMobile){
            pageSize = 5;
        }
            paging.push(
                React.createElement("div", {className: "btn-paging"}, 
                  React.createElement(PageNavi, {url: this.props.url, pageFunc: goPage, pageSize: pageSize, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
                )
            );

        return (
            React.createElement("div", {className: "tab-cont active"}, 
                React.createElement("h3", {className: "invisible"}, "전체 내용"), 
                React.createElement("div", {className: "my-lesson-list"}, 
                    myLecture
                ), 
                paging
            )
        );
    }
});

var MyLectureList = React.createClass({displayName: "MyLectureList",

    render:function(){
        var myLecList = this.props.data.map(function(lecData, index) {
            return (
                React.createElement(MyLecture, {lectrNm: lecData.lectrNm, 
                           lectrJobNo: lecData.lectrJobNo, 
                           lectrJobNm: lecData.lectrJobNm, 
                           lectDay: to_date_format(lecData.lectDay, "-"), 
                           lectStartTime: to_time_format(lecData.lectStartTime, ":"), 
                           lectEndTime: to_time_format(lecData.lectEndTime, ":"), 
                           lectTitle: lecData.lectTitle, 
                           reqLectTitle: lecData.reqLectTitle, 
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
                           setSer: lecData.setSer, 
                           schdSeq: lecData.schdSeq, 
                           applStatCd: lecData.applStatCd, 
                           applClassCd: lecData.applClassCd, 
                           clasRoomCualfCd: lecData.clasRoomCualfCd, 
                           clasRoomNm: lecData.clasRoomNm, 
                           schNm: lecData.schNm, 
                           reqStatCd: lecData.reqStatCd, 
                           reqStatCdNm: lecData.reqStatCdNm, 
                           schNo: lecData.schNo, 
                           lectSessId: lecData.lectSessId, 
                           targtJobNm: lecData.targtJobNm, 
                           targtMentorNm: lecData.targtMentorNm, 
                           withdrawCnt: lecData.withdrawCnt}
                    )
            );
        });

        return (
            React.createElement("ul", null, 
                myLecList
            )
        );
    }
});


var MyLecture = React.createClass({displayName: "MyLecture",
    propTypes: {
        lectrNm:        React.PropTypes.string,
        lectrJobNo:     React.PropTypes.string,
        lectrJobNm:     React.PropTypes.string,
        lectDay:        React.PropTypes.string,
        lectStartTime:  React.PropTypes.string,
        lectEndTime:    React.PropTypes.string,
        lectTitle:      React.PropTypes.string,
        reqLectTitle:   React.PropTypes.string,
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
        clasRoomSer:    React.PropTypes.string,
        setSer:         React.PropTypes.string,
        schdSeq:        React.PropTypes.string,
        applStatCd:     React.PropTypes.string,
        applClassCd:    React.PropTypes.string,
        clasRoomCualfCd:React.PropTypes.string,
        clasRoomNm:     React.PropTypes.string,
        schNm:          React.PropTypes.string,
        schNo:          React.PropTypes.string,
        reqStatCd:      React.PropTypes.string,
        reqStatCdNm:    React.PropTypes.string,
        lectSessId:     React.PropTypes.string,
        targtJobNm:     React.PropTypes.string,
        targtMentorNm:  React.PropTypes.string,
        withdrawCnt:    React.PropTypes.number

    },
    handleClick: function(id) {
        if(!$("#"+id).parent().hasClass('active')){
            $('.my-lesson-list span.lesson-time').removeClass('active');
            $("#"+id).parent().addClass('active');
            $('.content.sub').css('overflow','inherit');
            //dateOpen.parent().siblings('a').css('display','none');
        }else{
            $("#"+id).parent().removeClass('active');
            $('.content.sub').css('overflow','hidden');
        }
    },
    closeClick: function(id) {
        $("#"+id).parent().removeClass('active');
        $("#"+id).parent().siblings('a').css('display','');
    },
    cancelReqLecture: function(lectSer, lectTims, clasRoomSer, setSer,schdSeq, schNo, applClassCd) { //수업신청 취소

        $("#layerPopupDiv").load(mentor.contextpath +"/layer/layerLectureCancel.do?lectSer="+lectSer +"&lectTims=" + lectTims + "&clasRoomSer=" + clasRoomSer + "&setSer="+setSer + "&schdSeq=" + schdSeq + "&schNo=" +schNo + "&applClassCd=" +applClassCd,  function(){
            $("#layerOpen").trigger("click");
        });
    },
    cancelReqLectInfo: function(reqSer) {       //요청수업 취소
        $("#layerPopupDiv").load(mentor.contextpath +"/layer/layerReqLectCancel.do?reqSer="+reqSer, function(){
            $("#layerOpen").trigger("click");
        });
    },
    applLectApplInfo: function(lectSer, lectTims) {     //학교 신청
        $('#layerPopupDiv').load(mentor.contextpath + "/layer/layerPopupLectureApply.do?lectSer="+lectSer+"&lectTims="+lectTims+"&applClassCd=101715", {"callbackFunc":"callbackApplLectApplInfo"}, function() {
            $("#layerOpen").trigger("click");
        });
    },
    getLectWorkList: function(lectSer, lectTims, schdSeq, clasRoomSer) {     //학교 신청

        $('#layerPopupDiv').load(mentor.contextpath + "/layer/layerPopupLectureWorkList.do?cntntsTargtNo="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq+"&clasRoomSer="+clasRoomSer, {"callbackFunc":"callbackLectWorkList"}, function() {
            $("#layerOpen").trigger("click");
        });
    },
    defaultImgPath: function(imtPath) {
        //수업요청 default 이미지
        imtPath.target.src = mentor.contextpath + "/images/lesson/img_epilogue_default.gif";
    },
    goLectureView: function(lectSer, lectTims, schdSeq) {
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq;
        $(location).attr('href', url);
    },
    lectureTaskRegist: function(lectSer) {  //수업과제등록
        var url = mentor.contextpath + "/myPage/myCommnuity/data/workList.do?lectSer="+lectSer;
        $(location).attr('href', url);
    },
    lectureDetailEvl: function(lectSer, lectTims, schdSeq) { //수업평가
        var url = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+lectSer+"&lectTims="+lectTims+"&schdSeq="+schdSeq + "&evl=evl";
        $(location).attr('href', url);
    },
    lectureEntrance: function(classSer, lectSessId, applClassCd){
        solutionStart(lectSessId, classSer);
    },
    regObsvHist:function() {

        var lectSessId  = this.props.lectSessId;
        var clasRoomSer  = this.props.clasRoomSer;

        $.ajax({
          url: mentor.contextpath+"/myPage/myLecture/ajax.regObsvHist.do",
          data : {
                    /*lectSer : this.props.lectSer,
                    lectTims : this.props.lectTims,
                    schdSeq : this.props.schdSeq,aaaa*/
                    lectSessId : this.props.lectSessId,
                    clasRoomSer : this.props.clasRoomSer,
                    setSer : this.props.setSer,
                    schNo : this.props.schNo,
                    withdrawCnt : this.props.withdrawCnt
          },
          contentType: "application/json",
          dataType: 'json',
          cache: false,
          success: function(rtnData) {
              if(rtnData.success) {
                  solutionStart(lectSessId, clasRoomSer);
              }else{
                  alert(rtnData.message);
              }
          },
          error: function(xhr, status, err) {
            console.error("ajax.regObsvHist.do", status, err.toString());
          }
        });
    },

    render:function(){
        var lectTypeNm = "";

        //수업요청 시간목록
        var reqTimeTag = [];
        var timeLoop = [];
        var cancleTag = [];
        var cancleBtnTag = [];
        var lectDetailTag = [];
        var lectrInfoTag = [];


        if(this.props.lectTypeCd == "101530"){
            lectTypeNm = "[연강]";
        }else if(this.props.lectTypeCd == "101531"){
            lectTypeNm = "[특강]";
        }else if(this.props.lectTypeCd == "101532"){
            lectTypeNm = "[블록]";
        }

        var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

        var lectStatCd = this.props.lectStatCd;
        var applStatCd = this.props.applStatCd;
        var reqStatCd = this.props.reqStatCd;
        var clasRoomCualfCd = this.props.clasRoomCualfCd;
        var lectStatHtml = [];
        var lectWorkHtml = [];
        var lectInfoHtml = [];
        var lectSustHtml = [];
        var layerTag = "layer";
        var iconTag = "icon"
        var dateOpen = "date-open";

        if(reqStatCd == "101657"){
            iconTag = "icon cancel";
            {this.props.lectStatCdNm = this.props.reqStatCdNm};
        }else if(lectStatCd == "101545" || lectStatCd == "101547" || applStatCd == "101578"){
            layerTag = "layer cancel";
            dateOpen = "date-open type1"
            iconTag = "icon cancel";
            if(applStatCd == "101578" && lectStatCd != "101545" && lectStatCd != "101547"){
                {this.props.lectStatCdNm = "신청취소"};
            }
        }else if(lectStatCd == "101551"){
            layerTag = "layer finish";
            iconTag = "icon finish";
        }else if(lectStatCd == "101543"){
            iconTag = "icon recruit";
        }else if(lectStatCd == "101548"){
            iconTag = "icon schedule";
        }else if(reqStatCd == "101656" ){
            {this.props.lectStatCdNm = this.props.reqStatCdNm};
        }

        var cnclNm = "수업취소";

        if(this.props.applClassCd == "101716"){
            cnclNm = "참관취소";
        }

        if(applStatCd != null &&  applStatCd != ""){	// 수업 신청 이력 존재 UI

            //수업 신청 취소 , 모집취소 , 모집실패 처리
            if(lectStatCd == "101545" || lectStatCd == "101547" || applStatCd == "101578"){
                //추후 해당 상태 처리

            }else{
                if(lectStatCd == "101543"){  //수강모집
                    if(mbrClassCd == "100859" || mbrClassCd == "101707" || clasRoomCualfCd == "101691"){ // 교사 또는 학교관리자, 대상반의 반대표
                        lectStatHtml.push(React.createElement("a", {href: "#layer1", className: "cancel layer-open", title: "팝업 - 열기", onClick: this.cancelReqLecture.bind(this, this.props.lectSer, this.props.lectTims, this.props.clasRoomSer, this.props.setSer, this.props.schdSeq, this.props.schNo, this.props.applClassCd)}, cnclNm));
                    }
                }else if(lectStatCd == "101548"){
                    //추후 해당 상태 처리
                }else if(!mentor.isMobile && (lectStatCd == "101549" || lectStatCd == "101550") ){  //수업확정, 수업예정, 수업중
                    if(mbrClassCd == "100859" || mbrClassCd == "101707" || clasRoomCualfCd == "101691"){ // 교사 또는 학교관리자, 대상반의 반대표
                        lectStatHtml.push(React.createElement("a", {href: "javascript:void(0);", onClick: this.lectureEntrance.bind(this, this.props.clasRoomSer, this.props.lectSessId, this.props.applClassCd)}, "입장"));
                    }

                }else if(lectStatCd == "101551"){  //수업 완료
                    lectStatHtml.push(React.createElement("a", {href: "javascript:void(0);", className: "task", onClick: this.lectureTaskRegist.bind(this, this.props.lectSer)}, "수업과제"));
                    lectStatHtml.push(React.createElement("a", {href: "javascript:void(0);", className: "task", onClick: this.lectureDetailEvl.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}, "수업평가"));

                    if(mbrClassCd == "100859" || mbrClassCd == "101707" || clasRoomCualfCd == "101691"){ // 교사 또는 학교관리자, 대상반의 반대표
                        if(!mentor.isMobile){
                            lectWorkHtml.push(React.createElement("a", {href: "#layer1", className: "btn-type7 btn-hw-v", onClick: this.getLectWorkList.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq, this.props.clasRoomSer)}, "과제보기"));
                        }
                    }

                }
            }
            lectDetailTag.push(React.createElement("strong", null, React.createElement("a", {href: "javascript:void(0);", onClick: this.goLectureView.bind(this,  this.props.lectSer, this.props.lectTims, this.props.schdSeq)}, React.createElement("em", null, lectTypeNm), this.props.lectTitle)));

            reqTimeTag.push(React.createElement("div", {className: layerTag}, 
                                React.createElement("strong", null, this.props.lectDay), 
                                React.createElement("span", null, React.createElement("b", null, this.props.lectStartTime), React.createElement("b", null, "~"), React.createElement("b", null, this.props.lectEndTime)), 
                                lectStatHtml
                            ));
            reqTimeTag.push(React.createElement("span", {className: "thumb"}, React.createElement("img", {src: mentor.contextpath + "/fileDown.do?fileSer="+ this.props.imgPath, alt: this.props.lectTitle, onError: this.defaultImgPath})));

            lectInfoHtml.push(React.createElement("div", {className: "day-wrap"}, 
                                 React.createElement("span", {className: "m-name"}, this.props.lectrNm), 
                                 React.createElement("span", {className: "m-jop"}, this.props.lectrJobNm), 
                                 React.createElement("span", {className: "professor"}, 
                                    React.createElement("em", null, 
                                        React.createElement("span", null, this.props.schNm), 
                                        React.createElement("span", {className: "class-num"}, 
                                            this.props.clasRoomNm
                                        )
                                    )
                                 )
                              )
                             );
            lectInfoHtml.push(React.createElement("p", null, this.props.lectIntdcInfo));
        }else{  //요청수업 (수업신청이력 없음)
            lectDetailTag.push(React.createElement("strong", null, React.createElement("em", null, lectTypeNm), this.props.reqLectTitle));

            var prefTime =  toTimeObject(this.props.myLectList[0].lectPrefDay.replace(regExp, "") + this.props.myLectList[0].lectPrefTime.replace(regExp, ""));
            var nowTime =  new Date();

            if(lectStatCd == "101543"){  // 요청수업 수강모집 가능
                    lectStatHtml.push(React.createElement("a", {href: "javascript:void(0);", className: "request", onClick: this.applLectApplInfo.bind(this, this.props.lectSer, this.props.lectTims)}, "신청"));
            }else{
                if(this.props.lectSer != null){ //신청기간이 지난 수업들
                    layerTag = "layer finish";
                    lectStatHtml.push(React.createElement("a", {href: "#", className: "task"}, "신청종료"));

                }else if(prefTime.getTime() < nowTime.getTime()){ //요청날짜 지난 기간만료 요청
                    layerTag = "layer finish";
                    lectStatHtml.push(React.createElement("a", {href: "#", className: "task"}, "기간만료"));

                }else if(reqStatCd != "101657"){ //요청수업
                    cancleTag.push(React.createElement("a", {href: "javascript:void(0);", className: "cancel", onClick: this.cancelReqLectInfo.bind(this, this.props.reqSer)}, "취소"));

                }else if(reqStatCd == "101657"){
                                    layerTag = "layer finish";
                                    lectStatHtml.push(React.createElement("a", {href: "#", className: "task"}, "요청취소"));
                }
            }

            if(this.props.myLectList.length > 1 && (lectStatCd == "101543" ||  (prefTime.getTime() > nowTime.getTime() &&  this.props.lectSer == null))){ //희망수업 2개이상이고 수업모집상태이거나 수업미개설 상태에서 희망일자가 지나지 않을경우
                for(var i=1; i<this.props.myLectList.length; i++) {
                    timeLoop.push(React.createElement("li", null, React.createElement("a", {href: "#"}, React.createElement("strong", null, to_date_format(this.props.myLectList[i].lectPrefDay, "-")), React.createElement("span", null, React.createElement("b", null, to_time_format(this.props.myLectList[i].lectPrefTime, ":"))))));
                }
                reqTimeTag.push(React.createElement("div", {className: layerTag}, 
                                    React.createElement("strong", null, to_date_format(this.props.myLectList[0].lectPrefDay, "-")), 
                                    React.createElement("span", {className: "lesson-time"}, React.createElement("a", {href: "javascript:void(0);", id: this.props.reqSer+this.props.lectTims, onClick: this.handleClick.bind(this, this.props.reqSer+this.props.lectTims)}, to_time_format(this.props.myLectList[0].lectPrefTime, ":"))), 
                                    React.createElement("div", {className: dateOpen}, 
                                        React.createElement("ul", null, timeLoop), 
                                            cancleBtnTag
                                    ), 
                                    lectStatHtml, 
                                    cancleTag
                                ));
            }else{ //수업요청시간이 1개일경우
                reqTimeTag.push(React.createElement("div", {className: layerTag}, 
                                    React.createElement("strong", null, to_date_format(this.props.myLectList[0].lectPrefDay, "-")), 
                                    React.createElement("span", null, to_time_format(this.props.myLectList[0].lectPrefTime, ":")), 
                                    cancleTag, 
                                    lectStatHtml
                                ));
            }
            reqTimeTag.push(React.createElement("span", {className: "thumb"}, React.createElement("img", {src: mentor.contextpath + "/fileDown.do?fileSer="+ this.props.imgPath, alt: this.props.reqLectTitle, onError: this.defaultImgPath})));

            lectInfoHtml.push(React.createElement("div", {className: "day-wrap"}, 
                                (this.props.targtMentorNm==null)?'':React.createElement("span", {className: "m-name"}, this.props.targtMentorNm), 
                                (this.props.targtJobNm==null)?'':React.createElement("span", {className: "m-jop"}, this.props.targtJobNm), 
                                React.createElement("span", {className: "professor"}, 
                                    React.createElement("em", null
                                    )
                                )
                              )
                             );

            if(this.props.lectSer != null){
                lectInfoHtml.push(React.createElement("p", null, React.createElement("b", null, "개설수업"), " : ", React.createElement("a", {href: "javascript:void(0);", onClick: this.goLectureView.bind(this,  this.props.lectSer, this.props.lectTims, this.props.schdSeq)}, React.createElement("em", null, lectTypeNm), this.props.lectTitle)));
            }
        }

        return (
            React.createElement("li", null, 
                React.createElement("div", {className: "state"}, 
                    reqTimeTag
                ), 
                React.createElement("div", {className: "info"}, 
                    lectDetailTag, 
                    React.createElement("div", null, 
                        React.createElement("span", {className: "request-day"}, "신청일", React.createElement("em", null, to_date_format(this.props.regDtm, "-"))), 
                        React.createElement("span", {className: iconTag}, this.props.lectStatCdNm)
                    ), 
                    lectInfoHtml, 
                    lectWorkHtml
                )
            )
        );
    }
});

