/* license */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.springframework.util.AutoPopulatingList;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    BizGrpInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 10. 12. 오후 2:15:36
 * @author  technear
 * @see
 */
@Data
public class BizGrpInfo extends Base{
    private String grpNo;
    private String instMbrNo;
    private String grpNm;
    private String grpYn;
    private String grpDesc;
    private String regDtm;
    private String regMbrNo;
    private String schNo;
    private String mbrClassCd;
    private Integer setSer;
    private double clasPermCnt;
    private Integer setChgSer;
    private String schChgClassCd;

    private String clasStartDay;
    private String clasEndDay;
    private Integer setChgSeq;
    private String nm;

    private Integer maxApplCnt;
    private Integer maxObsvCnt;


    private String coNo;






    private List<SchInfo> listSchInfo;

    public BizGrpInfo() {
        listSchInfo = new AutoPopulatingList(SchInfo.class);
    }
}

