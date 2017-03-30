/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    PeopleInLecture
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 16. 4. 19. 오후 5:53
 */
@Data
public class PeopleInLecture {
    private String lectSessId;

    private String applMbrNo;

    private String clasRoomSer;

    private String lectrMbrNo;
}
