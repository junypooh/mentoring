var MyClassList = React.createClass({displayName: "MyClassList",
    getInitialState: function(param) {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10, 'regStatCd':this.props.regStatCd};
    },
    componentDidMount: function() {
        this.getList();
    },
    componentDidUpdate: function(){
        updatePosition();
    },
    getList: function(param) {
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10, 'regStatCd':this.props.regStatCd},param);
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
                    React.createElement("tr", null, 
                        React.createElement("td", {className: "tbl-hide"}, new Date(classData.regDtm).format('yyyy-MM-dd')), 
                        React.createElement("td", {className: "tbl-hide"}, classData.schInfo.sidoNm), 
                        React.createElement("td", {className: "tbl-class-td"}, 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("a", {href: "javascript:void(0)", onClick: goMySchool.bind(this,classData.schNo)}, classData.schInfo.schNm)), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, classData.clasRoomTypeNm), 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), React.createElement("a", {href: "#"}, classData.clasRoomNm), React.createElement("span", {className: "web-blind"}, ")"))
                        ), 
                        React.createElement("td", null, React.createElement("a", {href: "javascript:void(0)", className: classData.applyCnt > 0 ? "underpink":"underline", onClick: openApprovePopup.bind(this,classData.clasRoomSer,classData.applyCnt)}, classData.applyCnt)), 
                        React.createElement("td", null, React.createElement("a", {className: "underline", href: "classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm + "&clasRoomNm="+classData.clasRoomNm}, classData.registCnt)), 
                        React.createElement("td", {className: "tbl-hide ta-l"}, 
                            classData.rpsYn != 'Y' ? React.createElement("a", {href: "javascript:void(0)", className: "btn-type6", onClick: setRpsClassroom.bind(this, classData.rpsYn, classData.reqSer)}, "대표교실") : '', 
                            classData.rpsYn == 'Y' ? React.createElement("a", {href: "javascript:void(0)", className: "btn-type6 pink", onClick: setRpsClassroom.bind(this, classData.rpsYn, classData.reqSer)}, "대표교실") :   '', 
                            React.createElement("a", {href: "javascript:void(0)", className: "btn-delete", onClick: removeClassRoom.bind(this,classData)}, "삭제")
                        )
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "3", className: "empty"}, "교실 신청 관리에서 나의 교실을 등록해 주세요."), 
                        React.createElement("td", {className: "tbl-hide"}), 
                        React.createElement("td", {className: "tbl-hide"}), 
                        React.createElement("td", {className: "tbl-hide"})
                    )
            );
        }

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
            React.createElement("table", {className: "no-title"}, 
                React.createElement("caption", null, "대전둔원고등학교 교사 테이블정보 - 신청일, 지역, 학교, 반명, 등록 신청중, 학생현황"), 
                React.createElement("colgroup", null, 
                    React.createElement("col", {style: {width:'13%'}}), 
                    React.createElement("col", {style: {width:'14%'}}), 
                    React.createElement("col", null), 
                    React.createElement("col", {style: {width:'10%'}}), 
                    React.createElement("col", {style: {width:'10%'}}), 
                    React.createElement("col", {style: {width:'14%'}})
                ), 
                React.createElement("thead", null, 
                    React.createElement("tr", null, 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "신청일"), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "지역"), 
                        React.createElement("th", {scope: "col"}, 
                            React.createElement("span", {className: "web-tbl-th"}, "학교"), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, React.createElement("span", {className: ""}, "유형")), 
                            React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), "교실명", React.createElement("span", {className: "web-blind"}, ")"))
                        ), 
                        React.createElement("th", {scope: "col"}, "등록신청중"), 
                        React.createElement("th", {scope: "col"}, "학생현황"), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "관리")
                    )
                ), 
                React.createElement("tbody", null, 
                    classList
                )
            ), 
            paging
        )
      );
    }
});

