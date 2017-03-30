/* ntels */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.Message;
import kr.or.career.mentor.domain.MessageReciever;
import kr.or.career.mentor.domain.SendAndResult;
import org.springframework.dao.DataAccessException;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    MessageService
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 1. 오후 6:40
 */
public interface MessageService {

    int insertSendMessage(SendAndResult sendAndResult);

    int updateSendMessage(SendAndResult sendAndResult);

    int insertSendMessageTarget(SendAndResult sendAndResult);

    int updateSendMessageTarget(SendAndResult sendAndResult);

    Message loadCompleteMessage(Message message) throws DataAccessException;

    List<MessageReciever> loadPushMessageReciever(Message message) throws DataAccessException;
}
