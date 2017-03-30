/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.dto
 *    LectureInfomationDTO
 *
 * 수업정보관련 DTO
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-24 오전 11:36
 */
@Data
public class LectureInfomationDTO extends Base{

    /**
     * 학교_번호
     */
    private String schNo;

    /**
     * 학교_이름
     */
    private String schNm;

    /**
     * 학교_이름
     */
    private String schoolNm;

    /**
     * 학교급
     */
    private String schClassCd;

    /**
     * 학교급명
     */
    private String schClassCdNm;

    /**
     * 학교_지역(시,도)명
     */
    private String sidoNm;

    /**
     * 학교_지역(시,군, 구)명
     */
    private String sgguNm;

    /**
     * 교실_일련번호
     */
    private Integer clasRoomSer;

    /**
     * 교실_이름
     */
    private String clasRoomNm;

    /*
     * 교실에 등록된 인원
     */
    private Integer clasPersonCnt;

    /**
     * 교사_회원_번호
     */
    private String tchrMbrNo;

    /**
     * 교사_회원_이름
     */
    private String tchrNm;

    /**
     * 교사_이메일주소
     */
    private String tchrEmailAddr;

    /**
     * 교사_전화번호
     */
    private String tchrMobile;

    /**
     * 수업명
     */
    private String lectTitle;

    /**
     * 수업강사이름
     */
    private String lectrNm;

    /**
     * 수업일
     */
    private String lectDay;

    /**
     * 수업_시작_시간
     */
    private String lectStartTime;

    /**
     * 수업_종료_시간
     */
    private String lectEndTime;

    /**
     * 학생수
     */
    private Integer stdntCnt;

    /**
     * 수업신청상태가 신청상태인 신청정보건수
     */
    private Integer applyCnt;

    /**
     * 수업신청상태가 승인상태인 신청정보건수
     */
    private Integer authorityCnt;

    /**
     * 수업신청상태가 확정상태인 신청정보건수
     */
    private Integer confirmationCnt;

    /**
     * 수업신청상태가 취소상태인 신청정보건수
     */
    private Integer cancelCnt;

    /**
     * 교사가 부여한 수업에 대한 평점
     */
    private Double teacherRating;

    /**
     * 학생이 부여한 수업에 대한 평점
     */
    private Double studentRating;

    /**
     * 교사가 부여한 수업에 대한 평점(별표시 이미지파일에 사용)
     */
    private String imgTeacherRating;

    /**
     * 학생이 부여한 수업에 대한 평점(별표시 이미지파일에 사용)
     */
    private String imgStudentRating;

    /**
     * 수업일련번호
     */
    private Integer lectSer;

    /**
     * 수업차수
     */
    private Integer lectTims;

    /**
     * 수업일정순번
     */
    private Integer schdSeq;

    /**
     * 수업소개글
     */
    private String lectIntdcInfo;

    /**
     * 수업멘토회원번호
     */
    private String lectrMbrNo;

    /**
     * 수업직업번호
     */
    private String lectrJobNo;

    /**
     * 수업대상코드
     */
    private String lectTargtCd;

    /**
     * 수업대상코드
     */
    private String lectTargtCdNm;

    /**
     * 수업상태코드
     */
    private String lectStatCd;

    /**
     * 수업상태코드명
     */
    private String lectStatCdNm;

    /**
     * 등록일시
     */
    private Date regDtm;

    /**
     * 컨텐츠ID
     */
    private String cntntsId;

    private String arclSer;

    /**
     * 수업시간
     */
    private String lectureTime;

    /**
     * 수업상탴코드
     */
    private String lectTypeCd;

    /**
     * 수업상태코드명
     */
    private String lectTypeCdNm;

    /**
     * 수업신청디바이스 카운트
     */
    private Integer applCnt;

    /**
     * 수업신청/참관 구분값
     */
    private String applClassCd;

    /**
     * 수업신청/참관 구분값
     */
    private String applClassCdNm;

    /**
     * 참관신청디바이스 카운트
     */
    private Integer obsvCnt;

    /**
     * 수업대기디바이스 카운트
     */
    private Integer stdByCnt;

    /**
     * 수업횟수
     */
    private Integer lectureCnt;

    /**
     * 수업사진
     */
    private String lectPicPath;

