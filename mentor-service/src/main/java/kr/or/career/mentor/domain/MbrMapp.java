/* ntels */
package kr.or.career.mentor.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MbrMapp
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 23. 오전 10:11
 */
@Data
@AllArgsConstructor(staticName = "of")
public class MbrMapp {
    private String mbrNo;
    private String cnetMbrNo;
}
