package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      ActivityMentorInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-21 오후 3:40
 */
@Data
public class ActivityMentorInfo extends Base {

    private String mbrNo;

    private String nm;

    private String jobNm;

    private String lectTitle;

    private String lectDay;

    private String lectStartTime;

    private Integer lectSer;

    private Integer lectTims;

    private Integer schdSeq;

    private String clsfCd;

    private String searchKey;

    private Integer profFileSer;

    private String recomTargtCd;

    private String jobClsfNm;

    private String intdcInfo;
}
