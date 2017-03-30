package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.domain.StatChgHistInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.StatChgHistService;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      StatChgHistController
 *
 * 상태 변경 이력 테이블 관련 Controller
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-07-13 오후 3:36
 */
@Controller
@RequestMapping("/stat/chg")
@Slf4j
public class StatChgHistController {

    @Autowired
    private StatChgHistService statChgHistService;

    @RequestMapping("/hist/submit.do")
    @Historic(workId = "1000000015")
    public String histSubmit(StatChgHistInfo statChgHistInfo, RedirectAttributes redirectAttributes) throws Exception {

        User loginUser = SessionUtils.getUser();
        statChgHistInfo.setRegMbrNo(loginUser.getMbrNo());

        statChgHistService.insertStatChgHistSubmit(statChgHistInfo);

        redirectAttributes.addAttribute("mbrNo", statChgHistInfo.getStatChgTargtMbrNo());
        redirectAttributes.addAttribute("statChgSer", statChgHistInfo.getStatChgSer());

        if("managerMentorApproval".equals(statChgHistInfo.getReferType())) {
            // 관리자 > 회원관리 > 멘토회원관리 > 가입탈퇴승인
            return "redirect:/member/mentor/approval/view.do";
        } else {
            return null;
        }
    }
}
