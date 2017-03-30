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
public class MbrProfInfo implements Serializable {

    private static final long serialVersionUID = -4915293391867313727L;

    /** 회원번호 */
    private String mbrNo;

    /** 제목 */
    private String title;

    /** 소개 정보 */
    private String intdcInfo;

    /** 학력 정보 */
    private String schCarInfo;

    /** 경력 정보 */
    private String careerInfo;

    /** 수상 정보 */
    private String awardInfo;

    /** 저서 정보 */
    private String bookInfo;

    /** 변경 일시 */
    private Date chgDtm;

}
