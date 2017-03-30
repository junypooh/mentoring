/* ntels */
package kr.or.career.mentor.domain;

import lombok.Data;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    MessageDTO
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 24. 오전 5:03
 */
@Data
public class MessageDTO {

    private List<MessageReciever> messageRecievers;

    private SimplePayLoad simplePayLoad;

    private MessageSender messageSender;

    private int sendType;

    private String osType;
}
