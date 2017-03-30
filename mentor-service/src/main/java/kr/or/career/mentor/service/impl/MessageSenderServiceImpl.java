/* ntels */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.MessageMapper;
import kr.or.career.mentor.domain.MessageReciever;
import kr.or.career.mentor.domain.SearchOption;
import kr.or.career.mentor.domain.SendResultDTO;
import kr.or.career.mentor.service.MessageSenderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    MessageSenderServiceImpl
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 18. 오후 2:54
 */
@Slf4j
@Service
public class MessageSenderServiceImpl implements MessageSenderService {

    @Autowired
    private MessageMapper messageMapper;

    @Override
    public List<MessageReciever> listMessageTarget(SearchOption searchOption) {
        return messageMapper.selectMessageTarget(searchOption);
    }

    @Override
    public List<SendResultDTO> listSmsSendResult(SendResultDTO sendResultDTO) {
        return messageMapper.selectSmsSendResult(sendResultDTO);
    }

    @Override
    public List<SendResultDTO> listSmsSendResultTest(SendResultDTO sendResultDTO) {
        return messageMapper.selectSmsSendResultTest(sendResultDTO);
    }


    @Override
    public List<SendResultDTO> listSmsSendHistory(SendResultDTO sendResultDTO) {
        return messageMapper.selectSmsSendHistory(sendResultDTO);
    }

    @Override
    public SendResultDTO sendEmailView(SendResultDTO sendResultDTO) {
        return messageMapper.sendEmailView(sendResultDTO);
    }




    @Override
    public int deleteEmail(SendResultDTO sendResultDTO) {
        return messageMapper.deleteEmail(sendResultDTO);
    }




}
