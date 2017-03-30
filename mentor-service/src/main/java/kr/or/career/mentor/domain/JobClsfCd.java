package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

@Data
public class JobClsfCd {
    /** 코드 */
    private String cd;

    /** 상위_코드 */
    private String supCd;

    /** 코드_이름 */
    private String cdNm;

    /** 코드_설명 */
    private String cdDesc;

    /** 코드_분류_정보 */
    private String cdClsfInfo;

    /** 코드_레벨 */
    private Integer cdLv;

    /** 구_코드 */
    private String oldCd;

    /** 전시_순서 */
    private Integer dispSeq;

    /** 사용_여부 */
    private String useYn;

    /** 등록_일시 */
    private Date regDtm;

    /** 등록_회원_번호 */
    private String regMbrNo;

    /** 변경_일시 */
    private Date chgDtm;

    /** 변경_회원_번호 */
    private String chgMbrNo;

}
