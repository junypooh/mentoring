/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectApplCnt
 *
 * 강의 신청횟수 관련
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-25 오전 11:34
 */
@Data
public class LectApplCnt {

    /**
     * 강의신청횟수 교사ID
     */
    private String applMbrNo;

    /**
     * 강의신청횟수 일련번호
     */
    private Integer setSer;

    /**
     * 수업허용횟수
     */
    private double clasPermCnt;

    /**
     * 수업신청횟수
     */
    private double clasApplCnt;

    /**
     * 학교번호
     */
    private String schNo;
}
