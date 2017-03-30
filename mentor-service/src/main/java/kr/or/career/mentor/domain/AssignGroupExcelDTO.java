/* ntels */
package kr.or.career.mentor.domain;

import java.util.Date;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    AssignGroupExcelDTO
 *
 * 관리자포탈 - 배정그룹 excel용 DTO
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-29 오후 3:31
 */
@Data
public class AssignGroupExcelDTO {

    private Integer rn;

    @ExcelFieldName(name="번호",order=1)
    private Integer no;

    @ExcelFieldName(name="그룹관리자",order=2)
    private String coNm;

    @ExcelFieldName(name="배정그룹",order=3)
    private String grpNm;

    @ExcelFieldName(name="배정횟수",order=4)
    private Integer clasCnt;

    @ExcelFieldName(name="배정기간",order=5)
    private String clasPeriod;

    @ExcelFieldName(name="시도",order=6)
    private String sidoNm;

    @ExcelFieldName(name="기본주소",order=7)
    private String locaAddr;

    @ExcelFieldName(name="상세주소",order=8)
    private String locaDetailAddr;

    @ExcelFieldName(name="학교명",order=9)
    private String schNm;

    @ExcelFieldName(name="등록일",order=10)
    private Date regDtm;

}

