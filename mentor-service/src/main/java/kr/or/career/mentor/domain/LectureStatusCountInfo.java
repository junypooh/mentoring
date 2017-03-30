package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      LectureStatusCountInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-27 오후 1:42
 */
@Data
public class LectureStatusCountInfo extends Base {

    /* 수업완료 */
    private Integer finishLect;
    /* 오픈대기 */
    private Integer openWaitLect;
    /* 수강모집 */
    private Integer applLect;
    /* 수업예정 */
    private Integer expectLect;
    /* 수업취소 */
    private Integer cancelLect;
    /* 수업폐강 */
    private Integer closeLect;

    private String mbrNo;
    private String mbrCualfCd;
    private String mbrClassCd;
    private String period;
}
