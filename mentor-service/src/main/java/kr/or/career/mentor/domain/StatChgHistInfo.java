package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *      StatChgHistInfo
 *
 * 상태 변경 이력 테이블 Class
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-11 오후 1:54
 */
@Data
public class StatChgHistInfo {

    private Integer statChgSer;

    private String statChgClassCd;

    private List<String> statChgClassCds;

    private String statChgClassNm;

    private Integer statChgTargtNo;

    private String statChgTargtMbrNo;

    private String statChgRsltCd;

    private String statChgRsltNm;

    private String statChgRsn;

    private String regMbrNo;

    private String regMbrNm;

    private Date chgRegDtm;

    private Date regDtm;

    private String coNm;

    private String lastStatYn;

    // TOMS 연동을 위한 사용자 정보
    private String username;
    private String emailAddr;

    // 사용되는 메뉴
    private String referType;
}
