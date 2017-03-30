package kr.or.career.mentor.domain;

import lombok.Data;

@Data
public class ChrstcClsfDTO {

    /** 특성 코드 */
    private String chrstcCd;

    /** 특성 명 */
    private String chrstcNm;

    /** 멘토 수 */
    private int mentorCnt;

    /** 수업수 */
    private int lectureCnt;
}
