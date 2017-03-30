/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.domain.LectInfo;
import kr.or.career.mentor.domain.LectSchdInfo;
import kr.or.career.mentor.service.LectureManagementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * <pre>
 * kr.or.career.mentor.controller
 *    TabLectureInfoController
 *
 * 수업상세 화면의 수업소개 탭페이지 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-10-02 오후 2:34
 */
@Controller
@RequestMapping("lecture/lectureTotal")
public class TabLectureInfoController {

    @Autowired
    LectureManagementService lectureManagementService;

    /**
     * <pre>
     *     수업상세화면 수업소개 탭페이지 조회
     * </pre>
     * @param model
     * @param lectSer
     * @return
     */
    @RequestMapping(value = "tabLectureInfo.do", method = RequestMethod.GET)
    public String onLoadTabLectureInfo(Model model, @RequestParam int lectSer, @RequestParam int lectTims) throws Exception{
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(lectSer);
        lectSchdInfo.setLectTims(lectTims);

        LectInfo resultLectInfo = lectureManagementService.retireveLectureInfo(lectSchdInfo);

        model.addAttribute("lectInfo", resultLectInfo);

        return "lecture/lectureTotal/tabLectureInfo";
    }

    /**
     * <pre>
     *     수업상세화면 수업소개 탭페이지 조회
     * </pre>
     * @param model
     * @param lectSer
     * @return
     */
    @RequestMapping(value = "tabLectureInfoForMobile.do", method = RequestMethod.GET)
    public String onLoadTabLectureInfoForMobile(Model model, @RequestParam int lectSer, @RequestParam int lectTims) throws Exception{
        LectSchdInfo lectSchdInfo = new LectSchdInfo();
        lectSchdInfo.setLectSer(lectSer);
        lectSchdInfo.setLectTims(lectTims);

        LectInfo resultLectInfo = lectureManagementService.retireveLectureInfo(lectSchdInfo);

        model.addAttribute("lectInfo", resultLectInfo);

        return "lecture/lectureTotal/tabLectureInfoForMobile";
    }
}

