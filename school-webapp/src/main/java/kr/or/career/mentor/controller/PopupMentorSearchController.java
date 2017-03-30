/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.JobMentorInfoDTO;
import kr.or.career.mentor.domain.JobSearch;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    PopupMentorSearch
 *
 * 멘토찾기 팝업화면 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-21 오후 1:30
 */
@Controller
@RequestMapping("lecture/lectureTotal")
public class PopupMentorSearchController {

    @Autowired
    private LectureManagementService lectureManagementService;

//    @RequestMapping("popupMentorSearch.do")
//    public String popupMentorSearch() throws Exception {
//        return "lecture/lectureTotal/popupMentorSearch";
//    }

    @RequestMapping("jobDetailSearch.do")
    @ResponseBody
    public List<JobMentorInfoDTO> jobDetailSearch(@Pageable JobSearch jobSearch) throws Exception {
        List<JobMentorInfoDTO> jobInfoList = lectureManagementService.jobDetailSearch(jobSearch);
        return jobInfoList;
    }
}

