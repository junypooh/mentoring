package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      MemberLectureInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-21 오후 3:16
 */
@Data
public class MemberLectureInfo extends Base {

    private Integer lectSer;
    private Integer lectTims;
    private Integer schdSeq;
    private String lectTypeCd;
    private String lectTypeNm;
    private String lectTitle;
    private String lectrNm;
    private String jobNm;
    private String lectDay;
    private String lectStartTime;
    private Integer lectRunTime;
    private String lectStatCd;
    private String lectStatNm;
    private String schNm;
    private String clasRoomNm;
    private Date regDtm;
    private String applStatCd;
    private String applStatNm;
    private String applClassCd;
    private String applClassNm;
}
