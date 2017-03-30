/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SendResultExcelDTO
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 12. 2. 오전 3:16
 */
@Data
public class SendResultExcelDTO {
    @ExcelFieldName(name="번호",order=1)
    private Integer no;

    @ExcelFieldName(name="전송일자",order=2)
    private String sendDate;

    @ExcelFieldName(name="내역",order=3)
    private String sendDetail;

    @ExcelFieldName(name="발송자",order=4)
    private String sender;

    @ExcelFieldName(name="금액(원)",order=5)
    private String price;

}
