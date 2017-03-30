package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * Created by chaos on 2016. 7. 28..
 */
@Data
public class RecommandInfo extends Base {
    private Integer sortSeq;
    private Integer recomSer;
    private String recomTargtCd;
    private String recomTargtNo;
    private Integer lectTims;
    private String lectTargtNm;
    private String lectTypeCd;
    private String lectTypeNm;
    private String lectTitle;
    private String lectrMbrNm;
    private String lectStatNm;
    private String lectDay;
    private String regMbrNo;
    private String recentLectDay;
    private String expectLectDay;
    private String mbrNm;
    private String jobNo;
    private String jobNm;
    private String regDtm;

    private String jobClsfNm;
    private Integer mentorCnt;
    private Integer interestCnt;

}
