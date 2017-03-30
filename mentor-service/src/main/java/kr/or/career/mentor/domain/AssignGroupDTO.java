/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    AssignGroupDTO.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 23. 오전 11:23:36
 * @author  technear
 * @see
 */
@Data
public class AssignGroupDTO extends Base{
    private String grpNo;
    private String coNm;
    private String instMbrNo;
    private String grpNm;
    private String grpDesc;
    private String setSer;
    private String setTargtCd;
    private String setTargtNm;
    private String setTargtNo;
    private String clasCnt;
    private String clasStartDay;
    private String clasEndDay;
    /**
     * 수업허용횟수
     */
    private Integer clasPermCnt;

    /**
     * 수업신청횟수
     */
    private Integer clasApplCnt;
    private Date regDtm;
    private String regMbrNo;
}
