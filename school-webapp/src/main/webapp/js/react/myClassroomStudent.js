var MyClassList = React.createClass({displayName: "MyClassList",
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
                    tooltip.push(React.createElement("li", null, classes[i]));
                }
            } else {
                classData.reqMbrNmText = classes[0];
            }
            return (
                    React.createElement("tr", null, 
                        React.createElement("td", {className: "first-date"}, new Date(classData.reqDtm).format('yyyy-MM-dd')), 
                        React.createElement("td", {className: "tbl-hide"}, classData.clasRoomInfo.schInfo.sidoNm, " ", classData.clasRoomInfo.schInfo.sgguNm), 
                        React.createElement("td", {className: "tbl-class-td"}, 
                            React.createElement("span", {className: "web-tbl-td"}, classData.clasRoomInfo.schInfo.schNm), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, classData.clasRoomInfo.clasRoomTypeNm), 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), classData.clasRoomInfo.clasRoomNm, React.createElement("span", {className: "web-blind"}, ")"))
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
                        React.createElement("td", {colSpan: "3", className: "empty"}, "등록 된 교실이 없습니다."), 
                        React.createElement("td", {className: "tbl-hide"}), 
                        React.createElement("td", {className: "tbl-hide"})
                    )
            );
        }

        return (
        React.createElement("div", null, 
            React.createElement("table", null, 
                React.createElement("caption", null, "대전둔원고등학교 학생 테이블정보 - 신청일, 지역, 학교, 반명, 교사명, 현황"), 
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
                            React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), "교실명", React.createElement("span", {className: "web-blind"}, ")"))
                        ), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "교실 담당자"), 
                        React.createElement("th", {scope: "col"}, "현황")
                    )
                ), 
                React.createElement("tbody", null, classList)
            ), 
            React.createElement("div", {className: "btn-paging"}, 
                React.createElement(PageNavi, {
                            url: this.props.url, 
                            pageFunc: this.goPage, 
                            totalRecordCount: this.state.totalRecordCount, 
                            currentPageNo: this.state.currentPageNo, 
                            recordCountPerPage: this.state.recordPerPage, 
                            contextPath: this.props.contextPath})
            )
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
            return (
                    React.createElement("tr", null, 
                        React.createElement("td", null, classData.schInfo.sidoNm, " ", classData.schInfo.sgguNm), 
                        React.createElement("td", null, classData.schInfo.schNm), 
                        React.createElement("td", null, classData.clasRoomNm), 
                        React.createElement("td", null, classData.tchrMbrNm), 
                        React.createElement("td", {className: "none-line"}, React.createElement("button", {type: "button", className: "btn-type3 popup", name: "등록", onClick: registClassroom.bind(this,classData)}, "등록"))
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "5", className: "empty"}, "교실 찾기 버튼을 클릭 후 나의 교실을 신청해주세요.")
                    )
            );
        }

        return (
            React.createElement("div", null, 
                React.createElement("p", {className: "search-result"}, "검색 결과", React.createElement("strong", null, "총", React.createElement("em", null, this.state.totalRecordCount), "건")), 
                React.createElement("table", null, 
                    React.createElement("caption", null, "나의 교실 등록 검색결과 - 겸색결과와 지역,학교,반명,교사명,선택"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", {style: {width:"20%"}}), 
                        React.createElement("col", null), 
                        React.createElement("col", {style: {width:"18%"}}), 
                        React.createElement("col", {style: {width:"20%"}}), 
                        React.createElement("col", {style: {width:"12%"}})
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, "지역"), 
                            React.createElement("th", {scope: "col"}, "학교"), 
                            React.createElement("th", {scope: "col"}, "반 명"), 
                            React.createElement("th", {scope: "col"}, "교사 명"), 
                            React.createElement("th", {scope: "col", className: "none-line"}, "선택")
                        )
                    ), 
                    React.createElement("tbody", null, 
                        classList
                    )
                ), 
                React.createElement("p", null, React.createElement("em", null, "!"), "나의 반을 찾지 못했을 경우 진로상담 선생님께 확인하세요.")
            )
      );
    }
});


