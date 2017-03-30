/* license */
package kr.or.career.mentor.domain;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    ArclInfoRS.java
 *
 * ResultSet용 Domain
 *
 * </pre>
 *
 * @since 2015. 9. 18. 오후 4:43:45
 * @author technear
 * @see
 */
@Data
public class ArclInfoRS extends ArclInfo<T> {

  private ArclInfo<T> ansArclInfo;

  private String regMbrId;
  private String regMbrNm;

  private int cmtCount;

  /** 검색조건 */
  String searchKey;
  /** 검색단어 */
  String searchWord;

}