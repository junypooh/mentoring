/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    JobMentorInfoDTO
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-10-12 오후 5:32
 */
@Data
public class JobMentorInfoDTO extends Base{

    /**
     * 멘토명
     */
    private String mentorNm;

    /**
     * 직업명
     */
    private String jobNm;

    /**
     * 선택 멘토ID
     */
    private String mbrNo;

    /**
     * 직업특성명
     */
    private String jobChrstcNm;

    /**
     * 직업분류명
     */
    private String jobClsfNm;

    /**
     * 직업코드명
     */
    private String jobNo;
}
