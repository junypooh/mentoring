/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectApplInfo
 *
 * 강의신청 Domain
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-16 오전 11:38
 */
@Data
public class LectApplInfo extends Base{

    /**
     * 강의_일련번호
     */
    private Integer lectSer;

    /**
     * 강의_차수
     */
    private Integer lectTims;

    /**
     * 교실_일련번호
     */
    private Integer clasRoomSer;

    /**
     *신청 회원번호
     */
    private String applMbrNo;

    /**
     * 대상_회원_번호
     */
    private String targtMbrNo;

    /**
     * 설정 일련번호
     */
    private Integer setSer;

    /**
     * 신청상태코드
     */
    private String applStatCd;

    /**
     * 등록_일시
     */
    private Date regDtm;

    /**
     * 등록회원번호
     */
    private String regMbrNo;

    /**
     * 수정일시
     */
    private Date chgDtm;

    /**
     * 수정회원번호
     */
    private String chgMbrNo;

    /**
     * 수강날짜
     */
    private String lectDay;

    /**
     * 강의차수정보
     */
    private LectTimsInfo lectTimsInfo;

    /**
     * 교실정보
     */
    private ClasRoomInfo clasRoomInfo;

    /**
     * 신청횟수차감
     */
    private double clasApplCnt;

    /**
     * 수업허용 횟수
     */
    private double clasPermCnt;

    /**
     * 수업유형코드
     */
    private String lectTypeCd;

    /**
     * 교실목록 리스트
     */
    List<ClasRoomRegReqHist> clasRoomList;

    /**
     * 회원자격구분코드
     */
    private String mbrClassCd;

    /**
     * 수업유형코드(리스트)
     */
    List<String> lectTypeList;

    /**
     * 수업요청 일련번호
     */
    private Integer reqSer;

    /**
     * 강의 일정순서
     */
    private Integer schdSeq;

    /**
     * 수업요청상태
     */
    private String reqStatCd;

    /**
     * 학교번호
     */
    private String schNo;

    /**
     * Message를 받기위한 신청자의 정보
     */
    private MessageReciever reciever;

    /**
     * 신청취소사유
     */
    private String cnclRsnSust;

    /**
     *신청 회원 아이디
     */
    private String applId;

    /**
     * 수업 신청/참관 구분값
     */
    private String applClassCd;


    //반 권한 정보
    private String clasRoomCualfCd;

    //수업 노출 여부
    private String expsYn;

    private String lectSessId;

    /**
     * 참관차감에 대한 복구 수
     */
    private double withdrawCnt;
}
