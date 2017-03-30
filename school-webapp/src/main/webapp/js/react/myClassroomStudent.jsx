var MyClassList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'recordPerPage':10,'currentPageNo':1};
    },
    componentDidMount: function() {
        this.getList();
    },
    goPage:function(pageNo) {
      this.getList({'currentPageNo': pageNo});
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);
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
                this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':totalCnt,'currentPageNo':Number(_param.currentPageNo),'recordCountPerPage':Number(_param.recordCountPerPage)});

            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            var classes = classData.reqMbrNm.split(",");
            tooltip = [];
            if(classes.length > 1) {
                classData.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
                for(var i=0;i<=classes.length;i++){
                    tooltip.push(<li>{classes[i]}</li>);
                }
            } else {
                classData.reqMbrNmText = classes[0];
            }
            return (
                    <tr>
                        <td className="first-date">{new Date(classData.reqDtm).format('yyyy-MM-dd')}</td>
                        <td className="tbl-hide">{classData.clasRoomInfo.schInfo.sidoNm}&nbsp;{classData.clasRoomInfo.schInfo.sgguNm}</td>
                        <td className="tbl-class-td">
                            <span className="web-tbl-td">{classData.clasRoomInfo.schInfo.schNm}</span>
                            <span className="web-tbl-th m-blind">{classData.clasRoomInfo.clasRoomTypeNm}</span>
                            <span className="web-tbl-td"><span className="web-blind">(</span>{classData.clasRoomInfo.clasRoomNm}<span className="web-blind">)</span></span>
                        </td>
                        <td className="tbl-hide tooltip">
                            {classData.reqMbrNmText}
                            <div className="tooltip-box" style={{display:(tooltip=='')?'none':''}}>
                                <ul>
                                    {tooltip}
                                </ul>
                            </div>
                        </td>
                        <td>{classData.delYn == 'Y' ? '교실삭제' : classData.regStatNm}</td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="3" className="empty">등록 된 교실이 없습니다.</td>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        return (
        <div>
            <table>
                <caption>대전둔원고등학교 학생 테이블정보 - 신청일, 지역, 학교, 반명, 교사명, 현황</caption>
                <colgroup>
                    <col style={{width:'13%'}} />
                    <col style={{width:'14%'}} />
                    <col />
                    <col style={{width:'14%'}} />
                    <col style={{width:'9%'}} />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col" className="first-date">신청일</th>
                        <th scope="col" className="tbl-hide">지역</th>
                        <th scope="col">
                            <span className="web-tbl-th">학교</span>
                            <span className="web-tbl-th m-blind"><span className="">유형</span></span>
                            <span className="web-tbl-th"><span className="web-blind">(</span>교실명<span className="web-blind">)</span></span>
                        </th>
                        <th scope="col" className="tbl-hide">교실 담당자</th>
                        <th scope="col">현황</th>
                    </tr>
                </thead>
                <tbody>{classList}</tbody>
            </table>
            <div className="btn-paging">
                <PageNavi
                            url={this.props.url}
                            pageFunc={this.goPage}
                            totalRecordCount={this.state.totalRecordCount}
                            currentPageNo={this.state.currentPageNo}
                            recordCountPerPage={this.state.recordPerPage}
                            contextPath={this.props.contextPath} />
            </div>
        </div>
      );
    }
});

var ClassList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    <tr>
                        <td>{classData.schInfo.sidoNm}&nbsp;{classData.schInfo.sgguNm}</td>
                        <td>{classData.schInfo.schNm}</td>
                        <td>{classData.clasRoomNm}</td>
                        <td>{classData.tchrMbrNm}</td>
                        <td className="none-line"><button type="button" className="btn-type3 popup" name="등록" onClick={registClassroom.bind(this,classData)} >등록</button></td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="5" className="empty">교실 찾기 버튼을 클릭 후 나의 교실을 신청해주세요.</td>
                    </tr>
            );
        }

        return (
            <div>
                <p className="search-result">검색 결과<strong>총<em>{this.state.totalRecordCount}</em>건</strong></p>
                <table>
                    <caption>나의 교실 등록 검색결과 - 겸색결과와 지역,학교,반명,교사명,선택</caption>
                    <colgroup>
                        <col style={{width:"20%"}} />
                        <col />
                        <col style={{width:"18%"}} />
                        <col style={{width:"20%"}} />
                        <col style={{width:"12%"}} />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">지역</th>
                            <th scope="col">학교</th>
                            <th scope="col">반 명</th>
                            <th scope="col">교사 명</th>
                            <th scope="col" className="none-line">선택</th>
                        </tr>
                    </thead>
                    <tbody>
                        {classList}
                    </tbody>
                </table>
                <p><em>!</em>나의 반을 찾지 못했을 경우 진로상담 선생님께 확인하세요.</p>
            </div>
      );
    }
});


