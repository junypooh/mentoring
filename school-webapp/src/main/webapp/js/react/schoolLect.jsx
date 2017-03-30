var SchoolLectList = React.createClass({
    getInitialState: function() {

        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
    },
    goPage:function(pageNo) {
        var param = {currentPageNo : pageNo};
        this.getList(param);
    },
    getList: function(param) {

        var _param = jQuery.extend({'currentPageNo':1,'recordCountPerPage':10, 'lectApplCnt.schNo':$("#selSch").val(),'setTargtNo':'','setTargtCd':$("#lessonNum").val(), 'bizGrpInfo.grpNo':$("#biz").val()},param);
        $.ajax({
            url: this.props.url,
            data : _param,
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null && rtnData.length > 0){
                    totalCnt = rtnData[0].totalRecordCount;
                }
                var listData;
                if(_param.isMore != true){
                    listData = rtnData;
                }else{
                    listData = this.state.data.concat(rtnData);
                }

                this.setState({'data': listData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var classList = null;
        var totalCnt = this.state.totalRecordCount;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            var lectureUrl = mentor.contextpath + "/lecture/lectureTotal/lectureView.do?lectSer="+classData.lectSer+"&lectTims="+classData.lectTims+"&schdSeq=1";
            return (
        <tr>
            <td className="tbl-hide">{totalCnt - classData.rn +1}</td>
            <td className="ta-left">{mentor.parseDate(classData.lectDay).format('yyyy.MM.dd')} {classData.lectStartTime.replace(/^(\d{2})(\d{2})$/,"$1:$2")}~{classData.lectEndTime.replace(/^(\d{2})(\d{2})$/,"$1:$2")}</td>
            <td ><a href={lectureUrl}>[{classData.lectTypeNm}] {classData.lectTitle}</a></td>
            <td className="tbl-hide">{classData.applMbrNm}</td>
            <td className="tbl-hide">{classData.clasRoomNm}</td>
            <td className="tbl-hide">{classData.applClassNm}</td>
            <td>{classData.applClassCd == '101715' ? classData.lectureCnt : (classData.lectureCnt/2)}</td>
            <td className="tbl-hide">{classData.applStatNm}</td>
        </tr>
                  );
                });
            var paging = [];

            paging.push(
                  <div className="btn-paging">
                      <PageNavi url={this.props.url} pageFunc={this.goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
                  </div>
                  );
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                        <td colSpan="3">수업 신청 내역이 없습니다. </td>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        return (
            <div>
                <table className="tbl-other school-application">
                    <caption>대전둔원고등학교 학교신청현황 테이블정보 - 번호, 수업일, 멘토명, 수업명, 상태, 신청교사명, 현황</caption>
                   <colgroup>
                        <col/>
                        <col style={{width:"20%"}}/>
                        <col style={{width:"30%"}}/>
                        <col/>
                        <col/>
                        <col/>
                        <col/>
                        <col/>
                    </colgroup>
                    <thead>
                       <tr>
                            <th scope="col" className="tbl-hide">번호</th>
                            <th scope="col">수업일시</th>
                            <th scope="col">수업명</th>
                            <th scope="col" className="tbl-hide">신청교사명</th>
                            <th scope="col" className="tbl-hide">신청교실</th>
                            <th scope="col" className="tbl-hide">신청유형</th>
                            <th scope="col">차감기준</th>
                            <th scope="col" className="tbl-hide">상태</th>
                        </tr>
                    </thead>
                        <tbody>{classList}</tbody>
                    </table>
                    <div style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                        {paging}
                    </div>
                </div>
      );
    }
});



var SchAssignGroupList = React.createClass({
    getInitialState: function() {

        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
    },
    goPage:function(pageNo) {
        var param = {currentPageNo : pageNo};
        this.getList(param);
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':1,'recordCountPerPage':10, 'schNo':$("#selSch1").val(),'setTargtNo':'','setTargtCd':$("#lessonNum").val(), 'bizGrpInfo.grpNo':$("#biz").val()},param);
        $.ajax({
            url: this.props.url,
            data : _param,
            success: function(rtnData) {
                var totalCnt = 0;
                if(rtnData != null && rtnData.length > 0){
                    totalCnt = rtnData[0].totalRecordCount;
                }
                var listData;
                if(_param.isMore != true){
                    listData = rtnData;
                }else{
                    listData = this.state.data.concat(rtnData);
                }



                this.setState({'data': listData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo});
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var classList = null;
        var totalCnt = this.state.totalRecordCount;
        $("#singleSchArea").text(totalCnt);
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {

            if (typeof(classData.clasPermCnt) == "undefined"){
                classData.clasPermCnt = 0;
            }

            if(classData.clasEmpCnt == 0 && classData.clasPermCnt == 0){
                classData.clasPermCnt = classData.clasCnt;
            }
            classData.clasCnt = Number(classData.clasEmpCnt) + Number(classData.clasPermCnt);
            return (
                    <tr>
                        <td className="tbl-hide">{totalCnt - classData.rn +1}</td>
                        <td className="ta-left"><a href="#"  onClick={this.goLectureInfo.bind(this, classData)}>{classData.grpNm}</a></td>
                        <td className="tbl-hide">{mentor.parseDate(classData.clasStartDay).format('yyyy.MM.dd')} ~ {mentor.parseDate(classData.clasEndDay).format('yyyy.MM.dd')}</td>
                        <td>{classData.grpYn}</td>
                        <td>{classData.clasCnt}</td>
                        <td className="tbl-hide">{classData.clasEmpCnt}</td>
                        <td>{classData.clasPermCnt}</td>
                    </tr>
                  );
                });
            var paging = [];

            paging.push(
                  <div className="btn-paging">
                      <PageNavi url={this.props.url} pageFunc={this.goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
                  </div>
                  );
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td className="tbl-hide"></td>
                        <td colSpan="4">등록된 배정사업이 없습니다. </td>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        return (
            <div>
                <table className="tbl-other school-application">
                    <caption>대전둔원고등학교 학교신청현황 테이블정보 - 번호, 수업일, 멘토명, 수업명, 상태, 신청교사명, 현황</caption>
                    <colgroup>
                        <col/>
                        <col style={{width:"30%"}}/>
                        <col style={{width:"20%"}}/>
                        <col/>
                        <col/>
                        <col/>
                        <col/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col" className="tbl-hide">번호</th>
                            <th scope="col">배정사업</th>
                            <th scope="col" className="tbl-hide">배정기간</th>
                            <th scope="col">상태</th>
                            <th scope="col">총배정횟수</th>
                            <th scope="col" className="tbl-hide">사용횟수</th>
                            <th scope="col">잔여횟수</th>
                        </tr>
                    </thead>
                        <tbody>{classList}</tbody>
                    </table>
                    <div style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                        {paging}
                    </div>
                </div>
      );
    }
});


