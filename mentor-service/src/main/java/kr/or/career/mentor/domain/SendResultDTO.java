/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    SendResultDTO
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 12. 2. 오전 12:00
 */
@Data
public class SendResultDTO extends Base {
    /**
     * 검색조건 시작날짜
     */
    private String searchStDate;

    /**
     * 검색조건 종료날짜
     */
    private String searchEndDate;


    private String sendDate;

    private String sendDetail;

    private String sender;

    private String price;

    private String mbrNo;

    private String telNo;
    private String mailAddress;
    private String deviceToken;
    private String osType;

    private String schNo;
    private String schNm;
    private String name;
    private String classRoomNm;
    private String typeNm;

    private Integer msgSer;

    private String sendTypeCd;

    private String regMbrNo;
    private String regMbrNm;
    private String sendTargtCd;
    private String sendTargtNm;
    private String coNm;
    private String nm;
    private String chanel;
    private String sendMsg;
    private Integer sendCnt;
    private Integer sendSuccessCnt;
    private Integer sendFallCnt;

    private String searchType;
    private String searchNm;

    private List<String> sendTargtSers;
    private String sendTargtInfo;

    private String sendTitle;

    private List<String> msgSers;

    private String targtDvcNm;

    private String sendStatNm;

    private String posCoYn;

}
