/* license */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.MessageSendType;
import kr.or.career.mentor.constant.MessageType;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.CodeManagementService;
import kr.or.career.mentor.service.FileManagementService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.transfer.MessageTransferManager;
import lombok.SneakyThrows;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MyInfoController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 25. 오전 10:12:14
 * @author  technear
 * @see
 */
@Controller
@Slf4j
@RequestMapping("myPage/myInfo")
public class MyInfoController {

    @Autowired
    protected UserService userService;

    @Autowired
    protected CodeManagementService codeManagementService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private MessageTransferManager messageTransferManager;

    @RequestMapping("myInfoView")
    public void myInfoView(Model model, Authentication authentication){
        //가장 최근에 등록된 학교 정보
        //가장 최근에 등록된 번 정보
        model.addAttribute("user", authentication.getPrincipal());
    }

    @RequestMapping(value="myInfoEdit", method=RequestMethod.GET)
    public void myInfoEdit(Model model, Authentication authentication){
        model.addAttribute("user", authentication.getPrincipal());

      //공통코드 E-mail 주소 콤보 조회
        Code code = new Code();
        code.setSupCd("100533");
        model.addAttribute("code100533", codeManagementService.listCode(code));

        //비밀번호 질문
        code.setSupCd("100221");
        model.addAttribute("code100221", codeManagementService.listCode(code));

    }

    @RequestMapping(value="myInfoEdit", method=RequestMethod.POST)
    public String myInfoUpdate(@ModelAttribute User user, BindingResult result, Model model, Authentication authentication) throws Exception{
        User sessionUser = (User) authentication.getPrincipal();
        user.setId(sessionUser.getId());
        user.setMbrNo(sessionUser.getMbrNo());

        if(!userService.emailValidate(user.getEmailAddr())){
            result.rejectValue("emailAddr", "", "이메일을 입력 해 주세요");
        }

        try {
            InternetAddress emailAddr = new InternetAddress(user.getEmailAddr());
            emailAddr.validate();
        } catch (AddressException e) {
            result.rejectValue("emailAddr", "", "이메일을 입력 해 주세요");
        }

        if (result.hasErrors()) {
            model.addAttribute("user", user);

          //공통코드 E-mail 주소 콤보 조회
            Code code = new Code();
            code.setSupCd("100533");
            model.addAttribute("code100533", codeManagementService.listCode(code));

            //비밀번호 질문
            code.setSupCd("100221");
            model.addAttribute("code100221", codeManagementService.listCode(code));

            return "myPage/myInfo/myInfoEdit";
        }

        // 수정자 설정
        user.setChgMbrNo(sessionUser.getMbrNo());
        user.setTmpPwdYn("Y");
        userService.updateUser(user);

        sessionUser.setBirthday(user.getBirthday());
        sessionUser.setMobile(user.getMobile());
        sessionUser.setAgrees(user.getAgrees());
        sessionUser.setPwdQuestNm(user.getPwdQuestNm());
        sessionUser.setPwdQuestCd(user.getPwdQuestCd());
        sessionUser.setPwdAnsSust(user.getPwdAnsSust());
        sessionUser.setLunarYn(user.getLunarYn());

        //Authentication authentication2 = new UsernamePasswordAuthenticationToken(user, sessionUser.getPassword(), sessionUser.getAuthorities());
        //SecurityContextHolder.getContext().setAuthentication(authentication2);
        return "redirect:/myPage/myInfo/myInfoView.do";
    }


    @RequestMapping(value="secessionFinish")
    @SneakyThrows
    public void secessionFinish(Authentication authentication, HttpSession session){
        User user = (User) authentication.getPrincipal();
        user.setMbrStatCd(CodeConstants.CD100861_100864_탈퇴);
        userService.updateSecession(user);

        /**
         * 메일발송에서 실패가 있더라도 무시한다.
         *
         */
        try {
            MessageReciever reciever = MessageReciever.of(user.getMbrNo(),true);
            reciever.setMailAddress(user.getEmailAddr());

            Message message = new Message();
            message.setSendType(MessageSendType.EMS.getValue());
            message.setContentType(MessageType.SECEDE_SCHOOL);
            message.addReciever(reciever);

            MemberPayLoad  memberPayLoad = MemberPayLoad.of(user.getMbrNo(),message,true);
            memberPayLoad.setName(user.getUsername());
            memberPayLoad.setId(user.getId());
            message.setPayload(memberPayLoad);

            messageTransferManager.invokeTransfer(message);
        } catch (Exception e) {
            log.debug("Exception 처리가 필요치 않음.메시지 발송 실패하더라도 비지니스 로직은 작동해야하므로 Exception을 무시한다.");
        }

        //세션 제거
        session.invalidate();
        SecurityContextHolder.getContext().setAuthentication(null);
        SecurityContextHolder.clearContext();
    }

    /**
    *
    * <pre>
    * 파일을 Server로 Upload한다.
    * </pre>
    *
    * @param upload_file
    * @return
    * @throws Exception
    */@RequestMapping(value="/uploadFile.do",produces="text/plain;charset=UTF-8")
   @ResponseBody
   public String uploadFile(@RequestParam CommonsMultipartFile upload_file, Authentication authentication) throws Exception {
       FileInfo fileInfo = fileManagementService.fileProcess(upload_file,"TEST");
       Integer fileSize = Integer.parseInt(fileInfo.getFileSize());
       if(fileInfo.getFileMime().indexOf("image/") >= 0 && fileSize<5*1024*1024){

           MbrProfPicInfo mbrProfPicInfo = new MbrProfPicInfo();
           mbrProfPicInfo.setFileSer(fileInfo.getFileSer());
           User user = (User) authentication.getPrincipal();
           mbrProfPicInfo.setMbrNo(user.getMbrNo());
           //나의 프로필 사진 정보 갱신
           userService.saveProfPicInfo(mbrProfPicInfo);
           List<MbrProfPicInfo> lMbrProfPicInfo = new ArrayList<>();
           lMbrProfPicInfo.add(mbrProfPicInfo);
           user.setMbrpropicInfos(lMbrProfPicInfo);
       }else{
           fileInfo.setFileSer(-1);
       }
        StringBuilder sb = new StringBuilder()
                .append("{\"fileSer\":\"").append(fileInfo.getFileSer()).append("\",")
                .append("\"oriFileNm\":\"").append(fileInfo.getOriFileNm()).append("\",")
                .append("\"fileSize\":\"").append(fileInfo.getFileSize()).append("\"}");

        return sb.toString();
   }

   @RequestMapping("ajax.deletePropPic.do")
   @ResponseBody
   public int deletePropPic(@ModelAttribute MbrProfPicInfo mbrProfPicInfo , Authentication authentication) throws Exception {
       User user = (User) authentication.getPrincipal();
       mbrProfPicInfo.setMbrNo(user.getMbrNo());
       //나의 프로필 사진 정보 갱신
       int rtn = userService.deleteProfPicInfo(mbrProfPicInfo);
       if(rtn > 0){
           user.setMbrpropicInfos(null);
       }
       return rtn;
   }
}
