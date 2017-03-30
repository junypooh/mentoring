//SCHOOL-MAIN MyLesson

var MyLectureTab = React.createClass({
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
            myLecture.push(<MyLectureList data={this.state.data}/>);
        }else{
            myLecture.push(
                <div className="no-lesson-txt">
                    신청 된 수업이 없습니다.
                </div>
            );
        }

        var paging = [];
        var pageSize = 10;
        if(mentor.isMobile){
            pageSize = 5;
        }
            paging.push(
                <div className="btn-paging">
                  <PageNavi url={this.props.url} pageFunc={goPage} pageSize={pageSize} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
                </div>
            );

        return (
            <div className="tab-cont active">
                <h3 className="invisible">전체 내용</h3>
                <div className="my-lesson-list">
                    {myLecture}
                </div>
                {paging}
            </div>
        );
    }
});

var MyLectureList = React.createClass({

    render:function(){
        var myLecList = this.props.data.map(function(lecData, index) {
            return (
                <MyLecture lectrNm={lecData.lectrNm}
                           lectrJobNo={lecData.lectrJobNo}
                           lectrJobNm={lecData.lectrJobNm}
                           lectDay={to_date_format(lecData.lectDay, "-")}
                           lectStartTime={to_time_format(lecData.lectStartTime, ":")}
                           lectEndTime={to_time_format(lecData.lectEndTime, ":")}
                           lectTitle={lecData.lectTitle}
                           reqLectTitle={lecData.reqLectTitle}
                           lectIntdcInfo={lecData.lectIntdcInfo}
                           lectTypeCd={lecData.lectTypeCd}
                           lectStatCd={lecData.lectStatCd}
                           lectStatCdNm={lecData.lectStatCdNm}
                           reqSer={lecData.reqSer}
                           myLectList = {lecData.myLecutureReqTimeList}
                           regDtm = {lecData.regDtm}
                           imgPath={lecData.lectPicPath}
                           lectSer={lecData.lectSer}
                           lectTims={lecData.lectTims}
                           clasRoomSer={lecData.clasRoomSer}
                           setSer={lecData.setSer}
                           schdSeq={lecData.schdSeq}
                           applStatCd={lecData.applStatCd}
                           applClassCd={lecData.applClassCd}
                           clasRoomCualfCd={lecData.clasRoomCualfCd}
                           clasRoomNm={lecData.clasRoomNm}
                           schNm={lecData.schNm}
                           reqStatCd={lecData.reqStatCd}
                           reqStatCdNm={lecData.reqStatCdNm}
                           schNo={lecData.schNo}
                           lectSessId={lecData.lectSessId}
                           targtJobNm={lecData.targtJobNm}
                           targtMentorNm={lecData.targtMentorNm}
                           withdrawCnt={lecData.withdrawCnt}
                    />
            );
        });

        return (
            <ul>
                {myLecList}
            </ul>
        );
    }
});


