/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    McInfo
 *
 * MC 정보 Domain
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-18 오후 5:12
 */
@Data
public class McInfo extends Base{

    /**
     * MC_번호
     */
    private String mcNo;

    /**
     * MC_명
     */
    private String mcNm;

    /**
     * 소속_업체_번호
     */
    private String posCoNo;

    /**
     * 스튜디오_번호
     */
    private String stdoNo;

    /**
     * 연락_전화번호
     */
    private String contTel;

    /**
     * 사용여부
     */
    private String useYn;

    /**
     * 등록_일시
     */
    private Date regDtm;

    /**
     * 등록_회원_번호
     */
    private String regMbrNo;

    private String regMbrNm;

    private String regMbrCoNm;

    /**
     * 스튜디오 Domain
     */
    private StdoInfo stdoInfoDomain;

    /**
     * 회원정보 Domain
     */
    private User userDomain;

    /**
     * 수업일정정보 Domain
     */
    private LectSchdInfo lectSchdInfoDomain;

    /**
     * 목록번호
     */
    private String no;

    /**
     * 소속기업
     */
    private String mngrPosNm;

    /**
     * 성별코드
     */
    private String genCd;

}

