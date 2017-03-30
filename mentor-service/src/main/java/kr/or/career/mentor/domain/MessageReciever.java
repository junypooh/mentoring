/* ntels */
package kr.or.career.mentor.domain;

import lombok.*;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MessageReciever
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오후 5:44
 */
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@RequiredArgsConstructor(staticName = "of")
public class MessageReciever {
    @NonNull
    private String memberNo;
    private String telNo;
    private String mailAddress;
    private String deviceToken;
    private String osType;

    private String schNo;
    private String schNm;
    private String name;
    private String classRoomNm;
    private String typeNm;
    private Integer rn;

    @NonNull
    private boolean loadable;
}
