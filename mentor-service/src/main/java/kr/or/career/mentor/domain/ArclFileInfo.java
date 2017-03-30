/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ArclFileInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 18. 오후 4:52:05
 * @author  technear
 * @see
 */
@Data
public class ArclFileInfo {
    private Integer arclSer;
    private String boardId;
    private Integer fileSer;
    private Date regDtm;
    private String regMbrNo;
    private FileInfo fileInfo;

    private ComFileInfo comFileInfo;
}
