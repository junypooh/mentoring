package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.ChrstcClsfDTO;
import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.service.MentorCommonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/mentor/common")
public class MentorCommonController {

    @Autowired
    private MentorCommonService mentorCommonService;

    /**
     * 특성 분류 목록
     * @return
     */
    @RequestMapping("/ajax.chrstcClsf.do")
    @ResponseBody
    public List<ChrstcClsfDTO> chrstcClsfAjax() {
        return mentorCommonService.listChrstcClsf();
    }

    /**
     * 직업분류 목록
     * @return
     */
    @RequestMapping("/ajax.jobClsf.do")
    @ResponseBody
    public List<JobClsfDTO> jobClsfAjax() {
        return mentorCommonService.listJobClsf();
    }
}
