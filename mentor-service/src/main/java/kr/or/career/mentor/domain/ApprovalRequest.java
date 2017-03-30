/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ApprovalRquest
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 23. 오후 2:04
 */
@Data
public class ApprovalRequest extends Base implements Serializable{

    private static final long serialVersionUID = 293187279768653127L;
    private String approveType;
    private String approveTypeNm;
    /**
     *  mbrNo : 회원번호(멘토)
     *  lectSer : 강의번호
     */
    private String requestId;
    private String requestNm;
    /**
     *  lectTims : 강의차수
     */
    private int requestSeq;
    /**
     *  profile title,lecutre Name
     */
    private String content;
    private Date regDtm;
    /**
     *  personal mentor Name
     */
    private String mbrNo;
}
