/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MbrAgrInf
 *
 * 	회원동의정보
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 22. 오후 12:52
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MbrAgrInfo extends Base implements Serializable{
    /**
     * Field 설명
     */
    private static final long serialVersionUID = -6048292274116199467L;
    private String agrClassCd;
    private Date agrDtm;
    private String mbrNo;
}
