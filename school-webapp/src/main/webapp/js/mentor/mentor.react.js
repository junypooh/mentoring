/**
 * 직업 정보
 */

'use strict';

mentor.jobDataSet = {
    jobInfos: [],
    totalRecordCount: 0,
    currentPageNo: 1,
};


var ChrstcClsf = React.createClass({

    render: function() {
        return (
            <li>
                <label className="chk-skin">첨단&middot;정보(ICT)기술<em>(5)</em>
                    <input type="checkbox" className="check-style" name="특징분류" value={this.props.chrstcNm} ref="chrstcClsfChecker" />
                </label>
            </li>
        );
    }
});


var ChrstcClsfList = React.createClass({

    render: function() {
        return (
            <ul className="job-select-ul">
                <ChrstcClsf ref="abc" chrstcNm="cnm1" />
                <ChrstcClsf ref="abc" chrstcNm="cnm2" />
            </ul>
        );
    }
});


var JobClsf = React.createClass({

    onClick: function() {

    },

    render: function() {
        return (
            <li>
                <label className="radio-skin">선택 안함
                    <input type="radio" name="job" checked={true} />
                </label>
            </li>
        );
    }
});


var JobSearcher = React.createClass({

    setPosition: function() {
        var jobSearchLayerNode = React.findDOMNode(this.refs.jobSearch);
        var windowWidth = $(window).width();
        var windowHeight = $(window).height();
        var $obj = $(jobSearchLayerNode);
        var objWidth = $obj.width();
        var objHeight = $obj.height();
        var styles = {
                left:(windowWidth/2)-(objWidth/2),
                top:(windowHeight/2)-(objHeight/2),
        };
        $obj.css(styles);
    },

    doCancel: function() {
        event.preventDefault();

        console.info(this);
    },


    doConfirm: function(event) {
        event.preventDefault();

        console.info(this)
    },

    componentDidMount: function() {
        this.setPosition();
    },

    render: function() {
        return (
            <div className="layer-pop-wrap" id="jobSearch" ref="jobSearch">
                <div className="layer-pop">
                    <div className="layer-header">
                        <strong className="title">직업 선택</strong>
                    </div>
                    <div className="layer-cont">
                        <div className="box-style none-border">
                            <strong>특징 분류</strong>
                            <ChrstcClsfList ref="chrstcClsfList" />

                            <strong>직업 분류</strong>
                            <div className="job-selection" style={{position: 'relative'}}>
                                <div>
                                    <ul className="job-select-ul other-btm">
                                        <li>
                                            <label className="radio-skin">선택 안함
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">경영&middot;회계&middot;사무<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">금융&middot;보험<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">보건&middot;의료<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">사회 복지 및 종교<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">교육 및 자연과학, 사회과학 연구<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">영업 및 판매<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">경비 및 청소<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">법률&middot;경찰&middot;소방&middot;교도<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">전기&middot;전자<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">음식 서비스<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">문화&middot;예술&middot;디자인&middot;방송<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">화학<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">기계<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">정보통신<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">농림어업<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">건설<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">식품가공<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin other">군인<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin other">재료(금속&middot;유리&middot;점토&middot;시멘트)<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin other">환경&middot;인쇄&middot;목재&middot;가구&middot;공예 및<br /> 생산단순<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">섬유 및 의복<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">미용&middot;숙박&middot;여행&middot;오락&middot;스포츠<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li></li>
                                        <li>
                                            <label className="radio-skin">운전 및 운송<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                        <li>
                                            <label className="radio-skin">관리<em>(5)</em>
                                            <input type="radio" name="job" />
                                            </label>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div className="btn-area border">
                            <a href="#" className="btn-type2 popup" onClick={this.doConfirm}>확인</a>
                            <a href="#" className="btn-type2 cancel" onClick={this.doCancel}>취소</a>
                        </div>
                        <a href="#" className="layer-close">팝업 창 닫기</a>
                    </div>
                </div>
            </div>
        );
    }
});


