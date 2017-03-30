package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ArclInfo.java
 *
 * 게시판의 기능을 설명한다.
 *
 * </pre>
 *
 * @since 2015. 9. 18. 오후 4:43:45
 * @author technear
 * @see
 */
@Data
public class ArclCmtInfoRS extends ArclCmtInfo {
    private String cntntsTargtNo;
    private String lectTitle;
    private String lectrNm;
    private String regNm;

}