var MyClassInfoList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'recordPerPage':10,'currentPageNo':1, 'regStatCd':this.props.regStatCd};
    },
    componentDidMount: function() {
        this.getList();
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10, 'regStatCd':this.props.regStatCd, 'clasRoomCualfCd':$("#clasRoomCualfCd").val()},param);
        if(_param.isMore != true){
            this.setState({'data': [],'totalRecordCount':0,'currentPageNo':1});
        }
        if($("#clasRoomCualfCd").val() == "101691"){
            $("#lessonTab02").show();
            $(".tab-type1").addClass("tab03");
            $(".tab-type1").removeClass("tab02");
        }else{
            $(".tab-type1").removeClass("tab03");
            $(".tab-type1").addClass("tab02");
            $("#lessonTab02").hide();
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
                this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':totalCnt,'currentPageNo':Number(_param.currentPageNo),'recordCountPerPage':Number(_param.recordCountPerPage)});

            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            tooltip = [];
            var classes = classData.reqMbrNm.split(",");
            if(classes.length > 1) {
                classData.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
                 for(var i=0;i<=classes.length;i++){
                    tooltip.push(<li>{classes[i]}</li>);
                }
            } else {
                classData.reqMbrNmText = classes[0];
            }
            //classData.reqMbrNm = replaceAll(classData.reqMbrNm, ",", "");
            return (
                    <tr>
                        <td className="first-date">{new Date(classData.reqDtm).format('yyyy-MM-dd')}</td>
                        <td className="tbl-hide">{classData.clasRoomInfo.schInfo.sidoNm}&nbsp;{classData.clasRoomInfo.schInfo.sgguNm}</td>
                        <td className="tbl-class-td">
                            <span className="web-tbl-td">{classData.clasRoomInfo.schInfo.schNm}</span>
                            <span className="web-tbl-th m-blind">{classData.clasRoomInfo.clasRoomTypeNm}</span>
                            <span className="web-tbl-td"><span className="web-blind">(</span>{classData.clasRoomInfo.clasRoomNm}<span className="web-blind">)</span></span>
                        </td>

                        <td className="tbl-hide tooltip">
                            {classData.reqMbrNmText}
                            <div className="tooltip-box" style={{display:(tooltip=='')?'none':''}}>
                                <ul>
                                    {tooltip}
                                </ul>
                            </div>
                        </td>
                        <td className="tbl-hide ta-l">
                            {classData.clasRoomInfo.rpsYn != 'Y' && classData.regStatCd == '101526'  && classData.cualfCnt == '0' ? <a href="javascript:void(0)" className="btn-type6" onClick={setRpsClas.bind(this,classData)}>대표교실</a>: ''}
                            {classData.clasRoomInfo.rpsYn == 'Y' ? <a href="javascript:void(0)" className="btn-type6 pink" onClick={setRpsClas.bind(this,classData)}>대표교실</a> : ''}
                            <a href="javascript:void(0)" className="btn-delete"  onClick={delRpsClas.bind(this,classData)} >삭제</a>
                        </td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="3" className="empty">교실 신청 관리에서 나의 교실을 등록해 주세요.</td>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        return (
        <div>
            <table className="no-title">
                <caption>나의 교실 정보 테이블정보 - 신청일, 지역, 학교, 유형, 교실명, 담당자, 관리</caption>
                <colgroup>
                    <col style={{width:"13%"}}/>
                    <col style={{width:"14%"}}/>
                    <col/>
                    <col style={{width:"14%"}}/>
                    <col style={{width:"14%"}}/>
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col" className="first-date">신청일</th>
                        <th scope="col" className="tbl-hide">지역</th>
                        <th scope="col">
                            <span className="web-tbl-th">학교</span>
                            <span className="web-tbl-th m-blind"><span className="">유형</span></span>
                            <span className="web-tbl-th"><span className="web-blind">(</span>교실명<span className="web-blind">)</span></span>
                        </th>
                        <th scope="col">담당자</th>
                        <th scope="col" className="tbl-hide">관리</th>
                    </tr>
                </thead>
                <tbody>{classList}</tbody>
            </table>
            <div className="btn-paging">
                <PageNavi
                            url={this.props.url}
                            pageFunc={this.goPage}
                            totalRecordCount={this.state.totalRecordCount}
                            currentPageNo={this.state.currentPageNo}
                            recordCountPerPage={this.state.recordPerPage}
                            contextPath={this.props.contextPath} />
            </div>
        </div>
      );
    }
});



