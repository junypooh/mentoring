package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    CompLectInfoDTO
 *
 * 완료된 수업정보 Domain
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-11-05 오후 17:38
 */
@Data
public class CompLectInfoDTO extends Base {

    private Integer lectSer;
    private Integer lectTims;
    private Integer schdSeq;
    private String lectDay;
    private String lectStartTime;
    private String lectEndTime;
    private String jobNm;
    private String mentorMbrNo;
    private String mentorNm;
    private String lectTitle;

    /* 조회용 */
    private String searchKey;
    private String searchWord;
    private String searchLectType;
    private String clasStartDay;
    private String clasEndDay;

}
