/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    LectReqTimeInfo
 *
 * 수업요청시간정보 Domain
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-22 오후 4:44
 */
@Data
public class LectReqTimeInfo {

    /**
     * 요청 일련번호
     */
    private Integer reqSer;

    /**
     * 수업 희망일자
     */
    private String lectPrefDay;

    /**
     * 수업 희망일시
     */
    private String lectPrefTime;
}

