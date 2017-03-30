package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * Created by chaos on 2016. 8. 3..
 */
@Data
public class RecomMentorInfo extends Base{
    private Integer sortSeq;
    private Integer recomSer;
    private String recomTargtCd;
    private String recentLectDay;
    private String expectLectDay;
    private String mbrNm;
    private String jobNm;
    private String regDtm;
}
