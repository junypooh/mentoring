package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    Board
 *
 *  class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오후 8:31
 */

@Data
public class BoardPrefInfo {

  private String boardId;
  private String prefNo;
  private String prefNm;
  private Integer dispSeq;

}
