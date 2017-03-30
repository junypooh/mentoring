/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    JoinSummaryDTO
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 12. 16. 오전 9:19
 */
@Data
public class JoinSummaryDTO {

    @ExcelFieldName(name="일자",order=1)
    private String day;
    @ExcelFieldName(name="초",order=2)
    private String element;
    @ExcelFieldName(name="중",order=3)
    private String middle;
    @ExcelFieldName(name="고",order=4)
    private String high;
    @ExcelFieldName(name="대학",order=5)
    private String univ;
    @ExcelFieldName(name="일반",order=6)
    private String normal;
    @ExcelFieldName(name="학부모",order=7)
    private String parent;
    @ExcelFieldName(name="교사",order=8)
    private String teacher;
    @ExcelFieldName(name="멘토",order=9)
    private String mentor;
    @ExcelFieldName(name="전체",order=10)
    private String totcnt;
}
