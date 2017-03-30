/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MbrRelMapp
 *
 * 회원관계매핑 Domain
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-20 오후 2:18
 */
@Data
public class MbrRelMapp {

    /**
     * 매핑_일련번호
     */
    private Integer mappSer;

    /**
     * 등록_회원_번호
     */
    private String regMbrNo;

    /**
     * 대상_회원_번호
     */
    private String targtMbrNo;

    /**
     * 관계_구분_코드(CNET_CODE 테이블 SUP_CD = 100872)
     */
    private String relClassCd;

    /**
     * 등록_일시
     */
    private Date regDtm;

    /**
     * 승인_상태_코드(CNET_CODE 테이블 SUP_CD = 101025)
     */
    private String authStatCd;

    /**
     * AUTH_DTM
     */
    private Date authDtm;

}

