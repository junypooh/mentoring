package kr.or.career.mentor.domain;

import java.io.Serializable;
import java.util.Date;

import lombok.Data;


@Data
public class MbrIconInfo implements Serializable {

    private static final long serialVersionUID = 6100799292417780666L;
    /** 회원번호 */
    private String mbrNo;
    /** 아이콘 종류 코드 */
    private String iconKindCd;
    /** 등록일시 */
    private Date regDtm;
    /** 등록 회원 번호 */
    private String regMbrNo;
}
