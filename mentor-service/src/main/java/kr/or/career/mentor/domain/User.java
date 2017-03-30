package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Date;
import java.util.List;

@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class User extends Base implements UserDetails{
    private static final long serialVersionUID = -5022049944489761755L;

    private String username;
    private String password;

    private String mbrNo;
    private String mbrClassCd;
    private String mbrClassNm;
    private String mbrCualfCd;
    private String mbrCualfNm;
    private String mbrGradeCd;
    private String id;
    //private String pwd;
    //private String nm;
    private String genCd;
    private String birthday;
    private String lunarYn;
    private String emailAddr;
    private String jobCd;
    private String tel;
    private String mobile;
    private String prtctrNm;
    private String prtctrTel;
    private String prtctrEmailAddr;
    private String pwdQuestCd;
    private String pwdQuestNm;
    private String pwdAnsSust;
    private String mngrPicPath;
    private String mngrPosNm;
    private String mngrPosBizno;
    private String mbrStatCd;
    private String marryYn;
    private String natCd;
    private String domRsdcYn;
    private String rsdcAreaCd;
    private String schCarCd;
    private String schClassCd;
    private String schSer;
    private String schNm;
    private String schGrdNm;
    private String clasNm;
    private String chrgTchrNo;
    private String gpinIdntfNo;
    private String gpinDupVerfInfo;
    private String stdntClassCd;
    private String chrgStdntClassCd;
    private String mngrPosCd;
    private String mngrCareerInfo;
    private String mngrRmkSust;
    private String mngrFldInfo;
    private String loginPermYn;
    private String sessId;
    private String scrbPathCd;
    private Date useStopDtm;
    private Date pwdChgDtm;
    private Date cnslStartDay;
    private String connIp;
    private String loginCnt;
    private String lastLoginDtm;
    private Date regDtm;
    private String regMbrNo;
    private String regMbrNm;
    private Date chgDtm;
    private String chgMbrNo;
    private Date delDtm;
    private String delMbrNo;
    private String fax;
    private String schSiteExpsYn;
    private String tmpPwdYn;
    private String authCd;
    private String authNm;
    private String authType;


    //@NotEmpty
    private String usageAgree;

    //@NotEmpty
    private String personalInfoAgree;


    private boolean accountNonExpired = true;

    private boolean accountNonLocked = true;

    private Collection<Authority> authorities;

    private boolean credentialsNonExpired = true;

    private boolean enabled = true;

    private List<MbrAgrInfo> agrees;

    /** 회원 프로파일 조인  */
    private MbrProfInfo mbrProfInfo;

    /** 회원 프로파일사진정보 조인 */
    private List<MbrProfPicInfo> mbrpropicInfos;

    /** 회원 직업 정보 */
    private MbrJobInfo mbrJobInfo;

    /** 회원 직업 특성 정보 */
    private List<MbrJobChrstcInfo> mbrJobChrstcInfos;

    /** 스크렙 정보 */
    private List<MbrProfScrpInfo> mbrProfScrpInfos;

    /** 관계 정보 */
    private MbrRelMapp mbrRelMapp;

    /** 회원 아이콘 정보 */
    private MbrIconInfo mbrIconInfo;

    /** 관신 정보 코드*/
    private String itrstCd;

    /** 업체번호*/
    private String posCoNo;
    private String posCoNm;
    private String posBizno;

    /** 상위 소속 명 */
    private String supPosCoNm;

    private String supUsername;

    private String clasRoomSer;

    /** 학교정보 */
    private String schData;

    /** 교실정보 */
    private String roomData;

    /** 직업명 */
    private String jobNm;

    /** 직업태그정보 */
    private String jobTagInfo;

    /** 직업1차분류 */
    private String jobStruct1;

    /** 대표교사 여부 */
    private String rpsTeacher;

    /** 학교 관리자 여부 */
    private String schManager;

    /** 상태 변경 이력 */
    private StatChgHistInfo statChgHistInfo;

    private String authProcSust;

    private String mbrWithdrawnType;

    private String mbrWithdrawnTypeNm;

    private String sidoNm;

    private String sendTargtMbrNo;

    private String sendTargtInfo;

    private String profFileSer;

    private String authTargtId;
}
