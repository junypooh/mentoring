/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.dao.CoInfoMapper;
import kr.or.career.mentor.dao.MbrJobChrstcInfoMapper;
import kr.or.career.mentor.dao.MbrProfPicInfoMapper;
import kr.or.career.mentor.dao.MbrProfScrpInfoMapper;
import kr.or.career.mentor.dao.MentorMapper;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;


/**
 * <pre> kr.or.career.mentor.controller TabLectureInfoController
 *
 * 수업상세 화면의 멘토소개 탭페이지 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-02 오후 2:34
 */
@Controller
@RequestMapping("lecture/lectureTotal")
public class TabMentorInfoController {

    @Autowired
    private MentorMapper mentorMapper;
    @Autowired
    private MbrProfPicInfoMapper mbrProfPicInfoMapper;
    @Autowired
    private MbrProfScrpInfoMapper mbrProfScrpInfoMapper;
    @Autowired
    private MbrJobChrstcInfoMapper mbrJobChrstcInfoMapper;
    @Autowired
    private CoInfoMapper coInfoMapper;
    @Autowired
    private UserService userService;


    /**
     * <pre> 수업상세화면 멘토소개 탭페이지 조회 </pre>
     *
     * @param model
     * @param lectSer
     * @return
     */
    @RequestMapping(value = "tabMentorInfo.do", method = RequestMethod.GET)
    public String onLoadTabLectureInfo(Model model, @RequestParam String mbrNo) throws Exception {
        model.addAttribute("mentor", mentorMapper.getMentorInfoBy(mbrNo));
        model.addAttribute("listMbrJobChrstcInfos", mbrJobChrstcInfoMapper.listMbrJobChrstcInfoBy(mbrNo));
        model.addAttribute("listMbrProfPicInfo", mbrProfPicInfoMapper.listMbrProfPicInfoBy(mbrNo));
        model.addAttribute("listMbrProfScrpInfo", mbrProfScrpInfoMapper.listMbrProfScrpInfoBy(mbrNo, null));

        User user = userService.getUserByNo(mbrNo);
        if (CodeConstants.CD100204_101502_소속멘토.equals(user.getMbrCualfCd())) {
            User supUser = userService.getSupUserByNo(user.getMbrNo());
            model.addAttribute("corporationUser", user);
            model.addAttribute("organizationUser", supUser);
        }
        else {
            model.addAttribute("organizationUser", user);
        }

        return "lecture/lectureTotal/tabMentorInfo";
    }
}
