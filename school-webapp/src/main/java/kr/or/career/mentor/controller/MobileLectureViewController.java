/* ntels */
package kr.or.career.mentor.controller;

import kr.or.career.mentor.constant.CodeConstants;
import kr.or.career.mentor.constant.Constants;
import kr.or.career.mentor.dao.LectureInfomationMapper;
import kr.or.career.mentor.domain.*;
import kr.or.career.mentor.service.LectureManagementService;
import kr.or.career.mentor.util.EgovProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;
/**
 * <pre>
 * kr.or.career.mentor.controller
 *    LectureViewController
 *
 * 수업상세 화면의 Controller
 *
 * </pre>
 *
 * @author yujiy
 * @see
 * @since 2015-09-30 오후 3:10
 */
@Controller
@RequestMapping("mobile")
public class MobileLectureViewController {
	
	public static final Logger log = LoggerFactory.getLogger(MobileLectureViewController.class);
    @Autowired
    LectureManagementService lectureManagementService;

    @Autowired
    private LectureInfomationMapper lectureInfomationMapper;

    /**
     * <pre>
     *     수업상세화면 조회
     * </pre>
     * @param model
     * @param lectureSearch
     * @throws Exception
     */
    @RequestMapping(value = {"lectureView.do","myLessonView.do"}, method = RequestMethod.GET)
    public void onLoadlectureView(Model model, LectureSearch lectureSearch) throws Exception{

        //수업정보 조회
        LectInfo lectureInfo = lectureManagementService.lectureInfo(lectureSearch);

        //수업 차수 및 회차 정보 조회
        List<LectSchdInfo> lectSchdInfo = lectureInfomationMapper.lectureSchdList(lectureSearch);


        model.addAttribute("lectInfo", lectureInfo);    //수업정보
        model.addAttribute("lectureSearch", lectureSearch);    //수업정보

        model.addAttribute("lectSchdInfo", lectSchdInfo.get(0));    //수업 차수&회차 정보
        model.addAttribute("tommsPreFix", EgovProperties.getProperty("TOMMS_PREFIX"));
    }
}

