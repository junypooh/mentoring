package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.job.TestJob;
import kr.or.career.mentor.service.*;
import kr.or.career.mentor.util.AESCipherUtils;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Calendar;
import java.util.*;


@Controller
@Slf4j
public class CommonController {

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private UserService userService;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private JobClsfCdManagementService jobClsfCdManagementService;


    @SuppressWarnings({ "unchecked" })
    @RequestMapping("**")
    public void main(Authentication authentication) {
        if (authentication != null) {
            User user = (User) authentication.getPrincipal();
            Collection<SimpleGrantedAuthority> authorities = (Collection<SimpleGrantedAuthority>) SecurityContextHolder
                    .getContext().getAuthentication().getAuthorities();
            log.debug("Login User Info => {}", user);
            log.debug("Login User Granted => {}", authorities);
        }
    }


    @RequestMapping("/main/editorTest.do")
    public String editTest(@RequestParam Map<String, Object> params, Model model) {
        model.addAttribute("params", params);
        return "hello/hello";
    }


    @RequestMapping(value="/uploadFile.do",produces="text/plain;charset=UTF-8")
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
     *
     * <pre> 파일을 다운로드 한다. </pre>
     *
     * @param fileSer
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/fileDown.do")
    public void downloadFile(@RequestParam int fileSer, @RequestParam(required=false) String origin, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        fileManagementService.downloadFile(fileSer, "true".equals(origin) ? true: false ,  request, response);
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
            if(jobInfos.size() == 0)

                return JSONResponse.success(null);
            else
                return JSONResponse.success(jobInfos);
        }
        catch (Exception e) {
            CodeMessage codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
    }


    /**
     * 코드 정보
     *
     * @param code
     * @return
     * @throws Exception
     */
    @RequestMapping("code")
    @ResponseBody
    public List<Code> code(Code code) throws Exception {
        return codeManagementService.listCode(code);
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
    public List<JobClsfCd> jobClsfCd(JobClsfCd jobClsfCd)  {
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
    public List<JobInfo> jobInfo(JobInfo jobInfo)  {
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

    @RequestMapping("ajax.encriptBase64.do")
    @ResponseBody
    public Map<String,String> encriptBase64(String sid, Authentication authentication) throws Exception {
        Map<String,String> rtn = new HashMap<>();
        if(authentication != null){
            User user = (User) authentication.getPrincipal();
            rtn.put("sid", AESCipherUtils.encriptBase64(sid));
            rtn.put("userId", EgovProperties.getProperty("TOMMS_PREFIX") + user.getMbrNo());
        }
        return rtn;
    }
}
