/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectureSummaryByJobDto
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 16. 5. 26. 오후 1:46
 */
@Data
public class LectureSummaryByJobDto {
    @ExcelFieldName(name="직업ID",order = 1)
    private String jobNo;
    @ExcelFieldName(name="직업명",order = 2)
    private String jobNm;
    @ExcelFieldName(name="고용직업분류",order = 3)
    private String jobClsfNm;
    @ExcelFieldName(name="멘토수",order = 4)
    private Integer mentorCnt;
    @ExcelFieldName(name="수업수",order = 5)
    private Integer lectCnt;
}
