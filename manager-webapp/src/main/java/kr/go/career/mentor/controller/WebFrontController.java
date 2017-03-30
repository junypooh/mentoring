package kr.go.career.mentor.controller;

import com.google.common.collect.Lists;
import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.BannerService;
import kr.or.career.mentor.service.FrontManageService;
import kr.or.career.mentor.service.JobService;
import kr.or.career.mentor.view.JSONResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.ListUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

import static kr.or.career.mentor.constant.CodeConstants.CD101641_101642_인기멘토;
import static kr.or.career.mentor.constant.CodeConstants.CD101641_101757_HOT멘토;

/**
 * Created by chaos on 2016. 7. 26..
 */
@Controller
@RequestMapping("/web/front")
@Slf4j
public class WebFrontController {

    @Autowired
    private BannerService bannerService;

    @Autowired
    private FrontManageService frontManageService;

    @Autowired
    private JobService jobService;

    @RequestMapping("/ajax.bnrList.do")
    @ResponseBody
    @Historic(workId = "1000000200")
    public List<BnrInfo> bnrInfoList(@RequestBody @Pageable BnrInfo bnrInfo) {
        return bannerService.listBanner(bnrInfo);
    }

    @RequestMapping(value={"/mentorBanner/imageBannerEdit.do","/mainBanner/imageBannerEdit.do"},method= RequestMethod.GET)
    public String editBannerInfo(@ModelAttribute BnrInfo bnrInfo,Model model) {
        if(bnrInfo.getBnrSer() != null)
            model.addAttribute("bnrInfo",bannerService.retrieveBanner(bnrInfo));
        return "web/front/banner/imageBannerEdit";
    }

    @RequestMapping(value = {"/mentorBanner/list.do","/mainBanner/list.do"},method= RequestMethod.GET)
    public String mainBannerInfo() {

        return "web/front/banner/imageBannerList";
    }

    @RequestMapping(value="/banner/edit.do",method= RequestMethod.GET)
    @Historic(workId = "1000000201")
    public void editBnrInfo(@ModelAttribute BnrInfo bnrInfo,Model model) {
        if(bnrInfo.getBnrSer() != null)
            model.addAttribute("bnrInfo",bannerService.retrieveBanner(bnrInfo));
    }

    @RequestMapping(value="/banner/save.do", method = RequestMethod.POST)
    @Historic(workId = "1000000202")
    public String save(BnrInfo bnrInfo, Authentication authentication) {
        User user = (User) authentication.getPrincipal();
        bnrInfo.setRegMbrNo(user.getMbrNo());
        if(bnrInfo.getBnrSer() == null){
            bannerService.insertBanner(bnrInfo);
        }else{
            bannerService.updateBanner(bnrInfo);
        }

        ServletRequestAttributes sr = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = sr.getRequest();

        String referer = request.getHeader("referer");
        String returnUrl;

        if(referer.equals("/web/front/banner/edit.do"))
            returnUrl = "redirect:/web/front/banner/list.do";
        else {
            if(CodeConstants.CD101637_101640_홍보배너.equals(bnrInfo.getBnrTypeCd()))
                returnUrl = "redirect:/web/front/mentorBanner/list.do?bannerType=101640";
            else
                returnUrl = "redirect:/web/front/mainBanner/list.do?bannerType=101639";
        }

        return returnUrl;
    }



    @RequestMapping("/ajax.popularLectures.do")
    @ResponseBody
    @Historic(workId = "1000000203")
    public List<RecommandInfo> listPopularLecture() {
        return frontManageService.listRecommandLecture();
    }

    @RequestMapping("/ajax.changeOrder.do")
    @ResponseBody
    public List<RecommandInfo> changeOrder(@RequestBody OrderChanger orderChanger){
        return frontManageService.changeOrder(orderChanger);
    }

    @RequestMapping("/ajax.changeBnrOrder.do")
    @ResponseBody
    public List<BnrInfo> changeBnrOrder(@RequestBody OrderChanger orderChanger){
        return bannerService.changeOrder(orderChanger);
    }

    @RequestMapping("/ajax.searchLectTimesInfoList.do")
    @ResponseBody
    public List<RecommandInfo> searchLectTimesInfoList(@RequestBody LectureSearch lectureSearch){
        return frontManageService.searchLectTimesInfoList(lectureSearch);
    }

