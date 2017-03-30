/* license */
package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SchInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오전 9:38:56
 * @author technear
 * @see
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class SchJobGroup extends Base {

    /** 학교_번호 */
    private String schNo;

    /** 학교_특성_코드 */
    private String schChrstcCd;

    /** 학교_특성_이름 */
    private String schChrstcNm;

    private String regDtm;

    private String regMbrNo;

}
