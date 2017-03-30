package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.MentorManagementService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.util.ValidationUtils;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;


@Controller
@RequestMapping("/mentor/belongMentor")
@Slf4j
public class BelongMentorController {

    @Autowired
    private MentorManagementService mentorManagementService;
    @Autowired
    private UserService userService;

    @Autowired
    private MessageTransferManager messageTransferManager;


    /**
     * 소속 멘토 목록
     *
     * @param search
     * @param model
     */
    @RequestMapping("/belongMentorList.do")
    public void listBelongMentor(@Pageable @ModelAttribute("mentorSearch") MentorSearch search, Model model) {
        User user = SessionUtils.getUser();
        search.setRegMbrNo(user.getMbrNo());
        search.setPosCoNo(user.getPosCoNo());

        model.addAttribute("mentorList", mentorManagementService.listBelongMentor(search));
    }

    @RequestMapping("excel.belongMentorList.do")
    public ModelAndView excelBelongMentor(@ModelAttribute("mentorSearch") MentorSearch search, Model model) {
        User user = SessionUtils.getUser();
        search.setRegMbrNo(user.getMbrNo());
        search.setPosCoNo(user.getPosCoNo());

        model.addAttribute("fileName", "mentors.xls");
        model.addAttribute("domains",mentorManagementService.listBelongMentor(search));

        return new ModelAndView("excelView","data",model);
    }


    /**
     * 소속멘토 등록
     *
     * @param mentor
     * @param result
     * @return
     */
    @RequestMapping("/ajax.belongMentorInsert.do")
    @ResponseBody
    public JSONResponse insertbelongMentorAjax(@Valid User mentor, BindingResult result) {
        //@formatter:off
        ValidationUtils.rejectIfEmpty(result, "id", CodeMessage.MSG_800004_ID를_입력_해_주세요_);
        ValidationUtils.rejectIfId(result, "id", CodeMessage.MSG_810001_ID가_형식에_맞지_않습니다__5자리___12자리_영문__숫자_및_기호__________만_가능합니다_);
        ValidationUtils.rejectIfEmpty(result, "password", CodeMessage.MSG_800010_비밀번호를_입력_해_주세요_);
        ValidationUtils.rejectIfPassword(result, "password", CodeMessage.MSG_810002_비밀번호가가_형식에_맞지_않습니다__영문__숫자_또는_특수문자를_포함한_10_20자리가_가능합니다_);
        ValidationUtils.rejectIfEmpty(result, "username", CodeMessage.MSG_800003_이름을_입력_해_주세요_);
        ValidationUtils.rejectIfEmpty(result, "emailAddr", CodeMessage.MSG_800006_이메일을_입력_해_주세요_);
        ValidationUtils.rejectIfEmail(result, "emailAddr", CodeMessage.MSG_800007_이메일이_형식에_맞지_않습니다_);
        //@formatter:on

        // 중복체크
        if (StringUtils.isNotBlank(mentor.getId()) && !userService.isValidateId(mentor.getId())) {
            ValidationUtils.rejectIf(result, CodeMessage.MSG_800000_이미_등록된_아이디_입니다_);
        }

        // 에러가 있을경우
        if (result.hasErrors()) {
            ObjectError error = result.getAllErrors().get(0);
            return JSONResponse.failure(error.getDefaultMessage());
        }

        User target = SessionUtils.getUser();
        try {

            String password = mentor.getPassword();
            mentorManagementService.saveBelongMentor(mentor, target);

            /**
             * 메일 발송을 위한 정보 세팅 (수업신청 or 수업신청대기)
             */
            /*
            try {
                MessageReciever reciever = MessageReciever.of(mentor.getMbrNo(),true);
                reciever.setMailAddress(mentor.getEmailAddr());

                Message message = new Message();
                message.setSendType(MessageSendType.EMS);
                message.addReciever(reciever);

                MemberPayLoad memberPayLoad = MemberPayLoad.of(mentor.getMbrNo(),message,true);
                memberPayLoad.setPassword(password);
                memberPayLoad.setId(mentor.getId());
                message.setPayload(memberPayLoad);
                message.setContentType(MessageType.JOIN_MENTOR);

                messageTransferManager.invokeTransfer(message);
            }catch (Exception e){
                log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
            }
            */
            return JSONResponse.success(CodeMessage.MSG_100017_소속멘토가_등록되었습니다_.toMessage());
        }
        catch (Exception e) {
            log.debug("Not save: {}", e.getMessage(), e);
            return JSONResponse.failure(CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_);
        }
    }


    /**
     * 소속멘토 상세 정보 및 수정
     *
     * @param mbrNo
     * @param model
     */
    @RequestMapping("/belongMentorShow.do")
    public void showBelongMentor(@RequestParam String mbrNo, Model model) {
        User user = userService.getUserByNo(mbrNo);
        user.setAgrees(userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의));
        user.setMbrJobInfo(userService.getMbrJobInfoByMbrNo(user.getMbrNo()));
        user.setMbrJobChrstcInfos(userService.getMbrJobChrstcInfos(user.getMbrNo()));
        user.setMbrpropicInfos(userService.listMbrProfPicInfoByMbrNo(mbrNo));
        user.setMbrProfInfo(userService.getMbrProfInfoBy(user.getMbrNo()));
        user.setMbrProfScrpInfos(userService.listMbrProfScrpInfos(user.getMbrNo(), null));

        model.addAttribute("user", user);
    }


    /**
     * 멘토 기본정보 수정
     *
     * @param user
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/belongMentorBaseUpdate.do")
    public String updateBelongMentorBase(User user, RedirectAttributes redirectAttributes) {
        User loginUser = SessionUtils.getUser();
        user.setChgMbrNo(loginUser.getMbrNo());

        mentorManagementService.updateBelongMentorBase(user);
        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());
        redirectAttributes.addAttribute("actived", 0);

        return "redirect:/mentor/belongMentor/belongMentorShow.do";
    }


    /**
     * 멘토 직업정보 수정
     *
     * @param user
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/belongMentorJobUpdate.do")
    public String updateBelongMentorJob(User user, RedirectAttributes redirectAttributes) {
        mentorManagementService.updateBelongMentorJob(user);
        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());
        redirectAttributes.addAttribute("actived", 1);

        return "redirect:/mentor/belongMentor/belongMentorShow.do";
    }


    /**
     * 멘토 프로필 정보 수정
     *
     * @param user
     * @param redirectAttributes
     * @return
     */
    @RequestMapping("/belongMentorProfileUpdate.do")
    public String updateBelongMentorProfile(User user, RedirectAttributes redirectAttributes) {
        mentorManagementService.updateBelongMentorProfile(user);
        redirectAttributes.addAttribute("mbrNo", user.getMbrNo());
        redirectAttributes.addAttribute("actived", 2);

        return "redirect:/mentor/belongMentor/belongMentorShow.do";
    }
}
