/* license */
package kr.or.career.mentor.controller;

import java.util.List;

import kr.or.career.mentor.annotation.Pageable;
import kr.or.career.mentor.domain.MbrItrstInfo;
import kr.or.career.mentor.domain.MyInterestDTO;
import kr.or.career.mentor.domain.User;
import kr.or.career.mentor.service.MyInterestService;

import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    MyInterestController.java
 *
 * 	class의 기능을 설명한다.
 *
 * </pre>
 * @since   2015. 9. 24. 오후 2:33:43
 * @author  technear
 * @see
 */
@Controller
@RequestMapping("myPage/myInterest")
public class MyInterestController {

    @Autowired
    private MyInterestService myInterestService;

    @RequestMapping("myInterest.do")
    public void myInterest(Authentication authentication, Model model) {

        User user = (User) authentication.getPrincipal();
        MbrItrstInfo mbrItrstInfo = new MbrItrstInfo();
        mbrItrstInfo.setPageable(true);
        mbrItrstInfo.setCurrentPageNo(1);
        mbrItrstInfo.setRecordCountPerPage(5);
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        model.addAttribute("interestLecture", myInterestService.listMyInterestLecture(mbrItrstInfo));
        model.addAttribute("interestMentor", myInterestService.listMyInterestMentor(mbrItrstInfo));

    }

    @RequestMapping("ajax.myInterestLecture.do")
    @ResponseBody
    public List<MyInterestDTO> myInterestLecture(@Pageable MbrItrstInfo mbrItrstInfo, Authentication authentication) {

        User user = (User) authentication.getPrincipal();
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        return myInterestService.listMyInterestLecture(mbrItrstInfo);

    }

    @RequestMapping("ajax.myInterestMentor.do")
    @ResponseBody
    public List<MyInterestDTO> myInterestMentor(@Pageable MbrItrstInfo mbrItrstInfo, Authentication authentication) {

        User user = (User) authentication.getPrincipal();
        mbrItrstInfo.setMbrNo(user.getMbrNo());

        return myInterestService.listMyInterestMentor(mbrItrstInfo);

    }

    /**
     * 나의 관심 목록 조회
     *
     * @param mbrItrstInfo
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.listInterest.do")
    @ResponseBody
    public List<MyInterestDTO> myClassroomTeacher(@Pageable MbrItrstInfo mbrItrstInfo, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();

        mbrItrstInfo.setMbrNo(user.getMbrNo());
        return myInterestService.listMyInterest(mbrItrstInfo);
    }

    /**
     * 나의 관심목록 삭제
     * @param mbrItrstInfo
     * @param authentication
     * @return
     * @throws SchedulerException
     */
    @RequestMapping("ajax.deleteMyInterest.do")
    @ResponseBody
    public int deleteMyInterest(@ModelAttribute MbrItrstInfo mbrItrstInfo, Authentication authentication) throws SchedulerException {
        User user = (User) authentication.getPrincipal();
        mbrItrstInfo.setMbrNo(user.getMbrNo());
        return myInterestService.deleteMyInterest(mbrItrstInfo);
    }

}
