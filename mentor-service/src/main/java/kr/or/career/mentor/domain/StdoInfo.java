/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    StdoInfo
 *
 * 스튜디오 정보 Domain
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-18 오후 5:12
 */
@Data
public class StdoInfo extends Base{

    /**
     * 스튜디오_번호
     */
    private String stdoNo;

    /**
     * 스튜디오_명
     */
    private String stdoNm;

    /**
     * 층_이름
     */
    private String florNm;

    /**
     * 장소_이름(화면에서의 부가정보라는 항목)
     */
    private String plcNm;

    /**
     * 시도_코드
     */
    private String sidoCd;
    private String sidoNm;

    /**
     * 시도_코드명
     */
    private String sidoCdNm;

    /**
     * 시군구_코드
     */
    private String sgguCd;
    private String sgguNm;

    /**
     * 읍면동_코드
     */
    private String umdngCd;
    private String umdngNm;

    /**
     * 우편번호
     */
    private String postCd;

    /**
     * 소재지_주소
     */
    private String locaAddr;
    private String locaDetailAddr;

    /**
     * 실내_여부
     */
    private String indrYn;

    /**
     * 실내_여부
     */
    private String indrYnNm;

    /**
     * 소속_업체_번호
     */
    private String posCoNo;

    private String posCoNm;

    /**
     * 대표_전화번호
     */
    private String repTel;

    /**
     * 담당자_이름
     */
    private String chrgrNm;

    /**
     * 사용_여부
     */
    private String useYn;

    /**
     * 사용_여부
     */
    private String useYnNm;

    /**
     * 등록_일시
     */
    private Date regDtm;

    /**
     * 등록_회원_번호
     */
    private String regMbrNo;

    private String regMbrNm;

    private String regMbrCoNm;

    /**
     * MC정보 Domain
     */
    private McInfo mcInfoDomain;

    /**
     * 회원정보 Domain
     */
    private User userDomain;

    /**
     * 수업일정정보 Domain
     */
    private LectSchdInfo lectSchdInfoDomain;

    /**
     * 목록번호
     */
    private String no;

    private int relCnt;

    private String lectDay;

    private String lectStartTime;

    private String lectEndTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date searchStDate;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date searchEndDate;

    private String lectSer;


}

