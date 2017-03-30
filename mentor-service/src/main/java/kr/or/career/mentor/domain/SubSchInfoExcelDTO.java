/* license */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SubSchInfoExcelDTO.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오전 9:38:56
 * @author technear
 * @see
 */
@Data
public class SubSchInfoExcelDTO {

    @ExcelFieldName(name="수업일시",order=1)
    private String lectDateTime;

    @ExcelFieldName(name="수업명",order=2)
    private String lectTitle;

}
