package kr.or.career.mentor.domain;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;

/**
 * @author kadol
 *  kr.or.career.mentor.domain
 *  ArclInfoDTO
 *
 *  게시판 도메인의 추가 항목
 *
 */
@Data
public class ArclInfoDTO extends ArclInfo<T> {
    /**
     *
     */
    private static final long serialVersionUID = 1L;
    private String lectTitle;
    private String lectTargtCd;
    private String lectTypeCd;
    private String lectDay;
    private String lectStartTime;
    private String lectEndTime;
    private String mentorMbrNm;

    /**
     * 조회용 추가 항목
     */
    private String sLectTitle;
    private String sMentorNm;
    private String clasStartDay;
    private String clasEndDay;
    private String lectTime;
    private String bestYn = "N";

}
