package kr.or.career.mentor.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ArclCmtInfo.java
 *
 * 게시판의 기능을 설명한다.
 *
 * </pre>
 *
 * @since 2015. 9. 18. 오후 4:43:45
 * @author technear
 * @see
 */
@Data
public class ArclCmtInfo extends Base {

  private int cmtSer;
  private String boardId;
  private int arclSer;
  private int supCmtSer;
  private String cmtTitle;
  private String cmtSust;
  private float asmPnt;
  private int vcnt;
  private int rcnt;
  private String recomYn;
  private String useYn;
  private String regIpAddr;
  private Date regDtm;
  private String regMbrNo;
  private Date chgDtm;
  private String chgMbrNo;
  private Date delDtm;
  private String delMbrNo;

  /** 사용자 정보 */
  private String regMbrId;
  private String regMbrNm;
  private String mbrClassCd;
  private String mbrClassNm;
  private String fileSer;

  /* 평점 글의 강좌번호*/
  private Integer lectSer;

  /** 조회 사용자 정보 */
  private String sMbrNo;

  /** 서브 댓글 정보 */
  private List<ArclCmtInfo> listSubCmtInfo;

}