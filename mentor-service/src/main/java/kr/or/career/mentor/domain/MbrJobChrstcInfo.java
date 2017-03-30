package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MbrJobChrstcInfo {

    /** 회원 번호 */
    private String mbrNo;

    /** 직업특성 코드 */
    private String jobChrstcCd;

    /** 등록일자 */
    private Date regDtm;

    // transient ==============
    /** 직업특성 코드 명 */
    private String jobChrstcCdNm;
}
