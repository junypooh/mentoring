/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;


/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MbrLoginHist.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 11. 2. 오후 3:38:23
 * @author  technear
 * @see
 */
@Data
public class MbrLoginHist extends Base {
    String mbrNo;
    Date loginDtm;
    String loginClassCd;
    String connIp;
}
