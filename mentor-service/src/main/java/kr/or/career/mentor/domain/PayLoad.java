/* ntels */
package kr.or.career.mentor.domain;

import kr.or.career.mentor.constant.MessageSendType;

/**
 * <pre>
 * kr.or.career.mentor.domain
 *    PayLoad
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오후 6:06
 */
public interface PayLoad {

    String payload(MessageSendType messageSendType);

    void setMessage(Message message);

    Message getMessage();

    boolean isCompleted();
}