var MyClassInfoList = React.createClass({displayName: "MyClassInfoList",
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
                    tooltip.push(React.createElement("li", null, classes[i]));
                }
            } else {
                classData.reqMbrNmText = classes[0];
            }
            //classData.reqMbrNm = replaceAll(classData.reqMbrNm, ",", "");
            return (
                    React.createElement("tr", null, 
                        React.createElement("td", {className: "first-date"}, new Date(classData.reqDtm).format('yyyy-MM-dd')), 
                        React.createElement("td", {className: "tbl-hide"}, classData.clasRoomInfo.schInfo.sidoNm, " ", classData.clasRoomInfo.schInfo.sgguNm), 
                        React.createElement("td", {className: "tbl-class-td"}, 
                            React.createElement("span", {className: "web-tbl-td"}, classData.clasRoomInfo.schInfo.schNm), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, classData.clasRoomInfo.clasRoomTypeNm), 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), classData.clasRoomInfo.clasRoomNm, React.createElement("span", {className: "web-blind"}, ")"))
                        ), 

                        React.createElement("td", {className: "tbl-hide tooltip"}, 
                            classData.reqMbrNmText, 
                            React.createElement("div", {className: "tooltip-box", style: {display:(tooltip=='')?'none':''}}, 
                                React.createElement("ul", null, 
                                    tooltip
                                )
                            )
                        ), 
                        React.createElement("td", {className: "tbl-hide ta-l"}, 
                            classData.clasRoomInfo.rpsYn != 'Y' && classData.regStatCd == '101526'  && classData.cualfCnt == '0' ? React.createElement("a", {href: "javascript:void(0)", className: "btn-type6", onClick: setRpsClas.bind(this,classData)}, "대표교실"): '', 
                            classData.clasRoomInfo.rpsYn == 'Y' ? React.createElement("a", {href: "javascript:void(0)", className: "btn-type6 pink", onClick: setRpsClas.bind(this,classData)}, "대표교실") : '', 
                            React.createElement("a", {href: "javascript:void(0)", className: "btn-delete", onClick: delRpsClas.bind(this,classData)}, "삭제")
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
                        React.createElement("td", {className: "tbl-hide"})
                    )
            );
        }

        return (
        React.createElement("div", null, 
            React.createElement("table", {className: "no-title"}, 
                React.createElement("caption", null, "나의 교실 정보 테이블정보 - 신청일, 지역, 학교, 유형, 교실명, 담당자, 관리"), 
                React.createElement("colgroup", null, 
                    React.createElement("col", {style: {width:"13%"}}), 
                    React.createElement("col", {style: {width:"14%"}}), 
                    React.createElement("col", null), 
                    React.createElement("col", {style: {width:"14%"}}), 
                    React.createElement("col", {style: {width:"14%"}})
                ), 
                React.createElement("thead", null, 
                    React.createElement("tr", null, 
                        React.createElement("th", {scope: "col", className: "first-date"}, "신청일"), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "지역"), 
                        React.createElement("th", {scope: "col"}, 
                            React.createElement("span", {className: "web-tbl-th"}, "학교"), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, React.createElement("span", {className: ""}, "유형")), 
                            React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), "교실명", React.createElement("span", {className: "web-blind"}, ")"))
                        ), 
                        React.createElement("th", {scope: "col"}, "담당자"), 
                        React.createElement("th", {scope: "col", className: "tbl-hide"}, "관리")
                    )
                ), 
                React.createElement("tbody", null, classList)
            ), 
            React.createElement("div", {className: "btn-paging"}, 
                React.createElement(PageNavi, {
                            url: this.props.url, 
                            pageFunc: this.goPage, 
                            totalRecordCount: this.state.totalRecordCount, 
                            currentPageNo: this.state.currentPageNo, 
                            recordCountPerPage: this.state.recordPerPage, 
                            contextPath: this.props.contextPath})
            )
        )
      );
    }
});



