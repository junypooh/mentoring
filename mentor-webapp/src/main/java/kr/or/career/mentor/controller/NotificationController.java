/* ntels */
package kr.or.career.mentor.controller;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    NotificationController
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 11. 18. 오후 1:45
 */
@Controller
@RequestMapping("notification")
public class NotificationController {

    @Autowired
    private MessageSenderService messageSenderService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @RequestMapping(value = "notify.do",method = RequestMethod.GET)
    public String notify( SearchOption searchOption, Model model) {

        model.addAttribute("keyword",searchOption.getKeyword());
        return "notification/notify";
    }

    @RequestMapping(value = "ajax.selectMessageTargetList.do",method = RequestMethod.GET)
    @ResponseBody
    public List<MessageReciever> list( SearchOption searchOption) {

        return messageSenderService.listMessageTarget(searchOption);
    }

    @RequestMapping(value = "ajax.sendSms.do",method = RequestMethod.POST)
    @ResponseBody
    public JSONResponse sendSms(@RequestBody MessageDTO messageDTO, Authentication authentication) {

        Message message = new Message();
        message.addReciever(messageDTO.getMessageRecievers());

        int sendType = messageDTO.getSendType();
/*
        MessageSendType messageSendType = null;
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

        CodeMessage codeMessage = null;
        User user = (User) authentication.getPrincipal();
        try {
            messageTransferManager.invokeTransfer(message);
            message.getMessageSender().setMbrNo(user.getMbrNo());
        } catch (Exception e) {
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.toMessage());
    }



}
