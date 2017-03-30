package kr.or.career.mentor.controller;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.dao.JobMapper;
import kr.or.career.mentor.domain.JobInfo;
import kr.or.career.mentor.domain.LectureDTO;
import kr.or.career.mentor.domain.MentorDTO;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.service.JobService;
import kr.or.career.mentor.service.MentorManagementService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@RequestMapping("/mentor/jobIntroduce")
@Controller
@Slf4j
public class JobIntroduceController {

    @Autowired
    private JobMapper jobMapper;

    @Autowired
    private JobService jobService;

    @Autowired
    private MentorManagementService mentorManagementService;

    /**
     * <pre>
     * 멘토 직업 목록을 조회하는 화면으로 이동
     * </pre>
     *
     * @param search
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping("/listJobIntroduce.do")
    public void listJobIntroduce(@ModelAttribute("mentorSearch") MentorSearch search, Model model) {
        log.debug("[request] search: {}", search);

        if (StringUtils.isNotBlank(search.getSearchKey())
                || StringUtils.isNotBlank(search.getJobClsfCd())
                || CollectionUtils.isNotEmpty(search.getChrstcClsfCds())) {
            return;
        }

        model.addAttribute("recomJobList", mentorManagementService.listRecomJobInfo());
    }

    /**
     * <pre>
     * 멘토 직업 목록 조회 (Ajax) 형대로 결과 반환
     * </pre>
     *
     * @param search
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.listJobInfo.do")
    public List<JobInfo> listJobIntroduceAjax(@Pageable(size = 9) MentorSearch search) {
        log.debug("[request] search: {}", search);

        return jobService.listJobInfoBy(search);
    }

    /**
     * <pre>
     * 직업정보 상세보기 화면 이동
     * </pre>
     *
     * @param jobNo
     * @param model
     */
    @RequestMapping("/showJobIntroduce.do")
    public void showJobIntroduce(String jobNo, Model model) {
        log.debug("[request] jobNo: {}", jobNo);

        model.addAttribute("jobInfo", jobMapper.getJobInfo(jobNo));

        MentorSearch search = new MentorSearch();
        search.setPageable(true);
        search.setCurrentPageNo(1);
        search.setRecordCountPerPage(5);
        search.setJobNo(jobNo);
        model.addAttribute("relMentorList", jobMapper.listRelationMentor(search));
    }

    /**
     * <pre>
     * 직업정보 (직업소개) 상세 정보
     * </pre>
     *
     * @param jobNo
     * @param model
     */
    @RequestMapping("/sub/tabJobIntroduce.do")
    public void tabJobIntroduce(String jobNo, Model model) {
        log.debug("[request] jobNo: {}", jobNo);

        model.addAttribute("jobInfo", jobMapper.getJobInfo(jobNo));
        model.addAttribute("newsList", jobMapper.listScrpInfoByJob(jobNo, "101518")); // 뉴스
        model.addAttribute("interviewList", jobMapper.listScrpInfoByJob(jobNo, "101519")); // 인터뷰
        model.addAttribute("movieList", jobMapper.listScrpInfoByJob(jobNo, "101520")); // 동영상
    }

    /**
     * <pre>
     * 직업정보 (관련메토) 상세 정보
     */
    @RequestMapping("/sub/tabRelationMentor.do")
    public void tabRelationMentor()  {
    }


    /**
     * <pre>
     * 직업정보 (관련메토) 상세 정보
     */
    @RequestMapping("/sub/ajax.relationMentor.do")
    @ResponseBody
    public List<MentorDTO> relationMentorAjax(@Pageable MentorSearch search)  {
        log.debug("[request] search: {}", search);

        return jobMapper.listRelationMentor(search);
    }


    /**
     * <pre>
     * 직업정보 (관련메토) 상세 정보
     */
    @RequestMapping("/sub/tabRelationLecture.do")
    public void tabRelationLecture()  {
    }


    /**
     * <pre>
     * 직업정보 (관련메토) 상세 정보
     */
    @RequestMapping("/sub/ajax.relationLecture.do")
    @ResponseBody
    public List<LectureDTO> tabRelationLectureAjax(@Pageable MentorSearch search)  {
        log.debug("[request] search: {}", search);

        return jobMapper.listRelationLecture(search);
    }

    /**
     * <pre>
     * 멘토 > 직업소개 리스트 (Ajax) 형대로 결과 반환
     * </pre>
     *
     * @param search
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.listJobIntroduce.do")
    public List<JobInfo> listJobInfo(@Pageable(size = 9) MentorSearch search) {
        log.debug("[request] search: {}", search);

        return jobService.listJobInfo(search);
    }

}
