package kr.go.career.mentor.controller;

import com.google.common.collect.Maps;
import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.PooqUtils;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      OprManagerController
 *
 * Class 설명을 입력하세요.
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-04 오후 1:41
 */
@Controller
@RequestMapping("/opr/manager")
@Slf4j
public class OprManagerController {

    @Autowired
    private UserService userService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @RequestMapping("/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000309")
    public List<User> listManagerAjax(@Pageable UserSearch search) {

        if ("0".equals(search.getMbrCualfType())) {
            search.setMbrClassCds(Arrays.asList(CodeConstants.CD100857_100860_관리자));
            search.setMbrCualfCds(OPERATE_CUALF_CDS);
        } else if ("1".equals(search.getMbrCualfType())) {
            search.setMbrClassCds(Arrays.asList(CodeConstants.CD100857_100860_관리자));
            search.setMbrCualfCds(GROUP_CUALF_CDS);
        } else if ("2".equals(search.getMbrCualfType())) {
            search.setMbrClassCds(Arrays.asList(CodeConstants.CD100857_101504_기관_업체));
            search.setMbrCualfCds(Arrays.asList(CodeConstants.CD100204_101501_업체담당자));
        } else {
            search.setMbrClassCds(Arrays.asList(CodeConstants.CD100857_101504_기관_업체, CodeConstants.CD100857_100860_관리자));
            search.setMbrCualfCds(PooqUtils.merge(MANAGER_CUALF_CDS, Arrays.asList(CodeConstants.CD100204_101501_업체담당자)));
        }


        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }

    @RequestMapping("/view.do")
    @Historic(workId = "1000000310")
    public void viewManager(User user, Model model) {

        log.debug("[REQ] search: {}", user);

        if(StringUtils.isNotEmpty(user.getMbrNo())) {
            Map param = Maps.newHashMap();
            param.put("mbrNo", user.getMbrNo());
            user = userService.retrieveUser(param);

        } else {
            user.setLoginPermYn("Y");
        }
        model.addAttribute("user", user);
    }

    @RequestMapping(value = "/saveManager.do", method = RequestMethod.POST)
    @Historic(workId = "1000000311")
    public String saveManager(@ModelAttribute("user") User user, BindingResult result, RedirectAttributes redirectAttributes) {

        User sessionUser = SessionUtils.getUser();
        user.setRegMbrNo(sessionUser.getMbrNo());

        String password = user.getPassword();

        String[] split = user.getMbrCualfCd().split("\\|");
        user.setMbrCualfCd(split[1]);
        if(!"2".equals(user.getMbrGradeCd())) {
            user.setAuthTargtId(split[0]);
        }

        userService.saveManager(user);

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         */
        try {
            MessageReciever reciever = MessageReciever.of(user.getMbrNo(), true);
            reciever.setMailAddress(user.getEmailAddr());

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.JOIN_CONFIRM_ADMIN);
            message.addReciever(reciever);

            MemberPayLoad memberPayLoad = MemberPayLoad.of(user.getMbrNo(), message, true);
            memberPayLoad.setName(user.getUsername());
            memberPayLoad.setId(user.getId());
            memberPayLoad.setPassword(password);
            message.setPayload(memberPayLoad);

            messageTransferManager.invokeTransfer(message);
        }
        catch (Exception e) {
            log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
        }

        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());
        return "redirect:/opr/manager/view.do";
    }

    @RequestMapping(value = "/updateManager.do", method = RequestMethod.POST)
    @Historic(workId = "1000000312")
    public String updateManager(@ModelAttribute("user") User user, BindingResult result, RedirectAttributes redirectAttributes) throws Exception {

        User sessionUser = SessionUtils.getUser();
        user.setChgMbrNo(sessionUser.getMbrNo());

        String[] split = user.getMbrCualfCd().split("\\|");
        user.setMbrCualfCd(split[1]);
        if(!"2".equals(user.getMbrGradeCd())) {
            user.setAuthTargtId(split[0]);
        }

        userService.updateUser(user);

        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());
        return "redirect:/opr/manager/view.do";
    }

    //@formatter:off
    private static final List<String> OPERATE_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_100850_전체관리자,
            CodeConstants.CD100204_100851_운영관리자,
            CodeConstants.CD100204_100852_운영관리자,
            CodeConstants.CD100204_100853_운영관리자,
            CodeConstants.CD100204_100854_운영관리자,
            CodeConstants.CD100204_100855_운영관리자,
            CodeConstants.CD100204_100856_운영관리자,
            CodeConstants.CD100204_101675_운영관리자,
            CodeConstants.CD100204_101676_운영관리자,
            CodeConstants.CD100204_101677_운영관리자,
            CodeConstants.CD100204_101678_운영관리자,
            CodeConstants.CD100204_101717_사용자정의운영관리자);
    private static final List<String> GROUP_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_101500_기관담당자,
            CodeConstants.CD100204_101724_사용자정의기관담당자);
    private static final List<String> MANAGER_CUALF_CDS = PooqUtils.merge(
            OPERATE_CUALF_CDS,
            GROUP_CUALF_CDS);
    //@formatter:on
}
