/* license */
package kr.or.career.mentor.domain;

import java.util.Date;
import java.util.List;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;


/**
 * <pre>
 * kr.or.career.mentor.domain
 *    RatingCmtDTO.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 11. 18. 오후 3:51:04
 * @author  technear
 * @see
 */
@Data
public class RatingCmtDTO extends Base{

    Integer cmtSer;

    @ExcelFieldName(name="후기내용")
    String cmtSust;

    @ExcelFieldName(name="평점")
    Double asmPnt;

    String mbrClassCd;
    String nm;
    String id;
    Integer cnt;

    @ExcelFieldName(name="등록일")
    Date regDtm;

    String useYn;

    Integer lectSer;

    List<ArclCmtInfo> listArclCmtInfo;

    @ExcelFieldName(name="번호")
    Integer no;

    /** 작성자 학교명 */
    String regSchNm;

    /** 수업유형코드 */
    String lectTypeCd;

    @ExcelFieldName(name="수업유형")
    String lectTypeNm;

    @ExcelFieldName(name="수업명")
    String lectTitle;

    @ExcelFieldName(name="멘토명")
    String lectrNm;

    @ExcelFieldName(name="직업")
    String jobNm;

    /** 학교급 코드 */
    String lectTargtCd;

    @ExcelFieldName(name="학교급")
    String lectTargtNm;

    @ExcelFieldName(name="작성자")
    String regMbrNm;

    @ExcelFieldName(name="회원유형")
    String mbrCualfNm;

    @ExcelFieldName(name="학교명")
    String schNm;

    @ExcelFieldName(name="교실정보")
    String clasRoomNm;

    /** 회원유형 코드 */
    String mbrCualfCd;

    /**  배정사업 */
    String grpNm;

    /** 교육수행기관 */
    String coNm;

    /** 검색날짜 Start Day */
    String searchStDate;
    /** 검색날짜 End Day */
    String searchEndDate;

    /** 회원유형 학생 or 교사 구분 */
    String mbrCualfType;

    /** 작성자 ID */
    String regMbrId;

    /** 삭제 회원일련번호 */
    String delMbrNo;

    /** 검색조건 학교급 */
    String schoolGrd;
    /** 검색조건 학교급(기타) */
    String schoolEtcGrd;

    /**
     * 검색조건 수강 대상 리스트
     */
    private List<String> schoolGrdExList;
}
