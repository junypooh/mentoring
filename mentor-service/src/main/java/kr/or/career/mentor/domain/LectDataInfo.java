package kr.or.career.mentor.domain;

import lombok.Data;

import java.io.File;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      LectDataInfo
 *
 * 멘토,수업 자료관련 DTO
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-20 오후 6:24
 */
@Data
public class LectDataInfo extends Base{

    /** 자료일련번호 */
    private Integer dataSer;

    /** 자료명 */
    private String dataNm;

    /** 멘토 MBR_NO */
    private String ownerMbrNo;

    /** 멘토 명 */
    private String ownerMbrNm;

    /** 자료대상 */
    private String dataTargtClass;

    /** 자료유형 */
    private String dataTypeCd;

    /** 자료유형명 */
    private String dataTypeCdNm;

    /** 파일일련번호 */
    private Integer fileSer;

    /** 게시글일련번호 */
    private Integer arclSer;

    /** 게시글구분ID */
    private String boardId;

    /** 링크URL */
    private String dataUrl;

    /** 링크제목 */
    private String linkTitle;

    /** 사용유무 */
    private String useYn;

    /** 자료소개여부[자료구분으로 사용 (Y : 멘토자로, N: 수업자료)] */
    private String intdcDataYn;

    /** 자료소개여부[자료구분으로 사용 (Y : 멘토자로, N: 수업자료)] */
    private String intdcDataNm;

    /** 등록일 */
    private String regDtm;

    /** 등록자 일련번호*/
    private String regMbrNo;

    /** 등록자*/
    private String regMbrNm;

    /** 수정일 */
    private String chgDtm;

    /** 수정자일련번호 */
    private String chgMbrNo;

    /** 수정자 */
    private String chgMbrNm;

    /** 강의일련번호 */
    private Integer lectSer;

    /** 직업명 */
    private String jobNm;

    /** 회원자격코드 [101501: 교육수행기관, 그외: 멘토] */
    private String mbrCualfCd;

    /** 업체번호 */
    private String posCoNo;

    /** 연결수업수 */
    private Integer connectLect;

    /** 검색조건 */
    private String searchWord;
    private String searchKey;

    /** 자료대상 검색조건 학교급 */
    private String schoolGrd;

    /** 자료대상 검색조건 학교급(기타) */
    private String schoolEtcGrd;

    /** 검색조건 자료 대상 리스트 */
    private List<String> schoolGrdExList;

    /** 강의날짜 */
    private String lectDay;

    /** 강의제목 */
    private String lectTitle;

    /** 강의시작시간 */
    private String lectStartTime;

    /** 강의종료시간 */
    private String lectEndTime;

    /** 동영상정보 ID */
    private String cntntsId;

    /** 컨텐츠 API 경로 */
    private String cntntsApiPath;

    /** 동영상 재생시간 */
    private String cntntsPlayTime;

    /** 동영상 썸네일 경로 */
    private String cntntsThumbPath;

    private ComFileInfo comFileInfo;

    /** 파일사이즈 */
    private Integer fileSize;

    /** 파일명 */
    private String oriFileNm;

    /** 자료대상명 */
    private String dataTargtClassNm;

    /** 관리자포털 여부 */
    private String adminYn;

    /** 게시글번호 배열*/
    private String[] dataSers;

    /** 회원일련번호 */
    private String mbrNo;

    /** 강사명 */
    private String lectrNm;

    /** 파일확장자 */
    private String fileExt;

    /** 기타자료 구분 (기타자료 : etcData) */
    private String dataType;

    /** 자료유형명 */
    private String dataTypeNm;

    /** 자료내용 */
    private String dataSust;

    /** 동영상제목 */
    private String fileTitle;



}