    @RequestMapping("/ajax.deletePopularLectures.do")
    @ResponseBody
    @Historic(workId = "1000000204")
    public List<RecommandInfo> deletePopularLecture(@RequestBody List<OrderChanger> orderChangers){

        return frontManageService.deletePopularLecture(orderChangers);
    }

    @RequestMapping("/ajax.insertPopularLecture.do")
    @ResponseBody
    @Historic(workId = "1000000205")
    public List<RecommandInfo> insertPopularLecture(@RequestBody List<RecommandInfo> recommandInfos){

        frontManageService.insertRecommand(recommandInfos);
        return frontManageService.listRecommandLecture();
    }

    @RequestMapping("/ajax.popularMentors.do")
    @ResponseBody
    public List<RecommandInfo> listPopularMentors() {
        return frontManageService.listRecommandMentor(CD101641_101642_인기멘토);
    }

    @RequestMapping("/ajax.deletePopularMentors.do")
    @ResponseBody
    public List<RecommandInfo> deletePopularMentor(@RequestBody List<OrderChanger> orderChangers){

        return frontManageService.deletePopularMentor(orderChangers);
    }

    @RequestMapping("/ajax.insertPopularMentor.do")
    @ResponseBody
    public List<RecommandInfo> insertPopularMentor(@RequestBody List<RecommandInfo> recommandInfos){

        frontManageService.insertRecommand(recommandInfos);
        return frontManageService.listRecommandMentor(CD101641_101642_인기멘토);
    }

    @RequestMapping("/ajax.hotMentors.do")
    @ResponseBody
    @Historic(workId = "1000000206")
    public List<RecommandInfo> listHotMentors() {
        return frontManageService.listRecommandMentor(CD101641_101757_HOT멘토);
    }

    @RequestMapping("/ajax.deleteHotMentors.do")
    @ResponseBody
    @Historic(workId = "1000000207")
    public List<RecommandInfo> deleteHotMentors(@RequestBody List<OrderChanger> orderChangers){

        return frontManageService.deletePopularMentor(orderChangers);
    }

    @RequestMapping("/ajax.insertHotMentor.do")
    @ResponseBody
    @Historic(workId = "1000000208")
    public List<RecommandInfo> insertHotMentor(@RequestBody List<RecommandInfo> recommandInfos){

        frontManageService.insertRecommand(recommandInfos);
        return frontManageService.listRecommandMentor(CD101641_101757_HOT멘토);
    }

    @RequestMapping("/ajax.searchMentorInfoList.do")
    @ResponseBody
    public List<RecommandInfo> searchMentorInfoList(@RequestBody MentorSearch search){
        return frontManageService.searchMentorInfoList(search);
    }

    @RequestMapping("/ajax.recommandJobs.do")
    @ResponseBody
    public List<RecommandInfo> listRecommandJob() {
        return frontManageService.listRecommandJob();
    }

    @RequestMapping("/insertRcommandJob.do")
    public String insertRcommandJob(RecommandInfo recommandInfo){

        List<RecommandInfo> recommandInfos = Lists.newArrayList();
        recommandInfos.add(recommandInfo);

        frontManageService.insertRecommand(recommandInfos);
        return "redirect:/web/front/recommJob/list.do";
    }

    @RequestMapping("ajax.deleteRecommandJobs.do")
    @ResponseBody
    @Historic(workId = "1000000408")
    public List<RecommandInfo> deleteRecommandJobs(@RequestBody List<OrderChanger> orderChangers){

        return frontManageService.deleteRecommandJob(orderChangers);
    }


    @RequestMapping("ajax.deleteBnrInfo.do")
    @ResponseBody
    public List<BnrInfo> deleteBnrInfo(@RequestBody List<OrderChanger> orderChangers){

        return bannerService.deleteBnrInfo(orderChangers);
    }

    @RequestMapping("ajax.deleteBanner.do")
    @ResponseBody
    public JSONResponse deleteBanner(@RequestBody List<OrderChanger> orderChangers){

        int result = bannerService.deleteBanner(orderChangers);

        if(result > 0){
            return JSONResponse.success("");
        }else{
            return JSONResponse.failure("");
        }

    }

    @RequestMapping("/ajax.listJob.do")
    @ResponseBody
    public List<RecommandInfo> listJob(@RequestBody MentorSearch search){

        return frontManageService.selectRecommandTargetJob(search);
    }

    @RequestMapping("/ajax.listMentorByJobNo.do")
    @ResponseBody
    public List<RecommandInfo> listMentorByJobNo(@RequestBody MentorSearch search){

        return frontManageService.listMentorByJobNo(search);
    }

}
