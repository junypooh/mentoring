var MyClassList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
        this.getList();
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
    if ( typeof param == "undefined" ){
        param = [];
        param.schNo = $("#selSch1").val();
    }
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);


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
                    //totalCnt = rtnData.length;
                }
                $("#totalCnt2").text(rtnData.length);

                this.setState({data: rtnData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage});

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
                            <span className="web-tbl-td"><a href="javascript:void(0)" onClick={goMySchool.bind(this,classData.schNo)}>{classData.schInfo.schNm}</a></span>
                            <span className="web-tbl-th m-blind">{classData.clasRoomTypeNm}</span>
                            <span className="web-tbl-td"><span className="web-blind">(</span><a href={"classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm}>{classData.clasRoomNm}</a><span className="web-blind">)</span></span>
                        </td>
                        <td><a href="javascript:void(0)" className={classData.applyCnt > 0 ? "underpink":"underline"}  onClick={openApprovePopup.bind(this,classData.clasRoomSer,classData.applyCnt)}>{classData.applyCnt}</a></td>
                        <td><a className="underline" href={"classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm}>{classData.registCnt}</a></td>
                        <td className="tbl-hide ta-l ta-center">
                               <a href="javascript:void(0)" className="btn-delete" onClick={removeClassRoom.bind(this,classData.clasRoomSer,classData.applyCnt,classData.registCnt)} >삭제</a>
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
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        var paging = [];

        paging.push(
              <div className="btn-paging">
                  <PageNavi url={this.props.url} pageFunc={goPage2} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
              </div>
        );


        return (
        <div>
            <table className="no-title">
                <caption>대전둔원고등학교 교사 테이블정보 - 신청일, 지역, 학교, 반명, 등록 신청중, 학생현황</caption>
                <colgroup>
                    <col style={{width:'13%'}} />
                    <col style={{width:'14%'}} />
                    <col />
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
            if(classData.tchrMbrNm != null){
                var classes = classData.tchrMbrNm.split(",");
                if(classes.length > 1) {
                    classData.tchrMbrNm = classes[0] + " > 외" + (classes.length-1);
                } else {
                    classData.tchrMbrNm = classes[0];
                }
            }
            return (
                    <tr>
                        <td>{classData.schInfo.sidoNm}&nbsp;{classData.schInfo.sgguNm}</td>
                        <td>{classData.schInfo.schNm}</td>
                        <td>{classData.schInfo.clasRoomTypeNm}</td>
                        <td>{classData.clasRoomNm}</td>
                        <td>{classData.tchrMbrNm}</td>
                        <td className="none-line"><button type="button" className="btn-type3 popup" name="신청" onClick={registClassroom.bind(this,classData)} >{(classData.isRegistedRoom == "Y")?"완료":"신청"}</button></td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="6" className="empty">등록 된 학교가 없습니다.</td>
                    </tr>
            );
        }

        return (
            <div>
                <p className="search-result">검색 결과<strong>총<em>{this.state.totalRecordCount}</em>건</strong></p>
                <table>
                    <caption>나의 교실 등록 검색결과 - 겸색결과와 지역,학교,반명,교사명,선택</caption>
                    <colgroup>
                        <col style={{width:"17%"}} />
                        <col />
                        <col style={{width:"10%"}} />
                        <col style={{width:"15%"}} />
                        <col style={{width:"15%"}} />
                        <col style={{width:"12%"}} />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">지역</th>
                            <th scope="col">학교</th>
                            <th scope="col">유형</th>
                            <th scope="col">교실명</th>
                            <th scope="col">교실 담당자</th>
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
                <table >
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
                            <th scope="col"><span className="web-tbl-th">학교</span><span className="web-tbl-th"><span className="web-blind">(</span>교실명<span className="web-blind">)</span></span></th>
                            <th scope="col">학생</th>
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
var MemberList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
        this.getList({'clasRoomSer':this.props.clasRoomSer,'regStatCd':'101526'});
    },
    goPage:function(pageNo) {
        var param = {currentPageNo : pageNo};
        this.getList(param);
    },
    getList: function(param) {

        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);

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

                this.setState({data: rtnData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage});

            }.bind(this),
            error: function(xhr, status, err) {
                console.error(this.props.url, status, err.toString());
            }.bind(this)
        });
    },
    render:function(){
        var members;
        var url = "/myPage/myRecognition/myRecognition.do?tabOpen=2";
        if(this.state.data != null && this.state.data.length > 0){
            members = this.state.data.map(function(mbr, index) {
                var status = [];
                if(mbr.regStatCd == "101525"){
                    status.push(<td>
                    <button type="button" className="btn-type3 popup blue" name="승인" onClick={approveSingle.bind(null,mbr.reqSer)}>승인</button>
                    <button type="button" className="btn-type3 popup" name="반려" onClick={reject.bind(null,mbr)}>반려</button>
                    </td>);
                }else{
                    status.push(<td>{mbr.regStatNm}</td>);
                }

                var rpsClassUser = [];
                if(mbr.clasRoomCualfCd == "101691"){
                    rpsClassUser.push(
                        <td>
                        <a href="#" className="btn-type6 pink" name="반대표 취소" onClick={setClasRps.bind(null,mbr)}>반대표 취소</a>

                        <a href="#" className="btn-delete" name="삭제" onClick={delRpsClas.bind(null,mbr)}>삭제</a>

                        </td>
                    );
                }else{
                    rpsClassUser.push(
                        <td>
                        <a href="#" className="btn-type6" name="반대표 등록" onClick={setClasRps.bind(null,mbr)}>반대표 등록</a>
                            <a href="#" className="btn-delete" name="삭제" onClick={delRpsClas.bind(null,mbr)}>삭제</a>
                        </td>
                    );
                }
                return (
                  <tr>
                      <td>{mbr.rn}</td>
                      <td>{(new Date(mbr.reqDtm)).format("yyyy.MM.dd")}</td>
                      <td>{mbr.reqMbrNm}</td>
                      <td>{mbr.username}</td>
                      {rpsClassUser}
                  </tr>
                );
            });


        }else{
            members = [];
            members.push(<td colSpan="5">등록 내역이 없습니다.</td>);
        }

        var paging = [];

        paging.push(
              <div className="btn-paging">
                  <PageNavi url={this.props.url} pageFunc={this.goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
              </div>
        );

        return (
            <div className="board-list-type">
                <div className="board-list-title">
                    <h3>{this.props.myClass}</h3>
                    <div>
                        <strong>학생현황 <em>{this.state.totalRecordCount}</em>명</strong>
                    </div>
                </div>
                <table>
                    <caption>{this.props.myClass} 테이블정보 - 번호, 신청일, 학생명, 현황</caption>
                    <colgroup>
                        <col style={{width:'10%'}} />
                        <col style={{width:'24%'}} />
                        <col style={{width:'20%'}} />
                        <col style={{width:'20%'}} />
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">신청일</th>
                            <th scope="col">학생명</th>
                            <th scope="col">아이디</th>
                            <th scope="col">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        {members}
                    </tbody>
                </table>
                <ul className="btn-right">
                   <li><a href={mentor.contextpath + url} className="btn-type1 list">목록</a></li>
               </ul>
               {paging}
            </div>
      );
    }
});


