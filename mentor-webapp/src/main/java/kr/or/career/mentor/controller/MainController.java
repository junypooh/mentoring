package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.MbrProfPicInfoMapper;
import kr.or.career.mentor.dao.MbrProfScrpInfoMapper;
import kr.or.career.mentor.dao.MentorMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.*;
import kr.or.career.mentor.util.SessionUtils;
import org.apache.poi.ss.formula.functions.T;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
public class MainController {

    @Autowired
    private LectureManagementService lectureManagementService;

    @Autowired
    private UserService userService;

    @Autowired
    private MentorMapper mentorMapper;

    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;

    @Autowired
    private MbrProfScrpInfoMapper mbrProfScrpInfoMapper;

    @Autowired
    private FileManagementService fileManagementService;

    @Autowired
    private CodeManagementService codeManagementService;

    @Autowired
    private JobClsfCdManagementService jobClsfCdManagementService;

    @Autowired
    private ComunityService comunityService;

    @Autowired
    private BannerService bannerService;

    @Autowired
    private ActivityMentorService activityMentorService;

    @Autowired
    private MentorCommonService mentorCommonService;

    @RequestMapping("index")
    public String index(Model model, Authentication authentication) throws Exception {

        if(authentication == null){
            // 상단 배너 정보 최대 4개
            BnrInfo banner = new BnrInfo();
            banner.setPageable(true);
            banner.setUseYn("Y");
            banner.setSite(CodeConstants.CD101633_101636_MENTOR);       //멘토포탈
            banner.setBnrTypeCd(CodeConstants.CD101637_101640_홍보배너); // 101640 - 홍보배너
            banner.setCurrentPageNo(1);
            banner.setRecordCountPerPage(4);
            List<BnrInfo> bnrInfoList = bannerService.listBanner(banner);
            model.addAttribute("bnrInfoList", bnrInfoList);

            // 공지사항
            ArclInfo<T> arclInfo = new ArclInfo();
            arclInfo.setPageable(true);
            arclInfo.setCurrentPageNo(1);
            arclInfo.setRecordCountPerPage(1);
            arclInfo.setDispNotice(false);
            arclInfo.setBoardId(Constants.BOARD_ID_NOTICE);
            arclInfo.setExpsTargtCd(CodeConstants.CD101633_101636_MENTOR);

            List<ArclInfo<T>> arclInfos = comunityService.getArticleListWithoutFile(arclInfo);
            if(!CollectionUtils.isEmpty(arclInfos)) {
                model.addAttribute("noticeInfo", arclInfos.get(0));
            }

            // 멘토 NOW
            ActivityMentorInfo activityMentorInfo = new ActivityMentorInfo();
            activityMentorInfo.setClsfCd("100040");
            activityMentorInfo.setPageable(true);
            activityMentorInfo.setCurrentPageNo(1);
            activityMentorInfo.setRecordCountPerPage(30);
            List<ActivityMentorInfo> activityMentorInfos = activityMentorService.selectActivityMentors(activityMentorInfo);
            model.addAttribute("nowMentors", activityMentorInfos);

            // HOT 멘토
            activityMentorInfo.setRecomTargtCd(CodeConstants.CD101641_101757_HOT멘토);
            activityMentorInfo.setRecordCountPerPage(8);
            List<ActivityMentorInfo> hotActivityMentorInfos = activityMentorService.selectActivityMentors(activityMentorInfo);
            model.addAttribute("hotMentors", hotActivityMentorInfos);

            return "index";
        } else {
            // 총 누적 수업
            LectureStatusCountInfo info = new LectureStatusCountInfo();
            User user = SessionUtils.getUser();
            info.setMbrNo(user.getMbrNo());
            info.setMbrCualfCd(user.getMbrCualfCd());
            info.setMbrClassCd(user.getMbrClassCd());
            model.addAttribute("totLectInfo", lectureManagementService.mentorMainLectStatusCount(info));

            if(CodeConstants.CD100204_101503_개인멘토.equals(user.getMbrCualfCd()) || CodeConstants.CD100204_101502_소속멘토.equals(user.getMbrCualfCd())) {
                // 올해의 수업개설(개인멘토)
                LectReqInfo reqInfo = new LectReqInfo();
                reqInfo.setPageable(false);
                reqInfo.setReqMbrNo(user.getMbrNo());
                reqInfo.setReqTypeCd("101727");
                model.addAttribute("totLectReqInfo", lectureManagementService.selectLectReqInfoCount(reqInfo));

                // 수업 개설 반려 사유
                reqInfo.setAuthStatCd("101028");
                model.addAttribute("lectReqRejectList", lectureManagementService.selectLectReqInfoList(reqInfo));
            }

            // 한달간 수업현황(개인멘토/교육수행기관)
            info.setPeriod("month");
            model.addAttribute("monthLectInfo", lectureManagementService.mentorMainLectStatusCount(info));

            // 주간 수업 현황
            CalendarInfo calendarInfo = new CalendarInfo();
            model.addAttribute("calendarInfos", mentorCommonService.listThisWeekInfo(calendarInfo));

            LectureSearch lectureSearch = new LectureSearch();
            lectureSearch.setLectStatusCds(Arrays.asList("101543","101548","101549","101550","101551")); // 수강모집, 수업예정, 수업대기, 수업중, 수업완료

            Date today = new Date();     //오늘 날짜
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd"); //강의 시작날짜
            String strToDay = formatter.format(today);
            lectureSearch.setSearchStDate(strToDay);
            lectureSearch.setSearchEndDate(strToDay);
            lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
            lectureSearch.setMbrNo(user.getMbrNo());
            lectureSearch.setCoNo(user.getPosCoNo());
            lectureSearch.setViewType("mentorMain");
            model.addAttribute("lectureInfos", lectureManagementService.mentorLectureSchdList(lectureSearch));

            // 질문답변
            ArclInfo<T> arclInfo = new ArclInfo();
            arclInfo.setPageable(true);
            arclInfo.setCurrentPageNo(1);
            arclInfo.setRecordCountPerPage(5);
            arclInfo.setSrchMbrNo(user.getMbrNo());
            arclInfo.setMbrCualfCd(user.getMbrCualfCd());
            arclInfo.setAnsYn("N");
            arclInfo.setBoardId(Constants.BOARD_ID_LEC_QNA);
            model.addAttribute("lecQnAInfos", comunityService.getMentorArclInfoList(arclInfo));

            // 수업과제(질문답변과 동일 쿼리)
            arclInfo.setBoardId(Constants.BOARD_ID_LEC_WORK);
            model.addAttribute("lecWorkInfos", comunityService.getMentorArclInfoList(arclInfo));

            // 요청수업
            LectReqInfo lectReqInfo = new LectReqInfo();
            lectReqInfo.setPageable(true);
            lectReqInfo.setCurrentPageNo(1);
            lectReqInfo.setRecordCountPerPage(5);
            lectReqInfo.setMbrNo(user.getMbrNo());
            lectReqInfo.setMbrCualfCd(user.getMbrCualfCd());
            lectReqInfo.setCoNo(user.getPosCoNo());
            lectReqInfo.setReqTypeCd("101726");
            model.addAttribute("lectReqInfos", lectureManagementService.selectLectReqInfoList(lectReqInfo));

            // 공지사항
            ArclInfo<T> arclInfoByNotice = new ArclInfo();
            arclInfoByNotice.setPageable(true);
            arclInfoByNotice.setCurrentPageNo(1);
            arclInfoByNotice.setRecordCountPerPage(5);
            arclInfoByNotice.setDispNotice(false);
            arclInfoByNotice.setBoardId(Constants.BOARD_ID_NOTICE);
            arclInfoByNotice.setExpsTargtCd(CodeConstants.CD101633_101636_MENTOR);
            model.addAttribute("noticeInfos", comunityService.getArticleListWithoutFile(arclInfoByNotice));

           return "index_login";
        }

    }

