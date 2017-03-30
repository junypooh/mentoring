/* ntels */
package kr.or.career.mentor.transfer;

import com.google.common.collect.Lists;
import com.google.common.util.concurrent.FutureCallback;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.MessageService;
import kr.or.career.mentor.util.ApplicationContextUtils;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.PredicateUtils;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;

import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * <pre>
 * kr.or.career.mentor.invokeTransfer
 *    MessageTransfer
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 28. 오후 5:17
 */
@Slf4j
public class MessageTransferManager {

    @Autowired
    private MessageService messageService;


    public void invokeTransfer(Message message){
        try {
            checkNotNull(message.getPayload());

            User user = SessionUtils.getUser();

            MessageSender messageSender = message.getMessageSender();

            String mbrNo = "SYSTEM";

            if(user != null)
                mbrNo = SessionUtils.getUser().getMbrNo();

            if(messageSender != null)
                mbrNo = message.getMessageSender().getMbrNo();

            List<Transfer> transfers = configureTransfer(message.getSendType());

            message = messageService.loadCompleteMessage(message);

            List<SendAndResult> sends = new ArrayList<>();

            List<MessageReciever> recievers = message.getTargets();

            Object object = CollectionUtils.find(transfers, PredicateUtils.instanceofPredicate(PushTransfer.class));

            if(object != null && recievers.size() == 0){
                recievers = messageService.loadPushMessageReciever(message);
            }

            for(MessageReciever reciever : recievers){
                SendAndResult sendAndResult = new SendAndResult();
                sendAndResult.setReciever(reciever);
                sendAndResult.setPayload(message.getPayload());
                sendAndResult.setStatusCode("101037");             //TODO 코드값으로 변경할 것
                sendAndResult.setContentType(message.getContentType());
                //sendAndResult.setType(message.getSendType());
                sendAndResult.setRegMbrNo(mbrNo);
                sendAndResult.setSendTitle(message.getSendTitle());
                sendAndResult.setSender(message.getMessageSender());
                sends.add(sendAndResult);
            }


            FutureCallback callback = new  FutureCallback<SendAndResult>() {

                @Override
                public void onSuccess(SendAndResult result) {

                    if(result.getResult() == HttpStatus.SC_OK){
                        result.setStatusCode("101038"); //발송완료
                    }else{
                        result.setStatusCode("101040"); //발송실패
                    }
                    messageService.insertSendMessageTarget(result);
                    log.debug("success :::: {}", result.getResultMsg());
                }
                @Override
                public void onFailure(Throwable thrown) {
                    log.debug("failure :::: {}", thrown.getMessage());
                }
            };

            for(Transfer transfer : transfers){

                log.debug("{} send Started.....", transfer.toString());

                SendAndResult sendAndResultMain = new SendAndResult();
                sendAndResultMain.setSendTitle(message.getSendTitle());
                sendAndResultMain.setSender(message.getMessageSender());
                sendAndResultMain.setPayload(message.getPayload());
                if(sendAndResultMain.getPayload().getMessage() != null){
                    sendAndResultMain.getPayload().getMessage().setSendTitle("");
                }
                sendAndResultMain.setRegMbrNo(mbrNo);
                sendAndResultMain.setStatusCode("101038");
                sendAndResultMain.setSender(message.getMessageSender());

                if(transfer instanceof EmailTransfer) {
                    sendAndResultMain.setMessageSendType("101672");
                }else if(transfer instanceof SmsTransfer) {
                    sendAndResultMain.setMessageSendType("101673");
                }else if(transfer instanceof PushTransfer) {
                    sendAndResultMain.setMessageSendType("101674");
                }
                messageService.insertSendMessage(sendAndResultMain);
                Integer msgSer =  sendAndResultMain.getMsgSer();

                transfer.transfer(sends,callback,msgSer);

                log.debug("{} send Finished......b", transfer.toString());

            }
        }catch (DataAccessException e){
            log.error("Message Send Error :: {}" , e.getMessage());
        }
    }

    private List<Transfer> configureTransfer(int sendType){
        List<Transfer> transfers = Lists.newArrayList();

        char[] configure = StringUtils.leftPad(Integer.toBinaryString(sendType),3,'0').toCharArray();

        if(configure[0] == '1'){
            transfers.add((SmsTransfer)ApplicationContextUtils.getBean("smsTransfer"));
        }
        if(configure[1] == '1'){
            transfers.add((EmailTransfer)ApplicationContextUtils.getBean("emailTransfer"));
        }
        if(configure[2] == '1'){
            transfers.add((PushTransfer)ApplicationContextUtils.getBean("pushTransfer"));
        }
        return transfers;
    }


}
