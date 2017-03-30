package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

/**
 * Created by junypooh on 2016-05-25.
 */
@Data
public class ClassStatisticsExcelDto extends Base {

    @ExcelFieldName(name="번호")
    private Integer no;

    @ExcelFieldName(name="클래스ID")
    private String clasRoomSer;

    @ExcelFieldName(name="클래스명")
    private String clasRoomNm;

    @ExcelFieldName(name="시도")
    private String sidoNm;

    @ExcelFieldName(name="지역")
    private String sgguNm;

    @ExcelFieldName(name="학교급")
    private String schClassNm;

    @ExcelFieldName(name="학교ID")
    private String schNo;

    @ExcelFieldName(name="학교명")
    private String schNm;

    @ExcelFieldName(name="담당자")
    private String nm;

    @ExcelFieldName(name="핸드폰")
    private String mobile;

    @ExcelFieldName(name="참여구분")
    private String joinClassCdNm;

    @ExcelFieldName(name="수업횟수")
    private Integer lectCnt;

    @ExcelFieldName(name="클래스수")
    private Integer clsCnt;

    @ExcelFieldName(name="수업회차")
    private Integer lectTims;

    @ExcelFieldName(name="일정순서")
    private Integer schdSeq;

    @ExcelFieldName(name="수업ID")
    private String lectId;

    @ExcelFieldName(name="수업상태")
    private String lectStatCdNm;

    @ExcelFieldName(name="수업일시")
    private String lectDay;

    @ExcelFieldName(name="수업시간")
    private String lectTime;

    @ExcelFieldName(name="고용직업분류")
    private String lectJobClsfNm;

    @ExcelFieldName(name="직업명")
    private String jobNm;

    @ExcelFieldName(name="멘토명")
    private String lectrNm;

    @ExcelFieldName(name="수업명")
    private String lectTitle;

    @ExcelFieldName(name="수업유형")
    private String lectTypeCdNm;
}
