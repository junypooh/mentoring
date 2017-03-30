/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    AppliedSchLectInfo
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 16. 3. 9. 오후 1:36
 */
@EqualsAndHashCode(callSuper = false)
@Data
public class AppliedSchLectInfo extends Base {

    private static final long serialVersionUID = 4486161252462266606L;

    private String schNo;

    private Integer setSer;

    private Integer lectSer;

    private Integer lectTims;

    private Integer clasRoomSer;

    private String lectDateTime;

    private String lectTitle;
}
