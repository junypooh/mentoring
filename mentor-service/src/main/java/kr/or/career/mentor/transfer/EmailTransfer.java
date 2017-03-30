/* ntels */
package kr.or.career.mentor.transfer;

import com.google.common.util.concurrent.*;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.domain.EmsMail;
import kr.or.career.mentor.domain.MessageSender;
import kr.or.career.mentor.domain.SendAndResult;
import kr.or.career.mentor.service.EmsService;
import kr.or.career.mentor.util.EgovProperties;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.httpclient.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.concurrent.Executors;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * <pre>
 * kr.or.career.mentor.invokeTransfer
 *    EmailTransfer
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 29. 오전 9:43
 */
@Slf4j
public class EmailTransfer implements Transfer<SendAndResult> {

/*    @Autowired
    private JavaMailSender mailSender;*/

    @Autowired
    private EmsService emsService;

    @Override
    public void transfer(List<SendAndResult> messages, FutureCallback<SendAndResult> callback, Integer msgSer) {

        checkNotNull(messages);

        ListeningExecutorService service = MoreExecutors.listeningDecorator(Executors.newFixedThreadPool(10));


        for(final SendAndResult message : messages) {

            message.setMessageSendType("101672"); //Email
            message.setSendType(MessageSendType.EMS);
            message.setMsgSer(msgSer);

            ListenableFuture<SendAndResult> result = service.submit(new Runnable() {
                @Override
                public void run() {

                    String toName = "";
                    String fromEmail = null;
                    String fromName = null;
                    try {
                        EmsMail emsMail = new EmsMail();

                        if(message.getSender() == null)
                            message.setSender(new MessageSender());

                        fromEmail = message.getSender().getMailAddress();
                        if(fromEmail == null) fromEmail = EgovProperties.getProperty("MAIL.SENDER");

                        fromName = message.getSender().getSenderName();
                        if(fromName == null) fromName = EgovProperties.getProperty("MAIL.SENDERNAME");

                        emsMail.setFromEmail(fromEmail);
                        emsMail.setFromName(fromName);
                        emsMail.setMailCode(47);
                        emsMail.setMapLong(message.getSendMessage());
                        emsMail.setToEmail(message.getReciever().getMailAddress());
                        emsMail.setSubject(message.getSendTitle());
                        toName = message.getReciever().getName();
                        if(toName == null)
                            toName = EgovProperties.getProperty("MAIL.RECIEVERNAME");
                        emsMail.setToName(toName);
                        emsMail.setToId("TEST");


                        emsService.insertEmsMailQueue(emsMail);

                        message.setResult(HttpStatus.SC_OK);
                        message.setResultMsg("SUCCESS");
                    }catch(Exception e){
                        log.info("Mail send exception ::: {}", e.getMessage());
                        // 메일 발송 실패로 결과를 저장한다.
                        message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                        message.setResultMsg(e.getMessage());
                    }

                }
            }, message);

            Futures.addCallback(result, callback);

            //results.add(result);
        }


        service.shutdown();

    }

}
