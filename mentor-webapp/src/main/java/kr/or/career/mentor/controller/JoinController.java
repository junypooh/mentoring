package kr.or.career.mentor.controller;

import com.google.common.collect.Maps;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.security.EgovFileScrty;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.StatChgHistService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.ValidationUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.validation.Validator;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.validation.Valid;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Autowired
    private StatChgHistService statChgHistService;

    @InitBinder
    protected void initBinder(WebDataBinder binder){
        binder.setValidator(this.validator);
    }

    @ModelAttribute("user")
    public User user() {
        return new User(); // populates user for the first time if its null
    }

    @RequestMapping(value = "step1.do")
    public void start(SessionStatus sessionStatus) {
        log.debug("{}", RequestContextHolder.getRequestAttributes());
        sessionStatus.setComplete();
    }

    @RequestMapping(value= "step2.do")
    public String clauseAgree(@Valid @ModelAttribute User user, BindingResult result, Model model) {

        // Validation 오류 발생시 게시글 정보 등록화면으로 이동
        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError e : list) {
                log.error(" ObjectError : " + e);
            }

            model.addAttribute("user", user);
            return "join/step2";
        }

        return null;
    }

    @RequestMapping(value="step3.do", method={RequestMethod.POST,RequestMethod.GET})
    public ModelAndView joinInfoWrite(@Valid @ModelAttribute User user, BindingResult result, Model model) {

        String mbrNo = user.getMbrNo();
        if(mbrNo != null){
            Map param = Maps.newHashMap();
            param.put("mbrNo",mbrNo);
            param.put("mbrStatCd","100863");
            user = userService.retrieveUser(param);

            MbrJobInfo jobInfo = userService.getMbrJobInfoByMbrNo(mbrNo);

            List<MbrJobChrstcInfo> jobChrstcInfos = userService.getMbrJobChrstcInfos(mbrNo);
            MbrProfInfo profInfo = userService.getMbrProfInfoBy(mbrNo);
            model.addAttribute("user",user);
            model.addAttribute("jobInfo",jobInfo);
            model.addAttribute("jobChrstcInfos",jobChrstcInfos);
            model.addAttribute("profInfo",profInfo);
            return new ModelAndView("join/step3");

        }else {

            if (!CodeConstants.CD100939_100941_가입동의.equals(user.getAgrees().get(0).getAgrClassCd())) {
                result.rejectValue("agrees[0].agrClassCd", "", CodeMessage.MSG_800001_이용약관에_동의해_주세요_.toMessage());
            }
            if (!CodeConstants.CD100939_100940_개인정보공개동의.equals(user.getAgrees().get(1).getAgrClassCd())) {
                result.rejectValue("agrees[1].agrClassCd", "", CodeMessage.MSG_800002_개인정보_수집이용에_동의해_주세요_.toMessage());
            }

            // Validation 오류 발생시 게시글 정보 등록화면으로 이동
            if (result.hasErrors()) {
                // 에러 출력
                List<ObjectError> list = result.getAllErrors();
                for (ObjectError e : list) {
                    log.error(" ObjectError : " + e);
                }

                return new ModelAndView("join/step2");
            }
            return new ModelAndView("join/step3");
        }
    }

    @RequestMapping(value="step4.do", method=RequestMethod.POST)
    public String joinFinish(@Valid @ModelAttribute User user, BindingResult result, Model model, SessionStatus sessionStatus) throws ParseException {
        model.addAttribute("user", user);
        String mbrNo = user.getMbrNo();

        if (StringUtils.isEmpty(user.getUsername())) {
            result.rejectValue("username", "", "이름을 입력 해 주세요");
        }
        if (StringUtils.isEmpty(user.getId())) {
            result.rejectValue("id", "", "ID를 입력 해 주세요");
        }

        if (StringUtils.isEmpty(mbrNo) && StringUtils.isNotBlank(user.getId()) && !userService.isValidateId(user.getId())) {
            ValidationUtils.rejectIf(result, CodeMessage.MSG_800000_이미_등록된_아이디_입니다_);
        }
        if (StringUtils.isNotBlank(user.getEmailAddr()) && !userService.isValidateEmail(user.getEmailAddr())) {
            ValidationUtils.rejectIf(result, CodeMessage.MSG_800019_이미_등록된_이메일_입니다_);
        }

        try {
            InternetAddress emailAddr = new InternetAddress(user.getEmailAddr());
            emailAddr.validate();
        } catch (AddressException e) {
            result.rejectValue("emailAddr", "", "이메일을 입력 해 주세요");
        }

        // Validation 오류 발생시 게시글 정보 등록화면으로 이동
        if (result.hasErrors()) {
            // 에러 출력
            List<ObjectError> list = result.getAllErrors();
            for (ObjectError e : list) {
                log.error(" ObjectError : " + e);
            }

            return "join/step3";
        }

        //101505	100857	멘토
        user.setMbrClassCd(CodeConstants.CD100857_101505_멘토);

        //101502	100204	기업멘토	기업체 소속 멘토
        //101503	100204	개인멘토
        user.setMbrCualfCd(CodeConstants.CD100204_101503_개인멘토);
        user.setMbrGradeCd("0");

        // 상태
        user.setMbrStatCd(CodeConstants.CD100861_101506_승인요청);
        user.setLoginPermYn("N");

        if(StringUtils.isNotEmpty(mbrNo)){

            try {

                user.setChgMbrNo(user.getMbrNo());
                user.setPassword(EgovFileScrty.encryptPassword(user.getPassword(), user.getId()));
                userService.updateMentorMember(user);

            } catch (Exception e) {
                result.rejectValue("marryYn", "", "저장 중 오류 발생");
                log.error("USER INSERT ERROR {}",e.toString());
                return "join/step3";
            }
            sessionStatus.setComplete();
        } else {


            try {

                userService.insertUser(user);

                // 승인 요청 이력 데이터 생성
                StatChgHistInfo statChgHistInfo = new StatChgHistInfo();
                statChgHistInfo.setStatChgClassCd(CodeConstants.CD101718_101719_회원가입요청상태);
                statChgHistInfo.setStatChgTargtMbrNo(user.getMbrNo());
                statChgHistInfo.setStatChgRsltCd(user.getMbrStatCd()); // CodeConstants.CD100861_101506_승인요청
                statChgHistInfo.setRegMbrNo(user.getMbrNo());
                statChgHistService.insertStatChgHistInfo(statChgHistInfo);

            } catch (Exception e) {
                result.rejectValue("marryYn", "", "저장 중 오류 발생");
                log.error("USER INSERT ERROR {}",e.toString());
                return "join/step3";
            }
            sessionStatus.setComplete();

        }

        //100944	100939	메일수집동의	이메일 수신

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         */
        try {
            MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
            reciever.setMailAddress(user.getEmailAddr());

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.JOIN_APPLY);
            message.addReciever(reciever);

            MemberPayLoad  memberPayLoad = MemberPayLoad.of(user.getMbrNo(),message,true);
            memberPayLoad.setName(user.getUsername());
            memberPayLoad.setId(user.getId());
            message.setPayload(memberPayLoad);

            messageTransferManager.invokeTransfer(message);
        }catch (Exception e){
            log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
        }
        return null;
    }

    @RequestMapping(value="ajax.checkIdDupl.do", method=RequestMethod.GET)
    @ResponseBody
    public Map<String,String> checkIdDupl(@RequestParam Map<String, String> params) throws SchedulerException {
        Map<String,String> rtn = new HashMap<>();
        boolean success = true;
        if(!userService.idValidate(params.get("id"))){//접합한 ID인지 확인
            success = false;
            rtn.put("success", String.valueOf(success));
            rtn.put("type", "id_validate");
            rtn.put("message", "아이디는 5자리 ~ 12자리 영문 소문자 , 숫자 및 기호 '_', '-' 만 사용 가능합니다.");
        }
        if(success){
            success = userService.isValidateId(params.get("id"));

            rtn.put("success", String.valueOf(success));
            if(!success){
                rtn.put("message", "동일한 ID가 존재합니다.");
                rtn.put("type", "id_duplicate");
            }
        }

        return rtn;
    }

    @RequestMapping(value="idPwSearch")
    public void idPwSearch(@Valid @ModelAttribute User user, BindingResult result, Model model) {
        //공통코드 E-mail 주소 콤보 조회
        Code code = new Code();
        code.setSupCd("100533");
        model.addAttribute("code100533", codeManagementService.listCode(code));

        //비밀번호 질문
        code.setSupCd("100221");
        model.addAttribute("code100221", codeManagementService.listCode(code));
    }

    @RequestMapping(value="idSearchFinish", method=RequestMethod.POST)
    public String idSearch(@Valid @ModelAttribute User user, BindingResult result, @RequestParam Map<String, String> params, Model model) {
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
        //공통코드 E-mail 주소 콤보 조회
        Code code = new Code();
        code.setSupCd("100533");
        model.addAttribute("code100533", codeManagementService.listCode(code));

        //비밀번호 질문
        code.setSupCd("100221");
        model.addAttribute("code100221", codeManagementService.listCode(code));
        model.addAttribute("message", "입력하신 정보로 가입된 아이디가 없습니다.");
        return "join/idPwSearch";
    }

    @RequestMapping(value="ajax.pwSearchFinish.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,String> pwSearch(@Valid @ModelAttribute User user, BindingResult result, @RequestParam Map<String, String> params, Model model) throws Exception {
        Map<String,String> rtnData = new HashMap<>();
        if(StringUtils.isNotEmpty(params.get("id"))){
            List<User> findedUser = userService.listUser(params);
            if(findedUser != null && findedUser.size() > 0){
                String password = userService.updatePwdRandom(findedUser);
                rtnData.put("success", "true");
                rtnData.put("password",password);
            }else{
                rtnData.put("success", "false");
                rtnData.put("message", "입력하신 정보로 가입된 정보가 없습니다.");
            }
        }
        return rtnData;
    }

    @RequestMapping(value="ajax.idPwSearchWithEmail.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String,String> idPwSearchWithEmail(@Valid @ModelAttribute User user, BindingResult result, @RequestParam Map<String, String> params, Model model) throws Exception {
        List<User> findedUser = userService.retrieveUserByEmail(params);
        Map<String,String> rtnData = new HashMap<>();
        if(findedUser != null){
            userService.updatePwdRandom(findedUser);

            rtnData.put("success", "true");
            rtnData.put("message", "입력하신 E-mail로 아이디/비밀번호를 발송 했습니다.");
        }else{
            rtnData.put("success", "false");
            rtnData.put("message", "입력하신 정보로 가입된 정보가 없습니다.");
        }
        return rtnData;
    }
}
