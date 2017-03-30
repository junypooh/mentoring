/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.text.DecimalFormat;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    StatusSummaryDto
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 16. 5. 25. 오후 3:31
 */
@EqualsAndHashCode(callSuper = false)
@Data
public class StatusSummaryDto extends Base {

    private static final long serialVersionUID = 6827040009301579820L;

    private Integer bizSetSchoolCnt;

    private Integer appliedSchoolCnt;

    private Double appliedClassCnt;

    private Double avgOfAppliedClassBySchool;

    private Double avgOfAppliedClassExpect;

    private Integer openClassCnt;

    private String avgOfSchoolCntPerClass;

    private Integer totalMentorCnt;

    private Integer jobCntOfMentor;

    private Integer mentorCntOfLecture;

    private Integer jobCntOfLecture;

    public String getAvgOfAppliedClassBySchool(){
        DecimalFormat decimalFormat = new DecimalFormat("#####.##");
        if(bizSetSchoolCnt == 0)
            return "-";
        return decimalFormat.format((double)appliedClassCnt / bizSetSchoolCnt);
    }

    public String getAvgOfAppliedClassExpect(){
        DecimalFormat decimalFormat = new DecimalFormat("#####.##");
        if(appliedSchoolCnt == 0)
            return "-";
        return decimalFormat.format((double) appliedClassCnt / appliedSchoolCnt);
    }
}
