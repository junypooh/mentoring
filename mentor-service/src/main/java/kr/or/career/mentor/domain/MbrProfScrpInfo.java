package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MbrProfScrpInfo {

    /** 스크랩_일련번호 */
    private Long scrpSer;

    /** 회원_번호 */
    private String mbrNo;

    /** 스크랩_구분_코드 */
    private String scrpClassCd;

    /** 스크랩_제목 */
    private String scrpTitle;

    /** 스크랩_URL */
    private String scrpURL;

    /** 등록_일시 */
    private Date regDtm;

    // transient ==============
    /** 스크랩_구분_코드 명 */
    private String scrpClassCdNm;
}
