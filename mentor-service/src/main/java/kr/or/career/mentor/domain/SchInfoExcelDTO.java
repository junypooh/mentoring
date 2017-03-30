/* license */
package kr.or.career.mentor.domain;

import com.google.common.collect.Lists;
import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SchInfoExcelDTO.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 22. 오전 9:38:56
 * @author technear
 * @see
 */
@Data
public class SchInfoExcelDTO {

    @ExcelFieldName(name="학교코드",order=6)
    private String schNo;

    private String grpNo;

    private Integer setSer;

    private List<AppliedSchLectInfo> appliedSchLectInfos;

    private Integer rn;

    //@ExcelFieldName(name="번호",order=1)
    private Integer no;

    @ExcelFieldName(name="시도",order=1)
    private String sidoNm;

    @ExcelFieldName(name="기본주소",order=2)
    private String locaAddr;

    @ExcelFieldName(name="상세주소",order=3)
    private String locaDetailAddr;

    @ExcelFieldName(name="학교급",order=4)
    private String schClassCdNm;

    @ExcelFieldName(name="학교명",order=5)
    private String schNm;

    @ExcelFieldName(name="이름",order=7)
    private String username;

    @ExcelFieldName(name="연락처",order=8)
    private String mobile;

    @ExcelFieldName(name="디바이스유형",order=9)
    private String deviceType;

    @ExcelFieldName(name="배정유형",order=10)
    private String setTargtCdNm;

    @ExcelFieldName(name="배정그룹",order=11)
    private String grpNm;

    @ExcelFieldName(name="배정횟수",order=12)
    private Integer clasCnt;

    @ExcelFieldName(name="사용횟수",order=13)
    private Integer clasApplCnt;

    @ExcelFieldName(name="배정기간",order=14)
    private String clasPeriod;

    @ExcelFieldName(name="그룹관리자",order=15)
    private String coNm;

    @ExcelFieldName(name="수업현황",order=16)
    private List<String> lectDateTime = Lists.newArrayList();

    @ExcelFieldName(name="",order=17)
    private List<String> lectTitle = Lists.newArrayList();

}
