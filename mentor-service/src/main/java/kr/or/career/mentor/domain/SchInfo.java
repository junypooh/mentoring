/* license */
package kr.or.career.mentor.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SchInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오전 9:38:56
 * @author technear
 * @see
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class SchInfo extends Base {

    /** 학교_번호 */
    private String schNo;

    /** 학교_이름 */
    private String schNm;

    /** 학교_구분_코드 */
    private String schClassCd;
    private String schClassNm;

    /** 시도_코드 */
    private String sidoNm;

    /** 시군구_코드 */
    private String sgguNm;

    /** 읍면동_코드 */
    private String umdngNm;

    /** 우편번호 */
    private String postCd;

    /** 소재지_주소 */
    private String locaAddr;
    /** 상세_주소 */
    private String locaDetailAddr;

    /** 연락_전화번호 */
    private String contTel;

    /** 사이트_URL */
    private String siteUrl;

    /** 설립_일자 */
    private String foundDay;

    private String reqDtm;

    private String mbrNo;

    private String useYn;

    /** 수강 사용횟수 */
    private String clasApplCnt;

    private String grpNo;

    private String setSer;

    //private List<BizSetInfo> listbizsetinfo;

    /** 디바이스유형(욱성, 웹캠) */
    private String deviceType;

    /** 디바이스유형(욱성, 웹캠) */
    private String deviceTypeCdNm;

    /** 참여구분 */
    private String joinClass;

    /** 참여구분 */
    private String joinClassCdNm;

    /**
     *  수업 허용 회숫
     */
    private double clasPermCnt;

    /**
     * 수업 회수
     */
    private Integer clasCnt;

    private String clasRoomSer;

    private String clasRoomNm;

    private String clasRoomCd;

    private String mbrCualfCd;

    private String loginPermYn;

    private String MbrCualfNm;

    private String username;

    private String mbrClassCd;

    private String userId;

    private String clasNm;

    private String tchrNm;

    private String tchrMbrNm;

    private Integer clasUserCnt;

    private Integer studCnt;

    private String clasRoomType;

    private String authDtm;

    private String reqStatNm;

    private String regDtm;


    /**학교 관리자 비밀번호**/
    private String password;
    /**학교 관리자 전화번호**/
    private String tel;
    /**학교 관리자 이메일**/
    private String emailAddr;

    private String schMbrCualfCd;

    private String schMbrCualfNm;

    private String cualfRegStatCd;

    private String schMbrRollSer;

    private String regMbrNo;

    private String regMbrNm;

    private String authNm;

    private String clasRoomSers;

    private String deviceTypeHold;

    private List<String> schNos;

    private String ordSchNo;

    private List<SchJobGroup> schJobGroup;

    private String schClsfChrstcNm;

    private String clasRoomTypeNm;

    private String grnNm;

    private String genNm;

    private String regStatCd;

    private Integer clasRoomCnt;

}
