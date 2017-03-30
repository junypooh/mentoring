package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * Created by chaos on 2016. 8. 16..
 */
@Data
public class WithdrawInfo {
    private Integer sessionId;
    private String tommsId;
    private String setSer;
    private String schNo;
    private Integer clasRoomSer;
    private Integer rollbackCnt;
}
