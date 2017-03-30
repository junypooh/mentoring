package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.JobInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.exception.CnetException;
import kr.or.career.mentor.service.JobClsfCdManagementService;
import kr.or.career.mentor.util.CodeMessage;
import kr.or.career.mentor.view.JSONResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      OprJobController
 *
 * 운영관리 > 직업관리 Class
 *
 * </pre>
 *
 * @author DaDa
 * @see
 * @since 2016-06-20 오후 2:20
 */
@Controller
@RequestMapping("/opr/job")
public class OprJobController {

    @Autowired
    private JobClsfCdManagementService jobClsfCdManagementService;

    /**
     * <pre>
     *     운영관리 직업관리 리스트 조회
     * </pre>
     * @param jobInfo
     * @return
     */
    @RequestMapping("/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000300")
    public List<JobInfo> getJobClsfList(@Pageable JobInfo jobInfo){
        jobInfo.setOrderBy("A.REG_DTM DESC");
        return jobClsfCdManagementService.getJobInfo(jobInfo);
    }

    /**
     * <pre>
     *     운영관리 직업관리 리스트 조회
     * </pre>
     * @param jobInfo
     * @return
     */
    @RequestMapping("/ajax.view.do")
    @ResponseBody
    @Historic(workId = "1000000301")
    public List<JobInfo> getJobClsfView(JobInfo jobInfo){
        return jobClsfCdManagementService.getJobInfo(jobInfo);

    }

    @RequestMapping("/ajax.regist.do")
    @ResponseBody
    @Historic(workId = "1000000302")
    public JSONResponse registJobInfo(JobInfo jobInfo, Authentication authentication) {
        CodeMessage codeMessage = null;

        User user = (User) authentication.getPrincipal();
        jobInfo.setRegMbrNo(user.getMbrNo());

        try{
            if(StringUtils.stripToNull(jobInfo.getJobNo()) == null){
                String rtnStr = jobClsfCdManagementService.registJobInfo(jobInfo);
                if("SUCCESS".equals(rtnStr)){
                    codeMessage = CodeMessage.MSG_900001_등록_되었습니다_;
                }else if("OVERLAP".equals(rtnStr)){
                    codeMessage = CodeMessage.MSG_800016_기_등록된_직업이_존재합니다;
                }else{
                    codeMessage = CodeMessage.MSG_900002_등록_실패_하였습니다_;
                }
            }else{
                String rtnStr = jobClsfCdManagementService.updateJobInfo(jobInfo);
                if("SUCCESS".equals(rtnStr)){
                    codeMessage = CodeMessage.MSG_900003_수정_되었습니다_;
                }else if("OVERLAP".equals(rtnStr)){
                    codeMessage = CodeMessage.MSG_800016_기_등록된_직업이_존재합니다;
                }else{
                    codeMessage = CodeMessage.MSG_900008_수정_실패_하였습니다_;
                }
            }
        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.getCode());
    }

    @RequestMapping("/ajax.delete.do")
    @ResponseBody
    @Historic(workId = "1000000303")
    public JSONResponse deleteJobInfo(JobInfo jobInfo){
        CodeMessage codeMessage = null;
        try{
            String rtnStr = jobClsfCdManagementService.deleteJobInfo(jobInfo);
            if("SUCCESS".equals(rtnStr)){
                codeMessage = CodeMessage.MSG_900004_삭제_되었습니다_;
            }else if("OVERLAP".equals(rtnStr)){
                codeMessage = CodeMessage.MSG_800017_해당_직업명을_사용중인_멘토가_있습니다_멘토의_직업명을_변경_후_삭제해주세요_;
            }else{
                codeMessage = CodeMessage.MSG_900009_삭제_실패_하였습니다_;
            }
        }catch (Exception e){
            codeMessage = CodeMessage.ERROR_000001_시스템_오류_입니다_;
            if (e instanceof CnetException) {
                codeMessage = ((CnetException) e).getCode();
            }
            return JSONResponse.failure(codeMessage, e);
        }
        return JSONResponse.success(codeMessage.getCode());
    }

}
