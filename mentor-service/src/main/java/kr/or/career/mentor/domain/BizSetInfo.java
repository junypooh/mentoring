/* license */
package kr.or.career.mentor.domain;

import java.util.Date;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    BizSetInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 12. 오후 1:57:07
 * @author  technear
 * @see
 */
@Data
public class BizSetInfo extends Base{
    private String setSer;
    private String setTargtCd;
    private String setTargtNm;
    private String setTargtNo;
    private String clasCnt;
    private String clasStartDay;
    private String clasEndDay;
    private Date regDtm;
    private String regMbrNo;
    private double clasEmpCnt;
    private String clasPermCnt;
    private String nm;
    private String grpNm;
    private String grpYn;
    private String coNm;

    private String clasRoomSer;
    private String applStatCd;




    private BizGrpInfo bizGrpInfo;
    private LectApplCnt lectApplCnt;
    private CoInfo coInfo;




}