var DefaultSearcher = React.createClass({

    onSearch: function(event) {
        event.preventDefault();

        if (this.refs.searchKey.getDOMNode().value.length < 2) {
            alert('키워드는 2글자 이상 입력하세요.');
            return;
        }

        this.props.onSearch({
            searchType: this.refs.searchType.getDOMNode().value,
            searchKey: this.refs.searchKey.getDOMNode().value,
        });
    },

    render: function() {
        return (
            <div className="review-tbl-wrap">
                <div className="review-tbl">
                    <table>
                        <caption>직업소개 검색창 - 키워드,직업</caption>
                        <colgroup>
                            <col className="size-tbl1" />
                            <col className="size-tbl2" />
                            <col className="size-tbl1" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row"><label for="schoolKeyword">키워드</label></th>
                                <td>
                                    <div className="keyword-search">
                                        <select id="searchType" name="searchType" ref="searchType" className="keyword-slt" title="키워드 종류">
                                            <option value="all">전체 </option>
                                            <option value="class">수업 </option>
                                            <option value="mentor">멘토</option>
                                            <option value="tag">태그</option>
                                            <option value="job">직업</option>
                                        </select>
                                        <input type="text" id="searchKeyWord" name="searchKeyWord" ref="searchKey" className="keyword-inp" title="키워드입력란" />
                                    </div>
                                </td>
                                <th scope="row"><label>직업</label></th>
                                <td>
                                    <a href="#jobSearch" title="직업선택 - 열기" className="btn-job layer-open">직업선택</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div className="btn-area">
                    <a href="#" onClick={this.onSearch} className="btn-search"><span>검색</span></a>
                </div>
            </div>
        );
    }
});


var JobInfo = React.createClass({

    render: function() {
        var { jobNm, jobIntdcInfo, mentorCnt, jobPicInfo, ...other } = this.props.jobInfo;
        var jobPicAlt = jobNm + ' 인물사진';

        if (jobPicInfo) {
            jobPicInfo = jobPicInfo.replace(/^([^,]+).*/, '$1');
        }

        return (
            <li>
                <a href="#">
                    <dl className="introduction-info">
                        <dt className="title">{jobNm}</dt>
                        <dd className="info">{jobIntdcInfo}</dd>
                        <dd className="icon"><span className="icon-total-mentor">멘토 {mentorCnt}명</span></dd>
                        <dd className="img"><img src={jobPicInfo} alt={jobPicAlt} /></dd>
                    </dl>
                </a>
            </li>
        );
    }
});


var JobList = React.createClass({

    render: function() {
        var more = null;

        if ((this.props.totalRecordCount - (this.props.currentPageNo * 9)) > 0) {
            more = (
                <div className="btn-more-view">
                    <a href="#" onClick={this.props.onMore}>더 보기 (<span>{(Math.floor((this.props.totalRecordCount + 1) / 9) - this.props.currentPageNo) + 1}</span>)</a>
                </div>
            );
        }

        return (
            <div>
                <p className="result-total">검색 결과 총 <strong>{this.props.totalRecordCount}</strong> 건</p>
                <div className="introduction-list">
                    <ul>
                        {
                            this.props.jobInfos.map(function(data) {
                                return (
                                    <JobInfo jobInfo={data} />
                                );
                            }.bind(this))
                        }
                    </ul>
                </div>
                {more}
            </div>
        );
    }
});


var JobContents = React.createClass({

    componentDidMount: function() {
        $.get(this.props.source, {currentPageNo: mentor.jobDataSet.currentPageNo}, function(data) {
            mentor.jobDataSet.jobInfos = data;
            if (data.length) {
                mentor.jobDataSet.totalRecordCount = data[0].totalRecordCount;
            }
            this.setState(mentor.jobDataSet);
        }.bind(this));
    },
    onMore: function(event) {
        event.preventDefault();
        var params = {
            searchType: mentor.jobDataSet.searchType,
            searchKey: mentor.jobDataSet.searchKey,
            currentPageNo: ++mentor.jobDataSet.currentPageNo,
        };
        $.get(this.props.source, params, function(data) {
            mentor.jobDataSet.jobInfos = mentor.jobDataSet.jobInfos.concat(data);
            this.setState(mentor.jobDataSet);
        }.bind(this));
    },
    doSearch: function(params) {
        mentor.jobDataSet.currentPageNo = 1;
        mentor.jobDataSet.jobInfos = [];
        mentor.jobDataSet.totalRecordCount = 0;

        $.extend(mentor.jobDataSet, params);

        var params = {
            searchType: mentor.jobDataSet.searchType,
            searchKey: mentor.jobDataSet.searchKey,
            currentPageNo: mentor.jobDataSet.currentPageNo,
        };

        $.get(this.props.source, params, function(data) {
            mentor.jobDataSet.jobInfos = data;
            if (data.length) {
                mentor.jobDataSet.totalRecordCount = data[0].totalRecordCount;
            }
            this.setState(mentor.jobDataSet);
        }.bind(this));
    },
    render: function() {
        console.info(mentor.jobDataSet);
        return (
            <div>
                <DefaultSearcher onSearch={this.doSearch} />
                <JobList {...mentor.jobDataSet} onMore={this.onMore} />
                <JobSearcher />
            </div>
        );
    }
});


//var onChange = function() {
    React.render(
        <JobContents source={'ajax.listJobInfo.do'} />,
        document.getElementById('job-info-contents')
    );
//}
