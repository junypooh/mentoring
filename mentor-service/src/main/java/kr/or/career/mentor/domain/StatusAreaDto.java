/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;
import lombok.EqualsAndHashCode;


/**
 *  시도별 학교참여현황
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class StatusAreaDto extends Base {

    @ExcelFieldName(name="지역",order=1)
    private String sidoNm;
    @ExcelFieldName(name="초등학교(대상학교)",order=1)
    private Integer etargtCnt;
    @ExcelFieldName(name="중학교(대상학교)",order=1)
    private Integer mtargtCnt;
    @ExcelFieldName(name="고등학교(대상학교)",order=1)
    private Integer htargtCnt;
    @ExcelFieldName(name="계(대상학교)",order=1)
    private Integer ttargtCnt;
    @ExcelFieldName(name="초등학교(수업참여학교수)",order=1)
    private Integer eschCnt;
    @ExcelFieldName(name="중학교(수업참여학교수)",order=1)
    private Integer mschCnt;
    @ExcelFieldName(name="고등학교(수업참여학교수)",order=1)
    private Integer hschCnt;
    @ExcelFieldName(name="계(수업참여학교수)",order=1)
    private Integer tschCnt;
    @ExcelFieldName(name="초등학교(참여수업수)",order=1)
    private Double eclasCnt;
    @ExcelFieldName(name="중학교(참여수업수)",order=1)
    private Double mclasCnt;
    @ExcelFieldName(name="고등학교(참여수업수)",order=1)
    private Double hclasCnt;
    @ExcelFieldName(name="계(참여수업수)",order=1)
    private Double tclasCnt;
    @ExcelFieldName(name="초등학교(학교당 참여수업수 평균)",order=1)
    private Double eratio;
    @ExcelFieldName(name="중학교(학교당 참여수업수 평균)",order=1)
    private Double mratio;
    @ExcelFieldName(name="고등학교(학교당 참여수업수 평균)",order=1)
    private Double hratio;
    @ExcelFieldName(name="계(학교당 참여수업수 평균)",order=1)
    private Double tratio;


}