    /**
     * 총수업참여일수
     */
    private Integer totalLectDay;

    /**
     * 총수업횟수
     */
    private Integer totalLectCnt;

    /**
     * 수업정보
     */
    private List<LectSchdInfo> lectSchdInfoList;

    /**
     * 번호
     */
    private Integer no;

    /**
     * 기업멘토의 회원번호
     */
    private String companyMbrNo;

    /**
     * 기업멘토의 소속업체번호
     */
    private String companyPosCoNo;

    /**
     * 기업멘토의 소속업체명
     */
    private String companyCoNm;

    /**
     * 그룹관리자(교육청담당자)의 회원번호
     */
    private String groupMbrNo;

    /**
     * 그룹관리자(교육청담당자)의 소속업체(교육청)번호
     */
    private String groupPosCoNo;

    /**
     * 기업멘토의 상위 관리자가 그룹관리자(교육청담당자)일 경우만 화면에 표시
     */
    private String groupCoNm;

    /**
     * 교육 수행기관
     */
    private String coNm;

    private List<LectureInfomationDTO> lectureInfomationDTOList;

    /**
     * 직업명
     */
    private String jobNm;

    /**
     * 전체 건수
     */
    private Integer totalCnt;

    /**
     * 수업모집 건수
     */
    private Integer recruitmentCnt;

    /**
     * 수업예정 건수
     */
    private Integer preordinationCnt;

    /**
     * 수업대기 건수
     */
    private Integer waitingCnt;

    /**
     * 수업중 건수
     */
    private Integer progressCnt;

    /**
     * 수업완료 건수
     */
    private Integer completeCnt;

    /**
     * 회원 자격구분
     */
    private String mbrCualfCd;

    /**
     * 최대_신청_수
     */
    private Integer maxApplCnt;

    /**
     * 최대_참관_수
     */
    private Integer maxObsvCnt;

    /**
     * 특징분류
     */
    private String jobCtg0;

    /**
     * 1차직종
     */
    private String jobCtg1;

    /**
     * 2차직종
     */
    private String jobCtg2;

    /**
     * 3차직종
     */
    private String jobCtg3;

    /**
     * 스튜디오명
     */
    private String stdoNm;

    /**
     * MC명
     */
    private String mcNm;

    /**
     * 기업멘토회원번호
     */
    private String groupCoNo;

    /**
     * 설정 일련번호
     */
    private Integer setSer;

    /**
     * 그룹 일련번호
     */
    private String grpNo;

    /**
     * 배정그룹명
     */
    private String grpNm;

    /**
     * 수업상태현황 카운트
     */
    private String lectStatCnt;

    /**
     * 특징분류명
     */
    private String lectJobClsfNm;


    /**
     * 통계 멘토카운트
     */
    private Integer mentorCnt;

    /**
     * 1뎁스
     */
    private String lev1;

    /**
     * 2뎁스
     */
    private String lev2;

    /**
     * 3뎁스
     */
    private String lev3;

    /**
     * 통계초등
     */
    private int tc101534;

    /**
     * 통계중등
     */
    private int tc101535;

    /**
     * 통계고등
     */
    private int tc101536;

    /**
     * 통계초등중등
     */
    private int tc101537;

    /**
     * 통계초등고등
     */
    private int tc101538;

    /**
     * 통계중등고등
     */
    private int tc101539;

    /**
     * 통계초등중등고등
     */
    private int tc101540;

    /**
     * 통계 초등학교
     */
    private int elementarySchool;

    /**
     * 통계 중학교
     */
    private int middleSchool;

    /**
     * 통계 고등학교
     */
    private int highSchool;

    /**
     * 총 수업
     */
    private int totalLect;

    /**
     * 수업소계
     */
    private int subTotalLect;

    /**
     * 신청상태코드
     */
    private String applStatCd;

    /**
     * 등록일시
     */
    private String applRegDtm;

    /**
     * 노출 여부
     */
    private String expsYn;

    /** 직업계층구조 */
    private String jobStruct;

    private String cnclRsnSust;

    private String lectRunTime;

    /** 학교 참여 구분 **/
    private String joinClassNm;

    /** 장비 구분값 (욱성/웹캠) **/
    private String deviceTypeNm;

    /** 클래스 권한 정보 **/
    private String clasRoomCualfCdNm;
}

