/* ntels */
package kr.or.career.mentor.service.impl;

import kr.or.career.mentor.dao.MessageMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.MessageService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    MessageServiceImpl
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 1. 오후 6:43
 */
@Service
@Slf4j
public class MessageLoaderServiceImpl implements MessageService {
    @Autowired
    private MessageMapper messageMapper;

    @Override
    public int insertSendMessage(SendAndResult sendAndResult) {
        return messageMapper.insertSendMessage(sendAndResult);
    }

    @Override
    public int updateSendMessage(SendAndResult sendAndResult) {
        return messageMapper.updateSendMessage(sendAndResult);
    }

    @Override
    public int insertSendMessageTarget(SendAndResult sendAndResult) {
        return messageMapper.insertSendMessageTarget(sendAndResult);
    }

    @Override
    public int updateSendMessageTarget(SendAndResult sendAndResult) {
        return messageMapper.updateSendMessageTarget(sendAndResult);
    }

    @Override
    @Transactional(propagation= Propagation.REQUIRES_NEW)
    public Message loadCompleteMessage(Message message) throws DataAccessException {
        checkNotNull(message);

        PayLoad payLoad = message.getPayload();

        List<MessageReciever> recievers = message.getTargets();

        if(payLoad instanceof LecturePayLoad){

            LecturePayLoad selectPayLoad = (LecturePayLoad)payLoad;
            String cause = selectPayLoad.getCause();
            if(!payLoad.isCompleted()) {

                switch (message.getContentType()){
                    case ADMIN_RETURN:
                        selectPayLoad = messageMapper.selectLectureInfoPayLoad(selectPayLoad);
                        break;
                    default:
                        selectPayLoad = messageMapper.selectLecturePayLoad(selectPayLoad);
                        break;
                }

                selectPayLoad.setCause(cause);
                //selectPayload.setMessage(message);
                message.setPayload(selectPayLoad);
            }


            if(CollectionUtils.isEmpty(recievers)){
                List<MessageReciever> messageRecievers;
                switch (message.getContentType()){
                    case LECTURE_OPEN:
                        messageRecievers = messageMapper.selectMentorMessageReciever(selectPayLoad);
                        message.addReciever(messageRecievers);
                        break;
                    case LECTURE_CLOSE:
                        messageRecievers = messageMapper.selectMentorMessageReciever(selectPayLoad);
                        message.addReciever(messageRecievers);
                        // 수업에 신청,승인,확정인 대상에게 보냄
                        messageRecievers = messageMapper.selectLectureMessageReciever(selectPayLoad);
                        message.addReciever(messageRecievers);
                        break;
                    case LECTURE_CANCEL_LECTURE:
                        // 수업에 신청,승인,확정인 대상에게 보냄
                        messageRecievers = messageMapper.selectLectureMessageReciever(selectPayLoad);
                        message.addReciever(messageRecievers);
                        break;
                    case LECTURE_CONFIRM:
                        messageRecievers = messageMapper.selectMentorMessageReciever(selectPayLoad);
                        message.addReciever(messageRecievers);
                        break;
                    case ADMIN_APPROVE:
                        messageRecievers = messageMapper.selectMentorMessageRecieverForApprove(selectPayLoad);
                        message.addReciever(messageRecievers);
                        break;
                    case ADMIN_RETURN:
                        messageRecievers = messageMapper.selectMentorMessageRecieverForApprove(selectPayLoad);
                        message.addReciever(messageRecievers);
                        break;

                    default:


                        break;
                }
            }

        }else if(payLoad instanceof MemberPayLoad){

            MemberPayLoad selectPayload = (MemberPayLoad) payLoad;
            String cause = selectPayload.getCause();

            if(!payLoad.isCompleted()) {
                selectPayload = messageMapper.selectMemberPayLoad(selectPayload);
                selectPayload.setCause(cause);
                //selectPayload.setMessage(message);
                message.setPayload(selectPayload);
            }

            if(CollectionUtils.isEmpty(recievers)){
                recievers = messageMapper.selectMemberMessageReciever(selectPayload);
                message.setTargets(recievers);
            }

        }else if(payLoad instanceof ClassPayLoad){

        }

        return message;
    }

    @Override
    public List<MessageReciever> loadPushMessageReciever(Message message) throws DataAccessException {
        return messageMapper.selectPushReciever(message);
    }
}
