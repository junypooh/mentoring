package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      CalendarInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-27 오후 5:45
 */
@Data
public class CalendarInfo {

    private String strDay;
    private String year;
    private String month;
    private String day;
    private String date;

    private String searchDate;
}
