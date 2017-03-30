package kr.or.career.mentor.domain;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectInfo
 *
 * 강의일정정보 Domain
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-16 오전 11:38
 */
@Data
@Alias("LectSchdInfo")
public class LectSchdInfo extends Base {

    /**
     * 강의일련변호
     */
    private Integer lectSer;

    /**
     * 강의차수
     */
    private Integer lectTims;

    /**
     * 강의 일정순서
     */
    private Integer schdSeq;

    /**
     * 강의 제목
     */
    private String lectTitle;

    /**
     * 강의날짜(YYYYMMDD)
     */
    private String lectDay;

    /**
     * 강의시작시간(HH24MI)
     */
    private String lectStartTime;

    /**
     * 강의종료시간(HH24MI)
     */
    private String lectEndTime;

    /**
     * 강의진행시간(MI)
     */
    private String lectRunTime;

    /**
     * 강의 상태코드
     */
    private String lectStatCd;

    /**
     * MC번호
     */
    private String mcNo;

    /**
     * 스튜디오번호
     */
    private String stdoNo;

    /**
     * 강의취소 사유
     */
    private String lectCnclRsnSust;

    /**
     * 등록일시
     */
    private Date regDtm;

    /**
     * 등록자 아이디
     */
    private String regMbrNo;

    /**
     * 수정일시
     */
    private Date chgDtm;

    /**
     * 수정자 아이디
     */
    private String chgMbrNo;

    /**
     * 스튜디오 이름
     */
    private String stdoNm;

    /**
     * MC이름
     */
    private String mcNm;

    /**
     * 참관수
     */
    private Integer obsvCnt;

    /**
     * 교실일련번호 추가
     */
    private Integer clasRoomSer;

    /**
     * 강의차수정보 조인
     */
    LectTimsInfo lectTimsInfo;

    /**
     * 수업상태코드명
     */
    private String lectStatCdNm;

    /**
     * 수업신청기기수
     */
    private Integer applCnt;

    /**
     * 수업신청기기수
     */
    private String applClassCd;

    /**
     * 수업신청 max카운트
     */
    private Integer maxApplCnt;

    private Integer maxObsvCnt;

    private String lectSessId;

    /**
     * 수업 소요시간
     */
    private String lectureTime;

    /**
     * 회원구분
     */
    private String mbrClassCd;

    /**
     * 강의종류별 차감수
     */
    private Integer lectureCnt;

    /**
     * 강의 다시보기 게시글 일련번호
     */
    private Integer arclSer;

    /**
     * 멘토 회원번호
     */
    private String lectrMbrNo;

    /**
     * 강의 다시보기 cid
     */
    private Integer cntntsId;

    /**
     * 정원마감여부
     */
    private String lectStatCdDesc;

    /**
     * 강의 신청 디바이스 정렬
     */
    private String orderBy;


}