var ClassList = React.createClass({displayName: "ClassList",
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
                    React.createElement("tr", null, 
                        React.createElement("td", null, classData.schInfo.sidoNm, " ", classData.schInfo.sgguNm), 
                        React.createElement("td", null, classData.schInfo.schNm), 
                        React.createElement("td", null, classData.schInfo.clasRoomTypeNm), 
                        React.createElement("td", null, classData.clasRoomNm), 
                        React.createElement("td", null, classData.tchrMbrNm), 
                        React.createElement("td", {className: "none-line"}, React.createElement("button", {type: "button", className: (classData.isRegistedRoom == "Y")?"btn-type3 popup":"btn-type3 popup blue", name: "신청", onClick: registClassroom.bind(this,classData)}, (classData.isRegistedRoom == "Y")?"완료":"신청"))
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "6", className: "empty"}, "등록 된 학교가 없습니다.")
                    )
            );
        }

        return (
            React.createElement("div", null, 
                React.createElement("p", {className: "search-result"}, "검색 결과", React.createElement("strong", null, "총", React.createElement("em", null, this.state.totalRecordCount), "건")), 
                React.createElement("table", null, 
                    React.createElement("caption", null, "나의 교실 등록 검색결과 - 겸색결과와 지역,학교,반명,교사명,선택"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", {style: {width:"17%"}}), 
                        React.createElement("col", null), 
                        React.createElement("col", {style: {width:"10%"}}), 
                        React.createElement("col", {style: {width:"15%"}}), 
                        React.createElement("col", {style: {width:"15%"}}), 
                        React.createElement("col", {style: {width:"12%"}})
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, "지역"), 
                            React.createElement("th", {scope: "col"}, "학교"), 
                            React.createElement("th", {scope: "col"}, "유형"), 
                            React.createElement("th", {scope: "col"}, "교실명"), 
                            React.createElement("th", {scope: "col"}, "교실 담당자"), 
                            React.createElement("th", {scope: "col", className: "none-line"}, "선택")
                        )
                    ), 
                    React.createElement("tbody", null, 
                        classList
                    )
                )
            )
      );
    }
});

