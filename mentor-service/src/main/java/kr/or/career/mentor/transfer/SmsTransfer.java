/* ntels */
package kr.or.career.mentor.transfer;

import com.google.common.util.concurrent.*;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.domain.SendAndResult;
import kr.or.career.mentor.util.EgovProperties;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.methods.PostMethod;
import org.xml.sax.InputSource;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.concurrent.Executors;

/**
 * <pre>
 * kr.or.career.mentor.service.impl
 *    SmsTransfer
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 10. 27. 오후 3:01
 */
@Slf4j
public class SmsTransfer implements Transfer<SendAndResult> {

    @Override
    public void transfer(List<SendAndResult> messages, final FutureCallback<SendAndResult> callback, Integer msgSer) {


        final HttpClient client = new HttpClient();
        client.getParams().setParameter("http.useragent", "SEEDS Client");
        HttpConnectionManager connectionManager = new MultiThreadedHttpConnectionManager();
        client.setHttpConnectionManager(connectionManager);

        ListeningExecutorService service = MoreExecutors.listeningDecorator(Executors.newFixedThreadPool(10));

        for(final SendAndResult message : messages) {

            message.setMessageSendType("101673"); //SMS
            message.setSendType(MessageSendType.SMS);
            message.setMsgSer(msgSer);

            ListenableFuture<SendAndResult> result = service.submit(new Runnable() {
                @Override
                public void run() {

                    PostMethod method = new PostMethod("http://rest.supersms.co:6200/sms/xml");

                    try {

                        NameValuePair[] parameters = new NameValuePair[7];

                        parameters[0] = new NameValuePair("id", "ntels_restful"); //  아이디
                        parameters[1] = new NameValuePair("pwd", "2SWU07J189QZW191UB38"); //패스워드
                        parameters[2] = new NameValuePair("from", EgovProperties.getProperty("REPPHONE"));    //발신번호(등록사용자만 보낼 수 있음)
                        parameters[3] = new NameValuePair("to_country", "82");    //수신자 국가코드
                        parameters[4] = new NameValuePair("to", message.getReciever().getTelNo().replaceAll("-",""));      // 수신자 전화번호
                        parameters[5] = new NameValuePair("message", message.getSendMessage());
                        parameters[6] = new NameValuePair("report_req","1");

                        method.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
                        method.setRequestBody(parameters);
                        //method.getParams().setContentCharset("EUC-KR");

                        int statusCode = 0;
                        String resultString = "";

                        log.debug("called......{}", statusCode);
                        statusCode = client.executeMethod(method);

                        InputSource is = new InputSource(method.getResponseBodyAsStream());

                        XPath xpath = XPathFactory.newInstance().newXPath();

                        String resultCode = xpath.evaluate("/submit_response/messages/message/err_code",is);


                        log.debug("result......{}", resultCode);

                        if("R000".equals(resultCode)){
                            message.setResult(statusCode);
                            message.setResultMsg("SUCCESS");
                        }else{
                            message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                            message.setResultMsg(resultCode);
                        }

                    }/*catch (HttpException e){
                        log.error("ignore Exception because business logic should process : cause[{}]", e.getMessage());

                    }catch (XPathExpressionException e) {
                        log.error("ignore Exception because business logic should process : cause[{}]", e.getMessage());
                    }*/
                    catch (Exception ioe){
                        log.error("ignore Exception because business logic should process : cause[{}]",ioe.getMessage());
                        message.setResult(HttpStatus.SC_INTERNAL_SERVER_ERROR);
                        message.setResultMsg(ioe.getMessage());
                    }finally {
                        method.releaseConnection();
                    }
                }
            }, message);

            Futures.addCallback(result, callback);

        }

        service.shutdown();

    }




}
