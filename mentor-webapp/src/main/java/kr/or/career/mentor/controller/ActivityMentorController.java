package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.ActivityMentorInfo;
import kr.or.career.mentor.domain.JobClsfDTO;
import kr.or.career.mentor.service.ActivityMentorService;
import kr.or.career.mentor.service.MentorCommonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *      ActivityMentorController
 *
 * 활동멘토 Controller
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-20 오후 5:07
 */

@Controller
@RequestMapping("/activity")
public class ActivityMentorController {

    @Autowired
    private MentorCommonService mentorCommonService;

    @Autowired
    private ActivityMentorService activityMentorService;

    /**
     * 직업분류 목록 (멘토 수) + 검색(멘토명, 직업명, 직업태그)
     * @return
     */
    @RequestMapping("/ajax.jobClsfInfoSearch.do")
    @ResponseBody
    public List<JobClsfDTO> listJobClsfInfoStndMentoWithSearch(@RequestParam String value) {
        return mentorCommonService.listJobClsfInfoStndMentoWithSearch(value);
    }

    /**
     * 직업 분류별 멘토 목록
     * @return
     */
    @RequestMapping("/ajax.activityMentors.do")
    @ResponseBody
    public List<ActivityMentorInfo> listActivityMentors(@Pageable ActivityMentorInfo activityMentorInfo) {
        return activityMentorService.selectActivityMentors(activityMentorInfo);
    }
}
