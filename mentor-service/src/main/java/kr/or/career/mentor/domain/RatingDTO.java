/* license */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.List;


/**
 * <pre>
 * kr.or.career.mentor.domain
 *    RatingDTO.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 11. 17. 오후 7:22:02
 * @author  technear
 * @see
 */
@Data
public class RatingDTO extends Base{
    String nm;
    String mbrNo;

    @ExcelFieldName(name="직업명")
    String jobNm;

    @ExcelFieldName(name="수업수")
    String lectCnt;

    @ExcelFieldName(name="교사평점")
    Double techerPoint;

    @ExcelFieldName(name="학생평점")
    Double stuPoint;

    @ExcelFieldName(name="교사(명)")
    String teacherCnt;

    @ExcelFieldName(name="학생(명)")
    String stuCnt;

    String jobChrstcNm;
    String jobClsfNm;

    Integer lectSer;

    @ExcelFieldName(name="멘토")
    String lectrNm;

    @ExcelFieldName(name="수업명")
    String lectTitle;

    @ExcelFieldName(name="수업유형")
    String lectTypeNm;
    String lectTargtCd;

    String lectrMbrNo;
    String lectDay;
    String lectStartTime;
    String lectEndTime;

    String searchWord;
    String searchKey;
    String lectTypeCd;
    String lectStartDay;
    String lectEndDay;

    String orderType = "1";

    /** 멘토(강사) 학교명 */
    String lectrSchNm;

    @ExcelFieldName(name="배정사업")
    String grpNm;

    @ExcelFieldName(name="수업대상")
    String lectTargtNm;

    @ExcelFieldName(name="번호")
    Integer no;

    /** 검색조건 학교급 */
    String schoolGrd;
    /** 검색조건 학교급(기타) */
    String schoolEtcGrd;

    /** 평점 검색조건  */
    String avgPoint;

    /**
     * 검색조건 수강 대상 리스트
     */
    private List<String> schoolGrdExList;

}
