/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ClasRoomRegReqHist.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오전 10:56:41
 * @author  technear
 * @see
 */
@Data
public class ClasRoomRegReqHist extends Base{
    private Integer reqSer;
    private Integer clasRoomSer;
    private String reqMbrNo;
    private String reqMbrNm;
    private Date reqDtm;
    private String regStatCd;
    private String regStatNm;
    private Date authDtm;
    private String rjctRsnSust;

    private ClasRoomInfo clasRoomInfo;

    private String clasRegId;
    private String orderBy;

    /** 본인이 개설한 반 구분 */
    private String type;

    private Integer cualfCnt;

    private String clasRoomCualfCd;

    private String username;

    private String rpsYn;

    private String schNo;

    private String lectSer;

    private String authMbrNo;

    private String useYn;

    private String emailAddr;

    private String userType;

    private String mbrClassCd;

    private String schNm;
}
