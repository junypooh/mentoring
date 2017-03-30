package kr.or.career.mentor.domain;

import java.io.Serializable;
import java.util.Date;

import lombok.Data;

/**
 * 회원 프로필 정보
 * @author
 * @since
 * @version 1.0
 * @see
 *
 */

@Data
public class MbrJobInfo implements Serializable {

    private static final long serialVersionUID = 4355486399393168188L;

    /** 회원번호 */
    private String mbrNo;

    /** 직업번호 */
    private String jobNo;

    /** 직원이름 */
    private String jobNm;

    /** 직원설명 */
    private String jobDesc;

    /** 직업태그정보 */
    private String jobTagInfo;

    /** 등록일시 */
    private Date regDate;

    /** 직업분류 코드 */
    private String jobClsfCd;

    // transient =================================================
    private String jobClsfLv1Cd;
    private String jobClsfLv2Cd;
    private String jobClsfLv3Cd;
    private String jobClsfLv1Nm;
    private String jobClsfLv2Nm;
    private String jobClsfLv3Nm;

}
