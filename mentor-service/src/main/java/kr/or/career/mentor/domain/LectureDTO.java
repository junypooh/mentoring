package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class LectureDTO extends Base {

    /** 강사 회원 번호 */
    private String lectrMbrNo;

    /** 강사 회원 이름 */
    private String lectrMbrNm;

    /** 강의 제목 */
    private String lectTitle;

    /** 강의 소개정보 */
    private String lectIntdcInfo;

    /** 강의 대상 코드 */
    private String lectTargtCd;

    /** 강의 대상 코드 명 */
    private String lectTargtCdNm;

    /** 강의 상태 코드 */
    private String lectStatCd;

    /** 상의 상태 코드 명 */
    private String lectStatCdNm;

    /** 강의 일자 */
    private String lectDay;

    /** 강의 시작 시간 */
    private String lectStartTime;

    /** 강의 종료 시간 */
    private String lectEndTime;

    private String cntntsId;

    private String arclSer;

    private Integer lectSer;
    private Integer lectTims;
    private Integer schdSeq;
    private String lectTypeNm;
}
