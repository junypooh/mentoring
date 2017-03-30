/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.Calendar;
import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    CalculateManagementExcelDTO
 *
 * 정산관리 excel용 DTO
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-29 오후 3:31
 */
@Data
public class CalculateManagementExcelDTO {

    @ExcelFieldName(name="번호",order=1)
    private Integer no;

    private String lectDay;

    @ExcelFieldName(name="수업일",order=2)
    private Date dateLectDay;

    private String lectStartTime;

    private String lectEndTime;

    @ExcelFieldName(name="시간",order=3)
    private String lectTime;

    @ExcelFieldName(name="수업횟수",order=4)
    private Integer lectureCnt;

    @ExcelFieldName(name="유형",order=5)
    private String lectTypeCdNm;

    @ExcelFieldName(name="수업명",order=6)
    private String lectTitle;

    @ExcelFieldName(name="신청디바이스",order=7)
    private Integer applCnt;

    @ExcelFieldName(name="참관디바이스",order=8)
    private Integer obsvCnt;

}

