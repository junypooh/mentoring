/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MessageSender
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 24. 오전 3:30
 */
@Data
public class MessageSender {

    private String mbrNo;

    private String mobileNum;

    private String mailAddress;

    private String senderName;

}
