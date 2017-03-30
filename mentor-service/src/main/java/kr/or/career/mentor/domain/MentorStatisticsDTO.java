/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MentorStatisticsDTO
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-11-30 오후 7:08
 */
@Data
public class MentorStatisticsDTO {

    private String coNo;

    private Integer rn;

    private String day;

    @ExcelFieldName(name="번호",order=1)
    private Integer no;

    /**
     * 그룹관리자구분
     */
    @ExcelFieldName(name="그룹관리자 구분",order=2)
    private String coNm;

    /**
     * 보유기업
     */
    @ExcelFieldName(name="보유 기업",order=3)
    private String companyCnt;

    /**
     * 보유멘토
     */
    @ExcelFieldName(name="보유 멘토",order=4)
    private String mentorCnt;

    /**
     * 등록수업
     */
    private String lectureCnt;

    /**
     * 초등학교 수업일수
     */
    @ExcelFieldName(name="수업일수(초등)",order=5)
    private String elementaryLectDayCnt;

    /**
     * 중학교 수업일수
     */
    @ExcelFieldName(name="수업일수(중)",order=6)
    private String middleLectDayCnt;

    /**
     * 고등학교 수업일수
     */
    @ExcelFieldName(name="수업일수(고등)",order=7)
    private String highLectDayCnt;

    /**
     * 초등학교 수업제공수
     */
    @ExcelFieldName(name="수업제공수(초등)",order=8)
    private String elementaryLectOfferCnt;

    /**
     * 중학교 수업제공수
     */
    @ExcelFieldName(name="수업제공수(중)",order=9)
    private String middleLectOfferCnt;

    /**
     * 고등학교 수업제공수
     */
    @ExcelFieldName(name="수업제공수(고등)",order=10)
    private String highLectOfferCnt;
}

