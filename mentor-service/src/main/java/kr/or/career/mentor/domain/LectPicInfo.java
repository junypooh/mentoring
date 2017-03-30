/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectPicInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 21. 오후 6:50:06
 * @author  technear
 * @see
 */
@Data
public class LectPicInfo {

    /**
     * 강의_일련번호
     */
    private Integer lectSer;

    /**
     * 파일_일련번호
     */
    private Integer fileSer;

    /**
     * 등록_일시
     */
    private Date regDtm;

    /**
     * 등록_회원_번호
     */
    private String regMbrNo;

    /**
     * 파일_정보
     */
    private FileInfo fileInfo;

    /**
     * 공통_파일_정보
     */
    private ComFileInfo comFileInfo;
}
