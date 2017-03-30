/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectureScheduleExcelDTO
 *
 * 수업스케줄 excel DTO
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-29 오후 5:24
 */
@Data
public class LectureScheduleExcelDTO {

    @ExcelFieldName(name="번호",order=1)
    private Integer no;

    private String lectDay;

    @ExcelFieldName(name="수업일",order=2)
    private Date dateLectDay;

    private String lectStartTime;

    private String lectEndTime;

    @ExcelFieldName(name="시간",order=3)
    private String lectTime;

    @ExcelFieldName(name="멘토명",order=4)
    private String lectrNm;

    @ExcelFieldName(name="직업명",order=6)
    private String jobNm;

    @ExcelFieldName(name="유형",order=7)
    private String lectTypeCdNm;

    @ExcelFieldName(name="수업명",order=8)
    private String lectTitle;

    @ExcelFieldName(name="신청디바이스",order=9)
    private Integer applCnt;

    @ExcelFieldName(name="상태",order=11)
    private String lectStatCdNm;

    /** 직업계층구조 */
    @ExcelFieldName(name="직업분류",order=5)
    private String jobStruct;

    @ExcelFieldName(name="참관디바이스",order=10)
    private Integer obsvCnt;
}

