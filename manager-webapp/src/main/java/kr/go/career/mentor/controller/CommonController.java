/* license */
package kr.go.career.mentor.controller;

import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.job.WithdrawApplyCountByFailedObservationJob;
import kr.or.career.mentor.job.LectureStatusUpdateJob;
import kr.or.career.mentor.security.EgovFileScrty;
import kr.or.career.mentor.service.*;
import kr.or.career.mentor.util.AESCipherUtils;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.util.SessionUtils;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.log4j.Log4j2;
import org.apache.commons.lang3.StringUtils;
import org.quartz.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    CommonController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author technear
 * @see
 * @since 2015. 10. 15. 오전 9:31:09
 */
@Controller
@Log4j2
public class CommonController {

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private UserService userService;

    @Autowired
    private MentorManagementService mentorManagementService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private JobClsfCdManagementService jobClsfCdManagementService;

    @Autowired
    private SchInfoService schInfoService;

    @Autowired
    StudioService studioService;

    @Autowired
    private AuthService authService;

    @Autowired
    private MnuInfoService mnuInfoService;

    @Autowired
    private SchedulerFactoryBean quartzScheduler;

    private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);

    @RequestMapping("**")
    public void main(Authentication authentication) {
        // if(authentication != null){
        // User user = (User) authentication.getPrincipal();
        // Collection<SimpleGrantedAuthority> authorities =
        // (Collection<SimpleGrantedAuthority>)
        // SecurityContextHolder.getContext().getAuthentication().getAuthorities();
        // log.debug("Login User Info =>"+user.toString());
        // }
        log.info("{}", "aaaa");
    }

    // @RequestMapping("/main/ajax.monthInfo.do")
    // @ResponseBody
    // public List<Map<String,Object>> monthInfo(@RequestParam Map<String,
    // Object> params) throws SchedulerException {
    // return lectureManagementService.monthlyLectureInfo(params);
    // }

    @RequestMapping("ajax.mentorList.do")
    @ResponseBody
    public List<MentorDTO> mentorList(@ModelAttribute MentorSearch search) throws Exception {
        return mentorManagementService.listMentorInfo(search);
    }

    @RequestMapping("ajax.lectureList.do")
    @ResponseBody
    public List<LectInfo> lectureList(@ModelAttribute LectureSearch lectureSearch) throws Exception {
        return lectureManagementService.listLectInfo(lectureSearch);
    }

    @RequestMapping("ajax.listSchool.do")
    @ResponseBody
    public List<SchInfo> listSchool(@ModelAttribute SchInfo schInfo) throws Exception {
        schInfo.setUseYn("Y");
        return schInfoService.listSchInfo(schInfo);
    }


    @RequestMapping("ajax.listAssignSchool.do")
    @ResponseBody
    public List<SchInfo> listAssignSchool(@RequestBody SchInfo schInfo) throws Exception {
        schInfo.setUseYn("Y");

        return schInfoService.listSchInfo(schInfo);
    }

    @RequestMapping("ajax.listCorpo.do")
    @ResponseBody
    public List<CoInfo> listCorpo(@ModelAttribute CoInfo coInfo) throws Exception {
        return codeManagementService.listCoInfo(coInfo);
    }

    @RequestMapping("ajax.listStudio.do")
    @ResponseBody
    public List<StdoInfo> main(@ModelAttribute StdoInfo stdoInfo) {
        return studioService.listStudioPaging(stdoInfo);
    }

    @RequestMapping("/main/editorTest.do")
    public String editTest(@RequestParam Map<String, Object> params, Model model) {
        model.addAttribute("params", params);
        return "hello/hello";
    }

    @RequestMapping(value = "/uploadFile.do", produces = "text/plain;charset=UTF-8")
    @ResponseBody
    public String uploadFile(@RequestParam CommonsMultipartFile upload_file) throws Exception {

        FileInfo fileInfo = fileManagementService.fileProcess(upload_file, "test");

        StringBuilder sb = new StringBuilder()
                .append("{\"fileSer\":\"").append(fileInfo.getFileSer()).append("\",")
                .append("\"oriFileNm\":\"").append(fileInfo.getOriFileNm()).append("\",")
                .append("\"fileSize\":\"").append(fileInfo.getFileSize()).append("\",")
                .append("\"fileExt\":\"").append(fileInfo.getFileExt()).append("\"}");

        return sb.toString();
    }

    /**
     * <pre>
     * 파일을 다운로드 한다.
     * </pre>
     *
     * @param fileSer
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/fileDown.do")
    public void downloadFile(@RequestParam int fileSer, @RequestParam(required = false) String origin, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        fileManagementService.downloadFile(fileSer, "true".equals(origin) ? true : false, request, response);
    }

    /**
     * <pre> 게시글에 포함된 파일을 압축해서 다운로드 </pre>
     *
     * @param arclSer
     * @param boardId
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/fileDownAll.do")
    public void downloadFiles(@RequestParam int arclSer, @RequestParam String boardId, HttpServletRequest request,
                              HttpServletResponse response) throws Exception {
        fileManagementService.downloadFile(arclSer, boardId, request, response);
    }

    /**
     * <pre>
     * 수업상태 변경 배치
     * </pre>
     *
     * @throws SchedulerException
     */
    @PostConstruct
    public void autoSchedule() throws SchedulerException {
        Scheduler scheduler = quartzScheduler.getScheduler();

        JobDetail lectureStatusJob = JobBuilder.newJob(LectureStatusUpdateJob.class)
                .withIdentity("LECT_STATUS_CHANGER", "group1")
                .build();

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.SECOND, 10);

        Trigger lectureStatusTrigger = TriggerBuilder.newTrigger()
                .withIdentity("LECT_STATUS_CHANGER", "trigger1")
                .startAt(calendar.getTime()).build();

        JobDetail withdrawJob = JobBuilder.newJob(WithdrawApplyCountByFailedObservationJob.class)
                .withIdentity("rollbackObserver", "group2")
                .build();

        Trigger withdrawTrigger = TriggerBuilder.newTrigger()
                .withIdentity("rollbackObserver", "trigger2")
                .withSchedule(CronScheduleBuilder.cronSchedule("0 0 23 * * ?"))
                .build();

        if (!scheduler.isStarted()) {
            scheduler.start();

            //if(!scheduler.checkExists(lectureStatusJob.getKey())) {
                try {
                    scheduler.scheduleJob(lectureStatusJob, lectureStatusTrigger);
                }catch (ObjectAlreadyExistsException e){
                    scheduler.rescheduleJob(lectureStatusTrigger.getKey(),lectureStatusTrigger);
                }
            //}else{
            //    scheduler.resumeJob(lectureStatusJob.getKey());
            //}

            if(!scheduler.checkExists(withdrawJob.getKey())) {
                scheduler.scheduleJob(withdrawJob, withdrawTrigger);
            }else{
                scheduler.resumeJob(withdrawJob.getKey());
            }
        }
    }

    @RequestMapping("/popup/lectureSearch.do")
    public void lectureSearch(Model model) {
        Code codeParam = new Code();
        codeParam.setSupCd("101533");
        List<Code> schoolGrd = codeManagementService.listCode(codeParam); // 강의대상
        model.addAttribute("schoolGrd", schoolGrd);

        codeParam.setSupCd("101528");
        List<Code> lectType = codeManagementService.listCode(codeParam); // 강의유형

        model.addAttribute("lectType", lectType);
    }

    /**
     * <pre>
     * 공통코드 정보를 가져온다.
     * </pre>
     *
     * @param code
     * @return
     * @throws Exception
     */
    @RequestMapping("ajax.code.do")
    @ResponseBody
    public List<Code> code(Code code) throws Exception {
        return codeManagementService.listCode(code);
    }

    @RequestMapping("ajax.encriptBase64.do")
    @ResponseBody
    public Map<String, String> encriptBase64(String sid, Authentication authentication) throws Exception {
        Map<String, String> rtn = new HashMap<>();
        if (authentication != null) {
            User user = (User) authentication.getPrincipal();
            rtn.put("sid", AESCipherUtils.encriptBase64(sid));
            rtn.put("userId", EgovProperties.getProperty("TOMMS_PREFIX") + user.getMbrNo());
        }
        return rtn;
    }

    @RequestMapping(value = "ajax.checkIdDupl.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, String> checkIdDupl(@RequestParam Map<String, String> params) throws SchedulerException {
        Map<String, String> rtn = new HashMap<>();
        boolean success = true;
        if (!userService.idValidate(params.get("id"))) {//접합한 ID인지 확인
            success = false;
            rtn.put("success", String.valueOf(success));
            rtn.put("message", "아이디는 5자리 ~ 12자리 영문 소문자 , 숫자 및 기호 '_', '-' 만 사용 가능합니다.");
        }
        if (success) {
            success = userService.isValidateId(params.get("id"));

            rtn.put("success", String.valueOf(success));
            if (!success) {
                rtn.put("message", "동일한 ID가 존재합니다.");
            }
        }

        return rtn;
    }

    /**
     * 직업 코드 정보
     *
     * @param jobClsfCd
     * @return
     * @throws Exception
     */
    @RequestMapping("jobClsfCd")
    @ResponseBody
    public List<JobClsfCd> jobClsfCd(JobClsfCd jobClsfCd) {
        return jobClsfCdManagementService.listJobClsfCd(jobClsfCd);
    }


    /**
     * 직업코드에 해당하는 직업정보
     *
     * @param jobInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("jobInfo")
    @ResponseBody
    public List<JobInfo> jobInfo(JobInfo jobInfo) {
        return jobClsfCdManagementService.listJobInfo(jobInfo);
    }


    /**
     * 해당 직업의 상위 직업코드를 모두 가져 온다
     *
     * @param jobNo
     * @return
     */
    @RequestMapping("jobClsfCdByJobNo")
    @ResponseBody
    public List<JobClsfCd> jobClsfCdByJobNo(@RequestParam String jobNo) {
        return jobClsfCdManagementService.listJobClsfCdByJobNo(jobNo);
    }

    /**
     * 관리자 권한을 모두 가져온다.
     *
     * @param authInfo
     * @return
     */
    @RequestMapping("ajax.authCdList.do")
    @ResponseBody
    public List<AuthInfo> authCdList(AuthInfo authInfo) {
        return authService.listAuthCdList(authInfo);
    }

    /**
     * GNB 메뉴 클릭 시 권한에 맞는 2Depth or 3Depth 첫번째 메뉴 URL을 리턴한다.
     *
     * @param authInfo
     * @return
     */
    @RequestMapping("ajax.gnb.do")
    public String gnbMenuMove(AuthInfo authInfo, RedirectAttributes redirectAttributes) {

        List<GlobalMnuInfo> globalMnuInfo = mnuInfoService.getGlobalMnuInfo(authInfo.getAuthCd(), authInfo.getMnuId());

        String linkUrl = globalMnuInfo.get(0).getLinkUrl();

        if (StringUtils.isEmpty(linkUrl)) {
            List<GlobalMnuInfo> subMnuInfos = globalMnuInfo.get(0).getGlobalSubMnuInfos();
            linkUrl = subMnuInfos.get(0).getLinkUrl();
        }

        return "redirect:" + linkUrl;
    }


    /**
     * 직업정보 등록
     *
     * @param jobInfo
     * @return
     * @throws Exception
     */
    @RequestMapping("/ajax.saveJobInfo.do")
    @ResponseBody
    public JSONResponse saveJobInfo(JobInfo jobInfo) {
        log.debug("[REQ] jobInfo: {}", jobInfo);

        try {
            List<JobInfo> jobInfos = jobClsfCdManagementService.saveJobInfo(jobInfo);
            if (jobInfos.size() == 0)
                return JSONResponse.success(null);
            else
                return JSONResponse.success(jobInfos);
        } catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }

    @RequestMapping(value="ajax.pwChange.do", method=RequestMethod.POST)
    @ResponseBody
    public JSONResponse pwChange(@RequestParam("password") String password,@RequestParam("new_password") String new_password, Model model) throws Exception {
        User user = new User();
        User sessionUser = SessionUtils.getUser();
        user.setPassword(EgovFileScrty.encryptPassword(password,sessionUser.getId()));
        user.setMbrNo(sessionUser.getMbrNo());
        user.setId(sessionUser.getId());
        if( userService.updatePwd(user,new_password) > 0){
            return JSONResponse.success(CodeMessage.MSG_900003_수정_되었습니다_.toMessage());
        }else{
            return JSONResponse.failure(CodeMessage.MSG_800012_비밀번호가_맞지_않습니다_.toMessage());
        }
    }
}
