package kr.or.career.mentor.domain;

import lombok.Data;

@Data
public class LectArclDTO extends Base {
    /**
     *
     */
    private static final long serialVersionUID = 1L;

    private Integer lectSer;
    private Integer lectTims;
    private Integer schdSeq;
    private String lectrMbrNo;
    private String lectrNm;
    private String lectTitle;
    private String lectDay;
    private String lectStartTime;
    private String lectEndTime;
    private int workCnt;

    /*
     * Search Value
     */
    private String searchStartDate;
    private String searchEndDate;
    private String lectTypeCd;
    private String lectTargtCd;
    private String searchKey;
    private String searchWord;

}
