package kr.go.career.mentor.controller;

import kr.or.career.mentor.annotation.Historic;
import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.domain.StatChgHistInfo;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.domain.UserSearch;
import kr.or.career.mentor.service.MentorManagementService;
import kr.or.career.mentor.service.StatChgHistService;
import kr.or.career.mentor.service.UserService;
import kr.or.career.mentor.util.JSONUtil;
import kr.or.career.mentor.util.SessionUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * kr.go.career.mentor.controller
 *      MemberMentorController
 *
 * 멘토회원 관리 Controller
 *
 * </pre>
 *
 * @author junypooh
 * @see
 * @since 2016-06-13 오후 3:51
 */

@Controller
@RequestMapping("/member/mentor")
@Slf4j
public class MemberMentorController {

    @Autowired
    private UserService userService;

    @Autowired
    private MentorManagementService mentorManagementService;

    @Autowired
    private StatChgHistService statChgHistService;

    @RequestMapping("/mentor/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000010")
    public List<User> listMemberMentorAjax(@Pageable UserSearch search) {

        if (CollectionUtils.isEmpty(search.getMbrCualfCds())) {
            search.setMbrCualfCds(MENTOR_CUALF_CDS);
        }
        if (CollectionUtils.isEmpty(search.getMbrStatCds())) {
            search.setMbrStatCds(MBR_STAT_CDS);
        }
        /*if (SessionUtils.hasRole("ROLE_ADMIN_GROUP")) {
            search.setGrpMbrNo(SessionUtils.getUser().getMbrNo());
        }*/

        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }

    /**
     * 멘토 상세 정보
     *
     * @param mbrNo
     * @param model
     */
    @RequestMapping("/mentor/view.do")
    @Historic(workId = "1000000011")
    public void mentorView(@RequestParam String mbrNo, Model model) {

        User user = userService.getUserByNo(mbrNo);
        user.setAgrees(userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의));
        user.setMbrJobInfo(userService.getMbrJobInfoByMbrNo(user.getMbrNo()));
        user.setMbrJobChrstcInfos(userService.getMbrJobChrstcInfos(user.getMbrNo()));
        user.setMbrpropicInfos(userService.listMbrProfPicInfoByMbrNo(mbrNo));
        user.setMbrProfInfo(userService.getMbrProfInfoBy(user.getMbrNo()));
        user.setMbrProfScrpInfos(userService.listMbrProfScrpInfos(user.getMbrNo(), null));

