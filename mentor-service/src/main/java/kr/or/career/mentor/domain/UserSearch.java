package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.apache.commons.lang3.StringUtils;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;


@Data
@EqualsAndHashCode(callSuper = false)
@NoArgsConstructor
@ToString(callSuper = true)
public final class UserSearch extends Base {

    private static final long serialVersionUID = 8289550687229359525L;

    /** 이름 */
    private String name;
    /** 아이디*/
    private String id;
    /** 아이디/이름 */
    private String idName;
    /** 이메일*/
    private String email;
    /** 학교명*/
    private String school;
    /** 교실명*/
    private String clas;
    /** 휴대전화*/
    private String mobile;
    /** 직업명*/
    private String job;
    /** 직업 태그*/
    private String jobTag;


    /** 등록일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDtmBegin;
    /** 등록일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date regDtmEnd;
    /** 탈퇴일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date delDtmBegin;
    /** 탈퇴일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date delDtmEnd;
    /** 검색 유형 */
    private String searchType;
    /** 검색 키 */
    private String searchKey;
    /** 자격 유형 */
    private String mbrCualfType;
    /** 승인여부 */
    private String approveYn = StringUtils.EMPTY;
    /** 사용유무 */
    private String loginPermYn = StringUtils.EMPTY;
    /** 학교 구분코드 */
    private String schClassCd;
    /** 검색 묶음 유형 */
    private SearchGroupType searchGroupType = SearchGroupType.MANAGER;
    /** 검색 묶음 유형 */
//    private SearchTypeGroup searchTypeGroup = SearchTypeGroup.PUBLIC;

    /** 회원구분코드's */
    private List<String> mbrClassCds;
    /** 회원자격 코드's */
    private List<String> mbrCualfCds;
    /** 회원 상태 코드 */
    private List<String> mbrStatCds;
    /** 그룹관리자 회원 번호 */
    private String grpMbrNo;
    /** 기업담당자 회원 번호 */
    private String corpoMbrNo;

    /** 회원자격 코드 */
    private String mbrCualfCd;
    /** 회원 번호 */
    private String mbrNo;

    /** 직업분류 코드*/
    private String jobClsfCd;

    /** 학교대표 여부(대표교사, 학교관리자) */
    private String rpsTeacher;

    /** 반대표 여부 */
    private String rpsStudent;

    /** 권한 코드 */
    private String authCd;

    /** 가입탈퇴 승인 검색 조건 */

    /** 일련번호 */
    private Integer statChgSer;

    /** 구분 */
    private List<String> statChgClassCds;

    /** 상태 */
    private List<String> statChgRsltCds;

    /** 상태 */
    private String statChgRsltCd;

    /** 등록일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date statChgHistRegDtmBegin;

    /** 등록일 */
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date statChgHistRegDtmEnd;

    /** 가입탈퇴 승인 검색 조건 */

    @Deprecated
    public enum SearchGroupType {
        MANAGER("manager"), CORPO_MENTOR("corpoMentor"), SCHOOL_MEMBER("schoolMember"), MENTOR_MEMBER("mentorMember");
        private String value;
        private SearchGroupType(String value) {
            this.value = value;
        }
        public String getValue() {
            return value;
        }
    }

    /*public enum SearchTypeGroup {
        PUBLIC("public"), TEACHER("teacher"), MENTOR("mentor"), APPROVAL("approval"), WITHDRAWAL("withdrawal");
        private String value;
        SearchTypeGroup(String value) {
            this.value = value;
        }
        public String getValue() {
            return value;
        }
    }*/

    private List<String> mbrNos;

    private List<String> sendTargtSers;

    private String sendTargtSer;

    private String sendTargtCd;

    private String msgSer;

    private String mbrWithDrawnType;

    private String lastStatYn;

    private String selType;


}