var MyManagementClassList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordPerPage':10, 'clasRoomCualfCd':'101691'};
    },
    goPage:function(pageNo) {
      this.getList({'currentPageNo': pageNo});
    },
    componentDidMount: function() {
        this.getList();
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10, 'clasRoomCualfCd':'101691'},param);
        if(mentor.isMobile){
            if(_param.isMore != true){
                _param.currentPageNo = 1;
                this.setState({'data': [],'totalRecordCount':0,'currentPageNo':_param.currentPageNo});
            }
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
                    totalCnt = rtnData[0].totalRecordCount
                }

                if(totalCnt > 0){
                    $("#lessonTab02").show();
                    $(".tab-type1").addClass("tab03");
                    $(".tab-type1").removeClass("tab02");
                    load = "N";
                }else{
                    if(load != "Y"){
                        $(".tab-type1").removeClass("tab03");
                        $(".tab-type1").addClass("tab02");
                        $("#lessonTab02").hide();
                        $("#clasRoomCualfCd").val("101690");
                        $("#tab2").removeClass("active");
                        $("#tab3").addClass("active");
                    }else{
                        load = "N";
                    }

                }
                if(mentor.isMobile){
                    this.setState({data: this.state.data.concat(rtnData),'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo});
                }else{
                    this.setState({data: rtnData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage});
                }
            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },

    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    <tr>
                        <td className="tbl-hide">{new Date(classData.regDtm).format('yyyy-MM-dd')}</td>
                        <td className="tbl-hide">{classData.schInfo.sidoNm}</td>
                        <td className="tbl-class-td">
                            <span className="web-tbl-td">{classData.schInfo.schNm}</span>
                            <span className="web-tbl-th m-blind">{classData.clasRoomTypeNm}</span>
                            <span className="web-tbl-td"><span className="web-blind">(</span><a href={"classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm}>{classData.clasRoomNm}</a><span className="web-blind">)</span></span>
                        </td>
                        <td><a href="javascript:void(0)" className={classData.applyCnt > 0 ? "underpink":"underline"} onClick={openApprovePopup.bind(this,classData.clasRoomSer,classData.applyCnt)}>{classData.applyCnt}</a></td>
                        <td><a className="underline" href={"classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm+"&mbrClassCd=100858"}>{classData.registCnt}</a></td>
                        <td className="tbl-hide ta-l">
                            {classData.rpsYn != 'Y' && classData.regStatCd == '101526' ? <a href="javascript:void(0)" className="btn-type6" onClick={setRpsClas2.bind(this,classData)}>대표교실</a> : ''}
                            {classData.rpsYn == 'Y'  ? <a href="javascript:void(0)" className="btn-type6 pink" onClick={setRpsClas2.bind(this,classData)}>대표교실</a> :   ''}
                            <a href="javascript:void(0)" className="btn-delete" onClick={delRpsClas2.bind(this,classData)} >삭제</a>
                        </td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="4" className="empty">등록 된 교실이 없습니다.</td>
                        <td className="tbl-hide"></td>
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        var paging = [];
        if(mentor.isMobile){
            paging.push(
                <div className="btn-more-view" style={{display:(this.state.totalRecordCount-this.state.data.length<=0)?'none':''}}>
                    <a href="javascript:void(0);" onClick={this.getList.bind(this,{'isMore':true,'currentPageNo':this.state.currentPageNo+1})}>더 보기 (<span>{this.state.totalRecordCount-this.state.data.length}</span>)</a>
                </div>
            );
        }else{
            paging.push(
                  <div className="btn-paging">
                      <PageNavi url={this.props.url} pageFunc={this.goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
                  </div>
            );
        }

        return (
        <div>
            <table className="no-title">
                <caption>대전둔원고등학교 교사 테이블정보 - 신청일, 지역, 학교, 반명, 등록 신청중, 학생현황</caption>
                <colgroup>
                    <col style={{width:'13%'}} />
                    <col style={{width:'14%'}} />
                    <col/>
                    <col style={{width:'10%'}} />
                    <col style={{width:'10%'}} />
                    <col style={{width:'14%'}} />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col" className="tbl-hide">신청일</th>
                        <th scope="col" className="tbl-hide">지역</th>
                        <th scope="col">
                            <span className="web-tbl-th">학교</span>
                            <span className="web-tbl-th m-blind"><span className="">유형</span></span>
                            <span className="web-tbl-th"><span className="web-blind">(</span>교실명<span className="web-blind">)</span></span>
                        </th>
                        <th scope="col">등록신청중</th>
                        <th scope="col">학생현황</th>
                        <th scope="col" className="tbl-hide">관리</th>
                    </tr>
                </thead>
                <tbody>
                    {classList}
                </tbody>
            </table>
            {paging}
        </div>
      );
    }
});



var StudentApproveList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    <tr>
                        <td>
                            <label className="chk-skin">
                                <input type="checkbox" className="check-style" name={"listClasRoomRegReqHist["+index+"].reqSer"} value={classData.reqSer}/>
                            </label>
                        </td>
                        <td><span className="web-tbl-td">{classData.clasRoomInfo.schInfo.schNm}</span><span className="web-tbl-td"><span className="web-blind">(</span>({classData.clasRoomInfo.clasRoomNm})<span className="web-blind">)</span></span></td>
                        <td>{classData.reqMbrNm}</td>
                        <td className="none-line choice-btn">
                            <span><button type="button" className="btn-type3 popup blue" name="승인" onClick={approveSingle.bind(null,classData.reqSer)}>승인</button></span>
                            <span><button type="button" className="btn-type3 popup" name="반려" onClick={reject.bind(null,classData)}>반려</button></span>
                        </td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="4" className="empty">등록 된 학생이 없습니다.</td>
                    </tr>
            );
        }

        return(
                <table>
                    <caption>학생 승인 요청 현황 - 전체선택,학교반명,교사명,선택</caption>
                    <colgroup>
                        <col className="s-confirm1" />
                        <col />
                        <col className="s-confirm2" />
                        <col className="s-confirm3" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><label className="chk-skin fnt-0">전체선택<input type="checkbox" title="전체선택" name="all-choice" onChange={checkAll.bind($(React.findDOMNode(this.refs.chkAll)))} ref="chkAll"/></label></th>
                            <th scope="col"><span className="web-tbl-th">학교</span><span className="web-tbl-th"><span className="web-blind">(</span>반명<span className="web-blind">)</span></span></th>
                            <th scope="col">학생 명</th>
                            <th scope="col" className="none-line">선택</th>
                        </tr>
                    </thead>
                    <tbody>
                        {classList}
                    </tbody>
                </table>
        );
    }
});

