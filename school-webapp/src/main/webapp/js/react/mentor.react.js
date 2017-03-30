/**
 * 직업 정보
 */

var JobSearcher = React.createClass({displayName: "JobSearcher",
    render: function() {
        return (
            React.createElement("div", {className: "layer-pop-wrap", id: "jobSearch"}, 
                React.createElement("div", {className: "layer-pop"}, 
                    React.createElement("div", {className: "layer-header"}, 
                        React.createElement("strong", {className: "title"}, "직업 선택")
                    ), 
                    React.createElement("div", {className: "layer-cont"}, 
                        React.createElement("div", {className: "box-style none-border"}, 
                            React.createElement("strong", null, "특징 분류"), 
                            React.createElement("ul", {className: "job-select-ul"}, 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "첨단·정보(ICT)기술", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "글로벌·세계화 인재", React.createElement("em", null, "(6)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "환경 관련 녹색직업", React.createElement("em", null, "(11)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "잘 알려진 직업", React.createElement("em", null, "(00)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "생소한 직업", React.createElement("em", null, "(00)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "아시아나 교육기부", React.createElement("em", null, "(00)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "감성,웰빙 트렌드", React.createElement("em", null, "(9)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "기업가정신", React.createElement("em", null, "(000)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                ), 
                                React.createElement("li", null, 
                                    React.createElement("label", {className: "chk-skin"}, "대한민국명장 교육기부", React.createElement("em", null, "(00)"), 
                                        React.createElement("input", {type: "checkbox", className: "check-style", name: "특징분류"})
                                    )
                                )
                            ), 

                            React.createElement("strong", null, "직업 분류"), 
                            React.createElement("div", {className: "job-selection", style: {position: 'relative'}}, 
                                React.createElement("ul", {className: "job-select-ul other-btm"}, 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "선택 안함", 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "경영·회계·사무", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "금융·보험", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "보건·의료", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "사회 복지 및 종교", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "교육 및 자연과학, 사회과학 연구", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "영업 및 판매", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "경비 및 청소", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "법률·경찰·소방·교도", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "전기·전자", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "음식 서비스", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "문화·예술·디자인·방송", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "화학", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "기계", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "정보통신", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "농림어업", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "건설", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "식품가공", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin other"}, "군인", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin other"}, "재료(금속·유리·점토·시멘트)", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin other"}, "환경·인쇄·목재·가구·공예 및", React.createElement("br", null), " 생산단순", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "섬유 및 의복", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "미용·숙박·여행·오락·스포츠", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "운전 및 운송", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    ), 
                                    React.createElement("li", null, 
                                        React.createElement("label", {className: "radio-skin"}, "관리", React.createElement("em", null, "(5)"), 
                                        React.createElement("input", {type: "radio", name: "job"})
                                        )
                                    )
                                )
                            )
                        ), 
                        React.createElement("div", {className: "btn-area border"}, 
                            React.createElement("a", {href: "#", className: "btn-type2 popup"}, "확인"), 
                            React.createElement("a", {href: "#", className: "btn-type2 cancel"}, "취소")
                        ), 
                        React.createElement("a", {href: "#", className: "layer-close"}, "팝업 창 닫기")
                    )
                )
            )
        );
    }
});

var DefaultSearcher = React.createClass({displayName: "DefaultSearcher",
    onSearch: function() {
        alert(this.refs.searchType.getDOMNode().value)
        alert(this.refs.searchKey.getDOMNode().value)
        this.props.doSearch({});
    },

    render: function() {
        return (
            React.createElement("div", {className: "review-tbl-wrap"}, 
                React.createElement("div", {className: "review-tbl"}, 
                    React.createElement("table", null, 
                        React.createElement("caption", null, "직업소개 검색창 - 키워드,직업"), 
                        React.createElement("colgroup", null, 
                            React.createElement("col", {className: "size-tbl1"}), 
                            React.createElement("col", {className: "size-tbl2"}), 
                            React.createElement("col", {className: "size-tbl1"}), 
                            React.createElement("col", null)
                        ), 
                        React.createElement("tbody", null, 
                            React.createElement("tr", null, 
                                React.createElement("th", {scope: "row"}, React.createElement("label", {for: "schoolKeyword"}, "키워드")), 
                                React.createElement("td", null, 
                                    React.createElement("div", {className: "keyword-search"}, 
                                        React.createElement("select", {id: "searchType", name: "searchType", ref: "searchType", className: "keyword-slt", title: "키워드 종류"}, 
                                            React.createElement("option", {value: "all"}, "전체 "), 
                                            React.createElement("option", {value: "class"}, "수업 "), 
                                            React.createElement("option", {value: "mentor"}, "멘토"), 
                                            React.createElement("option", {value: "tag"}, "태그"), 
                                            React.createElement("option", {value: "job"}, "직업")
                                        ), 
                                        React.createElement("input", {type: "text", id: "searchKeyWord", name: "searchKeyWord", ref: "searchKey", className: "keyword-inp", title: "키워드입력란"})
                                    )
                                ), 
                                React.createElement("th", {scope: "row"}, React.createElement("label", null, "직업")), 
                                React.createElement("td", null, 
                                    React.createElement("a", {href: "#jobSearch", title: "직업선택 팝업 - 열기", className: "btn-job layer-open"}, "직업선택")
                                )
                            )
                        )
                    )
                ), 
                React.createElement("div", {className: "btn-area"}, 
                    React.createElement("a", {href: "#", onClick: this.onSearch, className: "btn-search"}, React.createElement("span", null, "검색"))
                )
            )
        );
    }
});

var JobInfo = React.createClass({displayName: "JobInfo",
    render: function() {
        var { jobNm, jobIntdcInfo, mentorCnt, jobPicInfo, ...other } = this.props.jobInfo;
        var jobPicAlt = jobNm + ' 인물사진';

        if (jobPicInfo) {
            jobPicInfo = jobPicInfo.replace(/^([^,]+).*/, '$1');
        }

        return (
            React.createElement("li", null, 
                React.createElement("a", {href: "#"}, 
                    React.createElement("dl", {className: "introduction-info"}, 
                        React.createElement("dt", {className: "title"}, jobNm), 
                        React.createElement("dd", {className: "info"}, jobIntdcInfo), 
                        React.createElement("dd", {className: "icon"}, React.createElement("span", {className: "icon-total-mentor"}, "멘토 ", mentorCnt, "명")), 
                        React.createElement("dd", {className: "img"}, React.createElement("img", {src: jobPicInfo, alt: jobPicAlt}))
                    )
                )
            )
        );
    }
});

var JobList = React.createClass({displayName: "JobList",
    render: function() {
        return (
            React.createElement("div", null, 
                React.createElement("p", {className: "result-total"}, "검색 결과 총 ", React.createElement("strong", null, this.props.totalRecordCount), " 건"), 
                React.createElement("div", {className: "introduction-list"}, 
                    React.createElement("ul", null, 
                        
                            this.props.jobInfos.map(function(data) {
                                return (
                                    React.createElement(JobInfo, {jobInfo: data})
                                );
                            }.bind(this))
                        
                    )
                ), 
                React.createElement("div", {className: "btn-more-view"}, 
                    React.createElement("a", {href: "#", onClick: this.props.onMore}, "더 보기 (", React.createElement("span", null, Math.floor(this.props.totalRecordCount / 9) - this.props.currentPageNo), ")")
                )
            )
        );
    }
});

var JobContents = React.createClass({displayName: "JobContents",
    getInitialState: function() {
        return {
            jobInfos: [],
            totalRecordCount: 0,
            currentPageNo: 1,
        };
    },
    componentDidMount: function() {
        $.get(this.props.url, {currentPageNo: this.state.currentPageNo}, function(data) {
            var dataSet = {};
            dataSet.jobInfos = data;
            if (data.length) {
                dataSet.totalRecordCount = data[0].totalRecordCount;
            }
            this.setState(dataSet);
        }.bind(this));
    },
    onMore: function(event) {
        event.preventDefault();
        $.get(this.props.url, {currentPageNo: this.state.currentPageNo + 1}, function(data) {
            var dataSet = {};
            dataSet.jobInfos = this.state.jobInfos.concat(data);
            dataSet.currentPageNo = this.state.currentPageNo + 1;
            this.setState(dataSet);
        }.bind(this));
    },
    doSearch: function(params) {
        alert(params);
    },
    render: function() {
        return (
            React.createElement("div", null, 
                React.createElement(DefaultSearcher, {doSearch: this.doSearch}), 
                React.createElement(JobList, React.__spread({},  this.state, {onMore: this.onMore})), 
                React.createElement(JobSearcher, null)
            )
        );
    }
});

//var onChange = function() {
    React.render(
        React.createElement(JobContents, {url: 'ajax.listJobInfo.do'}),
        document.getElementById('job-info-contents')
    );
//}