        // 재동의 관련 정보
        model.addAttribute("reAgrees", userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100942_재가입동의_재동의_));
        model.addAttribute("user", user);

        // 승인자 정보
        UserSearch userSearch = new UserSearch();
        userSearch.setMbrNo(mbrNo);
        userSearch.setLastStatYn("Y");
        userSearch.setStatChgClassCds(Arrays.asList(CodeConstants.CD101718_101719_회원가입요청상태, CodeConstants.CD101718_101751_회원탈퇴요청상태));
        List<StatChgHistInfo> statChgHistByMbrNo = statChgHistService.getStatChgHistByMbrNo(userSearch);
        if(statChgHistByMbrNo != null && !statChgHistByMbrNo.isEmpty()) {
            model.addAttribute("authInfo", statChgHistByMbrNo.get(statChgHistByMbrNo.size()-1));
        }
    }

    /**
     * 멘토 상세 정보
     *
     * @param mbrNo
     * @param model
     */
    @RequestMapping("/mentor/edit.do")
    public void mentorEdit(@RequestParam String mbrNo, Model model) {

        User user = userService.getUserByNo(mbrNo);
        user.setAgrees(userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의));
        user.setMbrJobInfo(userService.getMbrJobInfoByMbrNo(user.getMbrNo()));
        user.setMbrJobChrstcInfos(userService.getMbrJobChrstcInfos(user.getMbrNo()));
        user.setMbrpropicInfos(userService.listMbrProfPicInfoByMbrNo(mbrNo));
        user.setMbrProfInfo(userService.getMbrProfInfoBy(user.getMbrNo()));
        user.setMbrProfScrpInfos(userService.listMbrProfScrpInfos(user.getMbrNo(), null));

        model.addAttribute("user", user);
    }

    @RequestMapping("/mentor/editSubmit.do")
    @Historic(workId = "1000000012")
    public String mentorEditSubmit(User mentor, RedirectAttributes redirectAttributes) throws Exception {

        User loginUser = SessionUtils.getUser();
        mentor.setChgMbrNo(loginUser.getMbrNo());

        mentorManagementService.updateBelongMentorBase(mentor);
        mentorManagementService.updateBelongMentorJob(mentor);
        mentorManagementService.updateBelongMentorProfile(mentor);

        redirectAttributes.addAttribute("mbrNo", mentor.getMbrNo());
        return "redirect:/member/mentor/mentor/view.do";
    }

    @RequestMapping("/approval/ajax.list.do")
    @ResponseBody
    @Historic(workId = "1000000013")
    public List<User> listMemberApprovalAjax(@Pageable UserSearch search) {

        search.setMbrClassCds(MENTOR_CLASS_CDS);
        if (CollectionUtils.isEmpty(search.getStatChgClassCds())) {
            search.setStatChgClassCds(APPR_STAT_CHG_CLASS_CDS);
        }

        /*
        // 상태 검색 조건
        if (CollectionUtils.isNotEmpty(search.getStatChgRsltCds())) {
            String status = search.getStatChgRsltCds().get(0);

            if("REQ".equals(status)) { // 승인요청
                search.setStatChgRsltCds(APPR_STAT_REQ);
            } else if("OK".equals(status)) { // 승인완료
                search.setStatChgRsltCds(APPR_STAT_OK);
            } else if("NOK".equals(status)) { // 반려
                search.setStatChgRsltCds(APPR_STAT_NOK);
            }
        }
        */

        log.debug("[REQ] search: {}", search);

        return userService.listUserBy(search);
    }

    /**
     * 가입탈퇴 승인 상세 정보
     *
     * @param userSearch
     * @param model
     */
    @RequestMapping("/approval/view.do")
    @Historic(workId = "1000000014")
    public void approvalView(UserSearch userSearch, Model model) {

        User user = userService.getUserWithStatChgByNo(userSearch);
        user.setAgrees(userService.listMbrAgrInfo(user.getMbrNo(), CodeConstants.CD100939_100944_메일수집동의));
        user.setMbrJobInfo(userService.getMbrJobInfoByMbrNo(user.getMbrNo()));
        user.setMbrJobChrstcInfos(userService.getMbrJobChrstcInfos(user.getMbrNo()));
        user.setMbrpropicInfos(userService.listMbrProfPicInfoByMbrNo(user.getMbrNo()));
        user.setMbrProfInfo(userService.getMbrProfInfoBy(user.getMbrNo()));
        user.setMbrProfScrpInfos(userService.listMbrProfScrpInfos(user.getMbrNo(), null));

        model.addAttribute("user", user);
        model.addAttribute("statChgHist", JSONUtil.toJSON(statChgHistService.getStatChgHistByMbrNo(userSearch)));
    }

    //@formatter:off
    private static final List<String> MENTOR_CUALF_CDS = Arrays.asList(
            CodeConstants.CD100204_101502_소속멘토,
            CodeConstants.CD100204_101503_개인멘토);
    private static final List<String> MBR_STAT_CDS = Arrays.asList(
            CodeConstants.CD100861_100862_정상이용,
            CodeConstants.CD100861_101572_탈퇴요청);
    private static final List<String> MENTOR_CLASS_CDS = Arrays.asList(
            CodeConstants.CD100857_101505_멘토);


    private static final List<String> APPR_STAT_CHG_CLASS_CDS = Arrays.asList(
            CodeConstants.CD101718_101719_회원가입요청상태, // 회원가입요청
            CodeConstants.CD101718_101751_회원탈퇴요청상태);  // 회원탈퇴요청

    private static final List<String> APPR_STAT_REQ = Arrays.asList(
            CodeConstants.CD100861_101506_승인요청,
            CodeConstants.CD100861_101572_탈퇴요청
    );
    private static final List<String> APPR_STAT_OK = Arrays.asList(
            CodeConstants.CD100861_100862_정상이용,
            CodeConstants.CD100861_100864_탈퇴
    );
    private static final List<String> APPR_STAT_NOK = Arrays.asList(
            CodeConstants.CD100861_100863_이용중지,
            CodeConstants.CD100861_100862_정상이용
    );

    private static final List<String> APPR_MBR_STAT_IN_CDS = Arrays.asList(
            CodeConstants.CD100861_101506_승인요청, // 회원가입요청 최초
            CodeConstants.CD100861_100862_정상이용, // 회원가입요청 승인완료
            CodeConstants.CD100861_100863_이용중지); // 회원가입요청 반려
    private static final List<String> APPR_MBR_STAT_OUT_CDS = Arrays.asList(
            CodeConstants.CD100861_101572_탈퇴요청, // 회원탈퇴요청 최초
            CodeConstants.CD100861_100864_탈퇴, // 회원탈퇴요청 승인완료
            CodeConstants.CD100861_100862_정상이용);  // 회원탈퇴요청 반려
    //@formatter:on
}
