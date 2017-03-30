package kr.or.career.mentor.domain;

import java.io.Serializable;
import java.util.Date;

import lombok.Data;

/**
 * 멘토 관리를 위한 VO 클래스
 * @author
 * @since
 * @version 1.0
 * @see
 *
 */

@Data
public class MbrProfPicInfo implements Serializable {

    private static final long serialVersionUID = -969378740815356562L;

    /** 사진 일련번호 */
    private Integer picSer;

    /** 파일 일련번호 */
    private Integer fileSer;

    /** 회원번호 */
    private String mbrNo;

    /** 등록일시 */
    private Date regDtm;

}
