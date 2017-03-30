/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectureSearch
 *
 * 수업검색조건 도메인
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-16 오후 3:36
 */
@Data
@Alias("LectureSearch")
public class LectureSearch extends Base{

    /**
     * 검색조건 시작날짜
     */
    private String searchStDate;

    /**
     * 검색조건 종료날짜
     */
    private String searchEndDate;

    /**
     * 검색조건 학교급
     */
    private String schoolGrd;

    /**
     * 검색조건 수강 대상 리스트
     */
    private List<String> schoolGrdExList;

    /**
     * 검색조건 학교급 기타 조회 여부
     */
    private String schoolEtcGrd;

    /**
     * 검색조건수업시간
     */
    private String lectTime;

    /**
     * 검색조건 수업유형
     */
    private String lectType;

    /**
     * 검색조건 키워드
     */
    private String keyword;

    /**
     * 검색조건 직업
     */
    private String lectrJob;

    /**
     * 탭검색조건 수업상태
     */
    private String lectStatCd;

    /**
     * 탭검색조건 수업명
     */
    private String lectTitle;

    /**
     * 탭검색조건 멘토명
     */
    private String lectrNm;

    /**
     * 검색조건 특징분류
     */
    private String jobChrstcCd;

    /**
     * 검색조건 시도코드
     */
    private String sidoCd;

    /**
     * 검색조건 지역(시/도)명
     */
    private String sidoNm;

    /**
     * 검색조건 지역(구/군)명
     */
    private String sgguNm;

    /**
     * 검색조건 스튜디오명
     */
    private String stdoNm;

    /**
     * 검색조건 카테고리 (MC관리 화면 검색조건 구분 : 전체, 스튜디오, 기업멘토)
     */
    private String category;

    /**
     * 검색조건 selectbox  : 전체, 오픈, 멘토지정, 직업지정
     */
    private String category1;

    /**
     * 검색조건 selectbox  : 전체, 수업, 직업, 멘토
     */
    private String category2;

    /**
     * 요청수업유형
     */
    private String lectureRequestType;

    /**
     * D-Day
     */
    private Integer dDay;

    /**
     * 수업일
     */
    private String lectDay;

    /**
     * 제외시킬 수업상태코드
     */
    private List<String> exceptLectStatCdList;

    /**
     * 검색조건 회원번호
     */
    private String mbrNo;

    /**
     * 검색조건 회원번호
     */
    private String lectMbrNo;

    /**
     * 검색조건 직업번호
     */
    private String jobNo;

    /**
     * 수업일련번호
     */
    private Integer lectSer;

    /**
     * 수업차수번호
     */
    private Integer lectTims;

    /**
     * 수업일정순서
     */
    private Integer schdSeq;

    /**
     * 컨텐츠대상코드
     */
    private String cntntsTargtCd;

    /**
     * 직업특성코드
     */
    private List<String> jobChrstcList;

    /**
     * 검색조건 선택
     */
    private String searchType;

    /**
     * 검색조건 입력값
     */
    private String searchKey;

    /**
     * 학교번호
     */
    private String schNo;

    /**
     * 학교명
     */
    private String schNm;


    /**
     * 교실번호
     */
    private String clasRoomSer;

    /**
     * 교실명
     */
    private String clasRoomNm;

    /**
     * 학교구분코드
     */
    private String[] schClassCds;

    /**
     * 기관(교육청)번호
     */
    private String coNo;

    /**
     * 요청상태코드
     */
    private String reqStatCd;

    /**
     * 회원_자격_코드
     */
    private String mbrCualfCd;

    /**
     * 소속멘토 회원번호 String[]
     */
    private String[] belongMentorMbrNoList;

    /**
     * 멘토구분
     */
    private String mentorType;

    /**
     * 오더바이 순서
     */
    private String orderBy;

    /**
     * 검색조건 강의날짜 목록
     */
    private List<String> lectDays = new ArrayList<>();

    /**
     * 검색조건 id
     */
    private String mbrId;

    /**
     * 검색조건 이름
     */
    private String mbrNm;

    /**
     * 회원구분
     */
    private String mbrType;

    /**
     * 특정 강의 상태 코드에 해당하는 강의 정보를 조회하기 위한 정보
     */
    private List<String> lectStatusCds;

    private String grpNo;
    private Integer setSer;

    private Integer listType;


    private String lectTestYn;

    /**
     * 노출 여부
     */
    private String expsYn;

    /**
     * 캘린더 기준 달(yyyymm)
     */
    private String thisMonth;

    /**
     * 캘린더 next or previous
     */
    private Integer calPreNxt;

    /**
     * mc명
     */
    private String mcNm;

    /**
     *  휴대전화
     */
    private String contTel;

    /**
     * 소속기업 명
     */
    private String mngrPosNm;


    /**
     * 사용유무
     */
    private String useYn;


    /**
     * 성별
     */
    private String genCd;


    /**
     * 배정사업 그룹명
     */
    private String grpNm;


    /**
     * 교육수행기관명
     */
    private String coNm;

    /**
     * 교육 신청/참관 구분코드
     */
    private String applClassCd;

    /**
     * 교육 신청 상태 코드
     */
    private String applStatCd;

    /**
     * 교육 신청/참관 구분코드
     */
    private String applMbrNm;

    /**
     * 소속_업체_번호
     */
    private String posCoNo;

    /**
     * 사용하는 화면 정보
     */
    private String viewType;


    /** 초성검색 */
    private String consonantsVal;

    /** 반권한정보 */
    private String clasRoomCualfCd;

    /** 세션정보 */
    private String lectSessId;

}