var MyLecture = React.createClass({
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
                        lectStatHtml.push(<a href="#layer1" className="cancel layer-open" title="팝업 - 열기" onClick={this.cancelReqLecture.bind(this, this.props.lectSer, this.props.lectTims, this.props.clasRoomSer, this.props.setSer, this.props.schdSeq, this.props.schNo, this.props.applClassCd)}>{cnclNm}</a>);
                    }
                }else if(lectStatCd == "101548"){
                    //추후 해당 상태 처리
                }else if(!mentor.isMobile && (lectStatCd == "101549" || lectStatCd == "101550") ){  //수업확정, 수업예정, 수업중
                    if(mbrClassCd == "100859" || mbrClassCd == "101707" || clasRoomCualfCd == "101691"){ // 교사 또는 학교관리자, 대상반의 반대표
                        lectStatHtml.push(<a href="javascript:void(0);" onClick={this.lectureEntrance.bind(this, this.props.clasRoomSer, this.props.lectSessId, this.props.applClassCd)}>입장</a>);
                    }

                }else if(lectStatCd == "101551"){  //수업 완료
                    lectStatHtml.push(<a href="javascript:void(0);" className="task" onClick={this.lectureTaskRegist.bind(this, this.props.lectSer)}>수업과제</a>);
                    lectStatHtml.push(<a href="javascript:void(0);" className="task" onClick={this.lectureDetailEvl.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq)}>수업평가</a>);

                    if(mbrClassCd == "100859" || mbrClassCd == "101707" || clasRoomCualfCd == "101691"){ // 교사 또는 학교관리자, 대상반의 반대표
                        if(!mentor.isMobile){
                            lectWorkHtml.push(<a href="#layer1" className="btn-type7 btn-hw-v" onClick={this.getLectWorkList.bind(this, this.props.lectSer, this.props.lectTims, this.props.schdSeq, this.props.clasRoomSer)}>과제보기</a>);
                        }
                    }

                }
            }
            lectDetailTag.push(<strong><a href="javascript:void(0);" onClick={this.goLectureView.bind(this,  this.props.lectSer, this.props.lectTims, this.props.schdSeq)}><em>{lectTypeNm}</em>{this.props.lectTitle}</a></strong>);

            reqTimeTag.push(<div className={layerTag}>
                                <strong>{this.props.lectDay}</strong>
                                <span><b>{this.props.lectStartTime}</b><b>~</b><b>{this.props.lectEndTime}</b></span>
                                {lectStatHtml}
                            </div>);
            reqTimeTag.push(<span className="thumb"><img src={mentor.contextpath + "/fileDown.do?fileSer="+ this.props.imgPath} alt={this.props.lectTitle} onError={this.defaultImgPath}/></span>);

            lectInfoHtml.push(<div className="day-wrap">
                                 <span className="m-name">{this.props.lectrNm}</span>
                                 <span className="m-jop">{this.props.lectrJobNm}</span>
                                 <span className="professor">
                                    <em>
                                        <span>{this.props.schNm}</span>
                                        <span className="class-num">
                                            {this.props.clasRoomNm}
                                        </span>
                                    </em>
                                 </span>
                              </div>
                             );
            lectInfoHtml.push(<p>{this.props.lectIntdcInfo}</p>);
        }else{  //요청수업 (수업신청이력 없음)
            lectDetailTag.push(<strong><em>{lectTypeNm}</em>{this.props.reqLectTitle}</strong>);

            var prefTime =  toTimeObject(this.props.myLectList[0].lectPrefDay.replace(regExp, "") + this.props.myLectList[0].lectPrefTime.replace(regExp, ""));
            var nowTime =  new Date();

            if(lectStatCd == "101543"){  // 요청수업 수강모집 가능
                    lectStatHtml.push(<a href="javascript:void(0);" className="request" onClick={this.applLectApplInfo.bind(this, this.props.lectSer, this.props.lectTims)}>신청</a>);
            }else{
                if(this.props.lectSer != null){ //신청기간이 지난 수업들
                    layerTag = "layer finish";
                    lectStatHtml.push(<a href="#" className="task">신청종료</a>);

                }else if(prefTime.getTime() < nowTime.getTime()){ //요청날짜 지난 기간만료 요청
                    layerTag = "layer finish";
                    lectStatHtml.push(<a href="#" className="task">기간만료</a>);

                }else if(reqStatCd != "101657"){ //요청수업
                    cancleTag.push(<a href="javascript:void(0);" className="cancel" onClick={this.cancelReqLectInfo.bind(this, this.props.reqSer)}>취소</a>);

                }else if(reqStatCd == "101657"){
                                    layerTag = "layer finish";
                                    lectStatHtml.push(<a href="#" className="task">요청취소</a>);
                }
            }

            if(this.props.myLectList.length > 1 && (lectStatCd == "101543" ||  (prefTime.getTime() > nowTime.getTime() &&  this.props.lectSer == null))){ //희망수업 2개이상이고 수업모집상태이거나 수업미개설 상태에서 희망일자가 지나지 않을경우
                for(var i=1; i<this.props.myLectList.length; i++) {
                    timeLoop.push(<li><a href="#"><strong>{to_date_format(this.props.myLectList[i].lectPrefDay, "-")}</strong><span><b>{to_time_format(this.props.myLectList[i].lectPrefTime, ":")}</b></span></a></li>);
                }
                reqTimeTag.push(<div className={layerTag}>
                                    <strong>{to_date_format(this.props.myLectList[0].lectPrefDay, "-")}</strong>
                                    <span className="lesson-time"><a href="javascript:void(0);" id={this.props.reqSer+this.props.lectTims} onClick={this.handleClick.bind(this, this.props.reqSer+this.props.lectTims)}>{to_time_format(this.props.myLectList[0].lectPrefTime, ":")}</a></span>
                                    <div className={dateOpen}>
                                        <ul>{timeLoop}</ul>
                                            {cancleBtnTag}
                                    </div>
                                    {lectStatHtml}
                                    {cancleTag}
                                </div>);
            }else{ //수업요청시간이 1개일경우
                reqTimeTag.push(<div className={layerTag}>
                                    <strong>{to_date_format(this.props.myLectList[0].lectPrefDay, "-")}</strong>
                                    <span>{to_time_format(this.props.myLectList[0].lectPrefTime, ":")}</span>
                                    {cancleTag}
                                    {lectStatHtml}
                                </div>);
            }
            reqTimeTag.push(<span className="thumb"><img src={mentor.contextpath + "/fileDown.do?fileSer="+ this.props.imgPath} alt={this.props.reqLectTitle} onError={this.defaultImgPath}/></span>);

            lectInfoHtml.push(<div className="day-wrap">
                                {(this.props.targtMentorNm==null)?'':<span className="m-name">{this.props.targtMentorNm}</span>}
                                {(this.props.targtJobNm==null)?'':<span className="m-jop">{this.props.targtJobNm}</span>}
                                <span className="professor">
                                    <em>
                                    </em>
                                </span>
                              </div>
                             );

            if(this.props.lectSer != null){
                lectInfoHtml.push(<p><b>개설수업</b> : <a href="javascript:void(0);" onClick={this.goLectureView.bind(this,  this.props.lectSer, this.props.lectTims, this.props.schdSeq)}><em>{lectTypeNm}</em>{this.props.lectTitle}</a></p>);
            }
        }

        return (
            <li>
                <div className="state">
                    {reqTimeTag}
                </div>
                <div className="info">
                    {lectDetailTag}
                    <div>
                        <span className="request-day">신청일<em>{to_date_format(this.props.regDtm, "-")}</em></span>
                        <span className={iconTag}>{this.props.lectStatCdNm}</span>
                    </div>
                    {lectInfoHtml}
                    {lectWorkHtml}
                </div>
            </li>
        );
    }
});

