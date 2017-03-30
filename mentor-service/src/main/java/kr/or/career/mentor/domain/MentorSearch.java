package kr.or.career.mentor.domain;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

/**
 * 멘토 관리 검색 조건을 위한 VO 클래스
 *
 * @author
 * @since
 * @version 1.0
 * @see
 */

@Data
@EqualsAndHashCode(callSuper = false)
@ToString(callSuper = true)
public class MentorSearch extends Base {

    private static final long serialVersionUID = 2648177870010944098L;

    /** 유망멘토 조회시에 TRUE로 설정*/
    private boolean isHopeful = false;

    /** 검색구분 */
    private String searchType;

    /** 검색키워드 */
    private String searchKey;

    /** 검색 Text */
    private String searchWord;

    /** 수업상태 */
    private String classStatus;

    /** 성별 */
    private String gender;

    /** 특성분류 */
    private List<String> chrstcClsfCds;

    /** 직업분류 */
    private String jobClsfCd;

    /** 직업 번호 */
    private String jobNo;

    /** 강의 진행 상태코드 */
    private String lectStatCd;

    /** 성별 코드 */
    private String genCd;

    /** 회원 번호 */
    private String mbrNo;

    /** 승인상태코드 */
    private String authStatCd;

    /** 회원상태코드 */
    private String mbrStatCd;

    /** 등록 회원 번호*/
    private String regMbrNo;

    /** 대상 멘토 번호 */
    private String targtMbrNo;

    /** 소속 업체 번호 */
    private String posCoNo;

    /** 학교사이트 노출 여부 */
    private String schSiteExpsYn;

    /** 멘토 ID */
    private String mbrId;

    /** 멘토이름 */
    private String mbrNm;

    /** 멘토직업명 */
    private String mbrJobNm;

    private String targtCd;

    /** 초성검색 */
    private String consonantsVal;

    /** 멘토 사용유무 */
    private String loginPermYn;
}
