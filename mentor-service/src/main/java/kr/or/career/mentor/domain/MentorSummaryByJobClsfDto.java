/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MentorSummaryByJobClsfDto
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 16. 5. 26. 오후 2:45
 */
@Data
public class MentorSummaryByJobClsfDto {

    private String jobNo;

    @ExcelFieldName(name="고용직업분류",order = 1)
    private String jobClsfNm;

    @ExcelFieldName(name="직업수",order = 2)
    private Integer jobCnt;

    @ExcelFieldName(name="멘토수",order = 3)
    private Integer mentorCnt;

    @ExcelFieldName(name="수업수",order = 4)
    private Integer lectureCnt;
}
