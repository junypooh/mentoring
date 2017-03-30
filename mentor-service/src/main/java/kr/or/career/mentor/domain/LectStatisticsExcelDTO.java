/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;


/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectStatisticsExcelDTO
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-12-01 오후 5:05
 */
@Data
public class LectStatisticsExcelDTO {

    @ExcelFieldName(name="날짜",order=1)
    private String lectDay;

    @ExcelFieldName(name="총수업",order=2)
    private Integer totalLect;

    @ExcelFieldName(name="초등학교",order=3)
    private Integer elementarySchool;

    @ExcelFieldName(name="중학교",order=4)
    private Integer middleSchool;

    @ExcelFieldName(name="고등학교",order=5)
    private Integer highSchool;

    @ExcelFieldName(name="소계",order=6)
    private Integer subTotalLect;

}
