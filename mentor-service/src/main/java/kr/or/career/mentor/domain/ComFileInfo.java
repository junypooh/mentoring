/* license */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.util.Date;

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
public class ComFileInfo {
    private Integer fileSer;
    private String fileNm;
    private String filePath;
    private Integer fileSize;
    private String fileExt;
    private String oriFileNm;
    private Integer dwCnt;
    private String useYn;
    private Date regDtm;
    private String regMbrNo;
    private Date chgDtm;
    private String chgMbrNo;
    private CommonsMultipartFile file;
}
