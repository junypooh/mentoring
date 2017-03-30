/* license */
package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.ToString;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    BizGrpSearch.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 22. 오전 11:05:51
 * @author  technear
 * @see
 */
@Data
public class BizGrpSearch extends BizSetInfo{
    private String schNm;
    private String schNo;
    private String sidoNm;
    private String sgguNm;
    //private String grpNm;
    private String schClassCd;
    private String coNo;
    private String grpState;
    //private String grpYn;
    private String useYn;
    //private String coNm;
    private String schNoYn;
    private String grpNo;
    private String schMbrCualfCd;
    private String schCd;
    private String userId;



}
