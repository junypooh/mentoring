/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ClasSetHist
 *
 * 수업설정정보
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-23 오후 5:25
 */
@Data
public class ClasSetHist {

    /**
     * 수업설정정보 이력번호
     */
    private Integer histSer;

    /**
     * 최대 신청수
     */
    private Integer maxApplCnt;

    /**
     * 최대 참관수
     */
    private Integer maxObsvCnt;

    /**
     * 설정 변경사유
     */
    private String setDescSust;

    /**
     * 등록일
     */
    private Date regDtm;

    /**
     * 등록자 아이디
     */
    private String regMbrNo;
}
