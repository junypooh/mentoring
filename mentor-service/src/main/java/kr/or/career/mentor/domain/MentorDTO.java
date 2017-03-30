package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class MentorDTO extends Base {

    private static final long serialVersionUID = -8955230187068416004L;

    /** 멘토 회원번호 */
    private String mbrNo;

    /** 멘토 ID */
    @ExcelFieldName(name="아이디",order=1)
    private String id;

    /** 멘토 이름 */
    @ExcelFieldName(name="멘토명",order=2)
    private String nm;

    private String emailAddr;

    // transient ===========================
    /** 아이콘 정보 */
    private String iconKindCd;

    /** 프로필 타이틀 */
    private String profTitle;

    /** 프로필 소개 정보 */
    private String profIntdcInfo;

    /** 학력 정보 */
    private String profSchCarInfo;

    /** 경력 정보 */
    private String profCareerInfo;

    /** 수상 정보 */
    private String profAwardInfo;

    /** 저서 정보 */
    private String profBookInfo;

    /** 직업 명 */
    @ExcelFieldName(name="직업명",order=6)
    private String jobNm;

    /** 직업 태그 정보 */
    private String jobTagInfo;

    /** 프로필 파일 번호 */
    private Integer profFileSer;

    /** 직업분류 */
    private String jobClsfCd;

    /** 학생 점수 */
    private Double stdntAsmPnt;

    /** 교사 점수 */
    private Double tchrAsmPnt;

    /** 회원자격코드(멘토구분) */
    private String mbrCualfCd;

    /** 회원 상태 코드 */
    private String mbrStatCd;

    /** 회원 상태명 */
    @ExcelFieldName(name="상태",order=7)
    private String mbrStatNm;

    /** 로그인 사용 여부 */
    private String loginPermYn;

    /** 성별 코드 */
    private String genCd;

    @ExcelFieldName(name="성별",order=8)
    private String genNm;

    /** 등록일 */
    @ExcelFieldName(name="등록일",order=9)
    private Date regDtm;

    /** 직업_번호 */
    private String jobNo;

    private String posCoNo;

    /** 직업계층구조 */
    @ExcelFieldName(name="직업분류(1차)",order=3)
    private String jobStruct1;
    @ExcelFieldName(name="직업분류(2차)",order=4)
    private String jobStruct2;
    @ExcelFieldName(name="직업분류(3차)",order=5)
    private String jobStruct3;

    /** 직업특징분류 */
    private String jobChrstcCdNm;

}
