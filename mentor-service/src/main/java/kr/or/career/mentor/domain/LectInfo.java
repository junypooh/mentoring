package kr.or.career.mentor.domain;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectInfo
 *
 * 강의정보 Domain
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-09-16 오전 11:38
 */
@Data
@Alias("LectInfo")
public class LectInfo extends Base{

    /**
     * 강의 일련번호
     */
    private Integer lectSer;

    /**
     * 강의 유형코드
     */
    private String lectTypeCd;

    /**
     * 강의 대상코드
     */
    private String lectTargtCd;

    /**
     * 강의 제목
     */
    private String lectTitle;

    /**
     * 강의 시작일자
     */
    private String lectStartDtm;

    /**
     * 강의 종료일자
     */
    private String lectEndDtm;

    /**
     * 멘토 회원번호
     */
    private String lectrMbrNo;

    /**
     * 멘토 이름
     */
    private String lectrNm;

    /**
     * 멘토 직업코드
     */
    private String lectrJobNo;

    /**
     * 멘토 사진경로
     */
    private String lectPicPath;

    /**
     * 강의 개요정보
     */
    private String lectOutlnInfo;

    /**
     * 강의소개 정보
     */
    private String lectIntdcInfo ;

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
     * 등록일시
     */
    private Date regDtm;

    /**
     *등록 회원 번호
     */
    private String regMbrNo;

    /**
     *등록 회원명
     */
    private String regMbrNm;

    /**
     * 변경일시
     */
    private Date chgDtm;

    /**
     * 변경 회원번호
     */
    private String chgMbrNo;

    /**
     * 변경 회원명
     */
    private String chgMbrNm;

    /**
     * 강의 사진정보
     */
    List<LectPicInfo> listLectPicInfo;

    /**
     * 강의 차수정보 조인
     */
    LectTimsInfo lectTimsInfo;

    /**
     * 강의 유형코드명
     */
    private String lectTypeCdNm;

    /**
     * 직업태그정보
     */
    private String jobTagInfo;

    /**
     * 아이콘 종류 코드 : 재능기부
     */
    private String iconKindCd;

    private List<MbrJobInfo> mbrJobInfo;

    /**
     * 삭제파일
     */
    private String delFileSer;

    /**
     * 등록 파일 정보
     */
    private String fileSer;

    /**
     * 삭제파일
     */
    private List<String> fileSerList;

    /**
     * 강의 차수정보 조인
     */
    List<LectTimsInfo> lectTimsInfoList;

    private int lectTimsCnt;

    /**
     * 복사수업 변수
     */
    private String copyLectSer;

    private String lectrJobNm;

    private String lectrJobClsfNm;

    /**
     * 수업차수 추가
     */
    private Integer lectTims;

    /**
     * 일정순서 추가
     */
    private Integer schdSeq;

    /**
     * Message를 받기위한 Mentor의 정보
     */
    private MessageReciever reciever;

    /**
     * 수업복사시 mbrNo
     */
    private String copyLectrMbrNo;

    /**
     * 강의상태코드
     */
    private String lectStatCd;

    /**
     * 강의상태코드명
     */
    private String lectStatCdNm;

    /**
     * 배정그룹 번호
     */
    private String lectGrpNo;

    /**
     * 배정그룹 셋팅 번호
     */
    private String setSer;

    /**
     * 배정그룹명
     */
    private String grpNm;

    /**
     * 수행 업체 번호
     */
    private String lectCoNo;

    /**
     * 수행기관명
     */
    private String coNm;

    /**
     * 등록자 소속명
     */
    private String regCoNm;

    /**
     * 수정자 소속명
     */
    private String chgCoNm;

    /**
     * 테스트 강의 여부
     */
    private char lectTestYn;
}
