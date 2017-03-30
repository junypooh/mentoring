package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.ExcelFieldName;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.domain.UserSearch.SearchGroupType;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.*;
import kr.or.career.mentor.view.JSONResponse;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.lang.reflect.InvocationTargetException;
import java.util.*;

import static kr.or.career.mentor.constant.CodeConstants.CD100033_101766_101767;


@Controller
@RequestMapping("/user/manager")
@Slf4j
public class UserManagerController {

    @Autowired
    private UserService userService;
    @Autowired
    private MessageTransferManager messageTransferManager;


    @RequestMapping("/listManager.do")
    public void listManager(@ModelAttribute("search") UserSearch search) {
        search.setSearchGroupType(SearchGroupType.MANAGER);
        log.debug("[REQ] search: {}", search);
    }


    @RequestMapping("/ajax.listManager.do")
    @ResponseBody
    public List<User> listManagerAjax(@Pageable UserSearch search) {
        if ("operate".equals(search.getMbrCualfType())) {
            search.setMbrCualfCds(OPERATE_CUALF_CDS);
        }
        else if ("group".equals(search.getMbrCualfType())) {
            search.setMbrCualfCds(GROUP_CUALF_CDS);
        }
        else {
            search.setMbrCualfCds(MANAGER_CUALF_CDS);
        }

        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }


    @RequestMapping("/excel.listManager.do")
    public ModelAndView listManagerExcel(UserSearch search) {
        if ("operate".equals(search.getMbrCualfType())) {
            search.setMbrCualfCds(OPERATE_CUALF_CDS);
        }
        else if ("group".equals(search.getMbrCualfType())) {
            search.setMbrCualfCds(GROUP_CUALF_CDS);
        }
        else {
            search.setMbrCualfCds(MANAGER_CUALF_CDS);
        }

        search.setRegDtmBegin(DateUtils.addMonths(new Date(), -1));
        log.debug("[REQ] search: {}", search);

        Map<String, Object> model = new HashMap<>();

        List<User> managerList = userService.listUserBy(search);
        List<ManagerExcelDto> domains = new ArrayList<>();
        for (int i = 0, len = managerList.size(); i < len; ++i) {
            User u = managerList.get(i);
            ManagerExcelDto excelDto = new ManagerExcelDto();
            try {
                BeanUtils.copyProperties(excelDto, u);
                excelDto.setRn(i + 1);
                domains.add(excelDto);
            }
            catch (IllegalAccessException | InvocationTargetException e) {
                log.debug("property copy error: {}", e.getMessage(), e);
            }
        }

        model.put("fileName", String.format("%s_adminmem.xls", DateFormatUtils.format(new Date(), "yyyyMMddhhmmss")));
        model.put("domains", domains);

        return new ModelAndView("excelView", model);
    }


    @RequestMapping(value="/ajax.searchUser.do", method = RequestMethod.POST)
    @ResponseBody
    public List<User> listUserAjax(@RequestBody UserSearch search) {

        log.debug("[REQ] search: {}", search);
        search.setPageable(false);

        return userService.listUserForNotification(search);
    }


    @RequestMapping("/createManager.do")
    public void createManager(@ModelAttribute("user") User user) {
        user.setLoginPermYn("Y"); // 사용여부
        user.setMbrGradeCd("0"); // 운영관리자
    }


    @SuppressWarnings({ "unchecked", "rawtypes" })
    @RequestMapping(value = "/saveManager.do", method = RequestMethod.POST)
    public String saveManager(@ModelAttribute("user") User user, BindingResult result, RedirectAttributes redirectAttributes) {

        if (StringUtils.isNotBlank(user.getId()) && !userService.isValidateId(user.getId())) {
            ValidationUtils.rejectIf(result, CodeMessage.MSG_800000_이미_등록된_아이디_입니다_);
        }

        if (result.hasErrors()) {
            return "/user/manager/createManager";
        }

        User sessionUser = SessionUtils.getUser();
        user.setRegMbrNo(sessionUser.getMbrNo());

        String password = RandomStringUtils.randomAlphanumeric(6);
//        String password = "1";

        user.setPassword(password);
        userService.saveManager(user);

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         *
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
        return "redirect:/user/manager/showManager.do";
    }


    @RequestMapping("/showManager.do")
    public void showManager(@Param("mbrNo") String mbrNo, Model model) {
        model.addAttribute("user", userService.getUserByNo(mbrNo));
    }


    @RequestMapping("/editManager.do")
    public void editManager(@Param("mbrNo") String mbrNo, Model model) {
        User user = userService.getUserByNo(mbrNo);

        // set defult value;
        user.setMbrGradeCd(StringUtils.defaultString(user.getMbrGradeCd()));

        model.addAttribute("user", user);
    }


