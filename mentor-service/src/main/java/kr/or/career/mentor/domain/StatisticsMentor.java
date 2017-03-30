package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      StatisticsMentor
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-08-29 오전 11:12
 */
@Data
public class StatisticsMentor {

    /** 1차 직업분류 */
    private String jobStruct1;

    /** 2차 직업분류 */
    private String jobStruct2;

    /** 3차 직업분류 */
    private String jobStruct3;

    /** 직업별 보유 멘토수 */
    private String haveMentor;

    /** 직업별 보유 강의수 */
    private String haveLect;

    /** 1차 직업분류 갯수 */
    private String jobStruct1Cnt;

    /** 2차 직업분류 갯수 */
    private String jobStruct2Cnt;

    /** 3차 직업분류 갯수 */
    private String jobStruct3Cnt;

    /** 특징분류명 */
    private String chrstcNm;

    @ExcelFieldName(name="멘토ID", order=1)
    private String id;

    @ExcelFieldName(name="이름", order=2)
    private String nm;

    @ExcelFieldName(name="직업", order=3)
    private String jobNm;

    @ExcelFieldName(name="수업회차", order=4)
    private String lectTims;

    @ExcelFieldName(name="수업ID", order=5)
    private String lectSer;

    @ExcelFieldName(name="수업상태", order=6)
    private String lectStatNm;

    @ExcelFieldName(name="수업일시", order=7)
    private String lectDay;

    @ExcelFieldName(name="수업시간", order=8)
    private String lectDateTime;

    /** 강의시작시간 */
    private String lectStartTime;

    /** 강의종료시간 */
    private String lectEndTime;

    @ExcelFieldName(name="등록업체", order=9)
    private String coNm;

    @ExcelFieldName(name="참여클래스수", order=10)
    private String applCnt;

    /** 검색조건 시작날짜*/
    private String searchStDate;

    /** 검색조건 종료날짜*/
    private String searchEndDate;

}