var StudentApproveList = React.createClass({displayName: "StudentApproveList",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    React.createElement("tr", null, 
                        React.createElement("td", null, 
                            React.createElement("label", {className: "chk-skin"}, 
                                React.createElement("input", {type: "checkbox", className: "check-style", name: "listClasRoomRegReqHist["+index+"].reqSer", value: classData.reqSer})
                            )
                        ), 
                        React.createElement("td", null, React.createElement("span", {className: "web-tbl-td"}, classData.clasRoomInfo.schInfo.schNm), React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), "(", classData.clasRoomInfo.clasRoomNm, ")", React.createElement("span", {className: "web-blind"}, ")"))), 
                        React.createElement("td", null, classData.reqMbrNm), 
                        React.createElement("td", {className: "none-line choice-btn"}, 
                            React.createElement("span", null, React.createElement("button", {type: "button", className: "btn-type3 popup blue", name: "승인", onClick: approveSingle.bind(null,classData.reqSer)}, "승인")), 
                            React.createElement("span", null, React.createElement("button", {type: "button", className: "btn-type3 popup", name: "반려", onClick: reject.bind(null,classData)}, "반려"))
                        )
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "4", className: "empty"}, "등록 된 학생이 없습니다.")
                    )
            );
        }

        return(
                React.createElement("table", null, 
                    React.createElement("caption", null, "학생 승인 요청 현황 - 전체선택,학교반명,교사명,선택"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", {className: "s-confirm1"}), 
                        React.createElement("col", null), 
                        React.createElement("col", {className: "s-confirm2"}), 
                        React.createElement("col", {className: "s-confirm3"})
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, React.createElement("label", {className: "chk-skin fnt-0"}, "전체선택", React.createElement("input", {type: "checkbox", title: "전체선택", name: "all-choice", onChange: checkAll.bind($(React.findDOMNode(this.refs.chkAll))), ref: "chkAll"}))), 
                            React.createElement("th", {scope: "col"}, React.createElement("span", {className: "web-tbl-th"}, "학교"), React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), React.createElement("span", {className: "web-blind"}, "교실명"), React.createElement("span", {className: "web-blind"}, ")"))), 
                            React.createElement("th", {scope: "col"}, "학생"), 
                            React.createElement("th", {scope: "col", className: "none-line"}, "선택")
                        )
                    ), 
                    React.createElement("tbody", null, 
                        classList
                    )
                )
        );
    }
});
var StudentClassMemberList = React.createClass({displayName: "StudentClassMemberList",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0};
    },
    render:function(){
        var classList = null;
        if(this.state.data != null && this.state.data.length > 0){
            classList = this.state.data.map(function(classData, index) {
            return (
                    React.createElement("tr", null, 
                        React.createElement("td", null, React.createElement("span", {className: "web-tbl-td"}, classData.clasRoomInfo.schInfo.schNm), React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), "(", classData.clasRoomInfo.clasRoomNm, ")", React.createElement("span", {className: "web-blind"}, ")"))), 
                        React.createElement("td", null, classData.reqMbrNm)
                 /*    <td className="none-line">
                            <button type="button" className="btn-type3 popup" name="반려" onClick={reject.bind(null,classData)}>반려</button>
                        </td> */
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "2", className: "empty"}, "등록 된 학생이 없습니다.")
                    )
            );
        }

        return(
                React.createElement("table", null, 
                    React.createElement("caption", null, "학생 승인 요청 현황 - 전체선택,학교반명,교사명,선택"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", null), 
                        React.createElement("col", {className: "s-confirm2"})
                     /*   <col className="s-confirm3" /> */
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, React.createElement("span", {className: "web-tbl-th"}, "학교"), React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), "반명", React.createElement("span", {className: "web-blind"}, ")"))), 
                            React.createElement("th", {scope: "col"}, "학생 명")
                       /*     <th scope="col" className="none-line">선택</th> */
                        )
                    ), 
                    React.createElement("tbody", null, 
                        classList
                    )
                )
        );
    }
});
var MemberList = React.createClass({displayName: "MemberList",
    getInitialState: function() {
        return {'data': [], 'totalRecordCount':0,'currentPageNo':1, 'recordCountPerPage':10};
    },
    componentDidMount: function() {
        this.getList({'clasRoomSer':this.props.clasRoomSer});
    },
    goPage:function(pageNo) {
        var param = {currentPageNo : pageNo};
        this.getList(param);
    },
    getList: function(param) {

        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10, 'schNm':'Y'},param);
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
        var members;
        var url = "/myPage/myClassroom/myClassroom.do?tabOpen=2";
        if(this.state.data != null && this.state.data.length > 0){
            members = this.state.data.map(function(mbr, index) {
                var status = [];
                if(mbr.regStatCd == "101525"){
                    status.push(React.createElement("td", null, 
                    React.createElement("button", {type: "button", className: "btn-type3 popup blue", name: "승인", onClick: approveSingle.bind(null,mbr.reqSer)}, "승인"), 
                    React.createElement("button", {type: "button", className: "btn-type3 popup", name: "반려", onClick: reject.bind(null,mbr)}, "반려")
                    ));
                }else{
                    status.push(React.createElement("td", null, mbr.regStatNm));
                }

                var rpsClassUser = [];
                var rpsClass = [];
                if(mbr.clasRoomCualfCd == "101691"){
                    if($("#mbrClassCd").val() != "100858"){
                        rpsClassUser.push(React.createElement("a", {href: "#", className: "btn-type6 pink", name: "반대표 취소", onClick: setClasRps.bind(null,mbr)}, "반대표 취소"));
                    }
                    rpsClassUser.push(React.createElement("a", {href: "#", className: "btn-delete", name: "삭제", onClick: delRpsClas.bind(null,mbr)}, "삭제") );
                }else{
                    if($("#mbrClassCd").val() != "100858"){
                        rpsClassUser.push(React.createElement("a", {href: "#", className: "btn-type6", name: "반대표 등록", onClick: setClasRps.bind(null,mbr)}, "반대표 등록"));
                    }
                    rpsClassUser.push(React.createElement("a", {href: "#", className: "btn-delete", name: "삭제", onClick: delRpsClas.bind(null,mbr)}, "삭제"));
                }
                return (
                  React.createElement("tr", null, 
                      React.createElement("td", null, mbr.rn), 
                      React.createElement("td", null, (new Date(mbr.reqDtm)).format("yyyy.MM.dd")), 
                      React.createElement("td", null, mbr.reqMbrNm), 
                      React.createElement("td", null, mbr.username), 
                      React.createElement("td", null, rpsClassUser)
                  )
                );
            });


        }else{
            members = [];
            members.push(React.createElement("td", {colSpan: "5"}, "등록 내역이 없습니다."));
        }

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
                      React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
                  )
            );
        }
        return (
            React.createElement("div", {className: "board-list-type"}, 
                React.createElement("div", {className: "board-list-title"}, 
                    React.createElement("h3", null, this.props.myClass, " ", this.props.clasRoomNm), 
                    React.createElement("div", null, 
                        React.createElement("strong", null, "학생현황 ", React.createElement("em", null, this.state.totalRecordCount), "명")
                    )
                ), 
                React.createElement("table", null, 
                    React.createElement("caption", null, this.props.myClass, " 테이블정보 - 번호, 신청일, 학생명, 현황"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", {style: {width:'10%'}}), 
                        React.createElement("col", {style: {width:'24%'}}), 
                        React.createElement("col", {style: {width:'20%'}}), 
                        React.createElement("col", {style: {width:'20%'}}), 
                        React.createElement("col", null)
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, "번호"), 
                            React.createElement("th", {scope: "col"}, "신청일"), 
                            React.createElement("th", {scope: "col"}, "학생명"), 
                            React.createElement("th", {scope: "col"}, "아이디"), 
                            React.createElement("th", {scope: "col"}, "관리")
                        )
                    ), 
                    React.createElement("tbody", null, 
                        members
                    )
                ), 
                React.createElement("ul", {className: "btn-right"}, 
                   React.createElement("li", null, React.createElement("a", {href: mentor.contextpath + url, className: "btn-type1 list"}, "목록"))
               ), 
               paging
            )
      );
    }
});


