/* ntels */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.MessageSenderService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MessageController
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 30. 오전 3:13
 */
@Controller
@RequestMapping("/notify")
public class MessageController {

    @Autowired
    private MessageSenderService messageSenderService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @RequestMapping(value = "/sms/ajax.sendMessage.do",method = RequestMethod.POST)
    @ResponseBody
    @Historic(workId = "1000000401")
    public JSONResponse sendSms(@RequestBody MessageDTO messageDTO, Authentication authentication) {

        Message message = new Message();
        message.addReciever(messageDTO.getMessageRecievers());

        int sendType = messageDTO.getSendType();

        /*MessageSendType messageSendType = null;
        if(sendType == 4)
            messageSendType = MessageSendType.SMS;

        if(sendType == 2)
            messageSendType = MessageSendType.EMS;

        if(sendType == 1)
            messageSendType = MessageSendType.PUSH;*/

        message.setSendType(sendType);

        message.setPayload(messageDTO.getSimplePayLoad());
        message.setContentType(MessageType.SIMPLE_MESSAGE);
        message.setMessageSender(messageDTO.getMessageSender());
        message.setSendTitle(messageDTO.getSimplePayLoad().getTitle());
        message.setOsType(messageDTO.getOsType());

        CodeMessage codeMessage = null;
        User user = (User) authentication.getPrincipal();
        try {
            message.getMessageSender().setMbrNo(user.getMbrNo());
            messageTransferManager.invokeTransfer(message);
            codeMessage = CodeMessage.MSG_900011_메시지가_발송되었습니다_;
        } catch (Exception e) {
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }

    @RequestMapping(value = "/push/ajax.sendMessage.do",method = RequestMethod.POST)
    @ResponseBody
    @Historic(workId = "1000000407")
    public JSONResponse sendPush(@RequestBody MessageDTO messageDTO, Authentication authentication) {

        Message message = new Message();
        message.addReciever(messageDTO.getMessageRecievers());

        int sendType = messageDTO.getSendType();

        /*MessageSendType messageSendType = null;
        if(sendType == 4)
            messageSendType = MessageSendType.SMS;

        if(sendType == 2)
            messageSendType = MessageSendType.EMS;

        if(sendType == 1)
            messageSendType = MessageSendType.PUSH;*/

        message.setSendType(sendType);

        message.setPayload(messageDTO.getSimplePayLoad());
        message.setContentType(MessageType.SIMPLE_MESSAGE);
        message.setMessageSender(messageDTO.getMessageSender());
        message.setSendTitle(messageDTO.getSimplePayLoad().getTitle());
        message.setOsType(messageDTO.getOsType());

        CodeMessage codeMessage = null;
        User user = (User) authentication.getPrincipal();
        try {
            message.getMessageSender().setMbrNo(user.getMbrNo());
            messageTransferManager.invokeTransfer(message);
            codeMessage = CodeMessage.MSG_900011_메시지가_발송되었습니다_;
        } catch (Exception e) {
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }


    @RequestMapping(value = "/email/ajax.sendMessage.do",method = RequestMethod.POST)
    @ResponseBody
    @Historic(workId = "1000000406")
    public JSONResponse sendEmail(@RequestBody MessageDTO messageDTO, Authentication authentication) {

        Message message = new Message();
        message.addReciever(messageDTO.getMessageRecievers());

        int sendType = messageDTO.getSendType();

        /*MessageSendType messageSendType = null;
        if(sendType == 4)
            messageSendType = MessageSendType.SMS;

        if(sendType == 2)
            messageSendType = MessageSendType.EMS;

        if(sendType == 1)
            messageSendType = MessageSendType.PUSH;*/

        message.setSendType(sendType);

        message.setPayload(messageDTO.getSimplePayLoad());
        message.setContentType(MessageType.SIMPLE_MESSAGE);
        message.setMessageSender(messageDTO.getMessageSender());
        message.setSendTitle(messageDTO.getSimplePayLoad().getTitle());
        message.setOsType(messageDTO.getOsType());

        CodeMessage codeMessage = null;
        User user = (User) authentication.getPrincipal();
        try {
            message.getMessageSender().setMbrNo(user.getMbrNo());
            messageTransferManager.invokeTransfer(message);
            codeMessage = CodeMessage.MSG_900011_메시지가_발송되었습니다_;
        } catch (Exception e) {
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }



    @RequestMapping("/hist/ajax.sendSmsHistoryList.do")
    @ResponseBody
    @Historic(workId = "1000000402")
    public List<SendResultDTO> sendSmsHistoryList(@Pageable SendResultDTO sendResultDTO, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();


        List<SendResultDTO> listSendSms = messageSenderService.listSmsSendHistory(sendResultDTO);

        return listSendSms;
    }

    @RequestMapping("/push/ajax.sendSmsHistoryList.do")
    @ResponseBody
    @Historic(workId = "1000000403")
    public List<SendResultDTO> sendPushHistoryList(@Pageable SendResultDTO sendResultDTO, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();


        List<SendResultDTO> listSendSms = messageSenderService.listSmsSendHistory(sendResultDTO);

        return listSendSms;
    }

    @RequestMapping("/email/ajax.sendSmsHistoryList.do")
    @ResponseBody
    @Historic(workId = "1000000404")
    public List<SendResultDTO> sendEmailHistoryList(@Pageable SendResultDTO sendResultDTO, Authentication authentication) throws Exception {
        User user = (User) authentication.getPrincipal();


        List<SendResultDTO> listSendSms = messageSenderService.listSmsSendHistory(sendResultDTO);

        return listSendSms;
    }


    @RequestMapping(value={"/sms/list.do"})
    //@Historic(workId = "1000000400")
    public void list(@Pageable SendResultDTO sendResultDTO, Model model) {
        model.addAttribute("sendResultDTO",sendResultDTO);
    }


    @RequestMapping(value={"/email/ajax.sendView.do"})
    @ResponseBody
    public SendResultDTO sendEmailView(@Pageable SendResultDTO sendResultDTO, Authentication authentication) throws Exception {

        SendResultDTO listSendEmail = messageSenderService.sendEmailView(sendResultDTO);

        return listSendEmail;
    }


    @RequestMapping("/email/ajax.deleteEmail.do")
    @ResponseBody
    @Historic(workId = "1000000405")
    public JSONResponse deleteEmail(@ModelAttribute SendResultDTO sendResultDTO, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        User user = (User) authentication.getPrincipal();


        try {
            messageSenderService.deleteEmail(sendResultDTO);
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success(CodeMessage.MSG_900004_삭제_되었습니다_.toMessage());
    }

}
