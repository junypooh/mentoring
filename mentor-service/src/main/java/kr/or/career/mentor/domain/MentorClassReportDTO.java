/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MentorClassReportDTO
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
public class MentorClassReportDTO {

    /** 회원ID */
    @ExcelFieldName(name="멘토ID",order=1)
    private String id;

    /** 회원이름 */
    @ExcelFieldName(name="이름",order=2)
    private String nm;

    /** 직업명 */
    @ExcelFieldName(name="직업",order=3)
    private String jobNm;

    /** 수업차수 */
    @ExcelFieldName(name="수업회차",order=4)
    private String lectTims;

    /** 수업순서 */
    @ExcelFieldName(name="수업순서",order=5)
    private String schdSeq;

    /** 수업ID */
    @ExcelFieldName(name="수업ID",order=6)
    private String lectId;

    /** 수업대상학교 */
    @ExcelFieldName(name="수업대상학교",order=7)
    private String lectTargtNm;

    /** 수업상태명 */
    @ExcelFieldName(name="수업상태",order=8)
    private String lectStatDesc;

    /** 수업일시 */
    @ExcelFieldName(name="수업일시",order=9)
    private String lectDay;

    /** 수업시간 */
    @ExcelFieldName(name="수업시간",order=10)
    private String lectTime;

    /** 등록업체 */
    @ExcelFieldName(name="등록업체",order=11)
    private String coNm;

    /** 참여클래스 */
    @ExcelFieldName(name="참여클래스",order=12)
    private String applCnt;

    /** 회원일련번호 */
    private String mbrNo;

    /** row num */
    private Integer rn;

}

