/* license */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ApprovalDTO.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 26. 오전 10:12:06
 * @author  technear
 * @see
 */
@Data
public class ApprovalDTO extends Base{
    private String appTypeCd;
    private String appTypeNm;
    private String detail;
    private Integer  lectSer;
    private Integer lectTims;
    private Integer schdSeq;
    private String mbrNo;
    private String nm;
    private Date regDtm;

    private String lectStatCd;
    private String lectTargtCd;
    private String mbrStatCd;
    private String reason;

    private String lectSessId;

    private Integer cnt;

    private String loginPermYn;

    /**소속멘토의 정보만을 조회할 때 사용*/
    private List<String> listMbrNo;
}
