/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dto
 *    LectureApplInfoDTO
 *
 * 나의수업정보 DTO
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-10-01 오후 6:51
 */
@Data
public class LectureApplInfoDTO extends Base {

    /**
     * 강의소개 정보
     */
    private String lectIntdcInfo;

    /**
     * 강의내용 정보
     */
    private String lectSustInfo;

    /**
     * 강의 최대신청수
     */
    private Integer maxApplCnt;

    /**
     * 강의 최대참관수
     */
    private Integer maxObsvCnt;

    /**
     * 강의요청 일련번호
     */
    private Integer lectReqSer;

    /**
     * 강의 신청 가능횟수/강의최대 신청수
     */
    private double applCnt;

    /**
     * 강의 일련번호
     */
    private Integer lectSer;
    /**
     * 강의 유형코드
     */
    private String  lectTypeCd;

    /**
     * 강의 유형이름
     */
    private String  lectTypeNm;

    /**
     * 강의 대상코드
     */
    private String  lectTargtCd;

    /**
     * 강의제목
     */
    private String  lectTitle;

    /**
     * 요청수업 제목
     */
    private String  reqLectTitle;

    /**
     * 강의 시작일자
     */
    private String  lectStartDtm;

    /**
     * 강의 종료일자
     */
    private String  lectEndDtm;

    /**
     * 멘토 회원번호
     */
    private String  lectrMbrNo;

    /**
     * 멘토 이름
     */
    private String  lectrNm;

    /**
     * 멘토 직업코드
     */
    private String  lectrJobNo;

    /**
     * 멘토 직업명
     */
    private String  lectrJobNm;

    /**
     * 멘토 사진경로
     */
    private String  lectPicPath;

    /**
     * 강의 개요정보
     */
    private String  lectOutlnInfo;

    /**
     * 강의 차수
     */
    private Integer lectTims;

    /**
     * 강의 상태코드
     */
    private String  lectStatCd;

    /**
     * 강의 상태이름
     */
    private String  lectStatNm;

    /**
     * 강의 일정순서
     */
    private Integer schdSeq;

    /**
     * 강의 날짜
     */
    private String  lectDay;

    /**
     * 강의 시작시간
     */
    private String  lectStartTime;

    /**
     * 강의 종료시간
     */
    private String  lectEndTime;

    /**
     * MC번호
     */
    private String  mcNo;

    /**
     * 스튜디오 번호
     */
    private String  stdoNo;

    /**
     * 강의 취소사유
     */
    private String  lectCnclRsnSust;

    /**
     * 교실번호
     */
    private Integer clasRoomSer;

    /**
     * 강의신청 교사일련번호
     */
    private String  applMbrNo;

    /**
     * 강의신청 교사이름
     */
    private String  applMbrNm;

    /**
     * 설정일련번호
     */
    private Integer setSer;

    /**
     * 강의 신청 상태코드
     */
    private String  applStatCd;

    /**
     * 강의 신청 상태코드명
     */
    private String applStatNm;
    /**
     * 나의수업 수업유형별 갯수
     */
    private String lectCnt;

    /**
     * 수업유형별 종류명
     */
    private String lectCntStatCd;

    /**
     * 강의요청 일련번호
     */
    private Integer reqSer;

    /**
     * 강의 희망날짜
     */
    private String lectPrefDay;

    /**
     * 강의 희망시간
     */
    private String lectPrefTime;

    /**
     * 요청수업 시간정보 리스트
     */
    private List<LectureApplInfoDTO> myLecutureReqTimeList;

    /**
     * 신청시간
     */
    private String regDtm;

    /**
     * 교실이름
     */
    private String clasRoomNm;

    /**
     * 학교명
     */
    private String schNm;

    /**
     * 학교번호
     */
    private String schNo;

    /**
     * 요청수업상태코드
     */
    private String reqStatCd;

    /**
     * 요청수업상태코드
     */
    private String reqStatCdNm;

    /**
     * 강의 참관수
     */
    private Integer obsvCnt;

    private String lectStatCdNm;

    private String lectSessId;

    /*101542    수업요청*/
    private String st101542;
    /*101543    수강모집*/
    private String st101543;
    /*101544    모집마감*/
    private String st101544;
    /*101545    모집실패*/
    private String st101545;
    /*101545    모집취소요청*/
    private String st101546;
    /*101545    모집취소*/
    private String st101547;
    /*101548    수업예정*/
    private String st101548;
    /*101549    수업대기*/
    private String st101549;
    /*101550    수업중*/
    private String st101550;
    /*101551    수업완료*/
    private String st101551;
    /*101551    수업취소요청*/
    private String st101552;
    /*101553    수업취소*/
    private String st101553;
    /*101562    승인반려*/
    private String st101662;
    /*101575    수업신청대기*/
    private String st101575;
    /*101575    수업승인*/
    private String st101576;
    /*101575    수업배치확정*/
    private String st101577;
    /*101575    수업신청취소*/
    private String st101578;

    /**
     * 다시보기 동영상유무
     */
    private Integer replayCnt;

    //반 권한 정보
    private String clasRoomCualfCd;

    //요청수업 지정 직업명
    private String targtJobNm;

    //요청수업 지정 멘토명
    private String targtMentorNm;

    /**
     * 강의 신청 구분값 (신청 /참관)
     */
    private String  applClassCd;

    private String applClassNm;

    private double lectureCnt;

    /**
     * 강의진행시간(MI)
     */
    private String lectRunTime;

    /**
     * 참관차감에 대한 복구 수
     */
    private double withdrawCnt;

    private String grpNm;
}
