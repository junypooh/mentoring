package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.*;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
public class MainController {
    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private MyInterestService myInterestService;

    @Autowired
    private UserService userService;

    @Autowired
    private MnuInfoService mnuInfoService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    protected BannerService bannerService;

    @Autowired
    CodeManagementService codeManagementService;

    @Autowired
    MentorManagementService mentorManagementService;

    @Autowired
    private ComunityService comunityService;

    @Autowired
    private ActivityMentorService activityMentorService;

    @Autowired
    private MentorCommonService mentorCommonService;

    @RequestMapping("ajax.lectureList.do")
    public String ajaxLectureList(LectureApplInfoDTO lectureApplInfoDTO, Authentication authentication, Model model) {

        List<LectureInfomationDTO> list = null;
        String noLectMsg = "";
        switch (lectureApplInfoDTO.getLectRunTime()) {
            case "recomm" : // 추천수업
                list = lectureManagementService.listRecentRecommandLecture();
                noLectMsg = "수업이 없습니다.";
                break;
            case "close" : // 마감임박수업
                list = lectureManagementService.listSoonCloseLecture();
                noLectMsg = "마감 임박 수업이 없습니다.";
                break;
            case "new" : // 신규수업
                list = lectureManagementService.listNewLecture();
                noLectMsg = "수업이 없습니다.";
                break;
        }

        model.addAttribute("recommandLecture", list);
        model.addAttribute("noLectMsg", noLectMsg);

        return "index";
    }

    @RequestMapping("index.do")
    public void main(Model model, Authentication authentication) {

        // 나의 수업
        if (authentication != null) {
            LectureApplInfoDTO lectureApplInfoDTO = new LectureApplInfoDTO();
            User user = (User) authentication.getPrincipal();
            lectureApplInfoDTO.setApplMbrNo(user.getMbrNo());
            lectureApplInfoDTO.setSetSer(0);

            List<LectureApplInfoDTO> myLessionList = null;
            if(CodeConstants.CD100857_100859_교사.equals(user.getMbrClassCd())){
                myLessionList = lectureManagementService.listAppliedLecture(lectureApplInfoDTO);
            }else{
                // 내가 속한 교실에서 신청한 수업 목록
                myLessionList = lectureManagementService.listAppliedLectureByMyClassroom(lectureApplInfoDTO);
            }
            model.addAttribute("myLessionList", myLessionList);
        }

       // 상단 배너 정보 최대 5개
        BnrInfo banner = new BnrInfo();
        banner.setPageable(true);
        banner.setUseYn("Y");
        banner.setSite(CodeConstants.CD101633_101635_SCHOOL);       //학교포탈
        banner.setBnrTypeCd(CodeConstants.CD101637_101639_메인배너); // 101639 - 메인배너
        banner.setCurrentPageNo(1);
        banner.setRecordCountPerPage(5);
        List<BnrInfo> bnrInfoList = bannerService.listBanner(banner);
        model.addAttribute("bnrInfoList", bnrInfoList);

        // 추천 수업
        model.addAttribute("recommandLecture", lectureManagementService.listRecentRecommandLecture());
        model.addAttribute("noLectMsg", "수업이 없습니다.");

        // HOT 멘토
        ActivityMentorInfo activityMentorInfo = new ActivityMentorInfo();
        activityMentorInfo.setClsfCd("100040");
        activityMentorInfo.setPageable(true);
        activityMentorInfo.setCurrentPageNo(1);
        activityMentorInfo.setRecordCountPerPage(8);
        activityMentorInfo.setRecomTargtCd(CodeConstants.CD101641_101757_HOT멘토);
        List<ActivityMentorInfo> hotActivityMentorInfos = activityMentorService.selectActivityMentors(activityMentorInfo);
        model.addAttribute("hotMentors", hotActivityMentorInfos);

        // NEW 멘토
        List<MentorDTO> mentorInfos = mentorCommonService.listNewMentorInfo();
        model.addAttribute("mentorInfos", mentorInfos);

        // 활동 멘토
        model.addAttribute("listJobClsf", mentorCommonService.listJobClsfInfoStndMento());

        ArclInfo<T> arclInfo = new ArclInfo<T>();
        arclInfo.setDispNotice(false);
        arclInfo.setRecordCountPerPage(5);
        arclInfo.setPageable(true);
        arclInfo.setFileCnt(-1);

        // QNA 5개
        arclInfo.setBoardId(Constants.BOARD_ID_LEC_QNA);
        model.addAttribute("lecQnAs", comunityService.getArticleListWithoutFile(arclInfo));

        // 공지사항 5개
        arclInfo.setBoardId(Constants.BOARD_ID_NOTICE);
//        arclInfo.setDispNotice(true);
        arclInfo.setExpsTargtCd(CodeConstants.CD101633_101635_SCHOOL);
        model.addAttribute("lecNoticeBoards", comunityService.getArticleListWithoutFile(arclInfo));

    }