var MyClassInfoList = React.createClass({displayName: "MyClassInfoList",
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
        var _param = jQuery.extend({'currentPageNo':this.state.currentPageNo,'recordCountPerPage':10},param);
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
            classData.reqMbrNmText = "";
            tooltip = [];
            if(classData.reqMbrNm != null){
                var classes = classData.reqMbrNm.split(",");

                if(classes.length > 1) {
                    classData.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
                    for(var i=0;i<=classes.length;i++){
                        tooltip.push(React.createElement("li", null, classes[i]));
                    }
                } else {
                    classData.reqMbrNmText = classes[0];
                }
            }



            return (
                    React.createElement("tr", null, 
                        React.createElement("td", {className: "first-date"}, new Date(classData.regDtm).format('yyyy-MM-dd')), 
                        React.createElement("td", {className: "tbl-hide"}, classData.schInfo.sidoNm), 
                        React.createElement("td", {className: "tbl-class-td"}, 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("a", {href: "javascript:void(0)", onClick: goMySchool.bind(this,classData.schNo)}, classData.schInfo.schNm)), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, classData.clasRoomTypeNm), 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), React.createElement("a", {href: "classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm}, classData.clasRoomNm), React.createElement("span", {className: "web-blind"}, ")"))
                        ), 
                        React.createElement("td", {className: "tbl-hide tooltip"}, 
                        classData.reqMbrNmText, 
                        React.createElement("div", {className: "tooltip-box", style: {display:(tooltip=='')?'none':''}}, 
                        React.createElement("ul", null, 
                        tooltip
                        )
                        )
                        ), 
                        React.createElement("td", null, classData.delYn == 'Y' ? '교실삭제' : classData.regStatNm)
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "3", className: "empty"}, "교실 찾기 버튼을 클릭 후 나의 교실을 신청해주세요."), 
                        React.createElement("td", {className: "tbl-hide"}), 
                        React.createElement("td", {className: "tbl-hide"})
                    )
            );
        }

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
                      React.createElement(PageNavi, {url: this.props.url, pageFunc: goPage2, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
                  )
            );
        }

        return (
        React.createElement("div", null, 
            React.createElement("table", null, 
                React.createElement("caption", null, "대전둔원고등학교 교사 테이블정보 - 신청일, 지역, 학교, 반명, 등록 신청중, 학생현황"), 
                React.createElement("colgroup", null, 
                    React.createElement("col", {style: {width:'13%'}}), 
                    React.createElement("col", {style: {width:'14%'}}), 
                    React.createElement("col", null), 
                    React.createElement("col", {style: {width:'14%'}}), 
                    React.createElement("col", {style: {width:'9%'}})
                ), 
                React.createElement("thead", null, 
                    React.createElement("tr", null, 
                        React.createElement("th", {scope: "col", className: "first-date"}, "신청일"), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "지역"), 
                        React.createElement("th", {scope: "col"}, 
                            React.createElement("span", {className: "web-tbl-th"}, "학교"), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, React.createElement("span", {className: ""}, "유형")), 
                            React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), React.createElement("a", null, "교실명"), React.createElement("span", {className: "web-blind"}, ")"))

                        ), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "담당자"), 
                        React.createElement("th", {scope: "col"}, "현황")
                    )
                ), 
                React.createElement("tbody", null, 
                    classList
                )
            ), 
            paging
        )
      );
    }
});

