/* license */
package kr.or.career.mentor.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ClasRoomInfo.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 22. 오전 9:35:03
 * @author  technear
 * @see
 */
@Data
public class ClasRoomInfo extends Base{

    private Integer clasRoomSer;
    private Integer setSer;
    private String schGrdCd;
    private String schGrdNm;
    private String schNo;
    private String schNm;
    private String clasRoomNm;
    private String tchrMbrNo;
    private String tchrMbrNm;
    private String tchrMbrClassNm;
    private String clasRoomTypeCd;
    private String clasRoomTypeNm;
    private Date regDtm;
    private SchInfo schInfo;

    //등록신청건수
    private double applyCnt;

    //남은 배정건수
    private double permCnt;

    //학생현황
    private Integer registCnt;

    private String isRegistedRoom;

    private boolean isApplable = true;

    // 대표 여부
    private String rpsYn;
    // 교실 등록 요청 번호
    private Integer reqSer;

    // 교실 자격 코드
    private String clasRoomCualfCd;

    // 승인자
    private String authMbrNm;
    private Date authDtm;

    // 거부사유
    private String rjctRsnSust;

    // 등록 상태 코드
    private String regStatCd;
    private String regStatNm;

    private String reqMbrNm;

    private String delYn;

    private String teacherId;


    private String userType;


}
