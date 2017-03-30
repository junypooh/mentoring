package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.domain.Code;
import kr.or.career.mentor.domain.FileInfo;
import kr.or.career.mentor.domain.MnuInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.*;
import kr.or.career.mentor.util.AESCipherUtils;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.util.EgovProperties;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
public class CommonController {

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

    private static List<MnuInfo> listMenuInfo = null;

    @RequestMapping("**")
    public void defaultPath(Authentication authentication) {
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
     */
    @RequestMapping(value="/uploadFile.do",produces="text/plain;charset=UTF-8")
    @ResponseBody
    public String uploadFile(@RequestParam CommonsMultipartFile upload_file) throws Exception {

        FileInfo fileInfo = fileManagementService.fileProcess(upload_file, "TEST");

        StringBuilder sb = new StringBuilder()
                .append("{\"fileSer\":\"").append(fileInfo.getFileSer()).append("\",")
                .append("\"oriFileNm\":\"").append(fileInfo.getOriFileNm()).append("\",")
                .append("\"fileSize\":\"").append(fileInfo.getFileSize()).append("\",")
                .append("\"fileExt\":\"").append(fileInfo.getFileExt()).append("\"}");

        return sb.toString();
    }

    /**
     *
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
    public void downloadFile(@RequestParam int fileSer, @RequestParam(required=false) String origin, HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        fileManagementService.downloadFile(fileSer, "true".equals(origin) ? true: false , request, response);
    }

    /**
     * <pre>
     * 게시글에 포함된 파일을 압축해서 다운로드
     * </pre>
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

    public List<MnuInfo> listMnuInfo() {
        if (listMenuInfo == null) {
            Map<String, String> param = new HashMap<>();
            param.put("mnuId", Constants.MNU_CODE_SCHOOL);
            param.put("mbrNo", "NULL");
            listMenuInfo = mnuInfoService.listMnuInfoByMbrNo(param);
        }
        return listMenuInfo;
    }

    /**
     *
     * <pre>
     * 공통코드 정보를 가져온다.
     * </pre>
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
     * 나의 관심 멘토 여부
     *
     * @param itrstTargtNo
     * @param authentication
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.isMyInterestForMentor.do")
    public boolean isMyInterestForMentorAjax(@RequestParam String itrstTargtNo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return false;
        }

        User user = (User) authentication.getPrincipal();
        return myInterestService.isMyInterestForMentor(user, itrstTargtNo);
    }


    /**
     * 나의 관심 멘토 등록
     *
     * @param itrstTargtNo
     * @param authentication
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.saveMyInterestForMentor.do")
    public JSONResponse saveMyInterestForMentorAjax(@RequestParam String itrstTargtNo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            myInterestService.saveMyInterestForMentor(user, itrstTargtNo);

            return JSONResponse.success(CodeMessage.MSG_100002_X0_님_관심멘토가_등록되었습니다_.toMessage(user.getUsername()));
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
     * 나의 관심 직업 등록
     * @param itrstTargtNo
     * @param authentication
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.saveMyInterestForJob.do")
    public JSONResponse saveMyInterestForJobAjax(@RequestParam String itrstTargtNo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            myInterestService.saveMyInterestForJob(user, itrstTargtNo);

            return JSONResponse.success(CodeMessage.MSG_100003_X0_님_관심직업_등록되었습니다_.toMessage(user.getUsername()));
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
     * 나의 관심 직업 여부
     * @param itrstTargtNo
     * @param authentication
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.isMyInterestForJob.do")
    public boolean isMyInterestForJobAjax(@RequestParam String itrstTargtNo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return false;
        }

        User user = (User) authentication.getPrincipal();
        return myInterestService.isMyInterestForJob(user, itrstTargtNo);

    }

    /**
     * 나의 관심 수업 등록
     *
     * @param itrstTargtNo
     * @param authentication
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.saveMyInterestForLecture.do")
    public JSONResponse saveMyInterestForJobLecture(@RequestParam String itrstTargtNo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return JSONResponse.failure(CodeMessage.MSG_100001_로그인이_필요한_서비스_입니다_);
        }

        try {
            User user = (User) authentication.getPrincipal();
            myInterestService.saveMyInterestForLecture(user, itrstTargtNo);

            return JSONResponse.success(CodeMessage.MSG_100004_X0_님_관심수업_등록되었습니다_.toMessage(user.getUsername()));
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
     * 나의 관심 수업 여부
     *
     * @param itrstTargtNo
     * @param authentication
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.isMyInterestForLecture.do")
    public boolean isMyInterestForJobLecture(@RequestParam String itrstTargtNo, Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            return false;
        }

        User user = (User) authentication.getPrincipal();
        return myInterestService.isMyInterestForLecture(user, itrstTargtNo);
    }

    @RequestMapping("ajax.encriptBase64.do")
    @ResponseBody
    public Map<String,String> encriptBase64(String sid, String classSer, Authentication authentication) throws Exception {
        Map<String,String> rtn = new HashMap<>();
        if(authentication != null){
            User user = (User) authentication.getPrincipal();
            if(classSer == null)
                classSer = user.getClasRoomSer();

            rtn.put("sid", AESCipherUtils.encriptBase64(sid));
            if(CodeConstants.CD100857_100859_교사.equals(user.getMbrClassCd()) && classSer != null) {
                rtn.put("userId", EgovProperties.getProperty("TOMMS_PREFIX") + user.getMbrNo() + classSer);
            }else{
                rtn.put("userId", EgovProperties.getProperty("TOMMS_PREFIX") + user.getMbrNo());
            }
        }
        return rtn;
    }
}
