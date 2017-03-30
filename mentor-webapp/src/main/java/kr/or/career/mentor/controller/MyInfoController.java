package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.service.StatChgHistService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.util.ValidationUtils;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;


@Controller
@RequestMapping("/myPage/myInfo")
@Slf4j
public class MyInfoController {

    @Autowired
    private UserService userService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private StatChgHistService statChgHistService;

    /**
     * 회원 정보 상세
     *
     * @param model
     */
    @RequestMapping(value={"/myInfo.do","/myInfoEdit.do"})
    public void viewMyInfo(Model model) {
        User sessionUser = SessionUtils.getUser();
        log.debug("sessionUser: {}", sessionUser);

        User user = userService.getUserByNo(sessionUser.getMbrNo());
        user.setAgrees(userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의));
        model.addAttribute("user", user);
        if (SessionUtils.hasAnyRole("ROLE_COP_MENTOR")) {
            User corporation = userService.getSupUserByNo(user.getMbrNo());
            User organization = userService.getSupUserByNo(corporation.getMbrNo());
            model.addAttribute("corporation", corporation);
            model.addAttribute("organization", organization);
        }
    }

    @RequestMapping("/ajax.secessionCheck.do")
    @ResponseBody
    public JSONResponse secessionCheck() throws Exception {
        try {
            User sessionUser = SessionUtils.getUser();

            String sMbrNo = sessionUser.getMbrNo();
            LectureSearch lectureSearch = new LectureSearch();
            lectureSearch.setMbrNo(sMbrNo);
            int cnt = lectureManagementService.secessionCheck(lectureSearch);

            if(cnt > 0){
                CodeMessage.MSG_800014_수업_개설중인_상태에서는_회원_탈퇴가_불가능합니다.toException();
            }
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }

        return JSONResponse.success("");
    }

    /**
     * 회원정보 수정
     *
     * @param user
     * @param result
     * @return
     */
    @RequestMapping("/updateMyInfo.do")
    public String updateMyInfo(@ModelAttribute User user, BindingResult result, RedirectAttributes redirectAttributes) {
        User sessionUser = SessionUtils.getUser();
        user.setId(sessionUser.getId());
        user.setMbrNo(sessionUser.getMbrNo());

        ValidationUtils.rejectIfEmpty(result, "emailAddr", CodeMessage.MSG_800006_이메일을_입력_해_주세요_);
        ValidationUtils.rejectIfEmail(result, "emailAddr", CodeMessage.MSG_800007_이메일이_형식에_맞지_않습니다_);

        if (result.hasErrors()) {
            user.setUsername(sessionUser.getUsername());
            user.setGenCd(sessionUser.getGenCd());

            return "myPage/myInfo/myInfo";
            //return "redirect:/myPage/myInfo/myInfo.do";
        }

        try {
            user.setChgMbrNo(sessionUser.getMbrNo());
            userService.updateUserAndEmailAgree(user);

            sessionUser.setBirthday(user.getBirthday());
            sessionUser.setMobile(user.getMobile());
            sessionUser.setAgrees(user.getAgrees());
            sessionUser.setPwdQuestNm(user.getPwdQuestNm());
            sessionUser.setPwdQuestCd(user.getPwdQuestCd());
            sessionUser.setPwdAnsSust(user.getPwdAnsSust());
            sessionUser.setLunarYn(user.getLunarYn());

            redirectAttributes.addFlashAttribute("messageCode", CodeMessage.MSG_900003_수정_되었습니다_);

            return "redirect:/myPage/myInfo/myInfo.do";
        }
        catch (Exception e) {
            log.error(e.getMessage(), e);
            throw CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_.toExceptio(e);
        }
    }


    @RequestMapping("/profile.do")
    public void profile(Model model) {
        User sessionUser = SessionUtils.getUser();

        User user = userService.getUserByNo(sessionUser.getMbrNo());
        user.setMbrJobInfo(userService.getMbrJobInfoByMbrNo(user.getMbrNo()));
        user.setMbrJobChrstcInfos(userService.getMbrJobChrstcInfos(user.getMbrNo()));
        user.setMbrpropicInfos(userService.listMbrProfPicInfoByMbrNo(user.getMbrNo()));
        user.setMbrProfInfo(userService.getMbrProfInfoBy(user.getMbrNo()));
        user.setMbrProfScrpInfos(userService.listMbrProfScrpInfos(user.getMbrNo(), null));

        model.addAttribute("user", user);
    }


    @RequestMapping("/updateProfile.do")
    public String updateProfile(User user, RedirectAttributes redirectAttributes) {
        User sessionUser = SessionUtils.getUser();
        user.setChgMbrNo(sessionUser.getMbrNo());
        user.setMbrNo(sessionUser.getMbrNo());

        userService.updateJobAndProfile(user);

        //메인화면 링크바꾸기위해 수정성공시 오늘날짜로 셋팅
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sessionUser.setLastLoginDtm(sdf.format(date));

        return "redirect:/myPage/myInfo/profile.do";
    }

    /**
     * 탈퇴 신청 처리
     *
     * @param session
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    @RequestMapping(value="/secessionFisnsh.do")
    public void secessionFisnsh(HttpSession session) throws Exception {
        User user = SessionUtils.getUser();
        user.setChgMbrNo(user.getMbrNo());

        user.setMbrStatCd(CodeConstants.CD100861_101572_탈퇴요청);
        userService.updateSecession(user);

        // 승인 요청 이력 데이터 생성
        StatChgHistInfo statChgHistInfo = new StatChgHistInfo();
        statChgHistInfo.setStatChgClassCd(CodeConstants.CD101718_101751_회원탈퇴요청상태);
        statChgHistInfo.setStatChgTargtMbrNo(user.getMbrNo());
        statChgHistInfo.setStatChgRsltCd(CodeConstants.CD100861_101572_탈퇴요청); // CodeConstants.CD100861_101506_승인요청
        statChgHistInfo.setRegMbrNo(user.getMbrNo());
        statChgHistService.insertStatChgHistInfo(statChgHistInfo);

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         */
        try {

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.SECEDE_MENTOR_APPLY);

            message.setPayload(MemberPayLoad.of(user.getMbrNo(), message, false));

            messageTransferManager.invokeTransfer(message);
        }catch (Exception e){
            log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
        }
        /*
        if(CodeConstants.CD100204_101503_개인멘토.equals(user.getMbrCualfCd())) {
            user.setMbrStatCd(CodeConstants.CD100861_101572_탈퇴요청);
            userService.updateSecession(user);

             * 메일발송에서 실패가 있더라도 무시한다.
            try {

                Message message = new Message();
                message.setSendType(MessageSendType.EMS);
                message.setContentType(MessageType.SECEDE_MENTOR_APPLY);

                message.setPayload(MemberPayLoad.of(user.getMbrNo(), message, false));

                messageTransferManager.invokeTransfer(message);
            }catch (Exception e){
                log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
            }
        }else {
            user.setMbrStatCd(CodeConstants.CD100861_100864_탈퇴);
            userService.updateSecession(user);

             * 메일발송에서 실패가 있더라도 무시한다.
            try {

                Message message = new Message();
                message.setSendType(MessageSendType.EMS);
                message.setContentType(MessageType.SECEDE_MENTOR);

                message.setPayload(MemberPayLoad.of(user.getMbrNo(), message, false));

                messageTransferManager.invokeTransfer(message);
            }catch (Exception e){
                log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
            }
        }*/

        // 로그아웃 처리
        session.invalidate();
        SecurityContextHolder.getContext().setAuthentication(null);
        SecurityContextHolder.clearContext();
    }
}
