package kr.or.career.mentor.domain;

import lombok.Data;

@Data
public class JobClsfDTO {

    /** 직업 코드 */
    private String jobCd;

    /** 직업명 */
    private String jobNm;

    /** 멘토 수 */
    private int mentorCnt;

}
