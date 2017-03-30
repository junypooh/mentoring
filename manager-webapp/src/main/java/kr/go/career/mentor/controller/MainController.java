package kr.go.career.mentor.controller;

import kr.or.career.mentor.domain.GlobalMnuInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.MnuInfoService;
import kr.or.career.mentor.service.StatisticsService;
import kr.or.career.mentor.util.SessionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
public class MainController {

    @Autowired
    private StatisticsService statisticsService;

    @Autowired
    private MnuInfoService mnuInfoService;

    @RequestMapping("index")
    public String main(Model model, Authentication authentication) {
        if(authentication == null){
              return "redirect:login.do";
        }

        if(true) {

            // 로그인한 계정 권한에 맞는 첫번째 메뉴로 이동
            User user = (User) authentication.getPrincipal();

            List<GlobalMnuInfo> globalMnuInfo = mnuInfoService.getGlobalMnuInfo(user.getAuthCd(), mnuInfoService.getGlobalMnuInfo(user.getAuthCd()).get(0).getMnuId());

            String linkUrl = globalMnuInfo.get(0).getLinkUrl();
            if(StringUtils.isEmpty(linkUrl)) {
                List<GlobalMnuInfo> subMnuInfos = globalMnuInfo.get(0).getGlobalSubMnuInfos();
                linkUrl = subMnuInfos.get(0).getLinkUrl();
            }

            return "redirect:" + linkUrl;
// 개발 초기 임시 페이지 이동
//            return "redirect:/member/public/general/list.do";
        }

        //최초 로그인시에 약관동의 화면으로 이동
        User sessionUser = (User) authentication.getPrincipal();
        if (SessionUtils.hasRole("MENTOR_COP_MENTOR") && StringUtils.isBlank(sessionUser.getLastLoginDtm())) {
            return "redirect:/myPage/myInfo/agrees.do";
        }

        if (SessionUtils.hasAnyRole("ROLE_ADMIN_LEVEL3","ROLE_ADMIN_LEVEL4","ROLE_ADMIN_LEVEL5")) {
            return "redirect:/main/banner/bannerList.do";
        }else if (SessionUtils.hasRole("ROLE_ADMIN_LEVEL6")) {
            return "redirect:/usage/notice/noticeList.do";
        }

        //비밀번호 변경한지 3개월이 지났으면 비밀번호 변경 페이지로
        Calendar c = Calendar.getInstance();
        c.add(Calendar.MONTH, -3);
        Date dt = c.getTime();
        Date pwdDate = sessionUser.getPwdChgDtm();
        if( pwdDate != null && pwdDate.compareTo(dt) < 0){
            return "redirect:/myPage/myInfo/pwChange.do";
        }

        model.addAttribute("allocateGroupCnt", statisticsService.allocateGroupCnt());
        model.addAttribute("lectureStatusCnt", statisticsService.lectureStatusCnt(sessionUser));
        model.addAttribute("approvalRequestCnt", statisticsService.approvalRequestCnt());
        model.addAttribute("articleCnt", statisticsService.articleCnt());
        model.addAttribute("memberCnt", statisticsService.memberCnt());
        model.addAttribute("schoolCnt", statisticsService.schoolCnt());
        return null;
    }
}
