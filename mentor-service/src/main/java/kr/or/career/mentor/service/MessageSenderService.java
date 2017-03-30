/* ntels */
package kr.or.career.mentor.service;

import kr.or.career.mentor.domain.MessageReciever;
import kr.or.career.mentor.domain.SearchOption;
import kr.or.career.mentor.domain.SendResultDTO;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service
 *    MessageSenderService
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 18. 오후 2:54
 */
public interface MessageSenderService {

    List<MessageReciever> listMessageTarget(SearchOption searchOption);

    List<SendResultDTO> listSmsSendResult(SendResultDTO sendResultDTO);

    List<SendResultDTO> listSmsSendResultTest(SendResultDTO sendResultDTO);

    List<SendResultDTO> listSmsSendHistory(SendResultDTO sendResultDTO);

    SendResultDTO sendEmailView(SendResultDTO sendResultDTO);

    int deleteEmail(SendResultDTO sendResultDTO);


}