    @RequestMapping("/main/ajax.weekDateInfo.do")
    @ResponseBody
    public List<CalendarInfo> weekDateInfo(CalendarInfo calendarInfo) throws SchedulerException {
        return mentorCommonService.listThisWeekInfo(calendarInfo);
    }

    @RequestMapping("/main/ajax.lectureInfo.do")
    @ResponseBody
    public List<LectureApplInfoDTO> lectureInfo(LectureSearch lectureSearch) throws SchedulerException {

        User user = SessionUtils.getUser();

        lectureSearch.setLectStatusCds(Arrays.asList("101543","101548","101549","101550","101551")); // 수강모집, 수업예정, 수업대기, 수업중, 수업완료
        lectureSearch.setMbrCualfCd(user.getMbrCualfCd());
        lectureSearch.setMbrNo(user.getMbrNo());
        lectureSearch.setCoNo(user.getPosCoNo());
        lectureSearch.setViewType("mentorMain");

        return lectureManagementService.mentorLectureSchdList(lectureSearch);
    }

    @RequestMapping("/main/ajax.monthInfo.do")
    @ResponseBody
    public List<Map<String, Object>> monthInfo(@RequestParam Map<String, Object> params) throws SchedulerException {
        return lectureManagementService.monthlyLectureInfo(params);
    }

    @RequestMapping("/main/ajax.dailyLectInfo.do")
    @ResponseBody
    public List<LectSchdInfo> dailyLectInfo(@RequestParam Map<String, Object> params) throws SchedulerException {
        return lectureManagementService.dailyLectureInfo(params);
    }
}