 // 내가 신청한 수업 목록
    @RequestMapping("ajax.listAppliedLecture.do")
    @ResponseBody
    public List<LectureApplInfoDTO> listAppliedLecture(LectureApplInfoDTO lectureApplInfoDTO,
            Authentication authentication) throws Exception {
        if (authentication != null) {
            User user = (User) authentication.getPrincipal();
            lectureApplInfoDTO.setApplMbrNo(user.getMbrNo());
            if (lectureApplInfoDTO.getSetSer() == null) {
                lectureApplInfoDTO.setSetSer(0);
            }

            if(CodeConstants.CD100857_100859_교사.equals(user.getMbrClassCd())){
                return lectureManagementService.listAppliedLecture(lectureApplInfoDTO);
            }else{
                // 내가 속한 교실에서 신청한 수업 목록
                return lectureManagementService.listAppliedLectureByMyClassroom(lectureApplInfoDTO);
            }
        }
        return null;
    }


    /**
    *
    * <pre>
    * 모바일 나의수업 리스트 = 모바일 메인화면
    * </pre>
    * @param lectApplInfo
    * @param authentication
    * @return
    * @throws Exception
    */
   @RequestMapping("mobile/ajax.myLectureList.do")
   @ResponseBody
   public Map myLectureList(@Pageable LectApplInfo lectApplInfo, Authentication authentication) throws Exception {
       Map model = new HashMap();
       User user = (User) authentication.getPrincipal();
       lectApplInfo.setApplMbrNo(user.getMbrNo());
       lectApplInfo.setMbrClassCd(user.getMbrClassCd());
       lectApplInfo.setLectTypeCd("m");

       model = lectureManagementService.myLectureList(lectApplInfo);
//model.get
       log.info("mobile/main==============================================get mbr no{}"+user.getMbrNo());
       log.info("mobile/main==============================================get mbr classcd{}"+user.getMbrClassCd());
       log.info("mobile/main==============================================");
       log.info("mobile/main==============================================");
       log.info("mobile/main==============================================");
       log.info("mobile/main==============================================");
       
       
       return model;
   }
   
   @RequestMapping("mobile/noticeSetting.do")
   public Map noticeSetting(Authentication authentication) throws Exception {
       Map model = new HashMap();
       User user = (User) authentication.getPrincipal();


       List<MbrAgrInfo> noticeAgree = userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100992_모바일노티스동의);
       List<MbrAgrInfo> studyAgree = userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_101680_모바일수업알림동의);
       
       if(noticeAgree.size() > 0)
    	   model.put("noticeAgree", "Y");
       
       if(studyAgree.size() > 0)
    	   model.put("studyAgree", "Y");
       
       return model;
   }


    @RequestMapping("mobile/ajax.firstAgreementNotification.do")
     @ResponseBody
     public JSONResponse firstAgreementPushNotification(Authentication authentication){

        try {
            User user = (User) authentication.getPrincipal();
            userService.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100992_모바일노티스동의);
            userService.mergeMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_101680_모바일수업알림동의);

            return JSONResponse.success(CodeMessage.MSG_900001_등록_되었습니다_.toMessage());
        }catch(Exception e){
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;

            return JSONResponse.failure(codeMessage);
        }

    }

    @RequestMapping("mobile/ajax.agreementNotification.do")
    @ResponseBody
    public JSONResponse agreetPushNotificationAgreement(String code, Authentication authentication) {

        try {
            User user = (User) authentication.getPrincipal();
            userService.mergeMbrAgrInfo(user.getMbrNo(), code);

            return JSONResponse.success("SUCCESS");
        }catch(Exception e){
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;

            return JSONResponse.failure(codeMessage);
        }

    }

    @RequestMapping("mobile/ajax.removeNotification.do")
     @ResponseBody
     public JSONResponse removePushNotificationAgreement(String code, Authentication authentication) {
        try {
            User user = (User) authentication.getPrincipal();
            userService.deleteMbrAgrInfo(user.getMbrNo(), code);

            return JSONResponse.success("SUCCESS");
        }catch(Exception e){
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;

            return JSONResponse.failure(codeMessage);
        }

    }


    @RequestMapping("mobile/ajax.refreshPushDeviceInfo.do")
    @ResponseBody
    public JSONResponse refreshPushDeviceInfo(MbrDvcInfo dvcInfo, Authentication authentication) {

        try {
            User user = (User) authentication.getPrincipal();
            dvcInfo.setMbrNo(user.getMbrNo());

            userService.deleteDeviceInfo(dvcInfo);
            userService.upsertDeviceInfo(dvcInfo);

            return JSONResponse.success("SUCCESS");
        }catch(Exception e){
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;

            return JSONResponse.failure(codeMessage);
        }

    }
}
