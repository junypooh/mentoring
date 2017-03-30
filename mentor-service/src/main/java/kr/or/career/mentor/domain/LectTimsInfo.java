package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectInfo
 *
 * 강의차수정보 Domain
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-16 오전 11:38
 */
@EqualsAndHashCode(callSuper = false)
@Data
@Alias("LectTimsInfo")
public class LectTimsInfo extends Base{

    private static final long serialVersionUID = -7283095803089966300L;
    /**
     * 강의일련변호
     */
    private Integer lectSer;

    /**
     * 강의차수
     */
    private Integer lectTims;

    /**
     * 강의차수
     */
    private String lectTitle;

    /**
     * 강의 상태코드
     */
    private String lectStatCd;

    /**
     * 강의 상태명
     */
    private String lectStatCdNm;

    /**
     * 등록일시
     */
    private Date regDtm;

    /**
     * 등록자 아이디
     */
    private String regMbrNo;

    /**
     * 강의일정정보 조인
     */
    private List<LectSchdInfo> lectSchdInfo;

    /**
     * 강의정보 조인
     */
    private LectInfo lectInfo;

    /**
     * 일시수업에 대한 신청정보
     */
    private List<LectApplInfo> lectApplInfos;

    /**
     *  일시수업 최초 수업일시간
     */
    private String lectDayTime;

    /**
     * 일정순서
     */
    private Integer schdSeq;

    /**
     * 노출 여부
     */
    private String expsYn;

    /**
     * 취소 사유
     */
    private String lectCnclRsnSust;

    /**
     * 취소 등록자 번호
     */
    private String cnclMbrNo;

    /**
     * 취소 등록자명
     */
    private String cnclMbrNm;

    /**
     * 취소 등록자 업체명
     */
    private String cnclCoNm;

    /**
     * 강사 회원번호
     */
    private String lectrMbrNo;

    /**
     * 취소 등록날짜
     */
    private String cnclDtm;

    /**
     * 수업 차감 횟수
     */
    private double lectureCnt;

    /**
     * 수업 신청 최대횟수
     */
    private Integer maxApplCnt;

    /**
     * 수업 참관 최대횟수
     */
    private Integer maxObsvCnt;

    /**
     * 수업 신청 횟수
     */
    private Integer applCnt;

    /**
     * 수업 참관 횟수
     */
    private Integer obsvCnt;

    /**
     * 수업 신청 정보 상태
     */
    private String applStatCd;

    /**
     * 팝업 취소사유 타입 (취소사유 수정 or 취소 등록)
     */
    private String cnclSustType;

    /**
     * 반 번호
     */
    private Integer clasRoomSer;

    private Integer appliedCnt;

}
