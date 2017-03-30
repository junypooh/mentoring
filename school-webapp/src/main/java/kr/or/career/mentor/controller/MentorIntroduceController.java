package kr.or.career.mentor.controller;

import java.util.List;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.dao.MbrJobChrstcInfoMapper;
import kr.or.career.mentor.dao.MbrProfPicInfoMapper;
import kr.or.career.mentor.dao.MbrProfScrpInfoMapper;
import kr.or.career.mentor.dao.MentorCommonMapper;
import kr.or.career.mentor.dao.MentorMapper;
import kr.or.career.mentor.domain.ArclInfo;
import kr.or.career.mentor.domain.LectDataInfo;
import kr.or.career.mentor.domain.MentorDTO;
import kr.or.career.mentor.domain.MentorSearch;
import kr.or.career.mentor.service.ComunityService;
import kr.or.career.mentor.service.LectureDataService;
import kr.or.career.mentor.service.MentorIntroduceService;
import lombok.extern.slf4j.Slf4j;

import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/mentor/mentorIntroduce")
@Slf4j
public class MentorIntroduceController {

    @Autowired
    private MentorMapper mentorMapper;
    @Autowired
    private ComunityService comunityService;
    @Autowired
    private LectureDataService lectureDataService;
    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;
    @Autowired
    private MbrProfScrpInfoMapper mbrProfScrpInfoMapper;
    @Autowired
    private MentorCommonMapper mentorCommonMapper;
    @Autowired
    private MbrJobChrstcInfoMapper mbrJobChrstcInfoMapper;
    @Autowired
    private MentorIntroduceService mentorIntroduceService;

    /**
     * 기존 멘토 소개 목록
     *
     * @param search
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.listMentorInfo.do")
    public List<MentorDTO> listMentorIntroduceAjax(@Pageable(size = 9) MentorSearch search) {
        // DEFAULT SEARCH VALUE
        search.setSchSiteExpsYn("Y");
        log.debug("[request] search: {}", search);

        return mentorMapper.listMentorInfo(search);
    }

    /**
     * 멘토 소개 상세 정보
     *
     * @param mbrNo
     * @param model
     */
    @RequestMapping("/showMentorIntroduce.do")
    public void showJobIntroduce(@RequestParam("mbrNo") String mbrNo, Model model) {
        log.debug("[request] mbrNo: {}", mbrNo);

        model.addAttribute("mentor", mentorIntroduceService.getMentorInfoBy(mbrNo));
        model.addAttribute("listMbrJobChrstcInfos", mentorIntroduceService.listMbrJobChrstcInfoBy(mbrNo));
        model.addAttribute("listMbrProfPicInfo", mentorIntroduceService.listMbrProfPicInfoBy(mbrNo));
        model.addAttribute("listMbrProfScrpInfo", mentorIntroduceService.listMbrProfScrpInfoBy(mbrNo));
    }

    /**
     * 멘토 소개 목록
     *
     * @param mentorSearch
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.selectMentorList.do")
    public List<MentorDTO> selectMentorIntroduce(@Pageable MentorSearch mentorSearch) {
        // DEFAULT SEARCH VALUE
        mentorSearch.setSchSiteExpsYn("Y");
        log.debug("[request] mentorSearch: {}", mentorSearch);

        return mentorIntroduceService.selectMentorIntroduce(mentorSearch);
    }

    /**
     * 멘토 소개 상세 - Tab: 멘토소개
     *
     * @param mbrNo
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.mentorIntroduce.do")
    public MentorDTO mentorIntroduceAjax(@RequestParam("mbrNo") String mbrNo) {
        return mentorIntroduceService.getMentorInfoBy(mbrNo);
    }

    /**
     * 멘토 소개 상세 - Tab: 문의하기
     *
     * @param arclInfo
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.getMentorArclInfoList.do")
    public List<ArclInfo<T>> mentorArclInfoListAjax(@Pageable  ArclInfo<T> arclInfo) {
        return comunityService.getMentorArclInfoList(arclInfo);
    }

    /**
     * 멘토 소개 상세 - Tab: 멘토자료
     *
     * @param lectDataInfo
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.lectureDataList.do")
    public List<LectDataInfo> lectureDataListAjax(@Pageable LectDataInfo lectDataInfo) throws Exception{
        return lectureDataService.selectMbrDataInfo(lectDataInfo);
    }

    /**
     * <pre>
     *     멘토 소개 상세 - Tab: 멘토자료 - 연결수업 조회
     * </pre>
     * @param lectDataInfo
     * @return
     */
    @RequestMapping("/ajax.connectLectList.do")
    @ResponseBody
    public List<LectDataInfo> ajaxConnectLectList(LectDataInfo lectDataInfo){
        return lectureDataService.selectConnectLectList(lectDataInfo);
    }

    /**
     * 멘토 소개 상세 - Tab: 관련멘토
     *
     * @param mentorSearch
     * @return
     */
    @ResponseBody
    @RequestMapping("/ajax.mentorRelation.do")
    public List<MentorDTO> MentorRelationList(@Pageable MentorSearch mentorSearch) {
        return mentorIntroduceService.selectMentorRelation(mentorSearch);
    }

}
