package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      MbrNotiInfo
 *
 * 회원알린정보
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-07-27 오후 5:46
 */
@Data
public class MbrNotiInfo extends Base{

    /** 회원일련번호 */
    public String mbrNo;

    /** 알림일련번호 */
    public Integer notifSer;

    /** 알림확인여부(Y, N) */
    public String notifVerfYn;

    /** 알림확인여부(미확인, 확인) */
    public String notifVerfNm;

    /** 알림유형코드 */
    public String notifTypeCd;

    /** 알림유형명 */
    public String notifTypeNm;

    /** 알림메세지 */
    public String notifMsg;

    /** 알림등록일 */
    public Date regDtm;

    /** 알림등록자 */
    public String regMbrNo;

    /** 알림분류코드 */
    public String notifClsfCd;

    /** 알림분류명 */
    public String notifClsfNm;

    /** 알림확인일 */
    public String notifVerfDtm;

    /** 알림제목 */
    public String notifTitle;

    /** 강의일련번호 */
    public Integer lectSer;

    /** 강의거부사유내용 */
    public String lectRjctRsnSust;

    /** 검색시작날짜 */
    private String searchStDate;

    /** 검색종료날짜 */
    private String searchEndDate;

    /** 알림일련번호 배열 */
    public String[] notifSers;




}
