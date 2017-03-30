package kr.or.career.mentor.controller;

import com.google.common.collect.Maps;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.ValidationUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.Validator;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;

import javax.annotation.Resource;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.validation.Valid;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.*;

@Controller
@RequestMapping("join")
@SessionAttributes("user")
@Slf4j
public class JoinController {
    @Resource
    Validator validator;

    @Autowired
    protected UserService userService;

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @InitBinder
    protected void initBinder(WebDataBinder binder) {
        binder.setValidator(this.validator);
    }

    @ModelAttribute("user")
    public User user() {
        return new User(); // populates user for the first time if its null
    }
    @RequestMapping(value = "step1")
    public void clauseAgree(SessionStatus sessionStatus) {
        sessionStatus.setComplete();
    }


    @RequestMapping(value = "step2")
    public String clauseAgree(@Valid @ModelAttribute User user, BindingResult result, Model model) {

        // Validation 오류 발생시 게시글 정보 등록화면으로 이동
        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError e : list) {
                log.error(" ObjectError : " + e);
            }

            return "join/step2";
        }

        // 100939 //동의코드
        return null;
    }

    @RequestMapping(value = "step3.do", method = RequestMethod.POST)
    public String joinInfoWrite(@Valid @ModelAttribute User user, BindingResult result, Model model) {

        ValidationUtils.rejectIfEmpty(result, "agrees[0].agrClassCd", CodeMessage.MSG_800001_이용약관에_동의해_주세요_);
        ValidationUtils.rejectIfEmpty(result, "agrees[1].agrClassCd", CodeMessage.MSG_800002_개인정보_수집이용에_동의해_주세요_);

        // 100944 100939 메일수집동의 이메일 수신
        // Validation 오류 발생시 게시글 정보 등록화면으로 이동
        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError e : list) {
                log.error(" ObjectError : " + e);
            }

            return "join/step2";
        }

        // 공통코드 E-mail 주소 콤보 조회
        // Code code = new Code();
        // code.setSupCd("100533");
        // model.addAttribute("code100533",
        // codeManagementService.listCode(code));

        // 비밀번호 질문
        // code.setSupCd("100221");
        // model.addAttribute("code100221",
        // codeManagementService.listCode(code));

        return null;
    }

    @RequestMapping(value = "step4.do", method = RequestMethod.POST)
    public String joinFinish(@Valid @ModelAttribute User user, BindingResult result, Model model,
            SessionStatus sessionStatus) {

        try {
            ValidationUtils.rejectIfEmpty(result, "username", CodeMessage.MSG_800003_이름을_입력_해_주세요_);
            ValidationUtils.rejectIfEmpty(result, "id", CodeMessage.MSG_800004_ID를_입력_해_주세요_);
            ValidationUtils.rejectIfId(result, "id", CodeMessage.MSG_810001_ID가_형식에_맞지_않습니다__5자리___12자리_영문__숫자_및_기호__________만_가능합니다_);
            ValidationUtils.rejectIfEmpty(result, "password", CodeMessage.MSG_800010_비밀번호를_입력_해_주세요_);
            ValidationUtils.rejectIfPassword(result, "password", CodeMessage.MSG_810002_비밀번호가가_형식에_맞지_않습니다__영문__숫자_또는_특수문자를_포함한_10_20자리가_가능합니다_);
            ValidationUtils.rejectIfEmpty(result, "emailAddr", CodeMessage.MSG_800006_이메일을_입력_해_주세요_);
            ValidationUtils.rejectIfEmail(result, "emailAddr", CodeMessage.MSG_800007_이메일이_형식에_맞지_않습니다_);
            if (StringUtils.isNotBlank(user.getId()) && !userService.isValidateId(user.getId())) {
                ValidationUtils.rejectIf(result, CodeMessage.MSG_800000_이미_등록된_아이디_입니다_);
            }
            if (StringUtils.isNotBlank(user.getEmailAddr()) && !userService.isValidateEmail(user.getEmailAddr())) {
                ValidationUtils.rejectIf(result, CodeMessage.MSG_800019_이미_등록된_이메일_입니다_);
            }

            Date birthday = DateUtils.parseDate(user.getBirthday(), "yyyyMMdd");
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.YEAR, -14);
            Date user14 = cal.getTime();

            if (user14.compareTo(birthday) < 0 && !user.getMbrClassCd().equals(CodeConstants.CD100857_100859_교사)) {
                ValidationUtils.rejectIfEmpty(result, "prtctrEmailAddr", CodeMessage.MSG_800008_보호자_이메일을_입력_해_주세요_);
                ValidationUtils.rejectIfEmail(result, "prtctrEmailAddr", CodeMessage.MSG_800009_보호자_이메일이_형식에_맞지_않습니다_);

                if(StringUtils.isNotBlank(user.getPrtctrEmailAddr()) && StringUtils.isNotBlank(user.getEmailAddr())) {
                    if(user.getPrtctrEmailAddr().equals(user.getEmailAddr())) {
                        ValidationUtils.rejectIf(result, CodeMessage.MSG_800018_보호자_이메일과_회원의_이메일이_같을_수_없습니다_);
                    }
                }

                user.setMbrStatCd(CodeConstants.CD100861_101506_승인요청);
            } else {
                user.setMbrStatCd(CodeConstants.CD100861_100862_정상이용);
            }

            // 100944 100939 메일수집동의 이메일 수신
            // Validation 오류 발생시 게시글 정보 등록화면으로 이동
            if (result.hasErrors()) {
                // 에러 출력
                List<ObjectError> list = result.getAllErrors();
                for (ObjectError e : list) {
                    log.error(" ObjectError : " + e);
                }
                return "join/step3";
            }
            if (user14.compareTo(birthday) < 0) {
                MbrAgrInfo mbrAgrInfo = new MbrAgrInfo();
                mbrAgrInfo.setAgrClassCd(CodeConstants.CD100939_100971_미성년자가입부모동의);
                user.getAgrees().add(mbrAgrInfo);
            }
            user.setMbrGradeCd("0");
            userService.insertUser(user);

            sessionStatus.setComplete();

            // 14세 미만일 경우 부모 Email로 승인 요청 메일 발송
            if (user14.compareTo(birthday) < 0) {
                /**
                 * 메일발송에서 실패가 있더라도 무시한다.
                 *
                 */
                try {
                    MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
                    reciever.setMailAddress(user.getPrtctrEmailAddr());

                    Message message = new Message();
                    message.setSendType(MessageSendType.EMS.getValue());
                    message.setContentType(MessageType.JOIN_AGREE);
                    message.addReciever(reciever);

                    MemberPayLoad  memberPayLoad = MemberPayLoad.of(user.getMbrNo(),message,true);
                    memberPayLoad.setName(user.getUsername());
                    memberPayLoad.setId(user.getId());
                    message.setPayload(memberPayLoad);

                    messageTransferManager.invokeTransfer(message);
                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }
            }else {
                /**
                 * 메일발송에서 실패가 있더라도 무시한다.
                 *
                 */
                try {
                    MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
                    reciever.setMailAddress(user.getEmailAddr());

                    Message message = new Message();
                    message.setSendType(MessageSendType.EMS.getValue());
                    message.setContentType(MessageType.JOIN_SCHOOL);
                    message.addReciever(reciever);

                    MemberPayLoad  memberPayLoad = MemberPayLoad.of(user.getMbrNo(),message,true);
                    memberPayLoad.setName(user.getUsername());
                    memberPayLoad.setId(user.getId());
                    message.setPayload(memberPayLoad);

                    messageTransferManager.invokeTransfer(message);
                } catch (Exception e) {
                    log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
                }
            }
            return null;
        }
        catch (Exception e) {
            log.error("USER INSERT ERROR {}", e.toString());
            model.addAttribute("errorCode", CodeMessage.ERROR_000002_저장중_오류가_발생하였습니다_);
            return "join/step3";
        }
    }

    @RequestMapping(value = "approve", method = RequestMethod.POST)
    public String approve(@Valid @ModelAttribute User user,BindingResult result) throws InvalidKeyException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException {

        userService.approveUser(user);

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         *
         */
        try {
            MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
            reciever.setMailAddress(user.getEmailAddr());

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.JOIN_SCHOOL);
            message.addReciever(reciever);

            MemberPayLoad  memberPayLoad = MemberPayLoad.of(user.getMbrNo(),message,true);
            memberPayLoad.setName(user.getUsername());
            memberPayLoad.setId(user.getId());
            message.setPayload(memberPayLoad);

            messageTransferManager.invokeTransfer(message);
        } catch (Exception e) {
            log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
        }


        return "redirect:/index.do";
    }

    @RequestMapping(value = "minorMemberJoin.do", method = RequestMethod.GET)
    public String minorMemberJoin(@RequestParam(value="mbrNo") String mbrNo,Model model) {

        User user = userService.getUserByNo(mbrNo);

        model.addAttribute("user",user);
        return "join/minorMemberJoin";
    }

    @RequestMapping(value = "ajax.checkIdDupl.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, String> checkIdDupl(@RequestParam Map<String, String> params) {
        Map<String, String> rtn = new HashMap<>();
        boolean success = true;
        if (!userService.idValidate(params.get("id"))) {// 접합한 ID인지 확인
            success = false;
            rtn.put("success", String.valueOf(success));
            rtn.put("type", "id_validate");
            rtn.put("message", "아이디는 5자리 ~ 12자리 영문 소문자 , 숫자 및 기호 '_', '-' 만 사용 가능합니다.");
        }
        if (success) {
            success = userService.isValidateId(params.get("id"));

            rtn.put("success", String.valueOf(success));
            if (!success) {
                rtn.put("message", "동일한 ID가 존재합니다.");
                rtn.put("type", "id_duplicate");
            }
        }

        return rtn;
    }

    @RequestMapping(value = {"idPwSearch","idSearchFinish"}, method = RequestMethod.GET)
    public void idPwSearch(@Valid @ModelAttribute User user, BindingResult result, Model model) {
        // 공통코드 E-mail 주소 콤보 조회
        Code code = new Code();
        code.setSupCd("100533");
        model.addAttribute("code100533", codeManagementService.listCode(code));

        // 비밀번호 질문
        code.setSupCd("100221");
        model.addAttribute("code100221", codeManagementService.listCode(code));
    }

    @RequestMapping(value = "idSearchFinish", method = RequestMethod.POST)
    public String idSearch(@Valid @ModelAttribute User user, BindingResult result,
            @RequestParam Map<String, String> params, Model model) {

        params.put("userType", Constants.SCHOOL);
        List<User> listUser = userService.listUser(params);
        if (listUser != null && listUser.size() > 0) {
            for(User findedUser : listUser){
                int idLength = findedUser.getId().length();
                findedUser.setId(StringUtils.rightPad(findedUser.getId().substring(0, idLength / 2), idLength, "*"));
            }
            model.addAttribute("listUser", listUser);
            model.addAttribute("user", listUser.get(0));
            return null;
        }
        model.addAttribute("message", "입력하신 정보로 가입된 아이디가 없습니다.");

     // 공통코드 E-mail 주소 콤보 조회
        Code code = new Code();
        code.setSupCd("100533");
        model.addAttribute("code100533", codeManagementService.listCode(code));

        // 비밀번호 질문
        code.setSupCd("100221");
        model.addAttribute("code100221", codeManagementService.listCode(code));

        return "join/idPwSearch";
    }

    @RequestMapping(value = "ajax.pwSearchFinish.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> pwSearch(@Valid @ModelAttribute User user, BindingResult result,
            @RequestParam Map<String, String> params, Model model) throws Exception {

        params.put("userType", Constants.SCHOOL);
        List<User> listUser = userService.listUser(params);

        for(User usr : listUser){
            usr.setTmpPwdYn("N");
        }

        Map<String, String> rtnData = new HashMap<>();
        if (listUser != null && listUser.size() > 0) {
            String password = userService.updatePwdRandom(listUser);
            rtnData.put("success", "true");
            rtnData.put("password", password);
        }
        else {
            rtnData.put("success", "false");
            rtnData.put("message", "입력하신 정보로 가입된 정보가 없습니다.");
        }
        return rtnData;
    }

    @RequestMapping(value = "ajax.idPwSearchWithEmail.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> idPwSearchWithEmail(@Valid @ModelAttribute User user, BindingResult result,
            @RequestParam Map<String, String> params, Model model) throws Exception {
        params.put("userType","SCHOOL");
        List<User> findedUser = userService.retrieveUserByEmail(params);
        for(User usr : findedUser){
            usr.setTmpPwdYn("N");
        }
        Map<String, String> rtnData = new HashMap<>();
        if (findedUser != null && findedUser.size() > 0) {
            userService.updatePwdRandom(findedUser);
            rtnData.put("success", "true");
            rtnData.put("message", "입력하신 E-mail로 아이디/비밀번호를 발송 했습니다.");
        }
        else {
            rtnData.put("success", "false");
            rtnData.put("message", "입력하신 정보로 가입된 정보가 없습니다.");
        }
        return rtnData;
    }

    @RequestMapping(value = {"protectorMail"}, method = RequestMethod.GET)
    public String protectorMail(Authentication authentication, Model model) {
        if(authentication == null){
            return "redirect:/index.do";
        }
        User sessionUser = (User) authentication.getPrincipal();
        User user = new User();
        user.setMbrNo(sessionUser.getMbrNo());
        user.setPrtctrEmailAddr(sessionUser.getPrtctrEmailAddr());
        model.addAttribute("user", user);
        //model.addAttribute("prtctrEmailAddr", sessionUser.getPrtctrEmailAddr());
        SecurityContextHolder.clearContext();
        return null;
    }

    @RequestMapping(value = {"ajax.resendMail.do"}, method = RequestMethod.POST)
    @ResponseBody
    public Map<String,String> protectorMail(@Valid @ModelAttribute User user, BindingResult result, Model model) {

        Map<String, String> rtnData = new HashMap<>();

        ValidationUtils.rejectIfEmpty(result, "prtctrEmailAddr", CodeMessage.MSG_800006_이메일을_입력_해_주세요_);
        ValidationUtils.rejectIfEmail(result, "prtctrEmailAddr", CodeMessage.MSG_800007_이메일이_형식에_맞지_않습니다_);

        Map param = Maps.newHashMap();
        param.put("mbrNo", user.getMbrNo());
        User member = userService.retrieveUser(param);
        if(user.getPrtctrEmailAddr().equals(member.getEmailAddr())) {
            ValidationUtils.rejectIf(result, CodeMessage.MSG_800018_보호자_이메일과_회원의_이메일이_같을_수_없습니다_);
        }

        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();

            String message = "";
            for (ObjectError e : list) {
                log.error(" ObjectError : " + e);
                message = e.getDefaultMessage();
            }

            rtnData.put("success", "false");
            rtnData.put("message", message);

            return rtnData;
        }



        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         *
         */
        try {
            MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
            reciever.setMailAddress(user.getPrtctrEmailAddr());

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.JOIN_AGREE);
            message.addReciever(reciever);

            message.setPayload(MemberPayLoad.of(user.getMbrNo(), message, false));

            messageTransferManager.invokeTransfer(message);

            rtnData.put("success", "true");
            rtnData.put("message", "메일이 발송되었습니다.");


        } catch (Exception e) {
            log.error(e.getMessage());
            rtnData.put("success", "false");
            rtnData.put("message", "메일 발송이 실패하였습니다.");
        }
        return rtnData;
    }

}
