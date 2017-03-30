package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.Date;

/**
 * Created by chaos on 2016. 8. 23..
 */
@Data
public class WorkInfo extends Base {
    private String workNo;
    private String mbrNo;
    private String connIp;
    private String reqInfoSmry;
    private String targtMbrNo;

    private String workUrl;

    @ExcelFieldName(name="접속일자",order=1)
    private Date workDtm;
    @ExcelFieldName(name="접속메뉴",order=2)
    private String workSust;
    @ExcelFieldName(name="조회대상",order=3)
    private String targtMbrNm;
    @ExcelFieldName(name="소속",order=4)
    private String coNm;
    @ExcelFieldName(name="ID",order=5)
    private String id;
    @ExcelFieldName(name="관리자명",order=6)
    private String nm;
    @ExcelFieldName(name="접속권한",order=7)
    private String authNm;
    private String searchKey;
    private String searchWord;
    private String searchStDate;
    private String searchEndDate;
}
