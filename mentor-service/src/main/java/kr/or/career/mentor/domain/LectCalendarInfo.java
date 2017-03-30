package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectCalendarInfo
 *
 * 수업 일정 캘린더 Domain
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-05-19 오전 11:38
 */
@Data
public class LectCalendarInfo {

    /**
     * 년월일
     */
    private String dtm;

    /**
     * 일자
     */
    private Integer numDay;

    /**
     * 요일(숫자)
     * 1: 일요일 ~ 7: 토요일
     */
    private String d;

    /**
     * 이번달에 사용하는 css class명
     */
    private String thisMonth;

    /**
     * 오늘 날짜에 사용하는 css class명
     */
    private String toDay;

    /**
     * 전체 수업 건수
     */
    private Integer totCnt;

    /**
     * 초등학교 수업 건수
     */
    private Integer eleCnt;

    /**
     * 중학교 수업 건수
     */
    private Integer midCnt;

    /**
     * 고등학교 수업 건수
     */
    private Integer highCnt;
}
