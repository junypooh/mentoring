/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.apache.commons.lang3.StringUtils;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectReqInfo
 *
 * 수업요청정보 Domain
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-21 오후 3:02
 */
@Data
public class LectReqInfo extends Base{

    /**
     * 요청_일련번호
     */
    private Integer reqSer;

    /**
     * 요청_회원_번호
     */
    private String reqMbrNo;

    /**
     * 대상_직업_코드
     */
    private String targtJobNo;

    /**
     * 대상_회원_번호
     */
    private String targtMbrNo;

    /**
     * 교실_일련번호
     */
    private String clasRoomSer;

    /**
     * 강의_제목
     */
    private String lectTitle;

    /**
     * 강의_내용
     */
    private String lectSust;

    /**
     * 학교_구분_코드
     */
    private String schClassCd;

    /**
     * 등록_일시
     */
    private Date reqDtm;

    /**
     * 수업요청시간정보
     */
    private List<LectReqTimeInfo> lectReqTimeInfoDomain;

    /**
     * 수업요청시간정보
     */
    private List<String> lectReqTimeInfo;

    /**
     * 수업요청날짜 정보
     */
    private List<String> lectReqDayInfo;

    /**
     * 강의요청날짜
     */
    private String lectPrefDay;

    /**
     * 수업요청코드
     */
    private String reqStatCd;

    /**
     * 요청수업유형
     */
    private String lectureRequestType;

    /**
     * 요청 지정한 직업명
     */
    private String targtJobNm;

    /**
     * 요청 지정한 멘토명
     */
    private String targtMbrNm;

    /**
     * 학교구분코드명
     */
    private String schClassCdNm;

    /**
     * 학교명
     */
    private String schNm;

    /**
     * 요청자명
     */
    private String reqMbrNm;

    /**
     * 솔루션_종류_코드
     */
    private String solKindCd;

    /**
     * 솔루션_업체_전화번호
     */
    private String solCoTel;

    private String reqTypeCd;

    private Integer fileSer;

    private Integer fileSize;

    private String oriFileNm;

    private String authStatCd;

    private String procSust;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date procDtm;

    private String procMbrNo;

    private String procMbrNm;

    private String procCoNm;

    private String openYn;

    private String useYn;

    private Integer vcnt;

    private String mbrNo;

    private String coNo;

    private String mbrCualfCd;

    private Integer applCnt;

    private Integer rjtCnt;

    private Integer apprCnt;

    private Integer totCnt;


    /**
     *  수업개설신청 승인 상태코드명
     */
    private String authStatCdNm;

    /**
     *  수업개설신청 요청 조회 시작일
     */
    private String searchStDate;

    /**
     *  수업개설신청 요청 조회 종료일
     */
    private String searchEndDate;

}
