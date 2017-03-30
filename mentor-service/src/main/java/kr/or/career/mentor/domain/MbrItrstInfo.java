/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MbrItrstInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오후 6:56:40
 * @author technear
 * @see
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class MbrItrstInfo extends Base {

    /** 회원번호 */
    private String mbrNo;

    /** 관심 대상 코드 */
    private String itrstTargtCd;

    /** 관심 대상 번호 */
    private String itrstTargtNo;

    /** 등록일시 */
    private Date regDtm;
}
