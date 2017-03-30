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
 * @author
 * @see
 * @since 2016-5-24 오전 10:41
 */
@Data
public class MentorReportDTO {

    /** 회원ID */
    @ExcelFieldName(name="멘토ID",order=1)
    private String id;

    /** 회원이름 */
    @ExcelFieldName(name="이름",order=2)
    private String nm;

    /** 직업코드명 */
    @ExcelFieldName(name="고용직업분류",order=3)
    private String cdNm;

    /** 직업명 */
    @ExcelFieldName(name="직업",order=4)
    private String jobNm;

    /** 회원등록일 */
    @ExcelFieldName(name="멘토등록일",order=5)
    private String regDtm;

    /** 강의최초수업일 */
    @ExcelFieldName(name="최초수업일",order=6)
    private String minLectDay;

    /** 강의최근수업일 */
    @ExcelFieldName(name="최근수업일",order=7)
    private String maxLectDay;

    /** 강의수업일수 */
    @ExcelFieldName(name="수업참여일수",order=8)
    private String lectDayCnt;

    /** 강의수업총횟수 */
    @ExcelFieldName(name="총수업횟수",order=9)
    private String lectDayTotCnt;

    /** 회원일련번호 */
    private String mbrNo;

    /** 직업코드분류 */
    private String jobClsfCd;

    /** row num */
    private Integer rn;

}