var ClassList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    render:function(){
        var classList = null;

        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            var classes = classData.reqMbrNm.split(",");
            if(classes.length > 1) {
                classData.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
            } else {
                classData.reqMbrNmText = classes[0];
            }
            return (
                    <tr>
                        <td>{classData.schInfo.sidoNm}&nbsp;{classData.schInfo.sgguNm}</td>
                        <td>{classData.schInfo.schNm}</td>
                        <td>{classData.clasRoomNm}</td>
                        <td>{classData.reqMbrNmText}</td>
                        <td className="none-line"><button type="button" className="btn-type3 popup" name="신청" onClick={registClassroom.bind(this,classData)} >{(classData.isRegistedRoom == "Y")?"완료":"신청"}</button></td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="5" className="empty">등록 된 학교가 없습니다.</td>
                    </tr>
            );
        }

        return (
            <div>
                <p className="search-result">검색 결과<strong>총<em>{this.state.totalRecordCount}</em>건</strong></p>
                <table>
                    <caption>나의 교실 등록 검색결과 - 겸색결과와 지역,학교,반명,교사명,선택</caption>
                    <colgroup>
                        <col style={{width:"20%"}} />
                        <col />
                        <col style={{width:"18%"}} />
                        <col style={{width:"20%"}} />
                        <col style={{width:"12%"}} />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">지역</th>
                            <th scope="col">학교</th>
                            <th scope="col">반 명</th>
                            <th scope="col">교사 명</th>
                            <th scope="col" className="none-line">선택</th>
                        </tr>
                    </thead>
                    <tbody>
                        {classList}
                    </tbody>
                </table>
            </div>
      );
    }
});

var StudentClassMemberList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    <tr>
                        <td><span className="web-tbl-td">{classData.clasRoomInfo.schInfo.schNm}</span><span className="web-tbl-td"><span className="web-blind">(</span>({classData.clasRoomInfo.clasRoomNm})<span className="web-blind">)</span></span></td>
                        <td>{classData.reqMbrNm}</td>
                 {/*    <td className="none-line">
                            <button type="button" className="btn-type3 popup" name="반려" onClick={reject.bind(null,classData)}>반려</button>
                        </td> */}
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="2" className="empty">등록 된 학생이 없습니다.</td>
                    </tr>
            );
        }

        return(
                <table>
                    <caption>학생 승인 요청 현황 - 전체선택,학교반명,교사명,선택</caption>
                    <colgroup>
                        <col />
                        <col className="s-confirm2" />
                     {/*   <col className="s-confirm3" /> */}
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><span className="web-tbl-th">학교</span><span className="web-tbl-th"><span className="web-blind">(</span>반명<span className="web-blind">)</span></span></th>
                            <th scope="col">학생 명</th>
                       {/*     <th scope="col" className="none-line">선택</th> */}
                        </tr>
                    </thead>
                    <tbody>
                        {classList}
                    </tbody>
                </table>
        );
    }
});