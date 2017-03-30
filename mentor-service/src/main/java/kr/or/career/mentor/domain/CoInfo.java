/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    CoInfo
 *
 * 업체정보 Domain
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-15 오후 2:37
 */
@Data
public class CoInfo extends Base{

    /**
     * 업체_번호
     */
    private String coNo;

    /**
     * 업체_이름
     */
    private String coNm;

    private String coMbrNo;
    private String coMbrNm;

    /**
     * 업체_구분_코드
     */
    private String coClassCd;
    private String coClassNm;

    /**
     * 우편번호
     */
    private String postCd;

    /**
     * 소재지_주소
     */
    private String locaAddr;
    private String locaDetailAddr;

    /**
     * 전화번호
     */
    private String tel;

    /**
     * 팩스번호
     */
    private String fax;

    /**
     * 사업자등록번호
     */
    private String bizno;

    /**
     * 담당자 이름
     */
    private String mngrNm;

    /**
     * 사용(활동)여부
     */
    private String useYn;

    /**
     * 등록자
     */
    private String regMbrId;
    private String regMbrNm;

    private Date regDtm;
    private String regMbrNo;
    private String chgMbrNo;

    /**
     * 검색 조건 날짜
     */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDtmBegin;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDtmEnd;



}

