/* license */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MngrRecomInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 14. 오전 9:07:44
 * @author  technear
 * @see
 */
@Data
public class MngrRecomInfo {
    private int recomSer;
    private String recomTargtCd;
    private String recomTargtNo;
    private int sortSeq;
    private String useYn = "Y";
    private String regDtm;
    private String regMbrNo;

}