var MyManagementClassList = React.createClass({displayName: "MyManagementClassList",
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
                    React.createElement("tr", null, 
                        React.createElement("td", {className: "tbl-hide"}, new Date(classData.regDtm).format('yyyy-MM-dd')), 
                        React.createElement("td", {className: "tbl-hide"}, classData.schInfo.sidoNm), 
                        React.createElement("td", {className: "tbl-class-td"}, 
                            React.createElement("span", {className: "web-tbl-td"}, classData.schInfo.schNm), 
                            React.createElement("span", {className: "web-tbl-th m-blind"}, classData.clasRoomTypeNm), 
                            React.createElement("span", {className: "web-tbl-td"}, React.createElement("span", {className: "web-blind"}, "("), React.createElement("a", {href: "classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm}, classData.clasRoomNm), React.createElement("span", {className: "web-blind"}, ")"))
                        ), 
                        React.createElement("td", null, React.createElement("a", {href: "javascript:void(0)", className: classData.applyCnt > 0 ? "underpink":"underline", onClick: openApprovePopup.bind(this,classData.clasRoomSer,classData.applyCnt)}, classData.applyCnt)), 
                        React.createElement("td", null, React.createElement("a", {className: "underline", href: "classroomMembers.do?clasRoomSer="+classData.clasRoomSer+"&schNm="+classData.schInfo.schNm+"&mbrClassCd=100858"}, classData.registCnt)), 
                        React.createElement("td", {className: "tbl-hide ta-l"}, 
                            classData.rpsYn != 'Y' && classData.regStatCd == '101526' ? React.createElement("a", {href: "javascript:void(0)", className: "btn-type6", onClick: setRpsClas2.bind(this,classData)}, "대표교실") : '', 
                            classData.rpsYn == 'Y'  ? React.createElement("a", {href: "javascript:void(0)", className: "btn-type6 pink", onClick: setRpsClas2.bind(this,classData)}, "대표교실") :   '', 
                            React.createElement("a", {href: "javascript:void(0)", className: "btn-delete", onClick: delRpsClas2.bind(this,classData)}, "삭제")
                        )
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "4", className: "empty"}, "등록 된 교실이 없습니다."), 
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
                      React.createElement(PageNavi, {url: this.props.url, pageFunc: this.goPage, totalRecordCount: this.state.totalRecordCount, currentPageNo: this.state.currentPageNo, recordCountPerPage: this.state.recordCountPerPage, contextPath: mentor.contextpath})
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
                            React.createElement("th", {scope: "col"}, React.createElement("span", {className: "web-tbl-th"}, "학교"), React.createElement("span", {className: "web-tbl-th"}, React.createElement("span", {className: "web-blind"}, "("), "반명", React.createElement("span", {className: "web-blind"}, ")"))), 
                            React.createElement("th", {scope: "col"}, "학생 명"), 
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
            var classes = classData.reqMbrNm.split(",");
            if(classes.length > 1) {
                classData.reqMbrNmText = classes[0] + " > 외" + (classes.length-1);
            } else {
                classData.reqMbrNmText = classes[0];
            }
            return (
                    React.createElement("tr", null, 
                        React.createElement("td", null, classData.schInfo.sidoNm, " ", classData.schInfo.sgguNm), 
                        React.createElement("td", null, classData.schInfo.schNm), 
                        React.createElement("td", null, classData.clasRoomNm), 
                        React.createElement("td", null, classData.reqMbrNmText), 
                        React.createElement("td", {className: "none-line"}, React.createElement("button", {type: "button", className: "btn-type3 popup", name: "신청", onClick: registClassroom.bind(this,classData)}, (classData.isRegistedRoom == "Y")?"완료":"신청"))
                    )
                  );
                });
        }else{
            classList =[];
            classList.push(
                    React.createElement("tr", null, 
                        React.createElement("td", {colSpan: "5", className: "empty"}, "등록 된 학교가 없습니다.")
                    )
            );
        }

        return (
            React.createElement("div", null, 
                React.createElement("p", {className: "search-result"}, "검색 결과", React.createElement("strong", null, "총", React.createElement("em", null, this.state.totalRecordCount), "건")), 
                React.createElement("table", null, 
                    React.createElement("caption", null, "나의 교실 등록 검색결과 - 겸색결과와 지역,학교,반명,교사명,선택"), 
                    React.createElement("colgroup", null, 
                        React.createElement("col", {style: {width:"20%"}}), 
                        React.createElement("col", null), 
                        React.createElement("col", {style: {width:"18%"}}), 
                        React.createElement("col", {style: {width:"20%"}}), 
                        React.createElement("col", {style: {width:"12%"}})
                    ), 
                    React.createElement("thead", null, 
                        React.createElement("tr", null, 
                            React.createElement("th", {scope: "col"}, "지역"), 
                            React.createElement("th", {scope: "col"}, "학교"), 
                            React.createElement("th", {scope: "col"}, "반 명"), 
                            React.createElement("th", {scope: "col"}, "교사 명"), 
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