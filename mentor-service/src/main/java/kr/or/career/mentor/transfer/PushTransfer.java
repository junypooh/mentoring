/* ntels */
package kr.or.career.mentor.transfer;

import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.MulticastResult;
import com.google.android.gcm.server.Sender;
import com.google.common.collect.Lists;
import com.google.common.util.concurrent.*;
import javapns.Push;
import javapns.communication.exceptions.CommunicationException;
import javapns.communication.exceptions.KeystoreException;
import javapns.notification.PushNotificationPayload;
import javapns.notification.PushedNotifications;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.domain.SendAndResult;
import kr.or.career.mentor.util.EgovProperties;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.httpclient.HttpStatus;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.Executors;

/**
 * <pre>
 * kr.or.career.mentor.invokeTransfer
 *    PushTransfer
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 12. 4. 오전 5:50
 */
@Slf4j
public class PushTransfer implements Transfer<SendAndResult> {
    @Override
    public void transfer(List<SendAndResult> messages,FutureCallback<SendAndResult> callback, Integer msgSer) {


        ListeningExecutorService service = MoreExecutors.listeningDecorator(Executors.newFixedThreadPool(10));

        for(final SendAndResult message : messages) {

            message.setMessageSendType("101674"); //SMS
            message.setSendType(MessageSendType.PUSH);
            message.setMsgSer(msgSer);

            if(Constants.IOS.equals(message.getReciever().getOsType())){
                ListenableFuture<SendAndResult> result = service.submit(new Runnable() {
                @Override
                public void run() {
                    try {

                        PushNotificationPayload adPayload = PushNotificationPayload.alert(message.getPayload().payload(MessageSendType.PUSH));

                        //adPayload.addCustomAlertLocKey(locKey);

                        //adPayload.addCustomAlertLocArgs(args);

                        adPayload.addCustomDictionary("msg", message.getPayload().payload(MessageSendType.PUSH));

                        PushedNotifications noti = Push.payload(adPayload, EgovProperties.getProperty("CERTLOC"), EgovProperties.getProperty("CERTRES"), false, new String[] {message.getReciever().getDeviceToken()});

                        log.debug("sendMessage success : " + noti.getSuccessfulNotifications().size());

                        log.debug("sendMessage fail : " + noti.getFailedNotifications().size());

                        if(noti.getSuccessfulNotifications().size() > 0) {
                            message.setResult(HttpStatus.SC_OK);
                            message.setResultMsg("SUCCESS");
                        }else{
                            message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                            message.setResultMsg(noti.getFailedNotifications().get(0).getException().getMessage());
                        }

                    } catch (CommunicationException | KeystoreException e) {
                        log.error("sendMessage faild. :" + e.getMessage());
                        message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                        message.setResultMsg(e.getMessage());

                    } catch (Exception e) {
                        log.error("sendMessage faild. :" + e.getMessage());
                        message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                        message.setResultMsg(e.getMessage());
                    }
                                                                            }
                }, message);
                Futures.addCallback(result, callback);
            }else {

                ListenableFuture<SendAndResult> result = service.submit(new Runnable() {
                    @Override
                    public void run() {

                        try {
                            MulticastResult multicastResult = null;

                            String apiKey = EgovProperties.getProperty("APIKEY");
                            Sender sender = new Sender(apiKey);


                            List<String> list = Lists.newArrayList();
                            list.add(message.getReciever().getDeviceToken());


                            multicastResult = sender.send(
                                    new Message.Builder()
                                            .delayWhileIdle(true)
                                            .addData("msg", message.getPayload().payload(MessageSendType.PUSH))
                                            .build()
                                    , list, 1);


                            log.info(multicastResult.toString());
                            if(multicastResult.getSuccess() > 0) {
                                message.setResult(HttpStatus.SC_OK);
                                message.setResultMsg("SUCCESS");
                            }else{
                                message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                                message.setResultMsg(multicastResult.getResults().get(0).getErrorCodeName());
                            }
                        } catch (Exception e) {
                            log.error(e.getMessage());
                            message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                            message.setResultMsg(e.getMessage());
                        }

                    }
                }, message);
                Futures.addCallback(result, callback);
            }
        }

        service.shutdown();
    }
}
