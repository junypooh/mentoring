/* license */
package kr.or.career.mentor.domain;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    PagingObject.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since 2015. 9. 18. 오후 3:01:16
 * @author technear
 * @see
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class PagingObject<T> extends Base {
    List<T> data;
}
