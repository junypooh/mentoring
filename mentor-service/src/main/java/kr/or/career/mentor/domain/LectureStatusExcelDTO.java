/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.annotation.ExcelFieldName;
import lombok.Data;

import java.util.Date;
import java.util.List;


/**
 * <pre>
 * kr.or.career.mentor.domain
 *    CalculateManagementExcelDTO
 *
 * 멘토관리 - 정산 excel용 DTO
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-29 오후 3:31
 */
@Data
public class LectureStatusExcelDTO {

    @ExcelFieldName(name="번호",order=1)
    private Integer no;

    @ExcelFieldName(name="배정사업명",order=2)
    private String grpNm;

    @ExcelFieldName(name="수업상태",order=3)
    private String lectStatCdNm;

    @ExcelFieldName(name="수업일시",order=4)
    private String lectDay;

    @ExcelFieldName(name="수업시간",order=5)
    private String lectTime;

    @ExcelFieldName(name="고용직업분류",order=6)
    private String lectJobClsfNm;

    @ExcelFieldName(name="직업명",order=7)
    private String jobNm;

    @ExcelFieldName(name="멘토명",order=8)
    private String lectrNm;

    @ExcelFieldName(name="수업명",order=9)
    private String lectTitle;

    @ExcelFieldName(name="신청클래스수",order=10)
    private String applDvc;

    @ExcelFieldName(name="참여클래스수",order=11)
    private String obsvDvc;

    @ExcelFieldName(name="유형",order=12)
    private String lectTypeCdNm;

    @ExcelFieldName(name="차감횟수기준",order=13)
    private Integer lectureCnt;

    @ExcelFieldName(name="교육수행기관",order=14)
    private String coNm;

    @ExcelFieldName(name="스튜디오",order=15)
    private String stdoNm;

    @ExcelFieldName(name="MC명",order=16)
    private String mcNm;

    @ExcelFieldName(name="신청일",order=17)
    private String applRegDtm;

    @ExcelFieldName(name="신청유형",order=18)
    private String applClassCdNm;

    @ExcelFieldName(name="지역",order=19)
    private String sidoNm;

    @ExcelFieldName(name="시군구",order=20)
    private String sgguNm;

    @ExcelFieldName(name="학교급",order=21)
    private String schClassCdNm;

    @ExcelFieldName(name="학교ID",order=22)
    private String schNo;

    @ExcelFieldName(name="학교명",order=23)
    private String schoolNm;

    @ExcelFieldName(name="교실정보",order=24)
    private String clasRoomNm;

    @ExcelFieldName(name="교실인원수",order=25)
    private Integer clasPersonCnt;

    @ExcelFieldName(name="담당자",order=26)
    private String tchrNm;

    @ExcelFieldName(name="신청자 유형",order=27)
    private String clasRoomCualfCdNm;

    @ExcelFieldName(name="핸드폰",order=28)
    private String tchrMobile;

    @ExcelFieldName(name="참여구분",order=29)
    private String joinClassNm;



    private String lectStartTime;

    private String lectEndTime;

    private int maxApplCnt;

    private int maxObsvCnt;

    private int applCnt;

    private int obsvCnt;

    private String lectId;

    private String dateLectDay;

    private String lectTargtCd;

    private String lectTargtCdNm;

    private String deviceTypeNm;

    private String lectRunTime;



    @ExcelFieldName(name="특징분류")
    private String jobCtg0;

    @ExcelFieldName(name="1차직종")
    private String jobCtg1;

    @ExcelFieldName(name="2차직종")
    private String jobCtg2;

    @ExcelFieldName(name="3차직종")
    private String jobCtg3;

    @ExcelFieldName(name="대기학교")
    private List stbSchNm;

    @ExcelFieldName(name="대상:초")
    private String eleTargt;

    @ExcelFieldName(name="대상:중")
    private String midTargt;

    @ExcelFieldName(name="대상:고")
    private String highTargt;

    @ExcelFieldName(name="클래스ID")
    private String clasRoomSer;

    @ExcelFieldName(name="16년 수업횟수")
    private String lectCnt;

    @ExcelFieldName(name="신청학교")
    private List schNm;


}

