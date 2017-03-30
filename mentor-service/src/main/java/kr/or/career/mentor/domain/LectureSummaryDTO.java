/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LecutreSummaryDTO
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 12. 17. 오후 2:20
 */
@Data
public class LectureSummaryDTO {
    @ExcelFieldName(name="일자",order=1)
    private String day;
    @ExcelFieldName(name="총수업",order=2)
    private String totalCnt;
    @ExcelFieldName(name="초등학교",order=3)
    private String eleCnt;
    @ExcelFieldName(name="중학교",order=4)
    private String midCnt;
    @ExcelFieldName(name="고등학교",order=5)
    private String highCnt;
    @ExcelFieldName(name="소계",order=6)
    private String subTotalCnt;

}
