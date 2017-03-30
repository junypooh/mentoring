package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      ClasRoomRepInfo
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-23 오후 1:47
 */
@Data
public class ClasRoomRepInfo extends Base {

    private String schNm;
    private String clasRoomNm;
    private String repStdntNm;
    private String repStdntClassNm;
    private String repStdntRegMbrNm;
    private String repStdntRegMbrClassNm;
    private Date repStdntRegDtm;
}