var MyClassRecognizeList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
        this.getList();
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
    if ( typeof param == "undefined" ){
        param = [];
        param.schNo = $("#selSch1").val();
    }
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);


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
                $("#totalCnt1").text(totalCnt);

                this.setState({data: rtnData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage});

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
                        <td className="tbl-hide first-date">{new Date(classData.regDtm).format('yyyy-MM-dd')}</td>
                        <td>
                            <span className="web-tbl-th">{classData.schInfo.clasRoomTypeNm}</span>
                            <span className="web-tbl-th"><span className="web-blind">(</span>{classData.clasRoomNm}<span className="web-blind">)</span></span>
                        </td>
                        <td>{classData.reqMbrNm}</td>
                        <td className="tbl-hide">
                            {classData.regStatCd == 101526 ? <a href="#" className="underline-link" onClick={approvePop.bind(null,classData)}>승인</a>:''}
                            {classData.regStatCd == 101527 ? <a href="#" className="underline-link" onClick={approvePop.bind(null,classData)}>반려</a>:''}
                            {classData.regStatCd == '101525' ?  <a href="#" className="btn-type6 green" onClick={approveRoomSingle.bind(null,classData)}>승인</a> : ''}
                            {classData.regStatCd == '101525' ?  <a href="#" className="btn-type6 orange" style={{margin:'3px'}} onClick={rejectRoomPop.bind(null,classData)}>반려</a> : ''}
                        </td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                    <tr>
                        <td colSpan="3" className="empty">승인 요청된 교실정보가 없습니다.</td>
                        <td className="tbl-hide"></td>
                    </tr>
            );
        }

        var paging = [];

        paging.push(
              <div className="btn-paging">
                  <PageNavi url={this.props.url} pageFunc={goPage} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
              </div>
        );


        return (
        <div>
            <table>
                <caption>대전둔원고등학교 교사 테이블정보 - 신청일, 지역, 학교, 반명, 등록 신청중, 학생현황</caption>
                <colgroup>
                    <col style={{width:'16%'}} />
                    <col />
                    <col style={{width:'16%'}} />
                    <col style={{width:'16%'}} />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col" className="tbl-hide first-date">신청일</th>
                        <th scope="col">
                            <span className="web-tbl-th">유형</span>
                            <span className="web-tbl-th"><span className="web-blind">(</span>교실명<span className="web-blind">)</span></span>
                        </th>
                        <th scope="col">신청교사</th>
                        <th scope="col" className="tbl-hide">승인관리</th>
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



var MyTchrClassList = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
        this.getList();
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
        if ( typeof param == "undefined" ){
            param = [];
            param.schNo = $("#selSch1").val();

        }
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);


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
                $("#totalCnt3").text(totalCnt);

                this.setState({data: rtnData,'totalRecordCount':totalCnt,'currentPageNo':_param.currentPageNo,'recordCountPerPage':_param.recordCountPerPage});

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
                        <td className="first-date">{classData.regDtm}</td>
                        <td>대표교사</td>
                        <td>{classData.username}</td>
                        <td>{classData.regMbrNm}</td>
                        <td className="tbl-hide">
                            <a href="#" className="btn-type6 del"  onClick={tchrRpsDel.bind(null,classData.schMbrRollSer)}>권한삭제</a>
                        </td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                <tr>
                    <td colSpan="4" className="empty">등록된 교실이 없습니다.</td>
                    <td className="tbl-hide"></td>
                </tr>
            );
        }

        var paging = [];

        paging.push(
              <div className="btn-paging">
                  <PageNavi url={this.props.url} pageFunc={goPage3} totalRecordCount={this.state.totalRecordCount} currentPageNo={this.state.currentPageNo} recordCountPerPage={this.state.recordCountPerPage} contextPath={mentor.contextpath} />
              </div>
        );


        return (
        <div>
            <table className="no-title">
                <caption>대전둔원고등학교 교사 테이블정보 - 신청일, 지역, 학교, 반명, 등록 신청중, 학생현황</caption>
                <colgroup>
                    <col />
                    <col />
                    <col />
                    <col />
                    <col style={{width:'30%'}} />
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col" className="first-date">등록일</th>
                        <th scope="col">구분</th>
                        <th scope="col">교사</th>
                        <th scope="col">등록자</th>
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


var tchrInfo = React.createClass({
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    <tr>
                        <td>{index+1}</td>
                        <td>{classData.username}</td>
                        <td>{classData.userId}</td>
                        <td>{classData.genNm}</td>
                        <td className="none-line"><button type="button" className="btn-type3 popup" name="선택" onClick={goMyTchr.bind(this,classData.mbrNo)}>선택</button></td>
                    </tr>
                  );
                });
        }else{
            classList =[];
            classList.push(
                <tr><td colSpan="5" class="none-line" style={{width:'99%;'}}>검색된 결과가 없습니다.</td></tr>
            );
        }



        return(
                <table >
                    <caption>학생 승인 요청 현황 - 전체선택,학교반명,교사명,선택</caption>
                    <colgroup>
                        <col style={{width:'10%'}} />
                        <col style={{width:'20%'}} />
                        <col />
                        <col style={{width:'20%'}} />
                        <col style={{width:'20%'}} />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">번호</th>
                            <th scope="col">교사명</th>
                            <th scope="col">아이디</th>
                            <th scope="col">성별</th>
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