    @RequestMapping("/updateManager.do")
    public String updateManager(User user, RedirectAttributes redirectAttributes) {
        try {
            User sessionUser = SessionUtils.getUser();
            user.setChgMbrNo(sessionUser.getMbrNo());

            userService.updateUser(user);
        }
        catch (Exception e) {
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toExceptio(e);
        }

        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());
        return "redirect:/user/manager/showManager.do";
    }


    @RequestMapping("/changePwdAndSendMail.do")
    @ResponseBody
    public JSONResponse changePwdAndSendMail(@RequestParam("mbrNo") String mbrNo, @RequestParam("sendType") String sendType) {

        User user = userService.getUserByNo(mbrNo);
        String password = RandomStringUtils.randomAlphanumeric(6);
        //String password = "1";
        int value = 0;
        try {


            //String password = "1";
            value = userService.updatePwd(user, password);
        } catch (Exception e) {
            return JSONResponse.failure(CodeMessage.ERROR_000001_시스템_오류_입니다_);
        }

        if(value < 1) {
            return JSONResponse.failure(CodeMessage.MSG_800012_비밀번호가_맞지_않습니다_);
        } else {

            if (sendType.equals("EMS")) {
                /**
                 * 메일발송에서 실패가 있더라도 무시한다.
                 *
                 */
                try {
                    MessageReciever reciever = MessageReciever.of(user.getMbrNo(), true);
                    reciever.setMailAddress(user.getEmailAddr());
                    Message message = new Message();
                    message.setSendType(MessageSendType.EMS.getValue());
                    message.setContentType(MessageType.RESET_PASSWD_BYADMIN);
                    message.addReciever(reciever);

                    MemberPayLoad memberPayLoad = MemberPayLoad.of(user.getMbrNo(), message, true);
                    memberPayLoad.setName(user.getUsername());
                    memberPayLoad.setId(user.getId());
                    memberPayLoad.setPassword(password);

                    String mbrClassCd = user.getMbrClassCd();

                    if(CodeConstants.CD100857_100859_교사.equals(mbrClassCd)
                            || CodeConstants.CD100857_100858_일반회원.equals(mbrClassCd)
                            || CodeConstants.CD100857_101707_학교관리자.equals(mbrClassCd))
                        memberPayLoad.setSiteClass(Constants.SCHOOL);
                    else if(CodeConstants.CD100857_101505_멘토.equals(mbrClassCd)
                            || CodeConstants.CD100857_101504_기관_업체.equals(mbrClassCd))
                        memberPayLoad.setSiteClass(Constants.MENTOR);
                    else
                        memberPayLoad.setSiteClass(Constants.MANAGER);

                    message.setPayload(memberPayLoad);
                    message.setSendTitle(CD100033_101766_101767);

                    messageTransferManager.invokeTransfer(message);
                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }

                return JSONResponse.success(CodeMessage.MSG_900007_이메일이_발송되었습니다_.toMessage());
            } else {
                try {
                    MessageReciever reciever = MessageReciever.of(user.getMbrNo(), true);
                    reciever.setTelNo(user.getTel());
                    if(user.getMobile() != null){
                        reciever.setTelNo(user.getMobile());
                    }
                    Message message = new Message();
                    message.setSendType(MessageSendType.SMS.getValue());
                    message.setContentType(MessageType.SIMPLE_MESSAGE);
                    message.addReciever(reciever);
                    //message.getMessageSender().setMobileNum("01036860682");

                    MessageSender messageSender = new MessageSender();
                    messageSender.setMobileNum(EgovProperties.getProperty("REPPHONE"));
                    messageSender.setMbrNo(mbrNo);
                    message.setMessageSender(messageSender);
                    SimplePayLoad simplePayLoad = new SimplePayLoad();
                    simplePayLoad.setContent(password);

                    message.setPayload(simplePayLoad);

               /* MemberPayLoad memberPayLoad = MemberPayLoad.of(user.getMbrNo(), message, true);
                memberPayLoad.setName(user.getUsername());
                memberPayLoad.setId(user.getId());
                memberPayLoad.setPassword(password);


                message.setPayload(memberPayLoad);*/

                    message.setSendTitle("비밀번호 초기화");
                    messageTransferManager.invokeTransfer(message);
                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }
                return JSONResponse.success(CodeMessage.MSG_900007_이메일이_발송되었습니다_.toMessage());
            }
        }
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
            CodeConstants.CD100204_101678_운영관리자);
    private static final List<String> GROUP_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_101500_기관담당자);
    private static final List<String> MANAGER_CUALF_CDS = PooqUtils.merge(
            OPERATE_CUALF_CDS,
            GROUP_CUALF_CDS);
    //@formatter:on

    @Data
    public static class ManagerExcelDto {

        @ExcelFieldName(name = "번호", order = 1)
        private Integer rn;
        @ExcelFieldName(name = "아이디", order = 2)
        private String id;
        @ExcelFieldName(name = "유형", order = 3)
        private String mbrCualfNm;
        @ExcelFieldName(name = "이름", order = 4)
        private String username;
        @ExcelFieldName(name = "소속", order = 5)
        private String posCoNm;
        @ExcelFieldName(name = "휴대전화번호", order = 6)
        private String mobile;
        @ExcelFieldName(name = "이메일", order = 7)
        private String email;
        @ExcelFieldName(name = "권한", order = 8)
        private String mbrGradeCd;
        @ExcelFieldName(name = "사용유무", order = 9)
        private String loginPermYn;
        @ExcelFieldName(name = "등록자", order = 10)
        private String regMbrNm;
        @ExcelFieldName(name = "등록일", order = 11)
        private Date regDtm;

    }


    @RequestMapping(value="/ajax.searchHistoryUser.do", method = RequestMethod.POST)
    @ResponseBody
    public List<User> listUserHistoryAjax(@RequestBody UserSearch search) {

        log.debug("[REQ] search: {}", search);
        search.setPageable(false);

        return userService.listUserForNotificationHistory(search);
    }



}
