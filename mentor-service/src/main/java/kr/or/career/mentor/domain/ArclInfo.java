/* license */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ArclInfo.java
 *
 * 게시판의 기능을 설명한다.
 *
 * </pre>
 *
 * @since 2015. 9. 18. 오후 4:43:45
 * @author technear
 * @see
 */
@Data
public class ArclInfo<T> extends Base {

    /**
     *
     */
    private static final long serialVersionUID = 1L;



    @ExcelFieldName(name="번호")
    Integer no;

    private Integer arclSer;
    private String boardId;
    private int supArclSer;
    @ExcelFieldName(name="제목")
    private String title;
    private String subTitle;
    private String prefNo;
    @ExcelFieldName(name="내용")
    private String sust;
    private String cntntsTargtCd;
    private int cntntsTargtNo;
    private String cntntsTargtId;
    private String cntntsTargtNm;
    private String cntntsTypeCd;
    private int cntntsId;
    private String cntntsSust;
    private String cntntsSmryInfo;
    private String cntntsDay;
    private String cntntsPlayTime;
    private String cntntsThumbPath;
    private String cntntsApiPath;
    @ExcelFieldName(name="조회수")
    private int vcnt;
    private int rcnt;
    private String recomYn;
    private String scrtArclYn;
    private String notiYn;
    private String mrArclYn;
    private String rssPubYn;
    private String useYn = "Y";
    @ExcelFieldName(name="등록일")
    private Date regDtm;
    private String regMbrNo;
    private Date chgDtm;
    private String chgMbrNo;
    private String chgMbrNm;
    @ExcelFieldName(name="답변일")
    private Date ansRegDtm;
    private String ansRegMbrNo;
    private Date ansChgDtm;
    private String ansChgMbrNo;
    private String expsTargtCd;
    private String expsTargtNm;
    private String cntntsTargtTims;
    private String cntntsTargtSeq;
    private String popupYn;

    private ArclInfo<T> ansArclInfo;

    private List<ArclFileInfo> listArclFileInfo;
    private Integer fileCnt;

    private List<ArclCmtInfo> listArclCmtInfo;

    private String dataTitle;
    private String dataType;

    /** 게시물 머릿글 명 */
    @ExcelFieldName(name="문의유형")
    private String prefNm;

    /** 사용자 정보 */
    private String regMbrId;
    @ExcelFieldName(name="작성자")
    private String regMbrNm;
    private String mbrClassCd;
    private String mbrClassNm;
    @ExcelFieldName(name="답변자")
    private String ansRegMbrNm;
    private String ansMbrClassCd;
    private String ansMbrClassNm;
    @ExcelFieldName(name="답변여부")
    private String ansYn;
    @ExcelFieldName(name="회원유형")
    private String mbrCualfNm;
    private String mbrCualfCd;

    /** 강의정보 */
    private String lectSer;
    private String lectTims;
    private String schdSeq;
    private String lectTitle;
    private String lectrMbrNo;
    private String lectrNm;
    private String lectTypeNm;
    private String lectTypeCd;
    private String lectDay;
    private String lectStartTime;
    private String lectEndTime;
    private String lectCoNo;
    private String lectRunTime;

    /** 사용자 직업 */
    private String jobNo;
    private String jobNm;

    /** 댓글 수 */
    private int cmtCount;
    /** 검색조건 */
    private String searchKey;
    /** 검색단어 */
    private String searchWord;
    /** 교사 여부 */
    private String teacherYn;
    /** 조회용 사용자 MbrNo */
    private String srchMbrNo;
    /** 조회용 멘토 MbrNo */
    private String srchMentorMbrNo;
    /** 조회용 검색일 */
    private String sStartDate;
    private String sEndDate;
    /** 검색용 직업 No */
    private String sJobNo;
    private List<String> sJobChrstcCds;
    /** 학교정보 */
    @ExcelFieldName(name="학교")
    private String schNm;
    @ExcelFieldName(name="지역")
    private String sidoNm;
    /** 반명 */
    private String clasRoomNm;

    private String clasRoomSer;

    /**
     * Query 호출 시 조회값으 구분을 위해 사용함. ArclInfoMapp.xml 에서 확인 후 사용 여부 결정. sMentorQnA
     * : 학교 포탈 > 멘토소개 > 문의하기 게시판 사용 mentorLecture : 멘토 포탈 > 수업 상세 > 수업문의 탭 페이지
     * sMyComm : 학교 포탈 > 마이커뮤니티 자신의 글만 필요할때 사용
     * 조회 조건 사용시 사용
     *
     **/
    private String siteGbn;
    private String qnaGbn;
    private String searchPeriod;
    private boolean dispNotice = true;
    private String fileSers;

    /** 신규 글 여부 */
    private String newYn;

    /** 작성자 학교명 */
    private String regSchNm;

    /** 멘토 학교명 */
    private String lectrSchNm;

    /** 게시글번호 배열*/
    private String[] arclSers;

    /** 문의하기 대상 멘토명 */
    private String mentorMbrNm;

    /** 공지사항 팝업 pixel*/
    private String popupWidth;
    private String popupHigh;

    private String regClassNm;

    private int fileTotalSize;

}